extends Node

# Data catalogs. Add new head or torso resources without changing gameplay code.
const HEADS = preload("res://data/character/DT_Heads.tres")
const TORSOS = preload("res://data/character/DT_Torsos.tres")
const CHARACTERS = preload("res://data/character/DT_Characters.tres")

# These catalogs intentionally contain one base entry each. Limbs do not vary by gender.
const ARMS = preload("res://data/character/DT_Arms.tres")
const LEGS = preload("res://data/character/DT_Legs.tres")
const HANDS = preload("res://data/character/DT_Hands.tres")

# Kept for callers that still use the old clothes catalog API.
const CLOTHES = preload("res://data/character/DT_Clothes.tres")
const SKIN_TONES = preload("res://data/character/DT_SkinTones.tres")

# Legacy creator fields kept for compatibility with the existing project.
var genero = "boy"
var roupa_tipo = "r1"

# Player selections are IDs, not file paths.
var selected_head_id = "head_boy"
var selected_torso_id = "torso_boy"
var selected_character_id = ""
var selected_arms_id = "arms_basic"
var selected_legs_id = "legs_basic"
var selected_hands_id = "hands_basic"
var selected_clothes_id = "torso_boy"
var selected_skin_tone_id = "skin_01"

# Colors.
var cor_pele = Color.white
var cor_roupa_cima = Color.white
var cor_roupa_baixo = Color.white

# Resolved textures exposed for compatibility with existing test scenes.
var tex_cabeca: Texture
var tex_tronco: Texture
var tex_braco: Texture
var tex_braco_esquerdo: Texture
var tex_braco_direito: Texture
var tex_perna: Texture
var tex_perna_esquerda: Texture
var tex_perna_direita: Texture
var tex_mao: Texture
var tex_mao_esquerda: Texture
var tex_mao_direita: Texture
var tex_calca: Texture

# Special-expression textures.
var tex_rosto_dormindo: Texture
var tex_rosto_dor: Texture

func _ready() -> void:
	_load_legacy_fallbacks()
	_load_selected_parts()

func _load_legacy_fallbacks() -> void:
	tex_cabeca = load("res://assets/Character_Creator/modular/cabeca.png")
	tex_tronco = load("res://assets/Character_Creator/modular/tronco.png")
	tex_braco = load("res://assets/Character_Creator/modular/braco.png")
	tex_braco_esquerdo = tex_braco
	tex_braco_direito = tex_braco
	tex_perna_esquerda = load("res://assets/Character_Creator/modular/New_Assets/New_LegLeft.png")
	tex_perna_direita = tex_perna_esquerda
	tex_perna = tex_perna_esquerda
	tex_mao = tex_braco
	tex_mao_esquerda = tex_mao
	tex_mao_direita = tex_mao
	tex_calca = load("res://assets/Character_Creator/modular/calca.png")
	tex_rosto_dormindo = load("res://assets/Character_Creator/modular/rosto_dormindo.png")
	tex_rosto_dor = tex_cabeca

func _load_selected_parts() -> void:
	set_gender(genero)
	select_arms(selected_arms_id)
	select_legs(selected_legs_id)
	select_hands(selected_hands_id)
	select_skin_tone(selected_skin_tone_id)

func select_character(profile_id: String) -> bool:
	var profile = CHARACTERS.get_profile(profile_id)
	if profile == null:
		return false

	selected_character_id = profile_id
	var profile_gender = profile.get("gender")
	if profile_gender == "boy" or profile_gender == "girl":
		set_gender(profile_gender)
	return true

func get_selected_character_profile() -> Resource:
	if selected_character_id == "":
		return null
	return CHARACTERS.get_profile_for_gender(selected_character_id, genero)

func set_gender(gender_id: String) -> bool:
	if gender_id != "boy" and gender_id != "girl":
		return false

	# A profile is valid only for its own gender. Keep old catalog behavior when
	# menu changes gender without selecting a matching profile.
	if selected_character_id != "":
		var selected_profile = CHARACTERS.get_profile(selected_character_id)
		if selected_profile != null:
			var profile_gender = selected_profile.get("gender")
			if profile_gender != null and profile_gender != "" and profile_gender != "any" and profile_gender != gender_id:
				selected_character_id = ""

	genero = gender_id
	var head_ok = select_head("head_" + gender_id)
	var torso_ok = select_torso("torso_" + gender_id)
	if selected_character_id == "":
		var default_profile = CHARACTERS.get_first_profile_for_gender(gender_id)
		if default_profile != null:
			selected_character_id = default_profile.get("id")
	return head_ok and torso_ok

func select_head(head_id: String) -> bool:
	var part = HEADS.get_part(head_id)
	if part == null or part.get("texture") == null:
		return false

	selected_head_id = head_id
	tex_cabeca = part.get("texture")
	# No dedicated sleep PNG exists yet; use the selected head consistently.
	tex_rosto_dormindo = tex_cabeca
	return true

