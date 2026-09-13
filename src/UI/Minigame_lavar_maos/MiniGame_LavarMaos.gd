extends CanvasLayer

const BATHROOM_SCENE = "res://src/UI/Rooms/Bathroom.tscn"

var bathroom_reference = null
var water_on = false
var soap_used = false
var washed_hands = [false, false]
var finished = false

onready var status_label = $StatusLabel
onready var faucet_button = $FaucetButton
onready var soap_button = $SoapButton
onready var left_hand = $LeftHand
onready var right_hand = $RightHand


func _ready() -> void:
	start(null)


func start(ref) -> void:
	bathroom_reference = ref
	water_on = false
	soap_used = false
	washed_hands = [false, false]
	finished = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_update_interface()


func _on_faucet_pressed() -> void:
	if finished:
		return
	water_on = !water_on
	_update_interface()


func _on_soap_pressed() -> void:
	if finished:
		return
	soap_used = true
	_update_interface()


func _on_hand_pressed(hand_index: int) -> void:
	if finished:
		return
	if not water_on:
		status_label.text = "Abra a torneira antes de lavar as mãos."
		return
	if not soap_used:
		status_label.text = "Pegue o sabão e esfregue as mãos."
		return

	washed_hands[hand_index] = true
	_update_interface()


func _on_towel_pressed() -> void:
	if finished:
		return
	if not washed_hands[0] or not washed_hands[1]:
		status_label.text = "Lave as duas mãos antes de usar a toalha."
		return

	finished = true
	water_on = false
	status_label.text = "Mãos limpas! Seque-as com a toalha."
	$TowelButton.disabled = true
	yield(get_tree().create_timer(0.8), "timeout")
	_finish_minigame()


func _on_exit_pressed() -> void:
	if finished:
		return
	finished = true
	_finish_minigame()


func _update_interface() -> void:
	if water_on:
		faucet_button.text = "TORNEIRA\nFECHAR ÁGUA"
		$WaterLabel.text = "ÁGUA ABERTA"
		$WaterLabel.modulate = Color(0.12, 0.48, 0.82, 1)
	else:
		faucet_button.text = "TORNEIRA\nABRIR ÁGUA"
		$WaterLabel.text = "ÁGUA FECHADA"
		$WaterLabel.modulate = Color(0.35, 0.40, 0.43, 1)

	if soap_used:
		soap_button.text = "SABÃO\nUSADO ✓"
		soap_button.modulate = Color(0.76, 0.96, 0.48, 1)
	else:
		soap_button.text = "SABÃO\nPEGAR"
		soap_button.modulate = Color.white

	left_hand.text = "MÃO ESQUERDA"
	right_hand.text = "MÃO DIREITA"
	left_hand.modulate = Color(0.62, 0.83, 0.94, 1) if washed_hands[0] else Color.white
	right_hand.modulate = Color(0.62, 0.83, 0.94, 1) if washed_hands[1] else Color.white

	if washed_hands[0] and washed_hands[1]:
		status_label.text = "Muito bem! Toque na toalha para secar as mãos."
	elif soap_used and water_on:
		status_label.text = "Agora toque em cada mão para esfregar e enxaguar."
	elif soap_used:
		status_label.text = "Sabão aplicado. Abra a torneira para enxaguar."
	elif water_on:
		status_label.text = "Água aberta. Pegue o sabão."
	else:
		status_label.text = "Abra a torneira, pegue o sabão e lave as duas mãos."


func _finish_minigame() -> void:
	if bathroom_reference != null and is_instance_valid(bathroom_reference):
		if bathroom_reference.has_method("finish_washing_hands"):
			bathroom_reference.finish_washing_hands()
		queue_free()
		return

	# Permite abrir a cena diretamente para testar o minigame.
	if get_tree().current_scene == self:
		get_tree().change_scene(BATHROOM_SCENE)
	else:
		queue_free()
