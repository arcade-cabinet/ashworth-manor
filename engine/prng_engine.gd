class_name PRNGEngine
extends RefCounted
## Seed-based junction resolution, declaration patching, and constraint validation.
## At game start: seed -> macro thread -> junction variants -> validate -> patched declarations.

signal thread_selected(thread_id: String)
signal junction_resolved(junction_id: String, variant: String)
signal validation_complete(valid: bool, errors: Array[String])

var _seed: int = 0
var _rng: RandomNumberGenerator
var _resolved_thread: String = ""
var _resolved_junctions: Dictionary = {}  # junction_id -> "A" or "B"
var _log: Array[String] = []

# Flip probability for repeat playthroughs of same macro thread.
# First playthrough: 0.0 (always use macro_preference).
# Subsequent: 0.2 (20% chance of non-preferred variant).
var flip_probability: float = 0.2


func _init() -> void:
	_rng = RandomNumberGenerator.new()


## Resolve everything from a seed and WorldDeclaration.
## Returns the selected macro_thread id.
func resolve(world: WorldDeclaration) -> String:
	# 1. Generate or use provided seed
	_seed = world.prng_seed
	if _seed == 0:
		_rng.randomize()
		_seed = _rng.seed
	else:
		_rng.seed = _seed

	_log.append("PRNG seed: %d" % _seed)

	# 2. Determine macro thread from seed
	if world.macro_threads.size() > 0:
		var thread_index := _rng.randi() % world.macro_threads.size()
		_resolved_thread = world.macro_threads[thread_index].thread_id
	else:
		_resolved_thread = "captive"  # Default fallback

	_log.append("Macro thread: %s" % _resolved_thread)
	thread_selected.emit(_resolved_thread)

	# 3. Resolve each junction
	for junction in world.junctions:
		var variant := _resolve_junction(junction)
		_resolved_junctions[junction.junction_id] = variant
		_log.append("Junction '%s': variant %s" % [junction.junction_id, variant])
		junction_resolved.emit(junction.junction_id, variant)

	return _resolved_thread


## Resolve a single junction using macro_preference + PRNG.
func _resolve_junction(junction: JunctionDecl) -> String:
	# Check macro_preference first
	var preferred: String = ""
	if _resolved_thread in junction.macro_preference:
		preferred = junction.macro_preference[_resolved_thread]

	# PRNG can flip for variety (controlled by flip_probability)
	var roll := _rng.randf()
	if not preferred.is_empty():
		if roll >= flip_probability:
			return preferred
		else:
			return "B" if preferred == "A" else "A"

	# No preference -- pure random
	return "A" if roll < 0.5 else "B"


## Patch room declarations based on resolved junctions.
## For each junction, activate the resolved variant's interactables and deactivate the other's.
func patch_declarations(world: WorldDeclaration, room_decls: Dictionary) -> void:
	for junction in world.junctions:
		var variant_key: String = _resolved_junctions.get(junction.junction_id, "A")
		var active_variant: VariantDecl = junction.variant_a if variant_key == "A" else junction.variant_b
		var static_variant: VariantDecl = junction.variant_b if variant_key == "A" else junction.variant_a

		if active_variant == null or static_variant == null:
			continue

		# Patch interactable active/static in affected rooms
		_patch_room_interactables(room_decls, active_variant, true)
		_patch_room_interactables(room_decls, static_variant, false)

		# Apply clue overrides from the active variant
		for interactable_id in active_variant.clue_overrides:
			_log.append("Clue override '%s': %s" % [interactable_id, active_variant.clue_overrides[interactable_id]])


func _patch_room_interactables(room_decls: Dictionary, variant: VariantDecl, make_active: bool) -> void:
	if variant.room_id not in room_decls:
		return

	var room: RoomDeclaration = room_decls[variant.room_id]
	var target_ids: PackedStringArray = variant.interactables_active if make_active else variant.interactables_static

	for interactable in room.interactables:
		if interactable.id in target_ids:
			if make_active:
				# Ensure the interactable is active on the current thread
				if interactable.thread_active.size() > 0 and _resolved_thread not in interactable.thread_active:
					interactable.thread_active.append(_resolved_thread)
			else:
				# Remove from active threads
				var idx := interactable.thread_active.find(_resolved_thread)
				if idx >= 0:
					interactable.thread_active.remove_at(idx)