func select_torso(torso_id: String) -> bool:
	var part = TORSOS.get_part(torso_id)
	if part == null or part.get("texture") == null:
		return false

	selected_torso_id = torso_id
	selected_clothes_id = torso_id
	tex_tronco = part.get("texture")
	return true

func select_arms(arms_id: String) -> bool:
	var part = ARMS.get_part(arms_id)
	if part == null or part.get("left_texture") == null or part.get("right_texture") == null:
		return false

	selected_arms_id = arms_id
	tex_braco_esquerdo = part.get("left_texture")
	tex_braco_direito = part.get("right_texture")
	# Keep the old single-arm field valid for legacy callers.
	tex_braco = tex_braco_esquerdo
	return true

func select_legs(legs_id: String) -> bool:
	var part = LEGS.get_part(legs_id)
	if part == null or part.get("left_texture") == null or part.get("right_texture") == null:
		return false

	selected_legs_id = legs_id
	tex_perna_esquerda = part.get("left_texture")
	tex_perna_direita = part.get("right_texture")
	# Keep the old single-leg field valid for legacy callers.
	tex_perna = tex_perna_esquerda
	return true

func select_hands(hands_id: String) -> bool:
	var part = HANDS.get_part(hands_id)
	if part == null or part.get("left_texture") == null or part.get("right_texture") == null:
		return false

	selected_hands_id = hands_id
	tex_mao_esquerda = part.get("left_texture")
	tex_mao_direita = part.get("right_texture")
	# Keep the old single-hand field valid for legacy callers.
	tex_mao = tex_mao_esquerda
	return true

func select_clothes(clothes_id: String) -> bool:
	# The old test button means "use the current gender's shirt" now.
	if clothes_id == "shirt_test":
		return select_torso("torso_" + genero)

	var part = CLOTHES.get_part(clothes_id)
	if part == null or part.get("texture") == null:
		return false

	selected_torso_id = ""
	selected_clothes_id = clothes_id
	tex_tronco = part.get("texture")
	return true

func select_skin_tone(tone_id: String) -> bool:
	var tone = SKIN_TONES.get_tone(tone_id)
	if tone == null or tone.get("hex_color") == null:
		return false

	selected_skin_tone_id = tone_id
	cor_pele = Color(tone.get("hex_color"))
	return true

func get_skin_tone_color(tone_id: String) -> Color:
	return SKIN_TONES.get_color(tone_id)

func get_skin_tone_hex(tone_id: String) -> String:
	return SKIN_TONES.get_hex(tone_id)

func get_profile_head(variant: String = "default") -> Texture:
	var profile = get_selected_character_profile()
	if profile != null and profile.has_method("get_head"):
		return profile.get_head(variant)
	return null

func get_profile_torso(variant: String = "default") -> Texture:
	var profile = get_selected_character_profile()
	if profile != null and profile.has_method("get_torso"):
		return profile.get_torso(variant)
	return null

func get_profile_torso_scale(variant: String = "default") -> Vector2:
	var profile = get_selected_character_profile()
	if profile != null and profile.has_method("get_torso_scale"):
		return profile.get_torso_scale(variant)
	return Vector2.ZERO

func get_profile_leg(variant: String = "default", side: String = "left") -> Texture:
	var profile = get_selected_character_profile()
	if profile != null and profile.has_method("get_leg"):
		return profile.get_leg(variant, side)
	return null

