extends Node

var failures = 0

func _ready():
	call_deferred("_run")

func _check(ok: bool, message: String):
	if not ok:
		failures += 1
		push_error(message)

func _check_player_outfit(player, gender: String, variation: String):
	var tuning = player.weather_outfit_tuning
	var expected_head = tuning.get_normal_head_position(gender, "a", variation)
	_check(player.legacy_head_base_position == expected_head, "Head anchor must follow confirmed outfit: " + gender + " " + variation)
	_check(player.legacy_head.position == expected_head + player.LEGACY_IDLE_WALK_HEAD_OFFSET, "Visible head must follow outfit anchor")
	_check(player.legacy_head.scale == Vector2.ONE * tuning.get_normal_head_scale(gender, "a", variation), "Head scale must follow outfit")
	var body = player.get_node("player_sprites/idle")
	var expected_shader = player.GIRL_R2_BODY_SHADER if gender == "girl" and variation == "r2" else player.BODY_SKIN_SHADER.shader
	_check(body.material.shader == expected_shader, "Body shader must follow outfit")
	_check(body.material.get_shader_param("nova_cor_camisa") == Color(NewCharData.cor_roupa_cima), "Confirmed shirt color must apply live")
	for frame in range(1, 6):
		var walking_body = player.get_node("player_sprites/w%d" % frame)
		_check(walking_body.material.shader == expected_shader, "Walking shader must follow outfit")
		_check(walking_body.material.get_shader_param("nova_cor_camisa") == Color(NewCharData.cor_roupa_cima), "Walking shirt color must follow outfit")
	_check(player.skin_tone_rect.rect_position == expected_head + tuning.get_normal_neck_offset(variation, gender) + player.LEGACY_IDLE_WALK_HEAD_OFFSET, "Neck must follow outfit anchor")

func _run():
	var save_file = File.new()
	var had_save = save_file.file_exists("user://savegame.save")
	var backup = PoolByteArray()
	if had_save:
		save_file.open("user://savegame.save", File.READ)
		backup = save_file.get_buffer(save_file.get_len())
		save_file.close()
	for gender in ["boy", "girl"]:
		NewCharData.genero = gender
		NewCharData.cabelo = "a"
		NewCharData.cor_pele = "#8d5524"
		NewCharData.roupa = "r2"
		NewCharData.cor_roupa_cima = "#ed1b24"
		NewCharData.cor_roupa_baixo = "#724530"
		CharacterController.start()
		Resources.acessory = ""
		AnimationController.status = "ForgotAcessory"
		var house = preload("res://src/MainScreen.tscn").instance()
		get_tree().get_root().add_child(house)
		get_tree().current_scene = house
		yield(get_tree().create_timer(0.3), "timeout")
		AnimationController.anim_player.stop()
		var player = house.get_node("Player/Player")
		player.Idle()
		yield(get_tree(), "idle_frame")
		var room = house.get_node("Slots/Slot2").current_room
		room.get_node("PersonalizationButton").emit_signal("pressed")
		var layer = room.clothes_selector_layer
		var selector = layer.get_child(0)
		_check(get_tree().paused, "Wardrobe must pause room input")
		_check(layer.layer > 128 and not house.get_node("NecessityManager").is_processing(), "Wardrobe must cover pause controls and hide navigation")
		_check(not house.get_node("NecessityManager/left").visible and not house.get_node("NecessityManager/right").visible, "Walking buttons must hide")
		_check(selector.get_node("CancelButton").rect_position.y > selector.get_node("ConfirmButton").rect_position.y + selector.get_node("ConfirmButton").rect_size.y, "Cancel must appear below confirm")
		_check(selector.get_node("LegacyHead").position.y == selector.roupa_2_head_position.y - 70, "Character preview must move up")
		_check(selector.genero == gender and selector.get_node("btn_roupa_2").pressed, "Selected gender and existing clothes must load")
		_check(selector.get_node("btn_roupa_1").texture_normal == selector.get("sprite_btn_roupa_%s_1" % gender), "Gender-specific buttons must load")
		room.get_node("PersonalizationButton").emit_signal("pressed")
		_check(room.clothes_selector_layer == layer, "Duplicate wardrobe must not open")
		selector._on_btn_roupa_1_pressed()
		selector._on_btn_cima_cor_4_pressed()
		selector._on_CancelButton_pressed()
		_check(not get_tree().paused and NewCharData.roupa == "r2" and NewCharData.cor_roupa_cima == "#ed1b24", "Cancel must preserve clothes and release input")
		_check(house.get_node("NecessityManager").layer > 0, "Cancel must restore navigation")
		yield(get_tree(), "idle_frame")
		room._on_PersonalizationButton_pressed()
		selector = room.clothes_selector_layer.get_child(0)
		selector._on_btn_roupa_1_pressed()
		selector._on_btn_cima_cor_4_pressed()
		var capture_path = OS.get_environment("WARDROBE_CAPTURE")
		if capture_path != "":
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			var image = get_viewport().get_texture().get_data()
			image.flip_y()
			image.save_png(capture_path + "/wardrobe-" + gender + ".png")
		selector._on_ConfirmButton_pressed()
		yield(get_tree().create_timer(2), "timeout")
		_check(not get_tree().paused and not is_instance_valid(room.clothes_selector_layer), "Confirm must return to bedroom")
		_check(NewCharData.roupa == "r1" and CharacterController.roupa == "r1", "Outfit must update live")
		save_file.open("user://savegame.save", File.READ)
		var saved_character = {}
		while not save_file.eof_reached():
			var line = save_file.get_line()
			if line.strip_edges() == "":
				continue
			var parsed = JSON.parse(line)
			if parsed.error == OK and parsed.result.get("filename", "") == "NewCharData":
				saved_character = parsed.result
		save_file.close()
		_check(saved_character.get("genero") == gender and saved_character.get("roupa") == "r1" and saved_character.get("cor_roupa_cima") == "#21b24b", "Confirmed outfit must persist with selected gender")
		_check(house.get_node("NecessityManager").layer > 0, "Confirm must restore navigation")
		_check_player_outfit(player, gender, "r1")
		room._on_PersonalizationButton_pressed()
		selector = room.clothes_selector_layer.get_child(0)
		selector._on_btn_roupa_2_pressed()
		selector._on_ConfirmButton_pressed()
		yield(get_tree().create_timer(2), "timeout")
		_check_player_outfit(player, gender, "r2")
		get_tree().current_scene = self
		house.queue_free()
		yield(get_tree(), "idle_frame")
	if had_save:
		save_file.open("user://savegame.save", File.WRITE)
		save_file.store_buffer(backup)
		save_file.close()
	else:
		Directory.new().remove("user://savegame.save")
	# Prevent quit notification from overwriting the restored save with test data.
	NewCharData.genero = ""
	print("Bedroom clothes tests: ", failures, " failures")
	get_tree().quit(failures)
