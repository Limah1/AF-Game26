extends Node2D

export(int, "Idle", "Walk", "Run", "Sleep", "Toilet") var state = 0 setget set_state

onready var rig_hair = $Hair
onready var rig_head = $Head
onready var rig_torso = $Torso
onready var rig_left_arm = $LeftArm
onready var rig_right_arm = $RightArm
onready var rig_left_leg = $LeftLeg
onready var rig_right_leg = $RightLeg
onready var rig_pants = $Pants

var time = 0.0

func _ready():
	_apply_state_setup()

func set_state(new_state):
	state = new_state
	_apply_state_setup()

func _apply_state_setup():
	if rig_head == null: return # Proteção se não estiver no node tree ainda
	
	if state == 3: # Sleep
		show_parts(["Hair", "Head", "LeftArm", "RightArm"])
		rig_head.rotation_degrees = -90
		rig_hair.rotation_degrees = -90
		rig_left_arm.rotation_degrees = -90
		rig_right_arm.rotation_degrees = -90
		
		# Ajuste posições para parecer deitado (uma mão de cada lado do rosto)
		rig_hair.position = Vector2(-20, -50)
		rig_left_arm.position = Vector2(-40, -10)
		rig_right_arm.position = Vector2(40, -10)
	elif state == 4: # Toilet (Sentado)
		show_all()
		rig_head.rotation_degrees = 0
		rig_hair.rotation_degrees = 0
		rig_left_arm.rotation_degrees = -20
		rig_right_arm.rotation_degrees = 20
		rig_left_leg.rotation_degrees = -90
		rig_right_leg.rotation_degrees = -90
		
		rig_hair.position = Vector2(0, 0)
		rig_head.position = Vector2(0, 0)
		rig_left_arm.position = Vector2(-40, -10)
		rig_right_arm.position = Vector2(40, -10)
		rig_left_leg.position = Vector2(-25, 40)
		rig_right_leg.position = Vector2(25, 40)
		rig_torso.position = Vector2(0, 10)
	else:
		show_all()
		rig_head.rotation_degrees = 0
		rig_head.position = Vector2(0, 0)
		rig_hair.rotation_degrees = 0
		rig_hair.position = Vector2(0, 0)
		rig_left_arm.position = Vector2(-50, -22)
		rig_right_arm.position = Vector2(50, -22)
		rig_left_leg.position = Vector2(-25, 58)
		rig_right_leg.position = Vector2(25, 58)
		rig_torso.position = Vector2(0, 0)
		_reset_pose()

func _process(delta):
	time += delta
	
	if state == 0:
		_reset_pose()
		# Animação leve de respiração no idle
		var breath = sin(time * 3.0) * 2.0
		rig_torso.scale.y = 1.0 + (breath * 0.01)
		return
		
	if state == 3: # Sleep
		var breath = sin(time * 2.0) * 5.0
		rig_head.position.y = breath
		rig_hair.position.y = breath - 50
		rig_left_arm.position.y = breath - 10
		rig_right_arm.position.y = breath - 10
		return
		
	if state == 4: # Toilet
		# Respiração leve sentado
		var breath = sin(time * 2.0) * 2.0
		rig_torso.scale.y = 1.0 + (breath * 0.01)
		return
		
	var speed = 10.0 if state == 1 else 20.0
	var swing = sin(time * speed)
	var angle = swing * 45
	
	# Ajuste do eixo de rotacao para ficar no ombro/quadril
	rig_left_arm.offset = Vector2(0, 32)
	rig_left_arm.position = Vector2(-50, -22)
	
	rig_right_arm.offset = Vector2(0, 32)
	rig_right_arm.position = Vector2(50, -22)
	
	rig_left_leg.offset = Vector2(0, 32)
	rig_left_leg.position = Vector2(-25, 58)
	
	rig_right_leg.offset = Vector2(0, 32)
	rig_right_leg.position = Vector2(25, 58)
	
	rig_left_arm.rotation_degrees = angle
	rig_right_arm.rotation_degrees = -angle
	rig_left_leg.rotation_degrees = -angle
	rig_right_leg.rotation_degrees = angle

func _reset_pose():
	rig_left_arm.rotation_degrees = 0
	rig_right_arm.rotation_degrees = 0
	rig_left_leg.rotation_degrees = 0
	rig_right_leg.rotation_degrees = 0

func set_skin_color(c: Color):
	rig_head.modulate = c
	rig_left_arm.modulate = c
	rig_right_arm.modulate = c
	rig_left_leg.modulate = c
	rig_right_leg.modulate = c

func set_hair_color(c: Color):
	rig_hair.modulate = c

func set_shirt_color(c: Color):
	rig_torso.modulate = c

func set_pants_color(c: Color):
	if rig_pants: rig_pants.modulate = c

func hide_all():
	rig_hair.visible = false
	rig_head.visible = false
	rig_torso.visible = false
	if rig_pants: rig_pants.visible = false
	rig_left_arm.visible = false
	rig_right_arm.visible = false
	rig_left_leg.visible = false
	rig_right_leg.visible = false

func show_all():
	rig_hair.visible = true
	rig_head.visible = true
	rig_torso.visible = true
	if rig_pants: rig_pants.visible = true
	rig_left_arm.visible = true
	rig_right_arm.visible = true
	rig_left_leg.visible = true
	rig_right_leg.visible = true

func show_parts(parts: Array):
	hide_all()
	for p in parts:
		if has_node(p):
			get_node(p).visible = true

func set_face_texture(tex: Texture):
	if tex != null:
		rig_head.texture = tex

func set_arms_texture(tex: Texture):
	if tex != null:
		rig_left_arm.texture = tex
		rig_right_arm.texture = tex
