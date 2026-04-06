class_name TriggerEngine
extends RefCounted
## Handles entry/exit/timed/conditional room events and global triggers.
## Executes ActionDecl actions. Tracks "once" triggers by trigger_id.

signal action_executed(action: ActionDecl)
signal text_shown(text: String)
signal sfx_requested(path: String)
signal camera_shake_requested(trauma: float)
signal model_spawn_requested(config: Dictionary)
signal psx_fade_requested(amount: float)

var _state_machine: StateMachine
var _fired_triggers: Dictionary = {}  # trigger_id -> true
var _global_triggers: Array[GlobalTrigger] = []
var _ambient_timers: Dictionary = {}  # event_id -> elapsed time


func _init(state_machine: StateMachine) -> void:
	_state_machine = state_machine


## Load global triggers from WorldDeclaration.
func load_global_triggers(triggers: Array[GlobalTrigger]) -> void:
	_global_triggers = triggers


## Called when entering a room — evaluate on_entry triggers.
func on_room_enter(room_decl: RoomDeclaration) -> Array[ActionDecl]:
	var executed: Array[ActionDecl] = []
	for trigger in room_decl.on_entry:
		if _should_fire(trigger):
			for action in trigger.actions:
				_execute_action(action)
				executed.append(action)
			_mark_fired(trigger)
	return executed


## Called when exiting a room — evaluate on_exit triggers.
func on_room_exit(room_decl: RoomDeclaration) -> Array[ActionDecl]:
	var executed: Array[ActionDecl] = []
	for trigger in room_decl.on_exit:
		if _should_fire(trigger):
			for action in trigger.actions:
				_execute_action(action)
				executed.append(action)
			_mark_fired(trigger)
	return executed


## Called on every state change — evaluate global triggers.
func on_state_changed() -> Array[ActionDecl]:
	var executed: Array[ActionDecl] = []
	for global_trigger in _global_triggers:
		if _has_global_fired(global_trigger):
			continue
		if global_trigger.condition.is_empty() or _state_machine.evaluate(global_trigger.condition):
			for action in global_trigger.actions:
				_execute_action(action)
				executed.append(action)
			if global_trigger.once:
				_fired_triggers[global_trigger.trigger_id] = true
	return executed


## Called periodically — evaluate ambient events (timed periodic SFX).
## Returns actions that should fire based on elapsed time.
func update_ambient_events(room_decl: RoomDeclaration, delta: float) -> Array[ActionDecl]:
	var executed: Array[ActionDecl] = []
	for ambient_event in room_decl.ambient_events:
		if not ambient_event.condition.is_empty():
			if not _state_machine.evaluate(ambient_event.condition):
				continue

		var elapsed: float = _ambient_timers.get(ambient_event.event_id, 0.0) + delta
		var interval := randf_range(ambient_event.interval_min, ambient_event.interval_max)

		if elapsed >= interval:
			for action in ambient_event.actions:
				_execute_action(action)
				executed.append(action)
			_ambient_timers[ambient_event.event_id] = 0.0
		else:
			_ambient_timers[ambient_event.event_id] = elapsed

	return executed


## Evaluate conditional events (fire when state condition becomes true).
func check_conditional_events(room_decl: RoomDeclaration) -> Array[ActionDecl]:
	var executed: Array[ActionDecl] = []
	for cond_event in room_decl.conditional_events:
		if cond_event.once and _fired_triggers.get(cond_event.event_id, false):
			continue
		if _state_machine.evaluate(cond_event.condition):
			for action in cond_event.actions:
				_execute_action(action)
				executed.append(action)
			if cond_event.once:
				_fired_triggers[cond_event.event_id] = true
	return executed


## Check flashback triggers.
func check_flashbacks(room_decl: RoomDeclaration) -> Array[FlashbackDecl]:
	var triggered: Array[FlashbackDecl] = []
	for flashback in room_decl.flashbacks:
		if flashback.once and _fired_triggers.get(flashback.flashback_id, false):
			continue
		if flashback.condition.is_empty() or _state_machine.evaluate(flashback.condition):
			triggered.append(flashback)
			if flashback.once:
				_fired_triggers[flashback.flashback_id] = true
			# Emit actions for the flashback
			if flashback.camera_shake > 0:
				camera_shake_requested.emit(flashback.camera_shake)
			if not flashback.stinger_sfx.is_empty():
				sfx_requested.emit(flashback.stinger_sfx)
			if flashback.fade_amount > 0:
				psx_fade_requested.emit(flashback.fade_amount)
			if not flashback.model.is_empty():
				model_spawn_requested.emit({
					"model": flashback.model,
					"position": flashback.model_position,
					"scale": flashback.model_scale,
					"duration": flashback.duration,
				})
	return triggered


## Reset ambient timers (on room change).
func reset_ambient_timers() -> void:
	_ambient_timers.clear()


func _should_fire(trigger: TriggerDecl) -> bool:
	if trigger.once and _fired_triggers.get(trigger.trigger_id, false):
		return false
	if trigger.condition.is_empty():
		return true
	return _state_machine.evaluate(trigger.condition)


func _mark_fired(trigger: TriggerDecl) -> void:
	if trigger.once and not trigger.trigger_id.is_empty():
		_fired_triggers[trigger.trigger_id] = true


func _has_global_fired(trigger: GlobalTrigger) -> bool:
	return trigger.once and _fired_triggers.get(trigger.trigger_id, false)


func _execute_action(action: ActionDecl) -> void:
	# State mutations
	for key in action.set_state:
		_state_machine.set_var(key, action.set_state[key])

	# SFX
	if not action.play_sfx.is_empty():
		sfx_requested.emit(action.play_sfx)

	# Text
	if not action.show_text.is_empty():
		text_shown.emit(action.show_text)

	# Camera shake
	if action.camera_shake > 0:
		camera_shake_requested.emit(action.camera_shake)

	# Model spawn
	if not action.spawn_model.is_empty():
		model_spawn_requested.emit(action.spawn_model)

	# PSX fade
	if action.psx_fade > 0:
		psx_fade_requested.emit(action.psx_fade)

	action_executed.emit(action)
