class_name PuzzleEngine
extends RefCounted
## Tracks puzzle progress from declarations. Validates dependencies.
## On completion, sets reward_states and reward_items.

signal puzzle_step_completed(puzzle_id: String, step_id: String)
signal puzzle_completed(puzzle_id: String)

var _puzzles: Dictionary = {}  # puzzle_id -> PuzzleDeclaration
var _state_machine: StateMachine
var _completed_puzzles: Array[String] = []


func _init(state_machine: StateMachine) -> void:
	_state_machine = state_machine


## Load all puzzle declarations.
func load_puzzles(puzzles: Array[PuzzleDeclaration]) -> void:
	for puzzle in puzzles:
		_puzzles[puzzle.puzzle_id] = puzzle


## Check all puzzles for step completion on state change.
func on_state_changed() -> void:
	for puzzle_id in _puzzles:
		if puzzle_id in _completed_puzzles:
			continue

		var puzzle: PuzzleDeclaration = _puzzles[puzzle_id]

		# Check prerequisites
		if not _prerequisites_met(puzzle):
			continue

		# Check completion
		if not puzzle.completion_state.is_empty():
			if _state_machine.evaluate(puzzle.completion_state):
				_complete_puzzle(puzzle)
				continue

		# Check individual steps
		for step in puzzle.steps:
			var step_key := "%s_%s_done" % [puzzle_id, step.step_id]
			if _state_machine.get_var_bool(step_key, false):
				continue  # Already completed

			if _is_step_complete(step):
				_state_machine.set_var(step_key, true)
				# Apply step result states
				for key in step.result_states:
					_state_machine.set_var(key, step.result_states[key])
				puzzle_step_completed.emit(puzzle_id, step.step_id)


func _prerequisites_met(puzzle: PuzzleDeclaration) -> bool:
	for req_puzzle_id in puzzle.requires_puzzles:
		if req_puzzle_id not in _completed_puzzles:
			return false
	return true


func _is_step_complete(step: PuzzleStepDecl) -> bool:
	if not step.required_state.is_empty():
		if not _state_machine.evaluate(step.required_state):
			return false

	# Check result states are set (indicating the step's action was taken)
	for key in step.result_states:
		var current = _state_machine.get_var(key)
		if current != step.result_states[key]:
			return false

	return true


func _complete_puzzle(puzzle: PuzzleDeclaration) -> void:
	_completed_puzzles.append(puzzle.puzzle_id)

	# Set reward states
	for key in puzzle.reward_states:
		_state_machine.set_var(key, puzzle.reward_states[key])

	puzzle_completed.emit(puzzle.puzzle_id)


## Validate puzzle dependency graph -- no cycles, all prerequisites achievable.
## Returns array of error strings (empty = valid).
func validate_dependency_graph() -> PackedStringArray:
	var errors: PackedStringArray = []

	# Check for missing dependencies
	for puzzle_id in _puzzles:
		var puzzle: PuzzleDeclaration = _puzzles[puzzle_id]
		for req_id in puzzle.requires_puzzles:
			if req_id not in _puzzles:
				errors.append("Puzzle '%s' requires unknown puzzle '%s'" % [puzzle_id, req_id])

	# Check for cycles using topological sort
	var visited: Dictionary = {}
	var in_progress: Dictionary = {}

	for puzzle_id in _puzzles:
		if puzzle_id not in visited:
			var cycle := _detect_cycle(puzzle_id, visited, in_progress)
			if not cycle.is_empty():
				errors.append("Dependency cycle detected: %s" % cycle)

	return errors


func _detect_cycle(puzzle_id: String, visited: Dictionary, in_progress: Dictionary) -> String:
	if puzzle_id in in_progress:
		return puzzle_id  # Cycle found

	if puzzle_id in visited:
		return ""

	in_progress[puzzle_id] = true

	if puzzle_id in _puzzles:
		var puzzle: PuzzleDeclaration = _puzzles[puzzle_id]
		for req_id in puzzle.requires_puzzles:
			var result := _detect_cycle(req_id, visited, in_progress)
			if not result.is_empty():
				return "%s -> %s" % [puzzle_id, result]

	in_progress.erase(puzzle_id)
	visited[puzzle_id] = true
	return ""


## Get completion percentage for a puzzle.
func get_progress(puzzle_id: String) -> float:
	if puzzle_id not in _puzzles:
		return 0.0
	if puzzle_id in _completed_puzzles:
		return 1.0

	var puzzle: PuzzleDeclaration = _puzzles[puzzle_id]
	if puzzle.steps.is_empty():
		return 0.0

	var completed_steps := 0
	for step in puzzle.steps:
		var step_key := "%s_%s_done" % [puzzle_id, step.step_id]
		if _state_machine.get_var_bool(step_key, false):
			completed_steps += 1

	return float(completed_steps) / float(puzzle.steps.size())


func is_completed(puzzle_id: String) -> bool:
	return puzzle_id in _completed_puzzles
