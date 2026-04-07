extends SceneTree
## Focused garden-to-greenhouse acceptance for the grounds tableau.
## Run: godot --path . --script test/e2e/test_greenhouse_journey.gd
## Output: user://screenshots/greenhouse_journey/*.png when renderer is available.

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _player: Node3D = null
var _player_camera: Camera3D = null
var _capture_enabled: bool = true
var _screenshot_dir := "user://screenshots/greenhouse_journey/"
var _pass_count: int = 0
var _fail_count: int = 0
var _manifest: PackedStringArray = []


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(_screenshot_dir)
	_capture_enabled = DisplayServer.get_name() != "headless"
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_ui = _find(_main, "UIOverlay") as Control
	_player = _find(_main, "PlayerController") as Node3D
	_player_camera = _find_camera(_main)
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("greenhouse journey GameManager found", _gm != null)
	_assert("greenhouse journey RoomManager found", _rm != null)
	_assert("greenhouse journey InteractionManager found", _im != null)
	_assert("greenhouse journey PlayerController found", _player != null)
	if _gm == null or _rm == null or _im == null or _player == null:
		_finish()
		return

	_disable_nonessential_runtime_systems()
	_clear_save_data()
	_gm.new_game()
	_rm.load_room("garden", "kitchen_to_garden")
	await _settle()
	_assert("greenhouse journey starts in garden", _rm.get_current_room_id() == "garden")
	var grounds_world_before: String = _rm.get_current_compiled_world_id() if _rm.has_method("get_current_compiled_world_id") else ""
	await _capture("00_garden_greenhouse_branch")

	await _stage_pose("01_garden_greenhouse_approach", Vector3(0.25, 0, 4.2), 0.0)
	await _stage_pose("02_garden_greenhouse_threshold", Vector3(0.2, 0, 7.15), 0.0)

	_im._on_door_tapped("greenhouse", "garden_to_greenhouse")
	var reached_greenhouse := await _await_room_id("greenhouse", 180)
	await _settle()
	_assert("greenhouse journey reaches greenhouse", reached_greenhouse and _rm.get_current_room_id() == "greenhouse")
	if _rm.has_method("get_current_compiled_world_id"):
		var grounds_world_after: String = _rm.get_current_compiled_world_id()
		_assert("greenhouse journey stays in same compiled world", grounds_world_before == grounds_world_after)
	await _capture("03_greenhouse_entry")

	await _stage_pose("04_greenhouse_commit", Vector3(0.35, 0, 2.75), 0.0)
	await _stage_pose("05_greenhouse_lily_reveal", Vector3(0.1, 0, 1.55), 0.0, -6.0)

	var pot_decl := _find_decl("greenhouse_pot")
	_assert("greenhouse journey pot exists", pot_decl != null)
	if pot_decl != null:
		_im._on_interacted("greenhouse_pot", pot_decl.type, {})
		await _settle()
		await _capture("06_greenhouse_pot")

	_finish()


func _stage_pose(name: String, position: Vector3, rotation_y: float, pitch_degrees: float = 0.0) -> void:
	_set_player_pose(position, rotation_y, pitch_degrees)
	await _settle()
	await _capture(name)


func _set_player_pose(position: Vector3, rotation_y: float, pitch_degrees: float = 0.0) -> void:
	if _player == null:
		return
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
	if _rm == null:
		return Vector3.ZERO
	if _rm.has_method("get_room_world_origin"):
		return _rm.get_room_world_origin()
	var room: Node = _rm.get_current_room() if _rm.has_method("get_current_room") else null
	if room is Node3D:
		return (room as Node3D).global_position
	return Vector3.ZERO


func _find_decl(object_id: String) -> InteractableDecl:
	var room = _rm.get_current_room() if _rm != null else null
	if room == null or not room.has_method("get_interactables"):
		return null
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == object_id:
			var decl = area.get_meta("declaration") if area.has_meta("declaration") else null
			if decl is InteractableDecl:
				return decl
	return null


func _capture(name: String) -> void:
	_manifest.append(name)
	_hide_overlays()
	if not _capture_enabled:
		return
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


func _settle() -> void:
	await process_frame
	await process_frame
	await process_frame


func _await_room_id(room_id: String, max_frames: int = 120) -> bool:
	for _i in range(max_frames):
		if _rm != null and _rm.get_current_room_id() == room_id:
			return true
		await process_frame
	return _rm != null and _rm.get_current_room_id() == room_id


func _disable_nonessential_runtime_systems() -> void:
	if _im != null:
		_im._dialogue_paths = {}
		_im._current_dialogue_resource = null
		_im._audio_manager = null
	var audio := _find(_main, "AudioManager")
	if audio != null:
		if audio.has_method("shutdown"):
			audio.shutdown()
		audio.queue_free()


func _hide_overlays() -> void:
	if _ui == null:
		return
	if _ui.has_method("hide_document"):
		_ui.hide_document()
	var room_name_display := _find(_ui, "RoomNameDisplay")
	if room_name_display is Control:
		(room_name_display as Control).visible = false
	var room_name := _find(_ui, "RoomNameLabel")
	if room_name is Label:
		(room_name as Label).visible = false
		(room_name as Label).modulate.a = 0.0


func _clear_save_data() -> void:
	var save_system := root.get_node_or_null("SaveSystem")
	if save_system != null and save_system.has_method("delete_all"):
		save_system.delete_all()


func _finish() -> void:
	_write_manifest()
	print("")
	print("========================================")
	print("GREENHOUSE JOURNEY: %d passed, %d failed" % [_pass_count, _fail_count])
	if _capture_enabled:
		print("Screenshots: %s" % ProjectSettings.globalize_path(_screenshot_dir))
	else:
		print("Screenshots: skipped in headless mode")
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _write_manifest() -> void:
	var dir_path := ProjectSettings.globalize_path(_screenshot_dir)
	DirAccess.make_dir_recursive_absolute(dir_path)
	var file := FileAccess.open(dir_path.path_join("greenhouse_manifest.txt"), FileAccess.WRITE)
	if file == null:
		return
	file.store_line("Ashworth Manor Greenhouse Journey")
	file.store_line("capture_enabled=%s" % str(_capture_enabled))
	file.store_line("")
	for entry in _manifest:
		file.store_line(entry)
	file.close()


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


func _find_camera(node: Node) -> Camera3D:
	if node is Camera3D:
		return node as Camera3D
	for child in node.get_children():
		var found := _find_camera(child)
		if found != null:
			return found
	return null
