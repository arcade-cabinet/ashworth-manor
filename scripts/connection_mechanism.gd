extends Node
## Threshold mechanism controller. Plays a visible opening/reveal motion before traversal.

signal transition_visual_finished(connection_id: String)

var connection: Connection = null
var _mechanism_tween: Tween = null
var _last_duration: float = 0.0


func setup(conn: Connection) -> void:
	connection = conn


func _ready() -> void:
	_apply_persistent_state_immediately()


func get_last_duration() -> float:
	return _last_duration


func play_transition_visual() -> float:
	if connection == null:
		_last_duration = 0.0
		return 0.0
	if _mechanism_tween != null and _mechanism_tween.is_valid():
		_mechanism_tween.kill()
	_mechanism_tween = null

	var root := get_parent() as Node3D
	if root == null:
		_last_duration = 0.0
		return 0.0
	if connection.type in ["stairs", "path"]:
		transition_visual_finished.emit(connection.id)
		_last_duration = 0.0
		return 0.0

	var duration := _resolve_duration()
	if duration <= 0.0:
		transition_visual_finished.emit(connection.id)
		_last_duration = 0.0
		return 0.0

	var tween := create_tween()
	_mechanism_tween = tween

	match connection.type:
		"door", "heavy_door", "gate":
			_tween_single_door_open(root, tween, duration)
			_mark_open_state()
		"double_door":
			_tween_double_door_open(root, tween, duration)
			_mark_open_state()
		"hidden_door":
			_tween_hidden_door_reveal(root, tween, duration)
			_mark_revealed_state()
			_mark_open_state()
		"trapdoor":
			_tween_trapdoor_open(root, tween, duration)
			_mark_open_state()
		"ladder":
			_tween_ladder_deploy(root, tween, duration)
			_mark_open_state()
		_:
			# stairs/path already rely mostly on embodied camera motion
			tween.kill()
			_mechanism_tween = null
			transition_visual_finished.emit(connection.id)
			_last_duration = 0.0
			return 0.0

	_play_open_sfx()
	tween.tween_callback(func() -> void:
		transition_visual_finished.emit(connection.id)
	)
	_last_duration = duration
	return duration


func _apply_persistent_state_immediately() -> void:
	if connection == null:
		return
	var root := get_parent() as Node3D
	if root == null:
		return
	if _is_revealed():
		var cover := root.get_node_or_null("SecretPanelMask") as Node3D
		if cover != null:
			cover.position.x = 1.15
			cover.visible = false
	if _is_open():
		match connection.type:
			"door", "heavy_door", "gate":
				var hinge := root.get_node_or_null("DoorHinge") as Node3D
				if hinge != null:
					hinge.rotation_degrees.y = -92.0
			"double_door":
				var hinge_left := root.get_node_or_null("DoorHingeLeft") as Node3D
				var hinge_right := root.get_node_or_null("DoorHingeRight") as Node3D
				if hinge_left != null:
					hinge_left.rotation_degrees.y = -92.0
				if hinge_right != null:
					hinge_right.rotation_degrees.y = 92.0
			"hidden_door":
				var hidden_hinge := root.get_node_or_null("DoorHinge") as Node3D
				if hidden_hinge != null:
					hidden_hinge.rotation_degrees.y = -92.0
			"trapdoor":
				var trap_hinge := root.get_node_or_null("TrapdoorHinge") as Node3D
				if trap_hinge != null:
					trap_hinge.rotation_degrees.x = -96.0
			"ladder":
				var ladder_visual := root.get_node_or_null("LadderVisual") as Node3D
				if ladder_visual != null:
					ladder_visual.scale = Vector3.ONE
					ladder_visual.position = Vector3.ZERO


func _resolve_duration() -> float:
	match connection.type:
		"door", "heavy_door", "gate", "double_door":
			return 0.35
		"hidden_door":
			return 0.5
		"trapdoor":
			return 0.45
		"ladder":
			return 0.55
		_:
			return 0.0


