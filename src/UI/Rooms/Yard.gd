extends HouseRoom

# Time (seconds) the Yard stays "settled" as room_id 0 before it starts also
# answering to room_id 5 (see _process() below). This is not a random delay:
# room_id 5 is the id AnimationController.travel() checks for its "from == 5"
# wraparound branch, and it's also the fixed room_id of the separate Jardim
# room (see src/UI/Rooms/Jardim.gd, PlantCare minigame entrance). The Yard
# sits at one end of the room strip and Jardim conceptually sits at the other;
# letting the Yard answer to id 5 too lets travel() treat leaving the Yard
# (after this short settle time) as leaving the wrap-around slot, so the
# circular left/right navigation across the room strip works without a
# dedicated UI button for room 5. NecessityBarsManagerNew.gd's
# Set_Disabled_Button() has a matching `room_id == 0 or room_id == 5` check,
# confirming both ids are meant to be treated as "the Yard" while here.
var yard_wrap_timer = 3

var playing = false

var sunny = preload("res://assets/Plataforma/ambientes/quintal_sol.png")
var rainy = preload("res://assets/Plataforma/ambientes/quintal_chuva.png")
var snowy = preload("res://assets/Plataforma/ambientes/quintal_neve.png")
var night = preload("res://assets/Plataforma/ambientes/quintal_noite.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 0

func _process(delta: float) -> void:
	
	if(yard_wrap_timer > 0):
		yard_wrap_timer -= delta

		if(yard_wrap_timer <= 0):
			room_id = 5 # See comment on yard_wrap_timer above.
	
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
	$Hidratona_PopUp2/AnimationPlayer.play("in")

func _on_TutorialButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	AnimationController.is_travelling = false

	AnimationController.status = "Hidratona"
	NecessityBars.fun = true
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Tutorial.tscn")

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
	$Hidratona_PopUp2/AnimationPlayer.play("out")


func _on_HospitalButton_pressed():
	get_tree().change_scene("res://src/Hospital.tscn")
	pass # Replace with function body.
