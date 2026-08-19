extends Resource
class_name CharacterPartCatalog

# A catalog is a list of CharacterPart or CharacterArmSet resources.
export(Array, Resource) var entries = []

func get_part(part_id: String) -> Resource:
	for entry in entries:
		if entry != null and entry.id == part_id:
			return entry
	return null

func get_texture(part_id: String) -> Texture:
	var part = get_part(part_id)
	if part != null:
		return part.get("texture")
	return null

func get_part_for_gender(part_id: String, gender_id: String) -> Resource:
	var part = get_part(part_id)
	if part == null:
		return null

	var part_gender = part.get("gender")
	if part_gender == null or part_gender == "" or part_gender == "any" or part_gender == gender_id:
		return part
	return null
