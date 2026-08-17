extends PopupPanel

onready var DialogText := $MarginContainer/HBoxContainer/Right/DialogText
onready var ButtonsBox := $MarginContainer/HBoxContainer/Right/Buttons
onready var Btn1 := $MarginContainer/HBoxContainer/Right/Buttons/op1
onready var Btn2 := $MarginContainer/HBoxContainer/Right/Buttons/op2
onready var Btn3 := $MarginContainer/HBoxContainer/Right/Buttons/op3
onready var Portrait := $MarginContainer/HBoxContainer/mc/Left/Portrait
onready var NpcName := $MarginContainer/HBoxContainer/mc/Left/NpcName

export(String, FILE, "*.json") var json_path
export(String) var npc_name = "NPC"

var conversation_root := {}
var _current := {}

func _ready():
	print("[DialogSystem] Node initialized: ", name)
	print("[DialogSystem] NPC Name: ", npc_name)
	print("[DialogSystem] JSON Path: ", json_path)

	if NpcName:
		NpcName.text = npc_name

	if json_path != "":
		var f = File.new()
		if f.file_exists(json_path):
			f.open(json_path, File.READ)
			var text_content = f.get_as_text()
			print("[DialogSystem] JSON file loaded successfully. Size: ", text_content.length(), " bytes.")
			var parsed = parse_json(text_content)
			f.close()
			if typeof(parsed) == TYPE_DICTIONARY:
				conversation_root = parsed
				print("[DialogSystem] JSON parsed successfully. Root keys: ", conversation_root.keys())
			else:
				print("[DialogSystem] ERROR: JSON parsed as type ", typeof(parsed), " instead of Dictionary.")
				push_error("JSON inválido em %s" % json_path)
		else:
			print("[DialogSystem] ERROR: File not found at path: ", json_path)
			push_error("Arquivo JSON não encontrado: %s" % json_path)
	else:
		print("[DialogSystem] WARNING: json_path is empty!")

	Btn1.connect("pressed", self, "_on_choice", [1])
	Btn2.connect("pressed", self, "_on_choice", [2])
	Btn3.connect("pressed", self, "_on_choice", [3])

	start_conversation(conversation_root)

func start_conversation(root: Dictionary) -> void:
	_current = root
	_refresh()

func _refresh() -> void:
	if _current.has("texto"):
		DialogText.bbcode_text = str(_current["texto"])

	var opts = [
		_current.get("opcao1", null),
		_current.get("opcao2", null),
		_current.get("opcao3", null)
	]
	var btns = [Btn1, Btn2, Btn3]

	for i in range(3):
		var o = opts[i]
		var b: Button = btns[i]
		if typeof(o) == TYPE_DICTIONARY and o.has("botao"):
			b.text = str(o["botao"])
			b.visible = true
			b.disabled = false
		else:
			b.visible = false

func _on_choice(idx: int) -> void:
	var key := "opcao%d" % idx
	var choice = _current.get(key, null)
	if typeof(choice) != TYPE_DICTIONARY:
		return

	# Os dados de diálogo (assets/dialogos/*.json) só carregam o rótulo do
	# botão, sem um id/flag de ação, então o fluxo é decidido comparando o
	# texto. Normalizamos acentos e maiúsculas/minúsculas para não depender
	# de variantes exatas como "Ate logo" / "Até logo".
	var botao_text = _strip_accents(str(choice.get("botao", "")).strip_edges().to_lower())

	match botao_text:
		"ate logo":
			hide()
			return
		"quero perguntar outra coisa":
			_current = conversation_root
			_refresh()
			return

	# Exibe a resposta do NPC, se houver
	if choice.has("resposta"):
		DialogText.bbcode_text = str(choice["resposta"])
	else:
		DialogText.bbcode_text = ""

	_current = choice
	_refresh()

func _strip_accents(text: String) -> String:
	var accented = ["á","à","ã","â","ä","é","è","ê","ë","í","ì","î","ï","ó","ò","õ","ô","ö","ú","ù","û","ü","ç"]
	var plain    = ["a","a","a","a","a","e","e","e","e","i","i","i","i","o","o","o","o","o","u","u","u","u","c"]
	var result = text
	for i in range(accented.size()):
		result = result.replace(accented[i], plain[i])
	return result
