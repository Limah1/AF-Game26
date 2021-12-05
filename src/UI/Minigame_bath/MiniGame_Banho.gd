extends Node2D

var bathroom_reference = null

var molhado = 0
var ensaboado = 0
var enxaguar = 0
var enxugado = 0

var is_drying = false

var direction = null
var pressing = false

var status_button: bool = false

var cd = 0.5
var timer = 0

onready var chuveiro = $"Ativo 6/Chuveiro"
onready var bubbles = $"boy-banho-1/bubbles"

onready var water_circles = $"boy-banho-1/Molhado"
onready var foam = $"boy-banho-1/espuma"

func start(ref):
	bathroom_reference = ref
	
	$"boy-banho-1".texture = CharacterController.all_sprites.plataform.idle_bath
	

func _on_body_area_body_entered(body):
	if(body.name == "Sabonete"):
		bubbles.emitting = true
	
	if(body.name == "Toalha"):
		is_drying = true
		$towel_sound.play()

func _on_body_area_body_exited(body):
	if(body.name == "Sabonete"):
		bubbles.emitting = false
	
	if(body.name == "Toalha"):
		is_drying = false
		$towel_sound.stop()

func _on_SwipeArea_input_event(viewport, event, shape_idx):
	direction = null
	if(cd > 0):
		pressing = false
		return
	
	if event is InputEventMouseButton or event is InputEventScreenTouch and event.is_pressed():
		pressing = true
	elif event is InputEventMouseButton or event is InputEventScreenTouch and !event.is_pressed():
		pressing = false
	
	if event is InputEventScreenDrag and pressing and event.is_pressed():
		get_relative_direction(event.relative)
		cd = 0.5
	elif event is InputEventMouseMotion and pressing:
		get_relative_direction(event.relative)
		cd = 0.5

func get_relative_direction(relative):
	var relative_x = abs(relative.x)
	var relative_y = abs(relative.y)
	
	if(relative_x < relative_y):
		var aux = relative.y
		if(aux > 2):
			aumentar_chuveiro()
		elif(aux < 2):
			diminuir_chuveiro()

func aumentar_chuveiro():
	if(chuveiro.emitting == false):
		return
	chuveiro.emitting = false
	$"Ativo 6/AnimationPlayer".play("open_faucet")

func diminuir_chuveiro():
	if(chuveiro.emitting == true):
		return
	chuveiro.emitting = true
	$"Ativo 6/AnimationPlayer".play("open_faucet")	

func _process(delta):
	cd -= delta
	
	if(chuveiro.emitting == true and ensaboado <= 0):
		timer += delta
		
		molhado += (20 * delta)
		
		if(timer >= 1):
			if(water_circles.modulate.a >= 1):
				timer = 0
				return
			timer = 0
			water_circles.modulate.a = water_circles.modulate.a + 0.2
	
	if(bubbles.emitting == true):
		timer += delta
		
		ensaboado += (20 * delta)
		
		if(timer >= 1):
			if(foam.modulate.a >= 1):
				timer = 0
				return
			timer = 0
			foam.modulate.a = foam.modulate.a + 0.2
	
	if(chuveiro.emitting and ensaboado != 0):
		timer += delta
		
		enxaguar += (20 * delta)
		
		if(timer >= 1):
			timer = 0
			foam.modulate.a = foam.modulate.a - 0.2
		
	if(is_drying):
		timer += delta
		
		enxugado += (20 * delta)
		
		if(timer >= 1):
			timer = 0
			water_circles.modulate.a = water_circles.modulate.a - 0.2
	



func _on_TurnOn_pressed():
	if(!status_button):
		$"Ativo 6/TurnOff".visible = true
		$"Ativo 6/TurnOn".visible = false
		
		if(chuveiro.emitting == true):
			return
		chuveiro.emitting = true
		$shower_sound.play()
	else:
		if(chuveiro.emitting == false):
			return
			
		$"Ativo 6/TurnOff".visible = false
		$"Ativo 6/TurnOn".visible = true
			
		chuveiro.emitting = false
		$shower_sound.stop()
	
	status_button = !status_button
	

