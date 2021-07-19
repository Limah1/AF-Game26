extends Node2D

var time_sun = 0
var sun = false
onready var animation: AnimationPlayer = $AnimationPlayer

onready var parallax = $floor

func _ready():
	$CanvasLayer.layer = -128
	$Timer.start()

func _process(delta):
	$Player.global_position.x = $Position2D.global_position.x

func _on_pause_button_up():
	$CanvasLayer.layer = 128
	$CanvasLayer/play_button.visible = true
	$CanvasLayer/ColorRect.visible = true
	var colorRect = get_tree().get_nodes_in_group("sun")
	for i in colorRect:
		i.visible = false
	get_tree().paused = true 

func _on_playbutton_button_up():
	$CanvasLayer.layer = -128
	$CanvasLayer/play_button.visible = false

	$CanvasLayer/ColorRect.visible = false
	var colorRect = get_tree().get_nodes_in_group("sun")
	for i in colorRect:
		i.visible = false
	get_tree().paused = false 

func _on_Timer_timeout():
	var node = preload("res://src/Mini-games/Hidratona/src/objects/Sun.tscn")
	var scene = node.instance()
	add_child(scene)
	animation.play("sun")
	Resources.sunny = true
	$Timer2.start()

func _on_Timer2_timeout():
	Resources.sunny = false
	$Timer.start()

