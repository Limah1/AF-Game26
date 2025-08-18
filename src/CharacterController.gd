extends Node

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

func start():	
	#Preenche as variáveis de criação de personagem nova
	cabelo = NewCharData.cabelo
	genero = NewCharData.genero
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
	_update_character_visuals()
	print("CharacterController inicializado com sucesso!")

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
	
	var pathN = "res://assets/Sprites-v3/"
	var pathBath = "res://assets/Sprites-v3/"
	var pathD = "res://assets/Sprites-v3/"
	print("genero A =", genero)
	if(genero == "boy"):
		print("genero =", genero)
		if (cabelo == "a"):
			pathN = str(pathN, "boy-a/boy-a")
			if (roupa == "r1"):
				pathN = str(pathN, "-r1")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
				
			elif (roupa == "r2"):
				pathN = str(pathN, "-r2")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
			
			plataform.sleeping = load(str(pathD, "boy-a/boy-a-dormindo.png"))	
		
		elif (cabelo == "b"):
			pathN = str(pathN, "boy-b/boy-b")
			if (roupa == "r1"):
				pathN = str(pathN, "-r1")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
				
			elif (roupa == "r2"):
				pathN = str(pathN, "-r2")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
				
			plataform.sleeping = load(str(pathD, "boy-b/boy-b-dormindo.png"))
			
			
		plataform.idle_bath = load(str(pathBath, "boy-banho/boy-banho-m0.png")) 
		
		plataform.bath.w1 = load(str(pathBath, "boy-banho/boy-banho-m1.png"))
		plataform.bath.w2 = load(str(pathBath, "boy-banho/boy-banho-m2.png"))
		plataform.bath.w3 = load(str(pathBath, "boy-banho/boy-banho-m3.png"))
		plataform.bath.w4 = load(str(pathBath, "boy-banho/boy-banho-m4.png"))
		plataform.bath.w5 = load(str(pathBath, "boy-banho/boy-banho-m5.png"))

		plataform.idle_bath_dirty = load(str(pathBath, "boy-banho/boy-banho-m0-s.png"))
		
		plataform.bath_dirty.w1 = load(str(pathBath, "boy-banho/boy-banho-m1-s.png"))
		plataform.bath_dirty.w2 = load(str(pathBath, "boy-banho/boy-banho-m2-s.png"))
		plataform.bath_dirty.w3 = load(str(pathBath, "boy-banho/boy-banho-m3-s.png"))
		plataform.bath_dirty.w4 = load(str(pathBath, "boy-banho/boy-banho-m4-s.png"))
		plataform.bath_dirty.w5 = load(str(pathBath, "boy-banho/boy-banho-m5-s.png"))
	
				
	elif(genero == "girl"):
		print("genero =", genero)
		if (cabelo == "a"):
			pathN = str(pathN, "girl-a/girl-a")
			if (roupa == "r1"):
				pathN = str(pathN, "-r1")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
				
			elif (roupa == "r2"):
				pathN = str(pathN, "-r2")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
				
			plataform.sleeping = load(str(pathD, "girl-a/girl-a-dormindo.png"))
		elif (cabelo == "b"):
			pathN = str(pathN, "girl-b/girl-b")
			if (roupa == "r1"):
				pathN = str(pathN, "-r1")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
				
			elif (roupa == "r2"):
				pathN = str(pathN, "-r2")
				plataform.idle = load(str(pathN, "-m0.png"))
				plataform.walk.w1 = load(str(pathN, "-m1.png"))
				plataform.walk.w2 = load(str(pathN, "-m2.png"))
				plataform.walk.w3 = load(str(pathN, "-m3.png"))
				plataform.walk.w4 = load(str(pathN, "-m4.png"))
				plataform.walk.w5 = load(str(pathN, "-m5.png"))
				print(str(pathN, "-m5.png"))
				
				plataform.idle_dirty = load(str(pathN, "-m0-s.png"))
				plataform.walk_dirty.w1 = load(str(pathN, "-m1-s.png"))
				plataform.walk_dirty.w2 = load(str(pathN, "-m2-s.png"))
				plataform.walk_dirty.w3 = load(str(pathN, "-m3-s.png"))
				plataform.walk_dirty.w4 = load(str(pathN, "-m4-s.png"))
				plataform.walk_dirty.w5 = load(str(pathN, "-m5-s.png"))
				print(str(pathN, "-m4-s.png"))
				
				plataform.seated = load(str(pathN, "-sentado.png"))
				plataform.seated_dirty = load(str(pathN, "-sentado-s.png"))
			plataform.sleeping = load(str(pathD, "girl-b/girl-b-dormindo.png"))
			
	
		plataform.idle_bath = load(str(pathBath, "girl-banho/girl-banho-m0.png")) 
		
		plataform.bath.w1 = load(str(pathBath, "girl-banho/girl-banho-m1.png"))
		plataform.bath.w2 = load(str(pathBath, "girl-banho/girl-banho-m2.png"))
		plataform.bath.w3 = load(str(pathBath, "girl-banho/girl-banho-m3.png"))
		plataform.bath.w4 = load(str(pathBath, "girl-banho/girl-banho-m4.png"))
		plataform.bath.w5 = load(str(pathBath, "girl-banho/girl-banho-m5.png"))

		plataform.idle_bath_dirty = load(str(pathBath, "girl-banho/girl-banho-m0-s.png"))
		
		plataform.bath_dirty.w1 = load(str(pathBath, "girl-banho/girl-banho-m1-s.png"))
		plataform.bath_dirty.w2 = load(str(pathBath, "girl-banho/girl-banho-m2-s.png"))
		plataform.bath_dirty.w3 = load(str(pathBath, "girl-banho/girl-banho-m3-s.png"))
		plataform.bath_dirty.w4 = load(str(pathBath, "girl-banho/girl-banho-m4-s.png"))
		plataform.bath_dirty.w5 = load(str(pathBath, "girl-banho/girl-banho-m5-s.png"))
	
	"""
	var path = "res://assets/All_Character_Sprites/"
	
	if(boyorgirl == "Boy"):
		path = str(path, "Boy/")
		path = str(path, etnia, "/")
		if (glass == false):
			
			var walkpath = str(path, "Walk/boy-", str(variation))
			
			plataform.idle = load(str(walkpath, "/boy-", str(variation) ,"-1.png"))
			print(str(walkpath, "/boy-", str(variation) ,"-1.png"))
			
			plataform.seated = load(str(path, "boy-", variation, "-sentado/boy-", variation, "-sentado.png"))
			plataform.seated_dirty = load(str(path, "boy-", variation, "-sentado/boy-", variation, "-sujo-sentado.png"))
			
			plataform.walk.w1 = load(str(walkpath, "/boy-", str(variation) ,"-2.png"))
			plataform.walk.w2 = load(str(walkpath, "/boy-", str(variation) ,"-3.png"))
			plataform.walk.w3 = load(str(walkpath, "/boy-", str(variation) ,"-4.png")) 
			plataform.walk.w4 = load(str(walkpath, "/boy-", str(variation) ,"-5.png"))
			plataform.walk.w5 = load(str(walkpath, "/boy-", str(variation) ,"-6.png"))
			
			walkpath = str(walkpath, "-sujo")
			
			plataform.idle_dirty =  load(str(walkpath, "/boy-", str(variation) ,"-1.png"))
			plataform.walk_dirty.w1 = load(str(walkpath, "/boy-", str(variation) ,"-2.png")) 
			plataform.walk_dirty.w2 = load(str(walkpath, "/boy-", str(variation) ,"-3.png")) 
			plataform.walk_dirty.w3 = load(str(walkpath, "/boy-", str(variation) ,"-4.png"))
			plataform.walk_dirty.w4 = load(str(walkpath, "/boy-", str(variation) ,"-5.png")) 
			plataform.walk_dirty.w5 = load(str(walkpath, "/boy-", str(variation) ,"-6.png"))
			
			print(str(walkpath, "/boy-", str(variation) ,"-6.png"))
			
		elif (glass == true):
			var walkpath = str(path, "Walk/boy-", str(variation))
			
			plataform.idle = load(str(walkpath, "-oculos/boy-", str(variation) ,"-1.png"))
			plataform.walk.w1 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-2.png"))
			plataform.walk.w2 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-3.png"))
			plataform.walk.w3 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-4.png")) 
			plataform.walk.w4 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-5.png"))
			plataform.walk.w5 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-6.png"))
			
			walkpath = str(walkpath, "-sujo")
			
			plataform.seated = load(str(path, "boy-", variation, "-sentado/boy-", variation, "-sentado-oculos.png"))
			plataform.seated_dirty = load(str(path, "boy-", variation, "-sentado/boy-", variation, "-sujo-sentado-oculos.png"))
			
			
			plataform.idle_dirty =  load(str(walkpath, "-oculos/boy-", str(variation) ,"-1.png"))
			plataform.walk_dirty.w1 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-2.png")) 
			plataform.walk_dirty.w2 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-3.png")) 
			plataform.walk_dirty.w3 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-4.png"))
			plataform.walk_dirty.w4 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-5.png")) 
			plataform.walk_dirty.w5 = load(str(walkpath, "-oculos/boy-", str(variation) ,"-6.png"))
		
		plataform.idle_bath = load(str(path, "boy-banho/boy-banho-1.png"))
		
		plataform.bath.w1 = load(str(path, "boy-banho/boy-banho-2.png"))
		plataform.bath.w2 = load(str(path, "boy-banho/boy-banho-3.png"))
		plataform.bath.w3 = load(str(path, "boy-banho/boy-banho-4.png"))
		plataform.bath.w4 = load(str(path, "boy-banho/boy-banho-5.png"))
		plataform.bath.w5 = load(str(path, "boy-banho/boy-banho-6.png"))

		plataform.idle_bath_dirty = load(str(path, "boy-banho-sujo/boy-banho-1.png"))
		
		plataform.bath_dirty.w1 = load(str(path, "boy-banho-sujo/boy-banho-2.png"))
		plataform.bath_dirty.w2 = load(str(path, "boy-banho-sujo/boy-banho-3.png"))
		plataform.bath_dirty.w3 = load(str(path, "boy-banho-sujo/boy-banho-4.png"))
		plataform.bath_dirty.w4 = load(str(path, "boy-banho-sujo/boy-banho-5.png"))
		plataform.bath_dirty.w5 = load(str(path, "boy-banho-sujo/boy-banho-6.png"))
		
		plataform.sleeping = load(str(path, "boy-dormindo/boy-", str(variation) ,"-dormindo.png"))
	elif(boyorgirl == "Girl"):
		path = str(path, "Girl/")
		path = str(path, etnia, "/")
		
		if (glass == false):
			var walkpath = str(path, "Walk/girl-", str(variation))
			
			plataform.seated = load(str(path, "girl-", variation, "-sentada/girl-", variation, "-sentada.png"))
			plataform.seated_dirty = load(str(path, "girl-", variation, "-sentada/girl-", variation, "-suja-sentada.png"))
			print(str(path, "girl-", variation, "-sentada/girl-", variation, "-suja-sentada.png"))
			
			
			plataform.idle = load(str(walkpath, "/girl-", str(variation) ,"-1.png"))
			plataform.walk.w1 = load(str(walkpath, "/girl-", str(variation) ,"-2.png"))
			plataform.walk.w2 = load(str(walkpath, "/girl-", str(variation) ,"-3.png"))
			plataform.walk.w3 = load(str(walkpath, "/girl-", str(variation) ,"-4.png")) 
			plataform.walk.w4 = load(str(walkpath, "/girl-", str(variation) ,"-5.png"))
			plataform.walk.w5 = load(str(walkpath, "/girl-", str(variation) ,"-6.png"))
			
			walkpath = str(walkpath, "-suja")
			
			plataform.idle_dirty =  load(str(walkpath, "/girl-", str(variation) ,"-1.png"))
			plataform.walk_dirty.w1 = load(str(walkpath, "/girl-", str(variation) ,"-2.png")) 
			plataform.walk_dirty.w2 = load(str(walkpath, "/girl-", str(variation) ,"-3.png")) 
			plataform.walk_dirty.w3 = load(str(walkpath, "/girl-", str(variation) ,"-4.png"))
			plataform.walk_dirty.w4 = load(str(walkpath, "/girl-", str(variation) ,"-5.png")) 
			plataform.walk_dirty.w5 = load(str(walkpath, "/girl-", str(variation) ,"-6.png"))
		elif (glass == true):
			var walkpath = str(path, "Walk/girl-", str(variation))
			
			plataform.seated = load(str(path, "girl-", variation, "-sentada/girl-", variation, "-sentada-oculos.png"))
			plataform.seated_dirty = load(str(path, "girl-", variation, "-sentada/girl-", variation, "-suja-sentada-oculos.png"))
			
			plataform.idle = load(str(walkpath, "-oculos/girl-", str(variation) ,"-1.png"))
			plataform.walk.w1 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-2.png"))
			plataform.walk.w2 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-3.png"))
			plataform.walk.w3 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-4.png")) 
			plataform.walk.w4 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-5.png"))
			plataform.walk.w5 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-6.png"))
			
			walkpath = str(walkpath, "-suja")
			
			plataform.idle_dirty =  load(str(walkpath, "-oculos/girl-", str(variation) ,"-1.png"))
			plataform.walk_dirty.w1 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-2.png")) 
			plataform.walk_dirty.w2 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-3.png")) 
			plataform.walk_dirty.w3 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-4.png"))
			plataform.walk_dirty.w4 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-5.png")) 
			plataform.walk_dirty.w5 = load(str(walkpath, "-oculos/girl-", str(variation) ,"-6.png"))
		
		plataform.idle_bath = load(str(path, "girl-banho/girl-banho-1.png"))
		
		plataform.bath.w1 = load(str(path, "girl-banho/girl-banho-2.png"))
		plataform.bath.w2 = load(str(path, "girl-banho/girl-banho-3.png"))
		plataform.bath.w3 = load(str(path, "girl-banho/girl-banho-4.png"))
		plataform.bath.w4 = load(str(path, "girl-banho/girl-banho-5.png"))
		plataform.bath.w5 = load(str(path, "girl-banho/girl-banho-6.png"))

		plataform.idle_bath_dirty = load(str(path, "girl-banho-sujo/girl-banho-1.png"))
		
		plataform.bath_dirty.w1 = load(str(path, "girl-banho-sujo/girl-banho-2.png"))
		plataform.bath_dirty.w2 = load(str(path, "girl-banho-sujo/girl-banho-3.png"))
		plataform.bath_dirty.w3 = load(str(path, "girl-banho-sujo/girl-banho-4.png"))
		plataform.bath_dirty.w4 = load(str(path, "girl-banho-sujo/girl-banho-5.png"))
		plataform.bath_dirty.w5 = load(str(path, "girl-banho-sujo/girl-banho-6.png"))
		
		plataform.sleeping = load(str(path, "girl-dormindo/girl-", str(variation) ,"-dormindo.png"))
	"""
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
func _update_character_visuals():
	# Verifique se o nó do sprite principal existe
	var personagem_sprite = get_node("Player/Player/player_sprites")
	if personagem_sprite == null:
		print("Erro: Nó 'player_sprites' não encontrado para atualizar. Variável 'personagem_sprite' não foi definida.")
		return
	
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
