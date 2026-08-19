extends Node2D

var current_room

var bedroom = preload("res://src/UI/Rooms/Bedroom.tscn")
var livingroom = preload("res://src/UI/Rooms/LivingRoom.tscn")
var yard = preload("res://src/UI/Rooms/Yard.tscn")
var bathroom = preload("res://src/UI/Rooms/Bathroom.tscn")
var kitchen = preload("res://src/UI/Rooms/Kitchen.tscn")

onready var legacy_player = $Player/Player
onready var legacy_player_sprites = $Player/Player/player_sprites
onready var legacy_animation_player = $Player/AnimationPlayer
onready var modular_player = $Player/ModularPlayer

func _ready() -> void:
	CharacterController.player_ref = $Player/Player
	
	AnimationController.set_animation_player($Player/AnimationPlayer)
	_setup_modular_player()
	
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

func _process(_delta: float) -> void:
	current_room = $Slots/Slot6.current_room
	AnimationController.current_room = $Slots/Slot6.current_room
	_sync_modular_player()
	
	if (NecessityBars.some_problem != ""):
		$"Player/pop-up-emergencia/AnimationPlayer".play("fade_in_out")
	else:
		$"Player/pop-up-emergencia/AnimationPlayer".stop()

func _setup_modular_player() -> void:
	if modular_player == null or legacy_player == null:
		return
	legacy_player_sprites.visible = false
	modular_player.position = legacy_player.position
	modular_player.scale = Vector2(3, 3)
	modular_player.z_index = legacy_player.z_index
	modular_player.set_state(0)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(modular_player)

func _sync_modular_player() -> void:
	if modular_player == null or legacy_player == null:
		return

	modular_player.position = legacy_player.position
	modular_player.z_index = legacy_player.z_index
	if AnimationController.status == "Sleeping":
		modular_player.visible = false
		return
	modular_player.visible = true

	var animation_name = legacy_animation_player.current_animation
	var movement_animation = legacy_animation_player.is_playing() and (
		animation_name.begins_with("go_to_") or
		animation_name.begins_with("reach_from_") or
		animation_name == "return_from_bath" or
		animation_name == "return_from_toilet"
	)
	var walking = AnimationController.isTravelling() or movement_animation
	var desired_state = 1 if walking else 0
	if modular_player.state != desired_state:
		modular_player.set_state(desired_state)

	if legacy_player_sprites.scale.x != 0.0 and modular_player.has_method("set_facing"):
		modular_player.set_facing(-1 if legacy_player_sprites.scale.x < 0.0 else 1)

