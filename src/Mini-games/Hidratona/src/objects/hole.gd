extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$playInHole.texture = CharacterController.all_sprites.hidratona.fall
	
	if(Resources.acessory == "Coat"):
		$playInHole.texture = CharacterController.all_sprites.hidratona.snow.fall
	
	if(Resources.acessory == "Umbrella"):
		$playInHole.texture = CharacterController.all_sprites.hidratona.rain.fall


