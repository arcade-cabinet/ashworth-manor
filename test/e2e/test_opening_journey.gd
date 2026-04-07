extends SceneTree
## Focused opening-sequence acceptance for the diegetic front-gate start.
## Run: godot --path . --script test/e2e/test_opening_journey.gd
## Output: user://screenshots/opening_journey/*.png when renderer is available.

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _player: Node3D = null
var _player_camera: Camera3D = null
var _capture_enabled: bool = true
var _screenshot_dir := "user://screenshots/opening_journey/"
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

	_assert("opening GameManager found", _gm != null)
	_assert("opening RoomManager found", _rm != null)
	_assert("opening InteractionManager found", _im != null)
	_assert("opening PlayerController found", _player != null)
	if _gm == null or _rm == null or _im == null or _player == null:
		_finish()
		return

	_disable_nonessential_runtime_systems()
	_clear_save_data()
	_gm.new_game()
	_rm.load_room("front_gate")
	await _settle()
	_assert("opening starts at front_gate", _rm.get_current_room_id() == "front_gate")
	await _capture("00_gate_menu")

	var new_game_decl := _find_decl("gate_sign_new_game")
	_assert("opening new-game sign exists", new_game_decl != null)
	if new_game_decl == null:
		_finish()
		return
	_im._on_interacted("gate_sign_new_game", new_game_decl.type, {})
	await _settle()
	_assert("opening new-game selection stored", _gm.get_state("front_gate_menu_selection", "") == "new_game")
	_assert("opening threshold committed from sign", _gm.get_state("front_gate_threshold_acknowledged", false) == true)
	await _capture("01_new_game_selected")

	await _stage_pose("02_gate_threshold", Vector3(0, 0, -11.9), 180.0)
	await _stage_pose("03_drive_lower", Vector3(0, 0, -7.4), 180.0)
	await _stage_pose("04_drive_middle", Vector3(0, 0, -2.2), 180.0)
	await _stage_pose("05_drive_upper", Vector3(0, 0, 3.6), 180.0)
	await _stage_pose("06_front_steps", Vector3(0, 0, 8.8), 180.0)

	var room_loaded: Signal = _rm.room_loaded
	var transition_finished: Signal = _rm.room_transition_finished
	_im._on_door_tapped("foyer", "front_gate_to_foyer")
	var loaded_room: String = await room_loaded
	await transition_finished
	await _settle()
	_assert("opening reaches foyer", loaded_room == "foyer" and _rm.get_current_room_id() == "foyer")
	if _rm.has_method("get_visible_compiled_world_room_ids"):
		var visible_rooms: PackedStringArray = _rm.get_visible_compiled_world_room_ids()
		_assert("opening foyer keeps upper side rooms hidden", not visible_rooms.has("master_bedroom"))
		_assert("opening foyer hides upper hallway shell", not visible_rooms.has("upper_hallway"))
	await _capture("07_foyer_handoff")
	await _stage_pose("08_foyer_commit", Vector3(0.35, 0, -1.35), 176.0, -4.0)
	await _stage_pose("09_stairs_pull", Vector3(0.18, 0, -0.78), 176.0, -14.0)

	_finish()


func _stage_pose(name: String, position: Vector3, rotation_y: float, pitch_degrees: float = 0.0) -> void:
	_set_player_pose(position, rotation_y, pitch_degrees)
	await _settle()
	await _capture(name)


func _set_player_pose(position: Vector3, rotation_y: float, pitch_degrees: float = 0.0) -> void:
	if _player == null:
		return
	if _player.has_method("set_room_position"):
		_player.set_room_position(position)
	else:
		_player.global_position = position
	if _player.has_method("set_room_rotation_y"):
		_player.set_room_rotation_y(rotation_y)
	else:
		_player.rotation_degrees.y = rotation_y
	if _player.has_method("_set_pitch_degrees"):
		_player._set_pitch_degrees(pitch_degrees)


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
	print("OPENING JOURNEY: %d passed, %d failed" % [_pass_count, _fail_count])
	if _capture_enabled:
		print("Screenshots: %s" % ProjectSettings.globalize_path(_screenshot_dir))
	else:
		print("Screenshots: skipped in headless mode")
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _write_manifest() -> void:
	var dir_path := ProjectSettings.globalize_path(_screenshot_dir)
	DirAccess.make_dir_recursive_absolute(dir_path)
	var file := FileAccess.open(dir_path.path_join("opening_manifest.txt"), FileAccess.WRITE)
	if file == null:
		return
	file.store_line("Ashworth Manor Opening Journey")
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
