extends HouseRoom

var playing = false

onready var match3_popup_head: Sprite = $Match3PopUp/Head

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 2
	_setup_match3_popup_head()

func _setup_match3_popup_head() -> void:
	var head_texture = CharacterController.get_legacy_head_texture()
	if head_texture == null:
		match3_popup_head.visible = false
		return
	match3_popup_head.texture = head_texture
	match3_popup_head.visible = true
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	var head_material = match3_popup_head.material as ShaderMaterial
	if head_material != null:
		head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
		head_material.set_shader_param("target_skin", Color(NewCharData.cor_pele) if NewCharData.cor_pele != "" else Color.white)

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
	_setup_match3_popup_head()
	$audio_open_refri.play()
	$cozinha_geladeira.visible = false
	$geladeira_aberta.visible = true
	$Match3PopUp/AnimationPlayer.play("in")
	

func _on_TutorialButton_pressed() -> void:
	AnimationController.is_travelling = false
	AnimationController.status = "Match3"
	NecessityBars.eating = true
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_3x3.tscn")

func _on_StartButton_pressed() -> void:
	AnimationController.is_travelling = false
	
	AnimationController.status = "Match3"
	NecessityBars.eating = true
	get_tree().change_scene("res://src/Mini-games/Match-3/src/Levels/Tab_6x6.tscn")

func _on_LeaveButton_pressed() -> void:
	$geladeira_aberta.visible = false
	$cozinha_geladeira.visible = true	
	$Match3PopUp/AnimationPlayer.play("out")
	
	

