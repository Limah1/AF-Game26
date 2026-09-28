extends Node

func _ready() -> void:
	CharacterController.configure_faces(["feliz", "invalida", "feliz"], "feliz")
	assert(CharacterController.allowed_faces == ["feliz"])
	assert(CharacterController.expression == ("feliz" if CharacterController.get_face_texture("feliz") != null else "neutro"))
	CharacterController.set_expression("invalida")
	assert(CharacterController.expression == "neutro")
	CharacterController.configure_faces([], "triste")
	assert(CharacterController.allowed_faces == ["neutro"])
	assert(CharacterController.expression == "neutro")
	print("Face system OK")
	get_tree().quit()
