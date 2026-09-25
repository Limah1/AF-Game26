extends Control

const TUNING_PATH = "res://assets/SpritesV4/RoupasEspeciais/ConfiguracaoRoupasEspeciais.tres"
const DEFAULT_TUNING = preload(TUNING_PATH)
const HIDRATONA_RUN_PATH = "res://src/Mini-games/Hidratona/src/level/rain/RunCalibration.tres"
const HIDRATONA_RAIN_PATH = "res://src/Mini-games/Hidratona/src/level/rain/"
const HIDRATONA_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const HIDRATONA_BODY_SHADER = preload("res://src/Mini-games/Hidratona/src/level/rain/RainRunSkin.shader")
const RUN_HEAD_POSITIONS = [Vector2(-1, -5), Vector2(-13, -5), Vector2(-2.5, -5), Vector2(7, -1), Vector2(1.5, -3.5), Vector2(-7, -4.5), Vector2(0.5, -0.5)]
const GAME_NORMAL_SPRITE_POSITIONS = {
	"idle": Vector2(0.580444, 90), "w1": Vector2(0, 90), "w2": Vector2(0, 90),
	"w3": Vector2(0, 90), "w4": Vector2(0, 90), "w5": Vector2(0, 90)
}

onready var player = $Preview/Player
onready var hidratona_run = $Preview/HidratonaRun
onready var outfit_option = $Panel/Margin/Controls/OutfitRow/Outfit
onready var variation_option = $Panel/Margin/Controls/VariationRow/Variation
onready var gender_option = $Panel/Margin/Controls/GenderRow/Gender
onready var hair_option = $Panel/Margin/Controls/HairRow/Hair
onready var state_option = $Panel/Margin/Controls/StateRow/State
onready var outfit_scale_input = $Panel/Margin/Controls/OutfitScaleRow/OutfitScale
onready var head_x_input = $Panel/Margin/Controls/HeadXRow/HeadX
onready var head_y_input = $Panel/Margin/Controls/HeadYRow/HeadY
onready var head_scale_input = $Panel/Margin/Controls/HeadScaleRow/HeadScale
onready var neck_controls = $Panel/Margin/Controls/NeckControls
onready var neck_x_input = $Panel/Margin/Controls/NeckControls/NeckXRow/NeckX
onready var neck_y_input = $Panel/Margin/Controls/NeckControls/NeckYRow/NeckY
onready var neck_width_input = $Panel/Margin/Controls/NeckControls/NeckWidthRow/NeckWidth
onready var neck_height_input = $Panel/Margin/Controls/NeckControls/NeckHeightRow/NeckHeight
onready var status_label = $Panel/Margin/Controls/Status

var tuning: Resource
var run_tuning: Resource
var updating_controls = false

func _ready() -> void:
	_populate_options()
	_connect_controls()
	_prepare_character()
	_load_tuning_from_disk()
	_load_run_tuning()
	outfit_option.selected = 3
	_on_selection_changed(0)

func _populate_options() -> void:
	for label in ["Normal", "Chuva", "Neve", "Hidratona: corrida na chuva"]:
		outfit_option.add_item(label)
	for label in ["Variação 1", "Variação 2"]:
		variation_option.add_item(label)
	variation_option.selected = 1
	for label in ["Menino", "Menina"]:
		gender_option.add_item(label)
	for label in ["Cabelo A", "Cabelo B"]:
		hair_option.add_item(label)
	for label in ["Parado", "Andando"]:
		state_option.add_item(label)

func _connect_controls() -> void:
	for option in [outfit_option, variation_option, gender_option, hair_option, state_option]:
		option.connect("item_selected", self, "_on_selection_changed")
	for input in [outfit_scale_input, head_x_input, head_y_input, head_scale_input, neck_x_input, neck_y_input, neck_width_input, neck_height_input]:
		input.connect("value_changed", self, "_on_value_changed")

func _prepare_character() -> void:
	# The calibration scene instantiates Player.tscn directly; match the
	# normal-clothes overrides used by MainScreen before caching its layout.
	for sprite_name in GAME_NORMAL_SPRITE_POSITIONS:
		var sprite = player.get_node("player_sprites/" + sprite_name)
		sprite.position = GAME_NORMAL_SPRITE_POSITIONS[sprite_name]
		sprite.scale = Vector2(0.25, 0.25)
	player._capture_normal_sprite_layout()
	CharacterController.roupa = _selected_variation()
	if CharacterController.cor_pele == "":
		CharacterController.cor_pele = "#6f4e37"
	CharacterController.expression = "default"
	player.last_weather = Resources.weather

