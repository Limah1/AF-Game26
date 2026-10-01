extends SceneTree

# Godot_v3.3.4-stable_win64.exe --no-window --path . -s tests/test_hospital_home_loading.gd
func _init():
	call_deferred("_run")

func _run():
	var data = get_root().get_node("NewCharData")
	var character = get_root().get_node("CharacterController")
	var animation = get_root().get_node("AnimationController")
	data.genero = "boy"
	data.cabelo = "a"
	data.roupa = "r1"
	data.cor_pele = "#8d5524"
	character.start()
	get_root().get_node("NecessityBars").started = false
	assert(change_scene("res://src/Hospital.tscn") == OK)
	yield(self, "idle_frame")
	yield(self, "idle_frame")
	var menu = current_scene.get_node("NecessityManager")
	animation.anim_player.stop()
	animation.is_travelling = false
	menu._on_MenuButton_pressed()
	assert(menu.get_node("HospitalMapContainer").visible)
	menu.get_node("HospitalMapContainer/Button-5").emit_signal("pressed")
	yield(self, "idle_frame")
	assert(current_scene.filename == "res://src/UI/Loading.tscn")
	assert(current_scene.loader != null)
	for unused in range(120):
		if current_scene.filename != "res://src/UI/Loading.tscn":
			break
		yield(self, "idle_frame")
	assert(current_scene.filename == "res://src/MainScreen.tscn")
	assert(current_scene.get_node("Slots/Slot2").current_room.room_id == 1)
	assert(character.cor_pele == "#8d5524")
	assert(animation.status == "Started")
	print("Hospital -> loading -> casa: PASS")
	quit()