func _tween_single_door_open(root: Node3D, tween: Tween, duration: float) -> void:
	var hinge := root.get_node_or_null("DoorHinge") as Node3D
	if hinge == null:
		return
	tween.tween_property(hinge, "rotation_degrees:y", -92.0, duration)


func _tween_double_door_open(root: Node3D, tween: Tween, duration: float) -> void:
	var hinge_left := root.get_node_or_null("DoorHingeLeft") as Node3D
	var hinge_right := root.get_node_or_null("DoorHingeRight") as Node3D
	if hinge_left != null:
		tween.parallel().tween_property(hinge_left, "rotation_degrees:y", -92.0, duration)
	if hinge_right != null:
		tween.parallel().tween_property(hinge_right, "rotation_degrees:y", 92.0, duration)


func _tween_hidden_door_reveal(root: Node3D, tween: Tween, duration: float) -> void:
	var cover := root.get_node_or_null("SecretPanelMask") as Node3D
	if cover != null:
		tween.parallel().tween_property(cover, "position:x", 1.15, duration * 0.7)
		tween.parallel().tween_property(cover, "scale", Vector3(0.9, 0.9, 0.9), duration * 0.7)
		tween.parallel().tween_callback(func() -> void:
			cover.visible = false
		).set_delay(duration * 0.72)
	var hinge := root.get_node_or_null("DoorHinge") as Node3D
	if hinge != null:
		tween.parallel().tween_property(hinge, "rotation_degrees:y", -92.0, duration)


func _tween_trapdoor_open(root: Node3D, tween: Tween, duration: float) -> void:
	var hinge := root.get_node_or_null("TrapdoorHinge") as Node3D
	if hinge == null:
		return
	tween.tween_property(hinge, "rotation_degrees:x", -96.0, duration)


func _tween_ladder_deploy(root: Node3D, tween: Tween, duration: float) -> void:
	var ladder_visual := root.get_node_or_null("LadderVisual") as Node3D
	if ladder_visual == null:
		return
	ladder_visual.scale = Vector3(1.0, 0.18, 1.0)
	ladder_visual.position = Vector3(0, 0.9, 0)
	tween.tween_property(ladder_visual, "scale", Vector3.ONE, duration)
	tween.parallel().tween_property(ladder_visual, "position", Vector3.ZERO, duration)


func _mark_open_state() -> void:
	if connection == null:
		return
	var game_manager: Variant = _game_manager()
	if game_manager == null:
		return
	game_manager.set_state("connection_opened_%s" % connection.id, true)


func _mark_revealed_state() -> void:
	if connection == null:
		return
	var game_manager: Variant = _game_manager()
	if game_manager == null:
		return
	game_manager.set_state("connection_revealed_%s" % connection.id, true)


func _is_open() -> bool:
	if connection == null:
		return false
	var game_manager: Variant = _game_manager()
	var opened := false
	if game_manager != null:
		opened = bool(game_manager.get_state("connection_opened_%s" % connection.id, false))
	return opened or connection.mechanism_state == "open"


func _is_revealed() -> bool:
	if connection == null:
		return false
	var game_manager: Variant = _game_manager()
	var revealed := false
	if game_manager != null:
		revealed = bool(game_manager.get_state("connection_revealed_%s" % connection.id, false))
	return revealed or connection.reveal_state == "revealed"


func _game_manager() -> Variant:
	var tree := get_tree()
	if tree == null:
		return null
	return tree.root.get_node_or_null("GameManager")


func _play_open_sfx() -> void:
	if connection == null or connection.open_sfx.is_empty():
		return
	var audio := get_tree().root.get_node_or_null("Main/AudioManager")
	if audio == null or not audio.has_method("play_sfx"):
		return
	var sfx_name := connection.open_sfx
	if sfx_name.begins_with("res://assets/audio/sfx/"):
		sfx_name = sfx_name.trim_prefix("res://assets/audio/sfx/")
		if sfx_name.ends_with(".ogg"):
			sfx_name = sfx_name.substr(0, sfx_name.length() - 4)
	audio.play_sfx(sfx_name)
