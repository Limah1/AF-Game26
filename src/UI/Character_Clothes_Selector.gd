extends Control 

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
export(Vector2) var roupa_1_body_position = Vector2(1606.6, 513.576)
export(float, 0.05, 2.0, 0.001) var roupa_1_body_scale = 0.4
export(Vector2) var roupa_1_head_position = Vector2(1600, 190)
export(float, 0.05, 2.0, 0.001) var roupa_1_head_scale = 0.4
export(Vector2) var roupa_2_body_position = Vector2(1606.6, 513.576)
export(float, 0.05, 2.0, 0.001) var roupa_2_body_scale = 0.4
export(Vector2) var roupa_2_head_position = Vector2(1600, 190)
export(float, 0.05, 2.0, 0.001) var roupa_2_head_scale = 0.4

var personagem_sprite
var cabelo = NewCharData.cabelo
var genero = NewCharData.genero
var cor_pele = NewCharData.cor_pele

onready var modular_character = $ModularCharacter
onready var legacy_head = $LegacyHead

var sprite_boy_r1 = preload("res://assets/SpritesV4/RoupasNormais/Menino/Variacao1/m0.png")
var sprite_boy_r2 = preload("res://assets/SpritesV4/RoupasNormais/Menino/Variacao2/m0.png")
var sprite_girl_r1 = preload("res://assets/SpritesV4/RoupasNormais/Menina/Variacao1/m0.png")
var sprite_girl_r2 = preload("res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m0.png")

var sprite_btn_roupa_girl_1 = preload("res://assets/Character_Creator/btn_roupa_1_girl.png")
var sprite_btn_roupa_girl_1_on = preload("res://assets/Character_Creator/btn_roupa_1_girl_on.png")
var sprite_btn_roupa_boy_1 = preload("res://assets/Character_Creator/btn_roupa_1_boy.png")
var sprite_btn_roupa_boy_1_on = preload("res://assets/Character_Creator/btn_roupa_1_boy_on.png")
var sprite_btn_roupa_girl_2 = preload("res://assets/Character_Creator/btn_roupa_2_girl.png")
var sprite_btn_roupa_girl_2_on = preload("res://assets/Character_Creator/btn_roupa_2_girl_on.png")
var sprite_btn_roupa_boy_2 = preload("res://assets/Character_Creator/btn_roupa_2_boy.png")
var sprite_btn_roupa_boy_2_on = preload("res://assets/Character_Creator/btn_roupa_2_boy_on.png")


func _ready():
	personagem_sprite = get_node("Sprite") 
	_show_legacy_preview()
	if genero != "boy" and genero != "girl":
		genero = ModularCharacterData.genero
	ModularCharacterData.set_gender(genero)
	if cor_pele != "":
		ModularCharacterData.cor_pele = Color(cor_pele)
	get_node("btn_cima_cor_6").pressed = true
	get_node("btn_baixo_cor_6").pressed = true
	get_node("btn_roupa_1").pressed = true
	
	# Seta a cor da pele escolhida na tela anterior
	var new_color = ModularCharacterData.cor_pele if cor_pele == "" else Color(cor_pele)
	var shader_material = personagem_sprite.material as ShaderMaterial
	shader_material.set_shader_param("nova_cor_pele", new_color)
	
	if (genero == "girl"):
		$btn_roupa_1.texture_normal = sprite_btn_roupa_girl_1
		$btn_roupa_1.texture_pressed = sprite_btn_roupa_girl_1_on
		$btn_roupa_2.texture_normal = sprite_btn_roupa_girl_2
		$btn_roupa_2.texture_pressed = sprite_btn_roupa_girl_2_on
		$Sprite.texture = sprite_girl_r1
	else:
		$btn_roupa_1.texture_normal = sprite_btn_roupa_boy_1
		$btn_roupa_1.texture_pressed = sprite_btn_roupa_boy_1_on
		$btn_roupa_2.texture_normal = sprite_btn_roupa_boy_2
		$btn_roupa_2.texture_pressed = sprite_btn_roupa_boy_2_on
		$Sprite.texture = sprite_boy_r1
	_update_legacy_head()

	# Match the old selector defaults on the modular rig.
	_set_camisa_color(NewCharData.cor_roupa_cima if NewCharData.cor_roupa_cima != "" else "#8a9da5")
	_set_calca_color(NewCharData.cor_roupa_baixo if NewCharData.cor_roupa_baixo != "" else "#515151")
	_apply_modular_preview()

func _show_legacy_preview() -> void:
	# Use the original character preview with the new head overlay.
	if personagem_sprite != null:
		personagem_sprite.visible = true
		personagem_sprite.position = roupa_1_body_position
		personagem_sprite.scale = Vector2.ONE * roupa_1_body_scale
	if modular_character != null:
		modular_character.visible = false

