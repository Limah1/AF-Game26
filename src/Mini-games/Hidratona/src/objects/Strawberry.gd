extends Area2D


func start(gpos):
	global_position = gpos


func _on_Strawberry_body_entered(body):
	Resources.km += 20
	$crunch.play()
	$icon.visible = false
	$CollisionShape2D.disabled = true
	if Resources.current_life < 50:
		Resources.current_life += 1
	yield($crunch,"finished")
	queue_free()
