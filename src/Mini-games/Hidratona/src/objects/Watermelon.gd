extends Area2D


func start(gpos):
	global_position = gpos

func _on_Watermelon_body_entered(body):
	$crunch.play()
	yield($crunch,"finished")
	Resources.power_watermelon = true 
	Resources.watermelon_timer = 15 
	if Resources.current_life < 50:
		Resources.current_life += 1
	queue_free()
