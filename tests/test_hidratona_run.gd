extends Node2D

const RAIN_ROOT = "res://assets/SpritesV4/RoupasEspeciais/Chuva/Correndo/"
const SNOW_ROOT = "res://assets/SpritesV4/RoupasEspeciais/Neve/Correndo/"
const POSES = [
	["res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/pular-1.png", "res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/pular-2.png", "res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/agachar.png"],
	["res://src/Mini-games/Hidratona/src/level/rain/rc_j_no_head.png", "res://src/Mini-games/Hidratona/src/level/rain/rc_d_no_head.png", "res://src/Mini-games/Hidratona/src/level/rain/rc_squat_no_head.png"],
	["res://src/Mini-games/Hidratona/src/level/snow/rs_j_no_head.png", "res://src/Mini-games/Hidratona/src/level/snow/rs_d_no_head.png", "res://src/Mini-games/Hidratona/src/level/snow/rs_squat_no_head.png"]
]

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	for gender in ["Boy", "Girl"]:
		CharacterController.boyorgirl = gender
		for ethnicity in ["branco", "negro", "pardo"]:
			CharacterController.etnia = ethnicity
			for variation in ["r1", "r2"]:
				CharacterController.roupa = variation
				var shared_poses = CharacterController.Load_Hidratona()
				assert(shared_poses.jump.j1.resource_path == POSES[0][0])
				assert(shared_poses.jump.j2.resource_path == POSES[0][1])
				assert(shared_poses.squat.resource_path == POSES[0][2])
				assert(shared_poses.rain.squat.resource_path == POSES[1][2])
				assert(shared_poses.snow.squat.resource_path == POSES[2][2])
			var sprites = CharacterController.Load_Hidratona()
			for frame in range(1, 8):
				assert(sprites.rain.run["r%d" % frame].resource_path == RAIN_ROOT + "boy_rc_%d.png" % frame)
				assert(sprites.snow.run["r%d" % frame].resource_path == SNOW_ROOT + "correrneve-%d.png" % frame)
			var character_root = "res://assets/All_Character_Sprites/%s/%s/hidratona-%s/" % [gender, ethnicity, "BOY" if gender == "Boy" else "GIRL"]
			assert(sprites.jump.j1.resource_path == "res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/pular-1.png")
			assert(sprites.jump.j2.resource_path == "res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/pular-2.png")
			assert(sprites.squat.resource_path == "res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/agachar.png")
			assert(sprites.rain.jump.j1.resource_path == "res://src/Mini-games/Hidratona/src/level/rain/rc_j_no_head.png")
			assert(sprites.snow.squat.resource_path == "res://src/Mini-games/Hidratona/src/level/snow/rs_squat_no_head.png")
			assert(sprites.snow.win.resource_path == character_root + "snow/rs_win.png")

	var level = load("res://src/Mini-games/Hidratona/src/level/Level.tscn").instance()
	assert(level.weather_override == 0)
	assert(level.test_gender == "Use current" and level.test_hair == "Use current")
	assert(not level.get_node("Player").use_shared_hidratona_test_body)
	level.free()

	var calibration = load("res://src/Tools/OutfitCalibration.tscn").instance()
	get_tree().get_root().add_child(calibration)
	for outfit in [3, 4, 5]:
		calibration.outfit_option.select(outfit)
		for gender in [0, 1]:
			calibration.gender_option.select(gender)
			for hair in [0, 1]:
				calibration.hair_option.select(hair)
				for frame in range(1, 8):
					calibration._on_selection_changed(0)
					calibration.state_option.select(frame - 1)
					calibration._on_selection_changed(0)
					var expected = RAIN_ROOT + "boy_rc_%d.png" % frame if outfit == 3 else SNOW_ROOT + "correrneve-%d.png" % frame if outfit == 4 else CharacterController.Load_Hidratona().run["r%d" % frame].resource_path
					assert(calibration.hidratona_run.get_node("Body").texture.resource_path == expected)
					assert(calibration.hidratona_run.get_node("Head").position == calibration.run_tunings[outfit].get_head_position(frame))
					var head_folder = "Menino" if gender == 0 else "Menina"
					var head_name = ("boy" if gender == 0 else "girl") + ("1" if hair == 0 else "2")
					assert(calibration.hidratona_run.get_node("Head").texture.resource_path == "res://assets/SpritesV4/Cabecas/%s/%s.png" % [head_folder, head_name])
	var saved_offset = calibration.run_tunings[4].head_offsets[0]
	calibration.run_tunings[4].head_offsets[0] = saved_offset + Vector2(3, 4)
	var temporary_resource = "user://hidratona-calibration-test.tres"
	assert(ResourceSaver.save(temporary_resource, calibration.run_tunings[4]) == OK)
	assert(ResourceLoader.load(temporary_resource, "", true).head_offsets[0] == saved_offset + Vector2(3, 4))
	calibration.run_tunings[4].head_offsets[0] = saved_offset
	var directory = Directory.new()
	assert(directory.remove(temporary_resource) == OK)
	for outfit in [3, 4, 5]:
		calibration.outfit_option.select(outfit)
		calibration._on_selection_changed(0)
		for pose in range(3):
			calibration.state_option.select(pose + 7)
			calibration._on_selection_changed(0)
			assert(calibration.hidratona_run.get_node("Body").texture.resource_path == POSES[0 if outfit == 5 else 1 if outfit == 3 else 2][pose])
			assert(calibration.hidratona_run.get_node("Head").position == calibration.run_tunings[outfit].pose_head_positions[pose])
	var saved_pose = calibration.run_tunings[5].pose_head_positions[0]
	calibration.run_tunings[5].pose_head_positions[0] = saved_pose + Vector2(2, 3)
	assert(ResourceSaver.save(temporary_resource, calibration.run_tunings[5]) == OK)
	assert(ResourceLoader.load(temporary_resource, "", true).pose_head_positions[0] == saved_pose + Vector2(2, 3))
	calibration.run_tunings[5].pose_head_positions[0] = saved_pose
	assert(directory.remove(temporary_resource) == OK)
	if OS.has_environment("HIDRATONA_CAPTURE"):
		for outfit in [3, 4, 5]:
			calibration.outfit_option.select(outfit)
			for frame in range(1, 8):
				calibration._on_selection_changed(0)
				calibration.state_option.select(frame - 1)
				calibration._on_selection_changed(0)
				yield(get_tree(), "idle_frame")
				yield(get_tree(), "idle_frame")
				var screenshot = get_viewport().get_texture().get_data()
				screenshot.flip_y()
				var name = "/rain-%d.png" % frame if outfit == 3 else "/snow-%d.png" % frame if outfit == 4 else "/normal-%d.png" % frame
				assert(screenshot.save_png(OS.get_environment("HIDRATONA_CAPTURE") + name) == OK)
		for outfit in [3, 4, 5]:
			calibration.outfit_option.select(outfit)
			calibration._on_selection_changed(0)
			for pose in range(3):
				calibration.state_option.select(pose + 7)
				calibration._on_selection_changed(0)
				yield(get_tree(), "idle_frame")
				yield(get_tree(), "idle_frame")
				var screenshot = get_viewport().get_texture().get_data()
				screenshot.flip_y()
				assert(screenshot.save_png(OS.get_environment("HIDRATONA_CAPTURE") + "/pose-%d-%d.png" % [outfit, pose]) == OK)
	calibration.queue_free()

	for weather in ["Rainy", "Snowy"]:
		Resources.weather = weather
		Resources.acessory = "Umbrella" if weather == "Rainy" else "Coat"
		var tuning = load("res://src/Mini-games/Hidratona/src/level/rain/RunCalibration.tres") if weather == "Rainy" else load("res://src/Mini-games/Hidratona/src/level/snow/RunCalibration.tres")
		var root = RAIN_ROOT if weather == "Rainy" else SNOW_ROOT
		for gender in ["Boy", "Girl"]:
			CharacterController.boyorgirl = gender
			CharacterController.cabelo = "b"
			CharacterController.cor_pele = "#6f4e37" if gender == "Boy" else "#e6b58c"
			CharacterController.all_sprites.hidratona = CharacterController.Load_Hidratona()
			var holder = Node2D.new()
			var floor_node = Node2D.new()
			floor_node.name = "floor"
			holder.add_child(floor_node)
			var player = load("res://src/Mini-games/Hidratona/src/Actor/Player.tscn").instance()
			player.use_modular_character = false
			holder.add_child(player)
			get_tree().get_root().add_child(holder)
			for frame in range(1, 8):
				var body = player.get_node("AllSprites/r%d" % frame)
				var expected = root + ("boy_rc_%d.png" % frame if weather == "Rainy" else "correrneve-%d.png" % frame)
				assert(body.texture.resource_path == expected)
				assert(body.material.get_shader_param("target_skin") == Color(CharacterController.cor_pele))
				body.visible = true
				player._sync_legacy_head()
				assert(player.get_node("AllSprites/LegacyHead").position == tuning.get_head_position(frame))
				body.visible = false
			assert(player.get_node("AllSprites/LegacyHead").texture.resource_path.find("/Menino/") != -1 if gender == "Boy" else player.get_node("AllSprites/LegacyHead").texture.resource_path.find("/Menina/") != -1)
			assert(player.get_node("AllSprites/LegacyHead").material.get_shader_param("target_skin") == Color(CharacterController.cor_pele))
			for hair in ["a", "b"]:
				CharacterController.cabelo = hair
				player._refresh_legacy_head()
				var folder = "Menino" if gender == "Boy" else "Menina"
				var prefix = "boy" if gender == "Boy" else "girl"
				var expected_head = "res://assets/SpritesV4/Cabecas/%s/%s%s.png" % [folder, prefix, "1" if hair == "a" else "2"]
				assert(player.get_node("AllSprites/LegacyHead").texture.resource_path == expected_head)
			holder.queue_free()

		var result = load("res://src/Mini-games/Hidratona/src/level/GameOver.tscn").instance()
		get_tree().get_root().add_child(result)
		var expected_result = root + ("boy_rc_2.png" if weather == "Rainy" else "correrneve-2.png")
		assert(result.get_node("sprites/r2").texture.resource_path == expected_result)
		for frame in range(2, 7):
			result.get_node("sprites/r%d" % frame).visible = frame == 2
		result._process(0.0)
		assert(result.get_node("sprites/Head").visible)
		assert(result.get_node("sprites/Head").texture.resource_path == "res://assets/SpritesV4/Cabecas/Menina/girl2.png")
		result.queue_free()

	for weather in ["Sunny", "Rainy", "Snowy"]:
		Resources.weather = weather
		Resources.acessory = "Umbrella" if weather == "Rainy" else "Coat" if weather == "Snowy" else ""
		CharacterController.all_sprites.hidratona = CharacterController.Load_Hidratona()
		var game_level = load("res://src/Mini-games/Hidratona/src/level/Level.tscn").instance()
		get_tree().get_root().add_child(game_level)
		assert(game_level.active_weather == weather)
		var player_body = game_level.get_node("Player/AllSprites/r1").texture.resource_path
		if weather == "Rainy":
			assert(player_body == RAIN_ROOT + "boy_rc_1.png")
		elif weather == "Snowy":
			assert(player_body == SNOW_ROOT + "correrneve-1.png")
		else:
			assert(player_body.find("/hidratona-GIRL/correr-1-girl.png") != -1)
		assert(game_level.get_node("Player/AllSprites/LegacyHead").texture.resource_path == "res://assets/SpritesV4/Cabecas/Menina/girl2.png")
		var body_root = game_level.get_node("Player/AllSprites")
		var game_player = game_level.get_node("Player")
		var pose_tuning = game_player._get_pose_tuning()
		var run_tuning = game_player._get_run_tuning()
		for pose_name in ["j1", "j2", "squat"]:
			body_root.get_node(pose_name).visible = false
		for frame in range(1, 8):
			var run_body = body_root.get_node("r%d" % frame)
			run_body.visible = true
			game_player._sync_legacy_head()
			assert(run_body.scale == Vector2.ONE * run_tuning.body_scale)
			assert(body_root.get_node("LegacyHead").position == run_tuning.get_head_position(frame))
			assert(body_root.get_node("LegacyHead").scale == Vector2.ONE * run_tuning.head_scale)
			assert(game_player.skin_color_rect.rect_position == run_tuning.get_head_position(frame) + run_tuning.neck_offset)
			assert(game_player.skin_color_rect.rect_size == run_tuning.neck_size)
			run_body.visible = false
		for pose in range(3):
			var body = body_root.get_node(["j1", "j2", "squat"][pose])
			assert(body.texture.resource_path == POSES[0 if weather == "Sunny" else 1 if weather == "Rainy" else 2][pose])
			body_root.get_node("r1").visible = false
			body.visible = true
			game_player._sync_legacy_head()
			assert(body_root.get_node("LegacyHead").position == pose_tuning.pose_head_positions[pose])
			assert(body.scale == Vector2.ONE * pose_tuning.pose_body_scales[pose])
			assert(body_root.get_node("LegacyHead").scale == Vector2.ONE * pose_tuning.pose_head_scales[pose])
			assert(game_player.skin_color_rect.rect_position == pose_tuning.pose_head_positions[pose] + pose_tuning.pose_neck_offsets[pose])
			assert(game_player.skin_color_rect.rect_size == pose_tuning.pose_neck_sizes[pose])
			assert(body.material.get_shader_param("target_skin") == Color(CharacterController.cor_pele))
			assert(body.material.get_shader_param("source_skin") == Color("#dfcaab"))
			body.visible = false
		game_level.queue_free()

	print("Hidratona running and pose assets, player, result and calibration preview: OK")
	yield(get_tree(), "idle_frame")
	get_tree().quit()
