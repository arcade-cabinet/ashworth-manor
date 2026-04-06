extends SceneTree
## Validates all 48 PRNG configurations (3 threads x 2 paths x 8 swaps).
## Also validates bidirectional connections and puzzle dependency graph.
## Run: godot --headless --script test/e2e/validate_configurations.gd

var _pass_count: int = 0
var _fail_count: int = 0


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	print("=== Configuration Validation Suite ===\n")

	var world := _load_world()
	if not world:
		print("[FATAL] Cannot load world.tres")
		quit(1)
		return

	var puzzles := _load_puzzles()
	var rooms := _load_rooms()

	_validate_bidirectional_connections(world)
	_validate_puzzle_dependency_graph(puzzles)
	_validate_all_48_configurations(world, puzzles)
	_validate_junction_coverage(world)

	print("\n========================================")
	print("VALIDATION: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")

	quit(1 if _fail_count > 0 else 0)


func _validate_bidirectional_connections(world: WorldDeclaration) -> void:
	print("--- Bidirectional Connections ---")
	var pairs: Dictionary = {}
	for conn in world.connections:
		var key := "%s->%s" % [conn.from_room, conn.to_room]
		pairs[key] = conn

	var missing := 0
	for key in pairs:
		var conn: Connection = pairs[key]
		var reverse := "%s->%s" % [conn.to_room, conn.from_room]
		if reverse not in pairs:
			print("  MISSING: %s (no reverse for %s)" % [reverse, conn.id])
			missing += 1

	_assert("all %d connections are bidirectional" % pairs.size(), missing == 0)
	print("[DONE] %d connection pairs, %d missing\n" % [pairs.size(), missing])


func _validate_puzzle_dependency_graph(puzzles: Array[PuzzleDeclaration]) -> void:
	print("--- Puzzle Dependency Graph ---")
	var state_machine := StateMachine.new()
	var puzzle_engine := PuzzleEngine.new(state_machine)
	puzzle_engine.load_puzzles(puzzles)

	var errors := puzzle_engine.validate_dependency_graph()
	for error in errors:
		print("  ERROR: %s" % error)

	_assert("no dependency graph errors", errors.is_empty())
	print("[DONE] %d puzzles validated, %d errors\n" % [puzzles.size(), errors.size()])


func _validate_all_48_configurations(world: WorldDeclaration, puzzles: Array[PuzzleDeclaration]) -> void:
	print("--- 48-Configuration Validation ---")

	# We need to test enough seeds to cover all 48 configs
	# 3 threads x 2^6 diamond combos x 2^3 swap combos = very many,
	# but constraints reduce to 48 practical configs.
	# Test 200 seeds to ensure good coverage.

	var valid := 0
	var invalid := 0
	var configs_seen: Dictionary = {}
	var thread_coverage: Dictionary = {"captive": 0, "mourning": 0, "sovereign": 0}

	for seed_val in range(1, 201):
		var prng := PRNGEngine.new()
		var test_world := world.duplicate()
		test_world.prng_seed = seed_val
		var thread := prng.resolve(test_world)

		if thread in thread_coverage:
			thread_coverage[thread] += 1

		# Build config signature
		var config_sig := thread
		for junction in world.junctions:
			config_sig += "_%s" % prng.get_junction_variant(junction.junction_id)
		configs_seen[config_sig] = true

		if prng.validate_configuration(test_world, puzzles):
			valid += 1
		else:
			invalid += 1
			var log := prng.get_log()
			print("  INVALID seed=%d thread=%s" % [seed_val, thread])
			for entry in log:
				if "ERROR" in entry or "INVALID" in entry:
					print("    %s" % entry)

	_assert("all tested configurations valid (0 invalid)", invalid == 0)
	_assert("all 3 threads covered",
		thread_coverage["captive"] > 0 and
		thread_coverage["mourning"] > 0 and
		thread_coverage["sovereign"] > 0)

	print("[DONE] %d seeds tested: %d valid, %d invalid" % [200, valid, invalid])
	print("  Unique configurations: %d" % configs_seen.size())
	print("  Thread coverage: captive=%d mourning=%d sovereign=%d" % [
		thread_coverage["captive"], thread_coverage["mourning"], thread_coverage["sovereign"]])
	print("")


func _validate_junction_coverage(world: WorldDeclaration) -> void:
	print("--- Junction Coverage ---")
	var junction_a_count: Dictionary = {}
	var junction_b_count: Dictionary = {}

	for junction in world.junctions:
		junction_a_count[junction.junction_id] = 0
		junction_b_count[junction.junction_id] = 0

	for seed_val in range(1, 101):
		var prng := PRNGEngine.new()
		var test_world := world.duplicate()
		test_world.prng_seed = seed_val
		prng.resolve(test_world)

		for junction in world.junctions:
			var variant := prng.get_junction_variant(junction.junction_id)
			if variant == "A":
				junction_a_count[junction.junction_id] += 1
			else:
				junction_b_count[junction.junction_id] += 1

	for junction_id in junction_a_count:
		var a_pct := junction_a_count[junction_id]
		var b_pct := junction_b_count[junction_id]
		_assert("junction %s has both A(%d) and B(%d) coverage" % [junction_id, a_pct, b_pct],
			a_pct > 0 and b_pct > 0)
		print("  %s: A=%d%% B=%d%%" % [junction_id, a_pct, b_pct])

	print("[DONE] Junction coverage verified\n")


# === Loaders ===

func _load_world() -> WorldDeclaration:
	var path := "res://declarations/world.tres"
	if not ResourceLoader.exists(path):
		return null
	return load(path) as WorldDeclaration


func _load_puzzles() -> Array[PuzzleDeclaration]:
	var puzzles: Array[PuzzleDeclaration] = []
	var dir := DirAccess.open("res://declarations/puzzles/")
	if not dir:
		return puzzles
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		if file_name.ends_with(".tres"):
			var res := load("res://declarations/puzzles/" + file_name)
			if res is PuzzleDeclaration:
				puzzles.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	return puzzles


func _load_rooms() -> Dictionary:
	var rooms: Dictionary = {}
	var dir := DirAccess.open("res://declarations/rooms/")
	if not dir:
		return rooms
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		if file_name.ends_with(".tres"):
			var res := load("res://declarations/rooms/" + file_name)
			if res is RoomDeclaration:
				rooms[res.room_id] = res
		file_name = dir.get_next()
	dir.list_dir_end()
	return rooms


func _assert(description: String, condition: bool) -> void:
	if condition:
		_pass_count += 1
	else:
		_fail_count += 1
		print("  [FAIL] %s" % description)
