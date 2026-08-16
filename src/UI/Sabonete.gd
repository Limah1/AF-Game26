extends KinematicBody2D

export var preset_localization: Vector2 = Vector2(1072.176, 473)

var follow = false

func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta: float) -> void:
	if(follow):
		self.visible = true
		global_position = get_viewport().get_mouse_position()
		global_position.y -= 1620 + 540
		global_position.x -= 1920/2
	elif(!follow):
		position = preset_localization
		self.visible = true		


func _on_Press_button_down() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	
	z_index = 20
	
	follow = true

func _on_Press_button_up() -> void:
	
	$CollisionShape2D.set_deferred("disabled", true)
	follow = false

	
