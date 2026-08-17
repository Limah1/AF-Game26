extends CanvasLayer

var p1_finished = false

var timer = 0.7
var start = false
var started = false

var fb_index = 0

var input1 = false
var input2 = false
var input3 = false
var input4 = false

var obstacles = preload("res://src/Mini-games/Hidratona/src/objects/tutorial_obstacules.tscn")

func _ready() -> void:
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if p1_finished == true:
		return
	
	if event is InputEventScreenTouch and event.is_pressed() and timer <= 0 and !p1_finished:
		change_fb()
	if event is InputEventMouseButton and event.is_pressed() and timer <= 0 and !p1_finished:
		change_fb()

func _process(delta: float) -> void:
	timer -= delta
	
	if input1 and timer <= 0:
		change_fb()
		input1 = false
	if input2 and timer <= 0:
		change_fb()
		input2 = false		
	if input3 and timer <= 0:
		change_fb()
		input3 = false		
	if input4 and timer <= 0:
		change_fb()
		input4 = false		

func change_fb():
	fb_index += 1
	
	if fb_index == 1:
		$feedback/feedback_box.visible = false
		$feedback/feedback_box2.visible = true
	if fb_index == 2:
		$feedback/feedback_box2.visible = false
		$feedback/feedback_box3.visible = true
	if fb_index == 3:
		$feedback/feedback_box3.visible = false
		$feedback/feedback_box4.visible = true
	if fb_index == 4:
		$feedback/feedback_box4.visible = false
		$feedback/feedback_box5.visible = true
	if fb_index == 5:
		p1_finished = true
		$feedback/feedback_box5.visible = false
		$ColorRect.visible = false
		get_tree().paused = false
		
		yield(countdown(), "completed")
		
		var obstacle = obstacles.instance()
		obstacle.start("Trash", 0)
		get_parent().add_child(obstacle)
		
		input1 = true
		
		timer = 1.7
		return
	if fb_index == 6:
		get_tree().paused = true
		$feedback/jump.visible = true
	if fb_index == 7:
		$stop_input.queue_free()
		$feedback/jump.queue_free()
		input1 = false
		yield(countdown(), "completed")
		
		var obstacle = obstacles.instance()
		obstacle.start("Mosquito", 1)
		get_parent().add_child(obstacle)
		
		input2 = true
		timer = 2.5
		
		return
	if fb_index == 8:
		get_tree().paused = true
		$feedback/down.visible = true
	if fb_index == 9:
		$stop_input2.queue_free()
		input2 = false
		yield(countdown(), "completed")
		
		var obstacle = obstacles.instance()
		obstacle.start("Water", 1)
		get_parent().add_child(obstacle)
		
		input3 = true
		timer = 2.3
		return
	if fb_index == 10:
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box6.visible = true
		p1_finished = false
	if fb_index == 11:
		p1_finished = true
		get_tree().paused = false
		$ColorRect.visible = false
		$feedback/feedback_box6.visible = false
		timer = 2.7
		input4 = true
		return
	if fb_index == 12:
		p1_finished = false
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box7.visible = true
		return
	if fb_index == 13:
		p1_finished = true
		get_tree().paused = false
		$ColorRect.visible = false
		$feedback/feedback_box7.visible = false
		timer = 2.8
		input4 = true
		return
	if fb_index == 14:
		p1_finished = false
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box8.visible = true
		return
	if fb_index == 15:
		p1_finished = true
		get_tree().paused = false
		$ColorRect.visible = false
		$feedback/feedback_box8.visible = false
		timer = 3.6
		input4 = true
		return
	if fb_index == 16:
		p1_finished = false
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box9.visible = true
		return
	if fb_index == 17:
		p1_finished = true
		get_tree().paused = false
		$ColorRect.visible = false
		$feedback/feedback_box9.visible = false
		timer = 1.2
		input4 = true
		return
	if fb_index == 18:
		p1_finished = false
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box10.visible = true
		return
	if fb_index == 19:
		p1_finished = true
		get_tree().paused = false
		$ColorRect.visible = false
		$feedback/feedback_box10.visible = false
		timer = 4
		input4 = true
		return
	if fb_index == 20:
		p1_finished = false
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box11.visible = true
		return
	if fb_index == 21:
		p1_finished = true
		get_tree().paused = false
		$ColorRect.visible = false
		$feedback/feedback_box11.visible = false
		timer = 7
		input4 = true
		return
	if fb_index == 22:
		get_tree().paused = true
		$feedback/dash.visible = true
		return
	if fb_index == 23:
		$stop_input3.visible = false
		p1_finished = true
		get_tree().paused = false
		$feedback/dash.visible = false
		timer = 5
		input4 = true
		return
	if fb_index == 24:
		get_tree().paused = true
		$ColorRect.visible = true
		$feedback/feedback_box12.visible = true
		return
		
	timer = 1.2

func countdown():
	yield(get_tree(), "idle_frame")
	yield(get_tree().create_timer(1.5), "timeout")
	

func _on_jump_button_down() -> void:
	if $feedback/jump:
		$feedback/jump.visible = false
	else:
		$feedback/jump2.visible = false
		
	get_tree().paused = false
	
	var a = InputEventAction.new()
	a.action = "jump"
	a.pressed = true
	Input.parse_input_event(a)

func _on_jump_button_up() -> void:
	var a = InputEventAction.new()
	a.action = "jump"
	a.pressed = false
	Input.parse_input_event(a)
	
	change_fb()


func _on_down_button_down() -> void:
	$feedback/down.visible = false
	
	get_tree().paused = false
	
	var a = InputEventAction.new()
	a.action = "down"
	a.pressed = true
	Input.parse_input_event(a)
	
	get_parent().get_node("Player").down = true
	
	countdown()
	
	change_fb()
	$feedback/down.queue_free()


func _on_dash_button_down() -> void:
	get_parent().get_node("Player").dash()
	change_fb()


func _on_Start_pressed() -> void:
	get_tree().paused = false
	Resources.reset_resources()
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Level.tscn")


func _on_down_pressed():
	_on_down_button_down()
