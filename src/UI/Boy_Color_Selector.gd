extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterController.etnia = "negro"
	
	$branco.disabled = false
	$pardo.disabled = false
	$negro.disabled = true

func _on_branco_pressed():
	$gendersound.play()
	
	$branco.disabled = true
	$pardo.disabled = false
	$negro.disabled = false
	
	CharacterController.etnia = "branco"


func _on_pardo_pressed():
	$gendersound.play()
	
	$branco.disabled = false
	$pardo.disabled = true
	$negro.disabled = false
	
	CharacterController.etnia = "pardo"


func _on_negro_pressed():
	$gendersound.play()
	
	CharacterController.etnia = "negro"
	
	$branco.disabled = false
	$pardo.disabled = false
	$negro.disabled = true

func _on_ConfirmButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/UI/Boy_Style_Selector.tscn")

func _on_TextureButton_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/UI/Sex_Selector.tscn")

#func _ready() -> void:
#	CharacterController.glass = false
#	CharacterController.variation = 1
#
#	$boy_1.disabled = true
#	$boy_1_glass.disabled = false
#	$boy_2.disabled = false
#	$boy_2_glass.disabled = false
#
#
#func _on_boy_1_pressed() -> void:
#	$gendersound.play()
#	CharacterController.glass = false
#	CharacterController.variation = 1
#
#	$boy_1.disabled = true
#	$boy_1_glass.disabled = false
#	$boy_2.disabled = false
#	$boy_2_glass.disabled = false
#
#
#func _on_boy_1_glass_pressed() -> void:
#	$gendersound.play()
#	CharacterController.glass = true
#	CharacterController.variation = 1
#
#	$boy_1.disabled = false
#	$boy_1_glass.disabled = true
#	$boy_2.disabled = false
#	$boy_2_glass.disabled = false
#
#
#func _on_boy_2_pressed() -> void:
#	$gendersound.play()
#	CharacterController.glass = false
#	CharacterController.variation = 2
#
#	$boy_1.disabled = false
#	$boy_1_glass.disabled = false
#	$boy_2.disabled = true
#	$boy_2_glass.disabled = false
#
#
#func _on_boy_2_glass_pressed() -> void:
#	$gendersound.play()
#	CharacterController.glass = true
#	CharacterController.variation = 2
#
#	$boy_1.disabled = false
#	$boy_1_glass.disabled = false
#	$boy_2.disabled = false
#	$boy_2_glass.disabled = true
#
#

#
#



