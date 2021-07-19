extends Node2D

var heart = Resources.heart

func _ready():
	pass

func _process(delta):
	heart = Resources.heart
	if heart == 1:
		$heart1.visible = true
		$heart2.visible = false
		$heart3.visible = false
	elif heart == 2:
		$heart1.visible = true
		$heart2.visible = true
		$heart3.visible = false
	elif heart == 3:
		$heart1.visible = true
		$heart2.visible = true
		$heart3.visible = true
	else:
		$heart1.visible = false
		$heart2.visible = false
		$heart3.visible = false
	
func decrement():
	Resources.heart -= 1
func increment():
	Resources.heart += 1
