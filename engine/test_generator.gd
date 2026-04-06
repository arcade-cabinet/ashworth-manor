class_name TestGenerator
extends RefCounted
## Reads declarations and generates test expectations.
## Validates rooms, puzzles, connections, PRNG solvability.

var _world: WorldDeclaration
var _room_decls: Dictionary = {}  # room_id -> RoomDeclaration
var _puzzles: Array[PuzzleDeclaration] = []


func _init(world: WorldDeclaration) -> void:
	_world = world


## Load room declarations for testing.
func load_rooms(rooms: Dictionary) -> void:
	_room_decls = rooms


## Load puzzle declarations for testing.
func load_puzzles(puzzles: Array[PuzzleDeclaration]) -> void:
	_puzzles = puzzles


## Run all validations. Returns dictionary of test results.
func validate_all() -> Dictionary:
	var results := {
		"rooms": validate_rooms(),
		"connections": validate_connections_bidirectional(),
		"puzzles": validate_puzzles(),
		"prng": validate_prng_solvability(100),
		"total_errors": 0,
		"total_warnings": 0,
	}

	for category in ["rooms", "connections", "puzzles", "prng"]:
		results["total_errors"] += results[category].get("errors", []).size()
		results["total_warnings"] += results[category].get("warnings", []).size()

	return results


## Validate each room declaration.
func validate_rooms() -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []

	for room_id in _room_decls:
		var room: RoomDeclaration = _room_decls[room_id]

		# Check room has interactables
		if room.interactables.is_empty():
			warnings.append("Room '%s' has no interactables" % room_id)

		# Check each interactable has an id
		var seen_ids: Dictionary = {}
		for interactable in room.interactables:
			if interactable.id.is_empty():
				errors.append("Room '%s' has interactable with empty id" % room_id)
			elif interactable.id in seen_ids:
				errors.append("Room '%s' has duplicate interactable id '%s'" % [room_id, interactable.id])
			seen_ids[interactable.id] = true

			# Check interactable has at least one response or is progressive
			if interactable.responses.is_empty() and not interactable.progressive:
				if interactable.thread_responses.is_empty():
					warnings.append("Room '%s', interactable '%s' has no responses" % [room_id, interactable.id])

		# Check audio
		if room.ambient_loop.is_empty():
			warnings.append("Room '%s' has no ambient_loop" % room_id)

		# Check lights for interior rooms
		if not room.is_exterior and room.lights.is_empty():
			warnings.append("Interior room '%s' has no lights" % room_id)

		# Check for flickering lights
		var has_flicker := false
		for light in room.lights:
			if light.flickering:
				has_flicker = true
				break
		if not room.is_exterior and not has_flicker:
			warnings.append("Room '%s' has no flickering lights" % room_id)

	return {"errors": errors, "warnings": warnings, "rooms_checked": _room_decls.size()}


## Validate all connections are bidirectional (A->B implies B->A).
func validate_connections_bidirectional() -> Dictionary:
	var errors: Array[String] = []
	var connection_pairs: Dictionary = {}

	for conn in _world.connections:
		var key := "%s->%s" % [conn.from_room, conn.to_room]
		var reverse_key := "%s->%s" % [conn.to_room, conn.from_room]
		connection_pairs[key] = conn

	for key in connection_pairs:
		var conn: Connection = connection_pairs[key]
		var reverse_key := "%s->%s" % [conn.to_room, conn.from_room]
		if reverse_key not in connection_pairs:
			errors.append("Connection '%s' (%s -> %s) has no reverse" % [conn.id, conn.from_room, conn.to_room])

	return {"errors": errors, "pairs_checked": connection_pairs.size()}


## Validate puzzle completion chains.
func validate_puzzles() -> Dictionary:
	var errors: Array[String] = []

	# Check dependency graph
	var puzzle_engine := PuzzleEngine.new(StateMachine.new())
	puzzle_engine.load_puzzles(_puzzles)
	var dep_errors := puzzle_engine.validate_dependency_graph()
	errors.append_array(dep_errors)

	# Check each puzzle has steps
	for puzzle in _puzzles:
		if puzzle.steps.is_empty():
			errors.append("Puzzle '%s' has no steps" % puzzle.puzzle_id)

		if puzzle.completion_state.is_empty():
			errors.append("Puzzle '%s' has no completion_state" % puzzle.puzzle_id)

		# Check step interactables exist in room declarations
		for step in puzzle.steps:
			if step.target_room.is_empty():
				continue
			if step.target_room not in _room_decls:
				errors.append("Puzzle '%s' step '%s' references unknown room '%s'" % [
					puzzle.puzzle_id, step.step_id, step.target_room
				])
				continue
			if not step.target_interactable.is_empty():
				var room: RoomDeclaration = _room_decls[step.target_room]
				var found := false
				for interactable in room.interactables:
					if interactable.id == step.target_interactable:
						found = true
						break
				if not found:
					errors.append("Puzzle '%s' step '%s' references unknown interactable '%s' in room '%s'" % [
						puzzle.puzzle_id, step.step_id, step.target_interactable, step.target_room
					])

	return {"errors": errors, "puzzles_checked": _puzzles.size()}


## Validate PRNG solvability across N seeds.
func validate_prng_solvability(num_seeds: int) -> Dictionary:
	var errors: Array[String] = []
	var seeds_tested := 0

	for i in range(num_seeds):
		var prng := PRNGEngine.new()
		# Create a modified world with a specific seed
		var test_world := _world.duplicate()
		test_world.prng_seed = i + 1
		prng.resolve(test_world)

		# Verify all junctions resolved
		for junction in _world.junctions:
			var variant := prng.get_junction_variant(junction.junction_id)
			if variant != "A" and variant != "B":
				errors.append("Seed %d: Junction '%s' resolved to invalid variant '%s'" % [
					i + 1, junction.junction_id, variant
				])

		seeds_tested += 1

	return {"errors": errors, "seeds_tested": seeds_tested}


## Generate a human-readable test report.
func generate_report() -> String:
	var results := validate_all()
	var report := "=== Test Generator Report ===\n\n"

	report += "Rooms checked: %d\n" % results["rooms"].get("rooms_checked", 0)
	report += "Connection pairs: %d\n" % results["connections"].get("pairs_checked", 0)
	report += "Puzzles checked: %d\n" % results["puzzles"].get("puzzles_checked", 0)
	report += "PRNG seeds tested: %d\n" % results["prng"].get("seeds_tested", 0)
	report += "\nTotal errors: %d\n" % results["total_errors"]
	report += "Total warnings: %d\n\n" % results["total_warnings"]

	for category in ["rooms", "connections", "puzzles", "prng"]:
		var cat_data: Dictionary = results[category]
		if cat_data.get("errors", []).size() > 0:
			report += "--- %s ERRORS ---\n" % category.to_upper()
			for error in cat_data["errors"]:
				report += "  ERROR: %s\n" % error
		if cat_data.get("warnings", []).size() > 0:
			report += "--- %s WARNINGS ---\n" % category.to_upper()
			for warning in cat_data["warnings"]:
				report += "  WARN: %s\n" % warning

	if results["total_errors"] == 0:
		report += "\nALL VALIDATIONS PASSED\n"
	else:
		report += "\nVALIDATION FAILED: %d errors found\n" % results["total_errors"]

	return report
