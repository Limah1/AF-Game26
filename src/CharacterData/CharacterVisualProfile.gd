extends Resource
class_name CharacterVisualProfile

# Scales normalize each garment's visible PNG bounds to CamisaTest.png at
# the catalog torso scale (0.07). The source garments do not share a canvas.
const NORMALIZED_BATH_TORSO_SCALE = Vector2(0.2637, 0.0848)
const NORMALIZED_HOSPITAL_TORSO_SCALE = Vector2(0.1343, 0.1166)
const FALLBACK_GIRL_BATH_TORSO = preload("res://assets/Character_Creator/modular/New_Assets/biquini.png")
const FALLBACK_BOY_BATH_TORSO = preload("res://assets/Character_Creator/modular/New_Assets/sunga.png")
const FALLBACK_HOSPITAL_TORSO = preload("res://assets/Character_Creator/modular/New_Assets/CamisaHospital.png")

# One selectable character profile. Each profile keeps all face, torso, and
# lower-body variants together so scenes can change one visual slot without
# changing persistent player data.
export(String) var id = ""
export(String) var display_name = ""
export(String) var gender = "any"

export(Texture) var head
export(Texture) var sleeping_head
export(Texture) var sick_head

export(Texture) var torso
export(Texture) var running_torso
export(Texture) var bath_torso
export(Texture) var swimwear_torso
export(Texture) var swimwear_left_leg
export(Texture) var swimwear_right_leg
export(Texture) var hospital_torso
export(Texture) var hospital_left_leg
export(Texture) var hospital_right_leg

# Optional per-variant scales. Vector2.ZERO keeps the selected catalog scale.
export(Vector2) var torso_scale = Vector2.ZERO
export(Vector2) var running_torso_scale = Vector2.ZERO
export(Vector2) var bath_torso_scale = NORMALIZED_BATH_TORSO_SCALE
export(Vector2) var swimwear_torso_scale = NORMALIZED_BATH_TORSO_SCALE
export(Vector2) var hospital_torso_scale = NORMALIZED_HOSPITAL_TORSO_SCALE

func get_head(variant: String = "default") -> Texture:
	if variant == "sleeping" and sleeping_head != null:
		return sleeping_head
	if variant == "sick" and sick_head != null:
		return sick_head
	return head

func get_torso(variant: String = "default") -> Texture:
	if variant == "running" and running_torso != null:
		return running_torso
	if variant == "bath":
		# Bath uses a dedicated garment when available. Otherwise reuse the
		# profile's swimwear (sunga/biquini) instead of falling back to a shirt.
		if bath_torso != null:
			return bath_torso
		if swimwear_torso != null:
			return swimwear_torso
		# Keep the profile usable if an older DT_Characters resource is loaded.
		return FALLBACK_GIRL_BATH_TORSO if gender == "girl" else FALLBACK_BOY_BATH_TORSO
	if (variant == "swimwear" or variant == "swim") and swimwear_torso != null:
		return swimwear_torso
	if variant == "hospital" and hospital_torso != null:
		return hospital_torso
	if variant == "hospital":
		return FALLBACK_HOSPITAL_TORSO
	return torso

func get_torso_scale(variant: String = "default") -> Vector2:
	if variant == "running" and running_torso != null and running_torso_scale != Vector2.ZERO:
		return running_torso_scale
	if variant == "bath":
		if bath_torso != null:
			return bath_torso_scale if bath_torso_scale != Vector2.ZERO else NORMALIZED_BATH_TORSO_SCALE
		if swimwear_torso != null:
			return swimwear_torso_scale if swimwear_torso_scale != Vector2.ZERO else NORMALIZED_BATH_TORSO_SCALE
		return NORMALIZED_BATH_TORSO_SCALE
	if (variant == "swimwear" or variant == "swim") and swimwear_torso_scale != Vector2.ZERO:
		return swimwear_torso_scale
	if (variant == "swimwear" or variant == "swim") and swimwear_torso != null:
		return NORMALIZED_BATH_TORSO_SCALE
	if variant == "hospital":
		return hospital_torso_scale if hospital_torso_scale != Vector2.ZERO else NORMALIZED_HOSPITAL_TORSO_SCALE
	if torso != null and torso_scale != Vector2.ZERO:
		return torso_scale
	return Vector2.ZERO

func get_leg(variant: String = "default", side: String = "left") -> Texture:
	# Swimwear/hospital lower parts stay paired to profile, matching rig sides.
	if variant == "swimwear" or variant == "swim":
		return swimwear_left_leg if side == "left" else swimwear_right_leg
	if variant == "hospital":
		return hospital_left_leg if side == "left" else hospital_right_leg
	return null
