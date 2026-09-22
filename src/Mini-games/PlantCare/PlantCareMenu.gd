extends Control

const SAVE_PATH := "user://plant_care.save"
const SAVE_VERSION := 1
const PLANT_HOLD_SECONDS := 1.5
const STATIONARY_TOLERANCE := 12.0

export(int, 0, 1000000) var initial_coins := 100
export(Array, int) var slot_costs = [0, 0, 50, 75, 100, 150, 200, 300]
export(Array, Resource) var plant_catalog = []

var coins := 0
var slots := []
var pending_purchase = null

var dragged_plant = null
var drag_position := Vector2.ZERO
var hover_slot = null
var hover_anchor := Vector2.ZERO
var hover_time := 0.0
var _loaded := false
var _last_drag_issue := ""
var _card_font: DynamicFont

onready var plant_list: VBoxContainer = $Sidebar/Margin/Content/PlantList
onready var coins_label: Label = $TopBar/CoinsLabel
onready var message_label: Label = $MessageLabel
onready var drag_preview: TextureRect = $DragPreview
onready var purchase_dialog: ConfirmationDialog = $PurchaseDialog
onready var message_timer: Timer = $MessageTimer
onready var watering_sound: AudioStreamPlayer = $WateringSound


func _ready() -> void:
	BackgroundMusic.stop_music()
	_card_font = DynamicFont.new()
	_card_font.font_data = load("res://assets/fonts/Raleway-Medium.ttf")
	_card_font.size = 23
	purchase_dialog.get_ok().text = "Comprar"
	purchase_dialog.get_cancel().text = "Cancelar"
	coins = initial_coins
	slots = $GardenPanel/Margin/Grid.get_children()
	assert(slots.size() == 8)
	assert(plant_catalog.size() == 5)
	_build_plant_list()
	_configure_slots()
	_load_game()
	_update_coins()
	_loaded = true


func _exit_tree() -> void:
	if _loaded:
		_save_game()


func _process(delta: float) -> void:
	if dragged_plant == null:
		return
	drag_preview.rect_position = drag_position - drag_preview.rect_size * 0.5
	_update_drag_target(delta)


func _input(event: InputEvent) -> void:
	if dragged_plant == null:
		return
	if event is InputEventMouseMotion:
		drag_position = event.position
	elif event is InputEventScreenDrag:
		drag_position = event.position
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		_cancel_drag()
	elif event is InputEventScreenTouch:
		drag_position = event.position
		if not event.pressed:
			_cancel_drag()


func _build_plant_list() -> void:
	for child in plant_list.get_children():
		child.queue_free()

	for data in plant_catalog:
		if data == null:
			continue
		var card := Button.new()
		card.rect_min_size = Vector2(292, 130)
		card.focus_mode = Control.FOCUS_NONE
		card.connect("gui_input", self, "_on_plant_card_gui_input", [data, card])
		plant_list.add_child(card)

		var row := HBoxContainer.new()
		row.set_anchors_and_margins_preset(Control.PRESET_WIDE)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_constant_override("separation", 12)
		card.add_child(row)

		var icon := TextureRect.new()
		icon.rect_min_size = Vector2(112, 112)
		icon.texture = data.icon
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(icon)

		var text := Label.new()
		text.rect_min_size = Vector2(155, 112)
		text.text = "%s\n%d moedas" % [data.display_name, data.plant_cost]
		text.add_font_override("font", _card_font)
		text.align = Label.ALIGN_CENTER
		text.valign = Label.VALIGN_CENTER
		text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(text)


func _configure_slots() -> void:
	for index in range(slots.size()):
		var price := int(slot_costs[index]) if index < slot_costs.size() else 0
		var slot = slots[index]
		slot.configure(index, price, index < 2)
		slot.connect("purchase_requested", self, "_on_slot_purchase_requested")
		slot.connect("state_changed", self, "_on_slot_state_changed")
		slot.connect("sell_requested", self, "_on_slot_sell_requested")
		slot.connect("watering_started", self, "_on_watering_started")
		slot.connect("watering_stopped", self, "_on_watering_stopped")


func _on_plant_card_gui_input(event: InputEvent, data, card: Control) -> void:
	if dragged_plant != null:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		_begin_drag(data, get_viewport().get_mouse_position())
	elif event is InputEventScreenTouch and event.pressed:
		_begin_drag(data, card.rect_global_position + event.position)


func _begin_drag(data, position: Vector2) -> void:
	dragged_plant = data
	drag_position = position
	drag_preview.texture = data.icon
	drag_preview.visible = true
	_last_drag_issue = ""
	_show_message("Arraste para um slot vazio e segure por 1,5s")


