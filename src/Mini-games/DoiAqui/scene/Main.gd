extends Node2D

var typesPain = ["headache", "armPain", "fever", "wound"]
var numberPain = [1,2,3]
var nP

var life = 0
var isHalthLife = false
var max_life = GlobalResource.max_life
var messageInitial = false
var messageEnd = false 
var isCount = false

var noTreatment = ["assistir tv", "brincar na rua", "jogar video game" ]
var aux = ["no", "no2", "no3","no4"]

var isStart = false
var buttonsBlock
var gender

var number_history = []
var number_history2 = []

func _ready():
	gender = GlobalResource.gender
	print(gender)
	$Player/sprite.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-parado.png")
	$Player/wound.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-ferimento.png")
	$Player/expressions/cold.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-frio.png")
	$Player/expressions/stress.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-nervoso.png")
	$Player/expressions/fever.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-febre.png")
	$Player/pain.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-dores.png")

func _physics_process(delta):
	if (life == (max_life / 2)):
		isHalthLife = true
		
	#if isHalthLife and life == 0:
	#	get_tree().change_scene("res://src/scene/GameOver.tscn")
		
	if life >= GlobalResource.max_life:
		get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/GameOver.tscn")
		
	if isStart:
		isStart = false
		buttonsBlock = true
		#var buttons = get_tree().get_nodes_in_group("button")
		#for button in buttons:
		#	if(button.is_connected("pressed", self, "_on_Button_pressed")):
		#		#print("entrou aqui")
		#		button.disconnect("pressed", self, "_on_Button_pressed")
			
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
		$scalePain.set_process(true)
		$scalePain.visible = true
		$scalePain.typeAnimation = number
		yield($scalePain/AnimationPlayer,"animation_finished")
		$scalePain.set_process(false)
		$scalePain.typeAnimation = 0
		
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
		buttonsBlock = false 
	if isCount:
		GlobalResource.gameTime += 1 * delta
		
func _on_start_timeout():
	isStart = true

func _on_Button_pressed(name):
	if(!buttonsBlock):
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
			$messageInterGame/message.modulate = "#0BCE4C"			
			$HealthDisplay.update_healthBar(life)
		else:
			life -= 1
			if(life < 0):
				life = 0
			$messageInterGame/message.modulate = "#F4192E"
			$lose.play()			
			$messageInterGame/message.text = "Você errou!"
			$HealthDisplay.update_healthBar(life)
		buttonsBlock = true

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
			
func _input(event):
	if event is InputEventScreenTouch or ( event is InputEventMouseButton and event.is_pressed()):
		if buttonsBlock:
			if $messageInterGame.layer > 1:
				isStart = false
				if !messageInitial:
					$message.start()
					messageInitial = true
				elif messageInitial:
					if messageEnd:
						$messageInterGame/Sprite.texture = load("")
						$messageInterGame.layer = -100
						$askMessage/com.visible = true
						$askMessage/message.visible = true
						$askMessage/como_posso.visible = true
						$askMessage/message.text = "   ..."
						$painLevel/Sprite.texture = load("res://assets/DoiAqui/sprites/tratamento/pain/"+str(nP)+".png")
						$painLevel.layer = 100
						messageInitial = false
						messageEnd = false
			elif $painLevel.layer > 1:
				isStart = false
				if !messageInitial:
					$message.start()
					messageInitial = true
				elif messageInitial:
					if messageEnd:
						$painLevel/Sprite.texture = load("")
						$painLevel.layer = -100
						messageInitial = false
						messageEnd = false
						isStart = true
						$Player.typesPain = "normal"
						var buttons = get_tree().get_nodes_in_group("button")
						$askMessage/Sprite.texture = load("res://assets/DoiAqui/objects/empty.png")
						$askMessage/com.visible = false
						$askMessage/message.visible = false
						$askMessage/como_posso.visible = false
						for button in buttons:
							button.texture_normal = load("res://assets/DoiAqui/objects/button.png")
							button.texture_pressed = load("res://assets/DoiAqui/objects/button.png")
						
func _on_message_timeout():
	messageEnd = true

func _on_start_pressed():
	$button.play()
	$InitialMessage/ColorRect.queue_free()
	$InitialMessage/ColorRect2.queue_free()
	$InitialMessage/Label.queue_free()
	$InitialMessage/start.queue_free()
	isStart = true
	isCount = true


func _on_Player_tree_entered():
	gender = GlobalResource.gender
	$Player/sprite.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-parado.png")
	$Player/wound.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-ferimento.png")
	$Player/expressions/cold.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-frio.png")
	$Player/expressions/stress.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-nervoso.png")
