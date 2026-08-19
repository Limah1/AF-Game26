extends Resource
class_name CharacterArmSet

# Arm assets are stored as a pair so left/right art cannot become mismatched.
export(String) var id = ""
export(String) var display_name = ""
export(Texture) var left_texture
export(Texture) var right_texture
export(Color) var tint = Color.white
export(Vector2) var left_position = Vector2.ZERO
export(Vector2) var right_position = Vector2.ZERO
export(Vector2) var left_scale = Vector2.ONE
export(Vector2) var right_scale = Vector2.ONE
export(float) var left_rotation_degrees = 0.0
export(float) var right_rotation_degrees = 0.0
