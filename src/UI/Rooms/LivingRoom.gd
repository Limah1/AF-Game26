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
	if Resources.weather == "Sunny":
		$news.texture = news_sol
		
	elif Resources.weather == "Rainy":
		$news.texture = news_chuva
	elif Resources.weather == "Snowy":
		$news.texture = news_neve

func _on_Pais_pressed() -> void:
	$DoiAqui/AnimationPlayer.play("fade_in")

func _on_TextureButton_pressed() -> void:
	$DoiAqui/AnimationPlayer.play("fade_out")

func _on_YogaButton_pressed() -> void:
	$Alongamento/AnimationPlayer.play("fade_in")

func _on_AlongamentoClose_pressed() -> void:
	$Alongamento/AnimationPlayer.play("fade_out")

func _on_Tv_button_pressed() -> void:
	$tv_on.visible = !$tv_on.visible
	$news.visible = !$news.visible

func _on_StartButton_pressed() -> void:
	AnimationController.status = "DoiAqui"
	
	if(NecessityBars.some_problem == "fever"):
		GlobalResource.initialPain = 2
	elif(NecessityBars.some_problem == "headache"):
		GlobalResource.initialPain = 0
	elif(NecessityBars.some_problem == "armPain"):
		GlobalResource.initialPain = 1
	
	NecessityBars.inpain = false
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/Main.tscn")


func _on_Tutorial_pressed():
	get_tree().change_scene("res://src/Mini-games/DoiAqui/scene/IndicadorDeDor.tscn")


func _on_AlongamentoStartButton_pressed():
	get_tree().change_scene("res://src/AlongamentoTest.tscn")
