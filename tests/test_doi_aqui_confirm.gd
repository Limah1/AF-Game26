extends Node2D

const GAME = preload("res://src/Mini-games/DoiAqui/scene/Main.tscn")

func _init():
	call_deferred("_run")

func _run():
	CharacterController.boyorgirl = "Boy"
	CharacterController.cabelo = "a"
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
	game.get_node("Player").typesPain = "headache"
	game.nP = 1
	game.buttonsBlock = false
	game._on_Button_pressed("headache")
	assert(game.life == 1 and game.feedback_phase == "result")
	assert(game.get_node("ContinueLayer/ContinueButton").visible)
	game._on_Button_pressed("headache")
	assert(game.life == 1)
	game.get_node("ContinueLayer/ContinueButton").emit_signal("pressed")
	assert(game.feedback_phase == "pain_level" and game.get_node("painLevel").layer == 100)
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
		tree.current_scene.free()
		tree.current_scene = null
	print("DoiAqui confirm flow OK")
	tree.quit()
