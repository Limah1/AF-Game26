extends Control

const SLIDERS = {
	"Master": "Panel/Margin/VBox/MasterControl/Master",
	"Music": "Panel/Margin/VBox/MusicControl/Music",
	"SFX": "Panel/Margin/VBox/SFXControl/SFX",
	"Voice": "Panel/Margin/VBox/VoiceControl/Voice"
}
const LABELS = {
	"Master": "Panel/Margin/VBox/MasterLabel",
	"Music": "Panel/Margin/VBox/MusicLabel",
	"SFX": "Panel/Margin/VBox/SFXLabel",
	"Voice": "Panel/Margin/VBox/VoiceLabel"
}
const BARS = {
	"Master": "Panel/Margin/VBox/MasterControl/Fill",
	"Music": "Panel/Margin/VBox/MusicControl/Fill",
	"SFX": "Panel/Margin/VBox/SFXControl/Fill",
	"Voice": "Panel/Margin/VBox/VoiceControl/Fill"
}
const TITLES = {
	"Master": "Geral",
	"Music": "Trilha sonora",
	"SFX": "SFX",
	"Voice": "Dublagem"
}

var _syncing = false

func _ready() -> void:
	for bus_name in SLIDERS:
		get_node(SLIDERS[bus_name]).connect("value_changed", self, "_on_volume_changed", [bus_name])
	_sync_sliders()

func open() -> void:
	_sync_sliders()
	show()

func close() -> void:
	AudioSettings.save_settings()
	hide()

func _sync_sliders() -> void:
	_syncing = true
	for bus_name in SLIDERS:
		var percent = AudioSettings.get_volume(bus_name) * 100.0
		get_node(SLIDERS[bus_name]).value = percent
		get_node(BARS[bus_name]).value = percent
		_update_label(bus_name, percent)
	_syncing = false

func _on_volume_changed(value: float, bus_name: String) -> void:
	if !_syncing:
		AudioSettings.set_volume(bus_name, value / 100.0)
		get_node(BARS[bus_name]).value = value
		_update_label(bus_name, value)

func _update_label(bus_name: String, value: float) -> void:
	get_node(LABELS[bus_name]).text = "%s: %d%%" % [TITLES[bus_name], int(round(value))]

func _on_close_pressed() -> void:
	close()
