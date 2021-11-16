extends Room

var playing = false

onready var umbrella = $"bedroom/Ativo 15/Ativo 18/umbrella"
onready var coat = $"bedroom/Ativo 15/Ativo 19/coat"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 3
	if(Resources.acessory_not_founded == "Umbrella"):
		umbrella.get_node("AnimationPlayer").play("idle")
	if(Resources.acessory_not_founded == "Coat"):
		coat.get_node("AnimationPlayer").play("idle")

func back_sleeping():
	AnimationController.already_on_bed()
	$"quarto-abajur-ligado".visible = false
	$"quarto-abajur-desligado".visible = true
	$CanvasLayer/ColorRect.visible = true 
	$CanvasLayer/SleepButton2.visible = true 
	NecessityBars.sleeping = true

func _process(delta: float) -> void:
	if (NecessityBars.energia <= (NecessityBars.max_energia*0.2)) and playing == false:
		$"quarto-abajur-ligado/AnimationPlayer".play("scale_in_out")
		playing = true
	elif (NecessityBars.energia > (NecessityBars.max_energia*0.2)) and playing != false:
		$"quarto-abajur-ligado/AnimationPlayer".play("idle")
		playing = false
		
	if(Resources.weather == "Rainy"):
		$janela_chuva.visible = true
		$janela_sol.visible = false
		$janela_neve.visible = false
		$janela_noite.visible = false
	elif(Resources.weather == "Sunny"):
		$janela_chuva.visible = false
		$janela_sol.visible = true
		$janela_neve.visible = false
		$janela_noite.visible = false
	elif(Resources.weather == "Snowy"):
		$janela_chuva.visible = false
		$janela_sol.visible = false
		$janela_neve.visible = true
		$janela_noite.visible = false

func _on_pick_umbrella_pressed() -> void:
	$zip.play()
	umbrella.visible = !umbrella.visible
	coat.visible = true
	
	Resources.equip_acessory("Umbrella")

func _on_pick_coat_pressed() -> void:
	$zip.play()
	umbrella.visible = true
	coat.visible = !coat.visible
	
	Resources.equip_acessory("Coat")

func _on_SleepButton_pressed() -> void:
	$abajur.play()
	if(NecessityBars.sleeping):
		wake_up()
	else:
		sleep()

func sleep():
	$"quarto-abajur-ligado".visible = false
	$"quarto-abajur-desligado".visible = true
	$CanvasLayer/ColorRect.visible = true 
	$CanvasLayer/SleepButton2.visible = true 
	yield(AnimationController.go_to_bed(), "completed")
	NecessityBars.sleeping = true
	AnimationController.status = "Sleeping"

func wake_up():
	Resources.weather_randomize()
	AnimationController.status = "MainGame"
	
	Resources.acessory_not_founded = ""
	umbrella.get_node("AnimationPlayer").play("default")
	coat.get_node("AnimationPlayer").play("default")
	
	NecessityBars.sleeping = false
	$"quarto-abajur-ligado".visible = true
	$"quarto-abajur-desligado".visible = false
	$CanvasLayer/ColorRect.visible = false 
	$CanvasLayer/SleepButton2.visible = false 
	yield(AnimationController.wake_up_from_bed(), "completed")

func _on_PersonalizationButton_pressed() -> void:
	if CharacterController.boyorgirl == "Boy":
		$PersonalizationScreen/Boy_closet.visible = true
	elif CharacterController.boyorgirl == "Girl":
		$PersonalizationScreen/Girl_closet.visible = true
