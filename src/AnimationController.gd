extends Node

var status = "Started"

var slots_reference = null

var current_room
var is_room_moving = false
var is_travelling = false

var _travel_failsafe_timer = null

var anim_player: AnimationPlayer
var sound_flush: AudioStreamPlayer
var toilet_paper: AudioStreamPlayer

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
	if is_travelling: return # Evita chamadas duplicadas
	var result = from - to
	is_travelling = true

	# Segurança: se algo der errado, libera a trava após 5 segundos
	_cancel_travel_failsafe()
	_travel_failsafe_timer = get_tree().create_timer(5.0)
	_travel_failsafe_timer.connect("timeout", self, "set", ["is_travelling", false])

	print(from)
	print(to)

	# The hospital has rooms 1-4. Moving right from the Psychologist (4)
	# wraps to the Waiting Room (1) while preserving the rightward transition.
	if status == "Hospital" and from == 4 and to == 1:
		slots_reference.to_right(to)

		yield(go_to("right"), "completed")
		get_tree().call_group("rooms", "go_to", "left")
		yield(current_room, "stop_moving")

		slots_reference.reset_rooms("L")

		_finish_travel()
		return

	if(from == 5):
		slots_reference.to_right(to)

		print("to left")
		yield(go_to("special"), "completed")
		get_tree().call_group("rooms", "go_to", "special")
		print("reach from left")
		yield(current_room, "stop_moving")

		slots_reference.reset_rooms("L")

		_finish_travel()
		return

	if(to == 0):
		slots_reference.to_left(to)

		yield(go_to("special2"), "completed")
		get_tree().call_group("rooms", "go_to", "special2")
		yield(current_room, "stop_moving")

		slots_reference.reset_rooms("R")

		_finish_travel()
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
		_finish_travel()
		return

	_finish_travel()

func _finish_travel():
	is_travelling = false
	_cancel_travel_failsafe()

func _cancel_travel_failsafe():
	if _travel_failsafe_timer != null and is_instance_valid(_travel_failsafe_timer):
		if _travel_failsafe_timer.is_connected("timeout", self, "set"):
			_travel_failsafe_timer.disconnect("timeout", self, "set")
	_travel_failsafe_timer = null

func go_to_bath():
	print("[AnimationController] go_to_bath() playing animation")
	anim_player.play("go_to_bath")
	yield(anim_player, "animation_finished")
	print("[AnimationController] go_to_bath() animation finished")

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
	print("[AnimationController] return_from_bath() playing animation")
	anim_player.play("return_from_bath")
	yield(anim_player, "animation_finished")
	print("[AnimationController] return_from_bath() animation finished")

func go_to_toilet():
	anim_player.play("go_to_toilet")
	yield(anim_player, "animation_finished")

func higienic_paper_animation():
	bathroom_animplayer.play("higienic_paper")

func return_from_toilet():
	if is_instance_valid(sound_flush):
		sound_flush.play()
	else:
		print("[AnimationController] WARNING: sound_flush is invalid or null!")
	
	if is_instance_valid(bathroom_animplayer):
		bathroom_animplayer.play("toilet_paper")
	else:
		print("[AnimationController] WARNING: bathroom_animplayer is invalid or null!")
		
	yield(countdown(), "completed")
	
	if is_instance_valid(anim_player):
		anim_player.play("start")
	else:
		print("[AnimationController] WARNING: anim_player is invalid or null!")
		
	if is_instance_valid(bathroom_animplayer):
		yield(bathroom_animplayer, "animation_finished")
	
	if is_instance_valid(anim_player):
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
