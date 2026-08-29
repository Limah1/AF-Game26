extends HouseRoom

var playing = false
const SLEEP_TEST_RIG_SCALE = 2.0
const SLEEPING_HEAD_SCALE_MULTIPLIER = 3.0
const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const SLEEPING_HEAD_PATH = "res://assets/Sprites-v3/heads/%s-%s-dormindo.png"

export(Vector2) var manta_scale = Vector2(0.4, 0.4)

onready var umbrella = $"bedroom/Ativo 15/Ativo 18/umbrella"
onready var coat = $"bedroom/Ativo 15/Ativo 19/coat"
onready var manta = $Manta
onready var sleep_test_rig = $SleepTestRig
onready var sleep_test_head_target = $SleepTestHeadTarget
onready var sleep_test_left_hand_target = $SleepTestLeftHandTarget
onready var sleep_test_right_hand_target = $SleepTestRightHandTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 3
	if(Resources.acessory_not_founded == "Umbrella"):
		umbrella.get_node("AnimationPlayer").play("idle")
	if(Resources.acessory_not_founded == "Coat"):
		coat.get_node("AnimationPlayer").play("idle")
	manta.scale = manta_scale
	manta.visible = false
	_setup_sleep_test_rig()

func _setup_sleep_test_rig() -> void:
	if sleep_test_rig == null:
		return
	sleep_test_rig.position = Vector2.ZERO
	sleep_test_rig.rotation = 0.0
	sleep_test_rig.scale = Vector2(SLEEP_TEST_RIG_SCALE, SLEEP_TEST_RIG_SCALE)
	sleep_test_rig.set_state(0)
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(sleep_test_rig, "sleeping")
	sleep_test_rig.visible = false

func _show_sleep_test_rig() -> void:
	if sleep_test_rig == null:
		return

	# Targets live in Bedroom's 1920x1080 scene space.
	sleep_test_rig.position = Vector2.ZERO
	sleep_test_rig.rotation = 0.0
	sleep_test_rig.scale = Vector2(SLEEP_TEST_RIG_SCALE, SLEEP_TEST_RIG_SCALE)
	# Convert room-space targets to local rig-space, preserving exact screen anchors at 2x.
	sleep_test_rig.sleep_head_position = sleep_test_head_target.position / SLEEP_TEST_RIG_SCALE
	sleep_test_rig.sleep_left_hand_position = sleep_test_left_hand_target.position / SLEEP_TEST_RIG_SCALE
	sleep_test_rig.sleep_right_hand_position = sleep_test_right_hand_target.position / SLEEP_TEST_RIG_SCALE
	sleep_test_rig.sleep_head_visible = true
	sleep_test_rig.sleep_torso_visible = false
	sleep_test_rig.sleep_left_arm_visible = false
	sleep_test_rig.sleep_right_arm_visible = false
	sleep_test_rig.sleep_left_hand_visible = false
	sleep_test_rig.sleep_right_hand_visible = false
	sleep_test_rig.sleep_left_leg_visible = false
	sleep_test_rig.sleep_right_leg_visible = false
	sleep_test_rig.sleep_pants_visible = false
	if ModularCharacterData.has_method("apply_to_rig"):
		ModularCharacterData.apply_to_rig(sleep_test_rig, "sleeping")
	_apply_sleeping_head()
	sleep_test_rig.set_state(3)
	manta.scale = manta_scale
	manta.visible = true
	sleep_test_rig.visible = true

func _apply_sleeping_head() -> void:
	var head = sleep_test_rig.get_node_or_null("Head")
	if head == null:
		return

	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	var sleeping_head = load(SLEEPING_HEAD_PATH % [gender, hair]) as Texture
	if sleeping_head == null:
		return

	head.texture = sleeping_head
	head.scale = head.scale * SLEEPING_HEAD_SCALE_MULTIPLIER
	# The imported head sprites use a placeholder skin color. Reuse the same
	# replacement shader as the regular legacy head and avoid double tinting.
	var head_material = head.material as ShaderMaterial
	if head_material == null or head_material.shader != LEGACY_HEAD_SHADER:
		head_material = ShaderMaterial.new()
		head_material.shader = LEGACY_HEAD_SHADER
		head.material = head_material
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", ModularCharacterData.cor_pele)
	head.modulate = Color.white

func _hide_sleep_test_rig() -> void:
	if sleep_test_rig == null:
		return
	sleep_test_rig.set_state(0)
	sleep_test_rig.visible = false
	manta.visible = false

func back_sleeping():
	AnimationController.already_on_bed()
	$"quarto-abajur-ligado".visible = false
	$"quarto-abajur-desligado".visible = true
	$CanvasLayer/ColorRect.visible = true 
	$CanvasLayer/SleepButton2.visible = true 
	NecessityBars.sleeping = true
	_show_sleep_test_rig()

func _process(delta: float) -> void:
	if (NecessityBars.energia <= (NecessityBars.max_energia*0.2)) and playing == false:
		$"quarto-abajur-ligado/AnimationPlayer".play("scale_in_out")
		playing = true
	elif (NecessityBars.energia > (NecessityBars.max_energia*0.2)) and playing != false:
		$"quarto-abajur-ligado/AnimationPlayer".play("idle")
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

func _on_pick_umbrella_pressed() -> void:
	$zip.play()
	umbrella.visible = !umbrella.visible
	coat.visible = true
	
	Resources.equip_acessory("Umbrella")

func _on_pick_coat_pressed() -> void:
	$zip.play()
	umbrella.visible = true
	coat.visible = !coat.visible
	
	Resources.equip_acessory("Coat")

func _on_SleepButton_pressed() -> void:
	$abajur.play()
	$bed_particle.set_emitting(false)
	if(NecessityBars.sleeping):
		wake_up()
	else:
		sleep()
		Resources.weather = "sleep"

func sleep():
	$"quarto-abajur-ligado".visible = false
	$"quarto-abajur-desligado".visible = true
	$CanvasLayer/ColorRect.visible = true 
	$CanvasLayer/SleepButton2.visible = true 
	$lamp_particle.set_emitting(true)
	yield(AnimationController.go_to_bed(), "completed")
	_show_sleep_test_rig()
	NecessityBars.sleeping = true
	AnimationController.status = "Sleeping"
	$lullaby.play()
	

func wake_up():
	_hide_sleep_test_rig()
	Resources.weather_randomize()
	AnimationController.status = "MainGame"
	
	Resources.acessory_not_founded = ""
	umbrella.get_node("AnimationPlayer").play("default")
	coat.get_node("AnimationPlayer").play("default")
	
	NecessityBars.sleeping = false
	$"quarto-abajur-ligado".visible = true
	$"quarto-abajur-desligado".visible = false
	$CanvasLayer/ColorRect.visible = false 
	$CanvasLayer/SleepButton2.visible = false 
	$bed_particle.set_emitting(true)
	$lamp_particle.set_emitting(false)
	$lullaby.stop()
	yield(AnimationController.wake_up_from_bed(), "completed")

func _on_PersonalizationButton_pressed() -> void:
	if CharacterController.boyorgirl == "Boy":
		$PersonalizationScreen/Boy_closet.visible = true
	elif CharacterController.boyorgirl == "Girl":
		$PersonalizationScreen/Girl_closet.visible = true
