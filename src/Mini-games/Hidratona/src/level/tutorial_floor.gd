extends ParallaxBackground

var parallax_offset = 0
var time = 0.0
var obstacules
var dash_timer = 0

func _ready() -> void:
	self.add_to_group("parallax")

func _process(delta):
	if dash_timer > 0:
		dash_timer -= delta
		
		if dash_timer <= 0:
			Resources.parallax_speed = 1500
	
	parallax_offset -= delta * Resources.parallax_speed
	set_scroll_offset(Vector2(parallax_offset, 0))
	
		
	if Resources.heart <= 0 or Resources.current_life <= 0:
		get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/GameOver.tscn")
	
func paralax_dash():
	Resources.parallax_speed = 3000
	dash_timer = 1
