extends HouseRoom

var playing1 = false
var playing2 = false
var playing3 = false
var is_doing_action = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 4
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
	yield(AnimationController.go_to_bath(), "completed") 
	print("[Bathroom] Character reached bath, instantiating minigame...")
	var minigame_banho = load("res://src/UI/Minigame_bath/MiniGame_Banho.tscn").instance()
	#var sprite_do_personagem = CharacterController.personagem_sprite
	minigame_banho.start(self)
	add_child(minigame_banho)
	get_tree().current_scene.toggle_NM(false)
	NecessityBars.onbath = true	


func finish_bath():
	print("[Bathroom] finish_bath() triggered")
	NecessityBars.bathing = true
	get_viewport().canvas_transform = Transform2D()
	get_tree().current_scene.toggle_NM(true)
	print("[Bathroom] Playing return_from_bath animation...")
	yield(AnimationController.return_from_bath(), "completed") 
	print("[Bathroom] return_from_bath completed, resetting states...")
	NecessityBars.bathing = false
	NecessityBars.onbath = false	
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
		AnimationController.return_from_toilet()

func _on_sink_pressed() -> void:
	if(NecessityBars.soaked):
		return
	if is_doing_action:
		print("[Bathroom] Cannot start sink: is_doing_action is already true")
		return
	print("[Bathroom] Starting sink action (escovar dentes)...")
	is_doing_action = true
	
	var minigame_escovar = load("res://src/UI/Minigame_escovar/MiniGame_EscovarDentes.tscn").instance()
	minigame_escovar.start(self)
	add_child(minigame_escovar)
	get_tree().current_scene.toggle_NM(false)

func finish_escovar():
	print("[Bathroom] finish_escovar() triggered")
	get_tree().current_scene.toggle_NM(true)
	is_doing_action = false
	print("[Bathroom] Sink action finalized.")
