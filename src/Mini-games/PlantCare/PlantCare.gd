extends Node2D

enum PlantState { EMPTY, SEED, SPROUT, YOUNG, ADULT }

var plant_state = PlantState.EMPTY
var water_level := 100.0
var growth_level := 0.0

const WATER_DRAIN := 7.0
const GROWTH_RATE := 5.0
const LOW_WATER := 20.0

const SW := 1920
const SH := 1080
const CX := 960
const SOIL_Y := 760
const SOIL_W := 320
const SOIL_H := 55

var is_dead := false
var game_won := false

var plant_stem: ColorRect
var plant_top: ColorRect
var water_bar: ProgressBar
var growth_bar: ProgressBar
var status_label: Label
var plant_btn: Button
var water_btn: Button
var water_particles: CPUParticles2D

var _font_data: DynamicFontData


func _ready():
	_font_data = load("res://assets/fonts/PottaOne-Regular.ttf")
	_build_scene()


func _make_font(size: int) -> DynamicFont:
	var df := DynamicFont.new()
	df.font_data = _font_data
	df.size = size
	return df


func _make_btn_style(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_corner_radius_all(14)
	s.set_border_width_all(4)
	s.border_color = color.lightened(0.28)
	s.content_margin_left = 20
	s.content_margin_right = 20
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s


func _make_styled_button(txt: String, pos: Vector2, size: Vector2,
		method: String, col: Color) -> Button:
	var btn := Button.new()
	btn.text = txt
	btn.rect_position = pos
	btn.rect_size = size
	btn.add_font_override("font", _make_font(42))
	btn.add_stylebox_override("normal", _make_btn_style(col))
	var hov := _make_btn_style(col.lightened(0.14))
	btn.add_stylebox_override("hover", hov)
	var pre := _make_btn_style(col.darkened(0.18))
	btn.add_stylebox_override("pressed", pre)
	var dis := _make_btn_style(Color(0.35, 0.35, 0.35))
	btn.add_stylebox_override("disabled", dis)
	btn.connect("pressed", self, method)
	return btn


func _style_bar(bar: ProgressBar, fill_col: Color) -> void:
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_col
	fill.set_corner_radius_all(6)
	bar.add_stylebox_override("fill", fill)
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.08, 0.08, 0.12, 0.75)
	bg.set_corner_radius_all(6)
	bar.add_stylebox_override("background", bg)


