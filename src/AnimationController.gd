extends Node

var status = "Started"

var slots_reference = null

var current_room
var is_room_moving = false
var is_travelling = false

var anim_player: AnimationPlayer
var sound_flush: AudioStreamPlayer2D
var toilet_paper: AudioStreamPlayer2D

var bathroom_animplayer: AnimationPlayer

func _ready() -> void:
	add_to_group("Persist")

func set_animation_player(ap: AnimationPlayer):
	anim_player = ap

func go_to(dir):
	if(dir == "left"):
		anim_player.play("go_to_left")
	elif(dir == "right"):
		anim_player.play("go_to_right")
	elif(dir == "special" or dir == "special2"):
		anim_player.play("go_to_left")
	
	yield(anim_player , "animation_finished")
	return

func reach_from(dir):
	print(dir)
	if(dir == "left" or dir == "special" or dir == "special2"):
		anim_player.play("reach_from_left")
	elif(dir == "right" ):
		anim_player.play("reach_from_right")
	
	yield(anim_player , "animation_finished")
	return

func travel(from, to):
	var result = from - to
	is_travelling = true
	
	print(from)
	
	if(from == 5):
		slots_reference.to_right(to)
		
		print("to left")
		yield(go_to("special"), "completed")
		get_tree().call_group("rooms", "go_to", "special")
		print("reach from left")		
		yield(current_room, "stop_moving")
		
		slots_reference.reset_rooms("L")
		
		is_travelling = false
		return
	
	if(to == 0):
		slots_reference.to_left(to)
		
		yield(go_to("special2"), "completed")
		get_tree().call_group("rooms", "go_to", "special2")
		yield(current_room, "stop_moving")
		
		slots_reference.reset_rooms("R")
		
		is_travelling = false		
		return
	
	if result < 0:
		slots_reference.to_right(to)
		
		yield(go_to("right"), "completed")
		get_tree().call_group("rooms", "go_to", "left")
		yield(current_room, "stop_moving")
		
		slots_reference.reset_rooms("L")

	elif result > 0:
		slots_reference.to_left(to)
		
		yield(go_to("left"), "completed")
		get_tree().call_group("rooms", "go_to", "right")
		yield(current_room, "stop_moving")
		
		slots_reference.reset_rooms("R")

	else:
		is_travelling = false
		return
	
	is_travelling = false

func go_to_bath():
	anim_player.play("go_to_bath")
	yield(anim_player, "animation_finished")

func go_to_bed():
	anim_player.play("go_to_bed")
	yield(anim_player, "animation_finished")

func already_on_bed():
	anim_player.play("already_on_bed")
	yield(anim_player, "animation_finished")

func wake_up_from_bed():
	anim_player.play("wake_up")
	yield(anim_player, "animation_finished")

func return_from_bath():
	anim_player.play("return_from_bath")
	yield(anim_player, "animation_finished")

func go_to_toilet():
	anim_player.play("go_to_toilet")
	yield(anim_player, "animation_finished")

func return_from_toilet():
	sound_flush.play()
	
	bathroom_animplayer.play("toilet_paper")
	yield(countdown(), "completed")
	anim_player.play("start")
	yield(bathroom_animplayer, "animation_finished")
	
	
	anim_player.play("start")



func is_playing():
	if(!anim_player || !is_instance_valid(anim_player)):
		return false
	
	return anim_player.is_playing()

func isTravelling():
	return is_travelling

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(2), "timeout")

func save():
	var save_dict = {
		"filename" : "AnimationController",
		"status" : status,
	}
	
	return save_dict
