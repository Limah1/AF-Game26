extends Node2D

export(int, "Idle", "Walk", "Run", "Sleep", "Toilet", "Jump") var state = 0 setget set_state

# Idle pose positions.
export(Vector2) var idle_head_position = Vector2(0, 0)
export(Vector2) var idle_torso_position = Vector2(0, 0)
export(Vector2) var idle_left_arm_position = Vector2(-35, 12)
export(Vector2) var idle_right_arm_position = Vector2(35, 12)
export(Vector2) var idle_left_hand_position = Vector2(-50, -22)
export(Vector2) var idle_right_hand_position = Vector2(50, -22)
export(Vector2) var idle_left_leg_position = Vector2(-18, 20)
export(Vector2) var idle_right_leg_position = Vector2(10, 20)
export(Vector2) var idle_pants_position = Vector2(0, 55)
export(bool) var idle_head_visible = true
export(bool) var idle_torso_visible = true
export(bool) var idle_left_arm_visible = true
export(bool) var idle_right_arm_visible = true
export(bool) var idle_left_hand_visible = true
export(bool) var idle_right_hand_visible = true
export(bool) var idle_left_leg_visible = true
export(bool) var idle_right_leg_visible = true
export(bool) var idle_pants_visible = true

# Walk pose positions. Animation changes rotations, not these anchors.
export(Vector2) var walk_head_position = Vector2(0, 0)
export(Vector2) var walk_torso_position = Vector2(0, 0)
export(Vector2) var walk_left_arm_position = Vector2(-33, -22)
export(Vector2) var walk_right_arm_position = Vector2(33, -22)
export(Vector2) var walk_left_hand_position = Vector2(-50, -22)
export(Vector2) var walk_right_hand_position = Vector2(50, -22)
export(Vector2) var walk_left_leg_position = Vector2(-18, 20)
export(Vector2) var walk_right_leg_position = Vector2(10, 20)
export(Vector2) var walk_pants_position = Vector2(0, 55)
export(bool) var walk_head_visible = true
export(bool) var walk_torso_visible = true
export(bool) var walk_left_arm_visible = true
export(bool) var walk_right_arm_visible = true
export(bool) var walk_left_hand_visible = true
export(bool) var walk_right_hand_visible = true
export(bool) var walk_left_leg_visible = true
export(bool) var walk_right_leg_visible = true
export(bool) var walk_pants_visible = true

# Run pose positions. Separate defaults allow independent tuning later.
export(Vector2) var run_head_position = Vector2(0, 0)
export(Vector2) var run_torso_position = Vector2(0, 0)
export(Vector2) var run_left_arm_position = Vector2(-33, -22)
export(Vector2) var run_right_arm_position = Vector2(33, -22)
export(Vector2) var run_left_hand_position = Vector2(-50, -22)
export(Vector2) var run_right_hand_position = Vector2(50, -22)
export(Vector2) var run_left_leg_position = Vector2(-18, 20)
export(Vector2) var run_right_leg_position = Vector2(10, 20)
export(Vector2) var run_pants_position = Vector2(0, 55)
export(bool) var run_head_visible = true
export(bool) var run_torso_visible = true
export(bool) var run_left_arm_visible = true
export(bool) var run_right_arm_visible = true
export(bool) var run_left_hand_visible = true
export(bool) var run_right_hand_visible = true
export(bool) var run_left_leg_visible = true
export(bool) var run_right_leg_visible = true
export(bool) var run_pants_visible = true

# Sleep pose positions.
export(Vector2) var sleep_head_position = Vector2(0, -90)
export(Vector2) var sleep_torso_position = Vector2(0, 0)
export(Vector2) var sleep_left_arm_position = Vector2(-40, -10)
export(Vector2) var sleep_right_arm_position = Vector2(40, -10)
export(Vector2) var sleep_left_hand_position = Vector2(-40, -10)
export(Vector2) var sleep_right_hand_position = Vector2(40, -10)
export(Vector2) var sleep_left_leg_position = Vector2(-25, 58)
export(Vector2) var sleep_right_leg_position = Vector2(25, 58)
export(Vector2) var sleep_pants_position = Vector2(0, 55)
export(bool) var sleep_head_visible = true
export(bool) var sleep_torso_visible = false
export(bool) var sleep_left_arm_visible = true
export(bool) var sleep_right_arm_visible = true
export(bool) var sleep_left_hand_visible = true
export(bool) var sleep_right_hand_visible = true
export(bool) var sleep_left_leg_visible = false
export(bool) var sleep_right_leg_visible = false
export(bool) var sleep_pants_visible = false