func _build_scene():
	# Sky
	var sky := ColorRect.new()
	sky.rect_size = Vector2(SW, SH)
	sky.color = Color(0.45, 0.75, 0.95)
	add_child(sky)

	# Ground
	var ground := ColorRect.new()
	ground.rect_size = Vector2(SW, 380)
	ground.rect_position = Vector2(0, SH - 380)
	ground.color = Color(0.28, 0.55, 0.12)
	add_child(ground)

	# Dirt strip
	var dirt := ColorRect.new()
	dirt.rect_size = Vector2(SW, 65)
	dirt.rect_position = Vector2(0, SOIL_Y - 5)
	dirt.color = Color(0.40, 0.24, 0.08)
	add_child(dirt)

	# Soil patch
	var soil := ColorRect.new()
	soil.rect_size = Vector2(SOIL_W, SOIL_H)
	soil.rect_position = Vector2(CX - SOIL_W / 2, SOIL_Y)
	soil.color = Color(0.52, 0.32, 0.10)
	add_child(soil)

	_add_deco_plant(180, SOIL_Y)
	_add_deco_plant(260, SOIL_Y)
	_add_deco_plant(1660, SOIL_Y)
	_add_deco_plant(1740, SOIL_Y)

	# Plant stem
	plant_stem = ColorRect.new()
	plant_stem.visible = false
	add_child(plant_stem)

	# Plant leaves
	plant_top = ColorRect.new()
	plant_top.visible = false
	add_child(plant_top)

	# Water particles (shower effect)
	water_particles = CPUParticles2D.new()
	water_particles.emitting = false
	water_particles.amount = 28
	water_particles.lifetime = 0.6
	water_particles.one_shot = true
	water_particles.explosiveness = 0.05
	water_particles.emission_shape = 2  # RECTANGLE
	water_particles.emission_rect_extents = Vector2(22, 1)
	water_particles.direction = Vector2(0, 1)
	water_particles.spread = 18.0
	water_particles.gravity = Vector2(0, 240)
	water_particles.initial_velocity = 70.0
	water_particles.scale_amount = 2.2
	water_particles.color = Color(0.27, 0.63, 1.0, 0.85)
	water_particles.texture = load("res://assets/Match-3/circle.png")
	water_particles.position = Vector2(CX, SOIL_Y - 80)
	add_child(water_particles)

	# UI layer
	var ui := CanvasLayer.new()
	add_child(ui)

	var lbl_font_data: DynamicFontData = load("res://assets/fonts/Raleway-Medium.ttf")

	# Top panel (status)
	var top_panel := ColorRect.new()
	top_panel.rect_size = Vector2(SW, 148)
	top_panel.color = Color(0.10, 0.28, 0.06, 0.85)
	ui.add_child(top_panel)

	# Status label — Raleway 40px, legível para criança
	var lbl_font_status := DynamicFont.new()
	lbl_font_status.font_data = lbl_font_data
	lbl_font_status.size = 40

	status_label = Label.new()
	status_label.rect_position = Vector2(CX - 560, 10)
	status_label.rect_size = Vector2(1120, 128)
	status_label.align = Label.ALIGN_CENTER
	status_label.valign = Label.VALIGN_CENTER
	status_label.add_font_override("font", lbl_font_status)
	status_label.add_color_override("font_color", Color(0.92, 0.98, 0.72))
	status_label.text = "Clique 'Plantar' para começar!"
	status_label.autowrap = true
	ui.add_child(status_label)

	# Water bar panel — Raleway 30px
	var lbl_font_bar := DynamicFont.new()
	lbl_font_bar.font_data = lbl_font_data
	lbl_font_bar.size = 30

	var wp := ColorRect.new()
	wp.rect_position = Vector2(30, 158)
	wp.rect_size = Vector2(380, 160)
	wp.color = Color(0.08, 0.08, 0.15, 0.78)
	ui.add_child(wp)

	var wlbl := Label.new()
	wlbl.rect_position = Vector2(45, 164)
	wlbl.rect_size = Vector2(350, 50)
	wlbl.add_font_override("font", lbl_font_bar)
	wlbl.add_color_override("font_color", Color(0.55, 0.82, 1.0))
	wlbl.text = "Agua da planta"
	ui.add_child(wlbl)

	water_bar = ProgressBar.new()
	water_bar.rect_position = Vector2(45, 218)
	water_bar.rect_size = Vector2(350, 50)
	water_bar.max_value = 100
	water_bar.value = 100
	_style_bar(water_bar, Color(0.22, 0.55, 1.0))
	ui.add_child(water_bar)

	# Growth bar panel
	var gp := ColorRect.new()
	gp.rect_position = Vector2(SW - 410, 158)
	gp.rect_size = Vector2(380, 160)
	gp.color = Color(0.08, 0.08, 0.15, 0.78)
	ui.add_child(gp)

	var glbl := Label.new()
	glbl.rect_position = Vector2(SW - 395, 164)
	glbl.rect_size = Vector2(350, 50)
	glbl.add_font_override("font", lbl_font_bar)
	glbl.add_color_override("font_color", Color(0.55, 1.0, 0.55))
	glbl.text = "Crescimento"
	ui.add_child(glbl)

	growth_bar = ProgressBar.new()
	growth_bar.rect_position = Vector2(SW - 395, 218)
	growth_bar.rect_size = Vector2(350, 50)
	growth_bar.max_value = 100
	growth_bar.value = 0
	_style_bar(growth_bar, Color(0.18, 0.75, 0.22))
	ui.add_child(growth_bar)

	# Bottom button panel
	var bp := ColorRect.new()
	bp.rect_position = Vector2(CX - 360, SH - 170)
	bp.rect_size = Vector2(720, 148)
	bp.color = Color(0.08, 0.22, 0.05, 0.85)
	ui.add_child(bp)

	plant_btn = _make_styled_button(
		"Plantar",
		Vector2(CX - 340, SH - 155),
		Vector2(300, 118),
		"_on_plant_pressed",
		Color(0.42, 0.62, 0.15)
	)
	ui.add_child(plant_btn)

	water_btn = _make_styled_button(
		"Regar",
		Vector2(CX + 40, SH - 155),
		Vector2(300, 118),
		"_on_water_pressed",
		Color(0.18, 0.48, 0.82)
	)
	water_btn.disabled = true
	ui.add_child(water_btn)

	var back_btn := _make_styled_button(
		"Sair",
		Vector2(30, 25),
		Vector2(130, 65),
		"_on_back_pressed",
		Color(0.35, 0.18, 0.08)
	)
	ui.add_child(back_btn)


func _round_panel(_rect: ColorRect) -> void:
	pass  # ColorRect no Godot 3 nao tem border-radius nativo; visual ok sem


func _add_deco_plant(x: float, base_y: float) -> void:
	var stem := ColorRect.new()
	stem.rect_size = Vector2(14, 110)
	stem.rect_position = Vector2(x - 7, base_y - 110)
	stem.color = Color(0.25, 0.60, 0.14)
	add_child(stem)
	var leaves := ColorRect.new()
	leaves.rect_size = Vector2(80, 60)
	leaves.rect_position = Vector2(x - 40, base_y - 160)
	leaves.color = Color(0.20, 0.70, 0.18)
	add_child(leaves)


