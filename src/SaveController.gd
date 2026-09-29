extends Node

var cabelo
var genero
var cor_pele
var roupa
var cor_roupa_cima
var cor_roupa_baixo


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST or what == NOTIFICATION_WM_FOCUS_OUT:
		save_game()

func save_game(path: String = "user://savegame.save"):
	if NewCharData.cabelo == "" or NewCharData.genero == "" or NewCharData.cor_pele == "" or NewCharData.roupa == "":
		return
	var save_game = File.new()
	if save_game.open(path, File.WRITE) != OK:
		return
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	print(save_nodes)
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

func load_game(path: String = "user://savegame.save"):
	var save_game = File.new()
	if not save_game.file_exists(path):
		return false # Error! We don't have a save to load.
	if save_game.open(path, File.READ) != OK:
		return false
	var records = {}
	while not save_game.eof_reached():
		var line = save_game.get_line()
		if line == "":
			continue
		var record = parse_json(line)
		if typeof(record) == TYPE_DICTIONARY and record.has("filename"):
			records[record.filename] = record
	save_game.close()
	for name in ["NecessityManager", "CharacterController", "AnimationController", "NewCharData"]:
		if not records.has(name):
			return false
	var node_data2 = records.NecessityManager
	var node_data1 = records.CharacterController
	var node_data3 = records.AnimationController
	var char_data_dict = records.NewCharData
	for key in ["higiene", "bexiga", "fome", "diversao", "energia"]:
		if not node_data2.has(key):
			return false
	for key in ["boyorgirl", "glass", "variation"]:
		if not node_data1.has(key):
			return false
	if not node_data3.has("status"):
		return false
	for key in ["cabelo", "genero", "cor_pele", "roupa", "cor_roupa_cima", "cor_roupa_baixo"]:
		if not char_data_dict.has(key):
			return false
	
	NecessityBars.higiene = node_data2.higiene
	NecessityBars.bexiga = node_data2.bexiga
	NecessityBars.fome = node_data2.fome
	NecessityBars.diversao = node_data2.diversao
	NecessityBars.energia = node_data2.energia
	
	CharacterController.boyorgirl = node_data1.boyorgirl
	GlobalResource.set_gender(CharacterController.boyorgirl)
	CharacterController.glass = node_data1.glass
	CharacterController.variation = node_data1.variation

	AnimationController.status = node_data3.status
	
	# Atribui os valores de volta ao seu Singleton NewCharData
	NewCharData.cabelo = char_data_dict.cabelo
	NewCharData.genero = char_data_dict.genero
	NewCharData.cor_pele = char_data_dict.cor_pele
	NewCharData.tom_pele_id = char_data_dict.get("tom_pele_id", "")
	NewCharData.roupa = char_data_dict.roupa
	NewCharData.cor_roupa_cima = char_data_dict.cor_roupa_cima
	NewCharData.cor_roupa_baixo = char_data_dict.cor_roupa_baixo
	
	#CharacterController.apply_loaded_data() #11/08/25
	CharacterController.start()
	
	return true


