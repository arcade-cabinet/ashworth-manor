extends Node
## res://scripts/room_events.gd -- Room entry events: first-visit flags,
## room name display, ambient timed events, conditional elizabeth_aware events.

const STATE_SCHEMA_PATH := "res://declarations/state_schema.tres"

var _room_manager: Node = null
var _ui_overlay: Control = null
var _audio: Node = null
var _active_timers: Array[Timer] = []
var _current_room_id: String = ""
var _state_schema: Resource = null
var _state_machine: StateMachine = null
var _trigger_engine: TriggerEngine = null
var _applying_trigger_actions: bool = false

# Ambient event definitions: room_id -> Array of {sfx, min_s, max_s, flag_req}
const AMBIENT_EVENTS: Dictionary = {
	"front_gate": [
		{"sfx": "gate_creak", "min_s": 15.0, "max_s": 30.0, "flag_req": ""},
		{"sfx": "wind_gust", "min_s": 20.0, "max_s": 40.0, "flag_req": ""},
	],
	"kitchen": [
		{"sfx": "water_drip", "min_s": 8.0, "max_s": 15.0, "flag_req": ""},
	],
	"boiler_room": [
		{"sfx": "pipe_whisper", "min_s": 30.0, "max_s": 30.0, "flag_req": "elizabeth_aware"},
	],
	"wine_cellar": [
		{"sfx": "torch_gutter", "min_s": 60.0, "max_s": 60.0, "flag_req": "elizabeth_aware"},
	],
	"upper_hallway": [
		{"sfx": "child_crying", "min_s": 25.0, "max_s": 40.0, "flag_req": "elizabeth_aware"},
		{"sfx": "door_rattle", "min_s": 30.0, "max_s": 30.0, "flag_req": "knows_attic_locked"},
	],
	"attic_stairs": [
		{"sfx": "floorboard_creak", "min_s": 10.0, "max_s": 20.0, "flag_req": ""},
	],
	"hidden_chamber": [
		{"sfx": "whisper", "min_s": 15.0, "max_s": 25.0, "flag_req": ""},
	],
}


func _ready() -> void:
	_state_schema = load(STATE_SCHEMA_PATH)
	_state_machine = StateMachine.new()
	if _state_schema != null:
		_state_machine.init_from_schema(_state_schema)
	_trigger_engine = TriggerEngine.new(_state_machine)
	call_deferred("_connect_signals")


func _exit_tree() -> void:
	_cancel_timers()


func _connect_signals() -> void:
	_room_manager = _find_node("RoomManager")
	_ui_overlay = _find_node("UIOverlay") as Control
	_audio = _find_node("AudioManager")
	if _room_manager and _room_manager.has_signal("room_loaded"):
		var room_cb := Callable(self, "_on_room_loaded")
		if not _room_manager.room_loaded.is_connected(room_cb):
			_room_manager.room_loaded.connect(room_cb)
	if GameManager.has_signal("state_changed"):
		var state_cb := Callable(self, "_on_state_changed")
		if not GameManager.state_changed.is_connected(state_cb):
			GameManager.state_changed.connect(state_cb)


func _on_room_loaded(room_id: String) -> void:
	_cancel_timers()
	_current_room_id = room_id

	_sync_state_machine_from_game()
	_run_room_entry_triggers()

	# Fallback first-visit flag for rooms that do not declare their own entry state.
	var visit_flag: String = "visited_" + room_id
	if not GameManager.has_flag(visit_flag):
		GameManager.set_flag(visit_flag)

	# Room name display (handled by ui_overlay via room_loaded signal)
	# Schedule ambient events for this room
	_schedule_ambient_events(room_id)


func _on_state_changed(_key: String, _value: Variant) -> void:
	if _applying_trigger_actions:
		return
	_sync_state_machine_from_game()
	_run_room_conditional_events()


func _schedule_ambient_events(room_id: String) -> void:
	var events: Array = AMBIENT_EVENTS.get(room_id, [])
	for evt in events:
		var flag_req: String = evt.get("flag_req", "")
		if not flag_req.is_empty() and not GameManager.has_flag(flag_req):
			continue
		_schedule_one(evt)


