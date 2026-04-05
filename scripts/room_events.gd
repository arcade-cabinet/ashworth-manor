extends Node
## res://scripts/room_events.gd -- Room entry events: first-visit flags,
## room name display, ambient timed events, conditional elizabeth_aware events.

var _room_manager: Node = null
var _ui_overlay: Control = null
var _audio: Node = null
var _active_timers: Array[SceneTreeTimer] = []
var _current_room_id: String = ""

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
	"hidden_room": [
		{"sfx": "whisper", "min_s": 15.0, "max_s": 25.0, "flag_req": ""},
	],
}


func _ready() -> void:
	call_deferred("_connect_signals")


func _connect_signals() -> void:
	_room_manager = _find_node("RoomManager")
	_ui_overlay = _find_node("UIOverlay") as Control
	_audio = _find_node("AudioManager")
	if _room_manager and _room_manager.has_signal("room_loaded"):
		_room_manager.room_loaded.connect(_on_room_loaded)


func _on_room_loaded(room_id: String) -> void:
	_cancel_timers()
	_current_room_id = room_id

	# First-visit flag
	var visit_flag: String = "visited_" + room_id
	if not GameManager.has_flag(visit_flag):
		GameManager.set_flag(visit_flag)

	# Room name display (handled by ui_overlay via room_loaded signal)
	# Schedule ambient events for this room
	_schedule_ambient_events(room_id)


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
	var timer: SceneTreeTimer = get_tree().create_timer(delay)
	_active_timers.append(timer)
	timer.timeout.connect(_on_ambient_event.bind(sfx, evt))


func _on_ambient_event(sfx: String, evt: Dictionary) -> void:
	# Only play if still in the same room
	if GameManager.current_room != _current_room_id:
		return
	if _audio and _audio.has_method("play_sfx"):
		_audio.play_sfx(sfx)
	# Reschedule for next occurrence
	_schedule_one(evt)


func _cancel_timers() -> void:
	# SceneTreeTimers cannot be cancelled directly, but we check room_id
	# before playing so stale timers are harmless. Clear the tracking array.
	_active_timers.clear()


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