func _selected_gender() -> String:
	return "boy" if gender_option.selected == 0 else "girl"

func _selected_variation() -> String:
	return "r1" if variation_option.selected == 0 else "r2"

func _selected_hair() -> String:
	return "a" if hair_option.selected == 0 else "b"

func _is_weather_outfit() -> bool:
	return outfit_option.selected == 1 or outfit_option.selected == 2

func _is_hidratona_run() -> bool:
	return outfit_option.selected == 3

func _is_normal_neck() -> bool:
	return not _is_weather_outfit()

func _selected_accessory() -> String:
	if outfit_option.selected == 1:
		return "Umbrella"
	if outfit_option.selected == 2:
		return "Coat"
	return ""

func _on_selection_changed(_index: int) -> void:
	if _is_hidratona_run() and gender_option.selected != 0:
		gender_option.selected = 0
	var is_run_state = state_option.get_item_count() == 7
	if _is_hidratona_run() != is_run_state:
		state_option.clear()
		if _is_hidratona_run():
			for frame in range(1, 8):
				state_option.add_item("Corrida %d" % frame)
		else:
			for label in ["Parado", "Andando"]:
				state_option.add_item(label)
		state_option.selected = 0
	_load_head_controls()
	_update_tuning_controls_enabled()
	_apply_preview()

func _on_value_changed(_value: float) -> void:
	if updating_controls or tuning == null:
		return
	if _is_hidratona_run():
		run_tuning.head_offsets[state_option.selected] = Vector2(head_x_input.value, head_y_input.value)
		run_tuning.body_scale = outfit_scale_input.value
		run_tuning.head_scale = head_scale_input.value
		run_tuning.neck_offset = Vector2(neck_x_input.value, neck_y_input.value)
		run_tuning.neck_size = Vector2(neck_width_input.value, neck_height_input.value)
		_apply_preview()
		_set_status("Alterações ainda não salvas.", Color("#ffd166"))
		return
	tuning.outfit_scale = outfit_scale_input.value
	var positions = tuning.head_positions if _is_weather_outfit() else tuning.normal_r2_head_positions if _selected_variation() == "r2" else tuning.normal_head_positions
	var scales = tuning.head_scales if _is_weather_outfit() else tuning.normal_r2_head_scales if _selected_variation() == "r2" else tuning.normal_head_scales
	var head_key = "%s-%s" % [_selected_gender(), _selected_hair()]
	positions[head_key] = Vector2(head_x_input.value, head_y_input.value)
	scales[head_key] = head_scale_input.value
	if _is_normal_neck():
		var gender = _selected_gender()
		var neck_key = "%s-%s" % [_selected_variation(), gender]
		tuning.normal_neck_offsets[neck_key] = Vector2(neck_x_input.value, neck_y_input.value)
		tuning.normal_neck_sizes[neck_key] = Vector2(neck_width_input.value, neck_height_input.value)
	_apply_preview()
	_set_status("Alterações ainda não salvas.", Color("#ffd166"))

func _apply_preview() -> void:
	if tuning == null:
		return
	player.visible = not _is_hidratona_run()
	hidratona_run.visible = _is_hidratona_run()
	if _is_hidratona_run():
		_apply_hidratona_run_preview()
		return
	var gender = _selected_gender()
	CharacterController.genero = gender
	CharacterController.boyorgirl = "Boy" if gender == "boy" else "Girl"
	CharacterController.roupa = _selected_variation()
	CharacterController.cabelo = _selected_hair()
	CharacterController.all_sprites.plataform = CharacterController.Load_Plataform()
	Resources.acessory = _selected_accessory()
	player.set_weather_outfit_tuning(tuning)
	player.apply_visual_consistency()
	if state_option.selected == 0:
		player.Idle()
	else:
		player.Walk_to_Right()

