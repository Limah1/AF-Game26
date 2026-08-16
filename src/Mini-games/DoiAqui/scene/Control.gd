extends Control


func _ready():
	pass


func _on_startButton_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/Main.tscn")


func _on_learnButton_pressed():
	$button_sound.play()
