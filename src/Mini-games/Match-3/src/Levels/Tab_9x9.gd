extends Board

#onready var animationInfo: AnimationPlayer = $infoBoxAnimation

var personagem_sprite
var cor_pele = ""

func _ready() -> void:
	# Shaders mudando a etnia
	personagem_sprite = get_node("character")
	cor_pele = NewCharData.cor_pele
	var new_color_pele = Color(cor_pele)
	var shader_material = personagem_sprite.material as ShaderMaterial
	shader_material.set_shader_param("nova_cor_pele", new_color_pele)
	
	
	S_Conntroller.sound = $bite
	S_Conntroller.goals = [20,20,20]
	S_Conntroller.chances = 35
	S_Conntroller.last_result_won = true
	
	fruit_max_count = 81
	line_quant = 9
	
	AllTiles = [
		$Fila1.get_children(),
		$Fila2.get_children(),
		$Fila3.get_children(),
		$Fila4.get_children(),
		$Fila5.get_children(),
		$Fila6.get_children(),
		$Fila7.get_children(),
		$Fila8.get_children(),
		$Fila9.get_children()
	]
	
	alltiles = AllTiles[0] + AllTiles[1] + AllTiles[2] + AllTiles[3] + AllTiles[4] + AllTiles[5] + AllTiles[6] + AllTiles[7] + AllTiles[8]
	
	var swf = SWF.instance()
	swf.start(selected_good_fruits, selected_harmful_fruit)
	add_child(swf)

	
	$Temp_Tab_9x9.start(AllFruits)
	var textInfobox = get_node("info-box/ColorRect/Label").text
	for fruit in AllFruits:
		var fruitNode = fruit.instance()
		textInfobox += fruitNode.nutrient
		textInfobox += "\n"
		get_node("info-box/ColorRect/Label").text = textInfobox
		print(fruitNode.nutrient)
		fruitNode.queue_free()

func _on_TextureButton2_pressed():
	$"info-box".layer = 200
	$"info-box/ColorRect".visible = true
	#animationInfo.play("fade_in")
	#yield(animationInfo, "animation_finished")
	print("2")

func _on_back_pressed():
	#animationInfo.play("fade_out")
	#yield(animationInfo, "animation_finished")
	$"info-box".layer = -200
	$"info-box/ColorRect".visible = false
	print("1")


func _on_PauseButton_pressed() -> void:
	$CanvasLayer/Pause.visible = true
	
	var necessitybar = load("res://src/UI/NecessityManager.tscn").instance()
	$CanvasLayer/Pause.add_child(necessitybar)

func _on_continue_pressed() -> void:
	$CanvasLayer/Pause.visible = false
	$CanvasLayer/Pause.get_node("NecessityManager").queue_free()


func _on_leave_pressed() -> void:
	NecessityBars.eating = false
	get_tree().change_scene("res://src/MainScreen.tscn")
