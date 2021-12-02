extends Node2D

var time_sun = 0
var sun = false
onready var animation: AnimationPlayer = $AnimationPlayer

onready var parallax = $floor

func _ready():
	$Timer.start()
	$Timer3.start()
	if(Resources.weather == "Rainy"):
		$Rain.start(true)
		if(Resources.acessory != "Umbrella"):
			$CanvasLayer/ColorRect.visible = true
			$CanvasLayer/NaoTrouxeCapa.visible = true
			get_tree().paused = true
			Resources.acessory_not_founded = "Umbrella"
	if(Resources.weather == "Snowy"):
		$Snow.start(true)
		if(Resources.acessory != "Coat"):
			$CanvasLayer/ColorRect.visible = true
			$CanvasLayer/NaoTrouxeCasaco.visible = true
			get_tree().paused = true
			Resources.acessory_not_founded = "Coat"
	else:
		$sunny_sound.play()
	
	

func _process(delta):
	$Player.global_position.x = $Position2D.global_position.x
	
	if Resources.heart <= 0 or Resources.current_life <= 0:
		get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/GameOver.tscn")

func _on_pause_button_up():
	$CanvasLayer/Pause.visible = true
	var colorRect = get_tree().get_nodes_in_group("sun")
	for i in colorRect:
		i.visible = false
	get_tree().paused = true 
	
	var necessitybar = load("res://src/UI/NecessityManager.tscn").instance()
	$CanvasLayer/Pause.add_child(necessitybar)
	necessitybar.get_node("AnimationPlayer").play("Start")

func _on_playbutton_button_up():
	$CanvasLayer/Pause.visible = false
	$CanvasLayer/Pause.get_node("NecessityManager").queue_free()
	
	
	var colorRect = get_tree().get_nodes_in_group("sun")
	for i in colorRect:
		i.visible = false
	get_tree().paused = false 

func _on_Timer_timeout():
	if(Resources.weather == "Sunny"):
		var node = preload("res://src/Mini-games/Hidratona/src/objects/Sun.tscn")
		var scene = node.instance()
		add_child(scene)
		animation.play("sun")
		Resources.sunny = true
		$Timer2.start()

func _on_Timer2_timeout():
	Resources.sunny = false
	$Timer.start()

func _on_playbutton2_pressed() -> void:
	get_tree().paused = false
	Resources.reset_resources()
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_Timer3_timeout() -> void:
	if (Resources.weather == "Rainy" and Resources.acessory != "Umbrella"):
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/chuva.visible = true
		get_tree().paused = true
		
		NecessityBars.some_problem = "fever"
	elif (Resources.weather == "Snowy" and Resources.acessory != "Coat"):
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/neve.visible = true
		get_tree().paused = true
		
		NecessityBars.some_problem = "armPain"

func _on_playbutton_pressed() -> void:
	$CanvasLayer/Pause.visible = false
	$CanvasLayer/Pause.get_node("NecessityManager").queue_free()
	
	
	var colorRect = get_tree().get_nodes_in_group("sun")
	for i in colorRect:
		i.visible = false
	get_tree().paused = false 
