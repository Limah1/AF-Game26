extends Control



func _on_BoyButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	CharacterController.boyorgirl = "Boy"
	GlobalResource.set_gender("Boy")
	get_tree().change_scene("res://src/UI/Boy_Color_Selector.tscn")


func _on_GirlButton2_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	CharacterController.boyorgirl = "Girl"
	GlobalResource.set_gender("Girl")
	print("funcionando")
	get_tree().change_scene("res://src/UI/Girl_Color_Selector.tscn")


func _on_TextureButton_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/Landing_Page_Temp.tscn")
