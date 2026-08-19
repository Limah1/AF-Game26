extends Control

onready var rig_idle = $RigIdle
onready var rig_walk = $RigWalk
onready var rig_run = $RigRun
onready var rig_sleep = $RigSleep
onready var rig_toilet = $RigToilet
onready var rig_jump = $RigJump

var current_skin: Color
var current_clothes: Color

func _ready():
	yield(get_tree(), "idle_frame")
	_apply_default_colors()

	# Apply the selected data-driven parts to every test rig.
	for rig in [rig_idle, rig_walk, rig_run, rig_sleep, rig_toilet, rig_jump]:
		if rig != null:
			ModularCharacterData.apply_to_rig(rig)

	# Use the selected head for the sleeping rig too.
	if ModularCharacterData.tex_rosto_dormindo != null:
		rig_sleep.set_face_texture(ModularCharacterData.tex_rosto_dormindo)

func _apply_default_colors():
	_on_BtnSkin1_pressed()
	_on_BtnClothesBlue_pressed()

func _on_BtnSkin1_pressed():
	ModularCharacterData.select_skin_tone("skin_01")
	current_skin = ModularCharacterData.cor_pele
	_update_rigs()

func _on_BtnSkin2_pressed():
	ModularCharacterData.select_skin_tone("skin_06")
	current_skin = ModularCharacterData.cor_pele
	_update_rigs()

func _on_BtnClothesBlue_pressed():
	current_clothes = Color(0.2, 0.4, 0.8)
	_update_rigs()

func _on_BtnClothesYellow_pressed():
	current_clothes = Color(0.9, 0.9, 0.2)
	_update_rigs()

func _update_rigs():
	# Keep the data-driven singleton synchronized with this test UI.
	ModularCharacterData.cor_pele = current_skin
	ModularCharacterData.cor_roupa_cima = current_clothes
	for rig in [rig_idle, rig_walk, rig_run, rig_sleep, rig_toilet, rig_jump]:
		if rig != null:
			rig.set_skin_color(current_skin)
			rig.set_shirt_color(current_clothes)

func _apply_catalog_to_rigs():
	for rig in [rig_idle, rig_walk, rig_run, rig_sleep, rig_toilet, rig_jump]:
		if rig != null:
			ModularCharacterData.apply_to_rig(rig)
	_update_rigs()

func _on_BtnHeadWhite_pressed():
	if ModularCharacterData.set_gender("boy"):
		_apply_catalog_to_rigs()

func _on_BtnHeadGreen_pressed():
	if ModularCharacterData.set_gender("girl"):
		_apply_catalog_to_rigs()

func _on_BtnCatalogClothes_pressed():
	if ModularCharacterData.select_torso("torso_" + ModularCharacterData.genero):
		_apply_catalog_to_rigs()

func _on_BtnSave_pressed():
	ModularTestVariables.skin_color = current_skin
	ModularTestVariables.clothes_color = current_clothes

func _on_BtnLoadTest_pressed():
	get_tree().change_scene("res://src/Mini-games/CharacterTest/MinigameLoadTest.tscn")

func _on_BtnMovementTest_pressed():
	get_tree().change_scene("res://src/Mini-games/CharacterTest/CharacterMovementTest.tscn")
