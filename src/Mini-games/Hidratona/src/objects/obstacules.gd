extends ParallaxBackground

var in_hole = false
var paralax
signal fall

var parallax_offset = 0
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
var rng3 = RandomNumberGenerator.new()
var rng4 = RandomNumberGenerator.new()
var fruit = [preload("res://src/Mini-games/Hidratona/src/objects/water.tscn"),preload("res://src/Mini-games/Hidratona/src/objects/Watermelon.tscn"),
preload("res://src/Mini-games/Hidratona/src/objects/Strawberry.tscn"),preload("res://src/Mini-games/Hidratona/src/objects/Orange.tscn")]

func _ready():
	if !Resources.in_hole:
		$ParallaxLayer/hole/playInHole.visible = false
	rng.randomize()
	rng2.randomize()
	
	rng3.randomize()
	rng4.randomize()
	
	#Criando lixo em um dos lugares aleatorios
	var trash_random = rng3.randi_range(0,2)
	var nodeTrash = preload("res://src/Mini-games/Hidratona/src/objects/Trash.tscn")
	var sceneTrash = nodeTrash.instance()
	var posTrash = get_tree().get_nodes_in_group("obstacules")
	sceneTrash.global_position = posTrash[trash_random].position
	$ParallaxLayer.add_child(sceneTrash)

	#Criando mosquitos em um dos lugares aleatorios	
	var radom_mosquito = rng3.randi_range(0,2)
	var nodeMosquito = preload("res://src/Mini-games/Hidratona/src/objects/Mosquito.tscn")
	var sceneMosquito = nodeMosquito.instance()
	var posMosquito = get_tree().get_nodes_in_group("mosquito")
	var sizeMosquito = posMosquito.size() - 1
	sceneMosquito.global_position = posMosquito[radom_mosquito].position
	$ParallaxLayer.add_child(sceneMosquito)
	

	
	var pos = get_tree().get_nodes_in_group("position");
	
	#Criando frutas em um dos lugares aleatorios		
	var random_number = rng.randi_range(0, 3)
	var index_random =rng2.randi_range(0, 3)
	var node = fruit[index_random]
	var scene = node.instance()
	scene.global_position = pos[random_number].position
	$ParallaxLayer.add_child(scene)
	
func _process(delta):
	if !Resources.in_hole:
		$ParallaxLayer/hole/playInHole.visible = false
	parallax_offset -= delta * Resources.parallax_speed
	set_scroll_offset(Vector2(parallax_offset, 0))

func _on_Area2D_body_entered(body):
	if body.name == "Player" and $ParallaxLayer/hole/CollisionShape2D.disabled == false:
		$ParallaxLayer/hole/CollisionShape2D.disabled = true
		emit_signal("fall")
		Resources.in_hole = true
		Resources.heart -= 1
		$ParallaxLayer/hole/playInHole.visible = true
		paralax = get_tree().get_nodes_in_group("parallax")
		for p in paralax:
			p.set_process(false)
		$Timer.start()

func _on_Timer_timeout():
	$ParallaxLayer/hole/playInHole.visible = false
	set_process(true)
	paralax = get_tree().get_nodes_in_group("parallax")
	for p in paralax:
		p.set_process(true)
	Resources.in_hole = false


func _on_hole_body_entered(body: Node) -> void:
	_on_Area2D_body_entered(body)


func _on_obstacules_tree_exiting():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
