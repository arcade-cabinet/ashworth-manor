class_name StateMachine
extends RefCounted
## Manages all game state from StateSchema declarations.
## Includes a state expression parser for condition evaluation.
## Also manages game phase HSM and Elizabeth presence sub-HSM.

signal state_changed(variable: String, value: Variant)
signal phase_changed(from_phase: String, to_phase: String)
signal elizabeth_state_changed(from_state: String, to_state: String)

var _state: Dictionary = {}
var _visited_rooms: Dictionary = {}
var _inventory: Array[String] = []

# Phase HSM
var _current_phase: String = ""
var _phases: Array[PhaseDecl] = []
var _phase_transitions: Array[PhaseTransition] = []

# Elizabeth sub-HSM
var _elizabeth_state: String = ""
var _elizabeth_states: Array[ElizabethStateDecl] = []
var _elizabeth_transitions: Array[ElizabethTransition] = []


## Initialize state from schema.
func init_from_schema(schema: StateSchema) -> void:
	for var_decl in schema.variables:
		match var_decl.type:
			"bool":
				_state[var_decl.name] = var_decl.initial_value == "true"
			"int":
				_state[var_decl.name] = int(var_decl.initial_value)
			"string":
				_state[var_decl.name] = var_decl.initial_value
			"list":
				_state[var_decl.name] = var_decl.initial_value
			_:
				_state[var_decl.name] = var_decl.initial_value


## Initialize HSM from world declaration.
func init_hsm(world: WorldDeclaration) -> void:
	_phases = world.phases
	_phase_transitions = world.phase_transitions
	_elizabeth_states = world.elizabeth_states
	_elizabeth_transitions = world.elizabeth_transitions

	if _phases.size() > 0:
		_current_phase = _phases[0].phase_id
	if _elizabeth_states.size() > 0:
		_elizabeth_state = _elizabeth_states[0].state_id


## Set a state variable and check for phase/elizabeth transitions.
func set_var(variable: String, value: Variant) -> void:
	_state[variable] = value
	state_changed.emit(variable, value)
	_check_phase_transitions()
	_check_elizabeth_transitions()


## Get a state variable.
func get_var(variable: String) -> Variant:
	return _state.get(variable, null)


func get_var_bool(variable: String, default: bool = false) -> bool:
	var val = _state.get(variable, default)
	if val is bool:
		return val
	return bool(val)


func get_var_int(variable: String, default: int = 0) -> int:
	var val = _state.get(variable, default)
	if val is int:
		return val
	return int(val)


## Mark a room as visited.
func visit_room(room_id: String) -> void:
	_visited_rooms[room_id] = true


## Set inventory for HAS checks.
func set_inventory(items: Array[String]) -> void:
	_inventory = items


func get_current_phase() -> String:
	return _current_phase


func get_elizabeth_state() -> String:
	return _elizabeth_state


# ===== State Expression Parser =====

## Evaluate a state expression string. Returns true/false.
## Supports: AND, OR, NOT, HAS, VISITED, >=, <=, ==, !=, >, <
func evaluate(expression: String) -> bool:
	if expression.is_empty():
		return true

	expression = expression.strip_edges()

	# Handle OR (lowest precedence)
	var or_parts := _split_operator(expression, " OR ")
	if or_parts.size() > 1:
		for part in or_parts:
			if evaluate(part):
				return true
		return false

	# Handle AND
	var and_parts := _split_operator(expression, " AND ")
	if and_parts.size() > 1:
		for part in and_parts:
			if not evaluate(part):
				return false
		return true

	# Handle NOT
	if expression.begins_with("NOT "):
		return not evaluate(expression.substr(4))

	# Handle HAS (inventory check)
	if expression.begins_with("HAS "):
		var item_id := expression.substr(4).strip_edges()
		return item_id in _inventory

	# Handle VISITED (room visit check)
	if expression.begins_with("VISITED "):
		var room_id := expression.substr(8).strip_edges()
		return room_id in _visited_rooms

	# Handle numeric/string comparisons
	if " >= " in expression:
		var parts := expression.split(" >= ", false, 1)
		return _get_numeric(parts[0]) >= _get_numeric(parts[1])

	if " <= " in expression:
		var parts := expression.split(" <= ", false, 1)
		return _get_numeric(parts[0]) <= _get_numeric(parts[1])

	if " != " in expression:
		var parts := expression.split(" != ", false, 1)
		return str(_resolve_value(parts[0])) != str(_resolve_value(parts[1]))

	if " == " in expression:
		var parts := expression.split(" == ", false, 1)
		return str(_resolve_value(parts[0])) == str(_resolve_value(parts[1]))

	if " > " in expression:
		var parts := expression.split(" > ", false, 1)
		return _get_numeric(parts[0]) > _get_numeric(parts[1])

	if " < " in expression:
		var parts := expression.split(" < ", false, 1)
		return _get_numeric(parts[0]) < _get_numeric(parts[1])

	# Simple boolean check — variable name is truthy
	var val = _state.get(expression.strip_edges(), false)
	if val is bool:
		return val
	if val is int:
		return val != 0
	if val is String:
		return not val.is_empty() and val != "false" and val != "0"
	return bool(val)


func _split_operator(expr: String, op: String) -> PackedStringArray:
	var parts: PackedStringArray = []
	var depth := 0
	var current := ""

	var i := 0
	while i < expr.length():
		if expr.substr(i, op.length()) == op and depth == 0:
			parts.append(current.strip_edges())
			current = ""
			i += op.length()
			continue
		current += expr[i]
		i += 1

	if not current.strip_edges().is_empty():
		parts.append(current.strip_edges())

	return parts


func _resolve_value(token: String) -> Variant:
	token = token.strip_edges()
	if _state.has(token):
		return _state[token]
	return token


func _get_numeric(token: String) -> float:
	token = token.strip_edges()
	if _state.has(token):
		var val = _state[token]
		if val is int:
			return float(val)
		if val is float:
			return val
		return float(str(val))
	if token.is_valid_float():
		return token.to_float()
	if token.is_valid_int():
		return float(token.to_int())
	return 0.0


# ===== Phase HSM =====

func _check_phase_transitions() -> void:
	for transition in _phase_transitions:
		if transition.from_phase == _current_phase:
			if evaluate(transition.trigger_condition):
				var old := _current_phase
				_current_phase = transition.to_phase
				phase_changed.emit(old, _current_phase)
				return


func _check_elizabeth_transitions() -> void:
	for transition in _elizabeth_transitions:
		if transition.from_state == _elizabeth_state:
			if evaluate(transition.trigger_condition):
				var old := _elizabeth_state
				_elizabeth_state = transition.to_state
				elizabeth_state_changed.emit(old, _elizabeth_state)
				return
