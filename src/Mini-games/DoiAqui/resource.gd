extends Node

var max_life = 10
var initialPain = 1
var gameTime = 0.0
var currentLife
var gender = "girl"

func set_gender(_gender):
	if(_gender == "Girl"):
		gender = "girl"
	elif(_gender == "Boy"):
		gender = "boy"

func resetVar():
	max_life = 10
	initialPain = 1
	gameTime = 0.0
	currentLife = 0
