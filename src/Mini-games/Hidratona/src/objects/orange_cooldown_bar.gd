extends TextureProgress

func _process(delta: float) -> void:
	if Resources.orange_timer > 0:
		Resources.orange_timer -= delta
		value = Resources.orange_timer
		
		if Resources.orange_timer <= 0:
			Resources.power_orange = false
