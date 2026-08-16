extends Node2D

var waitingroom = preload("res://src/UI/Rooms/hospital_rooms/WaitingRoom.tscn")
var dentist = preload("res://src/UI/Rooms/hospital_rooms/Dentist.tscn")
var pediatrician = preload("res://src/UI/Rooms/hospital_rooms/Pediatrician.tscn")
var psychologist = preload("res://src/UI/Rooms/hospital_rooms/Psychologist.tscn")

onready var slots = [ $Slot1, $Slot2, $Slot3]

func start(id):
	AnimationController.slots_reference = self

	var room_resource = id_to_preloaded_room(id)
	if room_resource == null:
		push_error("SlotsHospital.start: no hospital room mapped for id %s" % str(id))
		return
	var new_room = room_resource.instance()
	new_room.start(slots[1])
	get_parent().add_child(new_room)

	AnimationController.current_room = slots[1].current_room

#	if(id == 0):
#		new_room.room_id = 5

	slots[1].current_room = new_room


func to_left(id):
	var room_resource = id_to_preloaded_room(id)
	if room_resource == null:
		push_error("SlotsHospital.to_left: no hospital room mapped for id %s" % str(id))
		return
	var new_room = room_resource.instance()
	new_room.start(slots[0])
	get_parent().add_child(new_room)

	slots[0].current_room = new_room

func to_right(id):
	var room_resource = id_to_preloaded_room(id)
	if room_resource == null:
		push_error("SlotsHospital.to_right: no hospital room mapped for id %s" % str(id))
		return
	var new_room = room_resource.instance()
	new_room.start(slots[2])
	get_parent().add_child(new_room)

	slots[2].current_room = new_room

func id_to_preloaded_room(id):
	# The hospital only has rooms 1-4 (WaitingRoom, Pediatrician, Dentist, Psychologist).
	# ids 0/5 (Yard/Jardim equivalents in the house) have no hospital counterpart, so
	# they intentionally fall through to null and are guarded against by callers above.
	if(id == 1):
		return waitingroom
	elif(id == 2):
		return pediatrician
	elif(id == 3):
		return dentist
	elif(id == 4):
		return psychologist
	return null

func reset_rooms(side):
	if(side == "L"):
		slots[0].current_room.queue_free()
	if(side == "R"):
		slots[2].current_room.queue_free()

func _process(delta):
	AnimationController.current_room = slots[1].current_room
