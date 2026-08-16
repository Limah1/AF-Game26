extends CanvasLayer

var all_fruits = []
var harmful_fruit
var timer = 3

onready var AP: AnimationPlayer = $Metas/AnimationPlayer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and timer <= 0:
		AP.play("dash_out")
		yield(AP, "animation_finished")
		get_tree().paused = false
		queue_free()

func _process(delta: float) -> void:
	timer -= delta

func _ready() -> void:
	get_tree().paused = true

func start(selected_fruits: Array, _harmful_fruit: String):
	for fruit in selected_fruits:
		all_fruits.append(get_fruit_reference(fruit))
	
	harmful_fruit = get_fruit_reference(_harmful_fruit)
	
	$Metas/Fruit_UI.start_show(all_fruits[0], 0)
	$Metas/Fruit_UI2.start_show(all_fruits[1], 1)
	$Metas/Fruit_UI3.start_show(all_fruits[2], 2)
	$Metas/Fruit_UI4.start_show(harmful_fruit)
	
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
	
