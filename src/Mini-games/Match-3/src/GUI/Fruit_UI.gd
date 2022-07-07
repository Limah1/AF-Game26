extends Button

var fruit

func start_show(_fruit, index):
	fruit = _fruit
	
	$icon.scale.x = 0.7
	$icon.scale.y = 0.7
	
#	$Label.visible = true
#	$Label3.visible = true
	
	if fruit.name == "Maca":
		fruit.name = "Maçã"
	
	$Label3.text = str("00 / ", S_Conntroller.goals[index])
	
	$Label.text = fruit.name
	$icon.texture = load(fruit.sprite)

func start_Win(_fruit, index):
	fruit = _fruit
	
	$icon.scale.x = 0.7
	$icon.scale.y = 0.7
	
#	$Label.visible = true
#	$Label3.visible = true
	
	if fruit.name == "Maca":
		fruit.name = "Maçã"
	if index == 0:
		$Label3.text = str(S_Conntroller.score1 ," / ", S_Conntroller.goals[index])
	if index == 1:
		$Label3.text = str(S_Conntroller.score2 ," / ", S_Conntroller.goals[index])
	if index == 2:
		$Label3.text = str(S_Conntroller.score3 ," / ", S_Conntroller.goals[index])
	
	$Label.text = fruit.name
	$icon.texture = load(fruit.sprite)
	$checked.visible = true

func start_ongame(_fruit):
	fruit = _fruit
	
	$icon.scale.x = 0.5
	$icon.scale.y = 0.5
	
	$Label.visible = false
	$Label3.visible = false
	
	$icon.texture = load(fruit.sprite)
	
func checked():
	$checked.visible = true

func unchecked():
	$checked.visible = false
