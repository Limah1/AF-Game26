class_name Room
extends Control

signal stop_moving

var room_id
var roomslot
var last_dir = ""

var speed = 1500
var position_difference = Vector2(0,0)
var smoothed_velocity = Vector2(0,0)

func start(_roomslot):
	add_to_group("rooms")
	
	rect_size.x = 1920
	rect_size.y = 1080
	
	roomslot = _roomslot
	rect_global_position = roomslot.get_node("position").global_position

func _process(delta: float) -> void:
	movement(delta)

func movement(delta):
	var destination = roomslot.get_node("position").global_position
	
	if(rect_position == destination):
		return
		
	AnimationController.is_room_moving = true
	position_difference = (destination - rect_position).normalized()
	smoothed_velocity = position_difference * speed * delta
	rect_position += smoothed_velocity
	
	var position_diference2 = destination.x - rect_position.x
	if position_diference2 < 25 and position_diference2 > -25:
		rect_position = destination
		AnimationController.is_room_moving = false
		emit_signal("stop_moving")
		yield(AnimationController.reach_from(last_dir), "completed")

func change_room(dir):
	var next_room
	if(dir == "special"):
		next_room = roomslot.get_adjacent_slot("left")
	elif(dir == "special2"):
		next_room = roomslot.get_adjacent_slot("right")
	else:
		next_room = roomslot.get_adjacent_slot(dir)

	if(next_room == null):
		return
	
	roomslot = next_room
	roomslot.set_current_room(self)
	last_dir = dir

func go_to(dir):
	change_room(dir)

