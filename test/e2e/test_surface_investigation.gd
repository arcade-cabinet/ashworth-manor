extends SceneTree
## Focused embodied-investigation acceptance for suspicious geometry.
## Run: godot --headless --path . --script test/e2e/test_surface_investigation.gd

var _main: Node = null
var _rm: Node = null
var _gm: Node = null
var _player: CharacterBody3D = null
var _pass_count: int = 0
var _fail_count: int = 0
var _surface_event: Dictionary = {}


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_player = _find(_main, "PlayerController") as CharacterBody3D
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("surface investigation GameManager found", _gm != null)
	_assert("surface investigation RoomManager found", _rm != null)
	_assert("surface investigation PlayerController found", _player != null)
	if _gm == null or _rm == null or _player == null:
		_finish()
		return

	if _player.has_signal("surface_investigated"):
		var cb := Callable(self, "_on_surface_investigated")
		if not _player.surface_investigated.is_connected(cb):
			_player.surface_investigated.connect(cb)

	_gm.new_game()
	_rm.load_room("front_gate")
	await _settle()

	var room_origin := _get_current_room_origin()
	var wall_target := room_origin + Vector3(-2.0, 1.45, -0.15)
	_player.begin_surface_investigation(wall_target, Vector3(0, 0, -1))
	var focused := await _await_surface_focus()
	_assert("surface investigation event fired", focused)
	await create_timer(0.35).timeout

	var camera: Camera3D = _player.get_view_camera()
	_assert("surface investigation camera exists", camera != null)
	if camera != null:
		_assert("surface investigation narrows fov", camera.fov < 70.0)
		_assert("surface investigation leans camera", camera.position.z < -0.01)

	_finish()


func _on_surface_investigated(surface_data: Dictionary) -> void:
	_surface_event = surface_data.duplicate(true)


func _await_surface_focus(max_frames: int = 240) -> bool:
	for _i in range(max_frames):
		if not _surface_event.is_empty():
			return true
		await process_frame
	return not _surface_event.is_empty()


func _get_current_room_origin() -> Vector3:
	if _rm == null:
		return Vector3.ZERO
	if _rm.has_method("get_room_world_origin"):
		return _rm.get_room_world_origin()
	var room: Node = _rm.get_current_room() if _rm.has_method("get_current_room") else null
	if room is Node3D:
		return (room as Node3D).global_position
	return Vector3.ZERO


func _settle() -> void:
	await process_frame
	await process_frame
	await process_frame


func _finish() -> void:
	print("")
	print("========================================")
	print("SURFACE INVESTIGATION: %d passed, %d failed" % [_pass_count, _fail_count])
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
