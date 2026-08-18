extends Node

# Configuração Base do Personagem (escolhida na tela de seleção)
var cabelo_tipo: String = "a"
var genero: String = "boy"
var roupa_tipo: String = "r1"

# Cores
var cor_pele: Color = Color.white
var cor_cabelo: Color = Color.white
var cor_roupa_cima: Color = Color.white
var cor_roupa_baixo: Color = Color.white

# Texturas customizadas globais (puxadas a partir dos PNGs modulares da pasta assets)
var tex_cabeca: Texture
var tex_cabelo: Texture
var tex_tronco: Texture
var tex_braco: Texture
var tex_perna: Texture
var tex_calca: Texture

# Expressões / Texturas especiais
var tex_rosto_dormindo: Texture
var tex_rosto_dor: Texture

func _ready() -> void:
	_load_default_textures()

func _load_default_textures() -> void:
	# Carrega os PNGs modulares base criados anteriormente
	tex_cabeca = load("res://assets/Character_Creator/modular/cabeca.png")
	tex_cabelo = load("res://assets/Character_Creator/modular/cabelo.png")
	tex_tronco = load("res://assets/Character_Creator/modular/tronco.png")
	tex_braco = load("res://assets/Character_Creator/modular/braco.png")
	tex_perna = load("res://assets/Character_Creator/modular/perna.png")
	tex_calca = load("res://assets/Character_Creator/modular/calca.png")
	
	# Fallback temporário para rostos especiais: usando a própria cabeça caso não exista
	tex_rosto_dormindo = load("res://assets/Character_Creator/modular/cabeca.png")
	tex_rosto_dor = load("res://assets/Character_Creator/modular/cabeca.png")

# Função que o CharacterRig vai chamar ao nascer
func apply_to_rig(rig: Node2D) -> void:
	if not rig.has_method("set_skin_color"):
		return
		
	# Passa as cores
	rig.set_skin_color(cor_pele)
	rig.set_hair_color(cor_cabelo)
	rig.set_shirt_color(cor_roupa_cima)
	rig.set_pants_color(cor_roupa_baixo)
	
	# Passa as texturas base
	rig.get_node("Head").texture = tex_cabeca
	rig.get_node("Hair").texture = tex_cabelo
	rig.get_node("Torso").texture = tex_tronco
	rig.get_node("LeftArm").texture = tex_braco
	rig.get_node("RightArm").texture = tex_braco
	rig.get_node("LeftLeg").texture = tex_perna
	rig.get_node("RightLeg").texture = tex_perna
	
	if rig.has_node("Pants"):
		rig.get_node("Pants").texture = tex_calca