# Toilet pose positions.
export(Vector2) var toilet_head_position = Vector2(0, 0)
export(Vector2) var toilet_torso_position = Vector2(0, 10)
export(Vector2) var toilet_left_arm_position = Vector2(-40, -10)
export(Vector2) var toilet_right_arm_position = Vector2(40, -10)
export(Vector2) var toilet_left_hand_position = Vector2(-40, -10)
export(Vector2) var toilet_right_hand_position = Vector2(40, -10)
export(Vector2) var toilet_left_leg_position = Vector2(-25, 40)
export(Vector2) var toilet_right_leg_position = Vector2(25, 40)
export(Vector2) var toilet_pants_position = Vector2(0, 55)
export(bool) var toilet_head_visible = true
export(bool) var toilet_torso_visible = true
export(bool) var toilet_left_arm_visible = true
export(bool) var toilet_right_arm_visible = true
export(bool) var toilet_left_hand_visible = true
export(bool) var toilet_right_hand_visible = true
export(bool) var toilet_left_leg_visible = true
export(bool) var toilet_right_leg_visible = true
export(bool) var toilet_pants_visible = true

# Jump pose. Static anchors; arm rotations stay exposed for tuning.
export(Vector2) var jump_head_position = Vector2(0, 0)
export(Vector2) var jump_torso_position = Vector2(0, 0)
export(Vector2) var jump_left_arm_position = Vector2(-35, 12)
export(Vector2) var jump_right_arm_position = Vector2(35, 12)
export(Vector2) var jump_left_hand_position = Vector2(-50, -22)
export(Vector2) var jump_right_hand_position = Vector2(50, -22)
export(Vector2) var jump_left_leg_position = Vector2(-18, 20)
export(Vector2) var jump_right_leg_position = Vector2(10, 20)
export(Vector2) var jump_pants_position = Vector2(0, 55)
export(bool) var jump_head_visible = true
export(bool) var jump_torso_visible = true
export(bool) var jump_left_arm_visible = true
export(bool) var jump_right_arm_visible = true
export(bool) var jump_left_hand_visible = true
export(bool) var jump_right_hand_visible = true
export(bool) var jump_left_leg_visible = true
export(bool) var jump_right_leg_visible = true
export(bool) var jump_pants_visible = true
export(float) var jump_left_arm_rotation_degrees = 180.0
export(float) var jump_right_arm_rotation_degrees = 180.0
export(float) var jump_left_hand_rotation_degrees = 180.0
export(float) var jump_right_hand_rotation_degrees = 180.0

# Pivot offsets are measured in rig units from the sprite center.
# They are converted to texture pixels after each part's scale is applied.
# Sprite origin acts as rotation pivot. Tune in CharacterRig Inspector.
export(Vector2) var head_pivot_offset = Vector2.ZERO
export(Vector2) var left_arm_pivot_offset = Vector2(0, 32)
export(Vector2) var right_arm_pivot_offset = Vector2(0, 32)
export(Vector2) var left_hand_pivot_offset = Vector2(0, 32)
export(Vector2) var right_hand_pivot_offset = Vector2(0, 32)
export(Vector2) var left_leg_pivot_offset = Vector2(0, 32)
export(Vector2) var right_leg_pivot_offset = Vector2(0, 32)

onready var rig_head = $Head
onready var rig_torso = $Torso
onready var rig_left_arm = $LeftArm
onready var rig_right_arm = $RightArm
onready var rig_left_hand = $LeftHand
onready var rig_right_hand = $RightHand
onready var rig_left_leg = $LeftLeg
onready var rig_right_leg = $RightLeg
onready var rig_pants = $Pants

var time = 0.0
var walk_time = 0.0
var torso_base_scale = Vector2.ONE
var facing_direction = 1

