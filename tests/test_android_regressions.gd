extends Node

var failures = 0

func _ready():
	call_deferred("_run")

func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)

func _character(gender: String, hair: String, outfit: String, skin: String) -> void:
	CharacterController.boyorgirl = "Boy" if gender == "boy" else "Girl"
	CharacterController.genero = gender
	CharacterController.cabelo = hair
	CharacterController.roupa = outfit
	CharacterController.cor_pele = skin
	NewCharData.cor_pele = skin
	CharacterController.all_sprites.plataform = CharacterController.Load_Plataform()
	CharacterController.all_sprites.match3 = CharacterController.Load_Match3()
	CharacterController.all_sprites.hidratona = CharacterController.Load_Hidratona()
	ModularCharacterData.set_gender(gender)
	ModularCharacterData.cor_pele = Color(skin)

func _open(path: String):
	var scene = load(path).instance()
	get_tree().get_root().add_child(scene)
	get_tree().current_scene = scene
	get_tree().paused = false
	return scene

func _close(scene) -> void:
	scene.queue_free()
	get_tree().current_scene = self
	get_tree().paused = false

func _capture(label: String) -> void:
	var folder = OS.get_environment("ANDROID_CAPTURE")
	if folder.empty():
		return
	Directory.new().make_dir_recursive(folder)
	VisualServer.force_draw()
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	_check(image.save_png(folder.plus_file(label + ".png")) == OK, "Screenshot failed: " + label)

