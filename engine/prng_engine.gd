class_name PRNGEngine
extends RefCounted
## Seed-based junction resolution and declaration patching.
## At game start: seed -> macro thread -> junction variants -> patched declarations.

signal thread_selected(thread_id: String)
signal junction_resolved(junction_id: String, variant: String)

var _seed: int = 0
var _rng: RandomNumberGenerator
var _resolved_thread: String = ""
var _resolved_junctions: Dictionary = {}  # junction_id -> "A" or "B"
var _log: Array[String] = []


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

	# PRNG can flip for variety (20% chance of non-preferred)
	var roll := _rng.randf()
	if not preferred.is_empty():
		if roll < 0.8:
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
