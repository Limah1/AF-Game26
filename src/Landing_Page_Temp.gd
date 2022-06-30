extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !SaveController.file_exist():
		$Continue.disabled = true
	$title_sound.play()
	BackgroundMusic.play_music()
	
	AnimationController.is_travelling = false
	AnimationController.is_room_moving = false

func _on_Continue_pressed() -> void:
	$button_pressed.play()
	yield($button_pressed,"finished")
	NecessityBars.started = true
	SaveController.load_game()
	get_tree().change_scene("res://src/MainScreen.tscn")


func _on_Restart_pressed() -> void:
	$button_pressed.play()
	yield($button_pressed,"finished")
	get_tree().change_scene("res://src/UI/Sex_Selector.tscn")


func _on_Leave_pressed() -> void:
	$button_pressed.play()
	yield($button_pressed,"finished")
	get_tree().quit()


