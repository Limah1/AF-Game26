extends KinematicBody2D

const LEGACY_HEAD_SHADER = preload("res://src/UI/LegacyHead.shader")
const BODY_SKIN_SHADER = preload("res://src/UI/ShaderPersonagem.tres")
const LEGACY_R1_SCALE = 1.38
const LEGACY_IDLE_WALK_HEAD_OFFSET = Vector2(0, 8)

var drying = false
var dirty = false
var show_bubble = false
var sleeping = false

var timer = 0.0
var last_weather = ""
var on_bath = false

onready var Anim_Player = $AnimationPlayer
onready var legacy_head = $player_sprites/Head
onready var skin_tone_rect = $player_sprites/SkinToneRect
onready var legacy_toilet_body = $player_sprites/toilet

var legacy_head_base_position = Vector2.ZERO
var legacy_toilet_base_position = Vector2.ZERO

func _ready() -> void:
	legacy_toilet_base_position = legacy_toilet_body.position
	set_normal_clothes()
	_refresh_legacy_head()
	apply_visual_consistency()

# Reaplica as propriedades visuais do player depois de uma troca de cena.
# As cenas Hospital/MainScreen usam instâncias diferentes do player; manter
# esta rotina aqui evita que materiais e escala fiquem dependentes da cena
# anterior.
func apply_visual_consistency(skin_color = null, shirt_color = null, pants_color = null) -> void:
	if not has_node("player_sprites"):
		return

	# O player legado deve sempre voltar ao tamanho base da plataforma.
	scale = Vector2.ONE
	_set_legacy_player_scale()

	var resolved_skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white
	var resolved_shirt = Color(NewCharData.cor_roupa_cima) if NewCharData.cor_roupa_cima != "" else Color("#8aa0a5")
	var resolved_pants = Color(NewCharData.cor_roupa_baixo) if NewCharData.cor_roupa_baixo != "" else Color("#515151")
	if skin_color != null:
		resolved_skin = skin_color
	if shirt_color != null:
		resolved_shirt = shirt_color
	if pants_color != null:
		resolved_pants = pants_color

	# Atribui o material diretamente a cada Sprite. Isso funciona tanto para
	# cenas que usam use_parent_material quanto para as que não o configuram.
	var body_material = BODY_SKIN_SHADER.duplicate()
	body_material.set_shader_param("nova_cor_pele", resolved_skin)
	body_material.set_shader_param("nova_cor_camisa", resolved_shirt)
	body_material.set_shader_param("nova_cor_calca", resolved_pants)
	$player_sprites.material = body_material
	for child in $player_sprites.get_children():
		if child is Sprite and child != legacy_head:
			child.material = body_material

	_refresh_legacy_head()

func _refresh_legacy_head() -> void:
	if legacy_head == null or not has_node("player_sprites/Head"):
		return
	var head_texture = CharacterController.get_legacy_head_texture()
	if head_texture == null:
		legacy_head.visible = false
		if skin_tone_rect != null:
			skin_tone_rect.visible = false
		return
	legacy_head.texture = head_texture
	legacy_head.visible = true
	var head_x = 20 if CharacterController.roupa == "r2" else 10
	var head_y = -37 if CharacterController.roupa == "r2" else -107
	legacy_head_base_position = Vector2(head_x, head_y)
	legacy_head.position = legacy_head_base_position
	legacy_head.scale = Vector2(0.1512, 0.1512)
	# The walk sprites do not include a neck. Keep this rectangle behind the
	# head and torso so it fills the opening without covering either sprite.
	if skin_tone_rect != null:
		skin_tone_rect.rect_position = Vector2(head_x - 23, head_y + 28)
		skin_tone_rect.rect_size = Vector2(46, 45)
		skin_tone_rect.rect_scale = Vector2.ONE
	var head_material = legacy_head.material as ShaderMaterial
	if head_material == null or head_material.shader != LEGACY_HEAD_SHADER:
		head_material = ShaderMaterial.new()
		head_material.shader = LEGACY_HEAD_SHADER
		legacy_head.material = head_material
	var skin = Color(CharacterController.cor_pele) if CharacterController.cor_pele != "" else Color.white
	if skin_tone_rect != null:
		var neck_style = skin_tone_rect.get_stylebox("panel") as StyleBoxFlat
		if neck_style != null:
			neck_style = neck_style.duplicate()
			neck_style.bg_color = skin
			skin_tone_rect.add_stylebox_override("panel", neck_style)
	var gender = "boy" if CharacterController.boyorgirl == "Boy" else "girl"
	var hair = CharacterController.cabelo if CharacterController.cabelo == "a" or CharacterController.cabelo == "b" else "a"
	head_material.set_shader_param("source_skin", CharacterController.get_legacy_head_source_skin_for(gender, hair))
	head_material.set_shader_param("target_skin", skin)

