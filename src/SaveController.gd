extends Node

func _notification(what: int) -> void:
	if what == 1006 or what == 1007 or what == 1005:
		save_game()

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func file_exist():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false # Error! We don't have a save to load.
	
	return true

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false # Error! We don't have a save to load.

	save_game.open("user://savegame.save", File.READ)
	
	var node_data2 = parse_json(save_game.get_line())
	
	if node_data2 == null:
		return false
	
	NecessityBars.higiene = node_data2.higiene
	NecessityBars.bexiga = node_data2.bexiga
	NecessityBars.banheiro = node_data2.banheiro
	NecessityBars.fome = node_data2.fome
	NecessityBars.diversao = node_data2.diversao
	NecessityBars.energia = node_data2.energia
	
	var node_data1 = parse_json(save_game.get_line())
	
	if node_data1 == null:
		return false
		
	CharacterController.boyorgirl = node_data1.boyorgirl
	GlobalResource.set_gender(CharacterController.boyorgirl)
	CharacterController.glass = node_data1.glass
	CharacterController.variation = node_data1.variation

	var node_data3 = parse_json(save_game.get_line())
	
	if node_data3 == null:
		return false
		
	AnimationController.status = node_data3.status
	
	CharacterController.start()
	save_game.close()
	
	return true
