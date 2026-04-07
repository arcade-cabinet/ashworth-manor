extends SceneTree
## Validates bidirectional connections and secret-passage endpoint integrity.
## Every A->B connection must have a corresponding B->A.
## Also checks locked/key_id consistency and position sanity.
## Run: godot --headless --script test/e2e/validate_connections.gd

var _pass_count: int = 0
var _fail_count: int = 0


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	print("=== Connection Validation ===\n")

	var world := load("res://declarations/world.tres") as WorldDeclaration
	if not world:
		print("[FATAL] Cannot load world.tres")
		quit(1)
		return

	_validate_bidirectional(world)
	_validate_lock_consistency(world)
	_validate_room_references(world)
	_validate_connection_types(world)
	_validate_secret_passages(world)

	print("\n========================================")
	print("CONNECTION VALIDATION: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")

	quit(1 if _fail_count > 0 else 0)


func _validate_bidirectional(world: WorldDeclaration) -> void:
	print("--- Bidirectional Check ---")
	var pairs: Dictionary = {}
	for conn in world.connections:
		var key := "%s->%s" % [conn.from_room, conn.to_room]
		pairs[key] = conn

	var missing := 0
	for key in pairs:
		var conn: Connection = pairs[key]
		var reverse := "%s->%s" % [conn.to_room, conn.from_room]
		if reverse not in pairs:
			print("  MISSING REVERSE: %s" % reverse)
			missing += 1

	_assert("all connections bidirectional (%d pairs)" % pairs.size(), missing == 0)
	print("  Total connections: %d" % world.connections.size())
	print("  Unique pairs: %d" % (pairs.size() / 2))
	print("  Missing reverse: %d\n" % missing)


func _validate_lock_consistency(world: WorldDeclaration) -> void:
	print("--- Lock Consistency ---")
	# If A->B is locked, B->A should also reflect the lock
	var pairs: Dictionary = {}
	for conn in world.connections:
		pairs["%s->%s" % [conn.from_room, conn.to_room]] = conn

	var issues := 0
	for key in pairs:
		var conn: Connection = pairs[key]
		if not conn.locked:
			continue
		# A->B is locked. Check if B->A exists and is also locked
		var reverse_key := "%s->%s" % [conn.to_room, conn.from_room]
		if reverse_key in pairs:
			var reverse: Connection = pairs[reverse_key]
			if not reverse.locked:
				# This is OK -- one-way locks are valid (lock from outside)
				print("  INFO: %s locked, reverse %s unlocked (one-way lock)" % [
					conn.id, reverse.id])
			elif reverse.key_id != conn.key_id:
				print("  WARN: %s key=%s but reverse %s key=%s" % [
					conn.id, conn.key_id, reverse.id, reverse.key_id])
				issues += 1

	_assert("lock consistency verified", issues == 0)
	print("  Lock issues: %d\n" % issues)


func _validate_room_references(world: WorldDeclaration) -> void:
	print("--- Room Reference Check ---")
	# All rooms referenced in connections should exist as room declarations
	var room_ids: Dictionary = {}
	for room_ref in world.rooms:
		room_ids[room_ref.room_id] = true

	var missing := 0
	for conn in world.connections:
		if conn.from_room not in room_ids:
			print("  MISSING ROOM: %s (referenced in %s)" % [conn.from_room, conn.id])
			missing += 1
		if conn.to_room not in room_ids:
			print("  MISSING ROOM: %s (referenced in %s)" % [conn.to_room, conn.id])
			missing += 1

	_assert("all connection rooms exist in world.rooms", missing == 0)
	print("  Referenced rooms: %d, Missing: %d\n" % [room_ids.size(), missing])


func _validate_connection_types(world: WorldDeclaration) -> void:
	print("--- Connection Types ---")
	var valid_types := [
		"door", "double_door", "heavy_door", "hidden_door", "gate",
		"stairs", "trapdoor", "ladder", "path",
	]
	var type_counts: Dictionary = {}
	var invalid := 0

	for conn in world.connections:
		if conn.type not in valid_types:
			print("  INVALID TYPE: '%s' in %s" % [conn.type, conn.id])
			invalid += 1
		if conn.type not in type_counts:
			type_counts[conn.type] = 0
		type_counts[conn.type] += 1

	_assert("all connection types valid", invalid == 0)
	for type_name in type_counts:
		print("  %s: %d" % [type_name, type_counts[type_name]])
	print("")


func _validate_secret_passages(world: WorldDeclaration) -> void:
	print("--- Secret Passages ---")
	var issues := 0
	var room_ids: Dictionary = {}
	for room_ref in world.rooms:
		room_ids[room_ref.room_id] = true

	for passage in world.secret_passages:
		if passage.from_room not in room_ids:
			print("  UNKNOWN FROM ROOM: %s in %s" % [passage.from_room, passage.passage_id])
			issues += 1
		if passage.to_room not in room_ids:
			print("  UNKNOWN TO ROOM: %s in %s" % [passage.to_room, passage.passage_id])
			issues += 1
		if passage.anchor_from == null or passage.anchor_to == null:
			print("  MISSING ANCHOR: %s" % passage.passage_id)
			issues += 1
			continue
		if passage.anchor_from.room_id != passage.from_room:
			print("  FROM ANCHOR MISMATCH: %s" % passage.passage_id)
			issues += 1
		if passage.anchor_to.room_id != passage.to_room:
			print("  TO ANCHOR MISMATCH: %s" % passage.passage_id)
			issues += 1
		if passage.locked and passage.key_id.is_empty():
			print("  LOCK WITH NO KEY: %s" % passage.passage_id)
			issues += 1

	_assert("secret passages valid", issues == 0)
	print("  Secret passages: %d, Issues: %d\n" % [world.secret_passages.size(), issues])


func _assert(description: String, condition: bool) -> void:
	if condition:
		_pass_count += 1
	else:
		_fail_count += 1
		print("  [FAIL] %s" % description)
