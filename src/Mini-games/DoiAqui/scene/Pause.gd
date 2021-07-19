extends CanvasLayer

func _on_TextureButton_pressed():
	$Pause2.visible = true
	get_tree().paused = true 
	
	var necessitybar = load("res://src/UI/NecessityManager.tscn").instance()
	$Pause2.add_child(necessitybar)
	necessitybar.get_node("AnimationPlayer").play("Start")

func _on_playbutton_pressed():
	$Pause2.visible = false
	get_tree().paused = false 
	$Pause2.get_node("NecessityManager").queue_free()

func _on_playbutton2_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://src/MainScreen.tscn")
