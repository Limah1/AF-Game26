extends Node2D

export(int, "Use global weather", "Sunny", "Rainy", "Snowy") var weather_override = 0
export(String, "Use current", "Boy", "Girl") var test_gender = "Use current"
export(String, "Use current", "A", "B") var test_hair = "Use current"
export(bool) var use_rain_test_assets = true
export(String) var rain_test_assets_root = "res://src/Mini-games/Hidratona/src/level/rain"
export(bool) var use_snow_test_assets = true
export(String) var snow_test_assets_root = "res://src/Mini-games/Hidratona/src/level/snow"

var time_sun = 0
var sun = false
var active_weather = "Sunny"
var test_selection_applied = false
var original_gender = ""
var original_character_gender = ""
var original_hair = ""
var original_hidratona_sprites = null
var original_weather = ""
var forced_weather = ""
var original_accessory = ""
var forced_accessory = ""
onready var animation: AnimationPlayer = $AnimationPlayer

onready var parallax = $floor

func _ready():
	active_weather = _get_active_weather()
	_apply_test_character_override()
	_apply_weather_accessory_override()
	_stop_weather_effects()
	# Player._ready() runs before Level._ready(), so refresh its textures after
	# applying the scene override.
	$Player.set_sprites()
	if active_weather == "Rainy" and use_rain_test_assets:
		$Player.set_weather_test_sprites("Rainy", rain_test_assets_root)
	elif active_weather == "Snowy" and use_snow_test_assets:
		$Player.set_weather_test_sprites("Snowy", snow_test_assets_root)
	$Player._refresh_legacy_head()
	$Timer.start()
	$Timer3.start()
	if(active_weather == "Rainy"):
		$Rain.start(true)
		if(Resources.acessory != "Umbrella"):
			$CanvasLayer/ColorRect.visible = true
			$CanvasLayer/NaoTrouxeCapa.visible = true
			get_tree().paused = true
			Resources.acessory_not_founded = "Umbrella"
	elif(active_weather == "Snowy"):
		$Snow.start(true)
		if(Resources.acessory != "Coat"):
			$CanvasLayer/ColorRect.visible = true
			$CanvasLayer/NaoTrouxeCasaco.visible = true
			get_tree().paused = true
			Resources.acessory_not_founded = "Coat"
	else:
		$sunny_sound.play()


func _apply_weather_accessory_override() -> void:
	if weather_override == 0:
		return

	original_weather = Resources.weather
	forced_weather = active_weather
	Resources.weather = forced_weather

	if weather_override != 2 and weather_override != 3:
		return

	original_accessory = Resources.acessory
	forced_accessory = "Umbrella" if active_weather == "Rainy" else "Coat"
	Resources.acessory = forced_accessory


func _apply_test_character_override() -> void:
	if test_gender == "Use current" and test_hair == "Use current":
		return

	test_selection_applied = true
	original_gender = CharacterController.boyorgirl
	original_character_gender = CharacterController.genero
	original_hair = CharacterController.cabelo
	original_hidratona_sprites = CharacterController.all_sprites.hidratona

	if test_gender == "Boy":
		CharacterController.boyorgirl = "Boy"
		CharacterController.genero = "boy"
	elif test_gender == "Girl":
		CharacterController.boyorgirl = "Girl"
		CharacterController.genero = "girl"

	if test_hair == "A":
		CharacterController.cabelo = "a"
	elif test_hair == "B":
		CharacterController.cabelo = "b"

	# Reload body sets after changing the test gender. This also makes F6 on
	# Level.tscn independent from the character-creator flow.
	CharacterController.all_sprites.hidratona = CharacterController.Load_Hidratona()


func _exit_tree() -> void:
	if forced_accessory != "" and Resources.acessory == forced_accessory:
		Resources.acessory = original_accessory
	if forced_weather != "" and Resources.weather == forced_weather:
		Resources.weather = original_weather
	if test_selection_applied:
		CharacterController.boyorgirl = original_gender
		CharacterController.genero = original_character_gender
		CharacterController.cabelo = original_hair
		CharacterController.all_sprites.hidratona = original_hidratona_sprites


func _get_active_weather() -> String:
	match weather_override:
		1:
			return "Sunny"
		2:
			return "Rainy"
		3:
			return "Snowy"
		_:
			return Resources.weather


func _stop_weather_effects() -> void:
	$Rain/Particles2D.emitting = false
	$Rain/nuvens.visible = false
	$Rain/rain_sound.stop()
	$Snow/Particles2D.emitting = false
	$Snow/nuvens.visible = false
	$Snow/snow_sound.stop()
	
	

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
	if(active_weather == "Sunny"):
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
	if (active_weather == "Rainy" and Resources.acessory != "Umbrella"):
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/chuva.visible = true
		get_tree().paused = true
		
		NecessityBars.some_problem = "fever"
	elif (active_weather == "Snowy" and Resources.acessory != "Coat"):
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
