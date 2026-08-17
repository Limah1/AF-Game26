extends Node2D

var current_room
var personagem_sprite
var sujeira_sprite
var cor_pele
var roupa
var cor_roupa_cima
var cor_roupa_baixo

func _ready() -> void:
	personagem_sprite = get_node("Player/Player/player_sprites")
	#sujeira_sprite = get_node("Player/Player/player_sprites/sujeira")
	AnimationController.status = "Started"
	CharacterController.player_ref = $Player/Player
	
	CharacterController.personagem_sprite = personagem_sprite
	
	AnimationController.set_animation_player($Player/AnimationPlayer)
	
	if(AnimationController.status == "Hospital" or AnimationController.status == "Started" or AnimationController.status == "MainGame" or AnimationController.status == "DoiAqui"):
		$Slots.start(1)
	elif(AnimationController.status == "Match3"):
		$Slots.start(2)
	elif(AnimationController.status == "Hidratona"):
		$Slots.start(0)
	elif(AnimationController.status == "Sleeping"):
		$Slots.start(3)
	elif(AnimationController.status == "ForgotAcessory"):
		$Slots.start(3)
	
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

func toggle_NM(visible = null):
	if visible != null:
		$NecessityManager.layer = abs($NecessityManager.layer) if visible else -abs($NecessityManager.layer)
	else:
		$NecessityManager.layer = -$NecessityManager.layer
