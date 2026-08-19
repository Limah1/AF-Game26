extends Resource
class_name CharacterSkinTone

export(String) var id = ""
export(String) var display_name = ""
export(String) var hex_color = "#ffffff"

func get_color() -> Color:
    return Color(hex_color)
