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


func _on_Home_pressed():
	get_tree().change_scene("res://src/MainScreen.tscn")
	pass # Replace with function body.


func _on_Hospital_pressed():
	get_tree().change_scene("res://src/Hospital.tscn")
	pass # Replace with function body.
