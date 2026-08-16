extends HouseRoom

func _ready() -> void:
	room_id = 1

func _on_Tv_button_pressed() -> void:
	$"tv-off".visible = !$"tv-off".visible

func _on_PainButton_pressed() -> void:
	$DoiAqui/AnimationPlayer.play("fade_in")

func _on_TextureButton_pressed() -> void:
	$DoiAqui/AnimationPlayer.play("fade_out")

func _on_StartButton_pressed() -> void:
	AnimationController.status = "DoiAqui"

	if(NecessityBars.some_problem == "fever"):
		GlobalResource.initialPain = 2
	elif(NecessityBars.some_problem == "headache"):
		GlobalResource.initialPain = 0
	elif(NecessityBars.some_problem == "armPain"):
		GlobalResource.initialPain = 1

	NecessityBars.inpain = false
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/Main.tscn")
