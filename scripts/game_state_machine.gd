extends Node
## res://scripts/game_state_machine.gd -- LimboAI HSM for game phase management
## 4 phases: Exploration -> Discovery -> Horror -> Resolution
## Driven by GameManager.flag_set signal dispatch

signal phase_changed(old_phase: String, new_phase: String)

enum Phase { EXPLORATION, DISCOVERY, HORROR, RESOLUTION }

const PHASE_NAMES: Dictionary = {
	Phase.EXPLORATION: "exploration",
	Phase.DISCOVERY: "discovery",
	Phase.HORROR: "horror",
	Phase.RESOLUTION: "resolution",
}

var _hsm: LimboHSM = null
var _state_exploration: LimboState = null
var _state_discovery: LimboState = null
var _state_horror: LimboState = null
var _state_resolution: LimboState = null
var _current_phase: int = Phase.EXPLORATION


func _ready() -> void:
	_build_hsm()
	call_deferred("_connect_signals")


func _build_hsm() -> void:
	_hsm = LimboHSM.new()
	_hsm.name = "GameHSM"
	add_child(_hsm)

	_state_exploration = LimboState.new()
	_state_exploration.name = "Phase_Exploration"
	_hsm.add_child(_state_exploration)

	_state_discovery = LimboState.new()
	_state_discovery.name = "Phase_Discovery"
	_hsm.add_child(_state_discovery)

	_state_horror = LimboState.new()
	_state_horror.name = "Phase_Horror"
	_hsm.add_child(_state_horror)

	_state_resolution = LimboState.new()
	_state_resolution.name = "Phase_Resolution"
	_hsm.add_child(_state_resolution)

	_hsm.initial_state = _state_exploration

	# Exploration -> Discovery: found_first_clue
	_hsm.add_transition(_state_exploration, _state_discovery, &"found_first_clue")
	# Exploration -> Horror: entered_attic (skip discovery)
	_hsm.add_transition(_state_exploration, _state_horror, &"entered_attic")
	# Discovery -> Horror: entered_attic
	_hsm.add_transition(_state_discovery, _state_horror, &"entered_attic")
	# Horror -> Resolution: knows_full_truth
	_hsm.add_transition(_state_horror, _state_resolution, &"knows_full_truth")

	# Connect state entry signals for driving audio/lighting
	_state_exploration.entered.connect(_on_phase_entered.bind(Phase.EXPLORATION))
	_state_discovery.entered.connect(_on_phase_entered.bind(Phase.DISCOVERY))
	_state_horror.entered.connect(_on_phase_entered.bind(Phase.HORROR))
	_state_resolution.entered.connect(_on_phase_entered.bind(Phase.RESOLUTION))

	_hsm.initialize(self)
	_hsm.set_active(true)


func _connect_signals() -> void:
	if GameManager.has_signal("flag_set"):
		GameManager.flag_set.connect(_on_flag_set)


func _on_flag_set(flag_name: String) -> void:
	# Dispatch flag as HSM event
	if _hsm and _hsm.is_active():
		_hsm.dispatch(StringName(flag_name))


func _on_phase_entered(phase: int) -> void:
	var old_name: String = PHASE_NAMES.get(_current_phase, "unknown")
	_current_phase = phase
	var new_name: String = PHASE_NAMES.get(phase, "unknown")
	phase_changed.emit(old_name, new_name)
	_apply_phase_effects(phase)


func _apply_phase_effects(phase: int) -> void:
	# Drive AdaptiSound layers and lighting parameters per phase
	match phase:
		Phase.EXPLORATION:
			_set_audio_layers(1.0, 0.0, 0.0)
			_set_flicker_intensity(1.0)
		Phase.DISCOVERY:
			_set_audio_layers(1.0, 0.3, 0.0)
			_set_flicker_intensity(1.2)
		Phase.HORROR:
			_set_audio_layers(1.0, 0.8, 0.5)
			_set_flicker_intensity(1.8)
		Phase.RESOLUTION:
			_set_audio_layers(0.7, 0.5, 0.0)
			_set_flicker_intensity(1.0)


func _set_audio_layers(base: float, tension: float, stinger: float) -> void:
	var audio: Node = _find_node("AudioManager")
	if audio == null:
		return
	# Tension layer is already driven by elizabeth_aware in audio_manager.gd
	# Here we adjust relative volumes for phase atmosphere
	if audio.has_method("set_tension_volume"):
		audio.set_tension_volume(tension)


func _set_flicker_intensity(multiplier: float) -> void:
	# Propagate flicker intensity to current room's flickering lights
	var rm: Node = _find_node("RoomManager")
	if rm and rm.has_method("get_current_room"):
		var room = rm.get_current_room()
		if room and room.has_method("set_flicker_intensity"):
			room.set_flicker_intensity(multiplier)


func get_current_phase() -> String:
	return PHASE_NAMES.get(_current_phase, "exploration")


func get_current_phase_id() -> int:
	return _current_phase


func is_horror_or_later() -> bool:
	return _current_phase >= Phase.HORROR


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