func _sync_legacy_head_visibility() -> void:
	if legacy_head == null:
		return
	var toilet_visible = $player_sprites/toilet.visible
	var idle_or_walking = $player_sprites/idle.visible or \
		$player_sprites/w1.visible or $player_sprites/w2.visible or \
		$player_sprites/w3.visible or $player_sprites/w4.visible or \
		$player_sprites/w5.visible
	var toilet_head_offset = Vector2(-5, 70) if toilet_visible else Vector2.ZERO
	var toilet_neck_offset = Vector2(-5, 70) if toilet_visible else Vector2.ZERO
	var toilet_body_offset = Vector2(0, 60) if toilet_visible else Vector2.ZERO
	var idle_walk_head_offset = LEGACY_IDLE_WALK_HEAD_OFFSET if idle_or_walking else Vector2.ZERO
	legacy_head.position = legacy_head_base_position + idle_walk_head_offset + toilet_head_offset
	legacy_toilet_body.position = legacy_toilet_base_position + toilet_body_offset
	var body_visible = $player_sprites/idle.visible or \
		$player_sprites/w1.visible or $player_sprites/w2.visible or \
		$player_sprites/w3.visible or $player_sprites/w4.visible or \
		$player_sprites/w5.visible or toilet_visible
	legacy_head.visible = body_visible and legacy_head.texture != null
	if skin_tone_rect != null:
		skin_tone_rect.visible = body_visible and legacy_head.texture != null
		skin_tone_rect.rect_position = Vector2(
			legacy_head_base_position.x - 23,
			legacy_head_base_position.y + 28
		) + idle_walk_head_offset + toilet_neck_offset

func _set_legacy_player_scale() -> void:
	var base_scale = LEGACY_R1_SCALE
	var direction = -1.0 if $player_sprites.scale.x < 0 else 1.0
	$player_sprites.scale = Vector2(base_scale * direction, base_scale)

func Walk_to_Right():
	_set_legacy_player_scale()
	$player_sprites.scale.x = abs($player_sprites.scale.x)
	Anim_Player.play("walk")

func Walk_to_Left():
	_set_legacy_player_scale()
	$player_sprites.scale.x = -abs($player_sprites.scale.x)
	Anim_Player.play("walk")

func Idle():
	_set_legacy_player_scale()
	Anim_Player.play("idle")

func show_bubbles():
	NecessityBars.soaked = true
	show_bubble = true
	$espuma.visible = true
	$espuma.modulate.a = 1

func leave_bath():
	on_bath = false

func sleep():
	sleeping = true

func wake_up():
	sleeping = false

func to_the_toilet():
	$player_sprites/idle.visible = false
	$player_sprites/toilet.visible = true