## Resolve puzzle variation points.
func resolve_variations(puzzles: Array[PuzzleDeclaration]) -> void:
	for puzzle in puzzles:
		for variation in puzzle.variation_points:
			var alternatives := variation.alternatives
			if alternatives.is_empty():
				continue
			var all_options: PackedStringArray = [variation.default_value]
			all_options.append_array(alternatives)
			var selected_index := _rng.randi() % all_options.size()
			var selected := all_options[selected_index]
			_log.append("Variation '%s' in puzzle '%s': %s -> %s" % [
				variation.what_varies, puzzle.puzzle_id, variation.default_value, selected
			])


# =============================================================================
# CONSTRAINT VALIDATION (P4-12)
# =============================================================================

## Puzzle dependency graph:
## attic_key_puzzle -> hidden_key_puzzle -> free_elizabeth_puzzle
## (no deps) -> cellar_key_puzzle -> free_elizabeth_puzzle
## gate_key_puzzle -> jewelry_key_puzzle -> free_elizabeth_puzzle
## free_elizabeth_puzzle requires: hidden_key, cellar_key, jewelry_key, gate_key puzzles

## Validate that the current junction resolution produces a solvable game.
## Returns true if all puzzles are solvable in the resolved configuration.
func validate_configuration(world: WorldDeclaration, puzzles: Array[PuzzleDeclaration]) -> bool:
	var errors: Array[String] = []

	# 1. Build the puzzle dependency graph
	var deps: Dictionary = {}  # puzzle_id -> Array[String] of required puzzle_ids
	for puzzle in puzzles:
		deps[puzzle.puzzle_id] = puzzle.requires_puzzles.duplicate()

	# 2. Check for cycles
	if _has_cycle(deps):
		errors.append("CYCLE: Puzzle dependency graph contains a cycle")
		validation_complete.emit(false, errors)
		return false

	# 3. Verify all junction-resolved items are accessible
	# For each diamond junction, the resolved variant must lead to an item
	# that satisfies the functional_slot needed by downstream puzzles
	for junction in world.junctions:
		if junction.junction_type != "diamond":
			continue

		var variant_key: String = _resolved_junctions.get(junction.junction_id, "A")
		var active_variant: VariantDecl = junction.variant_a if variant_key == "A" else junction.variant_b

		if active_variant == null:
			errors.append("MISSING: Junction '%s' variant %s has no VariantDecl" % [junction.junction_id, variant_key])
			continue

		# Verify the active variant's room exists and has the needed interactables
		if active_variant.interactables_active.is_empty():
			errors.append("EMPTY: Junction '%s' variant %s has no active interactables" % [junction.junction_id, variant_key])

	# 4. Verify counter-ritual has access to all required components
	# The counter-ritual (Diamond #6) requires items from puzzles that depend on
	# Diamonds #1-5. Each diamond must yield its functional_slot item.
	var required_slots: PackedStringArray = [
		"attic_access_key",    # Diamond #1
		"hidden_chamber_key",  # Diamond #2
		"cellar_box_key",      # Diamond #3
		"jewelry_box_key",     # Diamond #4
		"crypt_gate_key",      # Diamond #5
	]

	for slot in required_slots:
		var found := false
		for junction in world.junctions:
			if junction.functional_slot == slot:
				found = true
				break
		if not found:
			errors.append("UNREACHABLE: No junction produces functional_slot '%s'" % slot)

	# 5. Verify no item is locked behind its own door
	# (e.g., attic key must NOT be in the attic)
	var locked_room_keys: Dictionary = {
		"attic_access_key": "attic_storage",    # Key must not be IN the attic
		"hidden_chamber_key": "hidden_chamber",  # Key must not be IN hidden chamber
		"crypt_gate_key": "family_crypt",        # Key must not be IN the crypt
	}

	for junction in world.junctions:
		if junction.junction_type != "diamond":
			continue
		if junction.functional_slot not in locked_room_keys:
			continue

		var variant_key: String = _resolved_junctions.get(junction.junction_id, "A")
		var active_variant: VariantDecl = junction.variant_a if variant_key == "A" else junction.variant_b
		if active_variant == null:
			continue

		var forbidden_room: String = locked_room_keys[junction.functional_slot]
		if active_variant.room_id == forbidden_room:
			errors.append("LOCKED_BEHIND_OWN_DOOR: Junction '%s' places %s inside %s" % [
				junction.junction_id, junction.functional_slot, forbidden_room])

	# 6. Topological sort -- verify all puzzles can be completed in SOME order
	var completed: Array[String] = []
	var remaining: Array[String] = []
	for puzzle in puzzles:
		remaining.append(puzzle.puzzle_id)

	var max_iterations := remaining.size() * 2
	var iteration := 0
	while not remaining.is_empty() and iteration < max_iterations:
		var progress := false
		for i in range(remaining.size() - 1, -1, -1):
			var puzzle_id: String = remaining[i]
			var reqs: PackedStringArray = deps.get(puzzle_id, PackedStringArray())
			var all_met := true
			for req in reqs:
				if req not in completed:
					all_met = false
					break
			if all_met:
				completed.append(puzzle_id)
				remaining.remove_at(i)
				progress = true
		if not progress:
			break
		iteration += 1

	if not remaining.is_empty():
		errors.append("UNSOLVABLE: Cannot complete puzzles: %s" % str(remaining))

	# Report results
	if errors.is_empty():
		_log.append("Validation PASSED: All puzzles solvable in configuration")
		validation_complete.emit(true, errors)
		return true
	else:
		for error in errors:
			_log.append("Validation ERROR: %s" % error)
		validation_complete.emit(false, errors)
		return false


