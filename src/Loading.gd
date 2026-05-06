extends Control

func _ready():
	# Teste Direto: Força status e carrega o Hospital
	AnimationController.status = "Hospital"
	get_tree().change_scene("res://src/Hospital.tscn")
