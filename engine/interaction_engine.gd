class_name InteractionEngine
extends RefCounted
## Handles all player-interactable interactions from declarations.
## Replaces interaction_manager.gd + puzzle_handler.gd.
## No switch statements. No hardcoded types. Declaration defines behavior.

signal interaction_completed(interactable_id: String, response: ResponseDecl)
signal item_given(item_id: String)
signal state_changed(variable: String, value: Variant)

var _state_machine: StateMachine
var _current_thread: String = ""
var _inventory: Array[String] = []


func _init(state_machine: StateMachine) -> void:
	_state_machine = state_machine


## Set the active macro thread (from PRNG resolution).
func set_thread(thread_id: String) -> void:
	_current_thread = thread_id


## Set inventory reference (item IDs the player currently holds).
func set_inventory(items: Array[String]) -> void:
	_inventory = items


## Process a player tap on an interactable.
## Returns the ResponseDecl shown, or null if interaction was blocked.
func interact(decl: InteractableDecl) -> ResponseDecl:
	# 1. Check thread_active -- skip if wrong macro thread
	if not _is_active_on_thread(decl):
		return null

	# 2. Check if locked
	if decl.locked:
		var locked_response := _handle_locked(decl)
		if decl.locked or locked_response != null:
			return locked_response

	# 3. Check thread-specific response overrides
	if not _current_thread.is_empty() and _current_thread in decl.thread_responses:
		var thread_responses: Array = decl.thread_responses[_current_thread]
		var response := _evaluate_thread_augmented_responses(decl.responses, thread_responses)
		if response:
			_execute_response(decl, response)
			return response

	# 4. Progressive interaction
	if decl.progressive:
		return _handle_progressive(decl)

	# 5. Standard response evaluation
	var response := _evaluate_responses(decl.responses)
	if response:
		_execute_response(decl, response)
		return response

	# 6. Fallback
	if decl.fallback_response:
		_execute_response(decl, decl.fallback_response)
		return decl.fallback_response

	return null


func _is_active_on_thread(decl: InteractableDecl) -> bool:
	if decl.thread_active.is_empty():
		return true  # Active on all threads
	return _current_thread in decl.thread_active


func _handle_locked(decl: InteractableDecl) -> ResponseDecl:
	if decl.key_id.is_empty():
		return _make_text_response(decl.locked_response_no_key)

	# Check by exact item_id
	if decl.key_id in _inventory:
		decl.locked = false
		return null

	# Check by functional_slot match
	for item_id in _inventory:
		# The caller should resolve functional_slot lookup externally
		# For now, check if any item matches the key_id pattern
		pass

	# No matching key
	if _inventory.size() > 0:
		# Player has items but none match
		return _make_text_response(decl.locked_response_wrong_key)

	return _make_text_response(decl.locked_response_no_key)


func _handle_progressive(decl: InteractableDecl) -> ResponseDecl:
	var step_var := "%s_step" % decl.id
	var current_step: int = _state_machine.get_var_int(step_var, 0)

	# Find the step matching current progress
	for i in range(decl.progression_steps.size()):
		var step: ProgressionStep = decl.progression_steps[i]
		if i != current_step:
			continue

		# Check step conditions
		if not step.required_state.is_empty():
			if not _state_machine.evaluate(step.required_state):
				if decl.fallback_response:
					return decl.fallback_response
				return null

		# Check required items
		var has_items := true
		for req_item in step.required_items:
			if req_item not in _inventory:
				has_items = false
				break
		if not has_items:
			if decl.fallback_response:
				return decl.fallback_response
			return null

		# Consume items
		for consume_item in step.consume_items:
			_inventory.erase(consume_item)

		# Advance step counter
		_state_machine.set_var(step_var, current_step + 1)
		state_changed.emit(step_var, current_step + 1)

		if step.response:
			_execute_response(decl, step.response)
			return step.response

	# Past all steps -- use fallback
	if decl.fallback_response:
		return decl.fallback_response
	return null


func _evaluate_responses(responses) -> ResponseDecl:
	# responses can be Array[ResponseDecl] or Array (from Dictionary)
	for response in responses:
		if response is ResponseDecl:
			if response.condition.is_empty():
				return response
			if _state_machine.evaluate(response.condition):
				return response
	return null


func _evaluate_thread_augmented_responses(base_responses, thread_responses) -> ResponseDecl:
	var conditioned_base: Array = []
	var unconditional_base: Array = []
	for response in base_responses:
		if response is not ResponseDecl:
			continue
		if response.condition.is_empty():
			unconditional_base.append(response)
		else:
			conditioned_base.append(response)

	var ordered: Array = []
	ordered.append_array(conditioned_base)
	ordered.append_array(thread_responses)
	ordered.append_array(unconditional_base)
	return _evaluate_responses(ordered)


func _execute_response(decl: InteractableDecl, response: ResponseDecl) -> void:
	# Apply state mutations
	for key in response.set_state:
		_state_machine.set_var(key, response.set_state[key])
		state_changed.emit(key, response.set_state[key])

	# Give items
	var primary_item: String = response.gives_item if not response.gives_item.is_empty() else decl.gives_item
	var primary_condition: String = response.gives_item_condition if not response.gives_item_condition.is_empty() else decl.gives_item_condition
	var bonus_item: String = response.also_gives if not response.also_gives.is_empty() else decl.also_gives

	if not primary_item.is_empty():
		if primary_condition.is_empty() or _state_machine.evaluate(primary_condition):
			_grant_item(primary_item)

	if not bonus_item.is_empty():
		_grant_item(bonus_item)

	interaction_completed.emit(decl.id, response)


func _grant_item(item_id: String) -> void:
	if item_id.is_empty():
		return
	if item_id not in _inventory:
		_inventory.append(item_id)
	item_given.emit(item_id)


func _make_text_response(text: String) -> ResponseDecl:
	var r := ResponseDecl.new()
	r.text = text
	return r


## Check if player has item matching key_id OR functional_slot.
func has_key_for(key_id: String, functional_slot: String, items: Array[ItemDeclaration]) -> bool:
	for item in items:
		if item.item_id in _inventory:
			if item.item_id == key_id:
				return true
			if not functional_slot.is_empty() and item.functional_slot == functional_slot:
				return true
	return false
