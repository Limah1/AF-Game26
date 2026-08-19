extends Node

# Data catalogs. Add new head or torso resources without changing gameplay code.
const HEADS = preload("res://data/character/DT_Heads.tres")
const TORSOS = preload("res://data/character/DT_Torsos.tres")

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
	tex_perna_esquerda = load("res://assets/Character_Creator/modular/pernaesquerda.png")
	tex_perna_direita = load("res://assets/Character_Creator/modular/pernadireita.png")
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

func set_gender(gender_id: String) -> bool:
	if gender_id != "boy" and gender_id != "girl":
		return false

	genero = gender_id
	var head_ok = select_head("head_" + gender_id)
	var torso_ok = select_torso("torso_" + gender_id)
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

func apply_to_rig(rig: Node2D) -> void:
	if not rig.has_method("set_skin_color"):
		return

	# Colors still come from the player selection.
	rig.set_skin_color(cor_pele)
	rig.set_shirt_color(cor_roupa_cima)
	rig.set_pants_color(cor_roupa_baixo)

	var head = HEADS.get_part(selected_head_id)
	if head != null and head.get("texture") != null:
		rig.set_part_visual("Head", head.get("texture"), head.get("position"), head.get("scale"), head.get("rotation_degrees"))
	else:
		rig.set_face_texture(tex_cabeca)

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

	# Pants keep their legacy resource until a pants catalog is added.
	if rig.has_node("Pants"):
		rig.get_node("Pants").texture = tex_calca
