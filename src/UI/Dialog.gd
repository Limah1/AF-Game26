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
var _waiting_next = null 

func _ready():
	if NpcName:
		NpcName.text = npc_name

	if json_path != "":
		var f = File.new()
		if f.file_exists(json_path):
			f.open(json_path, File.READ)
			var parsed = parse_json(f.get_as_text())
			f.close()
			if typeof(parsed) == TYPE_DICTIONARY:
				conversation_root = parsed
			else:
				push_error("JSON inválido em %s" % json_path)
		else:
			push_error("Arquivo JSON não encontrado: %s" % json_path)

	Btn1.connect("pressed", self, "_on_choice", [1])
	Btn2.connect("pressed", self, "_on_choice", [2])
	Btn3.connect("pressed", self, "_on_choice", [3])

	start_conversation(conversation_root)

func start_conversation(root: Dictionary) -> void:
	_current = root
	_waiting_next = null
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

	var botao_text = str(choice.get("botao", "")).strip_edges()

	match botao_text:
		"Ate logo", "Até logo":
			hide()
			return
		"Quero perguntar outra coisa":
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

func _input(event):
	if _waiting_next and event.is_action_pressed("ui_accept"):
		_current = _waiting_next
		_waiting_next = null
		_refresh()
