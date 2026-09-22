extends Node2D

# Compatibilidade para cenas/abas antigas do editor.
func _ready() -> void:
	get_tree().change_scene("res://src/Mini-games/PlantCare/PlantCareMenu.tscn")