func _ready():
	_apply_state_setup()

func set_state(new_state):
	if new_state == 1 and state != 1:
		walk_time = 0.0
	state = new_state
	_apply_state_setup()

func set_facing(direction: int) -> void:
	if direction == 0:
		return
	facing_direction = -1 if direction < 0 else 1
	# Flip root, so every body part mirrors together.
	scale.x = abs(scale.x) * facing_direction

func _apply_state_setup():
	if rig_head == null: return

	if state == 3: # Sleep
		show_parts(["Head", "LeftArm", "RightArm", "LeftHand", "RightHand"])
		_apply_pose(
			sleep_head_position,
			sleep_torso_position,
			sleep_left_arm_position,
			sleep_right_arm_position,
			sleep_left_hand_position,
			sleep_right_hand_position,
			sleep_left_leg_position,
			sleep_right_leg_position,
			sleep_pants_position,
			[
				sleep_head_visible,
				sleep_torso_visible,
				sleep_left_arm_visible,
				sleep_right_arm_visible,
				sleep_left_hand_visible,
				sleep_right_hand_visible,
				sleep_left_leg_visible,
				sleep_right_leg_visible,
				sleep_pants_visible
			]
		)
		_apply_pivot_offsets()
		rig_head.rotation_degrees = 0
		rig_left_arm.rotation_degrees = -90
		rig_right_arm.rotation_degrees = -90
		rig_left_hand.rotation_degrees = -90
		rig_right_hand.rotation_degrees = -90
	elif state == 4: # Toilet
		show_all()
		_apply_pose(
			toilet_head_position,
			toilet_torso_position,
			toilet_left_arm_position,
			toilet_right_arm_position,
			toilet_left_hand_position,
			toilet_right_hand_position,
			toilet_left_leg_position,
			toilet_right_leg_position,
			toilet_pants_position,
			[
				toilet_head_visible,
				toilet_torso_visible,
				toilet_left_arm_visible,
				toilet_right_arm_visible,
				toilet_left_hand_visible,
				toilet_right_hand_visible,
				toilet_left_leg_visible,
				toilet_right_leg_visible,
				toilet_pants_visible
				]
		)
		_apply_pivot_offsets()
		rig_head.rotation_degrees = 0
		rig_left_arm.rotation_degrees = -20
		rig_right_arm.rotation_degrees = 20
		rig_left_hand.rotation_degrees = -20
		rig_right_hand.rotation_degrees = 20
		rig_left_leg.rotation_degrees = -90
		rig_right_leg.rotation_degrees = -90
	elif state == 5: # Jump
		show_all()
		_apply_pose(
			jump_head_position,
			jump_torso_position,
			jump_left_arm_position,
			jump_right_arm_position,
			jump_left_hand_position,
			jump_right_hand_position,
			jump_left_leg_position,
			jump_right_leg_position,
			jump_pants_position,
			[
				jump_head_visible,
				jump_torso_visible,
				jump_left_arm_visible,
				jump_right_arm_visible,
				jump_left_hand_visible,
				jump_right_hand_visible,
				jump_left_leg_visible,
				jump_right_leg_visible,
				jump_pants_visible
			]
		)
		_apply_pivot_offsets()
		_reset_pose()
		rig_head.rotation_degrees = 0
		rig_left_arm.rotation_degrees = jump_left_arm_rotation_degrees
		rig_right_arm.rotation_degrees = jump_right_arm_rotation_degrees
		rig_left_hand.rotation_degrees = jump_left_hand_rotation_degrees
		rig_right_hand.rotation_degrees = jump_right_hand_rotation_degrees
	else:
		show_all()
		if state == 1: # Walk
			_apply_pose(
				walk_head_position,
				walk_torso_position,
				walk_left_arm_position,
				walk_right_arm_position,
				walk_left_hand_position,
				walk_right_hand_position,
					walk_left_leg_position,
					walk_right_leg_position,
					walk_pants_position,
					[
						walk_head_visible,
						walk_torso_visible,
						walk_left_arm_visible,
						walk_right_arm_visible,
						walk_left_hand_visible,
						walk_right_hand_visible,
						walk_left_leg_visible,
						walk_right_leg_visible,
						walk_pants_visible
					]
			)
		elif state == 2: # Run
			_apply_pose(
				run_head_position,
				run_torso_position,
				run_left_arm_position,
				run_right_arm_position,
				run_left_hand_position,
				run_right_hand_position,
					run_left_leg_position,
					run_right_leg_position,
					run_pants_position,
				[
					run_head_visible,
					run_torso_visible,
					run_left_arm_visible,
					run_right_arm_visible,
					run_left_hand_visible,
					run_right_hand_visible,
					run_left_leg_visible,
					run_right_leg_visible,
					run_pants_visible
				]
			)
		else: # Idle
			_apply_pose(
				idle_head_position,
				idle_torso_position,
				idle_left_arm_position,
				idle_right_arm_position,
				idle_left_hand_position,
				idle_right_hand_position,
					idle_left_leg_position,
					idle_right_leg_position,
					idle_pants_position,
				[
					idle_head_visible,
					idle_torso_visible,
					idle_left_arm_visible,
					idle_right_arm_visible,
					idle_left_hand_visible,
					idle_right_hand_visible,
					idle_left_leg_visible,
					idle_right_leg_visible,
					idle_pants_visible
				]
			)
		_reset_pose()

