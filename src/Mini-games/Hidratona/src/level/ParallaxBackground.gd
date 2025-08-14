extends ParallaxBackground

var parallax_offset = 0
var time = 0.0

var obstacules

var dash_timer = 0

func _ready():
	pass

func _process(delta):
	if Resources.in_hole:
		set_process(false)
	else:
		set_process(true)
	if dash_timer > 0:
		dash_timer -= delta
		
		if dash_timer <= 0:
			Resources.parallax_speed = 1200
	
	parallax_offset -= delta * Resources.parallax_speed
	set_scroll_offset(Vector2(parallax_offset, 0))
	
	return
	
	time += 1 * delta
	if time > 5:
		var node = preload("res://src/Mini-games/Hidratona/src/objects/obstacules.tscn")
		var scene = node.instance()
		get_parent().add_child(scene)
		obstacules = scene
		time = 0
		
	#if Resources.heart <= 0 or Resources.current_life <= 0:
	#	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/GameOver.tscn")
	
func paralax_dash():
	Resources.parallax_speed *= 2
	dash_timer = 1

func increment_parallax_speed():
	return
	# Por enquanto o aumento de velocidade está desligado
	var percent = Resources.parallax_speed * 0.1
	Resources.parallax_speed += percent

func _on_Timer_speed_timeout():
	 increment_parallax_speed()
