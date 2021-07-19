extends Button

var fruit

func start_show(_fruit):
	fruit = _fruit
	
	$icon.scale.x = 0.7
	$icon.scale.y = 0.7
	
	$warning.visible = true
	$warning2.visible = false
	
	$Label.visible = true
	
	$Label.text = fruit.name
	$icon.texture = load(fruit.sprite)

func start_ongame(_fruit):
	fruit = _fruit
	
	#$blocked.scale.x = 0.7
	#$blocked.scale.y = 0.7
	
	$warning.visible = false
	$warning2.visible = true
	
	$icon.scale.x = 0.5
	$icon.scale.y = 0.5
	
	$Label.visible = false
	
	$icon.texture = load(fruit.sprite)
