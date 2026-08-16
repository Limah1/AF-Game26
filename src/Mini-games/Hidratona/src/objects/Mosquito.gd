extends Area2D

func start(gpos):
	global_position = gpos


func _on_Mosquito_body_entered(body):
	$mosquitosound.play()
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	Resources.heart -= 1
	yield($mosquitosound,"finished")
	queue_free()
