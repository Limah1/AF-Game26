extends Node

func _ready() -> void:
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
	assert(idle.material.shader == preload("res://src/UI/GirlR2Body.shader"))
	assert(idle.scale == Vector2(1.82, 1.82))
	calibration.gender_option.selected = 0
	calibration._on_selection_changed(0)
	assert(idle.texture.resource_path.ends_with("/Menino/Variacao2/m0.png"))
	assert(idle.material.shader == preload("res://src/UI/ShaderPersonagem.tres").shader)
	assert(idle.scale == Vector2(0.25, 0.25))
	print("Outfit calibration girl r2 skirt OK")
	get_tree().quit()
