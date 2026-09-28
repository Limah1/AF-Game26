extends SceneTree

func _init():
	call_deferred("_run")

func _run():
	var layer = CanvasLayer.new()
	layer.set_script(load("res://src/UI/Pause.gd"))
	var panel = Control.new()
	panel.name = "Pause"
	panel.hide()
	layer.add_child(panel)
	get_root().add_child(layer)

	layer._on_TextureButton_pressed()
	assert(panel.visible and paused)
	layer._on_TextureButton_pressed()
	assert(not panel.visible and not paused)
	paused = true
	layer._on_TextureButton_pressed()
	assert(not panel.visible and paused)
	paused = false
	layer.free()
	quit()
