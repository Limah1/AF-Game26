extends HouseRoom

var news_chuva = preload("res://assets/Plataforma/buttons/news-chuva.png")
var news_neve = preload("res://assets/Plataforma/buttons/news-neve.png")
var news_sol = preload("res://assets/Plataforma/buttons/news-sol.png")

var playing = false

func _ready() -> void:
	room_id = 2


func _process(delta: float) -> void:
	pass
	pass


func _on_Button_pressed():
	$DialogSystem.popup_centered()
	pass # Replace with function body.
