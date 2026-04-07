class_name TestGenerator
extends RefCounted
## Reads declarations and generates test expectations.
## Validates rooms, puzzles, connections, PRNG solvability.

var _world: WorldDeclaration
var _room_decls: Dictionary = {}  # room_id -> RoomDeclaration
var _puzzles: Array[PuzzleDeclaration] = []

const CRITICAL_ENTRY_ROOMS := {
	"front_gate": true,
	"foyer": true,
	"parlor": true,
	"dining_room": true,
	"kitchen": true,
	"storage_basement": true,
	"upper_hallway": true,
	"library": true,
	"attic_stairs": true,
	"attic_storage": true,
	"hidden_chamber": true,
}
const CRITICAL_ENTRY_CONNECTION_IDS := {
	"front_gate_to_foyer": true,
	"foyer_to_parlor": true,
	"foyer_to_dining_room": true,
	"foyer_to_kitchen": true,
	"foyer_to_upper_hallway": true,
	"upper_hallway_to_library": true,
	"upper_hallway_to_attic_stairs": true,
	"kitchen_to_storage_basement": true,
	"attic_stairs_to_attic_storage": true,
	"attic_storage_to_hidden_chamber": true,
}
const EXPECTED_INTER_WORLD_CONNECTION_IDS := {
	"front_gate_to_foyer": true,
	"foyer_to_front_gate": true,
	"kitchen_to_garden": true,
	"garden_to_kitchen": true,
	"kitchen_to_storage_basement": true,
	"storage_basement_to_kitchen": true,
	"storage_basement_to_carriage_house": true,
	"carriage_house_to_storage_basement": true,
}
const ENTRY_MAX_BLOCKER_DISTANCE := 1.3
const ENTRY_MAX_BLOCKER_ANGLE_DEG := 28.0
const ENTRY_MAX_BLOCKER_HEIGHT_DELTA := 1.5


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
		"secret_passages": validate_secret_passages(),
		"graph": validate_graph_compilation(),
		"puzzles": validate_puzzles(),
		"prng": validate_prng_solvability(100),
		"total_errors": 0,
		"total_warnings": 0,
	}

	for category in ["rooms", "connections", "secret_passages", "graph", "puzzles", "prng"]:
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
			if not interactable.model.is_empty() and not ResourceLoader.exists(interactable.model):
				errors.append("Room '%s', interactable '%s' model does not exist: %s" % [room_id, interactable.id, interactable.model])
			if not interactable.scene_path.is_empty() and not ResourceLoader.exists(interactable.scene_path):
				errors.append("Room '%s', interactable '%s' scene_path does not exist: %s" % [room_id, interactable.id, interactable.scene_path])
			if not interactable.inactive_model.is_empty() and not ResourceLoader.exists(interactable.inactive_model):
				errors.append("Room '%s', interactable '%s' inactive_model does not exist: %s" % [room_id, interactable.id, interactable.inactive_model])
			if not interactable.inactive_scene_path.is_empty() and not ResourceLoader.exists(interactable.inactive_scene_path):
				errors.append("Room '%s', interactable '%s' inactive_scene_path does not exist: %s" % [room_id, interactable.id, interactable.inactive_scene_path])
			for state_name in interactable.state_model_map.keys():
				var state_path := String(interactable.state_model_map[state_name])
				if state_path.is_empty():
					errors.append("Room '%s', interactable '%s' has empty visual path for state '%s'" % [room_id, interactable.id, state_name])
				elif not ResourceLoader.exists(state_path):
					errors.append("Room '%s', interactable '%s' state '%s' path does not exist: %s" % [room_id, interactable.id, state_name, state_path])

		# Check audio
		if room.ambient_loop.is_empty():
			warnings.append("Room '%s' has no ambient_loop" % room_id)

		for prop in room.props:
			if prop == null:
				errors.append("Room '%s' has null prop entry" % room_id)
				continue
			if prop.model.is_empty() and prop.scene_path.is_empty() and not prop.tags.has("procedural_moon"):
				warnings.append("Room '%s' prop '%s' has no model or scene_path" % [room_id, prop.id])
			if not prop.model.is_empty() and not ResourceLoader.exists(prop.model):
				errors.append("Room '%s' prop '%s' model does not exist: %s" % [room_id, prop.id, prop.model])
			if not prop.scene_path.is_empty() and not ResourceLoader.exists(prop.scene_path):
				errors.append("Room '%s' prop '%s' scene_path does not exist: %s" % [room_id, prop.id, prop.scene_path])
			if not prop.model.is_empty() and not prop.scene_path.is_empty():
				warnings.append("Room '%s' prop '%s' has both model and scene_path; scene_path will win" % [room_id, prop.id])

		# Check lights for interior rooms
		if not room.is_exterior and room.lights.is_empty():
			warnings.append("Interior room '%s' has no lights" % room_id)

		if CRITICAL_ENTRY_ROOMS.has(room_id):
			if room.entry_anchors.is_empty():
				errors.append("Critical room '%s' has no entry_anchors" % room_id)
			if room.focal_anchors.is_empty():
				errors.append("Critical room '%s' has no focal_anchors" % room_id)
			errors.append_array(_validate_entry_composition(room_id, room))

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
		if not conn.to_anchor_id.is_empty():
			if conn.to_room not in _room_decls:
				errors.append("Connection '%s' references unknown target room '%s' for anchor lookup" % [conn.id, conn.to_room])
			elif not _room_has_anchor(_room_decls[conn.to_room].entry_anchors, conn.to_anchor_id):
				errors.append("Connection '%s' references missing target entry anchor '%s'" % [conn.id, conn.to_anchor_id])
		if not conn.focal_anchor_id.is_empty():
			if conn.to_room not in _room_decls:
				errors.append("Connection '%s' references unknown target room '%s' for focal lookup" % [conn.id, conn.to_room])
			elif not _room_has_anchor(_room_decls[conn.to_room].focal_anchors, conn.focal_anchor_id):
				errors.append("Connection '%s' references missing target focal anchor '%s'" % [conn.id, conn.focal_anchor_id])
		if CRITICAL_ENTRY_CONNECTION_IDS.has(conn.id):
			if conn.to_anchor_id.is_empty():
				errors.append("Critical connection '%s' is missing to_anchor_id" % conn.id)
			if conn.focal_anchor_id.is_empty():
				errors.append("Critical connection '%s' is missing focal_anchor_id" % conn.id)
		if conn.type == "hidden_door" and conn.presentation_type.is_empty():
			errors.append("Hidden connection '%s' is missing presentation_type" % conn.id)
		if conn.type == "hidden_door" and conn.mechanism_type.is_empty():
			errors.append("Hidden connection '%s' is missing mechanism_type" % conn.id)
		var from_world_id := _world.get_compiled_world_for_room(conn.from_room)
		var to_world_id := _world.get_compiled_world_for_room(conn.to_room)
		if from_world_id.is_empty():
			errors.append("Connection '%s' has source room '%s' with no compiled world" % [conn.id, conn.from_room])
		if to_world_id.is_empty():
			errors.append("Connection '%s' has target room '%s' with no compiled world" % [conn.id, conn.to_room])
		var is_inter_world := from_world_id != "" and to_world_id != "" and from_world_id != to_world_id
		if EXPECTED_INTER_WORLD_CONNECTION_IDS.has(conn.id) and not is_inter_world:
			errors.append("Connection '%s' should cross compiled worlds but does not" % conn.id)
		if not EXPECTED_INTER_WORLD_CONNECTION_IDS.has(conn.id) and is_inter_world:
			errors.append("Connection '%s' crosses compiled worlds unexpectedly" % conn.id)

	return {"errors": errors, "pairs_checked": connection_pairs.size()}


