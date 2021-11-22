extends Control

var basePath: String = "res://assets/Plataforma/Char_Select/color-selectors-girl/"

func _ready() -> void:
	CharacterController.glass = false
	CharacterController.variation = 1
	
	setupButtons()
	
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
	get_tree().change_scene("res://src/UI/Girl_Color_Selector.tscn")

func setupButtons():

	$girl_1.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-1.png"))
	
	$girl_1.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-1-hover.png"))

	$girl_1_glass.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-1-oculos.png"))
	
	$girl_1_glass.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-1-oculos-hover.png"))
		
	$girl_2.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-2.png"))
	
	$girl_2.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-2-hover.png"))
		
	$girl_2_glass.texture_normal = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-2-oculos.png"))
	
	$girl_2_glass.texture_disabled = load(str(basePath,
		CharacterController.etnia.left(1),
		"-girl-estilo-2-oculos-hover.png"))
