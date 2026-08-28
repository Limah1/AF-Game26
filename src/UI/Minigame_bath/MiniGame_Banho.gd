extends Node2D

var bathroom_reference = null

var molhado = 0
var ensaboado = 0
var enxaguar = 0
var enxugado = 0

var is_drying = false

var direction = null
var pressing = false

var status_button: bool = false

var cd = 0.5
var wet_timer = 0
var soap_timer = 0
var rinse_timer = 0
var dry_timer = 0

onready var chuveiro = $"Ativo 6/Chuveiro"
onready var bath_character_rig = $BathCharacterRig
onready var bubbles = $"boy-banho-1/bubbles"

onready var water_circles = $"boy-banho-1/Molhado"
onready var foam = $"boy-banho-1/espuma"

# variaveis p shaders,
var personagem_sprite
var cor_pele
var roupa
var cor_roupa_cima
var cor_roupa_baixo

func _ready() -> void:
	# Allow direct scene testing as well as Bathroom.gd's explicit start(ref).
	start(null)

func start(ref):
	bathroom_reference = ref
	personagem_sprite = $"boy-banho-1"
	status_button = false
	chuveiro.emitting = false
	$shower_sound.stop()
	$"Ativo 6/TurnOn".visible = true
	$"Ativo 6/TurnOff".visible = false

	# The bath outfit is scoped to this minigame. Keep the legacy body node as
	# the collision/effects parent, but render the modular rig in its place.
	if bath_character_rig != null:
		bath_character_rig.position = personagem_sprite.position
		# Keep the 3x scale authored on BathCharacterRig in MiniGame_Banho.tscn.
		# The legacy sprite's 0.55 scale is only for its old full-body texture.
		bath_character_rig.rotation = personagem_sprite.rotation
		bath_character_rig.z_index = personagem_sprite.z_index
		bath_character_rig.visible = true
		bath_character_rig.set_state(0)
		if bath_character_rig.has_method("set_appearance_variant"):
			bath_character_rig.set_appearance_variant("bath")
		elif ModularCharacterData.has_method("apply_to_rig"):
			ModularCharacterData.apply_to_rig(bath_character_rig, "bath")
		# Keep legacy effects and Area2D alive, but remove its old body texture.
		personagem_sprite.texture = null
	else:
		# Safe fallback for older scene instances that do not contain the rig.
		personagem_sprite.texture = CharacterController.all_sprites.plataform.idle_bath

	# Legacy shader setup remains available for the fallback sprite.
	if bath_character_rig == null:
		cor_pele = NewCharData.cor_pele
		roupa = NewCharData.roupa
		cor_roupa_cima = NewCharData.cor_roupa_cima
		cor_roupa_baixo = NewCharData.cor_roupa_baixo
		#
		print("cores pele, camisa, calça")
		print(cor_pele, cor_roupa_cima, cor_roupa_baixo)
		#
		var new_color_pele = Color(cor_pele)
		var new_color_cima = Color(cor_roupa_cima)
		var new_color_baixo = Color(cor_roupa_baixo)
		var shader_material = personagem_sprite.material as ShaderMaterial
		if shader_material != null:
			shader_material.set_shader_param("nova_cor_pele", new_color_pele)
	

func _on_body_area_body_entered(body):
	if(body.name == "Sabonete"):
		bubbles.emitting = true
	
	if(body.name == "Toalha"):
		is_drying = true
		$towel_sound.play()

func _on_body_area_body_exited(body):
	if(body.name == "Sabonete"):
		bubbles.emitting = false
	
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
		$shower_sound.play()
	else:
		$"Ativo 6/AnimationPlayer".play("close_faucet")
		$shower_sound.stop()
	$"Ativo 6/TurnOn".visible = not enabled
	$"Ativo 6/TurnOff".visible = enabled

func _process(delta):
	cd -= delta

	if(status_button and ensaboado <= 0):
		wet_timer += delta

		molhado += (20 * delta)

		if(wet_timer >= 1):
			wet_timer = 0
			if(water_circles.modulate.a < 1):
				water_circles.modulate.a = water_circles.modulate.a + 0.2

	if(bubbles.emitting == true):
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




func _on_TurnOn_pressed():
	_set_shower_enabled(not status_button)
	

