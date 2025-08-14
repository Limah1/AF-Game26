extends Node2D
export(float) var speed = 600.0

func _draw():
	draw_circle(Vector2.ZERO, 100, Color(1, 0, 0))

func _process(delta):
	position.x -= speed * delta
	if position.x < -50:
		queue_free()