func _load_head_controls() -> void:
	if tuning == null:
		return
	updating_controls = true
	if _is_hidratona_run():
		var offset = run_tuning.head_offsets[state_option.selected]
		outfit_scale_input.value = run_tuning.body_scale
		head_x_input.value = offset.x
		head_y_input.value = offset.y
		head_scale_input.value = run_tuning.head_scale
		neck_x_input.value = run_tuning.neck_offset.x
		neck_y_input.value = run_tuning.neck_offset.y
		neck_width_input.value = run_tuning.neck_size.x
		neck_height_input.value = run_tuning.neck_size.y
		updating_controls = false
		return
	var gender = _selected_gender()
	var hair = _selected_hair()
	var position = tuning.get_head_position(gender, hair) if _is_weather_outfit() else tuning.get_normal_head_position(gender, hair, _selected_variation())
	outfit_scale_input.value = tuning.outfit_scale
	head_x_input.value = position.x
	head_y_input.value = position.y
	head_scale_input.value = tuning.get_head_scale(gender, hair) if _is_weather_outfit() else tuning.get_normal_head_scale(gender, hair, _selected_variation())
	var neck_offset = tuning.get_normal_neck_offset(_selected_variation(), gender)
	var neck_size = tuning.get_normal_neck_size(_selected_variation(), gender)
	neck_x_input.value = neck_offset.x
	neck_y_input.value = neck_offset.y
	neck_width_input.value = neck_size.x
	neck_height_input.value = neck_size.y
	updating_controls = false

func _load_tuning_from_disk() -> void:
	var loaded = ResourceLoader.load(TUNING_PATH, "", true)
	if loaded == null:
		tuning = DEFAULT_TUNING.duplicate()
		_set_status("Não foi possível carregar a configuração.", Color("#ef476f"))
	else:
		tuning = loaded.duplicate()
		_set_status("Configuração carregada.", Color("#8bd450"))
	player.set_weather_outfit_tuning(tuning)
	_load_head_controls()
	_update_tuning_controls_enabled()

func _on_Save_pressed() -> void:
	var error = ResourceSaver.save(HIDRATONA_RUN_PATH, run_tuning) if _is_hidratona_run() else ResourceSaver.save(TUNING_PATH, tuning)
	if error == OK:
		_set_status("Configuração salva no projeto.", Color("#8bd450"))
	else:
		_set_status("Erro ao salvar: código %d." % error, Color("#ef476f"))

func _on_Reload_pressed() -> void:
	_load_tuning_from_disk()
	_load_run_tuning()
	_load_head_controls()
	_apply_preview()

func _update_tuning_controls_enabled() -> void:
	variation_option.disabled = _is_weather_outfit() or _is_hidratona_run()
	gender_option.disabled = _is_hidratona_run()
	neck_controls.visible = _is_normal_neck()
	outfit_scale_input.editable = _is_weather_outfit() or _is_hidratona_run()
	for input in [head_x_input, head_y_input, head_scale_input]:
		input.editable = true
	$Panel/Margin/Controls/Buttons/Save.disabled = false
	if _is_hidratona_run():
		_set_status("Hidratona: ajuste a cabeça e o pescoço em cada quadro da corrida.", Color("#aeb8c5"))
	elif not _is_weather_outfit():
		_set_status("Ajustando %s, cabelo %s, roupa normal (%s)." % [_selected_gender(), _selected_hair(), _selected_variation()], Color("#aeb8c5"))

func _load_run_tuning() -> void:
	run_tuning = ResourceLoader.load(HIDRATONA_RUN_PATH, "", true).duplicate(true)

func _apply_hidratona_run_preview() -> void:
	if run_tuning == null:
		return
	var frame = state_option.selected + 1
	var body = hidratona_run.get_node("Body")
	var head = hidratona_run.get_node("Head")
	var neck = hidratona_run.get_node("Neck")
	body.texture = load(HIDRATONA_RAIN_PATH + "boy_rc_%d.png" % frame)
	body.position = Vector2(9, 46) if frame == 1 else Vector2(-3, 46)
	body.scale = Vector2.ONE * run_tuning.body_scale
	var skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color("#6f4e37")
	var body_material = ShaderMaterial.new()
	body_material.shader = HIDRATONA_BODY_SHADER
	body_material.set_shader_param("target_skin", skin)
	body.material = body_material
	head.texture = CharacterController.get_head_texture_for("boy", _selected_hair())
	var head_material = ShaderMaterial.new()
	head_material.shader = HIDRATONA_HEAD_SHADER
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for("boy", _selected_hair()))
	head_material.set_shader_param("target_skin", skin)
	head.material = head_material
	head.scale = Vector2.ONE * run_tuning.head_scale
	head.position = RUN_HEAD_POSITIONS[frame - 1] + run_tuning.head_offsets[frame - 1]
	neck.rect_position = head.position + run_tuning.neck_offset
	neck.rect_size = run_tuning.neck_size
	neck.color = skin

func _set_status(message: String, color: Color) -> void:
	status_label.text = message
	status_label.modulate = color
