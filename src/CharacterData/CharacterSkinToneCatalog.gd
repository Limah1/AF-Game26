extends Resource
class_name CharacterSkinToneCatalog

export(Array, Resource) var entries = []

func get_tone(tone_id: String) -> Resource:
    for entry in entries:
        if entry != null and entry.id == tone_id:
            return entry
    return null

func get_color(tone_id: String) -> Color:
    var tone = get_tone(tone_id)
    if tone != null:
        return Color(tone.get("hex_color"))
    return Color.white

func get_hex(tone_id: String) -> String:
    var tone = get_tone(tone_id)
    if tone != null:
        return tone.get("hex_color")
    return "#ffffff"
