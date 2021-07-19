extends Node2D

var current_room

var bedroom = preload("res://src/UI/Rooms/Bedroom.tscn")
var livingroom = preload("res://src/UI/Rooms/LivingRoom.tscn")
var yard = preload("res://src/UI/Rooms/Yard.tscn")
var bathroom = preload("res://src/UI/Rooms/Bathroom.tscn")
var kitchen = preload("res://src/UI/Rooms/Kitchen.tscn")

func _ready() -> void:
	CharacterController.player_ref = $Player/Player
	
	AnimationController.set_animation_player($Player/AnimationPlayer)
	
	if(AnimationController.status == "Started" or AnimationController.status == "MainGame" or AnimationController.status == "DoiAqui"):
		started()
	elif(AnimationController.status == "Match3"):
		back_from_match3()
	elif(AnimationController.status == "Hidratona"):
		back_from_hidratona()
	elif(AnimationController.status == "Sleeping"):
		back_from_sleeping()

func started():
	AnimationController.status = "MainGame"
	Resources.weather_randomize()
	
	var Yard = yard.instance()
	Yard.start($Slots/Slot5)
	add_child(Yard)
	
	var lr = livingroom.instance()
	lr.start($Slots/Slot6)
	add_child(lr)
	$Slots/Slot6.current_room = lr
	AnimationController.current_room = lr
	
	var kt = kitchen.instance()
	kt.start($Slots/Slot7)
	add_child(kt)
	
	var br = bedroom.instance()
	br.start($Slots/Slot8)
	add_child(br)
	
	var bth = bathroom.instance()
	bth.start($Slots/Slot9)
	add_child(bth)

func back_from_match3():
	AnimationController.status = "MainGame"
	NecessityBars.eating = false
	
	var Yard = yard.instance()
	Yard.start($Slots/Slot4)
	add_child(Yard)
	
	var lr = livingroom.instance()
	lr.start($Slots/Slot5)
	add_child(lr)
	
	var kt = kitchen.instance()
	kt.start($Slots/Slot6)
	add_child(kt)
	$Slots/Slot6.current_room = kt
	AnimationController.current_room = kt
	
	var br = bedroom.instance()
	br.start($Slots/Slot7)
	add_child(br)
	
	var bth = bathroom.instance()
	bth.start($Slots/Slot8)
	add_child(bth)

func back_from_hidratona():
	AnimationController.status = "MainGame"
	NecessityBars.fun = false
		
	var Yard = yard.instance()
	Yard.start($Slots/Slot6)
	add_child(Yard)
	current_room = Yard
	$Slots/Slot6.current_room = Yard
	AnimationController.current_room = Yard
	
	var lr = livingroom.instance()
	lr.start($Slots/Slot7)
	add_child(lr)
	
	var kt = kitchen.instance()
	kt.start($Slots/Slot8)
	add_child(kt)
	
	var br = bedroom.instance()
	br.start($Slots/Slot9)
	add_child(br)
	
	var bth = bathroom.instance()
	bth.start($Slots/Slot10)
	add_child(bth)

func back_from_sleeping():
	var Yard = yard.instance()
	Yard.start($Slots/Slot3)
	add_child(Yard)
	
	var lr = livingroom.instance()
	lr.start($Slots/Slot4)
	add_child(lr)
	
	var kt = kitchen.instance()
	kt.start($Slots/Slot5)
	add_child(kt)
	
	var br = bedroom.instance()
	br.start($Slots/Slot6)
	br.back_sleeping()
	add_child(br)
	$Slots/Slot6.current_room = br
	AnimationController.current_room = br
	
	var bth = bathroom.instance()
	bth.start($Slots/Slot7)
	add_child(bth)

func _process(delta: float) -> void:
	current_room = $Slots/Slot6.current_room
	AnimationController.current_room = $Slots/Slot6.current_room
	
	if (NecessityBars.some_problem != ""):
		$"Player/pop-up-emergencia/AnimationPlayer".play("fade_in_out")
	else:
		$"Player/pop-up-emergencia/AnimationPlayer".stop()

