class_name AdaptiSoundBridge
extends RefCounted
## Bridges AudioEngine declarations to AdaptiSound addon's 3-layer system.
## Layer 1: Base ambient (room loop, always playing)
## Layer 2: Tension (elizabeth_aware, volume from game phase)
## Layer 3: SFX (one-shot from ActionDecl.play_sfx)

var _audio_engine: AudioEngine


func _init(audio_engine: AudioEngine) -> void:
	_audio_engine = audio_engine


## Called on room transition. Returns AdaptiSound layer config.
func get_room_audio_config(room_decl: RoomDeclaration) -> Dictionary:
	var params := _audio_engine.get_crossfade_params()
	return {
		# Layer 1: Ambient
		"ambient": {
			"stream_path": params.ambient_path,
			"bus": params.reverb_bus,
			"crossfade_time": params.crossfade_duration,
			"volume_db": -6.0,
		},
		# Layer 2: Tension
		"tension": {
			"stream_path": params.tension_path,
			"bus": params.reverb_bus,
			"volume_db": linear_to_db(params.tension_volume) if params.tension_volume > 0 else -80.0,
			"crossfade_time": 2.0,
		},
		# Footstep config
		"footstep": _audio_engine.get_footstep_config(room_decl),
	}


## Map phase to tension volume scale.
## Exploration=0.0, Discovery=0.3, Horror=0.7, Resolution=1.0
func get_phase_tension_volume(phase: String) -> float:
	match phase:
		"exploration":
			return 0.0
		"discovery":
			return 0.3
		"horror":
			return 0.7
		"resolution":
			return 1.0
		_:
			return 0.0


## Get SFX path for a play_sfx action.
func resolve_sfx_path(sfx_ref: String) -> String:
	return _audio_engine.play_sfx(sfx_ref)


## Get the reverb bus name for the current room.
func get_reverb_bus() -> String:
	return _audio_engine.get_current_reverb_bus()
