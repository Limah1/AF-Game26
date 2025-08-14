extends Node2D
export(float) var speed = 600.0

func _draw():
	draw_rect(Rect2(Vector2(-10, -20), Vector2(50, 100)), Color(0.5, 0.5, 0.5))

func _process(delta):
	position.x -= speed * delta
	if position.x < -50:
		queue_free()
