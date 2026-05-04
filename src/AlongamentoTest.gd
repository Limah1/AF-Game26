extends Control

var colors = [Color.red, Color.green, Color.blue, Color.yellow, Color.purple, Color.cyan]
var current_round = 0
var max_rounds = 4
var target_color: Color

onready var target_rect = $TargetRect
onready var options_container = $Options
onready var status_label = $StatusLabel

func _ready():
	randomize()
	start_round()

func start_round():
	if current_round >= max_rounds:
		status_label.text = "VOCE VENCEU O ALONGAMENTO!"
		# Desabilita botões
		for btn in options_container.get_children():
			btn.disabled = true
		return
		
	status_label.text = "Rodada " + str(current_round + 1) + " de " + str(max_rounds)
	
	# Escolhe cor alvo
	colors.shuffle()
	target_color = colors[0]
	target_rect.color = target_color
	
	# Prepara opções (alvo + 3 aleatórias)
	var round_options = [colors[0], colors[1], colors[2], colors[3]]
	round_options.shuffle()
	
	var buttons = options_container.get_children()
	for i in range(4):
		var btn = buttons[i]
		var rect = btn.get_node("ColorRect")
		rect.color = round_options[i]
		
		# Desconecta sinais antigos para evitar duplicação e bug de cliques multiplos
		if btn.is_connected("pressed", self, "_on_option_pressed"):
			btn.disconnect("pressed", self, "_on_option_pressed")
			
		btn.connect("pressed", self, "_on_option_pressed", [round_options[i]])

func _on_option_pressed(selected_color):
	if selected_color == target_color:
		current_round += 1
		start_round()
	else:
		status_label.text = "Errou! Tente de novo."
