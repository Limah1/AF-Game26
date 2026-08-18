extends Control

onready var rig_idle = $RigIdle
onready var rig_walk = $RigWalk
onready var rig_run = $RigRun
onready var rig_sleep = $RigSleep
onready var rig_toilet = $RigToilet

var current_hair: Color
var current_skin: Color
var current_clothes: Color

func _ready():
	yield(get_tree(), "idle_frame")
	_apply_default_colors()
	
	# Aplica as texturas globais em todos os bonecos de teste
	for rig in [rig_idle, rig_walk, rig_run, rig_sleep, rig_toilet]:
		if rig != null:
			ModularCharacterData.apply_to_rig(rig)
	
	# Substitui especificamente o rosto do boneco dormindo
	if ModularCharacterData.tex_rosto_dormindo != null:
		rig_sleep.set_face_texture(ModularCharacterData.tex_rosto_dormindo)

func _apply_default_colors():
	_on_BtnHairBlue_pressed()
	_on_BtnSkin1_pressed()
	_on_BtnClothesBlue_pressed()

func _on_BtnHairBlue_pressed():
	current_hair = Color(0.2, 0.2, 1.0)
	_update_rigs()

func _on_BtnHairRed_pressed():
	current_hair = Color(1.0, 0.2, 0.2)
	_update_rigs()

func _on_BtnSkin1_pressed():
	current_skin = Color(0.96, 0.89, 0.82)
	_update_rigs()

func _on_BtnSkin2_pressed():
	current_skin = Color(0.44, 0.27, 0.18)
	_update_rigs()

func _on_BtnClothesBlue_pressed():
	current_clothes = Color(0.2, 0.4, 0.8)
	_update_rigs()

func _on_BtnClothesYellow_pressed():
	current_clothes = Color(0.9, 0.9, 0.2)
	_update_rigs()

func _update_rigs():
	for rig in [rig_idle, rig_walk, rig_run, rig_sleep, rig_toilet]:
		if rig != null:
			rig.set_hair_color(current_hair)
			rig.set_skin_color(current_skin)
			rig.set_shirt_color(current_clothes)

func _on_BtnSave_pressed():
	ModularTestVariables.hair_color = current_hair
	ModularTestVariables.skin_color = current_skin
	ModularTestVariables.clothes_color = current_clothes

func _on_BtnLoadTest_pressed():
	get_tree().change_scene("res://src/Mini-games/CharacterTest/MinigameLoadTest.tscn")
