extends CanvasLayer

var time = 0.0

func _ready():
	$bar.max_value = Resources.max_life
	$bar.value = Resources.current_life
	
func _process(delta):
	time += delta
	$Label.text = "Distância percorrida: "+ str(Resources.km) +" Km"
	if time > 3:
		if Resources.sunny:
			Resources.current_life -= 4
		else:
			Resources.current_life -= 2
		
		if Resources.power_orange:
			Resources.km += 2
		else:
			Resources.km += 1
		time = 0
		
	$bar.value = Resources.current_life
