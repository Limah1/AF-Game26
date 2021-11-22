extends Area2D


func start(gpos):
	global_position = gpos

func _on_Orange_body_entered(body):
	$crunch.play()
	yield($crunch,"finished")
	Resources.power_orange = true 
	Resources.orange_timer = 15 
	if Resources.current_life < 50:
		Resources.current_life += 1
	queue_free()
