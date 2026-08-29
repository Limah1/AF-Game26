extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP
const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const LEGACY_BODY_SKIN_SHADER = preload("res://src/UI/LegacyBodySkin.shader")
const LEGACY_HEAD_SCALE = Vector2(0.105, 0.105)
const LEGACY_HEAD_X_OFFSET = -15.0
const LEVEL_HEADS_PATH = "res://src/Mini-games/Hidratona/src/level/heads/"
const SHARED_HIDRATONA_TEST_PATH = "res://assets/Hidratona/sprites/HidratonaNewTest/"
export var legacy_neck_offset = Vector2(-10, 25)
export var legacy_run_head_offset = Vector2.ZERO
export var legacy_run_neck_offset = Vector2(-10, 25)
export var legacy_squat_head_position = Vector2(-45.5, 31.5)
export var legacy_squat_neck_offset = Vector2(-10, 25)
export var legacy_neck_size = Vector2(20, 20)
export(int) var legacy_neck_draw_order = 10
export(int) var legacy_head_z_index = 2
export var speed: = Vector2(0, 1400)
export var gravity = 3000.0
export(bool) var use_modular_character = true
export(bool) var use_shared_hidratona_test_body = false
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
onready var legacy_head = $AllSprites/LegacyHead
onready var skin_color_rect = $AllSprites/SkinColorRect

func _ready():
	# Keep the old exported property working for existing scene overrides.
	if legacy_neck_offset != Vector2(-10, 25) and legacy_run_neck_offset == Vector2(-10, 25):
		legacy_run_neck_offset = legacy_neck_offset
	set_sprites()
	# Panel does not expose z_index in this Godot version. Its draw order is
	# controlled by the sibling index instead.
	_apply_legacy_draw_order()
	if legacy_head != null:
		legacy_head.z_index = legacy_head_z_index
	# Keep legacy sprites as fallback while modular mode owns rendering.
	$AllSprites.visible = !use_modular_character
	modular_rig.visible = use_modular_character
	if use_modular_character:
		if ModularCharacterData.has_method("apply_to_rig"):
			ModularCharacterData.apply_to_rig(modular_rig)
		_update_modular_state()
	_refresh_legacy_head()

	parallax = get_parent().get_node("floor")

func _process(_delta):
	_sync_legacy_head()

func _refresh_legacy_head() -> void:
	if legacy_head == null:
		return
	var head_texture = _get_level_head_texture()
	if head_texture == null:
		legacy_head.visible = false
		if skin_color_rect != null:
			skin_color_rect.visible = false
		return
	legacy_head.texture = head_texture
	legacy_head.scale = LEGACY_HEAD_SCALE
	var skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white
	_refresh_legacy_body_skin(skin)
	# The headless walk sprites leave a gap at the neck. This panel sits above
	# the combined body sprite and below the head so the gap remains visible.
	if skin_color_rect != null:
		skin_color_rect.rect_position = legacy_head.position + legacy_run_neck_offset
		skin_color_rect.rect_size = legacy_neck_size
		var neck_style = skin_color_rect.get_stylebox("panel") as StyleBoxFlat
		if neck_style != null:
			neck_style = neck_style.duplicate()
			neck_style.bg_color = skin
			skin_color_rect.add_stylebox_override("panel", neck_style)
	var head_material = legacy_head.material as ShaderMaterial
	if head_material == null or head_material.shader != LEGACY_HEAD_SHADER:
		head_material = ShaderMaterial.new()
		head_material.shader = LEGACY_HEAD_SHADER
		legacy_head.material = head_material
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", skin)
	_sync_legacy_head()

func _get_level_head_texture() -> Texture:
	# Snow sprites use the original character head. Rain keeps the dedicated
	# level head assets because its body set has the rainy proportions.
	if _is_snow_character():
		return CharacterController.get_legacy_head_texture()
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	var level_head_path = LEVEL_HEADS_PATH + gender + "-" + hair + ".png"
	if ResourceLoader.exists(level_head_path):
		var level_head = load(level_head_path) as Texture
		if level_head != null:
			return level_head
	return CharacterController.get_legacy_head_texture()

func _is_snow_character() -> bool:
	return Resources.weather == "Snowy" or Resources.acessory == "Coat"

func _refresh_legacy_body_skin(skin: Color) -> void:
	var body_skin_material = ShaderMaterial.new()
	body_skin_material.shader = LEGACY_BODY_SKIN_SHADER
	body_skin_material.set_shader_param("target_skin", skin)
	for sprite_name in ["r1", "r2", "r3", "r4", "r5", "r6", "r7", "j1", "j2", "squat"]:
		var body_sprite = get_node_or_null("AllSprites/" + sprite_name) as Sprite
		if body_sprite != null:
			body_sprite.material = body_skin_material

func _apply_legacy_draw_order() -> void:
	if skin_color_rect == null:
		return
	var parent = skin_color_rect.get_parent()
	if parent == null:
		return
	var head_index = legacy_head.get_index() if legacy_head != null else parent.get_child_count()
	var max_neck_index = max(head_index - 1, 0)
	var desired_index = clamp(legacy_neck_draw_order, 0, max_neck_index)
	parent.move_child(skin_color_rect, desired_index)

