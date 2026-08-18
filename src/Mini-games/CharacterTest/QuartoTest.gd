extends Control

onready var rig_sleep = $RigSleep
onready var btn_deitar = $Button

func _ready():
	# Configura cores para teste
	rig_sleep.set_skin_color(Color("#644931"))
	rig_sleep.set_hair_color(Color("#21b24b"))
	
	# Simula o autoload setando as texturas caso você teste direto essa cena
	# Aqui, passamos a "cabeça" como se fosse a textura de rosto dormindo
	var tex = load("res://assets/Character_Creator/modular/cabeca.png")
	rig_sleep.set_face_texture(tex)
	
	btn_deitar.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	if rig_sleep.state == 0:
		# Move para a "Cama" (posição do botão)
		rig_sleep.position = Vector2(1300, 480) # Em cima do botão verde
		rig_sleep.set_state(3) # Dormindo
		btn_deitar.text = "Levantar da Cama"
		$LabelDormir.text = "Dormindo"
		$LabelDormir.rect_position = Vector2(1250, 400)
	else:
		# Volta para a esquerda
		rig_sleep.position = Vector2(300, 500)
		rig_sleep.set_state(0) # Parado
		btn_deitar.text = "Cama (Deitar)"
		$LabelDormir.text = "Acordado"
		$LabelDormir.rect_position = Vector2(250, 200)
