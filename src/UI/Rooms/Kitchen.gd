extends Room

var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 2

func _process(delta: float) -> void:
	if (NecessityBars.fome <= (NecessityBars.max_fome*0.2)) and playing == false:
		$cozinha_geladeira/AnimationPlayer.play("Shaking_animation")
		playing = true
	elif (NecessityBars.fome > (NecessityBars.max_fome*0.2)) and playing != false:
		$cozinha_geladeira/AnimationPlayer.play("idle")
		playing = false
	
	if(Resources.weather == "Rainy"):
		$janela_chuva.visible = true
		$janela_sol.visible = false
		$janela_neve.visible = false
		$janela_noite.visible = false
	elif(Resources.weather == "Sunny"):
		$janela_chuva.visible = false
		$janela_sol.visible = true
		$janela_neve.visible = false
		$janela_noite.visible = false
	elif(Resources.weather == "Snowy"):
		$janela_chuva.visible = false
		$janela_sol.visible = false
		$janela_neve.visible = true
		$janela_noite.visible = false


func _on_Eat_button_pressed() -> void:
	$audio_open_refri.play()
	$cozinha_geladeira.visible = false
	$geladeira_aberta.visible = true
	$Match3PopUp/AnimationPlayer.play("in")
	

func _on_TutorialButton_pressed() -> void:
	AnimationController.is_travelling = false
	return
	AnimationController.status = "Match3"
	NecessityBars.eating = true
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_3x3.tscn")

func _on_StartButton_pressed() -> void:
	AnimationController.is_travelling = false
	
	AnimationController.status = "Match3"
	NecessityBars.eating = true
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_9x9.tscn")

func _on_LeaveButton_pressed() -> void:
	$geladeira_aberta.visible = false
	$cozinha_geladeira.visible = true	
	$Match3PopUp/AnimationPlayer.play("out")
	
	

