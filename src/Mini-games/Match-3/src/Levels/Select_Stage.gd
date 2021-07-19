extends Control


func _on_3X3_pressed() -> void:
	get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_3x3.tscn")

func _on_6X6_pressed() -> void:
	get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_6x6.tscn")

func _on_9X9_pressed() -> void:
	get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_9x9.tscn")
