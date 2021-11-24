extends Area2D

func start(gpos):
	global_position = gpos


func _on_Trash_body_entered(body):
	$trashsound.play()
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	Resources.heart -= 1
	yield($trashsound,"finished")
	queue_free()
