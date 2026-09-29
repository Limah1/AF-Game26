extends Node

# Variáveis p armazenar os dados do personagem (Tela 1)
var cabelo: String = ""
var genero: String = ""
var cor_pele: String = ""
var tom_pele_id: String = ""
# Variáveis p armazenar os dados do personagem (Tela 2)
var roupa: String = ""
var cor_roupa_cima: String = ""
var cor_roupa_baixo: String = ""



func _ready() -> void:
	add_to_group("Persist")

func save():
	var save_dict = {
		"filename": "NewCharData", 
		"cabelo": cabelo,
		"genero": genero,
		"cor_pele": cor_pele,
		"tom_pele_id": tom_pele_id,
		"roupa": roupa,
		"cor_roupa_cima": cor_roupa_cima,
		"cor_roupa_baixo": cor_roupa_baixo
	}
	
	return save_dict
