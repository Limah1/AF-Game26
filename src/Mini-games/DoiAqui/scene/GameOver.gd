extends Control

func _ready():
	$applause.play()
	$Character.set_preview_state("parado")

func _on_home_pressed():
	GlobalResource.resetVar()
	NecessityBars.some_problem = ""
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_play_pressed():
	GlobalResource.resetVar()
	NecessityBars.some_problem = ""	
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/Main.tscn")