func apply_to_rig(rig: Node2D, appearance_variant: String = "default") -> void:
	if not rig.has_method("set_skin_color"):
		return

	# Colors still come from the player selection.
	rig.set_skin_color(cor_pele)
	# Bath profile garments (sunga/biquini) already contain their own colors.
	# Preserve those colors; only the fallback nude torso receives skin tint.
	var profile_torso = get_profile_torso(appearance_variant)
	if appearance_variant == "bath" and rig.has_method("set_torso_color"):
		rig.set_torso_color(Color.white if profile_torso != null else cor_pele)
	elif appearance_variant == "hospital" and profile_torso != null and rig.has_method("set_torso_color"):
		rig.set_torso_color(Color.white)
	else:
		rig.set_shirt_color(cor_roupa_cima)
	rig.set_pants_color(cor_roupa_baixo)
	if rig.has_method("set_lower_body_mode"):
		rig.set_lower_body_mode("skin" if appearance_variant == "bath" else "pants")

	var head = HEADS.get_part(selected_head_id)
	if head != null and head.get("texture") != null:
		rig.set_part_visual("Head", head.get("texture"), head.get("position"), head.get("scale"), head.get("rotation_degrees"))
	else:
		rig.set_face_texture(tex_cabeca)

	# Profile textures override only selected face variant. Rig transforms stay
	# unchanged, so existing pivots and pose anchors remain authoritative.
	var profile_head = get_profile_head(appearance_variant)
	if profile_head != null:
		rig.set_face_texture(profile_head)
	elif appearance_variant == "sleeping" and tex_rosto_dormindo != null:
		rig.set_face_texture(tex_rosto_dormindo)
	elif appearance_variant == "sick" and tex_rosto_dor != null:
		rig.set_face_texture(tex_rosto_dor)

	var arms = ARMS.get_part(selected_arms_id)
	if arms != null and arms.get("left_texture") != null and arms.get("right_texture") != null:
		rig.set_arm_visuals(
			arms.get("left_texture"),
			arms.get("right_texture"),
			arms.get("left_position"),
			arms.get("right_position"),
			arms.get("left_scale"),
			arms.get("right_scale"),
			arms.get("left_rotation_degrees"),
			arms.get("right_rotation_degrees")
		)
	else:
		rig.set_arms_texture(tex_braco_esquerdo, tex_braco_direito)

	var legs = LEGS.get_part(selected_legs_id)
	if legs != null and legs.get("left_texture") != null and legs.get("right_texture") != null and rig.has_method("set_leg_visuals"):
		rig.set_leg_visuals(
			legs.get("left_texture"),
			legs.get("right_texture"),
			legs.get("left_position"),
			legs.get("right_position"),
			legs.get("left_scale"),
			legs.get("right_scale"),
			legs.get("left_rotation_degrees"),
			legs.get("right_rotation_degrees")
		)
	else:
		if rig.has_node("LeftLeg"):
			rig.get_node("LeftLeg").texture = tex_perna_esquerda
		if rig.has_node("RightLeg"):
			rig.get_node("RightLeg").texture = tex_perna_direita

	# Profile-specific lower garments override catalog legs only when assigned.
	var profile_left_leg = get_profile_leg(appearance_variant, "left")
	var profile_right_leg = get_profile_leg(appearance_variant, "right")
	if profile_left_leg != null and rig.has_node("LeftLeg"):
		rig.get_node("LeftLeg").texture = profile_left_leg
	if profile_right_leg != null and rig.has_node("RightLeg"):
		rig.get_node("RightLeg").texture = profile_right_leg

	var hands = HANDS.get_part(selected_hands_id)
	if hands != null and hands.get("left_texture") != null and hands.get("right_texture") != null and rig.has_method("set_hand_visuals"):
		rig.set_hand_visuals(
			hands.get("left_texture"),
			hands.get("right_texture"),
			hands.get("left_position"),
			hands.get("right_position"),
			hands.get("left_scale"),
			hands.get("right_scale"),
			hands.get("left_rotation_degrees"),
			hands.get("right_rotation_degrees")
		)
	else:
		if rig.has_node("LeftHand"):
			rig.get_node("LeftHand").texture = tex_mao_esquerda
		if rig.has_node("RightHand"):
			rig.get_node("RightHand").texture = tex_mao_direita

	var torso = TORSOS.get_part(selected_torso_id)
	if torso != null and torso.get("texture") != null:
		rig.set_part_visual("Torso", torso.get("texture"), torso.get("position"), torso.get("scale"), torso.get("rotation_degrees"))
	else:
		var clothes = CLOTHES.get_part(selected_clothes_id)
		if clothes != null and clothes.get("texture") != null:
			rig.set_part_visual("Torso", clothes.get("texture"), clothes.get("position"), clothes.get("scale"), clothes.get("rotation_degrees"))
		else:
			rig.set_clothes_texture(tex_tronco)

	# Profile torso variants override the texture and, when supplied, its
	# normalized scale. State positions remain in CharacterRig.
	if profile_torso != null:
		var profile_torso_scale = get_profile_torso_scale(appearance_variant)
		if profile_torso_scale != Vector2.ZERO and rig.has_method("set_part_visual"):
			rig.set_part_visual("Torso", profile_torso, Vector2.ZERO, profile_torso_scale, 0.0)
		else:
			rig.set_clothes_texture(profile_torso)

	if appearance_variant == "bath" and profile_torso != null and rig.has_method("set_torso_skin_tone"):
		# Boy1's sunga and Girl1's bikini combine skin and garment pixels.
		rig.set_torso_skin_tone(cor_pele)
	elif rig.has_method("clear_torso_skin_tone"):
		rig.clear_torso_skin_tone()

	# Keep legacy Pants node compatible; profile lower legs already applied above.
	if rig.has_node("Pants"):
		rig.get_node("Pants").texture = tex_calca

	# Catalog resources may provide optional visual transforms. The rig's
	# exported state anchors remain authoritative for final member positions.
	if rig.has_method("refresh_pose"):
		rig.refresh_pose()
