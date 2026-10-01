extends Control

var cor_pele = ""

export(Vector2) var defeat_head_position = Vector2(271.351, 458)
export(Vector2) var victory_head_position = Vector2(268.973, 469)
export(Vector2) var victory_neck_position = Vector2(253, 550)
export(Vector2) var defeat_neck_position = Vector2(256, 539)

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
	# Shaders mudando a etnia
	cor_pele = NewCharData.cor_pele
	var new_color_pele = Color(cor_pele) if cor_pele != "" else Color.white
	for sprite in [$character, $VictoryArm]:
		var shader_material = sprite.material as ShaderMaterial
		shader_material.set_shader_param("nova_cor_pele", new_color_pele)
	_setup_legacy_head(new_color_pele)
	
	
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

	if S_Conntroller.last_result_won:
		# Vitoria: aplausos, pose de comemoracao e estrelas/checks por fruta
		$applause.play()

		$Fruit_UI.start_Win(get_fruit_reference(S_Conntroller.fruit1_reference), 0)
		$Fruit_UI2.start_Win(get_fruit_reference(S_Conntroller.fruit2_reference), 1)
		$Fruit_UI3.start_Win(get_fruit_reference(S_Conntroller.fruit3_reference), 2)
	else:
		# Derrota (ficou sem chances antes de bater a meta): sem aplausos/comemoracao
		$character.texture = preload("res://assets/Match-3/sprites_novo/personagem/headless/boy-a-match3-mto-triste-headless.png")
		$VictoryArm.hide()
		$Head.position = defeat_head_position
		$SkinToneRect.rect_position = defeat_neck_position

		for particles in [$p2d_red, $p2d_green, $p2d_blue, $p2d_violet, $p2d_white, $p2d_white2]:
			particles.emitting = false

		$Label.text = "Você ficou sem chances...\nTente novamente!"
		$Label.visible = true

func _setup_legacy_head(skin: Color) -> void:
	$SkinToneRect.rect_position = victory_neck_position
	$SkinToneRect.rect_size = Vector2(32, 30)
	var style = $SkinToneRect.get_stylebox("panel").duplicate()
	style.bg_color = skin
	$SkinToneRect.add_stylebox_override("panel", style)
	$Head.texture = CharacterController.get_legacy_head_texture()
	$Head.position = victory_head_position
	$SkinToneRect.visible = $Head.texture != null
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	var head_material = $Head.material as ShaderMaterial
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", skin)

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