func _update_drag_target(delta: float) -> void:
	var candidate = null
	for slot in slots:
		if slot.get_global_rect().has_point(drag_position):
			candidate = slot
			break

	if candidate != hover_slot:
		_clear_hover_slot()
		hover_slot = candidate
		hover_anchor = drag_position
		hover_time = 0.0
	elif candidate != null and drag_position.distance_to(hover_anchor) > STATIONARY_TOLERANCE:
		candidate.set_planting_progress(0.0)
		hover_anchor = drag_position
		hover_time = 0.0

	if candidate == null:
		return
	if not candidate.can_accept_plant():
		_show_drag_issue("Esse slot não está disponível")
		return
	if coins < dragged_plant.plant_cost:
		_show_drag_issue("Saldo insuficiente")
		return

	_last_drag_issue = ""
	hover_time += delta
	candidate.set_planting_progress(hover_time / PLANT_HOLD_SECONDS)
	if hover_time >= PLANT_HOLD_SECONDS:
		coins -= dragged_plant.plant_cost
		candidate.plant(dragged_plant)
		_update_coins()
		_show_message("%s plantada!" % dragged_plant.display_name)
		_save_game()
		_cancel_drag()


func _show_drag_issue(text: String) -> void:
	if _last_drag_issue == text:
		return
	_last_drag_issue = text
	_show_message(text)


func _clear_hover_slot() -> void:
	if hover_slot != null and is_instance_valid(hover_slot):
		hover_slot.set_planting_progress(0.0)
	hover_slot = null
	hover_time = 0.0


func _cancel_drag() -> void:
	_clear_hover_slot()
	dragged_plant = null
	drag_preview.visible = false
	_last_drag_issue = ""


func _on_slot_purchase_requested(slot) -> void:
	if pending_purchase != null or slot.unlocked:
		return
	pending_purchase = slot
	purchase_dialog.dialog_text = "Desbloquear este slot por %d moedas?" % slot.unlock_price
	purchase_dialog.popup_centered(Vector2(560, 250))


func _on_PurchaseDialog_confirmed() -> void:
	if pending_purchase == null:
		return
	if coins < pending_purchase.unlock_price:
		_show_message("Saldo insuficiente para desbloquear o slot")
		pending_purchase = null
		return
	coins -= pending_purchase.unlock_price
	pending_purchase.configure(pending_purchase.slot_index, pending_purchase.unlock_price, true)
	_update_coins()
	_show_message("Slot desbloqueado!")
	pending_purchase = null
	_save_game()


func _on_PurchaseDialog_popup_hide() -> void:
	pending_purchase = null


func _on_slot_state_changed(_slot) -> void:
	_save_game()


func _on_slot_sell_requested(slot) -> void:
	if slot.plant_data == null or slot.stage < 3:
		return
	coins += slot.plant_data.sell_value
	var sold_name: String = slot.plant_data.display_name
	slot.clear_plant()
	_update_coins()
	_show_message("%s vendida!" % sold_name)
	_save_game()


func _on_watering_started() -> void:
	if not watering_sound.playing:
		watering_sound.play()


func _on_watering_stopped() -> void:
	watering_sound.stop()


func _update_coins() -> void:
	coins_label.text = "%d moedas" % coins


func _show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true
	message_timer.start()


func _on_MessageTimer_timeout() -> void:
	message_label.visible = false


func _find_plant(plant_id: String):
	for data in plant_catalog:
		if data != null and data.id == plant_id:
			return data
	return null


func _save_game() -> void:
	if slots.empty():
		return
	var unlocked_slots := []
	var slot_states := []
	for slot in slots:
		unlocked_slots.append(slot.unlocked)
		slot_states.append(slot.serialize())
	var data := {
		"version": SAVE_VERSION,
		"coins": coins,
		"unlocked_slots": unlocked_slots,
		"slots": slot_states
	}
	var file := File.new()
	if file.open(SAVE_PATH, File.WRITE) == OK:
		file.store_line(to_json(data))
		file.close()


func _load_game() -> void:
	var file := File.new()
	if not file.file_exists(SAVE_PATH) or file.open(SAVE_PATH, File.READ) != OK:
		return
	var parsed = parse_json(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY or int(parsed.get("version", 0)) != SAVE_VERSION:
		return

	coins = max(0, int(parsed.get("coins", initial_coins)))
	var unlocked_slots = parsed.get("unlocked_slots", [])
	var saved_slots = parsed.get("slots", [])
	for index in range(slots.size()):
		var unlocked := index < 2
		if typeof(unlocked_slots) == TYPE_ARRAY and index < unlocked_slots.size():
			unlocked = bool(unlocked_slots[index]) or index < 2
		var price := int(slot_costs[index]) if index < slot_costs.size() else 0
		slots[index].configure(index, price, unlocked)

		if typeof(saved_slots) != TYPE_ARRAY or index >= saved_slots.size():
			continue
		var slot_data = saved_slots[index]
		if typeof(slot_data) != TYPE_DICTIONARY or not slot_data.has("plant_id"):
			continue
		var plant = _find_plant(str(slot_data.get("plant_id", "")))
		if plant != null:
			slots[index].restore(slot_data, plant)


func _on_BackButton_pressed() -> void:
	_save_game()
	AnimationController.status = "MainGame"
	get_tree().change_scene("res://src/MainScreen.tscn")