func _process(delta):
	time += delta
	if state == 1:
		walk_time += delta
	if state != 0:
		# Reapply after data-driven scale changes. Sprite.offset uses texture pixels.
		_apply_pivot_offsets()

	if state == 0:
		var breath = sin(time * 3.0) * 2.0
		rig_torso.scale = Vector2(torso_base_scale.x, torso_base_scale.y * (1.0 + (breath * 0.01)))
		return

	if state == 3: # Sleep
		var sleep_breath = sin(time * 2.0) * 5.0
		rig_head.position = sleep_head_position + Vector2(0, sleep_breath)
		rig_left_arm.position = sleep_left_arm_position + Vector2(0, sleep_breath)
		rig_right_arm.position = sleep_right_arm_position + Vector2(0, sleep_breath)
		rig_left_hand.position = sleep_left_hand_position + Vector2(0, sleep_breath)
		rig_right_hand.position = sleep_right_hand_position + Vector2(0, sleep_breath)
		return

	if state == 4: # Toilet
		var toilet_breath = sin(time * 2.0) * 2.0
		rig_torso.scale = Vector2(torso_base_scale.x, torso_base_scale.y * (1.0 + (toilet_breath * 0.01)))
		return

	if state == 5: # Jump
		# Static jump pose: no vertical animation.
		rig_head.position = jump_head_position
		rig_torso.position = jump_torso_position
		rig_left_arm.position = jump_left_arm_position
		rig_right_arm.position = jump_right_arm_position
		rig_left_hand.position = jump_left_hand_position
		rig_right_hand.position = jump_right_hand_position
		rig_left_leg.position = jump_left_leg_position
		rig_right_leg.position = jump_right_leg_position
		rig_pants.position = jump_pants_position
		rig_left_arm.rotation_degrees = jump_left_arm_rotation_degrees
		rig_right_arm.rotation_degrees = jump_right_arm_rotation_degrees
		rig_left_hand.rotation_degrees = jump_left_hand_rotation_degrees
		rig_right_hand.rotation_degrees = jump_right_hand_rotation_degrees
		return

	# Walk and run keep their exported anchors. Only rotation animates.
	var left_arm_position = walk_left_arm_position if state == 1 else run_left_arm_position
	var right_arm_position = walk_right_arm_position if state == 1 else run_right_arm_position
	var left_hand_position = walk_left_hand_position if state == 1 else run_left_hand_position
	var right_hand_position = walk_right_hand_position if state == 1 else run_right_hand_position
	var left_leg_position = walk_left_leg_position if state == 1 else run_left_leg_position
	var right_leg_position = walk_right_leg_position if state == 1 else run_right_leg_position

	var speed = 10.0 if state == 1 else 20.0
	var arm_angle = 0.0
	if state == 1:
		# Walk arms: rest at 0°, swing to 15°, return to rest.
		var walk_swing = (sin(walk_time * speed - (PI * 0.5)) + 1.0) * 0.5
		arm_angle = walk_swing * 15.0
	else:
		var run_swing = sin(time * speed)
		arm_angle = run_swing * 45.0
	var leg_angle = sin(time * speed) * 45.0

	rig_left_arm.position = left_arm_position
	rig_right_arm.position = right_arm_position
	rig_left_hand.position = left_hand_position
	rig_right_hand.position = right_hand_position
	rig_left_leg.position = left_leg_position
	rig_right_leg.position = right_leg_position

	rig_left_arm.rotation_degrees = arm_angle
	rig_right_arm.rotation_degrees = -arm_angle
	rig_left_hand.rotation_degrees = arm_angle
	rig_right_hand.rotation_degrees = -arm_angle
	rig_left_leg.rotation_degrees = -leg_angle
	rig_right_leg.rotation_degrees = leg_angle

