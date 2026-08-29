# script.gd (Anexado ao nó que contém os botões e o sprite)

extends Control # Ou Node2D, dependendo do seu nó base

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")

# Declare a variável, mas não a inicialize aqui no Godot 3.x
var personagem_sprite
var selected_skin_tone_id = "skin_01"

onready var modular_character = $ModularCharacter
onready var legacy_head = $LegacyHead

var sprite_boy_a = preload("res://assets/Sprites-v3/boy-a/boy-a-r1-m0.png")
var sprite_girl_a = preload("res://assets/Sprites-v3/girl-a/girl-a-r1-m0.png")
var sprite_boy_b = preload("res://assets/Sprites-v3/boy-b/boy-b-r1-m0.png")
var sprite_girl_b = preload("res://assets/Sprites-v3/girl-b/girl-b-r1-m0.png")

var cabelo_girl_A = preload("res://src/UI/Assets/Frame 7 - branco.png")
var cabelo_girl_A_on = preload("res://src/UI/Assets/Frame 7 - branco.png")
var cabelo_girl_B = preload("res://src/UI/Assets/Frame 8.png")
var cabelo_girl_B_on = preload("res://src/UI/Assets/Frame 8.png")
var cabelo_boy_A = preload("res://src/UI/Assets/Frame 6 - branco.png")
var cabelo_boy_A_on = preload("res://src/UI/Assets/Frame 6 - branco.png")
var cabelo_boy_B = preload("res://src/UI/Assets/Frame 9 - branco.png")
var cabelo_boy_B_on = preload("res://src/UI/Assets/Frame 9 - branco.png")


func _ready():
	# Inicialize a variável 'personagem_sprite' usando get_node()
	personagem_sprite = get_node("Sprite") 
	_show_legacy_preview()
	get_node("btn_cor_1").pressed = true
	get_node("btn_boy").pressed = true
	ModularCharacterData.set_gender("boy")
	get_node("cabelo_B").pressed = true
	_set_skin_tone(selected_skin_tone_id)
	_update_legacy_head()
	_apply_modular_preview()

func _show_legacy_preview() -> void:
	# Use the original single-sprite character preview.
	if personagem_sprite != null:
		personagem_sprite.visible = true
		personagem_sprite.scale = Vector2(0.6, 0.6)
	if modular_character != null:
		modular_character.visible = false

func _update_legacy_head() -> void:
	if legacy_head == null:
		return
	var gender = "boy" if $btn_boy.pressed else "girl"
	var hair = "a" if $cabelo_A.pressed else "b"
	legacy_head.texture = load("res://assets/Sprites-v3/heads/%s-%s-head.png" % [gender, hair])
	legacy_head.visible = true
	var head_material = legacy_head.material as ShaderMaterial
	if head_material == null or head_material.shader != LEGACY_HEAD_SHADER:
		head_material = ShaderMaterial.new()
		head_material.shader = LEGACY_HEAD_SHADER
		legacy_head.material = head_material
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", ModularCharacterData.cor_pele)

func _apply_modular_preview() -> void:
	if modular_character == null:
		return
	modular_character.scale = Vector2(3, 3)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(modular_character)

func _set_skin_tone(tone_id: String):
	var new_color = ModularCharacterData.get_skin_tone_color(tone_id)
	selected_skin_tone_id = tone_id
	ModularCharacterData.select_skin_tone(tone_id)

	var shader_material = personagem_sprite.material as ShaderMaterial
	shader_material.set_shader_param("nova_cor_pele", new_color)
	if legacy_head != null and legacy_head.material is ShaderMaterial:
		legacy_head.material.set_shader_param("target_skin", new_color)
	if modular_character != null:
		modular_character.set_skin_color(new_color)

# Métodos que serão chamados quando os botões forem clicados
func _on_btn_cor_1_pressed():
	_set_skin_tone("skin_01")
	get_node("btn_cor_1").pressed = true
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_2_pressed():
	_set_skin_tone("skin_02")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = true
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_3_pressed():
	_set_skin_tone("skin_03")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = true
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_4_pressed():
	_set_skin_tone("skin_04")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = true
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_5_pressed():
	_set_skin_tone("skin_05")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = true
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_6_pressed():
	_set_skin_tone("skin_06")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = true



func _on_btn_boy_pressed():
	ModularCharacterData.set_gender("boy")
	if	$cabelo_A.pressed:
		$Sprite.texture = sprite_boy_a
	else:
		$Sprite.texture = sprite_boy_b
		
	$cabelo_A.texture_normal = cabelo_boy_A
	$cabelo_A.texture_pressed = cabelo_boy_A_on
	$cabelo_B.texture_normal = cabelo_boy_B
	$cabelo_B.texture_pressed = cabelo_boy_B_on
	get_node("btn_girl").pressed = false
	_update_legacy_head()
	_apply_modular_preview()

func _on_btn_girl_pressed():
	ModularCharacterData.set_gender("girl")
	if	$cabelo_A.pressed:
		$Sprite.texture = sprite_girl_a
	else:
		$Sprite.texture = sprite_girl_b
		
	$cabelo_A.texture_normal = cabelo_girl_A
	$cabelo_A.texture_pressed = cabelo_girl_A_on
	$cabelo_B.texture_normal = cabelo_girl_B
	$cabelo_B.texture_pressed = cabelo_girl_B_on
	get_node("btn_boy").pressed = false
	_update_legacy_head()
	_apply_modular_preview()



func _on_cabelo_A_pressed():
	get_node("cabelo_A").pressed = true
	get_node("cabelo_B").pressed = false
	
	if $btn_boy.pressed:
		$Sprite.texture = sprite_boy_a
	else:
		$Sprite.texture = sprite_girl_a
	_update_legacy_head()


func _on_cabelo_B_pressed():
	get_node("cabelo_A").pressed = false
	get_node("cabelo_B").pressed = true
	
	if $btn_boy.pressed:
		$Sprite.texture = sprite_boy_b
	else:
		$Sprite.texture = sprite_girl_b
	_update_legacy_head()


func _on_ConfirmButton_pressed():
	# Definir cabelo
	if get_node("cabelo_A").pressed:
		NewCharData.cabelo = "a"
	else:
		NewCharData.cabelo = "b"
	
	#Definir gênero
	if get_node("btn_boy").pressed:
		NewCharData.genero = "boy"
	else:
		NewCharData.genero = "girl"
	ModularCharacterData.set_gender(NewCharData.genero)

	# Save the catalog ID and exact catalog color.
	NewCharData.cor_pele = ModularCharacterData.get_skin_tone_hex(selected_skin_tone_id)
		
	get_tree().change_scene("res://src/UI/Character_Clothes_Selector.tscn")
		

