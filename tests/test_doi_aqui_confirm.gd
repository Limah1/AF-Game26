extends Node2D

const GAME = preload("res://src/Mini-games/DoiAqui/scene/Main.tscn")

func _init():
	call_deferred("_run")

func _run():
	CharacterController.boyorgirl = "Boy"
	CharacterController.cabelo = "a"
	CharacterController.cor_pele = "#8d5524"
	CharacterController.cor_roupa_cima = "#21b24b"
	CharacterController.cor_roupa_baixo = "#3155cc"
	var calibration = load("res://src/Tools/OutfitCalibration.tscn").instance()
	add_child(calibration)
	calibration.rect_size = get_viewport().get_visible_rect().size
	assert(calibration.outfit_option.selected == 6)
	for gender in [0, 1]:
		for hair in [0, 1]:
			calibration.gender_option.select(gender)
			calibration.hair_option.select(hair)
			for state in range(8):
				calibration.state_option.select(state)
				calibration._on_selection_changed(state)
				var preview = calibration.doi_player
				assert(preview.get_node("sprite").texture.resource_path.ends_with("boy-%s.png" % calibration._doi_state()))
				assert(preview.get_node("LegacyHead").texture == CharacterController.get_legacy_head_texture())
				assert(preview.get_node("sprite").material.get_shader_param("target_shirt") == Color("#21b24b"))
				assert(preview.get_node("sprite").material.get_shader_param("target_pants") == Color("#3155cc"))
				assert(preview.get_node("LegacyHead").position == calibration.doi_tuning.head_positions.get(calibration._doi_state() + "-Boy-a", Vector2(0, -43)))
				assert(preview.get_node("LegacyHead").scale == Vector2.ONE * calibration.doi_tuning.head_scales.get(calibration._doi_state() + "-Boy-a", 0.094))
	calibration.head_x_input.value += 3
	assert(calibration.doi_player.get_node("LegacyHead").position.x == calibration.head_x_input.value)
	calibration.neck_width_input.value += 2
	assert(calibration.doi_player.get_node("SkinColorRect").rect_size.x == calibration.neck_width_input.value)
	assert(ResourceSaver.save("user://doi_test_tuning.tres", calibration.doi_tuning) == OK)
	var saved = ResourceLoader.load("user://doi_test_tuning.tres", "", true)
	assert(saved.get_head_position("erro").x == calibration.head_x_input.value)
	if OS.get_environment("DOI_CAPTURE") != "":
		calibration.state_option.select(0)
		calibration._on_selection_changed(0)
		yield(get_tree(), "idle_frame")
		yield(VisualServer, "frame_post_draw")
		var screenshot = get_viewport().get_texture().get_data()
		screenshot.flip_y()
		assert(screenshot.save_png(OS.get_environment("DOI_CAPTURE")) == OK)
	calibration.free()
	var game = GAME.instance()
	var tree = get_tree()
	tree.get_root().add_child(game)
	tree.current_scene = game
	for gender in ["Boy", "Girl"]:
		for hair in ["a", "b"]:
			CharacterController.boyorgirl = gender
			CharacterController.cabelo = hair
			game.get_node("Player")._refresh_legacy_head()
			var folder = "Menino" if gender == "Boy" else "Menina"
			var name = "boy" if gender == "Boy" else "girl"
			var number = "1" if hair == "a" else "2"
			assert(game.get_node("Player/LegacyHead").texture.resource_path == "res://assets/SpritesV4/Cabecas/%s/%s%s.png" % [folder, name, number])
			assert(game.get_node("Player/LegacyHead").material.get_shader_param("target_skin") == Color("#8d5524"))
	for state_name in ["parado", "dores", "ferimento", "frio", "nervoso", "febre"]:
		assert(game.get_node("Player")._body_texture_path(state_name) == "res://assets/SpritesV4/DoiAqui/boy-%s.png" % state_name)
	var animated_player = game.get_node("Player")
	var body_paths = ["sprite", "pain", "wound", "expressions/cold", "expressions/stress", "expressions/fever"]
	for previous in ["normal", "headache", "armPain", "fever", "wound"]:
		for next in ["normal", "headache", "armPain", "fever", "wound"]:
			animated_player.animation.play(previous)
			animated_player.animation.advance(1.1)
			animated_player.animation.play(next)
			for time in [0.0, 0.5, 0.6]:
				animated_player.animation.advance(time)
				var visible_bodies = 0
				for path in body_paths:
					if animated_player.get_node(path).visible:
						visible_bodies += 1
				assert(visible_bodies == 1)
	assert(game.get_node("Player/sprite").material.get_shader_param("target_skin") == Color("#8d5524"))
	game.get_node("Player").typesPain = "headache"
	game.nP = 1
	game.buttonsBlock = false
	game._on_Button_pressed("headache")
	assert(game.life == 1 and game.feedback_phase == "result")
	assert(game.get_node("messageInterGame/Character/sprite").texture.resource_path.ends_with("boy-parado.png"))
	assert(game.get_node("messageInterGame/Character/LegacyHead").texture == CharacterController.get_legacy_head_texture())
	assert(game.get_node("ContinueLayer/ContinueButton").visible)
	assert(game.get_node("Player/LegacyHead").visible)
	game._on_Button_pressed("headache")
	assert(game.life == 1)
	game.get_node("ContinueLayer/ContinueButton").emit_signal("pressed")
	assert(game.feedback_phase == "pain_level" and game.get_node("painLevel").layer == 100)
	assert(game.get_node("painLevel/Character/sprite").texture.resource_path.ends_with("boy-dores.png"))
	game.get_node("ContinueLayer/ContinueButton").emit_signal("pressed")
	assert(game.feedback_phase == "" and game.settingUp)
	game.get_node("ContinueLayer/ContinueButton").emit_signal("pressed")
	assert(game.life == 1 and game.feedback_phase == "")
	tree.current_scene = null
	game.free()

	for final_life in [10, 0]:
		game = GAME.instance()
		tree.get_root().add_child(game)
		tree.current_scene = game
		game.get_node("Player").typesPain = "headache"
		game.life = 9 if final_life == 10 else 1
		game.isHalthLife = final_life == 0
		game.buttonsBlock = false
		game._on_Button_pressed("headache" if final_life == 10 else "wrong")
		assert(game.life == final_life and game.feedback_phase == "result")
		assert(tree.current_scene == game)
		game.get_node("ContinueLayer/ContinueButton").emit_signal("pressed")
		yield(tree, "idle_frame")
		assert(tree.current_scene.filename == "res://src/Mini-games/DoiAqui/scene/GameOver.tscn")
		assert(tree.current_scene.get_node("Character/sprite").texture.resource_path == "res://assets/SpritesV4/DoiAqui/boy-parado.png")
		assert(tree.current_scene.get_node("Character/sprite").material.get_shader_param("target_skin") == Color("#8d5524"))
		assert(tree.current_scene.get_node("Character/LegacyHead").texture.resource_path == "res://assets/SpritesV4/Cabecas/Menina/girl2.png")
		tree.current_scene.free()
		tree.current_scene = null
	print("DoiAqui confirm flow OK")
	tree.quit()
