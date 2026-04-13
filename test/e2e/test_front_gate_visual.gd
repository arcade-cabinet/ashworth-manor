extends SceneTree
## Fast visual probe for front-gate composition tuning.
## Run: godot --path . --script test/e2e/test_front_gate_visual.gd

var _main: Node = null
var _rm: Node = null
var _gm: Node = null
var _player: Node3D = null
var _ui: CanvasItem = null
var _capture_enabled := true
var _screenshot_dir := "user://screenshots/front_gate_probe/"


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(_screenshot_dir)
	_reset_output_dir()
	_capture_enabled = DisplayServer.get_name() != "headless"
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_player = _find(_main, "PlayerController") as Node3D
	_ui = _find(_main, "UIOverlay") as CanvasItem
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break
	if _gm == null or _rm == null or _player == null:
		quit(1)
		return

	_gm.new_game()
	_rm.load_room("front_gate")
	await _settle()

	await _stage_pose("00_gate_menu_probe", Vector3(0.7, 0, -7.2), 180.0, 0.0)
	await _stage_pose("01_gate_outward_probe", Vector3(1.8, 0, -7.6), 10.0, -1.0)
	await _stage_pose("02_gate_sign_probe", Vector3(-2.2, 0, -4.7), 154.0, -2.0)
	await _stage_pose("02b_gate_sign_detail_probe", Vector3(-3.6, 0, -3.4), 136.0, -5.0)
	await _stage_pose("03_gate_sky_probe", Vector3(0.7, 0, -7.2), 180.0, 24.0)
	await _stage_pose("04_gate_valise_probe", Vector3(-1.2, 0, -5.7), 146.0, -7.0)
	await _stage_pose("04b_gate_valise_detail_probe", Vector3(-3.7, 0, -4.0), 146.0, -10.0)
	await _stage_pose("05_gate_village_left_probe", Vector3(1.7, 0, -7.6), 32.0, -2.0)
	await _stage_pose("06_gate_village_right_probe", Vector3(1.7, 0, -7.6), -14.0, -2.0)
	quit()


func _stage_pose(name: String, position: Vector3, rotation_y: float, pitch_degrees: float) -> void:
	_set_player_pose(position, rotation_y, pitch_degrees)
	await _settle()
	await _capture(name)


func _set_player_pose(position: Vector3, rotation_y: float, pitch_degrees: float) -> void:
	var room_origin := _get_current_room_origin()
	var world_position := position + room_origin
	if _player.has_method("set_room_position"):
		_player.set_room_position(world_position)
	else:
		_player.global_position = world_position
	if _player.has_method("set_room_rotation_y"):
		_player.set_room_rotation_y(rotation_y)
	else:
		_player.rotation_degrees.y = rotation_y
	if _player.has_method("_set_pitch_degrees"):
		_player._set_pitch_degrees(pitch_degrees)


func _get_current_room_origin() -> Vector3:
	if _rm != null and _rm.has_method("get_room_world_origin"):
		return _rm.get_room_world_origin()
	var room: Node = _rm.get_current_room() if _rm != null and _rm.has_method("get_current_room") else null
	if room is Node3D:
		return (room as Node3D).global_position
	return Vector3.ZERO


func _capture(name: String) -> void:
	if not _capture_enabled:
		return
	if _ui != null:
		_ui.visible = false
	await RenderingServer.frame_post_draw
	var viewport: Viewport = _main.get_viewport() if _main != null else null
	if viewport == null:
		return
	var viewport_tex := viewport.get_texture()
	if viewport_tex == null:
		return
	var image := viewport_tex.get_image()
	if image == null:
		return
	image.save_png(_screenshot_dir + name + ".png")


func _reset_output_dir() -> void:
	var dir := DirAccess.open(_screenshot_dir)
	if dir == null:
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if not dir.current_is_dir() and entry.get_extension().to_lower() == "png":
			dir.remove(entry)
		entry = dir.get_next()
	dir.list_dir_end()


func _settle() -> void:
	await process_frame
	await process_frame
	await process_frame


func _find(root_node: Node, target_name: String) -> Node:
	if root_node.name == target_name:
		return root_node
	for child in root_node.get_children():
		var found := _find(child, target_name)
		if found != null:
			return found
	return null
