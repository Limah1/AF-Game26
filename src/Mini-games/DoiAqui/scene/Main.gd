extends Node2D

var typesPain = ["headache", "armPain", "fever", "wound"]
var numberPain = [1,2,3]
var nP

var life = 0
var isHalthLife = false
var max_life = GlobalResource.max_life
var feedback_phase = ""
var isCount = false

var noTreatment = ["assistir tv", "brincar na rua", "jogar video game" ]
var aux = ["no", "no2", "no3","no4"]

var isStart = false
var finished_loading = false
var settingUp = false
var buttonsBlock
export(bool) var show_legacy_player = true
export(bool) var show_modular_player = false
export(Vector2) var modular_player_offset = Vector2(400, 0)

var number_history = []
var number_history2 = []

export(bool) var voice_enabled = true

const VOICE_ROOT = "res://src/Assets/Audio/Voice/Minigames/DoiAqui/"

func _ready():
	_setup_modular_player()

func _exit_tree() -> void:
	VoiceManager.stop()

func _play_doi_voice(stem: String) -> void:
	if !voice_enabled:
		VoiceManager.stop()
		return

	VoiceManager.play_first_available([
		VOICE_ROOT + stem + ".ogg",
		VOICE_ROOT + stem + ".wav",
		VOICE_ROOT + stem + ".mp3"
	])

func _setup_modular_player():
	# Exposed switches support legacy, modular, or side-by-side comparison.
	if !has_node("ModularPlayer"):
		return
	$Player.visible = show_legacy_player
	$ModularPlayer.visible = show_modular_player
	if !show_modular_player:
		return
	$ModularPlayer.position = $Player.position + modular_player_offset
	$ModularPlayer.scale = $Player.scale
	$ModularPlayer.z_index = $Player.z_index
	$ModularPlayer.set_state(0)
	$ModularPlayer.set_appearance_variant("hospital")

func _physics_process(delta):
	if isStart and !settingUp:
		isStart = false
		buttonsBlock = true
		
		setUpNewGame()
	if isCount:
		GlobalResource.gameTime += 1 * delta

func _on_continue_pressed():
	if feedback_phase == "result":
		if life >= max_life or (isHalthLife and life == 0):
			feedback_phase = ""
			get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/GameOver.tscn")
			return
		$messageInterGame/Character.hide()
		$messageInterGame.layer = -100
		$painLevel/Sprite.texture = load("res://assets/DoiAqui/sprites/tratamento/pain/" + str(nP) + ".png")
		$painLevel/Character.set_preview_state("dores")
		$painLevel/Character.show()
		$painLevel.layer = 100
		feedback_phase = "pain_level"
	elif feedback_phase == "pain_level":
		feedback_phase = ""
		$ContinueLayer/ContinueButton.hide()
		$painLevel/Character.hide()
		$painLevel.layer = -100
		$Player.visible = show_legacy_player
		$Player.typesPain = "normal"
		$askMessage/Sprite.texture = load("res://assets/DoiAqui/objects/empty.png")
		$askMessage/com.visible = false
		$askMessage/message.visible = false
		$askMessage/como_posso.visible = false
		for button in get_tree().get_nodes_in_group("button"):
			button.texture_normal = load("res://assets/DoiAqui/objects/button.png")
			button.texture_pressed = load("res://assets/DoiAqui/objects/button.png")
		finished_loading = false
		setUpNewGame()

