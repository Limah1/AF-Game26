extends Control

func _ready() -> void:
	CharacterController.glass = false
	CharacterController.variation = 1
	
	$girl_1.disabled = true
	$girl_1_glass.disabled = false
	$girl_2.disabled = false
	$girl_2_glass.disabled = false

func _on_girl_1_pressed() -> void:
	$sound_gender.play()
	CharacterController.glass = false
	CharacterController.variation = 1
	
	$girl_1.disabled = true
	$girl_1_glass.disabled = false
	$girl_2.disabled = false
	$girl_2_glass.disabled = false

func _on_girl_1_glass_pressed() -> void:
	$sound_gender.play()
	CharacterController.glass = true
	CharacterController.variation = 1
	
	$girl_1.disabled = false
	$girl_1_glass.disabled = true
	$girl_2.disabled = false
	$girl_2_glass.disabled = false

func _on_girl_2_pressed() -> void:
	$sound_gender.play()
	CharacterController.glass = false
	CharacterController.variation = 2
	
	$girl_1.disabled = false
	$girl_1_glass.disabled = false
	$girl_2.disabled = true
	$girl_2_glass.disabled = false

func _on_girl_2_glass_pressed() -> void:
	$sound_gender.play()
	CharacterController.glass = true
	CharacterController.variation = 2
	
	$girl_1.disabled = false
	$girl_1_glass.disabled = false
	$girl_2.disabled = false
	$girl_2_glass.disabled = true


func _on_TextureButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	NecessityBars.started = true
	CharacterController.start()
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_TextureButton2_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/UI/Sex_Selector.tscn")

