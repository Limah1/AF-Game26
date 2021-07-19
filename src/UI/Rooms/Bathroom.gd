extends Room

var playing1 = false
var playing2 = false
var playing3 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id = 4

func _process(delta: float) -> void:
	if (NecessityBars.higiene <= (NecessityBars.max_higiene*0.2)) and playing1 == false:
		$"banheiro-box/AnimationPlayer".play("scale_in_out")
		playing1 = true
	elif (NecessityBars.higiene > (NecessityBars.max_higiene*0.2)) and playing1 != false:
		$"banheiro-box/AnimationPlayer".play("idle")
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
	yield(AnimationController.go_to_bath(), "completed") 
	var minigame_banho = load("res://src/UI/Minigame_bath/MiniGame_Banho.tscn").instance()
	minigame_banho.start(self)
	add_child(minigame_banho)
	get_tree().current_scene.toggle_NM()
	NecessityBars.onbath = true	


func finish_bath():
	NecessityBars.bathing = true
	get_tree().current_scene.toggle_NM()
	yield(AnimationController.return_from_bath(), "completed") 
	NecessityBars.bathing = false
	NecessityBars.onbath = false	
	

func _on_toilet_pressed() -> void:
	if(NecessityBars.soaked):
		return
	
	NecessityBars.peeing = true
	yield(AnimationController.go_to_toilet(), "completed") 
