extends Resource
class_name CharacterPart

# Reusable data record for one visual character slot.
export(String) var id = ""
export(String) var display_name = ""
export(String) var gender = "any"
export(Texture) var texture
export(Color) var tint = Color.white
export(Vector2) var position = Vector2.ZERO
export(Vector2) var scale = Vector2.ONE
export(float) var rotation_degrees = 0.0
