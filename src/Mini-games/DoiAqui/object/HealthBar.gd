extends Node2D

var bar_green: = preload("res://assets/Match-3/sprites/barHorizontal_green.png")

onready var healthbar = $HealthBar

func start():
	pass
func _ready():
	$HealthBar.max_value = GlobalResource.max_life
	
func _process(delta):
	global_rotation = 0

func update_healthBar(value):
	healthbar.value = value