func _schedule_one(evt: Dictionary) -> void:
	var min_s: float = evt.get("min_s", 10.0)
	var max_s: float = evt.get("max_s", 30.0)
	var delay: float = randf_range(min_s, max_s)
	var sfx: String = evt.get("sfx", "")
	if sfx.is_empty():
		return
	_create_managed_timer(delay, _on_ambient_event.bind(sfx, evt))


func _on_ambient_event(sfx: String, evt: Dictionary) -> void:
	# Only play if still in the same room
	if GameManager.current_room != _current_room_id:
		return
	if _audio and _audio.has_method("play_sfx"):
		_audio.play_sfx(sfx)
	# Reschedule for next occurrence
	_schedule_one(evt)


func _cancel_timers() -> void:
	for timer in _active_timers:
		if is_instance_valid(timer):
			timer.stop()
			timer.queue_free()
	_active_timers.clear()


func _sync_state_machine_from_game() -> void:
	if _state_machine == null:
		return
	for key in GameManager.flags:
		_state_machine.set_var(key, GameManager.flags[key])
	for room_id in GameManager.visited_rooms:
		_state_machine.visit_room(room_id)
	_state_machine.set_inventory(GameManager.get_inventory_items())


func _run_room_entry_triggers() -> void:
	var room_decl: RoomDeclaration = _get_current_room_declaration()
	if room_decl == null or _trigger_engine == null:
		return
	var actions: Array[ActionDecl] = _trigger_engine.on_room_enter(room_decl)
	_apply_trigger_actions(actions)


func _run_room_conditional_events() -> void:
	var room_decl: RoomDeclaration = _get_current_room_declaration()
	if room_decl == null or _trigger_engine == null:
		return
	var actions: Array[ActionDecl] = _trigger_engine.check_conditional_events(room_decl)
	_apply_trigger_actions(actions)


func _apply_trigger_actions(actions: Array[ActionDecl]) -> void:
	if actions.is_empty():
		return
	_applying_trigger_actions = true
	for action in actions:
		_apply_or_schedule_action(action)
	_sync_state_machine_from_game()
	_applying_trigger_actions = false


func _apply_or_schedule_action(action: ActionDecl) -> void:
	if action.delay_seconds <= 0.0:
		_execute_action(action)
		return
	_create_managed_timer(action.delay_seconds, _on_delayed_action_timeout.bind(action))


func _on_delayed_action_timeout(action: ActionDecl) -> void:
	if GameManager.current_room != _current_room_id:
		return
	_execute_action(action)


func _execute_action(action: ActionDecl) -> void:
	for key in action.set_state:
		GameManager.set_state(key, action.set_state[key])
	if not action.show_room_name.is_empty() and _ui_overlay and _ui_overlay.has_method("show_room_name"):
		_ui_overlay.show_room_name(action.show_room_name)
	if not action.show_text.is_empty() and _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document("", action.show_text)
	if not action.play_sfx.is_empty() and _audio and _audio.has_method("play_sfx"):
		_audio.play_sfx(action.play_sfx)
	if not action.light_change.is_empty():
		_apply_light_changes(action.light_change)
	if action.camera_shake > 0.0:
		GameManager.set_state("room_event_camera_shake", action.camera_shake)


func _get_current_room_declaration() -> RoomDeclaration:
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		return null
	var room = _room_manager.get_current_room()
	if room == null:
		return null
	var decl = room.get_meta("declaration") if room.has_meta("declaration") else null
	if decl is RoomDeclaration:
		return decl
	return null


func _apply_light_changes(change_map: Dictionary) -> void:
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		return
	var room: Node = _room_manager.get_current_room()
	if room == null or not room.has_method("tween_light_energy"):
		return
	for light_id in change_map:
		var config: Variant = change_map[light_id]
		if not (config is Dictionary):
			continue
		var target_energy: float = float((config as Dictionary).get("energy", 0.0))
		var duration: float = float((config as Dictionary).get("duration", 0.0))
		room.tween_light_energy(light_id, target_energy, duration)


func _create_managed_timer(delay: float, callback: Callable) -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = delay
	add_child(timer)
	_active_timers.append(timer)
	timer.timeout.connect(_on_managed_timer_timeout.bind(timer, callback))
	timer.start()


func _on_managed_timer_timeout(timer: Timer, callback: Callable) -> void:
	_active_timers.erase(timer)
	if callback.is_valid():
		callback.call()
	if is_instance_valid(timer):
		timer.queue_free()


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
