extends SceneTree

func _init() -> void:
	call_deferred("_check_variations")

func _check_variations() -> void:
	var data = get_root().get_node("NewCharData")
	data.cabelo = "a"
	for gender in ["boy", "girl"]:
		data.genero = gender
		var selector = load("res://src/UI/Character_Clothes_Selector.tscn").instance()
		get_root().add_child(selector)
		var body = selector.get_node("Sprite")
		assert(body.scale == Vector2(0.4, 0.4))
		selector._on_btn_roupa_2_pressed()
		assert(body.scale == (Vector2(3.05, 3.05) if gender == "girl" else Vector2(0.455, 0.455)))
		assert(body.position == (Vector2(1606.6, 361) if gender == "girl" else Vector2(1606.6, 445)))
		selector._on_btn_roupa_1_pressed()
		assert(body.scale == Vector2(0.4, 0.4))
		selector.free()
	print("Character clothes selector variations OK")
	quit()
