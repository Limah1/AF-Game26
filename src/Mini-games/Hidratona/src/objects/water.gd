extends Area2D


func start(gpos):
	global_position = gpos


func _on_water_body_entered(body):
	$crunch.play()
	$agua.visible = false
	$CollisionShape2D.disabled = true
	if Resources.current_life <= (Resources.max_life - 10):
		Resources.current_life += 10
	if Resources.current_life > 40 and Resources.current_life < Resources.max_life:
		Resources.current_life = Resources.max_life
	if Resources.current_life < (Resources.max_life - 20) and Resources.power_watermelon:
		Resources.current_life += 20
	yield($crunch,"finished")
	queue_free()
