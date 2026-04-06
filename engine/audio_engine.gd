class_name AudioEngine
extends RefCounted
## Manages ambient loops, tension layers, SFX, and reverb.
## 3-layer audio: base ambient, tension (Elizabeth), one-shot SFX.

signal ambient_changed(loop_path: String)
signal tension_activated(active: bool)

var _current_ambient: String = ""
var _current_tension: String = ""
var _current_reverb_bus: String = "Room"
var _tension_active: bool = false
var _tension_volume: float = 0.0  # Driven by game phase

# Audio bus layout expected:
# Master -> Room (reverb) -> Ambient (base loops)
#                         -> Tension (tension layers)
#                         -> SFX (one-shot effects)

## Transition to a new room's audio configuration.
## Handles crossfade of ambient loops and tension layer swap.
func transition_to_room(room_decl: RoomDeclaration) -> Dictionary:
	var changes := {}

	# Ambient loop crossfade
	if room_decl.ambient_loop != _current_ambient:
		changes["ambient_from"] = _current_ambient
		changes["ambient_to"] = room_decl.ambient_loop
		_current_ambient = room_decl.ambient_loop
		ambient_changed.emit(_current_ambient)

	# Tension loop swap
	if room_decl.tension_loop != _current_tension:
		changes["tension_from"] = _current_tension
		changes["tension_to"] = room_decl.tension_loop
		_current_tension = room_decl.tension_loop

	# Reverb bus
	if room_decl.reverb_bus != _current_reverb_bus:
		changes["reverb_from"] = _current_reverb_bus
		changes["reverb_to"] = room_decl.reverb_bus
		_current_reverb_bus = room_decl.reverb_bus

	return changes


## Activate or deactivate the tension layer (driven by elizabeth_aware state).
func set_tension_active(active: bool) -> void:
	if _tension_active != active:
		_tension_active = active
		tension_activated.emit(active)


## Set tension volume scale from game phase.
func set_tension_volume(volume: float) -> void:
	_tension_volume = clampf(volume, 0.0, 1.0)


## Get current tension volume (phase scale * active flag).
func get_tension_volume() -> float:
	return _tension_volume if _tension_active else 0.0


## Play a one-shot SFX.
## Returns the SFX path for the caller to actually play.
func play_sfx(sfx_path: String) -> String:
	if sfx_path.is_empty():
		return ""
	# Normalize path
	if not sfx_path.begins_with("res://"):
		sfx_path = "res://assets/audio/" + sfx_path
	return sfx_path


## Get the crossfade parameters for AdaptiSound integration.
func get_crossfade_params() -> Dictionary:
	return {
		"ambient_path": _resolve_audio_path(_current_ambient, "loops"),
		"tension_path": _resolve_audio_path(_current_tension, "tension"),
		"reverb_bus": _current_reverb_bus,
		"tension_volume": get_tension_volume(),
		"crossfade_duration": 1.5,
	}


## Get the footstep surface for the current room.
## Footstep audio is handled by godot-material-footsteps addon.
func get_footstep_config(room_decl: RoomDeclaration) -> Dictionary:
	return {
		"surface": room_decl.footstep_surface,
		"audio_dir": "res://assets/audio/footsteps/%s/" % room_decl.footstep_surface,
	}


func _resolve_audio_path(name: String, subdir: String) -> String:
	if name.is_empty():
		return ""
	if name.begins_with("res://"):
		return name
	return "res://assets/audio/%s/%s" % [subdir, name]


func get_current_ambient() -> String:
	return _current_ambient


func get_current_tension() -> String:
	return _current_tension


func get_current_reverb_bus() -> String:
	return _current_reverb_bus
