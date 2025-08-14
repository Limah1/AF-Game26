extends Node2D

export(float) var ground_y = 940.0
export(float) var air_y = 600.0

var circle_scene = preload("res://src/Mini-games/Hidratona/src/temp/obstacles/CircleObstacle.tscn")
var trash_scene = preload("res://src/Mini-games/Hidratona/src/temp/obstacles/TrashCanObstacle.tscn")
var bug_scene = preload("res://src/Mini-games/Hidratona/src/temp/obstacles/BugObstacle.tscn")

var patterns = [
	{"width": 400, "prob": 1.0, "items": [{"scene": circle_scene, "x_ratio": 0.3, "y": ground_y}]},
	{"width": 500, "prob": 0.5, "items": [{"scene": trash_scene, "x_ratio": 0.5, "y": ground_y}]},
	{"width": 600, "prob": 1.0, "items": [
		{"scene": circle_scene, "x_ratio": 0.3, "y": ground_y},
		{"scene": bug_scene, "x_ratio": 0.7, "y": funcref(self, "choose_bug_y")}
	]}
]

var next_spawn_x = 1920.0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func spawn_block():
	var pattern = pick_pattern()
	for item in pattern["items"]:
		var inst = item["scene"].instance()
		var x = next_spawn_x + pattern["width"] * item["x_ratio"]
		var y = item["y"]
		if y is FuncRef:
			y = y.call_func()
		inst.position = Vector2(x, y)
		add_child(inst)
	next_spawn_x += pattern["width"]

func pick_pattern():
	var total = 0.0
	for p in patterns:
		total += p["prob"]
	var r = rng.randf() * total
	for p in patterns:
		r -= p["prob"]
		if r <= 0:
			return p
	return patterns[patterns.size() - 1]

func choose_bug_y():
	# Use if-else instead of ternary operator for Godot 3.x
	if rng.randf() < 0.5:
		return ground_y
	else:
		return air_y


func _on_SpawnTimer_timeout():
	spawn_block()

