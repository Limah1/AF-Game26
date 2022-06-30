extends CanvasLayer


func _on_Button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://src/MainScreen.tscn")
	AnimationController.status = "ForgotAcessory"


func _on_Button2_pressed():
	get_tree().paused = false
	$ColorRect.visible = false
	$NaoTrouxeCapa.visible = false
	$NaoTrouxeCasaco.visible = false