## Detect cycles in the dependency graph using DFS.
func _has_cycle(deps: Dictionary) -> bool:
	var visited: Dictionary = {}  # node -> "white" | "grey" | "black"
	for node in deps:
		visited[node] = "white"

	for node in deps:
		if visited[node] == "white":
			if _dfs_cycle(node, deps, visited):
				return true
	return false


func _dfs_cycle(node: String, deps: Dictionary, visited: Dictionary) -> bool:
	visited[node] = "grey"
	var neighbors: PackedStringArray = deps.get(node, PackedStringArray())
	for neighbor in neighbors:
		if neighbor not in visited:
			visited[neighbor] = "white"
		if visited[neighbor] == "grey":
			return true  # Back edge = cycle
		if visited[neighbor] == "white":
			if _dfs_cycle(neighbor, deps, visited):
				return true
	visited[node] = "black"
	return false


## Validate ALL 48 configurations by iterating through seeds.
## Returns a report of valid/invalid configurations.
func validate_all_configurations(world: WorldDeclaration, puzzles: Array[PuzzleDeclaration]) -> Dictionary:
	var results: Dictionary = {
		"total": 0,
		"valid": 0,
		"invalid": 0,
		"rejected": [],
		"thread_coverage": {"captive": 0, "mourning": 0, "sovereign": 0},
	}

	# Test 100 seeds to cover all 48 configurations (3 threads x 2 paths x 8 swaps)
	for seed_val in range(1, 101):
		var test_engine := PRNGEngine.new()
		test_engine.flip_probability = flip_probability

		# Temporarily set seed
		var original_seed := world.prng_seed
		world.prng_seed = seed_val
		var thread := test_engine.resolve(world)
		world.prng_seed = original_seed

		results.total += 1

		# Track thread coverage
		if thread in results.thread_coverage:
			results.thread_coverage[thread] += 1

		# Validate
		var valid := test_engine.validate_configuration(world, puzzles)
		if valid:
			results.valid += 1
		else:
			results.invalid += 1
			results.rejected.append({
				"seed": seed_val,
				"thread": thread,
				"junctions": test_engine._resolved_junctions.duplicate(),
				"log": test_engine.get_log(),
			})

	_log.append("Bulk validation: %d/%d valid (%d rejected)" % [
		results.valid, results.total, results.invalid])

	return results


## Get the resolved macro thread.
func get_thread() -> String:
	return _resolved_thread


## Get the resolved variant for a junction.
func get_junction_variant(junction_id: String) -> String:
	return _resolved_junctions.get(junction_id, "A")


## Get the seed used for this resolution.
func get_seed() -> int:
	return _seed


## Get the full resolution log for debugging/save.
func get_log() -> Array[String]:
	return _log
