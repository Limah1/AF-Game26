extends HouseRoom

var news_chuva = preload("res://assets/Plataforma/buttons/news-chuva.png")
var news_neve = preload("res://assets/Plataforma/buttons/news-neve.png")
var news_sol = preload("res://assets/Plataforma/buttons/news-sol.png")

var playing = false
onready var modular_test_rig = $ModularCharacterTestRig

func _ready() -> void:
	room_id = 1
	_setup_modular_test_rig()
	
	if NecessityBars.some_problem != "" and playing == false:
		$sala_pais/AnimationPlayer.play("scale_in_out")
		playing = true
	elif NecessityBars.some_problem == "" and playing != false:
		$sala_pais/AnimationPlayer.play("idle")
		playing = false

func _setup_modular_test_rig() -> void:
	if modular_test_rig == null:
		return
	var active_scene = get_tree().current_scene
	if active_scene != null and active_scene.has_node("Player/ModularPlayer"):
		# Full game uses persistent MainScreen/Teste rig; keep this preview for standalone scene tests only.
		modular_test_rig.visible = false
		return
	modular_test_rig.set_state(0)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(modular_test_rig)

func _process(delta: float) -> void:
	if Resources.weather == "Sunny":
		$news.texture = news_sol
		
	elif Resources.weather == "Rainy":
		$news.texture = news_chuva
	elif Resources.weather == "Snowy":
		$news.texture = news_neve

	if modular_test_rig != null and AnimationController.has_method("isTravelling"):
		# Idle normally; walk while legacy player travels between rooms.
		var desired_state = 1 if AnimationController.isTravelling() else 0
		if modular_test_rig.state != desired_state:
			modular_test_rig.set_state(desired_state)

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
