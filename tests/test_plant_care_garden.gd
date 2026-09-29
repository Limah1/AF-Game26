extends SceneTree

var failures := 0


func _check(value: bool, message: String) -> void:
	if not value:
		failures += 1
		push_error(message)


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	ProjectSettings.set_setting("application/config/name", "PlantCareGardenTest")
	var test_save_path := ProjectSettings.globalize_path("user://plant_care.save")
	Directory.new().make_dir_recursive(ProjectSettings.globalize_path("user://"))
	var test_save_file := File.new()
	if test_save_file.file_exists(test_save_path):
		Directory.new().remove(test_save_path)
	var garden = load("res://src/Mini-games/PlantCare/PlantCareMenu.tscn").instance()
	get_root().add_child(garden)
	garden._loaded = false # The check must not overwrite the player's save.
	yield(self, "idle_frame")
	_check(garden.slots.size() == 8, "Expected eight planting holes")
	for slot in garden.slots:
		_check(Rect2(Vector2.ZERO, Vector2(1920, 1080)).encloses(slot.get_global_rect()), "Planting hole outside the 1920x1080 layout")
	for i in range(garden.slots.size()):
		for j in range(i + 1, garden.slots.size()):
			_check(not garden.slots[i].get_global_rect().intersects(garden.slots[j].get_global_rect()), "Planting holes overlap")
	var screenshot_path := OS.get_environment("PLANTCARE_SCREENSHOT")
	if not screenshot_path.empty():
		VisualServer.force_draw()
		var screenshot := get_root().get_texture().get_data()
		screenshot.flip_y()
		_check(screenshot.save_png(screenshot_path) == OK, "Could not save garden screenshot")
	var watering_screenshot_path := OS.get_environment("PLANTCARE_WATERING_SCREENSHOT")
	if not watering_screenshot_path.empty():
		var garden_slot = garden.slots[0]
		garden_slot.disconnect("state_changed", garden, "_on_slot_state_changed")
		garden_slot.plant(load("res://src/Mini-games/PlantCare/data/plant_1.tres"))
		garden_slot.restore({"stage": 2}, garden_slot.plant_data)
		garden_slot._handle_press(true)
		yield(self, "idle_frame")
		VisualServer.force_draw()
		var watering_screenshot := get_root().get_texture().get_data()
		watering_screenshot.flip_y()
		_check(watering_screenshot.save_png(watering_screenshot_path) == OK, "Could not save watering screenshot")
		garden_slot._handle_press(false)

	garden.coins = 1000
	garden.slots[0].clear_plant()
	garden._begin_drag(garden.plant_catalog[0], garden.slots[0].rect_global_position + garden.slots[0].rect_size * 0.5)
	garden._update_drag_target(1.6)
	_check(garden.slots[0].plant_data != null and garden.coins == 995, "Drag planting failed")
	garden.pending_purchase = garden.slots[3]
	garden._on_PurchaseDialog_confirmed()
	_check(garden.slots[3].unlocked and garden.coins == 920, "Hole purchase failed")
	garden.slots[0].restore({"stage": 3}, garden.plant_catalog[0])
	garden._on_slot_sell_requested(garden.slots[0])
	_check(garden.slots[0].plant_data == null and garden.coins == 930, "Mature plant sale failed")
	var reopened = load("res://src/Mini-games/PlantCare/PlantCareMenu.tscn").instance()
	get_root().add_child(reopened)
	reopened._loaded = false
	_check(reopened.slots[3].unlocked and reopened.slots[0].plant_data == null and reopened.coins == 930, "Garden state did not survive reopening")
	reopened.queue_free()

	var slot = load("res://src/Mini-games/PlantCare/PlantSlot.tscn").instance()
	get_root().add_child(slot)
	slot.configure(0, 0, true)
	slot.plant(load("res://src/Mini-games/PlantCare/data/plant_1.tres"))
	slot._handle_press(true)
	_check(slot.watering_can.visible and slot.water_particles.emitting, "Watering effect did not start")
	slot._handle_press(false)
	_check(not slot.watering_can.visible and not slot.water_particles.emitting, "Watering effect did not stop")
	slot._handle_press(true)
	slot._process(3.1)
	_check(slot.stage == 1 and not slot.watering_can.visible, "Watering did not advance the plant")
	var saved = slot.serialize()
	slot.clear_plant()
	slot.restore(saved, load("res://src/Mini-games/PlantCare/data/plant_1.tres"))
	_check(slot.stage == 1 and slot.cooldown_until == saved.cooldown_until, "Plant state did not restore")
	slot.queue_free()
	garden.queue_free()
	Directory.new().remove(test_save_path)
	print("PlantCare garden checks: ", "PASS" if failures == 0 else "%d failures" % failures)
	quit(0 if failures == 0 else 1)
