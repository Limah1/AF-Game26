extends Node2D

func start(emit):
	$rain_sound.play()
	$Particles2D.emitting = emit
	$nuvens.visible = emit

