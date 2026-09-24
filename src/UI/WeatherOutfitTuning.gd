extends Resource
class_name WeatherOutfitTuning

export(float, 0.1, 3.0, 0.01) var outfit_scale = 0.75
export(Dictionary) var head_positions = {
	"boy-a": Vector2(-5, -22),
	"boy-b": Vector2(-5, -18),
	"girl-a": Vector2(-5, -32),
	"girl-b": Vector2(-5, -14)
}
export(Dictionary) var head_scales = {
	"boy-a": 0.2268,
	"boy-b": 0.2268,
	"girl-a": 0.2268,
	"girl-b": 0.2268
}
export(Dictionary) var normal_head_positions = {
	"boy-a": Vector2(10, -107),
	"boy-b": Vector2(10, -107),
	"girl-a": Vector2(10, -107),
	"girl-b": Vector2(10, -107)
}
export(Dictionary) var normal_head_scales = {
	"boy-a": 0.2268,
	"boy-b": 0.2268,
	"girl-a": 0.2268,
	"girl-b": 0.2268
}
export(Dictionary) var normal_r2_head_positions = {
	"boy-a": Vector2(20, -37),
	"boy-b": Vector2(20, -37),
	"girl-a": Vector2(20, -37),
	"girl-b": Vector2(20, -37)
}
export(Dictionary) var normal_r2_head_scales = {
	"boy-a": 0.2268,
	"boy-b": 0.2268,
	"girl-a": 0.2268,
	"girl-b": 0.2268
}
export(Dictionary) var normal_neck_offsets = {
	"r1-boy": Vector2(-23, 28),
	"r1-girl": Vector2(-23, 28),
	"r2-boy": Vector2(-23, 28),
	"r2-girl": Vector2(-23, 28)
}
export(Dictionary) var normal_neck_sizes = {
	"r1-boy": Vector2(46, 45),
	"r1-girl": Vector2(46, 45),
	"r2-boy": Vector2(46, 45),
	"r2-girl": Vector2(46, 45)
}

func get_head_position(gender: String, hair: String) -> Vector2:
	return head_positions.get("%s-%s" % [gender, hair], Vector2(-5, -22))

func get_head_scale(gender: String, hair: String) -> float:
	return float(head_scales.get("%s-%s" % [gender, hair], 0.2268))

func get_normal_head_position(gender: String, hair: String, variation = "r1") -> Vector2:
	var positions = normal_r2_head_positions if variation == "r2" else normal_head_positions
	var fallback = Vector2(20, -37) if variation == "r2" else Vector2(10, -107)
	return positions.get("%s-%s" % [gender, hair], fallback)

func get_normal_head_scale(gender: String, hair: String, variation = "r1") -> float:
	var scales = normal_r2_head_scales if variation == "r2" else normal_head_scales
	return float(scales.get("%s-%s" % [gender, hair], 0.2268))

func get_normal_neck_offset(variation: String, gender: String) -> Vector2:
	return normal_neck_offsets.get("%s-%s" % [variation, gender], Vector2(-23, 28))

func get_normal_neck_size(variation: String, gender: String) -> Vector2:
	return normal_neck_sizes.get("%s-%s" % [variation, gender], Vector2(46, 45))
