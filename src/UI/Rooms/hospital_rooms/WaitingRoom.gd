extends HouseRoom

var news_chuva = preload("res://assets/Plataforma/buttons/news-chuva.png")
var news_neve = preload("res://assets/Plataforma/buttons/news-neve.png")
var news_sol = preload("res://assets/Plataforma/buttons/news-sol.png")

var playing = false

func _ready() -> void:
	room_id = 1
	
	if NecessityBars.some_problem != "" and playing == false:
		$sala_pais/AnimationPlayer.play("scale_in_out")
		playing = true
	elif NecessityBars.some_problem == "" and playing != false:
		$sala_pais/AnimationPlayer.play("idle")
		playing = false

func _process(delta: float) -> void:
	pass
	pass
