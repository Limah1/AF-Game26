extends Node

const SETTINGS_PATH = "user://audio_settings.cfg"
const BUS_NAMES = ["Master", "Music", "SFX", "Voice"]

var _volumes = {}

func _ready() -> void:
	load_settings()

func set_volume(bus_name: String, value: float) -> void:
	if !BUS_NAMES.has(bus_name):
		push_warning("AudioSettings: bus desconhecido: %s" % bus_name)
		return
	_volumes[bus_name] = clamp(value, 0.0, 1.0)
	_apply_volume(bus_name)

func get_volume(bus_name: String) -> float:
	return float(_volumes.get(bus_name, 1.0))

func load_settings() -> void:
	var config = ConfigFile.new()
	var loaded = config.load(SETTINGS_PATH) == OK
	for bus_name in BUS_NAMES:
		_volumes[bus_name] = clamp(float(config.get_value("audio", bus_name, 1.0)) if loaded else 1.0, 0.0, 1.0)
		_apply_volume(bus_name)

func save_settings() -> void:
	var config = ConfigFile.new()
	for bus_name in BUS_NAMES:
		config.set_value("audio", bus_name, get_volume(bus_name))
	var error = config.save(SETTINGS_PATH)
	if error != OK:
		push_error("AudioSettings: falha ao salvar configurações (%s)" % error)

func _apply_volume(bus_name: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		push_warning("AudioSettings: bus não encontrado: %s" % bus_name)
		return
	var value = get_volume(bus_name)
	AudioServer.set_bus_mute(bus_index, value <= 0.0)
	if value > 0.0:
		AudioServer.set_bus_volume_db(bus_index, linear2db(value))

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()
