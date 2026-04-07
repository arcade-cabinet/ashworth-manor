extends Node
## res://scripts/elizabeth_presence.gd -- Elizabeth's presence sub-HSM
## Nested behavior within Horror/Resolution phases.
## 4 states: Dormant -> Watching -> Active -> Confrontation

signal elizabeth_state_changed(old_state: String, new_state: String)

enum State { DORMANT, WATCHING, ACTIVE, CONFRONTATION }

const STATE_NAMES: Dictionary = {
	State.DORMANT: "dormant",
	State.WATCHING: "watching",
	State.ACTIVE: "active",
	State.CONFRONTATION: "confrontation",
}

var _hsm: LimboHSM = null
var _state_dormant: LimboState = null
var _state_watching: LimboState = null
var _state_active: LimboState = null
var _state_confrontation: LimboState = null
var _current_state: int = State.DORMANT
var _game_hsm: Node = null

# Timed effect trackers
var _shadow_timer: float = 0.0
var _whisper_timer: float = 0.0
const SHADOW_INTERVAL: float = 25.0
const WHISPER_INTERVAL: float = 18.0


func _ready() -> void:
	_build_hsm()
	call_deferred("_connect_signals")


func _build_hsm() -> void:
	_hsm = LimboHSM.new()
	_hsm.name = "ElizabethHSM"
	add_child(_hsm)

	_state_dormant = LimboState.new()
	_state_dormant.name = "Elizabeth_Dormant"
	_hsm.add_child(_state_dormant)

	_state_watching = LimboState.new()
	_state_watching.name = "Elizabeth_Watching"
	_hsm.add_child(_state_watching)

	_state_active = LimboState.new()
	_state_active.name = "Elizabeth_Active"
	_hsm.add_child(_state_active)

	_state_confrontation = LimboState.new()
	_state_confrontation.name = "Elizabeth_Confrontation"
	_hsm.add_child(_state_confrontation)

	_hsm.initial_state = _state_dormant

	# Dormant -> Watching: elizabeth_aware
	_hsm.add_transition(_state_dormant, _state_watching, &"elizabeth_aware")
	# Watching -> Active: entered_attic (player is in attic rooms)
	_hsm.add_transition(_state_watching, _state_active, &"entered_attic")
	# Active -> Confrontation: found_hidden_chamber
	_hsm.add_transition(_state_active, _state_confrontation, &"found_hidden_chamber")
	# Confrontation -> freed (terminal, no further transition in HSM)

	# Connect state entry signals
	_state_dormant.entered.connect(_on_state_entered.bind(State.DORMANT))
	_state_watching.entered.connect(_on_state_entered.bind(State.WATCHING))
	_state_active.entered.connect(_on_state_entered.bind(State.ACTIVE))
	_state_confrontation.entered.connect(_on_state_entered.bind(State.CONFRONTATION))

	_hsm.initialize(self)
	_hsm.set_active(true)


func _connect_signals() -> void:
	if GameManager.has_signal("flag_set"):
		GameManager.flag_set.connect(_on_flag_set)

	# Listen for game phase changes to activate/deactivate
	_game_hsm = _find_node("GameStateMachine")
	if _game_hsm and _game_hsm.has_signal("phase_changed"):
		_game_hsm.phase_changed.connect(_on_phase_changed)


func _on_flag_set(flag_name: String) -> void:
	if _hsm and _hsm.is_active():
		_hsm.dispatch(StringName(flag_name))


func _on_phase_changed(_old_phase: String, new_phase: String) -> void:
	# Elizabeth is only active during horror and resolution phases
	if new_phase in ["horror", "resolution"]:
		if not _hsm.is_active():
			_hsm.set_active(true)
	# During exploration/discovery, Elizabeth can still transition to watching
	# via elizabeth_aware flag, but her effects are minimal


func _on_state_entered(state: int) -> void:
	var old_name: String = STATE_NAMES.get(_current_state, "unknown")
	_current_state = state
	var new_name: String = STATE_NAMES.get(state, "unknown")
	elizabeth_state_changed.emit(old_name, new_name)


func _process(delta: float) -> void:
	match _current_state:
		State.WATCHING:
			_process_watching(delta)
		State.ACTIVE:
			_process_active(delta)
		State.CONFRONTATION:
			pass  # Direct encounters handled by flashback_manager


func _process_watching(delta: float) -> void:
	# Occasional peripheral shadow effect
	_shadow_timer += delta
	if _shadow_timer >= SHADOW_INTERVAL:
		_shadow_timer = 0.0
		_trigger_peripheral_shadow()


func _process_active(delta: float) -> void:
	# Lights flicker more aggressively, whispers play
	_shadow_timer += delta
	_whisper_timer += delta

	if _shadow_timer >= SHADOW_INTERVAL * 0.6:
		_shadow_timer = 0.0
		_trigger_peripheral_shadow()

	if _whisper_timer >= WHISPER_INTERVAL:
		_whisper_timer = 0.0
		_trigger_whisper()

	# Increase flicker intensity during active state
	var rm: Node = _find_node("RoomManager")
	if rm and rm.has_method("get_current_room"):
		var room = rm.get_current_room()
		if room and room.has_method("set_flicker_intensity"):
			room.set_flicker_intensity(2.5)


func _trigger_peripheral_shadow() -> void:
	# Brief darkening at edge of screen to simulate peripheral shadow
	var ui: Control = _find_node("UIOverlay") as Control
	if ui == null:
		return
	var shadow := ColorRect.new()
	shadow.set_anchors_preset(Control.PRESET_FULL_RECT)
	shadow.color = Color(0, 0, 0, 0)
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(shadow)

	var tween: Tween = ui.create_tween()
	tween.tween_property(shadow, "color:a", 0.15, 0.3)
	tween.tween_interval(0.2)
	tween.tween_property(shadow, "color:a", 0.0, 0.5)
	tween.tween_callback(shadow.queue_free)


func _trigger_whisper() -> void:
	var audio: Node = _find_node("AudioManager")
	if audio and audio.has_method("play_sfx"):
		audio.play_sfx("whisper")


func get_current_state() -> String:
	return STATE_NAMES.get(_current_state, "dormant")


func is_active_or_confrontation() -> bool:
	return _current_state >= State.ACTIVE


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
