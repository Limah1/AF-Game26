extends Board

onready var animationInfo: AnimationPlayer = $infoBoxAnimation 
onready var legacy_head: Sprite = $Head
onready var skin_tone_rect: Panel = $SkinToneRect

var personagem_sprite
var cor_pele = ""

# Ajustes expostos para alinhar cabeça e pescoço no Inspector da cena.
export(Vector2) var legacy_head_position = Vector2(203.351, 497)
export(Vector2) var legacy_neck_position = Vector2(184, 517)
export(Vector2) var legacy_neck_size = Vector2(38, 60)

func _ready() -> void:
	# Shaders mudando a etnia
	personagem_sprite = get_node("character")
	cor_pele = NewCharData.cor_pele
	var new_color_pele = Color(cor_pele) if cor_pele != "" else Color.white
	var shader_material = personagem_sprite.material as ShaderMaterial
	if shader_material != null:
		shader_material.set_shader_param("nova_cor_pele", new_color_pele)
		shader_material.set_shader_param("nova_cor_camisa", Color("#8aa0a5"))
		shader_material.set_shader_param("nova_cor_calca", Color("#515151"))
	_setup_legacy_head(new_color_pele)
	reaction = {
		"sad":preload("res://assets/Match-3/sprites_novo/personagem/headless/boy-a-match3-triste-headless.png"),
		"very-sad":preload("res://assets/Match-3/sprites_novo/personagem/headless/boy-a-match3-mto-triste-headless.png"),
		"normal":preload("res://assets/Match-3/sprites_novo/personagem/headless/boy-a-match3-serio-headless.png"),
		"happy":preload("res://assets/Match-3/sprites_novo/personagem/headless/boy-a-match3-feliz-headless.png"),
		"very-happy":preload("res://assets/Match-3/sprites_novo/personagem/headless/boy-a-match3-mto-feliz-headless.png")
	}
	$character.texture = reaction["normal"]
	
	
	S_Conntroller.goalScore = 60
	S_Conntroller.chances = 20
	S_Conntroller.totalScore = 0
	S_Conntroller.last_result_won = true
	
	fruit_max_count = 36
	line_quant = 6
	
	AllTiles = [
		$Fila1.get_children(),
		$Fila2.get_children(),
		$Fila3.get_children(),
		$Fila4.get_children(),
		$Fila5.get_children(),
		$Fila6.get_children(),
	]
	
	alltiles = AllTiles[0] + AllTiles[1] + AllTiles[2] + AllTiles[3] + AllTiles[4] + AllTiles[5]
	
	var swf = SWF.instance()
	swf.start(selected_good_fruits, selected_harmful_fruit)
	add_child(swf)
	
	$Temp_Tab_6x6.start(AllFruits)
	var textInfobox = get_node("info-box/ColorRect/Label").text
	for fruit in AllFruits:
		var fruitNode = fruit.instance()
		textInfobox += fruitNode.nutrient
		textInfobox += "\n"
		get_node("info-box/ColorRect/Label").text = textInfobox
		print(fruitNode.nutrient)
		fruitNode.queue_free()

func _setup_legacy_head(skin: Color) -> void:
	if legacy_head == null or skin_tone_rect == null:
		return
	var head_texture = CharacterController.get_legacy_head_texture()
	if head_texture == null:
		legacy_head.visible = false
		skin_tone_rect.visible = false
		return
	legacy_head.texture = head_texture
	legacy_head.visible = true
	legacy_head.position = legacy_head_position
	legacy_head.scale = Vector2(0.252, 0.252)
	skin_tone_rect.visible = true
	skin_tone_rect.rect_position = legacy_neck_position
	skin_tone_rect.rect_size = legacy_neck_size
	var neck_style = skin_tone_rect.get_stylebox("panel") as StyleBoxFlat
	if neck_style != null:
		neck_style = neck_style.duplicate()
		neck_style.bg_color = skin
		skin_tone_rect.add_stylebox_override("panel", neck_style)
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	var head_material = legacy_head.material as ShaderMaterial
	if head_material != null:
		head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
		head_material.set_shader_param("target_skin", skin)

func _on_back_pressed():	
	animationInfo.play("fade_out")
	yield(animationInfo, "animation_finished")
	$"info-box".layer = -200
	$"info-box/ColorRect".visible = false
	print("1")


func _on_InfoButton_pressed():
	$"info-box".layer = 200
	$"info-box/ColorRect".visible = true
	animationInfo.play("fade_in")
	yield(animationInfo, "animation_finished")
	print("2")


func _on_PauseButton_pressed():
	$CanvasLayer/Pause.visible = true
	var necessitybar = load("res://src/UI/NecessityManager.tscn").instance()
	$CanvasLayer/Pause.add_child(necessitybar)


func _on_continue_pressed():
	$CanvasLayer/Pause.visible = false
	$CanvasLayer/Pause.get_node("NecessityManager").queue_free()


func _on_leave_pressed():
	NecessityBars.eating = false
	get_tree().change_scene("res://src/MainScreen.tscn")
