extends CanvasLayer

const MAIN_SCENE = "res://src/MainScreen.tscn"
const WATER = 0
const SOAP = 1
const RINSE = 2
const TOWEL = 3

var bathroom_reference = null
var phase = WATER
var water_on = false
var done_hands = [false, false]
var finished = false
var dragging = false
var drag_kind = -1
var drag_touch_index = -1
var faucet_pulse_time = 0.0
var towel_hand_index = -1
var towel_hold_time = 0.0

onready var hands = [$LeftHand, $RightHand]
onready var water_particles = [$LeftHand/WaterParticles, $RightHand/WaterParticles]
onready var foam_particles = [$LeftHand/FoamParticles, $RightHand/FoamParticles]
onready var foam_overlays = [$LeftHand/FoamOverlay, $RightHand/FoamOverlay]
onready var drag_preview = $DragPreview

func _ready() -> void:
	$SoapButton.connect("gui_input", self, "_on_source_input", [SOAP])
	$TowelButton.connect("gui_input", self, "_on_source_input", [TOWEL])
	start(null)

func start(ref) -> void:
	bathroom_reference = ref
	phase = WATER
	water_on = false
	done_hands = [false, false]
	finished = false
	dragging = false
	towel_hand_index = -1
	towel_hold_time = 0.0
	faucet_pulse_time = 0.0
	drag_preview.visible = false
	$DragPreview/SoapImage.visible = false
	$DragPreview/TowelImage.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color(0.92, 0.72, 0.58)
	for hand in hands:
		var sprite = hand.get_node("HandSprite")
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_param("skin_color", skin)
	for particles in water_particles + foam_particles:
		particles.emitting = false
		particles.visible = true
	for overlay in foam_overlays:
		overlay.visible = false
	$FaucetWater.emitting = false
	$WetHandsTimer.stop()
	$CompletionDelay.stop()
	$CompletionPanel.visible = false
	_update_interface()

func _process(delta: float) -> void:
	if (phase == WATER or phase == RINSE) and not finished:
		faucet_pulse_time += delta
		var pulse = 1.0 + 0.08 * sin(faucet_pulse_time * 5.0)
		$FaucetButton.rect_scale = Vector2(pulse, pulse)
	if dragging and phase == TOWEL and towel_hand_index >= 0 and not finished:
		towel_hold_time += delta
		if towel_hold_time >= 2.0:
			var dried_hand = towel_hand_index
			towel_hand_index = -1
			towel_hold_time = 0.0
			_apply_to_hand(dried_hand)

func _on_faucet_pressed() -> void:
	if finished or (phase != WATER and phase != RINSE) or water_on:
		return
	water_on = true
	$FaucetWater.emitting = true
	$WetHandsTimer.wait_time = 4.0 if phase == RINSE else 0.75
	$WetHandsTimer.start()
	_update_interface()

func _on_wet_hands_timer_timeout() -> void:
	if finished or (phase != WATER and phase != RINSE):
		return
	if phase == RINSE:
		for index in range(hands.size()):
			foam_particles[index].emitting = false
			foam_particles[index].visible = false
			foam_overlays[index].visible = false
			water_particles[index].visible = true
	for particles in water_particles:
		particles.emitting = true
	water_on = false
	$FaucetWater.emitting = false
	phase = SOAP if phase == WATER else TOWEL
	_update_interface()

func _on_source_input(event: InputEvent, kind: int) -> void:
	if finished or dragging or kind != phase:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		_begin_drag(kind, get_viewport().get_mouse_position(), -1)
	elif event is InputEventScreenTouch and event.pressed:
		var source = $SoapButton if kind == SOAP else $TowelButton
		_begin_drag(kind, source.rect_global_position + event.position, event.index)

func _begin_drag(kind: int, position: Vector2, touch_index: int) -> void:
	dragging = true
	drag_kind = kind
	drag_touch_index = touch_index
	_move_preview(position)
	drag_preview.visible = true
	$DragPreview/SoapImage.visible = kind == SOAP
	$DragPreview/TowelImage.visible = kind == TOWEL
	_update_towel_hover(position)

func _input(event: InputEvent) -> void:
	if not dragging:
		return
	if drag_touch_index == -1:
		if event is InputEventMouseMotion:
			_move_preview(event.position)
			_update_soap_hover(event.position)
			_update_towel_hover(event.position)
		elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
			_finish_drag(event.position)
	elif event is InputEventScreenDrag and event.index == drag_touch_index:
		_move_preview(event.position)
		_update_soap_hover(event.position)
		_update_towel_hover(event.position)
	elif event is InputEventScreenTouch and event.index == drag_touch_index and not event.pressed:
		_finish_drag(event.position)

func _move_preview(position: Vector2) -> void:
	drag_preview.rect_position = position - drag_preview.rect_size * 0.5

