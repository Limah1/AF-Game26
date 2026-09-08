extends KinematicBody2D

export var preset_localization: Vector2 = Vector2(1072.176, 473)

var follow = false

func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta: float) -> void:
	if(follow):
		self.visible = true
		# Use the scene's transformed mouse position, like the shower Button
		# does through Godot's UI input handling. Fixed 1920x1080 offsets break
		# dragging when the game window is scaled.
		global_position = get_global_mouse_position()
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

	
