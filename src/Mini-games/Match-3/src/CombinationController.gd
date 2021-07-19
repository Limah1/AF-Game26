extends Node

var started = false

var center
var score_t = []
var score_r = []
var score_l = []
var score_b = []


func score():
	var score = 1
	#Score onde faz um +
	if(score_t.size() >= 1 && score_b.size() >= 1 && score_l.size() >= 1 && score_r.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)

	#Score onde faz um T e mais um adicional
	if(score_t.size() >= 1 && score_b.size() >= 2 && score_l.size() >= 2 && score_r.size() >= 2):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	if(score_t.size() >= 2 && score_b.size() >= 1 && score_l.size() >= 2 && score_r.size() >= 2):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	if(score_t.size() >= 2 && score_b.size() >= 2 && score_l.size() >= 1 && score_r.size() >= 2):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	if(score_t.size() >= 2 && score_b.size() >= 2 && score_l.size() >= 2 && score_r.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)

	#Score onde a combinacao faz um L + 1 adicional de cada lado
	elif(score_t.size() >= 2 && score_l.size() >= 2 && score_b.size() >= 1 && score_r.size() >= 1):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_t.size() >= 2 && score_r.size() >= 2 && score_b.size() >= 1 && score_l.size() >= 1):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_l.size() >= 2 && score_t.size() >= 1 && score_r.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_r.size() >= 2 && score_l.size() >= 1 && score_t.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	
	#Score onde a combinacao faz um L + 1 adicional em um dos lados
	elif(score_t.size() >= 2 && score_l.size() >= 2 && score_r.size() >= 1):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_t.size() >= 2 && score_l.size() >= 2 && score_b.size() >= 1):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_t.size() >= 2 && score_r.size() >= 2 && score_b.size() >= 1):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_t.size() >= 2 && score_r.size() >= 2 && score_l.size() >= 1):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_l.size() >= 2 && score_t.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_l.size() >= 2 && score_r.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_r.size() >= 2 && score_t.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_r.size() >= 2 && score_l.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)

	#Score onde a combinacao faz um L
	elif(score_t.size() >= 2 && score_l.size() >= 2):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_t.size() >= 2 && score_r.size() >= 2):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_l.size() >= 2):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2 && score_r.size() >= 2):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	
	#Score de linha/coluna onde cada
	#lado tem pelo menos 1
	elif(score_t.size() >= 1 && score_b.size() >= 1):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_l.size() >= 1 && score_r.size() >= 1):
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)

	#Score de Linha/Coluna Individual
	elif(score_t.size() >= 2):
		for tile in score_t:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_r.size() >= 2):
		for tile in score_r:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_l.size() >= 2):
		for tile in score_l:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	elif(score_b.size() >= 2):
		for tile in score_b:
			S_Conntroller.add_tile_to_destroy(tile.fruit)
			score += 1
		S_Conntroller.add_tile_to_destroy(center.fruit)
	
	reset_score()
	
	return true if score >= 3 else false


func add_score(tile, dir):
	if(tile == center):
		return
	
	if(dir == "Top"):
		score_t.append(tile)
	elif(dir == "Right"):
		score_r.append(tile)
	elif(dir == "Left"):
		score_l.append(tile)
	elif(dir == "Bottom"):
		score_b.append(tile)
	else:
		return

func reset_score():
	center = null
	score_t = []
	score_r = []
	score_l = []
	score_b = []
