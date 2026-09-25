extends HouseRoom

var playing1 = false
var playing2 = false
var playing3 = false
var is_doing_action = false
var WashingHands = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 4
	$sink.set_meta("WashingHands", WashingHands)
	AnimationController.sound_flush = $flush
	AnimationController.toilet_paper = $toiler_paper
	AnimationController.bathroom_animplayer = $AnimationPlayer

func _process(delta: float) -> void:
	if (NecessityBars.higiene <= (NecessityBars.max_higiene*0.2)) and playing1 == false:
		$"banheiro-box/AnimationPlayer".play("scale_in_out")
		if has_node("pia/AnimationPlayer"):
			$pia/AnimationPlayer.play("scale_in_out")
		playing1 = true
	elif (NecessityBars.higiene > (NecessityBars.max_higiene*0.2)) and playing1 != false:
		$"banheiro-box/AnimationPlayer".play("idle")
		if has_node("pia/AnimationPlayer"):
			$pia/AnimationPlayer.play("idle")
		playing1 = false

	if (NecessityBars.bexiga <= (NecessityBars.max_bexiga*0.2)) and playing2 == false:
		$vazo/AnimationPlayer.play("scale_in_out")
		playing2 = true
	elif (NecessityBars.bexiga > (NecessityBars.max_bexiga*0.2)) and playing2 != false:
		$vazo/AnimationPlayer.play("idle")
		playing2 = false
	
	if(NecessityBars.soaked and !playing3):
		$Toalha/AnimationPlayer.play("scale_in_out")
		playing3 = true
	elif(!NecessityBars.soaked and playing3):
		$Toalha/AnimationPlayer.play("idle")
		playing3 = false

func _on_bath_pressed() -> void:
	if is_doing_action:
		print("[Bathroom] Cannot start bath: is_doing_action is already true")
		return
	print("[Bathroom] Starting bath action...")
	is_doing_action = true
	_set_persistent_player_visible(false)
	print("[Bathroom] Player hidden, instantiating minigame...")
	var minigame_banho = load("res://src/UI/Minigame_bath/MiniGame_Banho.tscn").instance()
	#var sprite_do_personagem = CharacterController.personagem_sprite
	add_child(minigame_banho)
	# Add first so MiniGame_Banho's onready nodes (including BathCharacterRig)
	# are initialized before its bath-specific appearance is applied.
	minigame_banho.start(self)
	_set_navigation_menu_visible(false)
	NecessityBars.onbath = true	

func _set_persistent_player_visible(is_visible: bool) -> void:
	var current_scene = get_tree().current_scene
	if current_scene == null:
		return
	var player_container = current_scene.get_node_or_null("Player")
	if player_container != null:
		player_container.visible = is_visible

func _set_navigation_menu_visible(is_visible: bool) -> void:
	var current_scene = get_tree().current_scene
	if current_scene != null and current_scene.has_method("toggle_NM"):
		current_scene.toggle_NM(is_visible)


func finish_bath():
	print("[Bathroom] finish_bath() triggered")
	NecessityBars.bathing = true
	get_viewport().canvas_transform = Transform2D()
	_set_navigation_menu_visible(true)
	if is_instance_valid(AnimationController.anim_player):
		print("[Bathroom] Playing return_from_bath animation...")
		yield(AnimationController.return_from_bath(), "completed")
	else:
		print("[Bathroom] No persistent player animation; skipping return_from_bath.")
	print("[Bathroom] Resetting bath states...")
	NecessityBars.bathing = false
	NecessityBars.onbath = false	
	_set_persistent_player_visible(true)
	is_doing_action = false
	print("[Bathroom] Bath action finalized.")
	

func _on_toilet_pressed() -> void:
	if(NecessityBars.soaked):
		return
	
	NecessityBars.peeing = true
	yield(AnimationController.go_to_toilet(), "completed") 
	

func _on_higienic_paper_pressed():
	if(NecessityBars.use_toilet_paper):
		NecessityBars.use_toilet_paper = false
		yield(AnimationController.return_from_toilet(), "completed")
		# A higiene das mãos vira a próxima ação obrigatória da pia depois
		# que o jogador termina de usar a privada.
		WashingHands = true
		$sink.set_meta("WashingHands", true)
		print("[Bathroom] WashingHands=true: sink now opens hand-washing minigame")

func _on_sink_pressed() -> void:
	if(NecessityBars.soaked):
		return
	if is_doing_action:
		print("[Bathroom] Cannot start sink: is_doing_action is already true")
		return
	print("[Bathroom] Starting sink action...")
	is_doing_action = true

	var minigame_path = "res://src/UI/Minigame_escovar/MiniGame_EscovarDentes.tscn"
	if WashingHands:
		minigame_path = "res://src/UI/Minigame_lavar_maos/MiniGame_LavarMaos.tscn"
		_set_persistent_player_visible(false)

	var minigame = load(minigame_path).instance()
	add_child(minigame)
	minigame.start(self)
	_set_navigation_menu_visible(false)

func finish_escovar():
	print("[Bathroom] finish_escovar() triggered")
	_set_navigation_menu_visible(true)
	is_doing_action = false
	print("[Bathroom] Sink action finalized.")

func finish_washing_hands():
	WashingHands = false
	$sink.set_meta("WashingHands", false)
	_set_persistent_player_visible(true)
	_set_navigation_menu_visible(true)
	# Deixe o toque que concluiu o minigame terminar antes de liberar a pia.
	yield(get_tree().create_timer(0.2), "timeout")
	is_doing_action = false
	print("[Bathroom] WashingHands=false: hand-washing minigame finalized.")
