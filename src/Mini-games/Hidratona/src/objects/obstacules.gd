extends ParallaxBackground

var parallax_offset = 0
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
var rng3 = RandomNumberGenerator.new()
var rng4 = RandomNumberGenerator.new()
var fruit = [preload("res://src/Mini-games/Hidratona/src/objects/water.tscn"),preload("res://src/Mini-games/Hidratona/src/objects/Watermelon.tscn"),
preload("res://src/Mini-games/Hidratona/src/objects/Strawberry.tscn"),preload("res://src/Mini-games/Hidratona/src/objects/Orange.tscn")]

func _ready():
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
	parallax_offset -= delta * Resources.parallax_speed
	set_scroll_offset(Vector2(parallax_offset, 0))


func _on_obstacules_tree_exiting():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