func validate_secret_passages() -> Dictionary:
	var errors: Array[String] = []
	var room_ids: Dictionary = {}
	for room_ref in _world.rooms:
		room_ids[room_ref.room_id] = true

	for passage in _world.secret_passages:
		if passage.from_room not in room_ids:
			errors.append("Secret passage '%s' has unknown from_room '%s'" % [passage.passage_id, passage.from_room])
		if passage.to_room not in room_ids:
			errors.append("Secret passage '%s' has unknown to_room '%s'" % [passage.passage_id, passage.to_room])
		if passage.anchor_from == null or passage.anchor_to == null:
			errors.append("Secret passage '%s' is missing anchors" % passage.passage_id)
			continue
		if passage.anchor_from.room_id != passage.from_room:
			errors.append("Secret passage '%s' anchor_from.room_id does not match from_room" % passage.passage_id)
		if passage.anchor_to.room_id != passage.to_room:
			errors.append("Secret passage '%s' anchor_to.room_id does not match to_room" % passage.passage_id)
		if passage.locked and passage.key_id.is_empty():
			errors.append("Secret passage '%s' is locked but has no key_id" % passage.passage_id)

	return {"errors": errors, "passages_checked": _world.secret_passages.size()}


func validate_graph_compilation() -> Dictionary:
	var compiler := GraphCompiler.new(_world, _room_decls)
	return compiler.validate()


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
	report += "Secret passages: %d\n" % results["secret_passages"].get("passages_checked", 0)
	report += "Regions checked: %d\n" % results["graph"].get("regions_checked", 0)
	report += "Puzzles checked: %d\n" % results["puzzles"].get("puzzles_checked", 0)
	report += "PRNG seeds tested: %d\n" % results["prng"].get("seeds_tested", 0)
	report += "\nTotal errors: %d\n" % results["total_errors"]
	report += "Total warnings: %d\n\n" % results["total_warnings"]

	for category in ["rooms", "connections", "secret_passages", "graph", "puzzles", "prng"]:
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


