extends Control

func _ready() -> void:
	CharacterController.glass = false
	CharacterController.variation = 1
	
	$boy_1.disabled = true
	$boy_1_glass.disabled = false
	$boy_2.disabled = false
	$boy_2_glass.disabled = false


func _on_boy_1_pressed() -> void:
	CharacterController.glass = false
	CharacterController.variation = 1
	
	$boy_1.disabled = true
	$boy_1_glass.disabled = false
	$boy_2.disabled = false
	$boy_2_glass.disabled = false


func _on_boy_1_glass_pressed() -> void:
	CharacterController.glass = true
	CharacterController.variation = 1
	
	$boy_1.disabled = false
	$boy_1_glass.disabled = true
	$boy_2.disabled = false
	$boy_2_glass.disabled = false


func _on_boy_2_pressed() -> void:
	CharacterController.glass = false
	CharacterController.variation = 2
	
	$boy_1.disabled = false
	$boy_1_glass.disabled = false
	$boy_2.disabled = true
	$boy_2_glass.disabled = false


func _on_boy_2_glass_pressed() -> void:
	CharacterController.glass = true
	CharacterController.variation = 2
	
	$boy_1.disabled = false
	$boy_1_glass.disabled = false
	$boy_2.disabled = false
	$boy_2_glass.disabled = true


func _on_ConfirmButton_pressed() -> void:
	#SaveController.save_game()
	NecessityBars.started = true
	CharacterController.start()
	get_tree().change_scene("res://src/MainScreen.tscn")