func _update_legacy_head() -> void:
	if legacy_head == null:
		return
	var hair = "a" if cabelo == "a" else "b"
	var roupa_1 = $btn_roupa_1.pressed
	legacy_head.texture = CharacterController.get_head_texture_for(genero, hair)
	legacy_head.visible = true
	personagem_sprite.position = roupa_1_body_position if roupa_1 else roupa_2_body_position
	personagem_sprite.scale = Vector2.ONE * (roupa_1_body_scale if roupa_1 else roupa_2_body_scale)
	legacy_head.position = roupa_1_head_position if roupa_1 else roupa_2_head_position
	legacy_head.scale = Vector2.ONE * (roupa_1_head_scale if roupa_1 else roupa_2_head_scale)
	var head_material = legacy_head.material as ShaderMaterial
	if head_material == null or head_material.shader != LEGACY_HEAD_SHADER:
		head_material = ShaderMaterial.new()
		head_material.shader = LEGACY_HEAD_SHADER
		legacy_head.material = head_material
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(genero, hair))
	head_material.set_shader_param("target_skin", ModularCharacterData.cor_pele)

func _apply_modular_preview() -> void:
	if modular_character == null:
		return
	modular_character.scale = Vector2(3, 3)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(modular_character)
	
	


func _set_camisa_color(color_hex: String):
	# Converte a string hexadecimal para um obj Color do Godot
	var new_color = Color(color_hex)
	
	var shader_material = personagem_sprite.material as ShaderMaterial
	# Define a nova cor de pele no shader
	shader_material.set_shader_param("nova_cor_camisa", new_color)
	ModularCharacterData.cor_roupa_cima = new_color
	if modular_character != null:
		modular_character.set_shirt_color(new_color)
	


func _set_calca_color(color_hex: String):
	# Converte a string hexadecimal para um obj Color do Godot
	var new_color = Color(color_hex)
	
	var shader_material = personagem_sprite.material as ShaderMaterial
	# Define a nova cor de pele no shader
	shader_material.set_shader_param("nova_cor_calca", new_color)
	ModularCharacterData.cor_roupa_baixo = new_color
	if modular_character != null:
		modular_character.set_pants_color(new_color)



func _on_btn_roupa_2_pressed():
	get_node("btn_roupa_1").pressed = false
	get_node("btn_roupa_2").pressed = true
	if (genero == "girl"):
		$Sprite.texture = sprite_girl_r2
	else:
		$Sprite.texture = sprite_boy_r2
	_update_legacy_head()


func _on_btn_roupa_1_pressed():
	get_node("btn_roupa_1").pressed = true
	get_node("btn_roupa_2").pressed = false
	if (genero == "girl"):
		$Sprite.texture = sprite_girl_r1
	else:
		$Sprite.texture = sprite_boy_r1
	_update_legacy_head()


func _on_btn_cima_cor_1_pressed():
	_set_camisa_color("#ed1b24")
	get_node("btn_cima_cor_1").pressed = true
	get_node("btn_cima_cor_2").pressed = false
	get_node("btn_cima_cor_3").pressed = false
	get_node("btn_cima_cor_4").pressed = false
	get_node("btn_cima_cor_5").pressed = false
	get_node("btn_cima_cor_6").pressed = false

func _on_btn_cima_cor_2_pressed():
	_set_camisa_color("#f46523")
	get_node("btn_cima_cor_1").pressed = false
	get_node("btn_cima_cor_2").pressed = true
	get_node("btn_cima_cor_3").pressed = false
	get_node("btn_cima_cor_4").pressed = false
	get_node("btn_cima_cor_5").pressed = false
	get_node("btn_cima_cor_6").pressed = false

func _on_btn_cima_cor_3_pressed():
	_set_camisa_color("#d5cd34")
	get_node("btn_cima_cor_1").pressed = false
	get_node("btn_cima_cor_2").pressed = false
	get_node("btn_cima_cor_3").pressed = true
	get_node("btn_cima_cor_4").pressed = false
	get_node("btn_cima_cor_5").pressed = false
	get_node("btn_cima_cor_6").pressed = false

func _on_btn_cima_cor_4_pressed():
	_set_camisa_color("#21b24b")
	get_node("btn_cima_cor_1").pressed = false
	get_node("btn_cima_cor_2").pressed = false
	get_node("btn_cima_cor_3").pressed = false
	get_node("btn_cima_cor_4").pressed = true
	get_node("btn_cima_cor_5").pressed = false
	get_node("btn_cima_cor_6").pressed = false

func _on_btn_cima_cor_5_pressed():
	_set_camisa_color("#2e3094")
	get_node("btn_cima_cor_1").pressed = false
	get_node("btn_cima_cor_2").pressed = false
	get_node("btn_cima_cor_3").pressed = false
	get_node("btn_cima_cor_4").pressed = false
	get_node("btn_cima_cor_5").pressed = true
	get_node("btn_cima_cor_6").pressed = false

