extends TextureButton

var full_super_button: StreamTexture = preload("res://assets/Hidratona/sprites/objects/botao-super-cheio.png")
var empty_super_button: StreamTexture = preload("res://assets/Hidratona/sprites/objects/botao-super-vazio.png")

func _process(delta: float) -> void:
	
	if Resources.dash_timer > 0:
		Resources.dash_timer -= delta
		$cooldown_bar.value = Resources.dash_timer
	
	if (Resources.current_life > Resources.max_life * 0.6) and (Resources.dash_timer <= 0.0):
		texture_normal = full_super_button
		$cooldown_bar.visible = false
	else:
		texture_normal = empty_super_button
		$cooldown_bar.visible = true
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
