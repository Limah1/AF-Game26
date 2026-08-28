extends Resource
class_name CharacterVisualCatalog

export(Array, Resource) var entries = []

func get_profile(profile_id: String) -> Resource:
	for entry in entries:
		if entry != null and entry.get("id") == profile_id:
			return entry
	return null

func get_profile_for_gender(profile_id: String, gender_id: String) -> Resource:
	var profile = get_profile(profile_id)
	if profile == null:
		return null

	var profile_gender = profile.get("gender")
	if profile_gender == null or profile_gender == "" or profile_gender == "any" or profile_gender == gender_id:
		return profile
	return null

func get_first_profile_for_gender(gender_id: String) -> Resource:
	for entry in entries:
		if entry == null:
			continue
		var profile_gender = entry.get("gender")
		if profile_gender == null or profile_gender == "" or profile_gender == "any" or profile_gender == gender_id:
			return entry
	return null
