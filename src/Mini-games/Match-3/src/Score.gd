extends Control

onready var p1 = $"Pontuacao1"
onready var p2 = $"Pontuacao2"
onready var p3 = $"Pontuacao3"

onready var chances = $Chances_quant
var value;

onready var PB = $ProgressBar
func _ready():
	$HealthDisplay/HealthBar.max_value = S_Conntroller.goalScore

func _process(delta: float) -> void:
	p1.text = str(S_Conntroller.score1, " / ",S_Conntroller.goals[0])
	p2.text = str(S_Conntroller.score2, " / ", S_Conntroller.goals[1])
	p3.text = str(S_Conntroller.score3, " / ", S_Conntroller.goals[2])
	
	value = S_Conntroller.totalScore
	$HealthDisplay.update_healthBar(value)
	
	chances.text = str(S_Conntroller.chances)
	
	if S_Conntroller.score1 == S_Conntroller.goals[0]:
		$Score1.checked()
	else:
		$Score1.unchecked()
	if S_Conntroller.score2 == S_Conntroller.goals[1]:
		$Score2.checked()
	else:
		$Score2.unchecked()
	if S_Conntroller.score3 == S_Conntroller.goals[2]:
		$Score3.checked()
	else:
		$Score3.unchecked()

func start(selected_fruits: Array, harmful_fruit: String):
	$Score1.start_ongame(get_fruit_reference(translated_name(selected_fruits[0])))
	$Score2.start_ongame(get_fruit_reference(translated_name(selected_fruits[1])))
	$Score3.start_ongame(get_fruit_reference(translated_name(selected_fruits[2])))
	$Blocked_Fruit.start_ongame(get_fruit_reference(translated_name(harmful_fruit)))
	
	$HealthDisplay.start()
	
func get_fruit_reference(fruit: String):
	var fruit_reference = {}
	var path: String = "res://assets/Match-3/sprites/"
	
	var fruit_name: String = fruit
	fruit_name = fruit_name.replace(" ", "-").to_lower()
	
	fruit_reference.name = fruit
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
	
