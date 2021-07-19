extends Node2D

var current_room

func _ready() -> void:
	CharacterController.player_ref = $Player/Player
	
	AnimationController.set_animation_player($Player/AnimationPlayer)
	
	if(AnimationController.status == "Started" or AnimationController.status == "MainGame" or AnimationController.status == "DoiAqui"):
		$Slots.start(1)
	elif(AnimationController.status == "Match3"):
		$Slots.start(2)
	elif(AnimationController.status == "Hidratona"):
		$Slots.start(0)
	elif(AnimationController.status == "Sleeping"):
		$Slots.start(3)
	
	AnimationController.status = "Started"

func _process(delta: float) -> void:
	current_room = $Slots/Slot1.current_room
	AnimationController.current_room = $Slots/Slot1.current_room

func toggle_NM():
	$NecessityManager.layer *= -1
