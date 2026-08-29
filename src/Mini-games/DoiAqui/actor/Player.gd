extends KinematicBody2D

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const BODY_SKIN_SHADER = preload("res://src/Mini-games/DoiAqui/actor/DoiAquiBodySkin.shader")
const SAD_BOY_A_HEAD = preload("res://assets/DoiAqui/sprites/actor/boy/boy-a-head-triste.png")
const SAD_BOY_B_HEAD = preload("res://assets/DoiAqui/sprites/actor/boy/boy-b-head-triste.png")
const SAD_GIRL_A_HEAD = preload("res://assets/DoiAqui/sprites/actor/boy/girl-a-head-triste.png")
const SAD_GIRL_B_HEAD = preload("res://assets/DoiAqui/sprites/actor/boy/girl-b-head-triste.png")
const BODY_PATH = "res://assets/DoiAqui/sprites/actor/boy/"

export var legacy_head_position = Vector2(5, -51)
export var legacy_head_scale = Vector2(0.094, 0.094)
export var head_offset_boy_a = Vector2(0, 10)
export var head_offset_boy_b = Vector2.ZERO
export var head_offset_girl_a = Vector2(0, 10)
export var head_offset_girl_b = Vector2.ZERO
export var legacy_neck_offset = Vector2(-10, 35)
export var legacy_neck_size = Vector2(20, 20)

var typesPain = "normal"

onready var animation: AnimationPlayer = $AnimationPlayer
onready var legacy_head: Sprite = $LegacyHead
onready var skin_color_rect: Panel = $SkinColorRect


func _ready():
	_configure_body_sprites()
	_refresh_legacy_head()
	_sync_legacy_composite()

func _process(_delta):
	if typesPain == "headache":
		animation.play("headache")
	elif typesPain == "armPain":
		animation.play("armPain")
	elif typesPain == "fever":
		animation.play("fever")
	elif typesPain == "wound":
		animation.play("wound")
	elif typesPain == "normal":
		animation.stop()
		$headache.visible = false
		$fever.visible = false
		$armPainCollection.visible = false
		$wound.visible = false
		animation.play("normal")
	_sync_legacy_composite()

func _configure_body_sprites() -> void:
	var body_sprites = {
		"parado": $sprite,
		"dores": $pain,
		"ferimento": $wound,
		"frio": $expressions/cold,
		"nervoso": $expressions/stress,
		"febre": $expressions/fever,
	}
	var skin = _selected_skin_color()
	for state_name in body_sprites:
		_configure_body_sprite(body_sprites[state_name] as Sprite, state_name, skin)

func _configure_body_sprite(body_sprite: Sprite, state_name: String, skin: Color) -> void:
	if body_sprite == null:
		return
	body_sprite.texture = load(_body_texture_path(state_name, true)) as Texture
	var body_material = ShaderMaterial.new()
	body_material.shader = BODY_SKIN_SHADER
	body_material.set_shader_param("skin_mask", load(_body_texture_path(state_name, false)) as Texture)
	body_material.set_shader_param("target_skin", skin)
	body_sprite.material = body_material

func _body_texture_path(state_name: String, white_skin: bool) -> String:
	var suffix = "-sem-cabeca-branco.png" if white_skin else "-sem-cabeca.png"
	return BODY_PATH + "boy-" + state_name + suffix

func _selected_skin_color() -> Color:
	return Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white


func _selected_head_key() -> String:
	var selected_gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var selected_hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	return "%s-%s" % [selected_gender, selected_hair]


func _get_doiaqui_head_texture() -> Texture:
	match _selected_head_key():
		"boy-a":
			return SAD_BOY_A_HEAD
		"boy-b":
			return SAD_BOY_B_HEAD
		"girl-a":
			return SAD_GIRL_A_HEAD
		"girl-b":
			return SAD_GIRL_B_HEAD
	return CharacterController.get_legacy_head_texture()


func _get_selected_head_offset() -> Vector2:
	match _selected_head_key():
		"boy-a":
			return head_offset_boy_a
		"boy-b":
			return head_offset_boy_b
		"girl-a":
			return head_offset_girl_a
		"girl-b":
			return head_offset_girl_b
	return Vector2.ZERO


func _refresh_legacy_head() -> void:
	var head_texture = _get_doiaqui_head_texture()
	if head_texture == null:
		legacy_head.visible = false
		skin_color_rect.visible = false
		return

	legacy_head.texture = head_texture
	var selected_head_position = legacy_head_position + _get_selected_head_offset()
	legacy_head.position = selected_head_position
	legacy_head.scale = legacy_head_scale

	var skin = _selected_skin_color()
	var head_material = ShaderMaterial.new()
	head_material.shader = LEGACY_HEAD_SHADER
	var selected_gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var selected_hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(selected_gender, selected_hair))
	head_material.set_shader_param("target_skin", skin)
	legacy_head.material = head_material

	skin_color_rect.rect_position = selected_head_position + legacy_neck_offset
	skin_color_rect.rect_size = legacy_neck_size
	var neck_style = skin_color_rect.get_stylebox("panel") as StyleBoxFlat
	if neck_style != null:
		neck_style = neck_style.duplicate()
		neck_style.bg_color = skin
		skin_color_rect.add_stylebox_override("panel", neck_style)

func _sync_legacy_composite() -> void:
	var body_visible = $sprite.visible or $pain.visible or $wound.visible \
		or $expressions/cold.visible or $expressions/stress.visible or $expressions/fever.visible
	var composite_visible = body_visible and legacy_head.texture != null
	legacy_head.visible = composite_visible
	skin_color_rect.visible = composite_visible

func _on_AnimationPlayer_animation_finished(anim_name):
	setTextureNormal()

func setTextureNormal():
	$sprite.texture = load(_body_texture_path("parado", true)) as Texture

