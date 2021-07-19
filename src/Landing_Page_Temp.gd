extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !SaveController.file_exist():
		$Continue.disabled = true

func _on_Continue_pressed() -> void:
	NecessityBars.started = true
	SaveController.load_game()
	get_tree().change_scene("res://src/MainScreen.tscn")


func _on_Restart_pressed() -> void:
	get_tree().change_scene("res://src/UI/Sex_Selector.tscn")


func _on_Leave_pressed() -> void:
	get_tree().quit()
