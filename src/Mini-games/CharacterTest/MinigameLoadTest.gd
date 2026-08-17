extends Control

onready var rig_run = $RigRun

func _ready():
	yield(get_tree(), "idle_frame")
	
	rig_run.set_hair_color(ModularTestVariables.hair_color)
	rig_run.set_skin_color(ModularTestVariables.skin_color)
	rig_run.set_clothes_color(ModularTestVariables.clothes_color)

func _on_BtnBack_pressed():
	get_tree().change_scene("res://src/Mini-games/CharacterTest/CharacterTest.tscn")