func _process(delta: float) -> void:
	if plant_state == PlantState.EMPTY or is_dead or game_won:
		return

	water_level -= WATER_DRAIN * delta
	water_level = clamp(water_level, 0.0, 100.0)
	water_bar.value = water_level

	if water_level > LOW_WATER:
		growth_level += GROWTH_RATE * delta
		growth_level = clamp(growth_level, 0.0, 100.0)
		growth_bar.value = growth_level
		_check_stage()

	if water_level <= 0.0:
		_plant_die()


func _check_stage() -> void:
	var new_state: int
	if growth_level < 25.0:
		new_state = PlantState.SEED
	elif growth_level < 50.0:
		new_state = PlantState.SPROUT
	elif growth_level < 80.0:
		new_state = PlantState.YOUNG
	else:
		new_state = PlantState.ADULT

	if new_state != plant_state:
		plant_state = new_state
		_refresh_visual()

	if plant_state == PlantState.ADULT and not game_won:
		_win()


func _refresh_visual() -> void:
	plant_stem.visible = true
	match plant_state:
		PlantState.SEED:
			plant_stem.rect_size = Vector2(24, 18)
			plant_stem.rect_position = Vector2(CX - 12, SOIL_Y - 18)
			plant_stem.color = Color(0.30, 0.15, 0.05)
			plant_top.visible = false
			status_label.text = "Semente plantada! Regue a planta."
		PlantState.SPROUT:
			plant_stem.rect_size = Vector2(18, 75)
			plant_stem.rect_position = Vector2(CX - 9, SOIL_Y - 75)
			plant_stem.color = Color(0.40, 0.72, 0.22)
			plant_top.rect_size = Vector2(75, 55)
			plant_top.rect_position = Vector2(CX - 38, SOIL_Y - 124)
			plant_top.color = Color(0.32, 0.82, 0.26)
			plant_top.visible = true
			status_label.text = "Broto! Continue regando!"
		PlantState.YOUNG:
			plant_stem.rect_size = Vector2(22, 155)
			plant_stem.rect_position = Vector2(CX - 11, SOIL_Y - 155)
			plant_stem.color = Color(0.28, 0.62, 0.18)
			plant_top.rect_size = Vector2(145, 105)
			plant_top.rect_position = Vector2(CX - 73, SOIL_Y - 250)
			plant_top.color = Color(0.22, 0.75, 0.20)
			plant_top.visible = true
			status_label.text = "Planta jovem! Quase lá!"
		PlantState.ADULT:
			plant_stem.rect_size = Vector2(26, 225)
			plant_stem.rect_position = Vector2(CX - 13, SOIL_Y - 225)
			plant_stem.color = Color(0.22, 0.55, 0.14)
			plant_top.rect_size = Vector2(215, 165)
			plant_top.rect_position = Vector2(CX - 108, SOIL_Y - 380)
			plant_top.color = Color(0.15, 0.68, 0.15)
			plant_top.visible = true


func _plant_die() -> void:
	is_dead = true
	plant_stem.color = Color(0.40, 0.25, 0.08)
	if plant_top.visible:
		plant_top.color = Color(0.45, 0.30, 0.10)
	status_label.text = "Planta morreu de sede... Tente novamente!"
	water_btn.disabled = true
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://src/Mini-games/PlantCare/PlantCareMenu.tscn")


func _win() -> void:
	game_won = true
	status_label.text = "Planta crescida com sucesso! Parabéns!"
	water_btn.disabled = true
	yield(get_tree().create_timer(3.5), "timeout")
	get_tree().change_scene("res://src/MainScreen.tscn")


func _on_plant_pressed() -> void:
	if plant_state != PlantState.EMPTY:
		return
	plant_state = PlantState.SEED
	water_level = 80.0
	growth_level = 0.0
	water_bar.value = water_level
	growth_bar.value = 0
	plant_btn.disabled = true
	water_btn.disabled = false
	_refresh_visual()


func _on_water_pressed() -> void:
	if is_dead or game_won:
		return
	water_level = min(water_level + 38.0, 100.0)
	water_bar.value = water_level
	# Position particles above plant top (or soil if seed)
	var emit_y := SOIL_Y - 30
	if plant_top.visible:
		emit_y = plant_top.rect_position.y - 20
	elif plant_stem.visible:
		emit_y = plant_stem.rect_position.y - 20
	water_particles.position = Vector2(CX, emit_y)
	water_particles.restart()


func _on_back_pressed() -> void:
	get_tree().change_scene("res://src/Mini-games/PlantCare/PlantCareMenu.tscn")
