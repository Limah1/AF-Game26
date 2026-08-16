extends Area2D


func _ready():
	pass


func _on_Melon_body_entered(body):
	$crunch.play()
	$icon.visible = false
	$CollisionShape2D.disabled = true
	Resources.power_melon = true
	Resources.melon_timer = 15
	if Resources.current_life < Resources.max_life:
		Resources.current_life += 1
	yield($crunch,"finished")
	
	queue_free()
