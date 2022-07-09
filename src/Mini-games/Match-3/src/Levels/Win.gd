extends Control

var complete_total_match = S_Conntroller.score1 == S_Conntroller.goals[0] and S_Conntroller.score2 == S_Conntroller.goals[1] and S_Conntroller.score3 == S_Conntroller.goals[2]
var complete_match1 = S_Conntroller.score1 == S_Conntroller.goals[0] and S_Conntroller.score2 == S_Conntroller.goals[1] and S_Conntroller.score3 != S_Conntroller.goals[2]
var complete_match2 = S_Conntroller.score1 == S_Conntroller.goals[0] and S_Conntroller.score2 != S_Conntroller.goals[1] and S_Conntroller.score3 == S_Conntroller.goals[2]
var complete_match3 = S_Conntroller.score1 != S_Conntroller.goals[0] and S_Conntroller.score2 == S_Conntroller.goals[1] and S_Conntroller.score3 == S_Conntroller.goals[2]

var complete_match4 = S_Conntroller.score1 == S_Conntroller.goals[0] and S_Conntroller.score2 != S_Conntroller.goals[1] and S_Conntroller.score3 != S_Conntroller.goals[2]
var complete_match5 = S_Conntroller.score1 != S_Conntroller.goals[0] and S_Conntroller.score2 != S_Conntroller.goals[1] and S_Conntroller.score3 == S_Conntroller.goals[2]
var complete_match6 = S_Conntroller.score1 != S_Conntroller.goals[0] and S_Conntroller.score2 == S_Conntroller.goals[1] and S_Conntroller.score3 != S_Conntroller.goals[2]

var complete_match7 = S_Conntroller.score1 != S_Conntroller.goals[0] and S_Conntroller.score2 != S_Conntroller.goals[1] and S_Conntroller.score3 != S_Conntroller.goals[2]
var value = S_Conntroller.totalScore

var timer = 2
var hide = false

func _ready():
	$applause.play()
	$character.texture = CharacterController.all_sprites.match3.win
	
	$HealthDisplay/HealthBar.max_value = S_Conntroller.goalScore
#	if complete_total_match:
#		$estrela2.visible = true
#		$estrela3.visible = true
#	elif complete_match1:
#		$estrela2.visible = true
#	elif complete_match2:
#		$estrela2.visible = true
#	elif complete_match3:
#		$estrela2.visible = true
		
#	if S_Conntroller.score1 == S_Conntroller.goals[0]:
#		$"arroz-feijao/checked".visible = true
#	else:
#		$"arroz-feijao/checked".visible = false
#	if S_Conntroller.score2 == S_Conntroller.goals[1]:
#		$"suco-abacaxi/checked".visible = true
#	else:
#		$"suco-abacaxi/checked".visible = false
#	if S_Conntroller.score3 == S_Conntroller.goals[2]:
#		$melancia/checked.visible = true
#	else:
#		$melancia/checked.visible = false		
	$HealthDisplay/HealthBar.value = value
	$HealthDisplay.update_healthBar(value)
	
#	$score1.text = str(S_Conntroller.score1, " / ", S_Conntroller.goals[0])
#	$score2.text = str(S_Conntroller.score2, " / ", S_Conntroller.goals[1])
#	$score3.text = str(S_Conntroller.score3, " / ", S_Conntroller.goals[2])
	
	$Fruit_UI.start_Win(get_fruit_reference(S_Conntroller.fruit1_reference), 0)
	$Fruit_UI2.start_Win(get_fruit_reference(S_Conntroller.fruit2_reference), 1)
	$Fruit_UI3.start_Win(get_fruit_reference(S_Conntroller.fruit3_reference), 2)

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed() and timer<=0) or (event is InputEventScreenTouch and event.is_pressed() and timer <= 0):
		$CanvasLayer/Tutorial.visible = false

func _process(delta: float) -> void:
	if S_Conntroller.tutorial and !hide:
		timer -= delta
		
		if timer <= 0:
			$CanvasLayer/Tutorial.visible = true
			hide = true
			
			S_Conntroller.reset_all()

func get_fruit_reference(fruit: String):
	var fruit_reference = {}
	var path: String = "res://assets/Match-3/sprites/"
	
	var fruit_name = translated_name(fruit)
	fruit_name = fruit_name.replace(" ", "-").to_lower()
	
	fruit_reference.name = translated_name(fruit)
	fruit_reference.sprite = str(path, fruit_name, ".png")
	
	return fruit_reference

func translated_name(fruit: String):
	if fruit == "Juice":
		return "Suco Abacaxi"
	elif fruit == "Watermelon":
		return "Melancia"
	elif fruit == "RiceAndBean":
		return "Arroz e Feijao"
	elif fruit == "Water":
		return "Agua"
	elif fruit == "Hamburguer":
		return "Hamburguer"
	elif fruit == "Apple":
		return "Maca"
	elif fruit == "IceCream":
		return "Sorvete"
	elif fruit == "Pizza":
		return "Pizza"
	elif fruit == "Orange":
		return "Laranja"
	elif fruit == "Fish":
		return "Peixe"
	elif fruit == "Salad":
		return "Salada"
	elif fruit == "Soda":
		return "Refrigerante"

func _on_TextureButton_pressed():
	S_Conntroller.tutorial = false
	
	S_Conntroller.chances = 15
	S_Conntroller.score1 = 0	
	S_Conntroller.score2 = 0	
	S_Conntroller.score3 = 0
	S_Conntroller.checked = true
	S_Conntroller.tilestodestroy = [] 
	
	
	C_Controller.started = false

	C_Controller.center = null
	C_Controller.score_t = []
	C_Controller.score_r = []
	C_Controller.score_l = []
	C_Controller.score_b = []
	
	M_Controller.moving = []
	M_Controller.pressing = false
	M_Controller.tile = null
	get_parent().get_tree().change_scene("res://src/Levels/Main.tscn")

func _on_VoltarParaCasa_pressed() -> void:
	S_Conntroller.reset_all()
	M_Controller.reset_all()
	C_Controller.reset_score()
	NecessityBars.eating = false
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_IrDeNovo_pressed() -> void:
	S_Conntroller.reset_all()
	M_Controller.reset_all()
	C_Controller.reset_score()
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_6x6.tscn")


func _on_Button_button_up():
	$aplausos.play()
