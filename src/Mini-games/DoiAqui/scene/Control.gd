extends Control


func _ready():
	pass


func _on_startButton_pressed():
	get_tree().change_scene("res://src/scene/Main.tscn")
