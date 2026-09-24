extends Node

signal expression_changed(expression)
var expression = "default"

func set_expression(value: String) -> void:
	var next_expression = "default" if value == "" else value
	if expression == next_expression:
		return
	expression = next_expression
	emit_signal("expression_changed", expression)

#Codigo antigo
var boyorgirl = "Boy" # Boy or Girl
var etnia = "negro"#negro, pardo ou branco
var glass = false# True or False
var variation = 1 # 1 or 2

# Carregando variaveis novas
var cabelo = ""
var genero= ""
var cor_pele = ""
var roupa = ""
var cor_roupa_cima = ""
var cor_roupa_baixo = ""

var personagem_sprite: Sprite = null #11/08/25

var player_ref = null

var all_sprites = {
	plataform = {
		idle = null,
		idle_dirty = null,
		seated = null,
		seated_dirty = null,
		walk = {
			w1 = null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null
		},
		walk_dirty = {
			w1= null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null
		},
		sleeping = null,
		idle_bath = null,
		bath = {
			w1 = null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null,
		},
		idle_bath_dirty = null,
		bath_dirty = {
			w1 = null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null,
		}
	},
	match3 = {
		very_happy = null,
		happy = null,
		serious = null,
		sad = null,
		very_sad = null,
		win = null
	},
	hidratona = {
		run = {
			r1 = null,
			r2 = null,
			r3 = null,
			r4 = null,
			r5 = null,
			r6 = null,
			r7 = null
		},
		jump = {
			j1 = null,
			j2 = null
		},
		fall = null,
		squat = null,
		win = null,
		
		snow = {
			run = {
				r1 = null,
				r2 = null,
				r3 = null,
				r4 = null,
				r5 = null,
				r6 = null,
				r7 = null
			},
			jump = {
				j1 = null,
				j2 = null
			},
			fall = null,
			squat = null,
			win = null
		},
		
		rain = {
			run = {
				r1 = null,
				r2 = null,
				r3 = null,
				r4 = null,
				r5 = null,
				r6 = null,
				r7 = null
			},
			jump = {
				j1 = null,
				j2 = null
			},
			fall = null,
			squat = null,
			win = null
		},
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Persist")	
	#start() #11/08/25

func start(target_node = null):
	#Preenche as variáveis de criação de personagem nova
	cabelo = NewCharData.cabelo
	genero = NewCharData.genero
	boyorgirl = "Boy" if genero == "boy" else "Girl"
	cor_pele = NewCharData.cor_pele
	roupa = NewCharData.roupa
	cor_roupa_cima = NewCharData.cor_roupa_cima
	cor_roupa_baixo = NewCharData.cor_roupa_baixo

	#Imprime para confirmar que os valores foram transferidos
	print("Dados do personagem carregados no CharacterController:")
	print("Cabelo: ", cabelo)
	print("Gênero: ", genero)
	print("Cor de Pele: ", cor_pele)
	print("Roupa: ", roupa)
	print("Cor Roupa Cima: ", cor_roupa_cima)
	print("Cor Roupa Baixo: ", cor_roupa_baixo)
	
	all_sprites.plataform = Load_Plataform()
	all_sprites.match3 = Load_Match3()
	all_sprites.hidratona = Load_Hidratona()
	
	# 3. APÓS TUDO SER CARREGADO, APLICA AS ATUALIZAÇÕES VISUAIS
	_update_character_visuals(target_node)
	print("CharacterController inicializado com sucesso!")

func get_legacy_head_texture() -> Texture:
	var gender = "boy" if boyorgirl == "Boy" else "girl"
	var hair = cabelo if cabelo == "a" or cabelo == "b" else "a"
	return get_head_texture_for(gender, hair)

func get_expression_head_texture_for(gender: String, hair: String, requested_expression: String = "") -> Texture:
	var face = expression if requested_expression == "" else requested_expression
	var gender_folder = "Menino" if gender == "boy" else "Menina"
	var selected_hair = hair if hair == "a" or hair == "b" else "a"
	if face == "feliz":
		var happy_head = "res://assets/SpritesV4/Cabecas/%s/%s1.png" % [gender_folder, "boy" if gender == "boy" else "girl"]
		if ResourceLoader.exists(happy_head):
			return load(happy_head) as Texture
	# Asset convention: a-feliz.png, b-triste.png, etc. Missing art uses the base head.
	if face != "default":
		var path = "res://assets/SpritesV4/Cabecas/%s/%s-%s.png" % [gender_folder, selected_hair, face]
		if ResourceLoader.exists(path):
			return load(path) as Texture
	return get_head_texture_for(gender, selected_hair)

func get_head_texture_for(gender: String, hair: String, sleeping: bool = false) -> Texture:
	var gender_folder = "Menino" if gender == "boy" else "Menina"
	var head_name = ("boy" if gender == "boy" else "girl") + ("1" if hair == "a" else "2")
	return load("res://assets/SpritesV4/Cabecas/%s/%s.png" % [gender_folder, head_name]) as Texture

func get_legacy_head_source_skin_for(gender: String, hair: String) -> Color:
	# Current boy1/boy2/girl1/girl2 heads share this placeholder skin color.
	return Color(0.129412, 0.960784, 0.003922, 1.0)

func Load_Plataform():
	var plataform = {
		idle = null,
		idle_dirty = null,
		dirty = null, # se der merda, deleta
		seated = null,
		seated_dirty = null,
		walk = {
			w1 = null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null
		},
		walk_dirty = {
			w1= null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null
		},
		sleeping = null,
		idle_bath = null,
		bath = {
			w1 = null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null,
		},
		idle_bath_dirty = null,
		bath_dirty = {
			w1 = null,
			w2 = null,
			w3 = null,
			w4 = null,
			w5 = null,
		}
	}
	
	var gender_folder = "Menino" if genero == "boy" else "Menina"
	var variation_folder = "Variacao2" if roupa == "r2" else "Variacao1"
	var normal_path = "res://assets/SpritesV4/RoupasNormais/%s/%s/" % [gender_folder, variation_folder]
	plataform.idle = load(normal_path + "m0.png")
	plataform.idle_dirty = load(normal_path + "m0-s.png")
	plataform.seated = load(normal_path + "sentado.png")
	plataform.seated_dirty = load(normal_path + "sentado-s.png")
	for frame in range(1, 6):
		var key = "w" + str(frame)
		plataform.walk[key] = load(normal_path + "m%d.png" % frame)
		plataform.walk_dirty[key] = load(normal_path + "m%d-s.png" % frame)

	var hair = cabelo if cabelo == "a" or cabelo == "b" else "a"
	plataform.sleeping = load("res://assets/SpritesV4/RoupasNormais/%s/dormindo-%s.png" % [gender_folder, hair])

	var bath_prefix = "boy" if genero == "boy" else "girl"
	var bath_path = "res://assets/Sprites-v3/%s-banho/%s-banho-" % [bath_prefix, bath_prefix]
	plataform.idle_bath = load(bath_path + "m0.png")
	plataform.idle_bath_dirty = load(bath_path + "m0-s.png")
	for bath_frame in range(1, 6):
		var bath_key = "w" + str(bath_frame)
		plataform.bath[bath_key] = load(bath_path + "m%d.png" % bath_frame)
		plataform.bath_dirty[bath_key] = load(bath_path + "m%d-s.png" % bath_frame)
	return plataform

func Load_Match3():
	var match3 = {
		very_happy = null,
		happy = null,
		serious = null,
		sad = null,
		very_sad = null,
		win = null
	}
	
	if(genero == "boy"):
		if(cabelo == "a"):
			match3.very_happy = load("res://assets/Match-3/sprites_novo/personagem/boy-a-match3-mto-feliz.png")
			match3.happy = load("res://assets/Match-3/sprites_novo/personagem/boy-a-match3-feliz.png")
			match3.serious = load("res://assets/Match-3/sprites_novo/personagem/boy-a-match3-serio.png")
			match3.sad = load("res://assets/Match-3/sprites_novo/personagem/boy-a-match3-triste.png")
			match3.very_sad = load("res://assets/Match-3/sprites_novo/personagem/boy-a-match3-mto-triste.png")
			match3.win = load("res://assets/Match-3/sprites_novo/personagem/boy-a-match3-mto-feliz-comemora.png")
		elif(cabelo == "b"):
			match3.very_happy = load("res://assets/Match-3/sprites_novo/personagem/boy-b-match3-mto-feliz.png")
			match3.happy = load("res://assets/Match-3/sprites_novo/personagem/boy-b-match3-feliz.png")
			match3.serious = load("res://assets/Match-3/sprites_novo/personagem/boy-b-match3-serio.png")
			match3.sad = load("res://assets/Match-3/sprites_novo/personagem/boy-b-match3-triste.png")
			match3.very_sad = load("res://assets/Match-3/sprites_novo/personagem/boy-b-match3-mto-triste.png")
			match3.win = load("res://assets/Match-3/sprites_novo/personagem/boy-b-match3-mto-feliz-comemora.png")
	elif (genero == "girl"):
		if(cabelo == "a"):
			match3.very_happy = load("res://assets/Match-3/sprites_novo/personagem/girl-a-match3-mto-feliz.png")
			match3.happy = load("res://assets/Match-3/sprites_novo/personagem/girl-a-match3-feliz.png")
			match3.serious = load("res://assets/Match-3/sprites_novo/personagem/girl-a-match3-serio.png")
			match3.sad = load("res://assets/Match-3/sprites_novo/personagem/girl-a-match3-triste.png")
			match3.very_sad = load("res://assets/Match-3/sprites_novo/personagem/girl-a-match3-mto-triste.png")
			match3.win = load("res://assets/Match-3/sprites_novo/personagem/girl-a-match3-mto-feliz-comemora.png")
		elif(cabelo == "b"):
			match3.very_happy = load("res://assets/Match-3/sprites_novo/personagem/girl-b-match3-mto-feliz.png")
			match3.happy = load("res://assets/Match-3/sprites_novo/personagem/girl-b-match3-feliz.png")
			match3.serious = load("res://assets/Match-3/sprites_novo/personagem/girl-b-match3-serio.png")
			match3.sad = load("res://assets/Match-3/sprites_novo/personagem/girl-b-match3-triste.png")
			match3.very_sad = load("res://assets/Match-3/sprites_novo/personagem/girl-b-match3-mto-triste.png")
			match3.win = load("res://assets/Match-3/sprites_novo/personagem/girl-b-match3-mto-feliz-comemora.png")
	
	"""
	if(boyorgirl == "Boy"):
		match3.very_happy = load("res://assets/All_Character_Sprites/Boy/match-3-BOY/boy-muito-feliz.png")
		match3.happy = load("res://assets/All_Character_Sprites/Boy/match-3-BOY/boy-alegre.png")
		match3.serious = load("res://assets/All_Character_Sprites/Boy/match-3-BOY/boy-serio.png")
		match3.sad = load("res://assets/All_Character_Sprites/Boy/match-3-BOY/boy-triste.png")
		match3.very_sad = load("res://assets/All_Character_Sprites/Boy/match-3-BOY/boy-muito-triste.png")
		match3.win = load("res://assets/All_Character_Sprites/Boy/match-3-BOY/boy-win.png")
	elif(boyorgirl == "Girl"):
		match3.very_happy = load("res://assets/All_Character_Sprites/Girl/match-3-GIRL/girl-muito-feliz.png")
		match3.happy = load("res://assets/All_Character_Sprites/Girl/match-3-GIRL/girl-alegre.png")
		match3.serious = load("res://assets/All_Character_Sprites/Girl/match-3-GIRL/girl-seria.png")
		match3.sad = load("res://assets/All_Character_Sprites/Girl/match-3-GIRL/girl-triste.png")
		match3.very_sad = load("res://assets/All_Character_Sprites/Girl/match-3-GIRL/girl-muito-triste.png")
		match3.win = load("res://assets/All_Character_Sprites/Girl/match-3-GIRL/girl-win.png")
	"""
	return match3

func Load_Hidratona():
	var hidratona = {
		run = {
			r1 = null,
			r2 = null,
			r3 = null,
			r4 = null,
			r5 = null,
			r6 = null,
			r7 = null
		},
		jump = {
			j1 = null,
			j2 = null
		},
		fall = null,
		squat = null,
		win = null,
		
		snow = {
			run = {
				r1 = null,
				r2 = null,
				r3 = null,
				r4 = null,
				r5 = null,
				r6 = null,
				r7 = null
			},
			jump = {
				j1 = null,
				j2 = null
			},
			fall = null,
			squat = null,
			win = null
		},
		
		rain = {
			run = {
				r1 = null,
				r2 = null,
				r3 = null,
				r4 = null,
				r5 = null,
				r6 = null,
				r7 = null
			},
			jump = {
				j1 = null,
				j2 = null
			},
			fall = null,
			squat = null,
			win = null
		},
	}
	
	var path = "res://assets/All_Character_Sprites/"
	
	if(boyorgirl == "Boy"):
		path = str(path, "Boy/", etnia,"/hidratona-BOY/")

		hidratona.run.r1 = load(str(path, "correr-1.png"))
		hidratona.run.r2 = load(str(path, "correr-2.png"))
		hidratona.run.r3 = load(str(path, "correr-3.png"))
		hidratona.run.r4 = load(str(path, "correr-4.png"))
		hidratona.run.r5 = load(str(path, "correr-5.png"))
		hidratona.run.r6 = load(str(path, "correr-6.png"))
		hidratona.run.r7 = load(str(path, "correr-7.png"))
		
		hidratona.jump.j1 = load(str(path, "pular-1.png"))
		hidratona.jump.j2 = load(str(path, "pular-2.png"))
		
		hidratona.fall = load(str(path, "caindo-buraco.png"))
		hidratona.squat = load(str(path, "agachar.png"))
		hidratona.win = load(str(path, "boy-win.png"))
		
		#rain
		hidratona.rain.run.r1 = load(str(path, "rain/rc_1.png"))
		hidratona.rain.run.r2 = load(str(path, "rain/rc_2.png"))
		hidratona.rain.run.r3 = load(str(path, "rain/rc_3.png"))
		hidratona.rain.run.r4 = load(str(path, "rain/rc_4.png"))
		hidratona.rain.run.r5 = load(str(path, "rain/rc_5.png"))
		hidratona.rain.run.r6 = load(str(path, "rain/rc_6.png"))
		hidratona.rain.run.r7 = load(str(path, "rain/rc_7.png"))
		
		hidratona.rain.jump.j1 = load(str(path, "rain/rc_j.png"))
		hidratona.rain.jump.j2 = load(str(path, "rain/rc_d.png"))
		
		hidratona.rain.fall = load(str(path, "rain/rc_fall.png"))
		hidratona.rain.squat = load(str(path, "rain/rc_squat.png"))
		hidratona.rain.win = load(str(path, "rain/rc_win.png"))
		
		#snow
		hidratona.snow.run.r1 = load(str(path, "snow/rs_1.png"))
		hidratona.snow.run.r2 = load(str(path, "snow/rs_2.png"))
		hidratona.snow.run.r3 = load(str(path, "snow/rs_3.png"))
		hidratona.snow.run.r4 = load(str(path, "snow/rs_4.png"))
		hidratona.snow.run.r5 = load(str(path, "snow/rs_5.png"))
		hidratona.snow.run.r6 = load(str(path, "snow/rs_6.png"))
		hidratona.snow.run.r7 = load(str(path, "snow/rs_7.png"))
		
		hidratona.snow.jump.j1 = load(str(path, "snow/rs_j.png"))
		hidratona.snow.jump.j2 = load(str(path, "snow/rs_d.png"))
		
		hidratona.snow.fall = load(str(path, "snow/rs_fall.png"))
		hidratona.snow.squat = load(str(path, "snow/rs_squat.png"))
		hidratona.snow.win = load(str(path, "snow/rs_win.png"))
		
	elif(boyorgirl == "Girl"):
		path = str(path, "Girl/", etnia,"/hidratona-GIRL/")
		
		hidratona.run.r1 = load(str(path, "correr-1-girl.png"))
		hidratona.run.r2 = load(str(path, "correr-2-girl.png"))
		hidratona.run.r3 = load(str(path, "correr-3-girl.png"))
		hidratona.run.r4 = load(str(path, "correr-4-girl.png"))
		hidratona.run.r5 = load(str(path, "correr-5-girl.png"))
		hidratona.run.r6 = load(str(path, "correr-6-girl.png"))
		hidratona.run.r7 = load(str(path, "correr-7-girl.png"))
		
		hidratona.jump.j1 = load(str(path, "pular-1-girl.png"))
		hidratona.jump.j2 = load(str(path, "pular-2-girl.png"))
		
		hidratona.fall = load(str(path, "cair-buraco-girl.png"))
		hidratona.squat = load(str(path, "agachar-girl.png"))
		hidratona.win = load(str(path, "girl-win.png"))
		
		#rain
		hidratona.rain.run.r1 = load(str(path, "rain/rc_1.png"))
		hidratona.rain.run.r2 = load(str(path, "rain/rc_2.png"))
		hidratona.rain.run.r3 = load(str(path, "rain/rc_3.png"))
		hidratona.rain.run.r4 = load(str(path, "rain/rc_4.png"))
		hidratona.rain.run.r5 = load(str(path, "rain/rc_5.png"))
		hidratona.rain.run.r6 = load(str(path, "rain/rc_6.png"))
		hidratona.rain.run.r7 = load(str(path, "rain/rc_7.png"))
		
		hidratona.rain.jump.j1 = load(str(path, "rain/rc_j.png"))
		hidratona.rain.jump.j2 = load(str(path, "rain/rc_d.png"))
		
		hidratona.rain.fall = load(str(path, "rain/rc_fall.png"))
		hidratona.rain.squat = load(str(path, "rain/rc_squat.png"))
		hidratona.rain.win = load(str(path, "rain/rc_win.png"))
		
		#snow
		hidratona.snow.run.r1 = load(str(path, "snow/rs_1.png"))
		hidratona.snow.run.r2 = load(str(path, "snow/rs_2.png"))
		hidratona.snow.run.r3 = load(str(path, "snow/rs_3.png"))
		hidratona.snow.run.r4 = load(str(path, "snow/rs_4.png"))
		hidratona.snow.run.r5 = load(str(path, "snow/rs_5.png"))
		hidratona.snow.run.r6 = load(str(path, "snow/rs_6.png"))
		hidratona.snow.run.r7 = load(str(path, "snow/rs_7.png"))
			
		hidratona.snow.jump.j1 = load(str(path, "snow/rs_j.png"))
		hidratona.snow.jump.j2 = load(str(path, "snow/rs_d.png"))
		
		hidratona.snow.fall = load(str(path, "snow/rs_fall.png"))
		hidratona.snow.squat = load(str(path, "snow/rs_squat.png"))
		hidratona.snow.win = load(str(path, "snow/rs_win.png"))
		
	return hidratona

func is_playing():
	if(!player_ref || !is_instance_valid(player_ref)):
		return false
	
	return player_ref.is_playing()

func save():
	var save_dict = {
		"filename" : "CharacterController",
		"boyorgirl" : boyorgirl,
		"glass": glass,
		"variation": variation
	}
	
	return save_dict

#11/08/25
func _update_character_visuals(target_node = null):
	# Descobre o nó do sprite do personagem a atualizar.
	# CharacterController é um autoload e não tem "Player/Player/player_sprites"
	# como filho seu, então o nó real precisa ser localizado na cena ativa
	# (ou recebido explicitamente via target_node / personagem_sprite).
	var sprite_node = target_node
	if sprite_node == null:
		sprite_node = personagem_sprite
	if sprite_node == null:
		var current_scene = get_tree().current_scene
		if current_scene and current_scene.has_node("Player/Player/player_sprites"):
			sprite_node = current_scene.get_node("Player/Player/player_sprites")

	if sprite_node == null or not is_instance_valid(sprite_node):
		# Não é um erro fatal. O start() pode ser chamado antes do boneco existir na cena.
		# print("Aviso: Sprite do jogador não está na tela. Cores serão aplicadas depois.")
		return
	# Some legacy scenes register the player_sprites container instead of an
	# actual Sprite. Resolve the idle child before assigning texture/material.
	if not (sprite_node is Sprite) and sprite_node.has_node("idle"):
		sprite_node = sprite_node.get_node("idle")
	if not (sprite_node is Sprite):
		return
	var personagem_sprite = sprite_node

	# 1. Aplica a textura inicial 
	if all_sprites.plataform.idle:
		personagem_sprite.texture = all_sprites.plataform.idle
	else:
		print("Aviso: A textura 'idle' não foi carregada corretamente.")

	# 2. Redimensiona o sprite para o tamanho correto (ver se precisa dps)
	#var escala_redimensionada = 1.0 / 7.0
	#personagem_sprite.scale = Vector2(escala_redimensionada, escala_redimensionada)

	# 3. Aplica os shaders
	var new_color_pele = Color(cor_pele)
	var new_color_cima = Color(cor_roupa_cima)
	var new_color_baixo = Color(cor_roupa_baixo)
	
	if personagem_sprite.material:
		var shader_material = personagem_sprite.material as ShaderMaterial
		if shader_material:
			shader_material.set_shader_param("nova_cor_pele", new_color_pele)
			shader_material.set_shader_param("nova_cor_camisa", new_color_cima)
			shader_material.set_shader_param("nova_cor_calca", new_color_baixo)