func _room_has_anchor(anchors: Array, anchor_id: String) -> bool:
	for anchor in anchors:
		if anchor != null and anchor.anchor_id == anchor_id:
			return true
	return false


func _validate_entry_composition(room_id: String, room: RoomDeclaration) -> Array[String]:
	var errors: Array[String] = []
	if room.entry_anchors.is_empty() or room.focal_anchors.is_empty():
		return errors
	var entry_anchor: RoomAnchorDecl = room.entry_anchors[0]
	var focal_anchor: RoomAnchorDecl = _find_target_focal_anchor(room, entry_anchor)
	if focal_anchor == null:
		focal_anchor = room.focal_anchors[0]
	var forward := focal_anchor.position - entry_anchor.position
	if forward.length_squared() <= 0.001:
		errors.append("Critical room '%s' has overlapping entry and focal anchors" % room_id)
		return errors
	forward.y = 0.0
	if forward.length_squared() <= 0.001:
		return errors
	for prop in room.props:
		var offset := prop.position - entry_anchor.position
		var flat_dist := Vector2(offset.x, offset.z).length()
		if flat_dist > ENTRY_MAX_BLOCKER_DISTANCE:
			continue
		if absf(offset.y) > ENTRY_MAX_BLOCKER_HEIGHT_DELTA:
			continue
		var angle := _flat_angle_deg(forward, offset)
		if angle <= ENTRY_MAX_BLOCKER_ANGLE_DEG:
			errors.append("Critical room '%s' prop '%s' intrudes into the entry cone (%.2fm / %.1fdeg)" % [room_id, prop.id, flat_dist, angle])
			break
	return errors


func _find_target_focal_anchor(room: RoomDeclaration, entry_anchor: RoomAnchorDecl) -> RoomAnchorDecl:
	if entry_anchor == null or entry_anchor.target_anchor_id.is_empty():
		return null
	for anchor in room.focal_anchors:
		if anchor != null and anchor.anchor_id == entry_anchor.target_anchor_id:
			return anchor
	return null


func _flat_angle_deg(forward: Vector3, offset: Vector3) -> float:
	var flat_forward := Vector3(forward.x, 0, forward.z)
	var flat_offset := Vector3(offset.x, 0, offset.z)
	if flat_forward.length_squared() <= 0.001 or flat_offset.length_squared() <= 0.001:
		return 180.0
	return rad_to_deg(acos(clampf(flat_forward.normalized().dot(flat_offset.normalized()), -1.0, 1.0)))
