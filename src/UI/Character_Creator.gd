# script.gd (Anexado ao nó que contém os botões e o sprite)

extends Control # Ou Node2D, dependendo do seu nó base

# Declare a variável, mas não a inicialize aqui no Godot 3.x
var personagem_sprite

var sprite_boy_a = preload("res://assets/Sprites-v3/boy-a/boy-a-r1-m0.png")
var sprite_girl_a = preload("res://assets/Sprites-v3/girl-a/girl-a-r1-m0.png")
var sprite_boy_b = preload("res://assets/Sprites-v3/boy-b/boy-b-r1-m0.png")
var sprite_girl_b = preload("res://assets/Sprites-v3/girl-b/girl-b-r1-m0.png")

var cabelo_girl_A = preload("res://assets/Character_Creator/cabelo_girl_A.png")
var cabelo_girl_A_on = preload("res://assets/Character_Creator/cabelo_girl_A_on.png")
var cabelo_girl_B = preload("res://assets/Character_Creator/cabelo_girl_B.png")
var cabelo_girl_B_on = preload("res://assets/Character_Creator/cabelo_girl_B_on.png")
var cabelo_boy_A = preload("res://assets/Character_Creator/cabelo_boy_A.png")
var cabelo_boy_A_on = preload("res://assets/Character_Creator/cabelo_boy_A_on.png")
var cabelo_boy_B = preload("res://assets/Character_Creator/cabelo_boy_B.png")
var cabelo_boy_B_on = preload("res://assets/Character_Creator/cabelo_boy_B_on.png")


func _ready():
	# Inicialize a variável 'personagem_sprite' usando get_node()
	personagem_sprite = get_node("Sprite") 
	get_node("btn_cor_1").pressed = true
	get_node("btn_boy").pressed = true
	get_node("cabelo_B").pressed = true
	
	

func _set_skin_color(color_hex: String):
	# Converte a string hexadecimal para um obj Color do Godot
	var new_color = Color(color_hex)
	
	var shader_material = personagem_sprite.material as ShaderMaterial
	# Define a nova cor de pele no shader
	shader_material.set_shader_param("nova_cor_pele", new_color)

# Métodos que serão chamados quando os botões forem clicados
func _on_btn_cor_1_pressed():
	_set_skin_color("#f5e3d2")
	get_node("btn_cor_1").pressed = true
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_2_pressed():
	_set_skin_color("#f0ccbb")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = true
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_3_pressed():
	_set_skin_color("#e6b489")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = true
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_4_pressed():
	_set_skin_color("#ba8f67")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = true
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_5_pressed():
	_set_skin_color("#7f5c3e")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = true
	get_node("btn_cor_6").pressed = false

func _on_btn_cor_6_pressed():
	_set_skin_color("#644931")
	get_node("btn_cor_1").pressed = false
	get_node("btn_cor_2").pressed = false
	get_node("btn_cor_3").pressed = false
	get_node("btn_cor_4").pressed = false
	get_node("btn_cor_5").pressed = false
	get_node("btn_cor_6").pressed = true



func _on_btn_boy_pressed():
	if	$cabelo_A.pressed:
		$Sprite.texture = sprite_boy_a
	else:
		$Sprite.texture = sprite_boy_b
		
	$cabelo_A.texture_normal = cabelo_boy_A
	$cabelo_A.texture_pressed = cabelo_boy_A_on
	$cabelo_B.texture_normal = cabelo_boy_B
	$cabelo_B.texture_pressed = cabelo_boy_B_on
	get_node("btn_girl").pressed = false

func _on_btn_girl_pressed():
	if	$cabelo_A.pressed:
		$Sprite.texture = sprite_girl_a
	else:
		$Sprite.texture = sprite_girl_b
		
	$cabelo_A.texture_normal = cabelo_girl_A
	$cabelo_A.texture_pressed = cabelo_girl_A_on
	$cabelo_B.texture_normal = cabelo_girl_B
	$cabelo_B.texture_pressed = cabelo_girl_B_on
	get_node("btn_boy").pressed = false



func _on_cabelo_A_pressed():
	get_node("cabelo_A").pressed = true
	get_node("cabelo_B").pressed = false
	
	if $btn_boy.pressed:
		$Sprite.texture = sprite_boy_a
	else:
		$Sprite.texture = sprite_girl_a


func _on_cabelo_B_pressed():
	get_node("cabelo_A").pressed = false
	get_node("cabelo_B").pressed = true
	
	if $btn_boy.pressed:
		$Sprite.texture = sprite_boy_b
	else:
		$Sprite.texture = sprite_girl_b


func _on_ConfirmButton_pressed():
	# Definir cabelo
	if get_node("cabelo_A").pressed:
		NewCharData.cabelo = "a"
	else:
		NewCharData.cabelo = "b"
	
	#Definir gênero
	if get_node("btn_boy").pressed:
		NewCharData.genero = "boy"
	else:
		NewCharData.genero = "girl"

	# Definir cor de pele
	if get_node("btn_cor_1").pressed:
		NewCharData.cor_pele = "#f5e3d2"
	elif get_node("btn_cor_2").pressed:
		NewCharData.cor_pele = "#f0ccbb"
	elif get_node("btn_cor_3").pressed:
		NewCharData.cor_pele = "#e6b489"
	elif get_node("btn_cor_4").pressed:
		NewCharData.cor_pele = "#ba8f67"
	elif get_node("btn_cor_5").pressed:
		NewCharData.cor_pele = "#7f5c3e"
	elif get_node("btn_cor_6").pressed:
		NewCharData.cor_pele = "#644931"
		
	get_tree().change_scene("res://src/UI/Character_Clothes_Selector.tscn")
		

