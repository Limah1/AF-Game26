extends Node

var boyorgirl = "Boy" # Boy or Girl
var etnia = "branco"#negro, pardo ou branco
var glass = false# True or False
var variation = 1 # 1 or 2

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
	start()

func start():
	all_sprites.plataform = Load_Plataform()
	all_sprites.match3 = Load_Match3()
	all_sprites.hidratona = Load_Hidratona()

func Load_Plataform():
	var plataform = {
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
	}
	
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
