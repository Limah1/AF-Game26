extends Node2D

var typeAnimation

onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	pass

func startCountdown(typeAnimation):
	if typeAnimation == 1:
		animation.play("leve")
	elif typeAnimation == 2:
		animation.play("moderada")
	elif typeAnimation == 3:
		animation.play("intensa")
	else:
		animation.play("leve")
		
	yield(animation, "animation_finished")
	
	

