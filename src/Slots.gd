extends Node2D

var bedroom = preload("res://src/UI/Rooms/Bedroom.tscn")
var livingroom = preload("res://src/UI/Rooms/LivingRoom.tscn")
var yard = preload("res://src/UI/Rooms/Yard.tscn")
var bathroom = preload("res://src/UI/Rooms/Bathroom.tscn")
var kitchen = preload("res://src/UI/Rooms/Kitchen.tscn")
var jardim = preload("res://src/UI/Rooms/Jardim.tscn")

onready var slots = [ $Slot1, $Slot2, $Slot3]

func start(id):
	AnimationController.slots_reference = self
	
	var new_room = id_to_preloaded_room(id).instance()
	new_room.start(slots[1])
	get_parent().add_child(new_room)
	get_parent().move_child(new_room, 0)

	AnimationController.current_room = slots[1].current_room
	
#	if(id == 0):
#		new_room.room_id = 5
		
	slots[1].current_room = new_room
	

func to_left(id):
	var new_room = id_to_preloaded_room(id).instance()
	new_room.start(slots[0])
	get_parent().add_child(new_room)
	get_parent().move_child(new_room, 0)

	slots[0].current_room = new_room

func to_right(id):
	var new_room = id_to_preloaded_room(id).instance()
	new_room.start(slots[2])
	get_parent().add_child(new_room)
	get_parent().move_child(new_room, 0)

	slots[2].current_room = new_room

func id_to_preloaded_room(id):
	if(id == 0):
		return yard
	elif(id == 1):
		return livingroom
	elif(id == 2):
		return kitchen
	elif(id == 3):
		return bedroom
	elif(id == 4):
		return bathroom
	elif(id == 5):
		return jardim

func reset_rooms(side):
	if(side == "L"):
		slots[0].current_room.queue_free()
	if(side == "R"):
		slots[2].current_room.queue_free()

func _process(delta):
	AnimationController.current_room = slots[1].current_room
