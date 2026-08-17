extends ParallaxBackground

var in_hole = false
var paralax
signal fall

var dash_timer = 0

var parallax_offset = 0
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
var rng3 = RandomNumberGenerator.new()
var rng4 = RandomNumberGenerator.new()

var positions

var Trash = preload("res://src/Mini-games/Hidratona/src/objects/Trash.tscn")
var Mosquito = preload("res://src/Mini-games/Hidratona/src/objects/Mosquito.tscn")
var Hole = preload("res://src/Mini-games/Hidratona/src/objects/hole.tscn")

var fruit = [preload("res://src/Mini-games/Hidratona/src/objects/water.tscn"),preload("res://src/Mini-games/Hidratona/src/objects/Orange.tscn"),preload("res://src/Mini-games/Hidratona/src/objects/Watermelon.tscn"),
preload("res://src/Mini-games/Hidratona/src/objects/Strawberry.tscn")]

var timer_1 = 6

func _ready():
	# Tutorial obstacles are spawned explicitly via start() calls from
	# TutorialController.gd, not randomly like the regular obstacules.gd.
	return

func start(obstacule, position):
	positions = $ParallaxLayer.get_children()
	self.add_to_group("parallax")
	
	if obstacule == "Hole":
		return
	elif obstacule == "Mosquito":
		$ParallaxLayer/hole.queue_free()
		
		var mosquito = Mosquito.instance()
		$ParallaxLayer/Position2D.add_child(mosquito)
		mosquito.start($ParallaxLayer/Position2D.global_position)
		return
	elif obstacule == "Water":
		$ParallaxLayer/hole.queue_free()
		
		var water = fruit[0].instance()
		$ParallaxLayer/Position2D.add_child(water)
		water.start($ParallaxLayer/Position2D.global_position)

		var orange = fruit[1].instance()
		$ParallaxLayer/Position2D2.add_child(orange)
		orange.start($ParallaxLayer/Position2D2.global_position)

		var watermelon = fruit[2].instance()
		$ParallaxLayer/Position2D3.add_child(watermelon)
		watermelon.start($ParallaxLayer/Position2D3.global_position)

		var strawberry = fruit[3].instance()
		$ParallaxLayer/Position2D4.add_child(strawberry)
		strawberry.start($ParallaxLayer/Position2D4.global_position)	

func _process(delta):
	parallax_offset -= delta * Resources.parallax_speed
	set_scroll_offset(Vector2(parallax_offset, 0))

func _on_Area2D_body_entered(body):
	if body.name == "Player" and $ParallaxLayer/hole/CollisionShape2D.disabled == false:
		$ParallaxLayer/hole/CollisionShape2D.disabled = true
		$ParallaxLayer/hole/playInHole.visible = true
		emit_signal("fall")
		Resources.in_hole = true
		Resources.heart -= 1
		for p in get_tree().get_nodes_in_group("parallax"):
			p.set_process(false)
		$Timer.start()

func _on_Timer_timeout():
	$ParallaxLayer/hole/playInHole.visible = false
	for p in get_tree().get_nodes_in_group("parallax"):
		p.set_process(true)
	Resources.in_hole = false

func _on_hole_body_entered(body: Node) -> void:
	_on_Area2D_body_entered(body)
