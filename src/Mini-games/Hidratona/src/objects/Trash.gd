extends Area2D

func start(gpos):
	global_position = gpos


func _on_Trash_body_entered(body):
	$trashsound.play()
	yield($trashsound,"finished")
	Resources.heart -= 1
	queue_free()
