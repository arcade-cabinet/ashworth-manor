extends Node
## res://scripts/shake_profiles.gd -- Camera shake event triggers
## Connects game flags and room events to ShakyCamera3D via camera_controller.gd
## Uses ShakyCamera3D.TypesOfShake animation presets with timed duration.

# Shake profile definitions: [shake_type, position_mul, rotation_mul, duration]
# ShakyCamera3D types: INVESTIGATION=0, CLOSEUP=1, WEDDING=2,
#   WALK_TO_THE_SOTORE=3, HANDYCAM_RUN=4, OUT_OF_CAR_WINDOW=5

const PROFILES: Dictionary = {
	# Walking head bob: very subtle investigation shake
	"head_bob": [0, 0.02, 0.01, 0.0],  # Continuous, special handling
	# First clue found: single jolt
	"discovery": [1, 0.15, 0.1, 0.3],
	# Enter attic: sustained tremor
	"attic_entry": [2, 0.08, 0.06, 2.0],
	# Elizabeth mirror event: sharp shake
	"mirror_event": [4, 0.25, 0.2, 0.5],
	# Ritual step completion: building pulse
	"ritual_step": [3, 0.1, 0.08, 1.5],
	# Ritual final moment: heavy release
	"ritual_final": [4, 0.4, 0.3, 2.0],
	# Ending trigger: sustained deep
	"ending": [2, 0.15, 0.1, 5.0],
}

var _player: Node = null
var _cam_ctrl: Node = null
var _head_bob_active: bool = false


func _ready() -> void:
	call_deferred("_connect_signals")


func _connect_signals() -> void:
	_player = _find_node("PlayerController")
	if _player:
		_cam_ctrl = _player.get_node_or_null("CameraController")

	if GameManager.has_signal("flag_set"):
		GameManager.flag_set.connect(_on_flag_set)
	if GameManager.has_signal("ending_triggered"):
		GameManager.ending_triggered.connect(_on_ending)

	var rm: Node = _find_node("RoomManager")
	if rm and rm.has_signal("room_loaded"):
		rm.room_loaded.connect(_on_room_loaded)


func _on_flag_set(flag_name: String) -> void:
	match flag_name:
		"found_first_clue":
			_apply_profile("discovery")
		"entered_attic":
			_apply_profile("attic_entry")
		"elizabeth_mirror_event":
			_apply_profile("mirror_event")
		"ritual_step_1", "ritual_step_2":
			_apply_profile("ritual_step")
		"ritual_step_3", "counter_ritual_complete":
			_apply_profile("ritual_final")


func _on_ending(_ending_id: String) -> void:
	_apply_profile("ending")


func _on_room_loaded(_room_id: String) -> void:
	# No shake during normal room transitions
	pass


func _apply_profile(profile_name: String) -> void:
	if _cam_ctrl == null or not _cam_ctrl.has_method("apply_shake"):
		return
	var profile: Array = PROFILES.get(profile_name, [])
	if profile.is_empty():
		return
	_cam_ctrl.apply_shake(profile[0], profile[1], profile[2], profile[3])


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
