extends Node

var max_life = 50
var current_life = max_life
var heart = 3
var km = 0.0
var score = 0 
var in_hole = false
var sunny = false

var power_watermelon = false
var watermelon_timer = 0
var power_melon = false
var power_orange = false
var orange_timer = 0
var power_strawberry = false

var dash_timer = 0

var parallax_speed = 1500
var parallax_speed_aux = parallax_speed

var weather = "Sunny" # Cloudy / Sunny / Rainy / Snowy
var acessory = "" # Umbrella / Coat

var acessory_not_founded = ""

func reset_resources():
	current_life = max_life
	heart = 3
	km = 0.0
	score = 0 
	in_hole = false
	
	sunny = false
	
	power_watermelon = false
	watermelon_timer = 0
	power_melon = false
	power_orange = false
	orange_timer = 0
	power_strawberry = false
	parallax_speed = parallax_speed_aux

func weather_randomize():
	var rng = RandomNumberGenerator.new()
	var weathers = ["Sunny", "Rainy" , "Snowy"]
	rng.randomize()
	
	var random_number = rng.randi_range(0, 2)
	#print(random_number)
	
	weather = weathers[random_number]

func equip_acessory(_acessory):
	if(acessory == _acessory):
		acessory = ""
		return
	
	acessory = _acessory
