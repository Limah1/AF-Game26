extends Node

var chances = 15
var goals = [8,8,8] #posicao 0 para metas do RiceAndBean, posicao 1 para watermelon e 3 para juice 

var last_fruit_is_harmful = false

var last_result_won = true

var sound: AudioStreamPlayer2D

var checked = true

var tutorial = false

var tilestodestroy = []

var fruit1_reference = ""
var fruit2_reference = ""
var fruit3_reference = ""
var harmful_fruit_reference = ""

var score1 = 0
var score2 = 0
var score3 = 0

var totalScore = 0
var goalScore = 60

func score(fruit, points, tile):
	print(fruit)
	
	if ((fruit == fruit1_reference 
		or fruit == fruit2_reference 
		or fruit == fruit3_reference) 
		and (totalScore < goalScore)):
		
		totalScore += points
	
	if fruit == fruit1_reference and score1 < goals[0]:
		score1 += points
		last_fruit_is_harmful = false
	if fruit == fruit2_reference and score2 < goals[1]:
		score2 += points
		last_fruit_is_harmful = false
	if fruit == fruit3_reference and score3 < goals[2]:
		score3 += points
		last_fruit_is_harmful = false

	if fruit == harmful_fruit_reference:
		last_fruit_is_harmful = true
		
		totalScore -= 1
		if score1 >= score2 and score1 >= score3:
			if score1 > 0:
				score1 -= points
		elif score2 >= score1 and score2 >= score3:
			if score2 > 0:
				score2 -= points
		elif score3 >= score1 and score3 >= score2:
			if score3 > 0:
				score3 -= points

func set_reference(good_fruits, harmful_fruit):
	fruit1_reference = good_fruits[0]
	fruit2_reference = good_fruits[1]
	fruit3_reference = good_fruits[2]
	harmful_fruit_reference = harmful_fruit

func add_tile_to_destroy(tile):
	if tilestodestroy.has(tile):
		return
	tilestodestroy.append(tile)

func ResetTiles():
	tilestodestroy = []

func reset_all():
	score1 = 0
	score2 = 0
	score3 = 0

	totalScore = 0
	last_result_won = true

	ResetTiles()

func DestroyTiles():
	if(tilestodestroy.empty()):
		return
	for tile in tilestodestroy:
		tile.score(1)
	#sound.play()
	checked = true
	ResetTiles()
	
