class_name Temp_Tab
extends Node2D

var instance_timer = 0.3
var rng = RandomNumberGenerator.new()
var start = 9
var checked = false

var can_start = false


var AllFruits = [
	load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Egg.tscn"),
]

var AllTiles = []
var alltiles = []


func start(_AllFruits):
	can_start = true
	AllFruits = _AllFruits

func _physics_process(delta: float) -> void:	
	if(!can_start):
		return
	
	if(start > 0):
		instance_timer -= delta
		if(instance_timer <= 0):
			start -= 1
			instance_timer = 0
			for tile in AllTiles[0]:
				rng.randomize()
				var random_number = rng.randi_range(0,4)
				add_fruit(tile, AllFruits[random_number])
		
		return
	
	if(checked == false):
		check_generated_map()
		send_fruits_to_main_tab()

func check_generated_map():
	for tile in alltiles:
		if tile.check_combinations():
			var oldfruit = tile.fruit
			rng.randomize()
			var random_number = rng.randi_range(0,4)
			add_fruit(tile, AllFruits[random_number])
			
			S_Conntroller.ResetTiles()
			
			check_generated_map()
	
	checked = true

func send_fruits_to_main_tab():
	var tiles_to_send = []
	
	for fila in AllTiles:
		var _fila = []
		
		for tile in fila:
			_fila.append(tile.fruit.fruit_name)
		
		tiles_to_send.append(_fila)
	
	S_Conntroller.score1 = 0
	S_Conntroller.score2 = 0
	S_Conntroller.score3 = 0

	get_parent().start(tiles_to_send)
	queue_free()

func add_fruit(tile, Fruit):
	var fruit = Fruit.instance()
	fruit.start(tile)
	tile.fruit = fruit
	add_child(fruit)
