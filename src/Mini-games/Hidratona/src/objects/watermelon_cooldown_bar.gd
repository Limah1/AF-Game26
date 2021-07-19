extends TextureProgress

func _process(delta: float) -> void:
	if Resources.watermelon_timer > 0:
		Resources.watermelon_timer -= delta
		value = Resources.watermelon_timer
		
		if Resources.watermelon_timer <= 0:
			Resources.power_watermelon = false
