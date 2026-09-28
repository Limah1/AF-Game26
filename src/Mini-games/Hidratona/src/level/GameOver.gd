extends Control

const RAIN_RUN_CALIBRATION = preload("res://src/Mini-games/Hidratona/src/level/rain/RunCalibration.tres")
const SNOW_RUN_CALIBRATION = preload("res://src/Mini-games/Hidratona/src/level/snow/RunCalibration.tres")
const HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const BODY_SHADER = preload("res://src/Mini-games/Hidratona/src/level/rain/RainRunSkin.shader")

var run_tuning = null

func _ready():
	var sprites = CharacterController.all_sprites.hidratona
	$sprites/r2.texture = sprites.run.r2
	$sprites/r3.texture = sprites.run.r3
	$sprites/r4.texture = sprites.run.r4
	$sprites/r5.texture = sprites.run.r5
	$sprites/r6.texture = sprites.run.r6
	
	$sprites/win.texture = sprites.win
	
	if(Resources.acessory == "Coat"):
		run_tuning = SNOW_RUN_CALIBRATION
		$sprites/r2.texture = sprites.snow.run.r2
		$sprites/r3.texture = sprites.snow.run.r3
		$sprites/r4.texture = sprites.snow.run.r4
		$sprites/r5.texture = sprites.snow.run.r5
		$sprites/r6.texture = sprites.snow.run.r6
		
		$sprites/win.texture = sprites.snow.win
	
	if(Resources.acessory == "Umbrella"):
		run_tuning = RAIN_RUN_CALIBRATION
		$sprites/r2.texture = sprites.rain.run.r2
		$sprites/r3.texture = sprites.rain.run.r3
		$sprites/r4.texture = sprites.rain.run.r4
		$sprites/r5.texture = sprites.rain.run.r5
		$sprites/r6.texture = sprites.rain.run.r6

		$sprites/win.texture = sprites.rain.win

	if run_tuning != null:
		var skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white
		var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
		var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
		$sprites/Head.texture = CharacterController.get_head_texture_for(gender, hair)
		var head_material = ShaderMaterial.new()
		head_material.shader = HEAD_SHADER
		head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
		head_material.set_shader_param("target_skin", skin)
		$sprites/Head.material = head_material
		$sprites/Neck.color = skin
		var body_material = ShaderMaterial.new()
		body_material.shader = BODY_SHADER
		body_material.set_shader_param("target_skin", skin)
		for frame in range(2, 7):
			get_node("sprites/r%d" % frame).material = body_material

	$applaude.play()
	yield($applaude, "finished")
	$stinger.play()

	if Resources.current_life <= 0:
		$Water_result.visible = true;
		$life_result.visible = false;
	
	if Resources.heart <= 0:
		$life_result.visible = true;
		$Water_result.visible = false;

func _process(_delta):
	if run_tuning == null:
		return
	var active_frame = 0
	for frame in range(2, 7):
		if get_node("sprites/r%d" % frame).visible:
			active_frame = frame
			break
	$sprites/Head.visible = active_frame != 0
	$sprites/Neck.visible = active_frame != 0
	if active_frame == 0:
		return
	var scale_factor = 3.0 / run_tuning.body_scale
	var head_position = (run_tuning.get_head_position(active_frame) - Vector2(-3, 46)) * scale_factor
	$sprites/Head.position = head_position
	$sprites/Head.scale = Vector2.ONE * run_tuning.head_scale * scale_factor
	$sprites/Neck.rect_position = head_position + run_tuning.neck_offset * scale_factor
	$sprites/Neck.rect_size = run_tuning.neck_size * scale_factor

func _on_TryAgainButton_pressed():
	$button_sound.play()
	yield($button_sound,"finished")
	Resources.reset_resources()
	get_tree().change_scene("res://src/Mini-games/Hidratona/src/level/Level.tscn")

func _on_GoHomeButton_pressed() -> void:
	$button_sound.play()
	yield($button_sound,"finished")
	Resources.reset_resources()
	get_tree().paused = false
	get_tree().change_scene("res://src/MainScreen.tscn")

func _on_MinigameRespiracao_pressed() -> void:
	Resources.reset_resources()
	get_tree().change_scene("res://src/Mini-games/Respiracao/Respiracao.tscn")
