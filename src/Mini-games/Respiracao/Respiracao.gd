extends Control

"""Minigame guiado de respiração.

O jogador segura o botão durante a inspiração e a pausa com os pulmões cheios.
Depois, a expiração é conduzida automaticamente enquanto o círculo diminui.
"""

const TOTAL_ROUNDS := 3
const BASE_SCALE := 1.0
const MAX_SCALE := 2.0
const INHALE_DURATION := 3.0
const HOLD_DURATION := 1.0
const EXHALE_DURATION := 6.0

enum Phase { WAITING, INHALE, HOLD, EXHALE, COMPLETE }

var phase = Phase.WAITING
var phase_time := 0.0
var current_round := 1
var holding_button := false
var exhale_start_scale := BASE_SCALE
var room_reference = null

onready var breath_button = $BreathButton
onready var aura = $Aura
onready var phase_label = $PhaseLabel
onready var helper_label = $HelperLabel
onready var round_label = $RoundLabel
onready var progress_bar = $ProgressBar
onready var completion_panel = $CompletionPanel
onready var completion_label = $CompletionPanel/CompletionBox/CompletionLabel


func _ready() -> void:
	breath_button.connect("button_down", self, "_on_breath_button_down")
	breath_button.connect("button_up", self, "_on_breath_button_up")
	$CompletionPanel/CompletionBox/RestartButton.connect("pressed", self, "_on_restart_pressed")
	$CompletionPanel/CompletionBox/BackButton.connect("pressed", self, "_on_back_pressed")
	_update_interface()

func start(room) -> void:
	room_reference = room
	_restart_exercise()


func _process(delta: float) -> void:
	if phase == Phase.INHALE:
		if not holding_button:
			return
		phase_time += delta
		_set_circle_scale(_ease_in_out(phase_time / INHALE_DURATION, BASE_SCALE, MAX_SCALE))
		progress_bar.value = (phase_time / INHALE_DURATION) * 100.0
		if phase_time >= INHALE_DURATION:
			phase = Phase.HOLD
			phase_time = 0.0
			_set_circle_scale(MAX_SCALE)
			_update_interface()

	elif phase == Phase.HOLD:
		if not holding_button:
			_reset_current_breath()
			return
		phase_time += delta
		progress_bar.value = (phase_time / HOLD_DURATION) * 100.0
		if phase_time >= HOLD_DURATION:
			_begin_exhale()

	elif phase == Phase.EXHALE:
		phase_time += delta
		_set_circle_scale(_ease_in_out(phase_time / EXHALE_DURATION, exhale_start_scale, BASE_SCALE))
		progress_bar.value = (phase_time / EXHALE_DURATION) * 100.0
		if phase_time >= EXHALE_DURATION:
			_finish_breath()


func _on_breath_button_down() -> void:
	if phase == Phase.COMPLETE:
		_restart_exercise()
		return

	if phase == Phase.WAITING:
		holding_button = true
		phase = Phase.INHALE
		phase_time = 0.0
		_update_interface()
	elif phase == Phase.INHALE or phase == Phase.HOLD:
		holding_button = true


func _on_breath_button_up() -> void:
	holding_button = false
	# Soltar cedo não reinicia a rodada: a expiração começa do tamanho atual.
	if phase == Phase.INHALE or phase == Phase.HOLD:
		_begin_exhale()


func _begin_exhale() -> void:
	exhale_start_scale = clamp(breath_button.rect_scale.x, BASE_SCALE, MAX_SCALE)
	phase = Phase.EXHALE
	phase_time = 0.0
	holding_button = false
	_set_circle_scale(MAX_SCALE)
	_update_interface()


func _finish_breath() -> void:
	_set_circle_scale(BASE_SCALE)
	if current_round >= TOTAL_ROUNDS:
		phase = Phase.COMPLETE
		progress_bar.value = 100.0
		_update_interface()
		completion_panel.show()
		breath_button.hide()
		aura.hide()
	else:
		current_round += 1
		phase = Phase.WAITING
		phase_time = 0.0
		progress_bar.value = 0.0
		_update_interface()


func _reset_current_breath() -> void:
	phase = Phase.WAITING
	phase_time = 0.0
	holding_button = false
	_set_circle_scale(BASE_SCALE)
	progress_bar.value = 0.0
	_update_interface()


func _update_interface() -> void:
	round_label.text = "RESPIRAÇÃO %d DE %d" % [current_round, TOTAL_ROUNDS]

	match phase:
		Phase.WAITING:
			phase_label.text = "Mantenha o dedo no botão"
			helper_label.text = "Toque e segure para começar a inspirar"
			breath_button.text = "SEGURE"
		Phase.INHALE:
			phase_label.text = "Inspire"
			helper_label.text = "Continue segurando..."
			breath_button.text = "INSPIRANDO"
		Phase.HOLD:
			phase_label.text = "Segure o ar"
			helper_label.text = "Mantenha o dedo no botão por mais um pouco"
			breath_button.text = "SEGURE"
		Phase.EXHALE:
			phase_label.text = "Solte o ar pela boca"
			helper_label.text = "Expire devagar enquanto o círculo diminui"
			breath_button.text = "EXPIRE"
		Phase.COMPLETE:
			phase_label.text = "Exercício concluído!"
			helper_label.text = "Você completou as 3 respirações"


func _set_circle_scale(value: float) -> void:
	var safe_scale = clamp(value, BASE_SCALE, MAX_SCALE)
	breath_button.rect_scale = Vector2.ONE * safe_scale
	aura.rect_scale = Vector2.ONE * safe_scale


func _ease_in_out(progress: float, from_value: float, to_value: float) -> float:
	var t = clamp(progress, 0.0, 1.0)
	t = t * t * (3.0 - 2.0 * t)
	return lerp(from_value, to_value, t)


func _restart_exercise() -> void:
	completion_panel.hide()
	breath_button.show()
	aura.show()
	current_round = 1
	phase = Phase.WAITING
	phase_time = 0.0
	holding_button = false
	_set_circle_scale(BASE_SCALE)
	progress_bar.value = 0.0
	_update_interface()


func _on_restart_pressed() -> void:
	_restart_exercise()


func _on_back_pressed() -> void:
	if is_instance_valid(room_reference):
		if room_reference.has_method("finish_breathing_test"):
			room_reference.finish_breathing_test()
		queue_free()
	else:
		get_tree().change_scene("res://src/MainScreen.tscn")
