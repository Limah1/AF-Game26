extends Resource

const STATES = ["parado", "dores", "febre", "ferimento", "frio", "nervoso", "cansado", "erro"]

export(Dictionary) var head_positions = {}
export(Dictionary) var head_scales = {}
export(Dictionary) var body_scales = {}
export(Dictionary) var neck_offsets = {}
export(Dictionary) var neck_sizes = {}

func head_key(state: String) -> String:
	return "%s-%s-%s" % [state, CharacterController.boyorgirl, CharacterController.cabelo]

func get_head_position(state: String) -> Vector2:
	return head_positions.get(head_key(state), Vector2(0, -43))

func get_head_scale(state: String) -> float:
	return head_scales.get(head_key(state), 0.094)

func get_body_scale(state: String) -> float:
	return body_scales.get(state, 1.0)

func get_neck_offset(state: String) -> Vector2:
	return neck_offsets.get(state, Vector2(-6, 27))

func get_neck_size(state: String) -> Vector2:
	return neck_sizes.get(state, Vector2(12, 12))
