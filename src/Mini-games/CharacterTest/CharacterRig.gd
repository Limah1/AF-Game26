extends Node2D

export(int, "Idle", "Walk", "Run") var state = 0

onready var rig_hair = $Hair
onready var rig_head = $Head
onready var rig_torso = $Torso
onready var rig_left_arm = $LeftArm
onready var rig_right_arm = $RightArm
onready var rig_left_leg = $LeftLeg
onready var rig_right_leg = $RightLeg

var time = 0.0

func _ready():
	_create_placeholder_textures()

func _process(delta):
	if state == 0:
		_reset_pose()
		return
		
	time += delta
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

func _create_placeholder_textures():
	var img = Image.new()
	img.create(64, 64, false, Image.FORMAT_RGBA8)
	img.fill(Color.white)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	rig_hair.texture = tex
	rig_head.texture = tex
	rig_torso.texture = tex
	rig_left_arm.texture = tex
	rig_right_arm.texture = tex
	rig_left_leg.texture = tex
	rig_right_leg.texture = tex
	
	rig_hair.scale = Vector2(1, 0.5)
	rig_head.scale = Vector2(0.8, 0.8)
	rig_torso.scale = Vector2(1, 1.5)
	rig_left_arm.scale = Vector2(0.4, 1.2)
	rig_right_arm.scale = Vector2(0.4, 1.2)
	rig_left_leg.scale = Vector2(0.4, 1.2)
	rig_right_leg.scale = Vector2(0.4, 1.2)

func set_hair_color(c: Color):
	rig_hair.modulate = c

func set_skin_color(c: Color):
	rig_head.modulate = c
	rig_left_arm.modulate = c
	rig_right_arm.modulate = c
	rig_left_leg.modulate = c
	rig_right_leg.modulate = c

func set_clothes_color(c: Color):
	rig_torso.modulate = c
