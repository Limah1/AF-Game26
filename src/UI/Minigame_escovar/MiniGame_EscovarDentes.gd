extends CanvasLayer

var bathroom_reference = null

var pressing = false
var min_x = 0
var max_x = 1920
var min_y = 0
var max_y = 1080

onready var escova = $Escova
onready var sujeiras = $Sujeiras
onready var tela_final = $TelaFinal
onready var btn_start = $TelaInicial/ColorRect/BtnStart
onready var score_label = $ScoreLabel

var total_sujeiras = 0
var pontos = 0

func _ready():
	total_sujeiras = sujeiras.get_child_count()
	$Background.visible = true
	$TelaInicial/ColorRect.visible = true
	$TelaFinal/ColorRect.visible = false
	escova.visible = false
	set_process_input(false)
	set_process(false)

func start(ref):
	bathroom_reference = ref
	$TelaInicial/ColorRect.visible = true

func _on_BtnStart_pressed():
	$TelaInicial/ColorRect.visible = false
	escova.visible = true
	set_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if escova.visible:
		escova.global_position = escova.get_global_mouse_position()

func _on_EscovaArea_area_entered(area):
	if area.is_in_group("sujeira"):
		# Toca o som se quiser: $BrushingSound.play()
		
		var pos = area.global_position
		area.queue_free()
		
		# Cria a espuma
		var espuma_scene = load("res://src/UI/Minigame_escovar/Espuma.tscn")
		if espuma_scene:
			var espuma_inst = espuma_scene.instance()
			espuma_inst.global_position = pos
			$Espumas.add_child(espuma_inst)
		
		pontos += 1
		if score_label:
			score_label.text = "Pontos: " + str(pontos)
		
		total_sujeiras -= 1
		if total_sujeiras <= 0:
			finish_minigame()

func finish_minigame():
	set_process(false)
	escova.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	var personagem_sprite = $TelaFinal/ColorRect/character
	var cor_pele = NewCharData.cor_pele
	if cor_pele != "":
		if personagem_sprite.material:
			var shader_material = personagem_sprite.material.duplicate() as ShaderMaterial
			personagem_sprite.material = shader_material
			var new_color_pele = Color(cor_pele)
			shader_material.set_shader_param("nova_cor_pele", new_color_pele)
	
	if CharacterController.all_sprites and CharacterController.all_sprites.has("match3") and typeof(CharacterController.all_sprites.match3) == TYPE_DICTIONARY and CharacterController.all_sprites.match3.has("win"):
		if CharacterController.all_sprites.match3.win != null:
			personagem_sprite.texture = CharacterController.all_sprites.match3.win

	$TelaFinal/ColorRect.visible = true

func _on_BtnConcluir_pressed():
	if bathroom_reference and bathroom_reference.has_method("finish_escovar"):
		bathroom_reference.finish_escovar()
	queue_free()

func _on_BtnClose_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if bathroom_reference and bathroom_reference.has_method("finish_escovar"):
		bathroom_reference.finish_escovar()
	queue_free()
