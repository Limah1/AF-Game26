extends Node2D

func start(emit):
	$rain.play()
	$rain.loop = true
	$Particles2D.emitting = emit
	$nuvens.visible = emit
