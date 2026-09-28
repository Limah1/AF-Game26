extends Node2D

const BOY_BATH_BODY = preload("res://assets/SpritesV4/MiniGameBanho/boy-banho-m1.png")
const GIRL_BATH_BODY = preload("res://assets/SpritesV4/MiniGameBanho/girl-banho-m1.png")
const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")

export(Vector2) var body_position = Vector2(-16.704, -1550.32)
export(Vector2) var body_scale = Vector2(0.55, 0.55)
export(Vector2) var water_particles_offset = Vector2(0, -600)
export(Vector2) var head_position = Vector2(0, -565)
export(Vector2) var head_scale = Vector2.ONE
export(Vector2) var bath_cap_position = Vector2(0, -195)
export(Vector2) var bath_cap_scale = Vector2.ONE

var bathroom_reference = null

var molhado = 0
var ensaboado = 0
var enxaguar = 0
var enxugado = 0

var is_drying = false
var soap_contact = false

var direction = null
var pressing = false

var status_button: bool = false

var cd = 0.5
var wet_timer = 0
var soap_timer = 0
var rinse_timer = 0
var dry_timer = 0

onready var chuveiro = $"Ativo 6/Chuveiro"
onready var character_body_area = $"boy-banho-1/body_area"
onready var character_body_shape = $"boy-banho-1/body_area/CollisionShape2D"
onready var character_head = $"boy-banho-1/Head"
onready var bath_cap = $"boy-banho-1/Head/BathCap"
onready var sabonete = $Sabonete
onready var sabonete_shape = $"Sabonete/CollisionShape2D"
onready var bubbles = $"boy-banho-1/bubbles"

onready var water_circles = $"boy-banho-1/Molhado"
onready var foam = $"boy-banho-1/espuma"

var personagem_sprite

func _ready() -> void:
	# Allow direct scene testing as well as Bathroom.gd's explicit start(ref).
	start(null)

func start(ref):
	bathroom_reference = ref
	personagem_sprite = $"boy-banho-1"
	status_button = false
	chuveiro.emitting = false
	soap_contact = false
	bubbles.emitting = false
	$shower_sound.stop()
	$"Ativo 6/TurnOn".visible = true
	$"Ativo 6/TurnOff".visible = false
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	var skin_value = CharacterController.cor_pele if CharacterController.cor_pele != "" else NewCharData.cor_pele
	var skin_color = Color(skin_value) if skin_value != "" else Color.white
	personagem_sprite.texture = BOY_BATH_BODY if gender == "boy" else GIRL_BATH_BODY
	personagem_sprite.position = body_position
	personagem_sprite.scale = body_scale
	chuveiro.global_position = personagem_sprite.global_position + water_particles_offset
	character_head.texture = CharacterController.get_head_texture_for(gender, hair)
	character_head.position = head_position
	character_head.scale = head_scale
	bath_cap.position = bath_cap_position
	bath_cap.scale = bath_cap_scale
	character_body_area.collision_mask = 4

	var body_material = personagem_sprite.material.duplicate() as ShaderMaterial
	body_material.set_shader_param("nova_cor_pele", skin_color)
	personagem_sprite.material = body_material
	var head_material = ShaderMaterial.new()
	head_material.shader = LEGACY_HEAD_SHADER
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", skin_color)
	character_head.material = head_material
	

func _on_body_area_body_entered(body):
	if(body.name == "Sabonete"):
		_set_soap_contact(true)
	
	if(body.name == "Toalha"):
		is_drying = true
		$towel_sound.play()

func _on_body_area_body_exited(body):
	if(body.name == "Sabonete"):
		_set_soap_contact(false)
	
	if(body.name == "Toalha"):
		is_drying = false
		$towel_sound.stop()

