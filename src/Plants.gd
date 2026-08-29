extends Control

onready var progress_bar = $ProgressBar
onready var timer = $Timer
onready var square_button = $SquareButton

var filling = false
var is_full = false
var fill_speed = 50.0 # Pontos por segundo (enche em 2s se max_value = 100)
var decay_speed = 30.0 # Pontos por segundo para decair

var pulse_time = 0.0

func _ready():
	progress_bar.value = 0
	progress_bar.rect_pivot_offset = progress_bar.rect_size / 2.0
	progress_bar.rect_scale = Vector2(1, 1)
	
	# Configurações para deixar apenas o Sprite visível
	square_button.flat = true # Remove o fundo padrão do botão
	if square_button.has_node("ColorRect"):
		square_button.get_node("ColorRect").visible = false # Esconde o quadrado verde
		
func _process(delta):
	if is_full:
		progress_bar.rect_scale = Vector2(1, 1)
		return

	# Pulsação suave aplicada somente à barra enquanto ela está enchendo.
	if filling:
		pulse_time += delta * 8.0
		var scale_amount = 1.0 + sin(pulse_time) * 0.05
		progress_bar.rect_scale = Vector2(scale_amount, scale_amount)
	else:
		pulse_time = 0.0
		progress_bar.rect_scale = progress_bar.rect_scale.linear_interpolate(Vector2(1, 1), min(delta * 10.0, 1.0))
		
	if filling:
		progress_bar.value += fill_speed * delta
		if progress_bar.value >= progress_bar.max_value:
			progress_bar.value = progress_bar.max_value
			is_full = true
			filling = false
			square_button.disabled = true
			start_cooldown()
	else:
		if progress_bar.value > 0:
			progress_bar.value -= decay_speed * delta

func _on_SquareButton_button_down():
	if not is_full:
		filling = true

func _on_SquareButton_button_up():
	filling = false

func start_cooldown():
	timer.start(45) # 45 segundos

func _on_Timer_timeout():
	progress_bar.value = 0
	is_full = false
	square_button.disabled = false # Reabilita o clique