func _run():
	NecessityBars.started = false
	NecessityBars.higiene = 900
	Resources.acessory = ""
	Resources.weather = "Sunny"
	for gender in ["boy", "girl"]:
		for hair in ["a", "b"]:
			for outfit in ["r1", "r2"]:
				_character(gender, hair, outfit, "#8d5524")
				var house = _open("res://src/MainScreen.tscn")
				yield(get_tree().create_timer(0.2), "timeout")
				var house_player = house.get_node("Player/Player")
				var body_position = house_player.get_node("player_sprites/idle").position
				var head_position = house_player.legacy_head.position
				var neck_position = house_player.skin_tone_rect.rect_position
				_close(house)
				yield(get_tree(), "idle_frame")
				var hospital = _open("res://src/Hospital.tscn")
				yield(get_tree().create_timer(0.2), "timeout")
				var player = hospital.get_node("Player/Player")
				_check(player.get_node("player_sprites/idle").position.is_equal_approx(body_position), "Hospital body differs from house")
				_check(player.legacy_head.position.is_equal_approx(head_position), "Hospital head differs from house")
				_check(player.skin_tone_rect.rect_position.is_equal_approx(neck_position), "Hospital neck differs from house")
				_check(not hospital.get_node("Pause/AudioSettingsPanel").visible, "Audio overlay captures input at startup")
				_capture("hospital-%s-%s-%s" % [gender, hair, outfit])
				_close(hospital)
				yield(get_tree(), "idle_frame")

	for gender in ["boy", "girl"]:
		for hair in ["a", "b"]:
			_character(gender, hair, "r1", "#8d5524")
			for name in ["Tab_3x3", "Tab_6x6", "Tab_9x9", "Win"]:
				var board = _open("res://src/Mini-games/Match-3/src/Levels/%s.tscn" % name)
				for child in board.get_children():
					if child is CanvasLayer and child.get_script() == load("res://src/Mini-games/Match-3/src/GUI/Show_Which_Fruit.gd"):
						child.queue_free()
				get_tree().paused = false
				yield(get_tree(), "idle_frame")
				var neck = board.get_node("SkinToneRect")
				_check(neck.visible and neck.get_stylebox("panel").bg_color == Color("#8d5524"), "Match-3 neck missing or wrong color: " + name)
				_check(neck.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Neck intercepts touch")
				_capture("%s-%s-%s" % [name, gender, hair])
				if name == "Tab_3x3":
					board.set_physics_process(false)
					board.start = 3
					board.tutorial_stopped = true
					board.Ordem = []
					for tile in board.alltiles:
						tile.set_physics_process(false)
					board.instance_timer = 0.0
					board._physics_process(0.1)
					for tile in board.AllTiles[0]:
						_check(is_instance_valid(tile.fruit), "Tutorial refill failed after scripted rows ended")
				if name == "Win":
					_close(board)
					yield(get_tree(), "idle_frame")
					S_Conntroller.last_result_won = false
					board = _open("res://src/Mini-games/Match-3/src/Levels/Win.tscn")
					yield(get_tree(), "idle_frame")
					_check(board.get_node("SkinToneRect").rect_position == board.defeat_neck_position, "Defeat neck not aligned")
					_capture("defeat-%s-%s" % [gender, hair])
				_close(board)
				yield(get_tree(), "idle_frame")

	_character("boy", "a", "r1", "#8d5524")
	AnimationController.status = "Bathroom"
	var house = _open("res://src/MainScreen.tscn")
	yield(get_tree(), "idle_frame")
	var bathroom = house.get_node("Slots/Slot2").current_room
	_check(bathroom.room_id == 4, "Bathroom not selected")
	for action in ["bath", "teeth", "hands"]:
		for complete in [false, true]:
			NecessityBars.soaked = false
			AnimationController.anim_player.stop()
			if action == "bath":
				bathroom._on_bath_pressed()
			else:
				bathroom.WashingHands = action == "hands"
				bathroom._on_sink_pressed()
			_check(not house.get_node("NecessityManager").is_processing(), "Navigation not hidden during " + action)
			_check(not house.get_node("NecessityManager/ColorRect").visible, "Hidden menu still intercepts minigame input")
			var game = bathroom.get_child(bathroom.get_child_count() - 1)
			if action == "bath":
				var steps = game.get_node("Passos")
				if complete:
					steps._on_Button_pressed()
				else:
					steps._on_TextureButton_pressed()
			elif action == "teeth":
				if complete:
					game._on_BtnConcluir_pressed()
				else:
					game._on_BtnClose_pressed()
			else:
				if complete:
					game.finished = true
					game._on_return_to_bathroom_pressed()
				else:
					game._on_exit_pressed()
			yield(get_tree().create_timer(4.0), "timeout")
			_check(not is_instance_valid(game), "Minigame overlay survived exit: " + action)
			_check(not bathroom.is_doing_action and not NecessityBars.onbath and not NecessityBars.bathing, "Minigame lock survived exit: " + action)
			_check(house.get_node("Player").visible and house.get_node("NecessityManager").layer > 0, "UI/player not restored: " + action)
			_check(not house.get_node("NecessityManager").check_if_can_press_button(), "Navigation blocked after " + action)
			var menu = house.get_node("NecessityManager")
			menu._on_MenuButton_pressed()
			_check(menu.get_node("MapContainer").visible, "Map did not reopen after " + action)
			menu._on_MenuButton_pressed()
			NecessityBars.soaked = true
			bathroom._on_sink_pressed()
			_check(not bathroom.is_doing_action, "Foam restriction was removed")
	NecessityBars.soaked = false
	bathroom._on_bath_pressed()
	var interrupted_bath = bathroom.get_child(bathroom.get_child_count() - 1)
	interrupted_bath.get_node("Passos")._on_TextureButton_pressed()
	AnimationController.anim_player.stop()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	_check(not bathroom.is_doing_action and not NecessityBars.onbath, "Interrupted bath return retained locks")
	_check(not house.get_node("NecessityManager").check_if_can_press_button(), "Interrupted animation blocked navigation")
	NecessityBars.peeing = true
	bathroom.finish_escovar()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	_check(NecessityBars.peeing and house.get_node("NecessityManager").check_if_can_press_button(), "Toilet restriction was removed")
	NecessityBars.peeing = false
	_close(house)
	yield(get_tree(), "idle_frame")

	var loop_path = "user://android-voice-%d.tres" % OS.get_ticks_usec()
	var sample = AudioStreamSample.new()
	sample.mix_rate = 44100
	sample.loop_mode = AudioStreamSample.LOOP_FORWARD
	sample.loop_end = 4410
	var data = PoolByteArray()
	data.resize(4410)
	sample.data = data
	_check(ResourceSaver.save(loop_path, sample) == OK, "Could not create test audio")
	var shared_sample = load(loop_path)
	_check(VoiceManager.play_path(loop_path), "Voice refused valid sample")
	_check(VoiceManager._player.stream.loop_mode == AudioStreamSample.LOOP_DISABLED, "Voice sample still loops")
	_check(shared_sample.loop_mode == AudioStreamSample.LOOP_FORWARD, "Shared audio resource was changed")
	yield(get_tree().create_timer(0.3), "timeout")
	_check(not VoiceManager.is_playing(), "Voice did not finish naturally")
	var dialog = _open("res://src/UI/Dialog.tscn")
	dialog.start_conversation({"texto": "Test", "voice": loop_path, "opcao1": {"botao": "Next", "resposta": "Next"}}, false)
	dialog._on_voice_button_pressed()
	dialog._on_choice(1)
	_check(not VoiceManager.is_playing(), "Previous answer voice continued")
	dialog.start_conversation({"texto": "Test", "voice": loop_path}, false)
	dialog._on_voice_button_pressed()
	dialog._on_popup_hide()
	_check(not VoiceManager.is_playing(), "Voice survived popup closure")
	dialog.start_conversation({"texto": "Test", "voice": loop_path}, false)
	dialog._on_voice_button_pressed()
	dialog.free()
	_check(not VoiceManager.is_playing(), "Voice survived scene exit")
	Directory.new().remove(loop_path)
	var ogg_path = "res://src/Assets/Audio/Voice/Hospital/Pediatrician/choice1.ogg"
	var shared_ogg = load(ogg_path)
	var was_looping = shared_ogg.loop
	shared_ogg.loop = true
	_check(VoiceManager.play_path(ogg_path), "Voice refused OGG")
	_check(not VoiceManager._player.stream.loop and shared_ogg.loop, "OGG voice loop mutated its shared resource")
	VoiceManager.stop()
	shared_ogg.loop = was_looping
	get_tree().current_scene = self

	var floor_holder = Node2D.new()
	var floor_node = Node2D.new()
	floor_node.name = "floor"
	floor_holder.add_child(floor_node)
	add_child(floor_holder)
	for skin in ["#dfcaab", "#8d5524", "#c68642"]:
		CharacterController.cor_pele = skin
		for accessory in ["", "Umbrella", "Coat"]:
			Resources.acessory = accessory
			var player = load("res://src/Mini-games/Hidratona/src/Actor/Player.tscn").instance()
			player.use_modular_character = false
			floor_holder.add_child(player)
			player.set_physics_process(false)
			for frame in ["j1", "j2"]:
				var sprite = player.get_node("AllSprites/" + frame)
				_check(sprite.material.get_shader_param("target_skin") == Color(skin), "Jump skin not assigned")
				_check(sprite.material.get_shader_param("source_skin") == Color("#dfcaab"), "Jump shader does not match source pixels")
			player.free()
	Resources.acessory = ""
	CharacterController.cor_pele = "#8d5524"
	floor_holder.queue_free()
	var tutorial = _open("res://src/Mini-games/Hidratona/src/level/Tutorial.tscn")
	var tutorial_player = tutorial.get_node("Player")
	tutorial_player._set_modular_state(5)
	_check(tutorial_player.use_modular_character, "Tutorial character mode changed")
	_check(tutorial_player.modular_rig.rig_left_arm.modulate == Color("#8d5524"), "Tutorial jump lost its skin tone")
	_close(tutorial)
	yield(get_tree(), "idle_frame")

	var loading = _open("res://src/UI/Loading.tscn")
	_check(loading.loader != null, "Loading screen has no loader")
	for unused in range(60):
		if get_tree().current_scene != loading:
			break
		yield(get_tree(), "idle_frame")
	var resumed = get_tree().current_scene
	_check(resumed != null and resumed.filename == "res://src/MainScreen.tscn", "Loading did not reach the house")
	_check(CharacterController.cor_pele == "#8d5524", "Loading changed the character")
	_close(resumed)
	yield(get_tree(), "idle_frame")

	AnimationController.anim_player = null
	AnimationController.is_travelling = false
	var yard = _open("res://src/UI/Rooms/Yard.tscn")
	AnimationController.current_room = yard
	var button = yard.get_node("PlantCareButton")
	_check(button.get_global_rect().has_point(yard.get_node("PlantCare").position), "Flower outside touch target")
	_check(button.is_connected("pressed", yard, "_on_PlantCareButton_pressed"), "Flower button not connected")
	button.emit_signal("pressed")
	_check(button.disabled, "Repeated flower input allowed")
	yield(get_tree(), "idle_frame")
	var garden = get_tree().current_scene
	if garden != null and garden != yard:
		garden._loaded = false # Never write the player's garden save.
		_check(garden.filename.ends_with("PlantCareMenu.tscn"), "Flower opened wrong scene")
		_close(garden)
	else:
		_check(false, "Flower did not open garden")
		_close(yard)
	yield(get_tree(), "idle_frame")
	print("Android regression checks: ", "PASS" if failures == 0 else "%d failures" % failures)
	get_tree().quit(0 if failures == 0 else 1)
