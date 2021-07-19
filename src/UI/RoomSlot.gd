extends Area2D

var current_room

onready var raycast_L = $left
onready var raycast_R = $right

func get_adjacent_slot(dir):
	if (dir == "left" and raycast_L.is_colliding()):
		return raycast_L.get_collider()
	elif (dir == "right" and raycast_R.is_colliding()):
		return raycast_R.get_collider()
	else:
		return null

func set_current_room(room):
	current_room = room
