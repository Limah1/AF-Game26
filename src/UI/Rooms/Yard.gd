extends HouseRoom

var countdown = 3

var playing = false

var sunny = preload("res://assets/Plataforma/ambientes/quintal_sol.png")
var rainy = preload("res://assets/Plataforma/ambientes/quintal_chuva.png")
var snowy = preload("res://assets/Plataforma/ambientes/quintal_neve.png")
var night = preload("res://assets/Plataforma/ambientes/quintal_noite.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 0

func _process(delta: float) -> void:
	
	if(countdown > 0):
		countdown -= delta
		
		if(countdown <= 0):
			room_id = 5
	
	if (NecessityBars.diversao <= (NecessityBars.max_diversao*0.2)) and playing == false:
		$"quintal-portao-fechado/AnimationPlayer".play("scale_in_out")
		playing = true
	elif (NecessityBars.diversao > (NecessityBars.max_diversao*0.2)) and playing != false:
		$"quintal-portao-fechado/AnimationPlayer".play("idle")
		playing = false
		
	if(AnimationController.current_room.room_id == 0 or AnimationController.current_room.room_id == 5):
		if(Resources.weather == "Rainy"):
			$Yard.texture = rainy
			$Rain.emitting = true
			$Snow.emitting = false
		elif(Resources.weather == "Sunny"):
			$Yard.texture = sunny
			$Rain.emitting = false
			$Snow.emitting = false
		elif(Resources.weather == "Snowy"):
			$Yard.texture = snowy
			$Rain.emitting = false
			$Snow.emitting = true

func _on_Button0_pressed() -> void:
	$opengate.play()
	$"quintal-portao-aberto".visible = true
	$"quintal-portao-fechado".visible = false
	$Hidratona_PopUp/AnimationPlayer.play("in")

#func _on_TutorialButton_pressed() -> void:
#	$button_sound.play()
#	yield($button_sound,"finished")
#	AnimationController.is_travelling = false
#	
#	AnimationController.status = "Hidratona"
#	NecessityBars.fun = true
#	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Tutorial.tscn")
	
func _on_TutorialButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	AnimationController.is_travelling = false
	
	AnimationController.status = "Hospital"
	NecessityBars.fun = true
	get_tree().change_scene("res://src/Hospital.tscn")

func _on_StartButton_pressed() -> void:
	AnimationController.is_travelling = false
	
	AnimationController.status = "Hidratona"
	NecessityBars.fun = true
	$button_sound.play()
	yield($button_sound,"finished")
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Level.tscn")

func _on_LeaveButton_pressed() -> void:
	$"quintal-portao-aberto".visible = false
	$"quintal-portao-fechado".visible = true
	$Hidratona_PopUp/AnimationPlayer.play("out")
