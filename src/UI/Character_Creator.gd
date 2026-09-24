# script.gd (Anexado ao nó que contém os botões e o sprite)

extends Control # Ou Node2D, dependendo do seu nó base

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const CHARACTER_SHADER_MATERIAL = preload("res://src/UI/ShaderPersonagem.tres")
const BOY_CARD_COLOR = Color("#5853ff")
const GIRL_CARD_COLOR = Color("#ec2ac5")

export(Vector2) var body_position = Vector2(1606.6, 513.576)
export(float, 0.05, 2.0, 0.001) var body_scale = 0.2
export(Vector2) var boy1_head_position = Vector2(1600, 141)
export(float, 0.05, 2.0, 0.001) var boy1_head_scale = 0.252
export(Vector2) var boy2_head_position = Vector2(1600, 141)
export(float, 0.05, 2.0, 0.001) var boy2_head_scale = 0.252
export(Vector2) var girl1_head_position = Vector2(1600, 141)
export(float, 0.05, 2.0, 0.001) var girl1_head_scale = 0.252
export(Vector2) var girl2_head_position = Vector2(1600, 141)
export(float, 0.05, 2.0, 0.001) var girl2_head_scale = 0.252

# Declare a variável, mas não a inicialize aqui no Godot 3.x
var personagem_sprite
var selected_skin_tone_id = "skin_01"

onready var modular_character = $ModularCharacter
onready var legacy_head = $LegacyHead
onready var hair_a_icon = $cabelo_A/HeadIcon
onready var hair_b_icon = $cabelo_B/HeadIcon

var sprite_boy = preload("res://assets/SpritesV4/RoupasNormais/Menino/Variacao1/m0.png")
var sprite_girl = preload("res://assets/SpritesV4/RoupasNormais/Menina/Variacao1/m0.png")

func _ready():
	# Inicialize a variável 'personagem_sprite' usando get_node()
	personagem_sprite = get_node("Sprite") 
	_show_legacy_preview()
	get_node("btn_cor_1").pressed = true
	get_node("btn_boy").pressed = true
	ModularCharacterData.set_gender("boy")
	get_node("cabelo_B").pressed = true
	_update_hair_buttons("boy")
	_set_skin_tone(selected_skin_tone_id)
	_update_legacy_head()
	_apply_modular_preview()

func _show_legacy_preview() -> void:
	# Use the original single-sprite character preview.
	if personagem_sprite != null:
		personagem_sprite.visible = true
		personagem_sprite.position = body_position
		personagem_sprite.scale = Vector2.ONE * body_scale
	if modular_character != null:
		modular_character.visible = false

func _update_legacy_head() -> void:
	if legacy_head == null:
		return
	var gender = "boy" if $btn_boy.pressed else "girl"
	var hair = "a" if $cabelo_A.pressed else "b"
	legacy_head.texture = CharacterController.get_head_texture_for(gender, hair)
	legacy_head.visible = true
	match "%s-%s" % [gender, hair]:
		"boy-a":
			legacy_head.position = boy1_head_position
			legacy_head.scale = Vector2.ONE * boy1_head_scale
		"boy-b":
			legacy_head.position = boy2_head_position
			legacy_head.scale = Vector2.ONE * boy2_head_scale
		"girl-a":
			legacy_head.position = girl1_head_position
			legacy_head.scale = Vector2.ONE * girl1_head_scale
		"girl-b":
			legacy_head.position = girl2_head_position
			legacy_head.scale = Vector2.ONE * girl2_head_scale
	var head_material = legacy_head.material as ShaderMaterial
	if head_material == null or head_material.shader != LEGACY_HEAD_SHADER:
		head_material = ShaderMaterial.new()
		head_material.shader = LEGACY_HEAD_SHADER
		legacy_head.material = head_material
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", ModularCharacterData.cor_pele)

func _update_hair_buttons(gender: String) -> void:
	var card_color = BOY_CARD_COLOR if gender == "boy" else GIRL_CARD_COLOR
	$cabelo_A.material.set_shader_param("top_color", card_color)
	hair_a_icon.texture = CharacterController.get_head_texture_for(gender, "a")
	hair_b_icon.texture = CharacterController.get_head_texture_for(gender, "b")
	for icon in [hair_a_icon, hair_b_icon]:
		var icon_material = icon.material as ShaderMaterial
		icon_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, "a"))
		icon_material.set_shader_param("target_skin", Color.white)

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

	if personagem_sprite != null:
		var shader_material = personagem_sprite.material as ShaderMaterial
		if shader_material == null:
			shader_material = CHARACTER_SHADER_MATERIAL.duplicate()
			personagem_sprite.material = shader_material
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
	$Sprite.texture = sprite_boy
	_update_hair_buttons("boy")
	get_node("btn_girl").pressed = false
	_update_legacy_head()
	_apply_modular_preview()

func _on_btn_girl_pressed():
	ModularCharacterData.set_gender("girl")
	$Sprite.texture = sprite_girl
	_update_hair_buttons("girl")
	get_node("btn_boy").pressed = false
	_update_legacy_head()
	_apply_modular_preview()



func _on_cabelo_A_pressed():
	get_node("cabelo_A").pressed = true
	get_node("cabelo_B").pressed = false
	
	if $btn_boy.pressed:
		$Sprite.texture = sprite_boy
	else:
		$Sprite.texture = sprite_girl
	_update_legacy_head()


func _on_cabelo_B_pressed():
	get_node("cabelo_A").pressed = false
	get_node("cabelo_B").pressed = true
	
	if $btn_boy.pressed:
		$Sprite.texture = sprite_boy
	else:
		$Sprite.texture = sprite_girl
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
		