func setUpNewGame():
	settingUp = true
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number = rng.randi_range(1, 3) #escala de dor
	while(number_history2.has(number)):
		rng.randomize()
		number = rng.randi_range(0, 3)
		
	number_history2.append(number)

	if(number_history2.size() == 3):
		number_history2.clear()		
	
	
	if(number_history.size() == 3):
		number_history.clear()
	
	$scalePain.visible = true
	
	#$scalePain.typeAnimation = number
	yield($scalePain.startCountdown(number), "completed")
	#$scalePain.typeAnimation = 0
	
	var number2
	if GlobalResource.initialPain >= 0:
		number2 = GlobalResource.initialPain
		GlobalResource.initialPain = -1
	else:
		var rng2 = RandomNumberGenerator.new()
		rng2.randomize()
		number2 = rng2.randi_range(0, 3) #tipo de dor
		while(number_history.has(number2)):
			rng2.randomize()
			number2 = rng2.randi_range(0, 3)
			
		number_history.append(number2)
		
		if(number_history.size() == 3):
			number_history.clear()
	$Player.typesPain = typesPain[number2]
	
	var namePain = str(typesPain[number2])

	register_buttons(namePain)
	
		
	$askMessage/Sprite.texture = load("res://assets/DoiAqui/sprites/tratamento/pain/1x/Ativo 21.png")
	$askMessage/com.visible = true
	$askMessage/message.visible = true
	$askMessage/como_posso.visible = true
	if(number == 1):
		nP = number
		if(number2 == 0):
			$askMessage/message.text = "dor de cabeça."
		if(number2 == 1):
			$askMessage/message.text = "dor nos braços."
		if(number2 == 2):
			$askMessage/message.text = "febre."				
		if(number2 == 3):
			$askMessage/message.text = "ferimentos abertos."								
		
	elif(number == 2):
		nP = number
		if(number2 == 0):
			$askMessage/message.text = "dor de cabeça."
		if(number2 == 1):
			$askMessage/message.text = "dor nos braços."
		if(number2 == 2):
			$askMessage/message.text = "febre."				
		if(number2 == 3):
			$askMessage/message.text = "ferimentos abertos."	

	else:
		nP = number
		if(number2 == 0):
			$askMessage/message.text = "dor de cabeça."
		if(number2 == 1):
			$askMessage/message.text = "dor nos braços."
		if(number2 == 2):
			$askMessage/message.text = "febre."				
		if(number2 == 3):
			$askMessage/message.text = "ferimentos abertos."
	_play_doi_voice("pain_" + typesPain[number2])
	buttonsBlock = false 
	
	settingUp = false
	

func _on_Button_pressed(name):
	if(!buttonsBlock):
		$Player.visible = false
		$messageInterGame/Character.set_preview_state("parado" if name == $Player.typesPain else "erro")
		$messageInterGame/Character.show()
		$messageInterGame.layer = 100
		$messageInterGame/Sprite.texture = load("res://assets/DoiAqui/sprites/tratamento/about/"+$Player.typesPain+".png")
		print("nome do botão "+name)
		print("nome em player "+$Player.typesPain)
		if(name == $Player.typesPain):
			life += 1
			if(life > max_life):
				life = max_life
			$messageInterGame/message.text = "Você acertou!"
			$sound_win.play()
			_play_doi_voice("correct")
			$messageInterGame/message.modulate = "#0BCE4C"			
			$HealthDisplay.update_healthBar(life)
		else:
			life -= 1
			if(life < 0):
				life = 0
			$messageInterGame/message.modulate = "#F4192E"
			$lose.play()			
			_play_doi_voice("incorrect")
			$messageInterGame/message.text = "Você errou!"
			$HealthDisplay.update_healthBar(life)
		if life == max_life / 2:
			isHalthLife = true
		buttonsBlock = true
		feedback_phase = "result"
		$ContinueLayer/ContinueButton.show()

func register_buttons(name):
	var buttons = get_tree().get_nodes_in_group("button")
	var i = 0 
	var size = buttons.size();
	while(i < size):
		buttons[i].name = str(i)
		i += 1
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number = rng.randi_range(0, 3)
	
	buttons[number].name = name 
	buttons[number].texture_normal = load("res://assets/DoiAqui/sprites/tratamento/"+name+".png")
	buttons[number].texture_pressed = load("res://assets/DoiAqui/sprites/tratamento/"+name+"-hover.png")
	get_buttons_group()
	i = 0
	while (i < size):
		#print(i)
		if(i != number):
			var nameButton = str(aux[i])
			buttons[i].texture_normal = load("res://assets/DoiAqui/sprites/notratamento/"+nameButton+".png")
			buttons[i].texture_pressed =load("res://assets/DoiAqui/sprites/notratamento/"+nameButton+"-hover.png")
		i += 1
	
	finished_loading = true;

func get_buttons_group():
	var buttons = get_tree().get_nodes_in_group("button")
	for button in buttons:
		if(button.is_connected("pressed", self, "_on_Button_pressed")):
			#print("entrou aqui")
			button.disconnect("pressed", self, "_on_Button_pressed")
			button.connect("pressed", self, "_on_Button_pressed", [button.name])
		else:
			#print("Tá no else")
			button.connect("pressed", self, "_on_Button_pressed", [button.name])
			
func _on_start_pressed():
	$button.play()
	_play_doi_voice("intro")
	$InitialMessage/ColorRect.queue_free()
	$InitialMessage/ColorRect2.queue_free()
	$InitialMessage/Label.queue_free()
	$InitialMessage/start.queue_free()
	isStart = true
	isCount = true


