extends Control

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const BODY_SKIN_SHADER = preload("res://src/Mini-games/DoiAqui/actor/DoiAquiBodySkin.shader")
const BODY_PATH = "res://assets/DoiAqui/sprites/actor/boy/"
const HEAD_POSITION = Vector2(5, -63)
const HEAD_SCALE = Vector2(0.094, 0.094)
const NECK_OFFSET = Vector2(-10, 35)
const NECK_SIZE = Vector2(20, 20)

func _ready():
	$applause.play()
	_configure_character()

func _configure_character() -> void:
	var skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white
	var body = $Character/Sprite as Sprite
	body.texture = load(BODY_PATH + "boy-acerto-sem-cabeca-branco.png") as Texture
	var body_material = ShaderMaterial.new()
	body_material.shader = BODY_SKIN_SHADER
	body_material.set_shader_param("skin_mask", load(BODY_PATH + "boy-acerto-sem-cabeca.png") as Texture)
	body_material.set_shader_param("target_skin", skin)
	body.material = body_material

	var head = $Character/LegacyHead as Sprite
	head.texture = CharacterController.get_legacy_head_texture()
	head.position = HEAD_POSITION
	head.scale = HEAD_SCALE
	if head.texture == null:
		head.visible = false
		$Character/SkinColorRect.visible = false
		return

	var head_material = ShaderMaterial.new()
	head_material.shader = LEGACY_HEAD_SHADER
	var selected_gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var selected_hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(selected_gender, selected_hair))
	head_material.set_shader_param("target_skin", skin)
	head.material = head_material
	head.visible = true

	var neck = $Character/SkinColorRect as Panel
	neck.rect_position = HEAD_POSITION + NECK_OFFSET
	neck.rect_size = NECK_SIZE
	var neck_style = neck.get_stylebox("panel") as StyleBoxFlat
	if neck_style != null:
		neck_style = neck_style.duplicate()
		neck_style.bg_color = skin
		neck.add_stylebox_override("panel", neck_style)
	neck.visible = true

func _on_home_pressed():
	GlobalResource.resetVar()
	NecessityBars.some_problem = ""
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_play_pressed():
	GlobalResource.resetVar()
	NecessityBars.some_problem = ""	
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/Main.tscn")
