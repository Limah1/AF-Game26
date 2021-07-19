extends Node

var started = false

var max_higiene = 900
var max_bexiga = 900
var max_banheiro = 1800 # 15 minutos, mas sempre que beber agua, reduzirá 30 sec
var max_fome = 900 # 15 minutos
var max_diversao = 900 # 15 minutos
var max_energia = 1800 # 30 minutos

var higiene: float = 0
var bexiga: float = 0
var banheiro: float = 0
var fome: float = 0
var diversao: float = 0
var energia: float = 0

var wake_up = null
var bath = null

var fun = false
var sleeping = false
var eating = false
var bathing = false
var onbath = false
var soaked = false
var peeing = false

var painpaused = false
var inpain = false

var second = 0
var some_problem = ""

func _ready() -> void:
	add_to_group("Persist")
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta: float) -> void:
	if(!started):
		return
	
	higiene -= delta
	bexiga -= delta
	fome -= delta
	diversao -= delta
	energia -= delta
	
	banheiro = bexiga + higiene
	
	if( higiene <= 0 ):
		higiene = 0
	if( bexiga <= 0 ):
		bexiga = 0
	if( fome <= 0 ):
		fome = 0
	if( diversao <= 0 ):
		diversao = 0
	if( energia <= 0 ):
		energia = 0
	
	if(fun == true):
		diversao += 100 * delta
		
		if (diversao >= max_diversao):
			diversao = max_diversao
	
	if(sleeping == true):
		energia += 100 * delta
		
		if (energia >= max_energia):
			energia = max_energia
	
	if(eating == true):
		fome += 20 * delta
		
		if (fome >= max_fome):
			fome = max_fome
	
	if(peeing == true):
		bexiga += 85 * delta
		
		if (bexiga >= max_bexiga):
			bexiga = max_bexiga
			AnimationController.return_from_toilet()
			peeing = false
	
	random_pain(delta)

func go_to_bath(bathroom):
	bath = bathroom
	bathing = true

func _input(event):
	var key = event.as_text()
	
	if key == "Z":
		painpaused = !painpaused
	
	if key == "X" and !inpain:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var number = rng.randi_range(0, 2)
		
		var popup = load("res://src/UI/PopUpDor.tscn").instance()
		if(number == 0):
			popup.start("headache")
			some_problem = "headache"
		elif(number == 1):
			popup.start("fever")
			some_problem = "fever"
		elif(number == 2):
			popup.start("armPain")
			some_problem = "armPain"
		
		get_tree().paused = true
		get_tree().current_scene.add_child(popup)
	
	if key == "C":
		S_Conntroller.score1 = 30
		S_Conntroller.score2 = 30
		S_Conntroller.score3 = 30

func random_pain(delta):
	second += delta
	
	if(second >= 1 and !painpaused and !inpain):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var number = rng.randi_range(0, 10000) #escala de dor
		
		if(
			number >= 0 and 
			number <= 30 and
			NecessityBars.some_problem == "" and
			AnimationController.status != "DoiAqui" and 
			AnimationController.status != ""
		):
			rng.randomize()
			number = rng.randi_range(0, 2)
			
			var popup = load("res://src/UI/PopUpDor.tscn").instance()
			if(number == 0):
				popup.start("headache")
				some_problem = "headache"
			elif(number == 1):
				popup.start("fever")
				some_problem = "fever"
			elif(number == 2):
				popup.start("armPain")
				some_problem = "armPain"
			
			get_tree().paused = true
			get_tree().current_scene.add_child(popup)
		second = 0

func save():
	var save_dict = {
		"filename" : "NecessityManager",
		"higiene" : higiene,
		"bexiga": bexiga,
		"banheiro": banheiro,
		"fome" : fome,
		"diversao": diversao,
		"energia": energia
	}
	
	return save_dict
