extends Node

var moving = []
var pressing = false
var tile

func _unhandled_input(event: InputEvent) -> void:
	if is_moving():
		return
	
	if event is InputEventScreenDrag and pressing and tile != null and event.is_pressed():
		var direction = get_relative_direction(event.relative)
		tile.move_to(direction)
		tile = null
	elif event is InputEventMouseMotion and pressing and tile != null :
		var direction = get_relative_direction(event.relative)
		tile.move_to(direction)
		tile = null
	
	if event is InputEventScreenTouch and pressing and !event.is_pressed():
		pressing = false

func set_tile(_tile):
	tile = _tile

func get_relative_direction(relative):
	var relative_x = abs(relative.x)
	var relative_y = abs(relative.y)
	
	if(relative_x > relative_y):
		var aux = relative.x
		if(aux > 2):
			return "Right"
		elif(aux < 2):
			return "Left"
	else:
		var aux = relative.y
		if(aux > 2):
			return "Bottom"
		elif(aux < 2):
			return "Top"

func move(fruit):
	moving.append(fruit)

func stop_moving(fruit):
	moving.erase(fruit)

func is_moving() -> bool:
	return !moving.empty()

func reset_all():
	moving = []
	pressing = false
