extends Node

func _ready() -> void:
	var defaults = load("res://src/UI/WeatherOutfitTuning.gd").new()
	for variation in ["r1", "r2"]:
		for gender in ["boy", "girl"]:
			for hair in ["a", "b"]:
				assert(defaults.seated_head_offsets.has("%s-%s-%s" % [gender, hair, variation]))
	var calibration = load("res://src/Tools/OutfitCalibration.tscn").instance()
	add_child(calibration)
	calibration.outfit_option.selected = 0
	calibration.variation_option.selected = 1
	calibration.gender_option.selected = 1
	calibration._on_selection_changed(0)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var idle = calibration.player.get_node("player_sprites/idle")
	assert(idle.texture.resource_path.ends_with("/girlsc-1-1.png"))
	for frame in range(1, 6):
		assert(calibration.player.get_node("player_sprites/w%d" % frame).texture.resource_path.ends_with("/girlsc-1-%d.png" % (frame + 1)))
	assert(idle.material.shader == preload("res://src/UI/GirlR2Body.shader"))
	assert(idle.scale == Vector2(1.82, 1.82))
	assert(idle.position == calibration.player.normal_sprite_layout.idle.position + calibration.tuning.girl_r2_body_offset)
	calibration.body_x_input.value = 9
	calibration.body_y_input.value = -14
	calibration.selector_x_input.value = 1600
	calibration.selector_y_input.value = 430
	assert(calibration.tuning.girl_r2_body_offset == Vector2(9, -14))
	assert(calibration.tuning.girl_r2_selector_position == Vector2(1600, 430))
	assert(idle.position == calibration.player.normal_sprite_layout.idle.position + Vector2(9, -14))
	calibration.player.set_normal_dirty_clothes()
	assert(idle.texture.resource_path.ends_with("/girlsc-1-1.png"))
	assert(idle.scale == Vector2(1.82, 1.82))
	calibration.gender_option.selected = 0
	calibration._on_selection_changed(0)
	assert(idle.texture.resource_path.ends_with("/Menino/Variacao2/m0.png"))
	assert(idle.material.shader == preload("res://src/UI/ShaderPersonagem.tres").shader)
	assert(idle.scale == Vector2(0.25, 0.25))
	calibration.state_option.selected = 2
	calibration._on_selection_changed(2)
	var toilet = calibration.player.get_node("player_sprites/toilet")
	var head = calibration.player.get_node("player_sprites/Head")
	assert(toilet.scale == Vector2(0.25, 0.25) and toilet.visible)
	var seated_position = calibration.tuning.get_normal_head_position("boy", "a", "r2") + calibration.tuning.get_seated_head_offset("boy", "a", "r2")
	assert(head.position == seated_position)
	calibration.head_x_input.value += 4
	assert(head.position == seated_position + Vector2(4, 0))
	print("Outfit calibration girl r2 skirt and seated pose OK")
	get_tree().quit()
