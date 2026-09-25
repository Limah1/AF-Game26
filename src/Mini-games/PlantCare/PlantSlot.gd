extends PanelContainer

signal purchase_requested(slot)
signal state_changed(slot)
signal sell_requested(slot)
signal watering_started
signal watering_stopped
signal plant_matured

const MATURE_STAGE := 3
const STAGE_NAMES := ["Semente", "Broto", "Jovem", "Madura"]
const STAGE_SCALES := [0.45, 0.65, 0.85, 1.0]

export(int) var slot_index := 0
export(int) var unlock_price := 0

var unlocked := false
var plant_data = null
var stage := -1
var water_progress := 0.0
var cooldown_until := 0

var _watering := false
var _water_changed := false

onready var progress_bar: ProgressBar = $Content/ProgressBar
onready var plant_area: Control = $Content/PlantArea
onready var plant_texture: TextureRect = $Content/PlantArea/PlantTexture
onready var status_label: Label = $Content/StatusLabel
onready var sell_button: Button = $Content/SellButton


func _ready() -> void:
	set_process(true)
	_refresh()


func configure(index: int, price: int, is_unlocked: bool) -> void:
	slot_index = index
	unlock_price = max(0, price)
	unlocked = is_unlocked
	_refresh()


func is_empty() -> bool:
	return unlocked and plant_data == null


func can_accept_plant() -> bool:
	return is_empty()


func plant(data) -> void:
	plant_data = data
	stage = 0
	water_progress = 0.0
	cooldown_until = 0
	_watering = false
	_refresh()


func clear_plant() -> void:
	plant_data = null
	stage = -1
	water_progress = 0.0
	cooldown_until = 0
	_watering = false
	_refresh()


func set_planting_progress(value: float) -> void:
	if not is_empty():
		return
	progress_bar.visible = value > 0.0
	progress_bar.value = clamp(value, 0.0, 1.0) * 100.0
	status_label.text = "Mantenha aqui..." if value > 0.0 else "Slot vazio"


func serialize() -> Dictionary:
	if plant_data == null:
		return {}
	return {
		"plant_id": plant_data.id,
		"stage": stage,
		"water_progress": water_progress,
		"cooldown_until": cooldown_until
	}


func restore(data: Dictionary, resource) -> void:
	if resource == null:
		clear_plant()
		return
	plant_data = resource
	stage = int(clamp(int(data.get("stage", 0)), 0, MATURE_STAGE))
	water_progress = clamp(float(data.get("water_progress", 0.0)), 0.0, 1.0)
	cooldown_until = max(0, int(data.get("cooldown_until", 0)))
	_watering = false
	_refresh()


func _process(delta: float) -> void:
	if plant_data == null or stage >= MATURE_STAGE:
		return

	if cooldown_until > OS.get_unix_time():
		status_label.text = "Regue em %ds" % int(ceil(cooldown_until - OS.get_unix_time()))
		return
	elif cooldown_until != 0:
		cooldown_until = 0
		_refresh()

	if not _watering:
		return

	water_progress = min(1.0, water_progress + delta / max(0.1, plant_data.watering_seconds))
	_water_changed = true
	progress_bar.value = water_progress * 100.0
	status_label.text = "Regando..."
	if water_progress >= 1.0:
		_complete_watering()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_handle_press(event.pressed)
	elif event is InputEventScreenTouch:
		_handle_press(event.pressed)
	elif event is InputEventScreenDrag and not Rect2(Vector2.ZERO, rect_size).has_point(event.position):
		_stop_watering()


func _handle_press(pressed: bool) -> void:
	if pressed:
		if _watering:
			return
		if not unlocked:
			emit_signal("purchase_requested", self)
		elif _can_water():
			_watering = true
			_water_changed = false
			emit_signal("watering_started")
	else:
		_stop_watering()


func _can_water() -> bool:
	return unlocked and plant_data != null and stage < MATURE_STAGE and cooldown_until <= OS.get_unix_time()


func _stop_watering() -> void:
	if not _watering:
		return
	_watering = false
	emit_signal("watering_stopped")
	if _water_changed:
		emit_signal("state_changed", self)
	_water_changed = false
	_refresh()


func _complete_watering() -> void:
	_watering = false
	emit_signal("watering_stopped")
	water_progress = 0.0
	stage = min(MATURE_STAGE, stage + 1)
	if stage < MATURE_STAGE:
		cooldown_until = OS.get_unix_time() + int(round(plant_data.wait_seconds))
	else:
		cooldown_until = 0
	_water_changed = false
	_refresh()
	if stage == MATURE_STAGE:
		emit_signal("plant_matured")
	emit_signal("state_changed", self)


func _refresh() -> void:
	if not is_inside_tree():
		return

	plant_texture.visible = plant_data != null
	sell_button.visible = false
	progress_bar.visible = false

	if not unlocked:
		self_modulate = Color(0.62, 0.62, 0.62)
		status_label.text = "Bloqueado\n%d moedas" % unlock_price
		plant_texture.texture = null
		return

	self_modulate = Color.white
	if plant_data == null:
		status_label.text = "Slot vazio"
		plant_texture.texture = null
		plant_texture.material = null
		return

	plant_texture.texture = plant_data.get_stage_texture(stage)
	plant_texture.material = plant_data.create_stage_material(stage)
	call_deferred("_resize_plant")
	if stage >= MATURE_STAGE:
		status_label.text = "%s madura" % plant_data.display_name
		sell_button.text = "Vender +%d" % plant_data.sell_value
		sell_button.visible = true
		return

	progress_bar.visible = true
	progress_bar.value = water_progress * 100.0
	if cooldown_until > OS.get_unix_time():
		status_label.text = "Regue em %ds" % int(ceil(cooldown_until - OS.get_unix_time()))
	else:
		status_label.text = "%s - segure para regar" % STAGE_NAMES[stage]


func _resize_plant() -> void:
	if plant_data == null or stage < 0:
		return
	var size: Vector2 = Vector2(220.5, 199.5) * STAGE_SCALES[stage]
	plant_texture.rect_size = size
	plant_texture.rect_position = (plant_area.rect_size - size) * 0.5


func _on_mouse_exited() -> void:
	_stop_watering()


func _on_SellButton_pressed() -> void:
	emit_signal("sell_requested", self)
