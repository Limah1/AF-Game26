class_name Board
extends Node2D

var SWF = preload("res://src/Mini-games/Match-3/src/GUI/Show_Which_Fruit.tscn")

var instance_timer = 0.3
var rng = RandomNumberGenerator.new()
var start = 0
var line_quant

var checked = false

var preview_points;

var fruit_max_count = 81

var can_start = false
var allfruits = []
#onready var animation: AnimationPlayer = $AnimationPlayer

var AllTiles = []
var alltiles = []

#var reaction = {
#	"sad":preload("res://assets/Match-3/sprites/personagens/girl-triste.png"),
#	"very-sad":preload("res://assets/Match-3/sprites/personagens/girl-muito-triste.png"),
#	"normal":preload("res://assets/Match-3/sprites/personagens/girl-seria.png"),
#	"happy":preload("res://assets/Match-3/sprites/personagens/girl-alegre.png"),
#	"very-happy":preload("res://assets/Match-3/sprites/personagens/girl-muito-feliz.png")
#}

var reaction = {
	
}

var good_fruits_name = [
	"Watermelon",
	"RiceAndBean",
	"Water",
	"Juice",
	"Apple",
	"IceCream",
	"Fish",
	"Orange"
]

var harmful_fruits_name = [
	"Hamburguer",
	"Pizza",
	"Soda",
]

var selected_good_fruits = []
var selected_harmful_fruit

var AllFruits = [
	#load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Egg.tscn"),
]

func _ready():
	var sprites = CharacterController.all_sprites.match3
	
	reaction = {
		"sad": sprites.sad,
		"very-sad": sprites.very_sad,
		"normal": sprites.serious,
		"happy": sprites.happy,
		"very-happy": sprites.very_happy
	}
	
	$character.texture = reaction.normal
	
	preview_points = 0
	
	for i in range(3):
		rng.randomize()
		var random_number = rng.randi_range(0,good_fruits_name.size()-1)
		
		while selected_good_fruits.has(good_fruits_name[random_number]):
			rng.randomize()
			random_number = rng.randi_range(0,good_fruits_name.size()-1)
			
		selected_good_fruits.append(good_fruits_name[random_number])
	
	rng.randomize()
	selected_harmful_fruit = harmful_fruits_name[rng.randi_range(0, harmful_fruits_name.size() - 1)]
	
	
	for fruit in selected_good_fruits:
		AllFruits.append(get_fruit_by_name(fruit))
	AllFruits.append(get_fruit_by_name(selected_harmful_fruit))
	
	S_Conntroller.set_reference(selected_good_fruits, selected_harmful_fruit)
	
	$Score.start(selected_good_fruits, selected_harmful_fruit)

func _physics_process(delta: float) -> void:
	if !can_start:
		return
	
	set_reaction()
	
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
	
	if(get_tree().get_nodes_in_group("fruits").size() == fruit_max_count):
		instance_timer = 0.3
		return

	instance_timer -= delta
	if(instance_timer <= 0):
		for tile in AllTiles[0]:
			if !is_instance_valid(tile.fruit):
				instance_timer = 0.5
				
				#LoadFruit here
				#First randomize for selecting if it will be a harmfull or not,
				#with a 5% of being harmfull
				rng.randomize()
				var random_number = rng.randi_range(1,20)
				if random_number == 1:
					add_fruit(tile, AllFruits[3])
				else:
					rng.randomize()
					random_number = rng.randi_range(0,2)
					add_fruit(tile, AllFruits[random_number])
	
	if (S_Conntroller.chances == 0):
		S_Conntroller.last_result_won = false
		get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Win.tscn")
#	if (
#		(S_Conntroller.goals[0] == S_Conntroller.score1 
#		and S_Conntroller.goals[1] == S_Conntroller.score2
#		and S_Conntroller.goals[2] == S_Conntroller.score3)
#		):
#		get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Win.tscn")

	if S_Conntroller.totalScore >= S_Conntroller.goalScore:
		S_Conntroller.last_result_won = true
		get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Win.tscn")

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
	
	if S_Conntroller.last_fruit_is_harmful:
		$character.texture = reaction["very-sad"]
	
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
	return
	$"info-box".layer = 200
	$"info-box/ColorRect".visible = true
	#animation.play("fade_in")
	#yield(animation, "animation_finished")
	print("2")

func _on_TextureButton_pressed():
	return	
	#animation.play("fade_out")
	#yield(animation, "animation_finished")
	$"info-box".layer = -200
	$"info-box/ColorRect".visible = false
	print("1")

func _on_LeaveButton_pressed() -> void:
	S_Conntroller.tutorial = false

	S_Conntroller.chances = 15
	S_Conntroller.last_result_won = true
	S_Conntroller.score1 = 0
	S_Conntroller.score2 = 0	
	S_Conntroller.score3 = 0
	S_Conntroller.checked = true
	S_Conntroller.tilestodestroy = [] 
	
	
	C_Controller.started = false

	C_Controller.center = null
	C_Controller.score_t = []
	C_Controller.score_r = []
	C_Controller.score_l = []
	C_Controller.score_b = []
	
	M_Controller.moving = []
	M_Controller.pressing = false
	M_Controller.tile = null
	
	get_parent().get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Main.tscn")
	
