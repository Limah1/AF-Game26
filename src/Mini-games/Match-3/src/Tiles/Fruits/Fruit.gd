class_name Fruit
extends KinematicBody2D

var fruit_name
var speed = 350
var tile

onready var a_dir = get_node("AnimationDirection")

onready var AP: AnimationPlayer = get_node("AnimationPlayer")

func start(new_tile):
	add_to_group("fruits")
	
	tile = new_tile
	global_position = tile.global_position

func reparenting(new_tile):
	tile = new_tile

func _physics_process(delta: float) -> void:
	if tile != null:
		var tile_distance = (tile.global_position - self.global_position)
		if tile_distance.y <= 1.667786 && tile_distance.y >= -4.165527 && tile_distance.x == 0:
			self.global_position = tile.global_position
			return
		if tile_distance.x >= -4.166321 && tile_distance.x <= 4.166321 && tile_distance.y == 0:
			self.global_position = tile.global_position
			return
		
		var target_direction = (tile.global_position - self.global_position).normalized()
		move_and_slide(target_direction * speed)

func score(points):
	S_Conntroller.score(fruit_name, points, self)
	
	AP.play("Match")
	yield(AP, "animation_finished") 
	queue_free()

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(1), "timeout")
