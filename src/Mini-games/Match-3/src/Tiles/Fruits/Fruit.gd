class_name Fruit
extends KinematicBody2D

var fruit_name
var speed = 350
var tile
var scored = false

onready var a_dir = get_node("AnimationDirection")

onready var AP: AnimationPlayer = get_node("AnimationPlayer")

func start(new_tile):
	add_to_group("fruits")
	
	tile = new_tile
	global_position = tile.global_position
	set_physics_process(false)

func reparenting(new_tile):
	tile = new_tile
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if tile != null:
		# Board movement has no obstacles; clamp the step so it cannot overshoot.
		global_position = global_position.move_toward(tile.global_position, speed * delta)
		if global_position == tile.global_position:
			set_physics_process(false)

func score(points):
	if scored:
		return
	scored = true
	set_physics_process(false)
	remove_from_group("fruits")
	S_Conntroller.score(fruit_name, points, self)

	# Clear the owning tile immediately. Leaving a queued-for-deletion fruit in
	# tile.fruit lets a concurrent board scan access a stale reference.
	if tile != null and is_instance_valid(tile) and tile.fruit == self:
		tile.remove_fruit()
	tile = null
	
	AP.play("Match")
	yield(AP, "animation_finished") 
	queue_free()

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(1), "timeout")
