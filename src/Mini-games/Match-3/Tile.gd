class_name Tile
extends KinematicBody2D

onready var raycast_T: RayCast2D = $RayCast_Top
onready var raycast_R: RayCast2D = $RayCast_Right
onready var raycast_L: RayCast2D = $RayCast_Left
onready var raycast_B: RayCast2D = $RayCast_Bottom

var fruit = null
var pressing = false

func _on_Tile_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !S_Conntroller.checked or M_Controller.is_moving():
		return
	
	if event is InputEventScreenTouch and event.is_pressed() and !M_Controller.is_moving():
		M_Controller.pressing = true
		M_Controller.set_tile(self)
	
	elif event is InputEventMouseButton and event.is_pressed() and !M_Controller.is_moving():
		M_Controller.pressing = true
		M_Controller.set_tile(self)

func add_fruit(new_fruit):
	fruit = new_fruit
	if(!is_instance_valid(fruit)):
		return
	fruit.reparenting(self)

func remove_fruit():
	var aux = fruit
	fruit = null
	return aux

func check_on_direction_tile(dir):	
	#Checking Top
	if(
		dir == "Top" && 
		raycast_T.is_colliding() && 
		fruit != null
	):
		return raycast_T.get_collider()
	
	#Checking Bottom
	elif(
		dir == "Bottom" && 
		raycast_B.is_colliding() && 
		fruit != null
	):
		return raycast_B.get_collider()
	
	#Checking Left
	elif(
		dir == "Left" && 
		raycast_L.is_colliding() && 
		fruit != null
	):
		return raycast_L.get_collider()
	
	#Checking Right
	elif(
		dir == "Right" && 
		raycast_R.is_colliding() && 
		fruit != null
	):
		return raycast_R.get_collider()
	else:
		return null

func _physics_process(delta: float) -> void:
	check_bellow()

func check_bellow():
	var tile: Tile = check_on_direction_tile("Bottom")
	if tile != null && is_instance_valid(tile) && !is_instance_valid(tile.fruit):
		var _fruit = remove_fruit()
		tile.add_fruit(_fruit)

func move_to(direction):
	var tile = check_on_direction_tile(direction)
	
	if(tile == null):
		return
	
	var aux = tile.fruit
	var aux2 = fruit
	add_fruit(aux)
	tile.add_fruit(aux2)
	
	M_Controller.move(aux)
	M_Controller.move(aux2)
	
	
	yield(countdown(), "completed") # waiting for the countdown() function to complete
	
	var main_tile_result = check_combinations()
	var moved_tile_result = tile.check_combinations()
	
	if !main_tile_result and !moved_tile_result:
		add_fruit(aux2)
		tile.add_fruit(aux)
		C_Controller.reset_score()
		M_Controller.stop_moving(aux)
		M_Controller.stop_moving(aux2)
		return
	
	M_Controller.stop_moving(aux)
	M_Controller.stop_moving(aux2)
	
	#S_Conntroller.DestroyTiles()
	
	
	get_parent().get_parent().check_map_combinations()	
	
#	yield(countdown(), "completed") 
#	yield(countdown(), "completed") 
#	yield(countdown(), "completed")  
	
#	get_parent().get_parent().check_map_combinations()
	S_Conntroller.chances -= 1

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(0.8), "timeout")

func check_combinations():
	C_Controller.center = self
	
	#Checking top
	check_for_points(fruit.fruit_name, "Top")
	
	#Checking bot
	check_for_points(fruit.fruit_name, "Bottom")
	
	#Checking Left
	check_for_points(fruit.fruit_name, "Left")
	
	#Checking Right
	check_for_points(fruit.fruit_name, "Right")
	
	return C_Controller.score()

func check_for_points(fruit_name, dir):
	if fruit != null && fruit.fruit_name == fruit_name:
		C_Controller.add_score(self, dir)
		var tile = check_on_direction_tile(dir)
		if tile != null:
			tile.check_for_points(fruit_name, dir)
