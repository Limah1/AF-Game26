extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP
export var speed: = Vector2(0, 1400)
export var gravity = 3000.0
var time = 0
var power = false
var down = false
var jump_pressed = null
var time_down = 0
var playsom

var cd = 0.5
var timer = 0

var jump = 0.0
var is_jump_interrupted = false
var not_in_floor = false
var parallax 

var velocity: = Vector2.ZERO

onready var modular_rig = $ModularRig

func _ready():
	set_sprites()
	# Keep legacy sprites in scene as fallback, but render modular character.
	$AllSprites.visible = false
	modular_rig.visible = true
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(modular_rig)
	_update_modular_state()

	parallax = get_parent().get_node("floor")
	
func _physics_process(delta):
	
	time_down -= delta
	time += delta
	
	if Resources.in_hole:
		# Legacy hole animation stays hidden; keep modular player in airborne pose.
		_set_modular_state(5)
		return
	
	input()
	animations(delta)
	
	velocity = calculate_move_velocity(velocity, speed, is_jump_interrupted, not_in_floor)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	

func animations(delta):
	$CollisionShape2D2.position.y = 0
	$CollisionShape2D2.scale.y = 1
	
	if Resources.in_hole:
		_set_modular_state(5)
		$AnimationPlayer.play("hole")
		if time > 2:
			#$AnimatedSprite.play("run")
			time = 0
			Resources.in_hole = false
			if down:
				time_down = 0
		
		return
	
	if down and !Resources.in_hole:
		_set_modular_state(0)
		$AnimationPlayer.play("squat")
		if !playsom:
			playsom = true
			$freio_sound.play()
			
		$CollisionShape2D2.position.y = 70
		$CollisionShape2D2.scale.y = 0.3
		
		if time_down <= 0:
			playsom = false
			down = false
	elif velocity.y < 0 and !Resources.in_hole:
		_set_modular_state(5)
		$AnimationPlayer.play("jump")
	elif velocity.y > 0 and !Resources.in_hole:
		_set_modular_state(5)
		$AnimationPlayer.play("down")
	elif velocity.y == 0 and !Resources.in_hole:
		_set_modular_state(2)
		$AnimationPlayer.play("run")

func _update_modular_state() -> void:
	if Resources.in_hole:
		_set_modular_state(5)
	elif down:
		_set_modular_state(0)
	elif velocity.y != 0:
		_set_modular_state(5)
	else:
		_set_modular_state(2)

func _set_modular_state(next_state: int) -> void:
	if modular_rig == null:
		return
	if modular_rig.state != next_state:
		modular_rig.set_state(next_state)

func calculate_move_velocity(
		linear_velocity: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool,
		not_in_floor: bool
	) -> Vector2: 

	var out: = linear_velocity
	out.y += gravity * get_physics_process_delta_time()
	
	if jump == -1.0: 
		out.y = speed.y * (-1.0)
	
	if velocity.y != 0:
		jump_pressed = false

	if not_in_floor:
		out.y = speed.y
		
	return out

func input():
	if Resources.in_hole:
		return
		
	if jump_pressed and is_on_floor():
		$jump.play()
		jump = -1.0
		time_down = 0
		down = false
	else:
		jump = 0

	if Input.is_action_just_pressed("down"):
		time_down = 1.2
		down = true

	if (Input.is_action_just_pressed("down") or down ) and !is_on_floor():
		not_in_floor = true
		down = true
	else:
		not_in_floor = false


	if Input.is_action_just_pressed("power"):
		dash()

func dash():
	if Resources.dash_timer > 0:
		return
	
	parallax.paralax_dash()
	
	Resources.dash_timer = 2.0
	Resources.current_life -= 1

func _on_power_pressed():
	$sprint.play()
	dash()

func _on_down_button_down():
	var a = InputEventAction.new()
	a.action = "down"
	a.pressed = true
	Input.parse_input_event(a)

func _on_down_button_up() -> void:
	var a = InputEventAction.new()
	a.action = "down"
	a.pressed = false
	Input.parse_input_event(a)


func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(0.8), "timeout")

func _on_jump_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and is_on_floor():
		jump = -1.0
	else:
		jump = 0


func _on_jump_pressed():
	$jump.play()
	jump_pressed = true
	if is_on_floor():
		jump = -1.0
	else:
		jump = 0


func _on_jump_button_up():
	jump_pressed = false
	if velocity.y < 0.0:
		is_jump_interrupted = true
	else:
		is_jump_interrupted = false
	

func set_sprites():
	var sprites = CharacterController.all_sprites.hidratona
	if(Resources.acessory != "Coat" and Resources.acessory != "Umbrella"):
		$AllSprites/r1.texture = sprites.run.r1
		$AllSprites/r2.texture = sprites.run.r2
		$AllSprites/r3.texture = sprites.run.r3
		$AllSprites/r4.texture = sprites.run.r4
		$AllSprites/r5.texture = sprites.run.r5
		$AllSprites/r6.texture = sprites.run.r6
		$AllSprites/r7.texture = sprites.run.r7
		
		$AllSprites/j1.texture = sprites.jump.j1
		$AllSprites/j2.texture = sprites.jump.j2
		
		$AllSprites/squat.texture = sprites.squat
	
	if(Resources.acessory == "Coat"):
		$AllSprites/r1.texture = sprites.snow.run.r1
		$AllSprites/r2.texture = sprites.snow.run.r2
		$AllSprites/r3.texture = sprites.snow.run.r3
		$AllSprites/r4.texture = sprites.snow.run.r4
		$AllSprites/r5.texture = sprites.snow.run.r5
		$AllSprites/r6.texture = sprites.snow.run.r6
		$AllSprites/r7.texture = sprites.snow.run.r7
		
		$AllSprites/j1.texture = sprites.snow.jump.j1
		$AllSprites/j2.texture = sprites.snow.jump.j2
		
		$AllSprites/squat.texture = sprites.snow.squat
	
	if(Resources.acessory == "Umbrella"):
		$AllSprites/r1.texture = sprites.rain.run.r1
		$AllSprites/r2.texture = sprites.rain.run.r2
		$AllSprites/r3.texture = sprites.rain.run.r3
		$AllSprites/r4.texture = sprites.rain.run.r4
		$AllSprites/r5.texture = sprites.rain.run.r5
		$AllSprites/r6.texture = sprites.rain.run.r6
		$AllSprites/r7.texture = sprites.rain.run.r7
		
		$AllSprites/j1.texture = sprites.rain.jump.j1
		$AllSprites/j2.texture = sprites.rain.jump.j2
		
		$AllSprites/squat.texture = sprites.rain.squat

func _input(event):
	if Resources.in_hole:
		return;

#	print(event.as_text())

	if event is InputEventKey and event.is_pressed() and char(event.scancode) == "W" and is_on_floor():
		jump_pressed = true

	if event is InputEventScreenDrag:
		#get_relative_direction(event.relative)
		var aux = event.relative.y
		if aux > 3 and time_down <= 0:
			time_down = 1.2
			down = true
		elif aux < 3 and is_on_floor():
			jump_pressed = true


func get_relative_direction(relative):
	var aux = relative.y
	if(aux > 3):
		var a = InputEventAction.new()
		a.action = "down"
		a.pressed = true
		Input.parse_input_event(a)
	elif(aux < 3):
		jump_pressed = true
#		var a = InputEventAction.new()
#		a.action = "jump"
#		a.pressed = true
#		Input.parse_input_event(a)

