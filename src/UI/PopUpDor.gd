extends CanvasLayer

func start(pain):
	NecessityBars.inpain = true
	
	if(CharacterController.boyorgirl == "Boy"):
		$"Control/DorDeCabeca/boy-dores".visible = true
		$"Control/DorNosBracos/boy-ferimento".visible = true
		$"Control/Febre/boy-febre".visible = true
		
		$"Control/DorDeCabeca/girl-dores".visible = false
		$"Control/DorNosBracos/girl-ferimento".visible = false
		$"Control/Febre/girl-febre".visible = false
	elif(CharacterController.boyorgirl == "Girl"):
		$"Control/DorDeCabeca/girl-dores".visible = true
		$"Control/DorNosBracos/girl-ferimento".visible = true
		$"Control/Febre/girl-febre".visible = true
		
		$"Control/DorDeCabeca/boy-dores".visible = false
		$"Control/DorNosBracos/boy-ferimento".visible = false
		$"Control/Febre/boy-febre".visible = false

	if pain == "headache":
		$Control/DorDeCabeca.visible = true
		$Control/DorDeCabeca/vermelho_piscando/AnimationPlayer.play("piscando")
	if pain == "fever":
		$Control/Febre.visible = true
	if pain == "armPain":
		$Control/DorNosBracos.visible = true
		$Control/DorNosBracos/vermelho_piscando/AnimationPlayer2.play("piscando")
		$Control/DorNosBracos/vermelho_piscando2/AnimationPlayer3.play("piscando")

func _on_go_to_mother_pressed() -> void:
	
	if(AnimationController.status == "" and AnimationController.is_playing() and AnimationController.isTravelling()):
		get_tree().paused = false
		queue_free()
		return
	elif(AnimationController.status == "MainGame"):
		get_tree().paused = false
		AnimationController.travel(AnimationController.current_room.room_id, 1)
		queue_free()
	else:
		get_tree().paused = false
		AnimationController.status = "DoiAqui"
		get_tree().change_scene("res://src/MainScreen.tscn")


func _on_ok_pressed() -> void:
	get_tree().paused = false
	queue_free()
	return
