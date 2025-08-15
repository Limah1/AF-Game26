extends KinematicBody2D

var drying = false
var dirty = false
var show_bubble = false
var sleeping = false

var timer = 0.0
var last_weather = ""
var on_bath = false

onready var Anim_Player = $AnimationPlayer

func _ready() -> void:
	set_normal_clothes()

func Walk_to_Right():
	$player_sprites.scale.x = 2.3
	Anim_Player.play("walk")

func Walk_to_Left():
	$player_sprites.scale.x = -2.3
	Anim_Player.play("walk")

func Idle():
	$player_sprites.scale.x = 2.3
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
		$player_sprites.position.y = -268
		if(on_bath):
			set_bath_dirty_clothes()
			return
		set_normal_dirty_clothes()
	else:
		$player_sprites.position.y = -212
		
		if(on_bath):
			set_bath_clothes()
			return
		set_normal_clothes()
		
func set_normal_clothes():
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
