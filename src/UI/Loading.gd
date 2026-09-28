extends Control

var loader = ResourceLoader.load_interactive("res://src/MainScreen.tscn")
var dots = 1

func _process(_delta):
	if loader == null:
		set_process(false)
		return
	var result = loader.poll()
	if result == ERR_FILE_EOF:
		set_process(false)
		get_tree().change_scene_to(loader.get_resource())
	elif result != OK:
		set_process(false)
		push_error("Falha ao carregar MainScreen.tscn: %s" % result)

func _on_Timer_timeout():
	dots = dots % 3 + 1
	$Label.text = "Carregando" + ["", ".", "..", "..."][dots]
