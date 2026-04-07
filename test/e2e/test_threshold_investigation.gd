extends SceneTree
## Embodied threshold inspection acceptance for concealed seams and approach-first taps.
## Run: godot --headless --path . --script test/e2e/test_threshold_investigation.gd

var _main: Node = null
var _rm: Node = null
var _gm: Node = null
var _player: CharacterBody3D = null
var _ui: Control = null
var _pass_count: int = 0
var _fail_count: int = 0
var _surface_events: Array[String] = []
var _door_events: Array[String] = []
var _event_order: PackedStringArray = []


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_player = _find(_main, "PlayerController") as CharacterBody3D
	_ui = _find(_main, "UIOverlay") as Control
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("threshold investigation GameManager found", _gm != null)
	_assert("threshold investigation RoomManager found", _rm != null)
	_assert("threshold investigation PlayerController found", _player != null)
	if _gm == null or _rm == null or _player == null:
		_finish()
		return

	if _player.has_signal("surface_investigated"):
		var surface_cb := Callable(self, "_on_surface_investigated")
		if not _player.surface_investigated.is_connected(surface_cb):
			_player.surface_investigated.connect(surface_cb)
	if _player.has_signal("door_tapped"):
		var door_cb := Callable(self, "_on_door_tapped")
		if not _player.door_tapped.is_connected(door_cb):
			_player.door_tapped.connect(door_cb)

	await _test_hidden_threshold_probe()
	_finish()


func _test_hidden_threshold_probe() -> void:
	_surface_events.clear()
	_door_events.clear()
	_event_order.clear()
	_gm.new_game()
	_rm.load_room("storage_basement")
	await _settle()

	var hidden_area := _find_connection_area("storage_basement_to_carriage_house")
	_assert("hidden threshold area found", hidden_area != null)
	if hidden_area == null:
		return

	var target_world := hidden_area.global_position + Vector3(0, 1.0, -0.42)
	var room_origin := _get_current_room_origin()
	if _player.has_method("set_room_position"):
		_player.set_room_position(room_origin + Vector3(1.0, 0.0, 1.2))
	var yaw := _yaw_to_world_point(target_world)
	if _player.has_method("set_room_rotation_y"):
		_player.set_room_rotation_y(yaw)
	await _settle()

	var camera: Camera3D = _player.get_view_camera()
	_assert("threshold investigation camera exists", camera != null)
	if camera == null:
		return

	_player.begin_threshold_probe(
		"carriage_house",
		"storage_basement_to_carriage_house",
		target_world,
		Vector3(0.0, 0.0, -1.0),
		true
	)
	_assert("hidden threshold does not emit door instantly", _door_events.is_empty())
	_assert("hidden threshold does not emit surface instantly", _surface_events.is_empty())

	var arrived := await _await_events()
	_assert("hidden threshold events fire after approach", arrived)
	_assert("hidden threshold surface probe fires", _surface_events.size() == 1)
	_assert("hidden threshold door tap fires", _door_events.size() == 1)
	_assert("hidden threshold probes before door tap", _event_order == PackedStringArray(["surface", "door"]))
	await create_timer(0.35).timeout

	if camera != null:
		_assert("hidden threshold narrows fov", camera.fov < 70.0)
		_assert("hidden threshold leans camera", camera.position.z < -0.01)
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()


func _find_connection_area(connection_id: String) -> Area3D:
	var room = _rm.get_current_room() if _rm != null and _rm.has_method("get_current_room") else null
	if room == null or not room.has_method("get_connections"):
		return null
	for area in room.get_connections():
		if area.has_meta("connection_id") and String(area.get_meta("connection_id")) == connection_id:
			return area
	return null


func _yaw_to_world_point(world_position: Vector3) -> float:
	var player_eye := _player.global_position
	var to_target := world_position - player_eye
	var flat := Vector2(to_target.x, to_target.z)
	if flat.length() <= 0.001:
		return _player.rotation_degrees.y
	return rad_to_deg(atan2(-flat.x, -flat.y))


func _get_current_room_origin() -> Vector3:
	if _rm == null:
		return Vector3.ZERO
	if _rm.has_method("get_room_world_origin"):
		return _rm.get_room_world_origin()
	var room: Node = _rm.get_current_room() if _rm.has_method("get_current_room") else null
	if room is Node3D:
		return (room as Node3D).global_position
	return Vector3.ZERO


func _on_surface_investigated(_surface_data: Dictionary) -> void:
	_surface_events.append("surface")
	_event_order.append("surface")


func _on_door_tapped(_target_room: String, _connection_id: String) -> void:
	_door_events.append("door")
	_event_order.append("door")


func _await_events(max_frames: int = 240) -> bool:
	for _i in range(max_frames):
		if _surface_events.size() >= 1 and _door_events.size() >= 1:
			return true
		await process_frame
	return _surface_events.size() >= 1 and _door_events.size() >= 1


func _settle() -> void:
	await process_frame
	await process_frame
	await process_frame


func _finish() -> void:
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()
	if _main != null and is_instance_valid(_main):
		_main.queue_free()
		await process_frame
		await process_frame
	print("")
	print("========================================")
	print("THRESHOLD INVESTIGATION: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _assert(label: String, ok: bool) -> void:
	if ok:
		_pass_count += 1
		print("[PASS] %s" % label)
		return
	_fail_count += 1
	print("[FAIL] %s" % label)


func _find(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var found := _find(child, target)
		if found != null:
			return found
	return null
