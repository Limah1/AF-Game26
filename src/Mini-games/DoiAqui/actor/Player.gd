extends KinematicBody2D

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const BODY_SKIN_SHADER = preload("res://src/Mini-games/DoiAqui/actor/DoiAquiBodySkin.shader")
const TUNING_PATH = "res://src/Mini-games/DoiAqui/actor/OutfitTuning.tres"
var outfit_tuning = preload(TUNING_PATH)
var active_state = "parado"
export var preview_only = false

const BODY_PATH = "res://assets/SpritesV4/DoiAqui/"

var typesPain = "normal"

onready var animation: AnimationPlayer = $AnimationPlayer
onready var legacy_head: Sprite = $LegacyHead
onready var skin_color_rect: Panel = $SkinColorRect


func _ready():
	_configure_body_sprites()
	_refresh_legacy_head()
	_sync_legacy_composite()

func _process(_delta):
	if preview_only:
		return
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
	body_sprite.texture = load(_body_texture_path(state_name)) as Texture
	var body_material = ShaderMaterial.new()
	body_material.shader = BODY_SKIN_SHADER
	body_material.set_shader_param("target_shirt", Color(CharacterController.cor_roupa_cima) if CharacterController.cor_roupa_cima != "" else Color.white)
	body_material.set_shader_param("target_pants", Color(CharacterController.cor_roupa_baixo) if CharacterController.cor_roupa_baixo != "" else Color("#efb826"))
	body_material.set_shader_param("target_skin", skin)
	body_sprite.material = body_material
	body_sprite.scale = Vector2.ONE * outfit_tuning.get_body_scale(state_name)

func _body_texture_path(state_name: String) -> String:
	return BODY_PATH + "boy-" + state_name + ".png"

func set_preview_state(state: String) -> void:
	preview_only = true
	animation.stop()
	active_state = state
	for path in ["sprite", "pain", "wound", "expressions/cold", "expressions/stress", "expressions/fever", "headache", "fever", "armPainCollection"]:
		get_node(path).visible = false
	_configure_body_sprite($sprite, state, _selected_skin_color())
	$sprite.visible = true
	_refresh_legacy_head()
	_sync_legacy_composite()

func _selected_skin_color() -> Color:
	return Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white


func _refresh_legacy_head() -> void:
	var head_texture = CharacterController.get_legacy_head_texture()
	if head_texture == null:
		legacy_head.visible = false
		skin_color_rect.visible = false
		return

	legacy_head.texture = head_texture
	var selected_head_position = outfit_tuning.get_head_position(active_state)
	legacy_head.position = selected_head_position
	legacy_head.scale = Vector2.ONE * outfit_tuning.get_head_scale(active_state)

	var skin = _selected_skin_color()
	var head_material = ShaderMaterial.new()
	head_material.shader = LEGACY_HEAD_SHADER
	var selected_gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var selected_hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(selected_gender, selected_hair))
	head_material.set_shader_param("target_skin", skin)
	legacy_head.material = head_material

	skin_color_rect.rect_position = selected_head_position + outfit_tuning.get_neck_offset(active_state)
	skin_color_rect.rect_size = outfit_tuning.get_neck_size(active_state)
	var neck_style = skin_color_rect.get_stylebox("panel") as StyleBoxFlat
	if neck_style != null:
		neck_style = neck_style.duplicate()
		neck_style.bg_color = skin
		skin_color_rect.add_stylebox_override("panel", neck_style)

func _sync_legacy_composite() -> void:
	if not preview_only:
		var state = "ferimento" if $wound.visible else "dores" if $pain.visible else "frio" if $expressions/cold.visible else "nervoso" if $expressions/stress.visible else "febre" if $expressions/fever.visible else "parado"
		if state != active_state:
			active_state = state
			_refresh_legacy_head()
	var body_visible = $sprite.visible or $pain.visible or $wound.visible \
		or $expressions/cold.visible or $expressions/stress.visible or $expressions/fever.visible
	var composite_visible = body_visible and legacy_head.texture != null
	legacy_head.visible = composite_visible
	skin_color_rect.visible = composite_visible

func _on_AnimationPlayer_animation_finished(anim_name):
	setTextureNormal()

func setTextureNormal():
	$sprite.texture = load(_body_texture_path("parado")) as Texture

