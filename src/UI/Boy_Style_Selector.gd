extends Control

var basePath: String = "res://assets/Plataforma/Char_Select/color-selectors/"

func _ready() -> void:
	CharacterController.glass = false
	CharacterController.variation = 1
	
	setupButtons()
	
	$boy_1.disabled = true
	$boy_1_glass.disabled = false
	$boy_2.disabled = false
	$boy_2_glass.disabled = false

func _on_boy_1_pressed() -> void:
	$gendersound.play()
	CharacterController.glass = false
	CharacterController.variation = 1
	
	$boy_1.disabled = true
	$boy_1_glass.disabled = false
	$boy_2.disabled = false
	$boy_2_glass.disabled = false


func _on_boy_1_glass_pressed() -> void:
	$gendersound.play()
	CharacterController.glass = true
	CharacterController.variation = 1
	
	$boy_1.disabled = false
	$boy_1_glass.disabled = true
	$boy_2.disabled = false
	$boy_2_glass.disabled = false


func _on_boy_2_pressed() -> void:
	$gendersound.play()
	CharacterController.glass = false
	CharacterController.variation = 2
	
	$boy_1.disabled = false
	$boy_1_glass.disabled = false
	$boy_2.disabled = true
	$boy_2_glass.disabled = false


func _on_boy_2_glass_pressed() -> void:
	$gendersound.play()
	CharacterController.glass = true
	CharacterController.variation = 2
	
	$boy_1.disabled = false
	$boy_1_glass.disabled = false
	$boy_2.disabled = false
	$boy_2_glass.disabled = true


func _on_ConfirmButton_pressed() -> void:
	#SaveController.save_game()
	$button_sound.play()
	yield($button_sound,"finished")
	NecessityBars.started = true
	CharacterController.start()
	get_tree().change_scene("res://src/MainScreen.tscn")


func _on_TextureButton_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/UI/Boy_Color_Selector.tscn")

func setupButtons():

	$boy_1.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-1.png"))
	
	$boy_1.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-1-hover.png"))

	$boy_1_glass.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-1-oculos.png"))
	
	$boy_1_glass.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-1-oculos-hover.png"))
		
	$boy_2.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-2.png"))
	
	$boy_2.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-2-hover.png"))
		
	$boy_2_glass.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-2-oculos.png"))
	
	$boy_2_glass.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-boy-estilo-2-oculos-hover.png"))
