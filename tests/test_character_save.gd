extends SceneTree

const SAVE_PATH = "user://test_character_save.save"

func _init() -> void:
	call_deferred("_check_save")

func _check_save() -> void:
	var data = get_root().get_node("NewCharData")
	var controller = get_root().get_node("CharacterController")
	var modular = get_root().get_node("ModularCharacterData")
	var saver = get_root().get_node("SaveController")
	var file = File.new()
	assert(file.open(SAVE_PATH, File.WRITE) == OK)
	file.store_string("existing save")
	file.close()
	data.roupa = ""
	saver.save_game(SAVE_PATH)
	assert(file.open(SAVE_PATH, File.READ) == OK)
	assert(file.get_as_text() == "existing save")
	file.close()
	data.genero = "girl"
	data.cabelo = "b"
	data.tom_pele_id = "skin_04"
	data.cor_pele = modular.get_skin_tone_hex(data.tom_pele_id)
	data.roupa = "r2"
	data.cor_roupa_cima = "#ed1b24"
	data.cor_roupa_baixo = "#724530"
	controller.start()
	saver.save_game(SAVE_PATH)
	assert(file.open(SAVE_PATH, File.READ) == OK)
	var records = []
	while not file.eof_reached():
		var line = file.get_line()
		if line != "":
			records.append(line)
	file.close()
	assert(records.size() == 4)
	records.invert()
	assert(file.open(SAVE_PATH, File.WRITE) == OK)
	for record in records:
		file.store_line(record)
	file.close()
	data.genero = "boy"
	data.cabelo = "a"
	data.tom_pele_id = "skin_01"
	data.cor_pele = "#ffffff"
	data.roupa = "r1"
	data.cor_roupa_cima = "#ffffff"
	data.cor_roupa_baixo = "#ffffff"
	assert(saver.load_game(SAVE_PATH))
	assert(data.genero == "girl" and controller.genero == "girl")
	assert(data.cabelo == "b" and controller.cabelo == "b")
	assert(controller.get_legacy_head_texture().resource_path.ends_with("/Menina/girl2.png"))
	assert(data.tom_pele_id == "skin_04" and modular.selected_skin_tone_id == "skin_04")
	assert(data.cor_pele == "#ba8f67" and modular.cor_pele == Color("#ba8f67"))
	assert(data.roupa == "r2" and controller.roupa == "r2" and modular.roupa_tipo == "r2")
	assert(controller.cor_roupa_cima == "#ed1b24" and modular.cor_roupa_cima == Color("#ed1b24"))
	assert(controller.cor_roupa_baixo == "#724530" and modular.cor_roupa_baixo == Color("#724530"))
	assert(file.open(SAVE_PATH, File.WRITE) == OK)
	for record in records:
		var old_record = parse_json(record)
		if old_record.filename == "NewCharData":
			old_record.erase("tom_pele_id")
		file.store_line(to_json(old_record))
	file.close()
	data.tom_pele_id = ""
	modular.select_skin_tone("skin_01")
	assert(saver.load_game(SAVE_PATH))
	assert(data.tom_pele_id == "skin_04" and modular.selected_skin_tone_id == "skin_04")
	Directory.new().remove(SAVE_PATH)
	print("Character save OK")
	quit()
