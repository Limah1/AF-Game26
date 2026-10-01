extends Node

# Run with MATCH3_SOAK_SECONDS=1800 for the full session, including on Android.
var frame_times = []

func _process(delta):
	frame_times.append(delta)

func _ready():
	call_deferred("_run")

func _metrics(board, label: String) -> void:
	frame_times.sort()
	var median_ms = frame_times[frame_times.size() / 2] * 1000 if not frame_times.empty() else 0.0
	print("MATCH3_METRICS ", label, " nodes=", Performance.get_monitor(Performance.OBJECT_NODE_COUNT), " objects=", Performance.get_monitor(Performance.OBJECT_COUNT), " memory=", OS.get_static_memory_usage(), " fruits=", get_tree().get_nodes_in_group("fruits").size(), " frame_ms=", median_ms, " physics_ms=", Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000)
	frame_times.clear()

func _run():
	_check_fruit_movement()
	NecessityBars.started = false
	NewCharData.cor_pele = "#8d5524"
	CharacterController.all_sprites.match3 = CharacterController.Load_Match3()
	var board = load("res://src/Mini-games/Match-3/src/Levels/Tab_6x6.tscn").instance()
	get_tree().get_root().add_child(board)
	get_tree().current_scene = board
	board.get_node("Temp_Tab_6x6").queue_free()
	for child in board.get_children():
		if child is CanvasLayer and child.get_script() == load("res://src/Mini-games/Match-3/src/GUI/Show_Which_Fruit.gd"):
			child.queue_free()
	get_tree().paused = false
	board.set_physics_process(false)
	S_Conntroller.goalScore = 1000000
	S_Conntroller.set_reference(["Water", "RiceAndBean", "Watermelon"], "Hamburguer")
	yield(get_tree(), "idle_frame")
	for tile in board.alltiles:
		board.add_fruit(tile, load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Water.tscn"))
	yield(get_tree().create_timer(0.2), "timeout")
	var baseline_nodes = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	var baseline_objects = Performance.get_monitor(Performance.OBJECT_COUNT)
	_metrics(board, "start")
	var seconds = float(OS.get_environment("MATCH3_SOAK_SECONDS"))
	if seconds <= 0:
		seconds = 20.0
	var deadline = OS.get_ticks_msec() + int(seconds * 1000)
	var cycle = 0
	while OS.get_ticks_msec() < deadline:
		var fruits = []
		for tile in board.AllTiles[5]:
			fruits.append(tile.fruit)
			S_Conntroller.add_tile_to_destroy(tile.fruit)
		S_Conntroller.DestroyTiles()
		var score = S_Conntroller.totalScore
		for fruit in fruits:
			fruit.score(1)
		assert(S_Conntroller.totalScore == score)
		assert(get_tree().get_nodes_in_group("fruits").size() == 30)
		yield(get_tree().create_timer(0.85), "timeout")
		for fruit in fruits:
			assert(not is_instance_valid(fruit))
		for tile in board.AllTiles[0]:
			if not is_instance_valid(tile.fruit):
				board.add_fruit(tile, load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Water.tscn"))
		yield(get_tree().create_timer(0.3), "timeout")
		assert(get_tree().get_nodes_in_group("fruits").size() == 36)
		for tile in board.alltiles:
			assert(not tile.fruit.is_physics_processing())
		assert(Performance.get_monitor(Performance.OBJECT_NODE_COUNT) == baseline_nodes)
		assert(Performance.get_monitor(Performance.OBJECT_COUNT) <= baseline_objects + 5)
		cycle += 1
		if cycle % 10 == 0:
			_metrics(board, "cycle-%d" % cycle)
	_metrics(board, "end-%d" % cycle)
	# Exercise the real swap/cascade path after repeated allocation/destruction.
	var names = ["Water", "RiceAndBean", "Watermelon", "Hamburguer"]
	for row in range(6):
		for column in range(6):
			board.AllTiles[row][column].fruit.fruit_name = names[(row + column) % 4]
	var left = board.AllTiles[0][0].fruit
	var right = board.AllTiles[0][1].fruit
	board.AllTiles[0][0].move_to("Right")
	yield(get_tree().create_timer(1.0), "timeout")
	assert(board.AllTiles[0][0].fruit == left and board.AllTiles[0][1].fruit == right)
	assert(not M_Controller.is_moving())
	board.AllTiles[0][0].fruit.fruit_name = "Water"
	board.AllTiles[0][1].fruit.fruit_name = "RiceAndBean"
	board.AllTiles[0][2].fruit.fruit_name = "Water"
	board.AllTiles[1][1].fruit.fruit_name = "Water"
	board.can_start = true
	board.start = board.line_quant
	board.set_physics_process(true)
	var chances = S_Conntroller.chances
	board.AllTiles[0][1].move_to("Bottom")
	yield(get_tree().create_timer(1.0), "timeout")
	var waits = 0
	while M_Controller.is_moving() and waits < 80:
		yield(get_tree().create_timer(0.5), "timeout")
		waits += 1
	assert(not M_Controller.is_moving() and not board.resolving_board)
	assert(S_Conntroller.chances == chances - 1)
	assert(get_tree().get_nodes_in_group("fruits").size() == 36)
	_metrics(board, "cascade-complete")
	board.queue_free()
	get_tree().current_scene = self
	yield(get_tree(), "idle_frame")
	print("Match-3 soak: PASS")
	get_tree().quit()

func _check_fruit_movement():
	var target = Node2D.new()
	add_child(target)
	var fruit = load("res://src/Mini-games/Match-3/src/Tiles/Fruits/Water.tscn").instance()
	fruit.start(target)
	add_child(fruit)
	# Short final steps, full tile moves, and a retarget during a fall.
	for delta in [1.0 / 120, 1.0 / 60, 1.0 / 30, 0.1]:
		for offset in [Vector2(5, 0), Vector2(-94, 0), Vector2(0, 94), Vector2(94, 94)]:
			fruit.global_position = Vector2.ZERO
			target.global_position = offset
			fruit.reparenting(target)
			var steps = int(ceil(offset.length() / (fruit.speed * delta)))
			for step in range(steps):
				fruit._physics_process(delta)
			assert(fruit.global_position == offset)
			assert(not fruit.is_physics_processing())
	fruit.global_position = Vector2.ZERO
	target.global_position = Vector2(0, 94)
	fruit.reparenting(target)
	fruit._physics_process(0.1)
	target.global_position = Vector2(0, 188)
	fruit.reparenting(target)
	fruit._physics_process(1.0)
	assert(fruit.global_position == target.global_position)
	assert(not fruit.is_physics_processing())
	fruit.free()
	target.free()
	print("Match-3 movement: PASS")
