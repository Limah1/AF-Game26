extends Node2D

func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://src/Mini-games/PlantCare/PlantCare.tscn")

func _on_BackButton_pressed() -> void:
	AnimationController.status = "MainGame"
	get_tree().change_scene("res://src/MainScreen.tscn")