func _process(delta: float) -> void:
	_sync_legacy_head_visibility()
	if AnimationController.status == "Hospital":
		$rainny_sound.stop()
		$sunny_sound.stop()
		$snow_sound.stop()
		BackgroundMusic.stop_music()

	elif last_weather != Resources.weather:
		if Resources.weather == "Rainy" :
			$rainny_sound.play()
			$sunny_sound.stop()
			$snow_sound.stop()
			BackgroundMusic.play_music()

			last_weather = Resources.weather
		elif Resources.weather == "Sunny" :
			$rainny_sound.stop()
			$sunny_sound.play()
			$snow_sound.stop()
			BackgroundMusic.play_music()
	
			last_weather = Resources.weather
		elif Resources.weather == "Snowy" :
			$rainny_sound.stop()
			$sunny_sound.stop()
			$snow_sound.play()
			BackgroundMusic.play_music()
		
			last_weather = Resources.weather
		elif Resources.weather == "sleep":
			$rainny_sound.stop()
			$sunny_sound.stop()
			$snow_sound.stop()
			BackgroundMusic.stop_music()
		
	if( drying ):
		timer += delta
		if(timer >= 1):
			timer = 0
			$espuma.modulate.a = $espuma.modulate.a - 0.2
			
			if $espuma.modulate.a <= 0:
				NecessityBars.soaked = false
				show_bubble = false
				$espuma.visible = false
				drying = false
				on_bath = false
	
	if(NecessityBars.higiene < (NecessityBars.max_higiene * 0.3) and !sleeping):
		dirty = true
		$player_sprites.position.y = -218
		if(on_bath):
			set_bath_dirty_clothes()
			return
		set_normal_dirty_clothes()
	else:
		$player_sprites.position.y = -162
		
		if(on_bath):
			set_bath_clothes()
			return
		set_normal_clothes()
		
func set_normal_clothes():
	_set_legacy_player_scale()
	var sprites = CharacterController.all_sprites.plataform
	
	$player_sprites/idle.texture = sprites.idle
	$player_sprites/sleeping.texture = sprites.sleeping
	$player_sprites/toilet.texture = sprites.seated
	
	$player_sprites/w1.texture = sprites.walk.w1
	$player_sprites/w2.texture = sprites.walk.w2
	$player_sprites/w3.texture = sprites.walk.w3
	$player_sprites/w4.texture = sprites.walk.w4
	$player_sprites/w5.texture = sprites.walk.w5

func set_normal_dirty_clothes():
	_set_legacy_player_scale()
	var sprites = CharacterController.all_sprites.plataform
	
	$player_sprites/idle.texture = sprites.idle_dirty
	$player_sprites/sleeping.texture = sprites.sleeping
	$player_sprites/toilet.texture = sprites.seated_dirty
	
	$player_sprites/w1.texture = sprites.walk_dirty.w1
	$player_sprites/w2.texture = sprites.walk_dirty.w2
	$player_sprites/w3.texture = sprites.walk_dirty.w3
	$player_sprites/w4.texture = sprites.walk_dirty.w4
	$player_sprites/w5.texture = sprites.walk_dirty.w5

func set_bath_clothes():
	_set_legacy_player_scale()
	on_bath = true
	
	var sprites = CharacterController.all_sprites.plataform
	
	$player_sprites/idle.texture = sprites.idle_bath
	$player_sprites/sleeping.texture = sprites.sleeping
	
	$player_sprites/w1.texture = sprites.bath.w1
	$player_sprites/w2.texture = sprites.bath.w2
	$player_sprites/w3.texture = sprites.bath.w3
	$player_sprites/w4.texture = sprites.bath.w4
	$player_sprites/w5.texture = sprites.bath.w5

func set_bath_dirty_clothes():
	_set_legacy_player_scale()
	var sprites = CharacterController.all_sprites.plataform
	
	$player_sprites/idle.texture = sprites.idle_bath_dirty
	$player_sprites/sleeping.texture = sprites.sleeping
	
	$player_sprites/w1.texture = sprites.bath_dirty.w1
	$player_sprites/w2.texture = sprites.bath_dirty.w2
	$player_sprites/w3.texture = sprites.bath_dirty.w3
	$player_sprites/w4.texture = sprites.bath_dirty.w4
	$player_sprites/w5.texture = sprites.bath_dirty.w5

func is_playing():
	return Anim_Player.is_playing()

func _on_Area2D_body_entered(body: Node) -> void:
	if(!show_bubble):
		return
	drying = true

func _on_Area2D_body_exited(body: Node) -> void:
	if(!show_bubble):
		return
	drying = false
