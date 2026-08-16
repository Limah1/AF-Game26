extends TextureProgress

func _process(delta: float) -> void:
	if Resources.melon_timer > 0:
		Resources.melon_timer -= delta
		value = Resources.melon_timer

		if Resources.melon_timer <= 0:
			Resources.power_melon = false
