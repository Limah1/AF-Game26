extends Control

func _ready():
	pass

func _on_Start_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Level.tscn")


func _on_Tutorial_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Tutorial.tscn")
