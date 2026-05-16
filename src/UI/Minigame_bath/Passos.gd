extends Control

var molhado
var ensaboado
var enxaguar
var enxugar

var p1_played = false
var p2_played = false
var p3_played = false
var p4_played = false

var finished = false

func _process(delta):
	molhado = get_parent().molhado
	ensaboado = get_parent().ensaboado
	enxaguar = get_parent().enxaguar
	enxugar = get_parent().enxugado
	
	$Molhar/ProgressBar.value = molhado
	$Ensaboar/ProgressBar.value = ensaboado
	$Enxaguar/ProgressBar.value = enxaguar
	$Enxugar/ProgressBar.value = enxugar
	
	if(molhado >= 100 and p1_played == false):
		$AnimationPlayer.play("p1")
		p1_played = true
	if(ensaboado >= 100 and p2_played == false):
		$AnimationPlayer.play("p2")
		p2_played = true
	if(enxaguar >= 100 and p3_played == false):
		$AnimationPlayer.play("p3")
		p3_played = true
	if(enxugar >= 100 and p4_played == false):
		$AnimationPlayer.play("p4")
		p4_played = true


func _on_Button_pressed():
	if finished: return
	finished = true
	$Button/button_sound.play()
	yield($Button/button_sound,"finished")
	NecessityBars.higiene = 900
	get_parent().bathroom_reference.finish_bath()
	get_parent().queue_free()


func _on_TextureButton_pressed():
	if finished: return
	finished = true
	get_parent().bathroom_reference.finish_bath()
	get_parent().queue_free()
