extends Node2D

var current_screen = null
var target  = Vector2()
var current_page = 1
var relative

var timer = 0

onready var animation: AnimationPlayer = $AnimationPlayer

	
func _input(event):
	if event is InputEventScreenDrag and timer <= 0:
		target = event.position
		relative = event.relative.x
		if relative < 0:
			if current_page != 4:
				if current_page == 2:
					current_screen = $"2"
					change_screen($"3")
					current_page = 3
				elif current_page == 1:
					current_screen = $"1"
					change_screen($"2")
					current_page = 2
				elif current_page == 3:
					current_screen = $"3"
					change_screen($"4")
					current_page = 4
			else:
				current_screen = $"4"
				change_screen($"1")
				current_page = 1

		elif relative > 0:
			if current_page != 1:
				if current_page == 3:
					current_screen = $"3"
					change_screen($"2")
					current_page = 2
				elif current_page == 2:
					current_screen = $"2"
					change_screen($"1")
					current_page = 1
				elif current_page == 4:
					current_screen = $"4"
					change_screen($"3")
					current_page = 3
			else:
				current_page = 1
				current_screen = $"1"
		
		timer = 0.3

func _process(delta):
	timer -= delta

func change_screen(new_screen):
	current_screen.visible = false
	new_screen.visible = true 

func _on_2_visibility_changed():
	animation.play("match")

func _on_start_pressed():
	get_tree().change_scene("res://src/MainScreen.tscn")


func _on_1_visibility_changed():
	animation.play("slide")


func _on_4_visibility_changed():
	animation.play("slide (copy)")
