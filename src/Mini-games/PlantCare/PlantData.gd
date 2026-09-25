extends Resource
class_name PlantData

export(String) var id = ""
export(String) var display_name = "Planta"
export(Texture) var icon
export(Array, Texture) var stage_sprites = []
export(Color) var flower_color = Color.white
export(int, 0, 100000) var plant_cost = 5
export(int, 0, 100000) var sell_value = 10
export(float, 0.1, 30.0, 0.1) var watering_seconds = 3.0
export(float, 0.0, 3600.0, 0.5) var wait_seconds = 10.0


func get_stage_texture(stage: int) -> Texture:
	if stage >= 0 and stage < stage_sprites.size() and stage_sprites[stage] != null:
		return stage_sprites[stage]
	return icon


func create_stage_material(stage: int) -> ShaderMaterial:
	if stage < 2:
		return null
	var material := ShaderMaterial.new()
	material.shader = preload("res://src/Mini-games/PlantCare/flower_tint.shader")
	material.set_shader_param("petal_color", flower_color)
	return material