func _apply_pose(head_position: Vector2, torso_position: Vector2, left_arm_position: Vector2, right_arm_position: Vector2, left_hand_position: Vector2, right_hand_position: Vector2, left_leg_position: Vector2, right_leg_position: Vector2, pants_position: Vector2, visibility: Array):
	var positions = [
		head_position,
		torso_position,
		left_arm_position,
		right_arm_position,
		left_hand_position,
		right_hand_position,
		left_leg_position,
		right_leg_position,
		pants_position
	]
	rig_head.position = positions[0]
	rig_torso.position = positions[1]
	rig_left_arm.position = positions[2]
	rig_right_arm.position = positions[3]
	rig_left_hand.position = positions[4]
	rig_right_hand.position = positions[5]
	rig_left_leg.position = positions[6]
	rig_right_leg.position = positions[7]
	rig_pants.position = positions[8]

	var nodes = [
		rig_head,
		rig_torso,
		rig_left_arm,
		rig_right_arm,
		rig_left_hand,
		rig_right_hand,
		rig_left_leg,
		rig_right_leg,
		rig_pants
	]
	for index in range(nodes.size()):
		nodes[index].visible = visibility[index]

func _reset_pose():
	rig_left_arm.rotation_degrees = 0
	rig_right_arm.rotation_degrees = 0
	rig_left_hand.rotation_degrees = 0
	rig_right_hand.rotation_degrees = 0
	rig_left_leg.rotation_degrees = 0
	rig_right_leg.rotation_degrees = 0
	rig_head.offset = Vector2.ZERO
	rig_left_arm.offset = Vector2.ZERO
	rig_right_arm.offset = Vector2.ZERO
	rig_left_hand.offset = Vector2.ZERO
	rig_right_hand.offset = Vector2.ZERO
	rig_left_leg.offset = Vector2.ZERO
	rig_right_leg.offset = Vector2.ZERO

func _apply_pivot_offsets():
	_set_pivot_offset(rig_head, head_pivot_offset)
	_set_pivot_offset(rig_left_arm, left_arm_pivot_offset)
	_set_pivot_offset(rig_right_arm, right_arm_pivot_offset)
	_set_pivot_offset(rig_left_hand, left_hand_pivot_offset)
	_set_pivot_offset(rig_right_hand, right_hand_pivot_offset)
	_set_pivot_offset(rig_left_leg, left_leg_pivot_offset)
	_set_pivot_offset(rig_right_leg, right_leg_pivot_offset)

func _set_pivot_offset(sprite: Sprite, rig_offset: Vector2):
	var scale = sprite.scale
	var scale_x = scale.x if abs(scale.x) > 0.0001 else 1.0
	var scale_y = scale.y if abs(scale.y) > 0.0001 else 1.0
	sprite.offset = Vector2(rig_offset.x / scale_x, rig_offset.y / scale_y)

func set_skin_color(c: Color):
	rig_head.modulate = c
	rig_left_arm.modulate = c
	rig_right_arm.modulate = c
	rig_left_hand.modulate = c
	rig_right_hand.modulate = c

func set_shirt_color(c: Color):
	rig_torso.modulate = c

