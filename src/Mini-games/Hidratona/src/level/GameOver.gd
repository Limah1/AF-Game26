extends Control

func _ready():
	var sprites = CharacterController.all_sprites.hidratona
	$applaude.play()
	$sprites/r2.texture = sprites.run.r2
	$sprites/r3.texture = sprites.run.r3
	$sprites/r4.texture = sprites.run.r4
	$sprites/r5.texture = sprites.run.r5
	$sprites/r6.texture = sprites.run.r6
	
	$sprites/win.texture = sprites.win
	
	if(Resources.acessory == "Coat"):
		$sprites/r2.texture = sprites.snow.run.r2
		$sprites/r3.texture = sprites.snow.run.r3
		$sprites/r4.texture = sprites.snow.run.r4
		$sprites/r5.texture = sprites.snow.run.r5
		$sprites/r6.texture = sprites.snow.run.r6
		
		$sprites/win.texture = sprites.snow.win
	
	if(Resources.acessory == "Umbrella"):
		$sprites/r2.texture = sprites.rain.run.r2
		$sprites/r3.texture = sprites.rain.run.r3
		$sprites/r4.texture = sprites.rain.run.r4
		$sprites/r5.texture = sprites.rain.run.r5
		$sprites/r6.texture = sprites.rain.run.r6
		
		$sprites/win.texture = sprites.rain.win


func _on_TryAgainButton_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	Resources.reset_resources()
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Level.tscn")

func _on_GoHomeButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	Resources.reset_resources()
	get_tree().paused = false
	get_tree().change_scene("res://src/MainScreen.tscn")