func _on_btn_cima_cor_6_pressed():
	_set_camisa_color("#8a9da5")
	get_node("btn_cima_cor_1").pressed = false
	get_node("btn_cima_cor_2").pressed = false
	get_node("btn_cima_cor_3").pressed = false
	get_node("btn_cima_cor_4").pressed = false
	get_node("btn_cima_cor_5").pressed = false
	get_node("btn_cima_cor_6").pressed = true



func _on_btn_baixo_cor_1_pressed():
	_set_calca_color("#b9181f")
	get_node("btn_baixo_cor_1").pressed = true
	get_node("btn_baixo_cor_2").pressed = false
	get_node("btn_baixo_cor_3").pressed = false
	get_node("btn_baixo_cor_4").pressed = false
	get_node("btn_baixo_cor_5").pressed = false
	get_node("btn_baixo_cor_6").pressed = false

func _on_btn_baixo_cor_2_pressed():
	_set_calca_color("#724530")
	get_node("btn_baixo_cor_1").pressed = false
	get_node("btn_baixo_cor_2").pressed = true
	get_node("btn_baixo_cor_3").pressed = false
	get_node("btn_baixo_cor_4").pressed = false
	get_node("btn_baixo_cor_5").pressed = false
	get_node("btn_baixo_cor_6").pressed = false

func _on_btn_baixo_cor_3_pressed():
	_set_calca_color("#a29f62")
	get_node("btn_baixo_cor_1").pressed = false
	get_node("btn_baixo_cor_2").pressed = false
	get_node("btn_baixo_cor_3").pressed = true
	get_node("btn_baixo_cor_4").pressed = false
	get_node("btn_baixo_cor_5").pressed = false
	get_node("btn_baixo_cor_6").pressed = false

func _on_btn_baixo_cor_4_pressed():
	_set_calca_color("#18581b")
	get_node("btn_baixo_cor_1").pressed = false
	get_node("btn_baixo_cor_2").pressed = false
	get_node("btn_baixo_cor_3").pressed = false
	get_node("btn_baixo_cor_4").pressed = true
	get_node("btn_baixo_cor_5").pressed = false
	get_node("btn_baixo_cor_6").pressed = false

func _on_btn_baixo_cor_5_pressed():
	_set_calca_color("#2d2d4b")
	get_node("btn_baixo_cor_1").pressed = false
	get_node("btn_baixo_cor_2").pressed = false
	get_node("btn_baixo_cor_3").pressed = false
	get_node("btn_baixo_cor_4").pressed = false
	get_node("btn_baixo_cor_5").pressed = true
	get_node("btn_baixo_cor_6").pressed = false

func _on_btn_baixo_cor_6_pressed():
	_set_calca_color("#515151")
	get_node("btn_baixo_cor_1").pressed = false
	get_node("btn_baixo_cor_2").pressed = false
	get_node("btn_baixo_cor_3").pressed = false
	get_node("btn_baixo_cor_4").pressed = false
	get_node("btn_baixo_cor_5").pressed = false
	get_node("btn_baixo_cor_6").pressed = true


func _on_ConfirmButton_pressed():
	# Definir roupa
	if get_node("btn_roupa_1").pressed:
		NewCharData.roupa = "r1"
	else:
		NewCharData.roupa = "r2"
		
	#Definor cor da roupa de cima
	if get_node("btn_cima_cor_1").pressed:
		NewCharData.cor_roupa_cima = "#ed1b24"
	elif get_node("btn_cima_cor_2").pressed:
		NewCharData.cor_roupa_cima = "#f46523"
	elif get_node("btn_cima_cor_3").pressed:
		NewCharData.cor_roupa_cima = "#d5cd34"
	elif get_node("btn_cima_cor_4").pressed:
		NewCharData.cor_roupa_cima = "#21b24b"
	elif get_node("btn_cima_cor_5").pressed:
		NewCharData.cor_roupa_cima = "#2e3094"
	elif get_node("btn_cima_cor_6").pressed:
		NewCharData.cor_roupa_cima = "#8a9da5"
		
	#Definor cor da roupa de baixo
	if get_node("btn_baixo_cor_1").pressed:
		NewCharData.cor_roupa_baixo = "#b9181f"
	elif get_node("btn_baixo_cor_2").pressed:
		NewCharData.cor_roupa_baixo = "#724530"
	elif get_node("btn_baixo_cor_3").pressed:
		NewCharData.cor_roupa_baixo = "#a29f62"
	elif get_node("btn_baixo_cor_4").pressed:
		NewCharData.cor_roupa_baixo = "#18581b"
	elif get_node("btn_baixo_cor_5").pressed:
		NewCharData.cor_roupa_baixo = "#2d2d4b"
	elif get_node("btn_baixo_cor_6").pressed:
		NewCharData.cor_roupa_baixo = "#515151"
		
	$button_sound.play()
	yield($button_sound,"finished")
	NecessityBars.started = true
	CharacterController.start()
	get_tree().change_scene("res://src/MainScreen.tscn")
