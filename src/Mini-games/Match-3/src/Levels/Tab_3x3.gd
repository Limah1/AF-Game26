extends Node2D

var SWF = preload("res://src/Mini-games/Match-3/src/GUI/Show_Which_Fruit.tscn")

var instance_timer = 0.3
var rng = RandomNumberGenerator.new()
var start = 0
var line_quant

var tutorial_stopped = false

var preview_points = 0

var fruit_max_count = 9

var can_start = false
var allfruits = []
onready var animation: AnimationPlayer = $AnimationPlayer

var AllTiles = []
var alltiles = []

var reaction = {
	"sad":preload("res://assets/Match-3/sprites/personagens/girl-triste.png"),
	"very-sad":preload("res://assets/Match-3/sprites/personagens/girl-muito-triste.png"),
	"normal":preload("res://assets/Match-3/sprites/personagens/girl-seria.png"),
	"happy":preload("res://assets/Match-3/sprites/personagens/girl-alegre.png"),
	"very-happy":preload("res://assets/Match-3/sprites/personagens/girl-muito-feliz.png")
}


var AllFruits = [
	"Water",
	"RiceAndBean",
	"Watermelon",
	"Hamburguer"
]

var Ordem = [
	["Hamburguer", "Watermelon", "Water"],
	["RiceAndBean", "Watermelon", "RiceAndBean"],
	["Watermelon", "Water", "RiceAndBean"],
	["Watermelon", "Hamburguer", "Water"],
	["Hamburguer", "Hamburguer", "Water"]

]

func _ready():
	S_Conntroller.goals = [3,3,3]
	
	AllTiles = [
		$Fila1.get_children(),
		$Fila2.get_children(),
		$Fila3.get_children(),
	]
	
	fruit_max_count = 9
	line_quant = 3
	
	AllTiles = [
		$Fila1.get_children(),
		$Fila2.get_children(),
		$Fila3.get_children(),
	]
	
	allfruits = [
		["Water", "Water", "Hamburguer"],
		["Hamburguer", "RiceAndBean", "Water"],
		["Watermelon", "Hamburguer", "Watermelon"]
	]
	can_start = true
	
	alltiles = AllTiles[0] + AllTiles[1] + AllTiles[2]

	S_Conntroller.set_reference(["Water", "RiceAndBean", "Watermelon"], "Hamburguer")
	
	$Score.start(["Water", "RiceAndBean", "Watermelon"], "Hamburguer")

func _physics_process(delta: float) -> void:
	if !can_start:
		return
	if(start < line_quant && can_start):
		instance_timer -= delta
		if(instance_timer <= 0):
			instance_timer = 0.5
			var index = 0
			for tile in AllTiles[0]:
				add_fruit(tile, get_fruit_by_name(allfruits[start][index]))
				index+=1
			start += 1
		return

	C_Controller.started = true
	
	if get_tree().get_nodes_in_group("fruits").size() == fruit_max_count and !tutorial_stopped:
		
		
		return
	
	if(get_tree().get_nodes_in_group("fruits").size() == fruit_max_count):
		instance_timer = 0.3
		return
	
	instance_timer -= delta
	if(instance_timer <= 0):
		var index = 0
		for tile in AllTiles[0]:
			if tile.fruit == null:
				instance_timer = 0.5
				rng.randomize()
				add_fruit(tile, get_fruit_by_name(Ordem[0][index]))
				index += 1
		Ordem.remove(0)
	
	if (S_Conntroller.chances == 0):
		get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Win.tscn")
	if (S_Conntroller.goals[0] == S_Conntroller.score1 and S_Conntroller.goals[1] == S_Conntroller.score2
	and S_Conntroller.goals[2] == S_Conntroller.score3):
		S_Conntroller.tutorial = true
		get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Win.tscn")
	set_reaction()

func start(fruits):
	fruits.invert()
	allfruits = fruits
	can_start = true

func add_fruit(tile, Fruit):
	var fruit = Fruit.instance()
	fruit.start(tile)
	tile.fruit = fruit
	add_child(fruit)

func get_fruit_by_name(fruit_name):
	if fruit_name == "Hamburguer":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Hamburguer.tscn")
	elif fruit_name == "RiceAndBean":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/RiceAndBean.tscn")
	elif fruit_name == "Juice":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Juice.tscn")
	elif fruit_name == "Water":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Water.tscn")
	elif fruit_name == "Watermelon":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Watermelon.tscn")
	elif fruit_name == "Apple":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Apple.tscn")
	elif fruit_name == "IceCream":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/IceCream.tscn")
	elif fruit_name == "Pizza":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Pizza.tscn")
	elif fruit_name == "Orange":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Orange.tscn")
	elif fruit_name == "Fish":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Fish.tscn")
	elif fruit_name == "Salad":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Salad.tscn")
	elif fruit_name == "Soda":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Soda.tscn")
	elif fruit_name == "Egg":
		return load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Egg.tscn")

func check_map_combinations():
	while get_tree().get_nodes_in_group("fruits").size() < fruit_max_count:
		yield(countdown(), "completed") 
	
	M_Controller.move(self)
	
	var has_combination = false
	
	for tile in alltiles:
		if tile.check_combinations():
			has_combination = true
	
	if !has_combination:
		M_Controller.stop_moving(self)
		
		S_Conntroller.ResetTiles()
		C_Controller.reset_score()
		return
	
	S_Conntroller.DestroyTiles()
	C_Controller.reset_score()
	
	yield(countdown(), "completed") 
	yield(countdown(), "completed") 
	
	if get_tree().get_nodes_in_group("fruits").size() < fruit_max_count:
		yield(countdown(), "completed") 

	
	check_map_combinations()
	
	S_Conntroller.checked = true
	M_Controller.stop_moving(self)
	return

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(1.5), "timeout")

func set_reaction():
	var max_points = get_node("Score/HealthDisplay/HealthBar").max_value
	var value = get_node("Score").value
	if preview_points > value and value < max_points * 0.4 :
		if value < max_points * 0.2:
			$character.texture = reaction["very-sad"]
		elif value < max_points * 0.4:
			$character.texture = reaction["sad"]
	else:
		if value > max_points * 0.8:
			$character.texture = reaction["very-happy"]
		elif value > max_points * 0.5:
			$character.texture = reaction["happy"]
		elif value > max_points * 0.2:
			$character.texture = reaction["normal"]
		preview_points = value

func _on_TextureButton2_button_up():
	$"info-box".layer = 200
	$"info-box/ColorRect".visible = true
	animation.play("fade_in")
	yield(animation, "animation_finished")

func _on_TextureButton_pressed():
	animation.play("fade_out")
	yield(animation, "animation_finished")
	$"info-box".layer = -200
	$"info-box/ColorRect".visible = false