func _on_SwipeArea_input_event(viewport, event, shape_idx):
	direction = null
	if(cd > 0):
		pressing = false
		return
	
	if event is InputEventMouseButton or event is InputEventScreenTouch and event.is_pressed():
		pressing = true
	elif event is InputEventMouseButton or event is InputEventScreenTouch and !event.is_pressed():
		pressing = false
	
	if event is InputEventScreenDrag and pressing and event.is_pressed():
		get_relative_direction(event.relative)
		cd = 0.5
	elif event is InputEventMouseMotion and pressing:
		get_relative_direction(event.relative)
		cd = 0.5

func get_relative_direction(relative):
	var relative_x = abs(relative.x)
	var relative_y = abs(relative.y)
	
	if(relative_x < relative_y):
		var aux = relative.y
		if(aux > 2):
			aumentar_chuveiro()
		elif(aux < 2):
			diminuir_chuveiro()

func aumentar_chuveiro():
	if status_button:
		return
	_set_shower_enabled(true)

func diminuir_chuveiro():
	if not status_button:
		return
	_set_shower_enabled(false)

func _set_shower_enabled(enabled: bool) -> void:
	# Keep gameplay state independent from Particles2D's runtime emitter flag.
	# This also makes the button reliable when the renderer has not initialized
	# the particle system yet.
	status_button = enabled
	chuveiro.emitting = enabled
	if enabled:
		chuveiro.restart()
		$"Ativo 6/AnimationPlayer".play("open_faucet")
		$faucet_open_sound.play()
		$shower_sound.play()
	else:
		$"Ativo 6/AnimationPlayer".play("close_faucet")
		$faucet_close_sound.play()
		$shower_sound.stop()
	$"Ativo 6/TurnOn".visible = not enabled
	$"Ativo 6/TurnOff".visible = enabled

func _process(delta):
	cd -= delta
	_update_soap_contact()

	if(status_button and ensaboado <= 0):
		wet_timer += delta

		molhado += (20 * delta)

		if(wet_timer >= 1):
			wet_timer = 0
			if(water_circles.modulate.a < 1):
				water_circles.modulate.a = water_circles.modulate.a + 0.2

	if(soap_contact):
		soap_timer += delta

		ensaboado += (20 * delta)

		if(soap_timer >= 1):
			soap_timer = 0
			if(foam.modulate.a < 1):
				foam.modulate.a = foam.modulate.a + 0.2

	if(status_button and ensaboado != 0):
		rinse_timer += delta

		enxaguar += (20 * delta)

		if(rinse_timer >= 1):
			rinse_timer = 0
			foam.modulate.a = foam.modulate.a - 0.2

	if(is_drying):
		dry_timer += delta

		enxugado += (20 * delta)

		if(dry_timer >= 1):
			dry_timer = 0
			water_circles.modulate.a = water_circles.modulate.a - 0.2

func _update_soap_contact() -> void:
	# Check the transformed shapes so soap contact remains reliable even when
	# Area2D body signals are delayed or unavailable.
	if sabonete == null or not sabonete.follow:
		_set_soap_contact(false)
		return

	_set_soap_contact(_get_shape_rect(character_body_shape).intersects(
		_get_shape_rect(sabonete_shape)
	))

func _set_soap_contact(contacting: bool) -> void:
	if soap_contact == contacting:
		return

	soap_contact = contacting
	bubbles.emitting = contacting
	if contacting:
		bubbles.restart()

func _get_shape_rect(collision_shape: CollisionShape2D) -> Rect2:
	if collision_shape == null or collision_shape.shape == null:
		return Rect2()

	var rectangle_shape = collision_shape.shape as RectangleShape2D
	if rectangle_shape == null:
		return Rect2()

	var global_shape_scale = collision_shape.global_scale
	var size = rectangle_shape.extents * 2.0
	size.x *= abs(global_shape_scale.x)
	size.y *= abs(global_shape_scale.y)
	return Rect2(collision_shape.global_position - size / 2.0, size)




func _on_TurnOn_pressed():
	_set_shower_enabled(not status_button)
	

