extends HouseRoom

func _ready() -> void:
	room_id = 5

func _on_StartButton_pressed() -> void:
	AnimationController.is_travelling = false
	AnimationController.status = "PlantCare"
	get_tree().change_scene("res://src/Mini-games/PlantCare/PlantCareMenu.tscn")
