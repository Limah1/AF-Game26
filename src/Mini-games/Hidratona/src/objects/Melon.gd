extends Area2D


func _ready():
	pass


func _on_Melon_body_entered(body):
	$crunch.play()
	Resources.power_melon = true
	if Resources.current_life < 50:
		Resources.current_life += 1
	queue_free()
