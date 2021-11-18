extends Node2D

func start(emit):
	$Particles2D.emitting = emit
	$nuvens.visible = emit
	#$snowSound.play()
