extends Node2D

const BATH_GAME = preload("res://src/UI/Minigame_bath/MiniGame_Banho.tscn")

func _init():
	call_deferred("_run")

func _run():
	var tree = get_tree()
	for gender in ["Boy", "Girl"]:
		for hair in ["a", "b"]:
			CharacterController.boyorgirl = gender
			CharacterController.cabelo = hair
			CharacterController.cor_pele = "#8d5524"
			var game = BATH_GAME.instance()
			tree.get_root().add_child(game)
			var body = game.get_node("boy-banho-1")
			var head = body.get_node("Head")
			var cap = head.get_node("BathCap")
			var gender_name = "boy" if gender == "Boy" else "girl"
			var folder = "Menino" if gender == "Boy" else "Menina"
			var number = "1" if hair == "a" else "2"
			assert(body.texture.resource_path == "res://assets/SpritesV4/MiniGameBanho/%s-banho-m1.png" % gender_name)
			assert(head.texture.resource_path == "res://assets/SpritesV4/Cabecas/%s/%s%s.png" % [folder, gender_name, number])
			assert(body.material.get_shader_param("nova_cor_pele") == Color("#8d5524"))
			assert(head.material.get_shader_param("target_skin") == Color("#8d5524"))
			assert(cap.get_parent() == head and cap.texture.resource_path.ends_with("/banho_touca.png"))
			assert(game.chuveiro.global_position == body.global_position + game.water_particles_offset)
			head.position = Vector2(12, -540)
			head.scale = Vector2(0.9, 0.9)
			assert(cap.global_scale.is_equal_approx(body.global_scale * head.scale))
			assert(game.character_body_shape != null and game.water_circles != null and game.foam != null)
			game.free()
	print("Bath character visuals OK")
	tree.quit()
