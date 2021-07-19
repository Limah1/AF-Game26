extends Control

func _on_start_pressed():
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Select_Stage.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_3x3.tscn")
