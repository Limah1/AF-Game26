extends SceneTree

# Godot_v3.3.4-stable_win64.exe --no-window --path . -s tests/test_bathroom_navigation.gd
var failures = 0
var presses = 0

func _init():
	call_deferred("_run")

func _pressed():
	presses += 1

func _check(ok, message):
	if not ok:
		failures += 1
		push_error(message)

func _click(button):
	yield(self, "idle_frame")
	var center = button.get_global_transform_with_canvas().xform(button.rect_size * 0.5)
	var position = get_root().get_final_transform().xform(center)
	for down in [true, false]:
		var event = InputEventMouseButton.new()
		event.button_index = BUTTON_LEFT
		event.position = position
		event.global_position = position
		event.pressed = down
		Input.parse_input_event(event)
		yield(self, "idle_frame")

func _wait_for_navigation(menu):
	for unused in range(120):
		yield(create_timer(0.1), "timeout")
		if not menu.check_if_can_press_button():
			return

func _run():
	var character = get_root().get_node("CharacterController")
	var data = get_root().get_node("NewCharData")
	data.genero = "boy"
	data.cabelo = "a"
	data.roupa = "r1"
	data.cor_pele = "#8d5524"
	character.start()
	var animation = get_root().get_node("AnimationController")
	var needs = get_root().get_node("NecessityBars")
	needs.started = false
	animation.status = "Bathroom"
	change_scene("res://src/MainScreen.tscn")
	yield(self, "idle_frame")
	yield(self, "idle_frame")
	var house = current_scene
	var bathroom = house.get_node("Slots/Slot2").current_room
	var menu = house.get_node("NecessityManager")
	house.toggle_NM(true)
	_check(menu.get_node("left").visible, "Repeated restore hid navigation")
	house.toggle_NM(false)
	house.toggle_NM(false)
	# Processing alone must not prevent hidden controls from recovering.
	menu.set_process(true)
	house.toggle_NM(true)
	_check(menu.is_processing() and menu.get_node("left").visible, "Partial menu state did not recover")
	_check(not menu.get_node("MapContainer").visible, "Restore opened a previously closed map")
	for path in ["MapButton/MenuButton", "left", "right"]:
		menu.get_node(path).connect("pressed", self, "_pressed")
	for path in ["left", "right"]:
		menu.get_node(path).disconnect("pressed", menu, "_on_" + path + "_pressed")
	for action in ["initial", "bath", "teeth", "hands"]:
		animation.anim_player.stop()
		needs.soaked = false
		if action != "initial":
			if action == "bath":
				bathroom._on_bath_pressed()
			else:
				bathroom.WashingHands = action == "hands"
				bathroom._on_sink_pressed()
			var game = bathroom.get_child(bathroom.get_child_count() - 1)
			bathroom._on_toilet_pressed()
			_check(not needs.peeing, "Toilet interrupted " + action)
			yield(_click(house.get_node("Pause/TextureButton")), "completed")
			_check(paused, "Pause did not open during " + action)
			yield(_click(house.get_node("Pause/Pause/play-button")), "completed")
			_check(not paused, "Pause did not resume during " + action)
			# Restoration must use the owning house, even if current_scene changes.
			current_scene = null
			if action == "bath":
				yield(_click(game.get_node("Passos/TextureButton")), "completed")
			elif action == "teeth":
				yield(_click(game.get_node("TelaInicial/ColorRect/BtnStart")), "completed")
				game.finish_minigame()
				yield(create_timer(1.6), "timeout")
				yield(_click(game.get_node("TelaFinal/ColorRect/BtnConcluir")), "completed")
			else:
				yield(_click(game.get_node("ExitButton")), "completed")
			current_scene = house
			yield(create_timer(3.0), "timeout")
			_check(not is_instance_valid(game), "Overlay survived " + action)
		_check(not menu.check_if_can_press_button(), "Navigation locked after " + action)
		yield(_click(menu.get_node("MapButton/MenuButton")), "completed")
		_check(menu.get_node("MapContainer").visible, "Map click failed after " + action)
		yield(_click(menu.get_node("MapButton/MenuButton")), "completed")
		# Observe GUI delivery without starting a room transition.
		for path in ["left", "right"]:
			var before = presses
			yield(_click(menu.get_node(path)), "completed")
			_check(presses == before + 1, path + " click failed after " + action)
		animation.is_travelling = false
	# Exercise the real navigation handlers and room movement as well.
	for path in ["left", "right"]:
		menu.get_node(path).connect("pressed", menu, "_on_" + path + "_pressed")
	for path in ["left", "right"]:
		yield(_click(menu.get_node(path)), "completed")
		_check(animation.is_travelling, path + " did not start travel")
		yield(_wait_for_navigation(menu), "completed")
		var expected_room = 3 if path == "left" else 4
		_check(house.get_node("Slots/Slot2").current_room.room_id == expected_room, path + " did not reach room")
		_check(not menu.check_if_can_press_button(), path + " retained travel lock")
	yield(_click(menu.get_node("MapButton/MenuButton")), "completed")
	yield(_click(menu.get_node("MapContainer/Button-2")), "completed")
	_check(animation.is_travelling, "Map destination did not start travel")
	yield(_wait_for_navigation(menu), "completed")
	_check(house.get_node("Slots/Slot2").current_room.room_id == 2, "Map destination did not reach kitchen")
	_check(not menu.check_if_can_press_button(), "Map retained travel lock")
	print("Bathroom GUI navigation: ", "PASS" if failures == 0 else str(failures) + " failures")
	quit(0 if failures == 0 else 1)
