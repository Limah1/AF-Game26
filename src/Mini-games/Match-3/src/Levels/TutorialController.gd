extends CanvasLayer

var checked = false
var pressing = false

var input1 = false
var input2 = false
var input3 = false
var input4 = false
var input5 = false

var p1_finished = false

var timer = 0.7
var start = false
var started = false

var fb_index = 0

func _input(event: InputEvent) -> void:
	if p1_finished:
		return
	
	if event is InputEventScreenTouch and event.is_pressed() and timer <= 0:
		change_fb()
	if event is InputEventMouseButton and event.is_pressed() and timer <= 0:
		change_fb()

func change_fb():
	fb_index += 1
	
	if fb_index == 1:
		$feedback/feedback_box1.visible = false
		$feedback/feedback_box2.visible = true
	if fb_index == 2:
		$feedback/feedback_box2.visible = false
		$feedback/feedback_box3.visible = true
	
	if fb_index == 3:
		$feedback.visible = false
		get_tree().paused = false
		
		$Input1.visible = true
		$AnimationPlayer.play("Input1")
		input1 = true
		p1_finished = true
	
	if fb_index == 4:
		$Input1.queue_free()
		$"tutorial-dedo".visible = false
		$AnimationPlayer.stop()
		
		yield(countdown(), "completed") 
		
		$Input2.visible = true
		$AnimationPlayer.play("Input2")
		input2 = true
		input1 = false
	
	if fb_index == 5:
		$Input2.queue_free()
		$"tutorial-dedo".visible = false
		$AnimationPlayer.stop()
		
		yield(countdown(), "completed") 
		
		$feedback.visible = true
		p1_finished = false
		
		$feedback/feedback_box3.visible = false
		$feedback/feedback_box4.visible = true
		
	if fb_index == 6:
		$feedback/feedback_box4.visible = false
		$feedback/feedback_box5.visible = true
	
	if fb_index == 7:
		$feedback.visible = false
		p1_finished = true
		
		$Input3.visible = true
		$AnimationPlayer.play("Input2")
		input3 = true
		input2 = false

	if fb_index == 8:
		$Input3.queue_free()
		$"tutorial-dedo".visible = false
		$AnimationPlayer.stop()
		
		yield(countdown(), "completed") 
		
		$Input4.visible = true
		$AnimationPlayer.play("Input3")
		input4 = true
		input3 = false

	if fb_index == 9:
		$Input4.queue_free()
		$"tutorial-dedo".visible = false
		$AnimationPlayer.stop()
		
		yield(countdown(), "completed") 
		
		$Input5.visible = true
		$AnimationPlayer.play("Input4 ")
		input5 = true
		input4 = false
	
	timer = 1.2
	pressing = false

func _physics_process(delta: float) -> void:
	if get_tree().get_nodes_in_group("fruits").size() == 9:
		start = true
	
	if start:
		timer-= delta
		
		if timer <= 0 and !started:
			get_tree().paused = true
			$feedback.visible = true
			
			started = true
			
			timer = 1.5

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(3.0), "timeout")

func _on_Input1_gui_input(event: InputEvent) -> void:
	if !input1:
		return
	if event is InputEventMouseButton:
		pressing = false
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.is_pressed()):
		pressing = true
	if (event is InputEventMouseMotion and pressing and get_parent().get_node("Fila2/Tile3") != null) or (event is InputEventScreenDrag and pressing and get_parent().get_node("Fila2/Tile3") != null and event.is_pressed()):
		if event.relative.y > 2:
			get_parent().get_node("Fila2/Tile3").move_to("Bottom")
			change_fb()

func _on_Input2_gui_input(event: InputEvent) -> void:
	if !input2:
		return
	if event is InputEventMouseButton:
		pressing = false
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.is_pressed()):
		pressing = true
	if (event is InputEventMouseMotion and pressing and get_parent().get_node("Fila2/Tile2") != null) or (event is InputEventScreenDrag and pressing and get_parent().get_node("Fila2/Tile2") != null and event.is_pressed()):
		if event.relative.y > 2:
			get_parent().get_node("Fila2/Tile2").move_to("Bottom")
			change_fb()

func _on_Input3_gui_input(event: InputEvent) -> void:
	if !input3:
		return
	if event is InputEventMouseButton:
		pressing = false
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.is_pressed()):
		pressing = true
	if (event is InputEventMouseMotion and pressing and get_parent().get_node("Fila2/Tile2") != null) or (event is InputEventScreenDrag and pressing and get_parent().get_node("Fila2/Tile2") != null and event.is_pressed()):
		if event.relative.y > 2:
			get_parent().get_node("Fila2/Tile2").move_to("Bottom")
			change_fb()

func _on_Input4_gui_input(event: InputEvent) -> void:
	if !input4:
		return
	if event is InputEventMouseButton:
		pressing = false
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.is_pressed()):
		pressing = true
	if (event is InputEventMouseMotion and pressing and get_parent().get_node("Fila3/Tile2") != null) or (event is InputEventScreenDrag and pressing and get_parent().get_node("Fila3/Tile2") != null and event.is_pressed()):
		if event.relative.y < 2:
			get_parent().get_node("Fila3/Tile2").move_to("Top")
			change_fb()

func _on_Input5_gui_input(event: InputEvent) -> void:
	if !input5:
		return
	if event is InputEventMouseButton:
		pressing = false
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.is_pressed()):
		pressing = true
	if (event is InputEventMouseMotion and pressing and get_parent().get_node("Fila2/Tile2") != null) or (event is InputEventScreenDrag and pressing and get_parent().get_node("Fila2/Tile2") != null and event.is_pressed()):
		if abs(event.relative.x) > 2:
			get_parent().get_node("Fila2/Tile2").move_to("Right")
			change_fb()
