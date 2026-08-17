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
	# Definindo cor azul para a barra de progresso via código (Override)
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 1) # Azul
	progress_bar.add_stylebox_override("fg", sb)
	
	# Configurações para deixar apenas o Sprite visível
	square_button.flat = true # Remove o fundo padrão do botão
	if square_button.has_node("ColorRect"):
		square_button.get_node("ColorRect").visible = false # Esconde o quadrado verde
		
	# Define o eixo de escala para o centro do botão
	square_button.rect_pivot_offset = square_button.rect_size / 2.0

func _process(delta):
	if is_full:
		square_button.rect_scale = Vector2(1, 1) # Reseta o tamanho ao encher
		return
		
	# Efeito de pulsação suave (cresce e diminui)
	pulse_time += delta * 5.0 # Velocidade da pulsação
	var scale_amount = 1.0 + sin(pulse_time) * 0.05 # Oscila entre 0.95 e 1.05
	square_button.rect_scale = Vector2(scale_amount, scale_amount)
		
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
