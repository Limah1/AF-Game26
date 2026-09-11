extends Node

signal voice_started(path)
signal voice_finished(path)

var enabled = true
var _player: AudioStreamPlayer
var _current_path = ""

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.name = "VoicePlayer"
	_player.bus = "voice"
	add_child(_player)
	_player.connect("finished", self, "_on_voice_finished")

func play_path(path: String) -> bool:
	stop()

	if !enabled or path.strip_edges() == "":
		return false

	if !ResourceLoader.exists(path):
		return false

	var stream = load(path)
	if stream == null or !(stream is AudioStream):
		push_warning("VoiceManager: áudio inválido: %s" % path)
		return false

	_player.stream = stream
	_current_path = path
	_player.play()
	emit_signal("voice_started", path)
	return true

func play_first_available(paths: Array) -> bool:
	stop()
	for path in paths:
		if typeof(path) == TYPE_STRING and ResourceLoader.exists(path):
			return play_path(path)
	return false

func stop() -> void:
	if _player != null and _player.playing:
		_player.stop()
	_current_path = ""

func is_playing() -> bool:
	return _player != null and _player.playing

func get_current_path() -> String:
	return _current_path

func _on_voice_finished() -> void:
	var finished_path = _current_path
	_current_path = ""
	emit_signal("voice_finished", finished_path)
