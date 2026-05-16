extends Control

export(Array, Texture) var image_pool = []
var session_targets = []
var current_round = 0
var max_rounds = 5
var target_image: Texture

onready var target_rect = $TargetRect
onready var options_container = $Options
onready var status_label = $StatusLabel
onready var end_panel = $EndPanel
onready var sequence_container = $EndPanel/SequenceWhiteBox/SequenceContainer
onready var btn_repeat = $EndPanel/BtnRepeat
onready var btn_room = $EndPanel/BtnRoom

func _ready():
	randomize()
	btn_repeat.connect("pressed", self, "start_session")
	btn_room.connect("pressed", self, "_on_room_pressed")
	
	# Fallback if array empty
	if image_pool.empty():
		for i in range(10):
			image_pool.append(preload("res://icon.png"))
			
	BackgroundMusic.stop_music()
			
	# Music
	var music := AudioStreamPlayer.new()
	music.name = "bg_music"
	music.stream = load("res://assets/sounds/Sons Atualizados/Still Water Mat.mp3")
	add_child(music)
	music.play()
			
	start_session()

func start_session():
	end_panel.hide()
	options_container.show()
	target_rect.show()
	current_round = 0
	
	var pool_copy = image_pool.duplicate()
	pool_copy.shuffle()
	
	session_targets.clear()
	for i in range(5):
		session_targets.append(pool_copy[i])
		
	start_round()

func start_round():
	if current_round >= max_rounds:
		show_end_screen()
		return
		
	status_label.text = "Rodada " + str(current_round + 1) + " de " + str(max_rounds)
	
	target_image = session_targets[current_round]
	target_rect.texture = target_image
	
	# Pega 3 distrações
	var distractions = []
	var pool_copy = image_pool.duplicate()
	pool_copy.erase(target_image)
	pool_copy.shuffle()
	
	for i in range(3):
		distractions.append(pool_copy[i])
		
	# Prepara as 4 opções da rodada
	var round_options = [target_image, distractions[0], distractions[1], distractions[2]]
	round_options.shuffle()
	
	var buttons = options_container.get_children()
	for i in range(4):
		var btn = buttons[i]
		var sprite = btn.get_node("Sprite")
		sprite.texture = round_options[i]
		
		if btn.is_connected("pressed", self, "_on_option_pressed"):
			btn.disconnect("pressed", self, "_on_option_pressed")
			
		btn.connect("pressed", self, "_on_option_pressed", [round_options[i]])

func _on_option_pressed(selected_image):
	if selected_image == target_image:
		current_round += 1
		start_round()
	else:
		status_label.text = "Errou! Tente de novo."

func show_end_screen():
	status_label.text = "Sessão Concluída!"
	options_container.hide()
	target_rect.hide()
	end_panel.show()
	
	# Limpa sequencia antiga
	for child in sequence_container.get_children():
		child.queue_free()
		
	# Mostra sequencia escolhida (as 5 imagens)
	for img in session_targets:
		var rect = TextureRect.new()
		rect.texture = img
		rect.expand = true
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		rect.rect_min_size = Vector2(100, 100)
		sequence_container.add_child(rect)

func _on_room_pressed():
	AnimationController.status = "MainGame"
	get_tree().change_scene("res://src/MainScreen.tscn")
