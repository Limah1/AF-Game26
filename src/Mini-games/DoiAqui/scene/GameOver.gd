extends Control

func _ready():
	$Sprite.texture = load("res://assets/DoiAqui/sprites/actor/"+str(GlobalResource.gender)+"/"+str(GlobalResource.gender)+"-acerto.png")

func _on_home_pressed():
	GlobalResource.resetVar()
	NecessityBars.some_problem = ""
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_play_pressed():
	GlobalResource.resetVar()
	NecessityBars.some_problem = ""	
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/Main.tscn")
