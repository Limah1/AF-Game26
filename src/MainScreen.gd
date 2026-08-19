extends Node2D

var current_room
var personagem_sprite
var sujeira_sprite
var cor_pele
var roupa
var cor_roupa_cima
var cor_roupa_baixo

onready var legacy_player = $Player/Player
onready var legacy_player_sprites = $Player/Player/player_sprites
onready var legacy_animation_player = $Player/AnimationPlayer
onready var modular_player = $Player/ModularPlayer

func _ready() -> void:
	personagem_sprite = get_node("Player/Player/player_sprites")
	#sujeira_sprite = get_node("Player/Player/player_sprites/sujeira")
	var previous_status = AnimationController.status
	CharacterController.player_ref = $Player/Player

	CharacterController.personagem_sprite = personagem_sprite

	AnimationController.set_animation_player($Player/AnimationPlayer)
	_setup_modular_player()

	if(previous_status == "Hospital" or previous_status == "Started" or previous_status == "MainGame" or previous_status == "DoiAqui"):
		$Slots.start(1)
	elif(previous_status == "Match3"):
		$Slots.start(2)
	elif(previous_status == "Hidratona"):
		$Slots.start(0)
	elif(previous_status == "Sleeping"):
		$Slots.start(3)
	elif(previous_status == "ForgotAcessory"):
		$Slots.start(3)
	else:
		$Slots.start(1)

	AnimationController.status = "Started"

	$Player/Player/rainny_sound.stop()
	$Player/Player/sunny_sound.stop()
	$Player/Player/snow_sound.stop()
	
	# Variaveis para Shaders
	cor_pele = NewCharData.cor_pele
	roupa = NewCharData.roupa
	cor_roupa_cima = NewCharData.cor_roupa_cima
	cor_roupa_baixo = NewCharData.cor_roupa_baixo
	
	print("cores pele, camisa, calça")
	print(cor_pele, cor_roupa_cima, cor_roupa_baixo)
	
	var new_color_pele = Color(cor_pele)
	var new_color_cima = Color(cor_roupa_cima)
	var new_color_baixo = Color(cor_roupa_baixo)
	var shader_material = personagem_sprite.material as ShaderMaterial
	shader_material.set_shader_param("nova_cor_pele", new_color_pele)
	shader_material.set_shader_param("nova_cor_camisa", new_color_cima)
	shader_material.set_shader_param("nova_cor_calca", new_color_baixo)
	


func _process(delta: float) -> void:
	current_room = $Slots/Slot1.current_room
	AnimationController.current_room = $Slots/Slot1.current_room
	_sync_modular_player()

func _setup_modular_player() -> void:
	if modular_player == null or legacy_player == null:
		return
	legacy_player_sprites.visible = false
	modular_player.position = legacy_player.position
	modular_player.scale = Vector2(3, 3)
	modular_player.z_index = legacy_player.z_index
	modular_player.set_state(0)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(modular_player)

func _sync_modular_player() -> void:
	if modular_player == null or legacy_player == null:
		return

	# Keep modular character loaded with persistent legacy player across room swaps.
	modular_player.position = legacy_player.position
	modular_player.z_index = legacy_player.z_index

	# Bedroom's dedicated sleep preview owns that state; avoid drawing duplicate rig.
	if AnimationController.status == "Sleeping":
		modular_player.visible = false
		return
	modular_player.visible = true

	var animation_name = legacy_animation_player.current_animation
	var movement_animation = legacy_animation_player.is_playing() and (
		animation_name.begins_with("go_to_") or
		animation_name.begins_with("reach_from_") or
		animation_name == "return_from_bath" or
		animation_name == "return_from_toilet"
	)
	var walking = AnimationController.isTravelling() or movement_animation
	var desired_state = 1 if walking else 0
	if modular_player.state != desired_state:
		modular_player.set_state(desired_state)

	# Legacy Player.gd owns facing sign; mirror it for every modular body part.
	if legacy_player_sprites.scale.x != 0.0 and modular_player.has_method("set_facing"):
		modular_player.set_facing(-1 if legacy_player_sprites.scale.x < 0.0 else 1)

func toggle_NM(visible = null):
	if visible != null:
		$NecessityManager.layer = abs($NecessityManager.layer) if visible else -abs($NecessityManager.layer)
	else:
		$NecessityManager.layer = -$NecessityManager.layer
