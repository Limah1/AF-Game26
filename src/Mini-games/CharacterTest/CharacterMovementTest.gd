extends Node2D

const WALK_SPEED = 180.0

onready var character = $CharacterRig
onready var movement_tween = $MovementTween
onready var status_label = $CanvasLayer/UI/Status
onready var sleep_button = $CanvasLayer/UI/SleepButton

var moving = false
var next_state = 0

func _ready():
	# CharacterRig has no textures in its scene. Apply current modular data after
	# autoloads finish loading, then start in the idle pose.
	yield(get_tree(), "idle_frame")
	character.set_state(0)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(character)
	_sync_sleep_button()

func _walk_to(target: Vector2, final_state: int, message: String, direction: int = 0) -> void:
	if moving:
		return

	moving = true
	next_state = final_state
	status_label.text = message
	if direction == 0:
		direction = _direction_to_target(target)
	_set_facing(direction)
	character.set_state(1) # Walk

	var distance = character.position.distance_to(target)
	var duration = max(distance / WALK_SPEED, 0.1)
	movement_tween.interpolate_property(
		character,
		"position",
		character.position,
		target,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	movement_tween.start()

func _on_MovementTween_tween_all_completed() -> void:
	moving = false
	character.set_state(next_state)
	character.set_appearance_variant("sleeping" if next_state == 3 else "default")
	if next_state == 3:
		status_label.text = "Sleeping at bed"
	else:
		status_label.text = "Idle"
	_sync_sleep_button()

func _on_LeftButton_pressed() -> void:
	_walk_to(
		$LeftTarget.position,
		0,
		"Walking to left target",
		_button_direction($CanvasLayer/UI/LeftButton)
	)

func _on_RightButton_pressed() -> void:
	_walk_to(
		$RightTarget.position,
		0,
		"Walking to right target",
		_button_direction($CanvasLayer/UI/RightButton)
	)

func _on_SleepButton_pressed() -> void:
	if moving:
		return

	if character.state == 3:
		character.set_state(0)
		character.set_appearance_variant("default")
		status_label.text = "Idle at bed"
		_sync_sleep_button()
		return

	var bed_position = $BedTarget.position
	if character.position.distance_to(bed_position) <= 2.0:
		character.set_state(3)
		character.set_appearance_variant("sleeping")
		status_label.text = "Sleeping at bed"
		_sync_sleep_button()
	else:
		_walk_to(bed_position, 3, "Walking to bed")

func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://src/Mini-games/CharacterTest/CharacterTest.tscn")

func _button_direction(button: Button) -> int:
	if button.has_meta("walk_direction"):
		return int(button.get_meta("walk_direction"))
	return 0

func _direction_to_target(target: Vector2) -> int:
	if target.x < character.position.x:
		return -1
	if target.x > character.position.x:
		return 1
	return 0

func _set_facing(direction: int) -> void:
	if direction == 0:
		return
	if character.has_method("set_facing"):
		character.set_facing(direction)

func _sync_sleep_button() -> void:
	if character.state == 3:
		sleep_button.text = "Wake Up"
	else:
		sleep_button.text = "Sleep Here"