func set_pants_color(c: Color):
	# The modular lower-body assets are the two leg sprites.
	rig_left_leg.modulate = c
	rig_right_leg.modulate = c
	# Keep the legacy Pants node compatible for toilet/fallback poses.
	if rig_pants: rig_pants.modulate = c

func hide_all():
	rig_head.visible = false
	rig_torso.visible = false
	if rig_pants: rig_pants.visible = false
	rig_left_arm.visible = false
	rig_right_arm.visible = false
	rig_left_hand.visible = false
	rig_right_hand.visible = false
	rig_left_leg.visible = false
	rig_right_leg.visible = false

func show_all():
	rig_head.visible = true
	rig_torso.visible = true
	if rig_pants: rig_pants.visible = true
	rig_left_arm.visible = true
	rig_right_arm.visible = true
	rig_left_hand.visible = true
	rig_right_hand.visible = true
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

func set_arms_texture(tex: Texture, right_tex: Texture = null):
	if tex != null:
		rig_left_arm.texture = tex
	if right_tex != null:
		rig_right_arm.texture = right_tex
	elif tex != null:
		rig_right_arm.texture = tex

func set_clothes_texture(tex: Texture):
	if tex != null:
		rig_torso.texture = tex

func set_part_visual(part_name: String, tex: Texture, visual_position: Vector2, visual_scale: Vector2, visual_rotation_degrees: float):
	if not has_node(part_name):
		return

	var sprite = get_node(part_name)
	if tex != null:
		sprite.texture = tex
	# Zero transform values mean "keep the pose selected by the rig state".
	if visual_position != Vector2.ZERO:
		sprite.position = visual_position
	if visual_scale != Vector2.ZERO:
		sprite.scale = visual_scale
	if visual_rotation_degrees != 0.0:
		sprite.rotation_degrees = visual_rotation_degrees
	if part_name == "Torso" and visual_scale != Vector2.ZERO:
		torso_base_scale = visual_scale

func set_arm_visuals(left_tex: Texture, right_tex: Texture, left_position: Vector2, right_position: Vector2, left_scale: Vector2, right_scale: Vector2, left_rotation_degrees: float, right_rotation_degrees: float):
	_apply_pair_visuals(rig_left_arm, rig_right_arm, left_tex, right_tex, left_position, right_position, left_scale, right_scale, left_rotation_degrees, right_rotation_degrees)

func set_leg_visuals(left_tex: Texture, right_tex: Texture, left_position: Vector2, right_position: Vector2, left_scale: Vector2, right_scale: Vector2, left_rotation_degrees: float, right_rotation_degrees: float):
	_apply_pair_visuals(rig_left_leg, rig_right_leg, left_tex, right_tex, left_position, right_position, left_scale, right_scale, left_rotation_degrees, right_rotation_degrees)

func set_hand_visuals(left_tex: Texture, right_tex: Texture, left_position: Vector2, right_position: Vector2, left_scale: Vector2, right_scale: Vector2, left_rotation_degrees: float, right_rotation_degrees: float):
	_apply_pair_visuals(rig_left_hand, rig_right_hand, left_tex, right_tex, left_position, right_position, left_scale, right_scale, left_rotation_degrees, right_rotation_degrees)

func _apply_pair_visuals(left_sprite: Sprite, right_sprite: Sprite, left_tex: Texture, right_tex: Texture, left_position: Vector2, right_position: Vector2, left_scale: Vector2, right_scale: Vector2, left_rotation_degrees: float, right_rotation_degrees: float):
	if left_tex != null:
		left_sprite.texture = left_tex
	if right_tex != null:
		right_sprite.texture = right_tex

	# Zero transform values mean "keep the current state pose".
	if left_position != Vector2.ZERO:
		left_sprite.position = left_position
	if right_position != Vector2.ZERO:
		right_sprite.position = right_position
	if left_scale != Vector2.ZERO:
		left_sprite.scale = left_scale
	if right_scale != Vector2.ZERO:
		right_sprite.scale = right_scale
	if left_rotation_degrees != 0.0:
		left_sprite.rotation_degrees = left_rotation_degrees
	if right_rotation_degrees != 0.0:
		right_sprite.rotation_degrees = right_rotation_degrees