func _sync_legacy_head() -> void:
	if legacy_head == null:
		return
	if use_modular_character or Resources.in_hole:
		legacy_head.visible = false
		if skin_color_rect != null:
			skin_color_rect.visible = false
		return

	var next_position = Vector2.ZERO
	var neck_offset = legacy_run_neck_offset
	var body_visible = true
	var squat_visible = false
	if $AllSprites/r1.visible:
		next_position = Vector2(14 + LEGACY_HEAD_X_OFFSET, -5)
	elif $AllSprites/r2.visible:
		next_position = Vector2(2 + LEGACY_HEAD_X_OFFSET, -5)
	elif $AllSprites/r3.visible:
		next_position = Vector2(12.5 + LEGACY_HEAD_X_OFFSET, -5)
	elif $AllSprites/r4.visible:
		next_position = Vector2(22 + LEGACY_HEAD_X_OFFSET, -1)
	elif $AllSprites/r5.visible:
		next_position = Vector2(16.5 + LEGACY_HEAD_X_OFFSET, -3.5)
	elif $AllSprites/r6.visible:
		next_position = Vector2(8 + LEGACY_HEAD_X_OFFSET, -4.5)
	elif $AllSprites/r7.visible:
		next_position = Vector2(15.5 + LEGACY_HEAD_X_OFFSET, -0.5)
	elif $AllSprites/j1.visible:
		next_position = Vector2(11 + LEGACY_HEAD_X_OFFSET, -5.5)
	elif $AllSprites/j2.visible:
		next_position = Vector2(18 + LEGACY_HEAD_X_OFFSET, -7)
	elif $AllSprites/squat.visible:
		next_position = legacy_squat_head_position
		neck_offset = legacy_squat_neck_offset
		squat_visible = true
	else:
		body_visible = false

	# Running frames retain their individual alignment offsets, while this
	# exported value moves the complete running head/neck pair together.
	var running_visible = $AllSprites/r1.visible or $AllSprites/r2.visible or $AllSprites/r3.visible or $AllSprites/r4.visible or $AllSprites/r5.visible or $AllSprites/r6.visible or $AllSprites/r7.visible
	if body_visible and running_visible:
		next_position += legacy_run_head_offset
	if _is_snow_character():
		next_position += Vector2(35, 20)
		if squat_visible:
			next_position.x -= 15
			next_position.y += 10
	elif squat_visible and (Resources.weather == "Rainy" or Resources.acessory == "Umbrella"):
		next_position.y += 3

	legacy_head.position = next_position
	legacy_head.visible = body_visible and legacy_head.texture != null and $AllSprites.visible
	if skin_color_rect != null:
		skin_color_rect.rect_position = next_position + neck_offset
		skin_color_rect.visible = body_visible and legacy_head.texture != null and $AllSprites.visible and not squat_visible
	
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
	if !use_modular_character or modular_rig == null:
		return
	if modular_rig.state != next_state:
		modular_rig.set_state(next_state)
	var desired_variant = "running" if next_state == 2 else "default"
	if modular_rig.has_method("set_appearance_variant") and modular_rig.appearance_variant != desired_variant:
		modular_rig.set_appearance_variant(desired_variant)

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
	# Temporary migration switch: use one shared body set while keeping the
	# legacy head selected by CharacterController.boyorgirl.
	if use_shared_hidratona_test_body and Resources.acessory != "Coat" and Resources.acessory != "Umbrella":
		_set_shared_hidratona_test_sprites()
		return

	var sprites = _get_hidratona_sprites()
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

func set_weather_test_sprites(weather: String, assets_root: String) -> bool:
	var prefix = "rc" if weather == "Rainy" else "rs" if weather == "Snowy" else ""
	if prefix == "":
		return false

	var required_files = []
	for i in range(1, 8):
		required_files.append(prefix + "_" + str(i) + "_no_head.png")
	required_files += [prefix + "_j_no_head.png", prefix + "_d_no_head.png", prefix + "_squat_no_head.png"]
	for file_name in required_files:
		if !ResourceLoader.exists(assets_root.plus_file(file_name)):
			return false

	var run_nodes = ["r1", "r2", "r3", "r4", "r5", "r6", "r7"]
	for i in range(run_nodes.size()):
		get_node("AllSprites/" + run_nodes[i]).texture = load(assets_root.plus_file(prefix + "_" + str(i + 1) + "_no_head.png"))
	$AllSprites/j1.texture = load(assets_root.plus_file(prefix + "_j_no_head.png"))
	$AllSprites/j2.texture = load(assets_root.plus_file(prefix + "_d_no_head.png"))
	$AllSprites/squat.texture = load(assets_root.plus_file(prefix + "_squat_no_head.png"))
	return true

func _get_hidratona_sprites():
	var sprites = CharacterController.all_sprites.hidratona
	var required_run = sprites.run
	if Resources.acessory == "Coat":
		required_run = sprites.snow.run
	elif Resources.acessory == "Umbrella":
		required_run = sprites.rain.run

	# Level.tscn can be tested directly, before CharacterController.start()
	# has populated the cached Hidratona textures.
	if required_run.r1 == null:
		sprites = CharacterController.Load_Hidratona()
		CharacterController.all_sprites.hidratona = sprites

	return sprites

func _set_shared_hidratona_test_sprites() -> void:
	var path = SHARED_HIDRATONA_TEST_PATH
	$AllSprites/r1.texture = load(path + "correr-1-girl.png")
	$AllSprites/r2.texture = load(path + "correr-2-girl.png")
	$AllSprites/r3.texture = load(path + "correr-3-girl.png")
	$AllSprites/r4.texture = load(path + "correr-4-girl.png")
	$AllSprites/r5.texture = load(path + "correr-5-girl.png")
	$AllSprites/r6.texture = load(path + "correr-6-girl.png")
	$AllSprites/r7.texture = load(path + "correr-7-girl.png")
	$AllSprites/j1.texture = load(path + "pular-1-girl.png")
	$AllSprites/j2.texture = load(path + "pular-2-girl.png")
	$AllSprites/squat.texture = load(path + "agachar.png")

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