func _finish_drag(position: Vector2) -> void:
	dragging = false
	drag_preview.visible = false
	towel_hand_index = -1
	towel_hold_time = 0.0
	_update_soap_hover(Vector2(-1, -1))
	if drag_kind == TOWEL:
		if finished:
			$CompletionDelay.start()
		return
	for index in range(hands.size()):
		if hands[index].get_global_rect().has_point(position):
			_apply_to_hand(index)
			break

func _update_soap_hover(position: Vector2) -> void:
	if drag_kind != SOAP:
		return
	for index in range(hands.size()):
		var over_hand = dragging and phase == SOAP and hands[index].get_global_rect().has_point(position)
		foam_particles[index].emitting = done_hands[index] or over_hand
		water_particles[index].emitting = not done_hands[index] and not over_hand

func _update_towel_hover(position: Vector2) -> void:
	if drag_kind != TOWEL:
		return
	var hovered_hand = -1
	if dragging and phase == TOWEL:
		for index in range(hands.size()):
			if not done_hands[index] and hands[index].get_global_rect().has_point(position):
				hovered_hand = index
				break
	if hovered_hand != towel_hand_index:
		towel_hand_index = hovered_hand
		towel_hold_time = 0.0

func _apply_to_hand(index: int) -> void:
	if finished or drag_kind != phase or done_hands[index]:
		return
	done_hands[index] = true
	if phase == SOAP:
		water_particles[index].emitting = false
		water_particles[index].visible = false
		foam_particles[index].emitting = true
		foam_overlays[index].visible = true
	else:
		water_particles[index].emitting = false
		foam_particles[index].emitting = false
		water_particles[index].visible = false
		foam_particles[index].visible = false
		foam_overlays[index].visible = false
	if done_hands[0] and done_hands[1]:
		if phase == TOWEL:
			_complete()
			return
		phase += 1
		done_hands = [false, false]
	_update_interface()

func _update_interface() -> void:
	$WaterLabel.text = "ÁGUA ABERTA" if water_on else "ÁGUA FECHADA"
	$SoapButton.disabled = phase != SOAP
	$TowelButton.disabled = phase != TOWEL
	$SoapButton.modulate = Color.white if phase == SOAP else Color(1, 1, 1, 0.45)
	$TowelButton.modulate = Color.white if phase == TOWEL else Color(1, 1, 1, 0.45)
	$FaucetButton.disabled = phase != WATER and phase != RINSE
	if phase != WATER and phase != RINSE:
		$FaucetButton.rect_scale = Vector2.ONE
	$InstructionLabel.text = ["1/4 MOLHAR AS MÃOS", "2/4 PASSAR SABÃO", "3/4 ENXAGUAR AS MÃOS", "4/4 SECAR COM A TOALHA"][phase]
	var count = int(done_hands[0]) + int(done_hands[1])
	$StatusLabel.text = "%d/2 mãos prontas nesta etapa" % count if count > 0 else ["Abra a torneira para molhar as mãos", "Arraste o sabão", "Abra a torneira para tirar o sabão", "Segure a toalha por 2 segundos em cada mão"][phase]
	$SoapCaption.text = "2. Passe sabão"
	$TowelCaption.text = "4. Seque as mãos"
	$StageProgress.value = phase
	$StageProgressLabel.text = "Molhar: %s  |  Sabão: %s  |  Enxágue: %s  |  Secar: pendente" % [
		"OK" if phase >= SOAP else "pendente",
		"OK" if phase >= RINSE else "pendente",
		"OK" if phase >= TOWEL else "pendente"
	]
	for index in range(hands.size()):
		hands[index].modulate = Color(0.83, 1, 0.83, 1) if done_hands[index] else Color.white

func _complete() -> void:
	finished = true
	$StageProgress.value = 4
	$StageProgressLabel.text = "Molhar: OK  |  Sabão: OK  |  Enxágue: OK  |  Secar: OK"
	$StatusLabel.text = "Mãos limpas e secas!"

func _on_completion_delay_timeout() -> void:
	$CompletionPanel.visible = true

func _on_replay_pressed() -> void:
	if finished:
		start(bathroom_reference)

func _on_return_to_bathroom_pressed() -> void:
	if finished:
		_finish_minigame()

func _on_exit_pressed() -> void:
	if finished:
		return
	finished = true
	_finish_minigame()

func _finish_minigame() -> void:
	if bathroom_reference != null and is_instance_valid(bathroom_reference):
		if bathroom_reference.has_method("finish_washing_hands"):
			bathroom_reference.finish_washing_hands()
		queue_free()
		return
	if get_tree().current_scene == self:
		AnimationController.status = "Bathroom"
		get_tree().change_scene(MAIN_SCENE)
	else:
		queue_free()
