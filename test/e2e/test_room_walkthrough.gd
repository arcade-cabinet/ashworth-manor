extends SceneTree
## Integration Walkthrough — visits every room in play order, interacts with
## every object, captures screenshots for visual review.
## Run: godot --headless --script test/e2e/test_room_walkthrough.gd
## Output: headless = validation only, renderer = user://screenshots/walkthrough/*.png

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _player_camera: Camera3D = null
var _qa_camera: Camera3D = null
var _player: Node3D = null
var _world: WorldDeclaration = null
var _room_entry_position: Vector3 = Vector3.ZERO
var _room_entry_rotation_y: float = 0.0
var _restore_pose_after_capture: bool = false
var _frame: int = 0
var _step: int = 0
var _steps: Array = []
var _screenshot_dir: String = "user://screenshots/walkthrough/"
var _milestone_dir: String = "user://screenshots/walkthrough/milestones/"
var _pass_count: int = 0
var _fail_count: int = 0
var _capture_enabled: bool = true
var _framing_warning_count: int = 0
var _framing_failure_count: int = 0
var _framing_log: PackedStringArray = []
var _milestone_log: PackedStringArray = []
var _capture_manifest_log: PackedStringArray = []
var _last_capture_name: String = ""
var _finishing: bool = false
var _last_interaction_target: Vector3 = Vector3.ZERO
var _has_last_interaction_target: bool = false
var _restore_ui_after_capture: bool = false
var _ui_was_visible_before_capture: bool = true

const CRITICAL_ENTRY_ROOMS := {
	"front_gate": true,
	"foyer": true,
	"parlor": true,
	"dining_room": true,
	"kitchen": true,
	"storage_basement": true,
	"boiler_room": true,
	"wine_cellar": true,
	"family_crypt": true,
	"upper_hallway": true,
	"library": true,
	"attic_stairs": true,
	"attic_storage": true,
	"hidden_chamber": true,
}
const ENTRY_MAX_PITCH_DEG := 12.0
const ENTRY_MAX_FOCAL_ANGLE_DEG := 35.0
const ENTRY_MAX_BLOCKER_DISTANCE := 1.2
const ENTRY_MAX_BLOCKER_ANGLE_DEG := 26.0
const ENTRY_MAX_BLOCKER_HEIGHT_DELTA := 1.4
const ENTRY_MAX_STRUCTURAL_DISTANCE := 1.55
const ENTRY_MAX_STRUCTURAL_ANGLE_DEG := 30.0
const ENTRY_MIN_WALL_CLEARANCE := 0.75
const ENTRY_NEAR_SURFACE_DISTANCE := 0.68
const CRITICAL_MILESTONE_CAPTURES := {
	"front_gate_entry": true,
	"foyer_entry": true,
	"storage_basement_basement_mattress": true,
	"storage_basement_scratched_portrait": true,
	"boiler_room_entry": true,
	"wine_cellar_entry": true,
	"wine_cellar_overview": true,
	"family_crypt_crypt_graves": true,
	"carriage_house_entry": true,
	"attic_stairs_entry": true,
	"attic_storage_elizabeth_portrait": true,
	"attic_storage_attic_music_box": true,
	"hidden_chamber_entry": true,
	"hidden_chamber_overview": true,
	"hidden_chamber_child_music_box": true,
	"family_crypt_crypt_music_box": true,
}
const CUSTOM_CAPTURE_POSES := {
	"foyer_overview": {
		"mode": "qa",
		"position": Vector3(-0.45, 2.0, -4.05),
		"target": Vector3(1.4, 1.45, 2.15),
	},
	"storage_basement_overview": {
		"mode": "qa",
		"position": Vector3(-2.8, 1.9, 0.9),
		"target": Vector3(1.95, 0.95, 2.2),
	},
	"storage_basement_improvised_relight": {
		"mode": "qa",
		"position": Vector3(-1.05, 1.45, -0.35),
		"target": Vector3(2.2, 0.9, 2.0),
	},
	"boiler_room_overview": {
		"mode": "qa",
		"position": Vector3(-2.55, 1.95, -1.35),
		"target": Vector3(0.65, 1.3, 2.8),
	},
	"boiler_room_gas_restore": {
		"mode": "qa",
		"position": Vector3(-1.2, 1.5, -0.75),
		"target": Vector3(2.1, 1.22, 3.0),
	},
	"family_crypt_overview": {
		"mode": "qa",
		"position": Vector3(-2.2, 1.65, -1.9),
		"target": Vector3(0.8, 0.82, 1.35),
	},
	"family_crypt_crypt_graves": {
		"mode": "qa",
		"position": Vector3(-1.4, 1.35, -1.55),
		"target": Vector3(0.35, 0.76, 1.45),
	},
	"family_crypt_crypt_music_box": {
		"mode": "qa",
		"position": Vector3(0.7, 1.28, -0.1),
		"target": Vector3(1.95, 0.82, 1.02),
	},
	"hidden_chamber_child_music_box": {
		"mode": "qa",
		"position": Vector3(-0.8, 1.45, -0.2),
		"target": Vector3(1.1, 0.82, 2.1),
	},
}


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(_screenshot_dir)
	DirAccess.make_dir_recursive_absolute(_milestone_dir)
	_capture_enabled = DisplayServer.get_name() != "headless"
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_setup")


func _setup() -> void:
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_ui = _find(_main, "UIOverlay")
	_player_camera = _find_camera(_main)
	_player = _find(_main, "PlayerController") as Node3D
	_world = load("res://declarations/world.tres") as WorldDeclaration
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_clear_save_data()
	_gm.new_game()
	_setup_capture_camera()
	_disable_nonessential_runtime_systems()
	_build_walkthrough()
	_step = 0
	print("Walkthrough: %d steps queued" % _steps.size())
	print("Capture mode: %s" % ("screenshots" if _capture_enabled else "headless-validation"))


func _build_walkthrough() -> void:
	for entry in WalkthroughData.get_play_order():
		var room_id: String = entry[0]
		var obj_ids: Array = entry[1]
		var entry_from_room_id: String = entry[2] if entry.size() > 2 else ""
		_steps.append({
			"type": "load_room",
			"room_id": room_id,
			"entry_from_room_id": entry_from_room_id,
		})
		_steps.append({"type": "settle"})
		_steps.append({"type": "settle"})
		_steps.append({"type": "overview", "name": "%s_overview" % room_id})
		_steps.append({"type": "entry", "name": "%s_entry" % room_id})
		for angle in [0, 90, 180, 270]:
			_steps.append({"type": "look", "angle": angle})
			_steps.append({"type": "screenshot", "name": "%s_look_%d" % [room_id, angle]})
		for obj_id in obj_ids:
			_steps.append({"type": "interact", "object_id": obj_id, "room_id": room_id})
			_steps.append({"type": "settle"})
			_steps.append({"type": "settle"})
			_steps.append({"type": "dismiss"})
			_steps.append({"type": "settle"})
			_steps.append({"type": "screenshot", "name": "%s_%s" % [room_id, obj_id]})


func _process(_delta: float) -> bool:
	_frame += 1
	if _frame % 3 != 0:
		return false
	if _step >= _steps.size():
		if not _finishing:
			_finishing = true
			call_deferred("_finish")
		return false
	_execute_step(_steps[_step])
	_step += 1
	return false


func _execute_step(s: Dictionary) -> void:
	match s["type"]:
		"load_room":
			var room_id: String = s["room_id"]
			var entry_from_room_id: String = s.get("entry_from_room_id", "")
			var entry_connection_id: String = _find_entry_connection_id(entry_from_room_id, room_id)
			_rm.load_room(room_id, entry_connection_id)
			var room = _rm.get_current_room()
			if room and _player:
				var pose: Dictionary = _resolve_entry_pose(room, room_id, entry_connection_id)
				_room_entry_position = pose.get("position", room.spawn_position)
				_room_entry_rotation_y = pose.get("rotation_y", room.spawn_rotation_y)
				_restore_entry_pose()
				_hide_qa_overlays()
				_clear_dialogue_balloons()
				print("ROOM: %s" % room.room_id)
			else:
				print("[FAIL] load: %s" % room_id)
				_fail_count += 1
		"overview":
			_set_capture_mode("qa")
			_prepare_overview_pose()
			_restore_pose_after_capture = true
			_capture(s["name"])
		"entry":
			_restore_entry_pose()
			_set_capture_mode("player")
			_capture(s["name"])
		"look":
			if _player:
				_set_player_yaw(float(s["angle"]))
				_set_capture_mode("player")
				_sync_capture_camera_to_player()
		"interact":
			_do_interact(s["object_id"], s.get("room_id", ""))
		"settle":
			pass
		"screenshot":
			_capture(s["name"])
		"dismiss":
			if _ui and _ui.has_method("hide_document"):
				_ui.hide_document()
			var tree := _main.get_tree() if _main != null else null
			if tree != null and tree.paused and _ui != null and _ui.has_method("toggle_pause_menu"):
				_ui.toggle_pause_menu()
			_clear_dialogue_balloons()


func _do_interact(obj_id: String, room_id: String) -> void:
	var room = _rm.get_current_room()
	if room == null:
		return
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == obj_id:
			_last_interaction_target = area.global_position
			_has_last_interaction_target = true
			_orient_player_toward(area.global_position)
			var t: String = area.get_meta("type") if area.has_meta("type") else ""
			var d: Dictionary = area.get_meta("data") if area.has_meta("data") else {}
			_im._on_interacted(obj_id, t, d)
			_pass_count += 1
			return
	print("[MISS] %s/%s — not in scene" % [room_id, obj_id])
	_fail_count += 1


func _capture_post_draw(name: String) -> void:
	await RenderingServer.frame_post_draw
	var viewport: Viewport = _main.get_viewport() if _main != null else root
	if viewport == null:
		return
	var viewport_tex := viewport.get_texture()
	if viewport_tex == null:
		return
	var img: Image = viewport_tex.get_image()
	if img != null:
		_last_capture_name = name
		var capture_path := _screenshot_dir + name + ".png"
		img.save_png(capture_path)
		if CRITICAL_MILESTONE_CAPTURES.has(name):
			var milestone_path := _milestone_dir + name + ".png"
			img.save_png(milestone_path)
			_milestone_log.append("%s -> %s" % [name, ProjectSettings.globalize_path(milestone_path)])
	if _restore_pose_after_capture:
		_restore_pose_after_capture = false
		_restore_entry_pose()
	if _restore_ui_after_capture:
		_restore_ui_after_capture = false
		if _ui != null and is_instance_valid(_ui):
			_ui.visible = _ui_was_visible_before_capture


func _finish() -> void:
	_clear_dialogue_balloons()
	await process_frame
	await process_frame
	_hide_qa_overlays()
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()
	if _qa_camera != null and is_instance_valid(_qa_camera):
		_qa_camera.current = false
		_qa_camera.queue_free()
		_qa_camera = null
	if _player_camera != null and is_instance_valid(_player_camera):
		_player_camera.current = false
	var audio := _find(_main, "AudioManager")
	if audio != null and audio.has_method("shutdown"):
		audio.shutdown()
		await process_frame
		await process_frame
	if audio != null and is_instance_valid(audio):
		audio.queue_free()
		await process_frame
	current_scene = null
	if _main != null:
		if _main.get_parent() == root:
			root.remove_child(_main)
		_main.queue_free()
		await process_frame
		await process_frame
		await process_frame
		await process_frame
		await process_frame
		_main = null
	_rm = null
	_im = null
	_ui = null
	_player = null
	_player_camera = null
	_world = null
	_gm = null
	print("")
	print("========================================")
	print("WALKTHROUGH: %d found, %d missing" % [_pass_count, _fail_count])
	print("Framing: %d warnings, %d failures" % [_framing_warning_count, _framing_failure_count])
	_write_framing_report()
	if _capture_enabled:
		print("Screenshots: %s" % ProjectSettings.globalize_path(_screenshot_dir))
	else:
		print("Screenshots: skipped in headless mode")
	print("========================================")
	quit(1 if (_fail_count + _framing_failure_count) > 0 else 0)


func _clear_dialogue_balloons() -> void:
	if _main == null:
		return
	_queue_dialogue_balloons(_main)


func _queue_dialogue_balloons(node: Node) -> void:
	var script: Variant = node.get_script()
	if script is Script:
		var script_path: String = (script as Script).resource_path
		if script_path.contains("/addons/dialogue_manager/example_balloon/"):
			node.queue_free()
			return
	for child in node.get_children():
		_queue_dialogue_balloons(child)


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


func _clear_save_data() -> void:
	var save_system := root.get_node_or_null("SaveSystem")
	if save_system != null and save_system.has_method("delete_all"):
		save_system.delete_all()


func _hide_qa_overlays() -> void:
	if _ui == null:
		return
	if _ui.has_method("hide_document"):
		_ui.hide_document()
	var tree := _main.get_tree() if _main != null else null
	if tree != null and tree.paused and _ui.has_method("toggle_pause_menu"):
		_ui.toggle_pause_menu()
	var room_name_display := _find(_ui, "RoomNameDisplay")
	if room_name_display is Control:
		(room_name_display as Control).visible = false
	var room_name := _find(_ui, "RoomNameLabel")
	if room_name is Label:
		(room_name as Label).modulate.a = 0.0
		(room_name as Label).visible = false


func _restore_entry_pose() -> void:
	if _player == null:
		return
	if _player.has_method("set_room_position"):
		_player.set_room_position(_room_entry_position)
	else:
		_player.global_position = _room_entry_position
	_set_player_yaw(_room_entry_rotation_y)
	_sync_capture_camera_to_player()


func _prepare_overview_pose() -> void:
	var room = _rm.get_current_room() if _rm != null and _rm.has_method("get_current_room") else null
	if room == null or _qa_camera == null:
		return
	var decl = room.get_meta("declaration") if room.has_meta("declaration") else null
	if decl == null:
		return
	var room_origin := _get_room_world_origin(room)
	var dims: Vector3 = decl.get("dimensions") if decl.has_method("get") else Vector3(12, 4, 12)
	if dims == Vector3.ZERO:
		dims = Vector3(12, 4, 12)
	var center := room_origin + Vector3(0, maxf(1.4, dims.y * 0.35), 0)
	var is_exterior: bool = bool(decl.get("is_exterior")) if decl.has_method("get") else false
	var cam_pos := room_origin + Vector3(
		maxf(2.4, dims.x * 0.22),
		maxf(3.6, dims.y * (1.1 if is_exterior else 0.82)),
		-maxf(6.0, dims.z * (0.72 if is_exterior else 0.55))
	)
	_qa_camera.global_position = cam_pos
	_qa_camera.look_at(center, Vector3.UP)


func _setup_capture_camera() -> void:
	if not _capture_enabled or _main == null:
		return
	_qa_camera = Camera3D.new()
	_qa_camera.name = "QACamera3D"
	_qa_camera.current = true
	_qa_camera.fov = 70.0
	_qa_camera.near = 0.05
	_qa_camera.far = 200.0
	_main.add_child(_qa_camera)
	_set_capture_mode("player")


func _set_capture_mode(mode: String) -> void:
	if not _capture_enabled:
		return
	if _player_camera != null:
		_player_camera.current = mode == "player"
	if _qa_camera != null:
		_qa_camera.current = mode == "qa"


func _sync_capture_camera_to_player() -> void:
	if _qa_camera == null or _player == null:
		return
	var view_camera: Camera3D = _player.get_view_camera() if _player.has_method("get_view_camera") else null
	if view_camera != null:
		_player_camera = view_camera
		_qa_camera.global_transform = view_camera.global_transform
		_qa_camera.fov = view_camera.fov
		_qa_camera.near = view_camera.near
		_qa_camera.far = view_camera.far
		return
	_qa_camera.global_position = _player.global_position + Vector3(0, 1.7, 0)
	_qa_camera.global_rotation = Vector3.ZERO
	_qa_camera.rotation_degrees = Vector3(0, _player.rotation_degrees.y, 0)


func _set_player_yaw(rotation_y_deg: float) -> void:
	if _player == null:
		return
	if _player.has_method("set_room_rotation_y"):
		_player.set_room_rotation_y(rotation_y_deg)
	else:
		_player.rotation_degrees = Vector3(0, rotation_y_deg, 0)


func _orient_player_toward(target_world: Vector3) -> void:
	if _player == null:
		return
	var view_camera: Camera3D = _player.get_view_camera() if _player.has_method("get_view_camera") else _player_camera
	var eye: Vector3 = view_camera.global_position if view_camera != null else (_player.global_position + Vector3(0, 1.7, 0))
	var to_target: Vector3 = target_world - eye
	if to_target.length_squared() <= 0.001:
		return
	var flat := Vector2(to_target.x, to_target.z)
	if flat.length() > 0.001:
		_set_player_yaw(rad_to_deg(atan2(-flat.x, -flat.y)))
	if _player.has_method("_set_pitch_degrees"):
		var pitch_deg := clampf(rad_to_deg(atan2(to_target.y, maxf(flat.length(), 0.01))), -4.0, 12.0)
		_player._set_pitch_degrees(pitch_deg)
	_sync_capture_camera_to_player()


func _resolve_entry_pose(room: RoomBase, room_id: String, entry_connection_id: String) -> Dictionary:
	var room_origin := _get_room_world_origin(room)
	var spawn_position: Vector3 = room.spawn_position + room_origin
	var spawn_rotation_y: float = room.spawn_rotation_y
	var decl = room.get_meta("declaration") if room.has_meta("declaration") else null
	if decl != null:
		var entry_anchor = _get_primary_anchor(decl.get("entry_anchors"))
		if entry_anchor != null:
			spawn_position = entry_anchor.position + room_origin
			spawn_rotation_y = entry_anchor.rotation_y
			var focal_anchor = _find_target_focal_anchor(decl, entry_anchor)
			if focal_anchor != null:
				spawn_rotation_y = _yaw_to_target(entry_anchor.position + room_origin, focal_anchor.position + room_origin)
	if _world == null or entry_connection_id.is_empty():
		return {"position": spawn_position, "rotation_y": spawn_rotation_y}
	for conn in _world.connections:
		if conn != null and conn.id == entry_connection_id and conn.to_room == room_id:
			if decl != null:
				var entry_anchor = _find_anchor_by_id(decl.get("entry_anchors"), conn.to_anchor_id)
				var focal_anchor = _find_anchor_by_id(decl.get("focal_anchors"), conn.focal_anchor_id)
				if entry_anchor != null:
					spawn_position = entry_anchor.position + room_origin
					spawn_rotation_y = entry_anchor.rotation_y
					if focal_anchor != null:
						spawn_rotation_y = _yaw_to_target(entry_anchor.position + room_origin, focal_anchor.position + room_origin)
					return {"position": spawn_position, "rotation_y": spawn_rotation_y}
			return {"position": conn.position_in_to + room_origin, "rotation_y": conn.spawn_rotation_y}
	return {"position": spawn_position, "rotation_y": spawn_rotation_y}


func _capture(name: String) -> void:
	if not _capture_enabled:
		if name.ends_with("_entry"):
			_validate_entry_framing(name)
		return
	if _apply_custom_capture_pose(name):
		pass
	elif _should_use_detail_capture(name):
		_prepare_detail_pose(_last_interaction_target)
		_set_capture_mode("qa")
	elif name.ends_with("_overview"):
		_set_capture_mode("qa")
		_prepare_overview_pose()
	if name.ends_with("_entry"):
		_validate_entry_framing(name)
		_set_capture_mode("player")
	_hide_qa_overlays()
	if _ui != null and is_instance_valid(_ui):
		_ui_was_visible_before_capture = _ui.visible
		_ui.visible = false
		_restore_ui_after_capture = true
	_record_capture_context(name)
	call_deferred("_capture_post_draw", name)


func _should_use_detail_capture(name: String) -> bool:
	if not _has_last_interaction_target:
		return false
	return name in [
		"attic_storage_attic_music_box",
		"family_crypt_crypt_music_box",
		"hidden_chamber_child_music_box",
	]


func _apply_custom_capture_pose(name: String) -> bool:
	if not CUSTOM_CAPTURE_POSES.has(name) or _qa_camera == null:
		return false
	var spec: Dictionary = CUSTOM_CAPTURE_POSES[name]
	var room = _rm.get_current_room() if _rm != null and _rm.has_method("get_current_room") else null
	var room_origin := _get_room_world_origin(room)
	var position: Vector3 = spec.get("position", Vector3.ZERO) + room_origin
	var target: Vector3 = spec.get("target", Vector3.ZERO) + room_origin
	_qa_camera.global_position = position
	_qa_camera.look_at(target, Vector3.UP)
	_set_capture_mode(String(spec.get("mode", "qa")))
	return true


func _prepare_detail_pose(target_world: Vector3) -> void:
	if _qa_camera == null:
		return
	var view_camera: Camera3D = _player.get_view_camera() if _player != null and _player.has_method("get_view_camera") else _player_camera
	var eye: Vector3 = view_camera.global_position if view_camera != null else (_room_entry_position + Vector3(0.0, 1.7, 0.0))
	var back_dir := eye - target_world
	back_dir.y = 0.0
	if back_dir.length_squared() <= 0.001:
		back_dir = Vector3(0.0, 0.0, 1.0)
	back_dir = back_dir.normalized()
	var side_dir := Vector3.UP.cross(back_dir).normalized()
	var cam_pos := target_world + back_dir * 2.4 + side_dir * 0.6 + Vector3(0.0, 1.15, 0.0)
	_qa_camera.global_position = cam_pos
	_qa_camera.look_at(target_world + Vector3(0.0, 0.5, 0.0), Vector3.UP)


func _validate_entry_framing(name: String) -> void:
	var room_id := name.trim_suffix("_entry")
	if _player == null:
		return
	var is_critical: bool = CRITICAL_ENTRY_ROOMS.has(room_id)
	var view_camera: Camera3D = _player.get_view_camera() if _player.has_method("get_view_camera") else _player_camera
	if view_camera == null:
		_log_framing_issue(room_id, "warning", "No active player camera available for framing validation", is_critical)
		return
	var pitch_deg: float = _player.get_view_pitch_degrees() if _player.has_method("get_view_pitch_degrees") else rad_to_deg(view_camera.global_rotation.x)
	if absf(pitch_deg) > ENTRY_MAX_PITCH_DEG:
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"Entry pitch %.1f exceeds %.1f and risks dollhouse/ceiling framing" % [pitch_deg, ENTRY_MAX_PITCH_DEG], is_critical)

	var room = _rm.get_current_room() if _rm != null and _rm.has_method("get_current_room") else null
	if room == null or not room.has_meta("declaration"):
		return
	var decl = room.get_meta("declaration") as RoomDeclaration
	if decl == null:
		return
	var room_origin := _get_room_world_origin(room)
	var focal_anchor = _resolve_entry_focal_anchor(decl)
	if focal_anchor != null:
		var to_focal: Vector3 = (focal_anchor.position + room_origin) - view_camera.global_position
		var forward: Vector3 = -view_camera.global_transform.basis.z
		if to_focal.length_squared() > 0.001 and forward.length_squared() > 0.001:
			var angle_deg := rad_to_deg(acos(clampf(forward.normalized().dot(to_focal.normalized()), -1.0, 1.0)))
			if angle_deg > ENTRY_MAX_FOCAL_ANGLE_DEG:
				_log_framing_issue(room_id, "failure" if is_critical else "warning",
					"Focal anchor '%s' sits %.1f deg off the entry forward cone" % [focal_anchor.anchor_id, angle_deg], is_critical)

	_validate_wall_clearance(room_id, decl, room_origin, view_camera.global_position, -view_camera.global_transform.basis.z, is_critical)
	_validate_spawn_blockers(room_id, decl, room_origin, view_camera.global_position, -view_camera.global_transform.basis.z, is_critical)
	_validate_frame_surface_balance(room_id, view_camera, is_critical)
	_validate_near_surface_intrusion(room_id, view_camera, is_critical)


func _resolve_entry_focal_anchor(decl: RoomDeclaration) -> Variant:
	var entry_anchor = _get_primary_anchor(decl.entry_anchors)
	var focal_anchor = _find_target_focal_anchor(decl, entry_anchor) if entry_anchor != null else null
	if focal_anchor == null:
		focal_anchor = _get_primary_anchor(decl.focal_anchors)
	return focal_anchor


func _validate_spawn_blockers(room_id: String, decl: RoomDeclaration, room_origin: Vector3, eye_pos: Vector3, forward: Vector3, is_critical: bool) -> void:
	var forward_flat := forward.normalized()
	for prop in decl.props:
		if prop == null:
			continue
		var to_prop: Vector3 = (prop.position + room_origin) - eye_pos
		var flat_dist := Vector2(to_prop.x, to_prop.z).length()
		var structural := _is_structural_blocker_prop(prop)
		var max_dist := ENTRY_MAX_STRUCTURAL_DISTANCE if structural else ENTRY_MAX_BLOCKER_DISTANCE
		var max_angle := ENTRY_MAX_STRUCTURAL_ANGLE_DEG if structural else ENTRY_MAX_BLOCKER_ANGLE_DEG
		if flat_dist > max_dist:
			continue
		if absf(to_prop.y) > ENTRY_MAX_BLOCKER_HEIGHT_DELTA:
			continue
		var angle_deg := _angle_to_forward_deg(forward_flat, to_prop)
		if angle_deg > max_angle:
			continue
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"%s '%s' intrudes into the entry cone at %.2fm / %.1f deg" % [
				"Structural prop" if structural else "Prop",
				prop.id,
				flat_dist,
				angle_deg,
			], is_critical)
		return


func _angle_to_forward_deg(forward: Vector3, offset: Vector3) -> float:
	var flat_forward := Vector3(forward.x, 0, forward.z)
	var flat_offset := Vector3(offset.x, 0, offset.z)
	if flat_forward.length_squared() <= 0.001 or flat_offset.length_squared() <= 0.001:
		return 180.0
	return rad_to_deg(acos(clampf(flat_forward.normalized().dot(flat_offset.normalized()), -1.0, 1.0)))


func _validate_wall_clearance(room_id: String, decl: RoomDeclaration, room_origin: Vector3, eye_pos: Vector3, forward: Vector3, is_critical: bool) -> void:
	if decl == null or decl.is_exterior:
		return
	var local_eye := eye_pos - room_origin
	var half_width := decl.dimensions.x * 0.5
	var half_depth := decl.dimensions.z * 0.5
	var forward_flat := Vector3(forward.x, 0.0, forward.z)
	if forward_flat.length_squared() <= 0.001:
		return
	forward_flat = forward_flat.normalized()
	var wall_name := ""
	var wall_distance := INF
	if forward_flat.z < -0.28:
		wall_name = "north"
		wall_distance = absf(local_eye.z + half_depth)
	elif forward_flat.z > 0.28:
		wall_name = "south"
		wall_distance = absf(half_depth - local_eye.z)
	elif forward_flat.x > 0.28:
		wall_name = "east"
		wall_distance = absf(half_width - local_eye.x)
	elif forward_flat.x < -0.28:
		wall_name = "west"
		wall_distance = absf(local_eye.x + half_width)
	if wall_name.is_empty():
		return
	if wall_distance < ENTRY_MIN_WALL_CLEARANCE:
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"Entry camera sits only %.2fm from the %s wall and risks a cramped threshold read" % [wall_distance, wall_name], is_critical)


func _validate_near_surface_intrusion(room_id: String, view_camera: Camera3D, is_critical: bool) -> void:
	var viewport := _main.get_viewport() if _main != null else null
	if viewport == null:
		return
	var size := viewport.get_visible_rect().size
	if size.x <= 0 or size.y <= 0:
		return
	var world3d := view_camera.get_world_3d()
	if world3d == null:
		return
	var space := world3d.direct_space_state
	if space == null:
		return
	var intrusive_hits := 0
	var center_intrusions := 0
	var nearest_intrusion := INF
	for sample_x in [0.28, 0.5, 0.72]:
		for sample_y in [0.38, 0.54, 0.7]:
			var screen_pos := Vector2(size.x * sample_x, size.y * sample_y)
			var from := view_camera.project_ray_origin(screen_pos)
			var to := from + view_camera.project_ray_normal(screen_pos) * 1.2
			var hit := _raycast_view(space, from, to)
			if hit.is_empty():
				continue
			var collider_name := _get_collider_name(hit)
			if collider_name.begins_with("FloorCollision") or collider_name.begins_with("CeilingCollision"):
				continue
			var hit_distance := from.distance_to(hit.get("position", from))
			if hit_distance > ENTRY_NEAR_SURFACE_DISTANCE:
				continue
			intrusive_hits += 1
			nearest_intrusion = minf(nearest_intrusion, hit_distance)
			if absf(sample_x - 0.5) <= 0.12:
				center_intrusions += 1
	if center_intrusions >= 3 or (center_intrusions >= 2 and nearest_intrusion <= 0.52) or intrusive_hits >= 5:
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"Near wall or column geometry crowds the first-person frame", is_critical)


func _is_structural_blocker_prop(prop: PropDecl) -> bool:
	if prop == null:
		return false
	if prop.scene_role in ["architectural_trim", "threshold_trim"]:
		return true
	for tag in prop.tags:
		var lower_tag := String(tag).to_lower()
		if lower_tag.contains("column") or lower_tag.contains("pillar") or lower_tag.contains("wall") or lower_tag.contains("frame") or lower_tag.contains("trim") or lower_tag.contains("banister"):
			return true
	var haystack := "%s %s %s" % [prop.id, prop.model, prop.scene_path]
	haystack = haystack.to_lower()
	for keyword in ["column", "pillar", "wall", "frame", "trim", "banister", "frieze", "molding", "moulding", "arch", "post"]:
		if haystack.contains(keyword):
			return true
	return false


func _log_framing_issue(room_id: String, severity: String, message: String, counts_as_failure: bool) -> void:
	var line := "[%s] %s: %s" % [severity.to_upper(), room_id, message]
	_framing_log.append(line)
	if severity == "failure" and counts_as_failure:
		_framing_failure_count += 1
	else:
		_framing_warning_count += 1
	print(line)


func _write_framing_report() -> void:
	var dir_path := ProjectSettings.globalize_path(_screenshot_dir)
	DirAccess.make_dir_recursive_absolute(dir_path)
	var path := dir_path.path_join("framing_report.txt")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return
	file.store_line("Ashworth Manor Walkthrough Framing Report")
	file.store_line("warnings=%d failures=%d" % [_framing_warning_count, _framing_failure_count])
	file.store_line("last_capture=%s" % _last_capture_name)
	file.store_line("")
	for line in _framing_log:
		file.store_line(line)
	file.close()
	var milestone_path := dir_path.path_join("milestone_manifest.txt")
	var milestone_file := FileAccess.open(milestone_path, FileAccess.WRITE)
	if milestone_file == null:
		return
	milestone_file.store_line("Ashworth Manor Walkthrough Milestones")
	milestone_file.store_line("capture_enabled=%s" % str(_capture_enabled))
	milestone_file.store_line("")
	for line in _milestone_log:
		milestone_file.store_line(line)
	milestone_file.close()
	var capture_manifest_path := dir_path.path_join("capture_manifest.txt")
	var capture_manifest_file := FileAccess.open(capture_manifest_path, FileAccess.WRITE)
	if capture_manifest_file == null:
		return
	capture_manifest_file.store_line("Ashworth Manor Walkthrough Capture Manifest")
	capture_manifest_file.store_line("capture_enabled=%s" % str(_capture_enabled))
	capture_manifest_file.store_line("")
	for line in _capture_manifest_log:
		capture_manifest_file.store_line(line)
	capture_manifest_file.close()


func _record_capture_context(name: String) -> void:
	var room_id: String = _rm.get_current_room_id() if _rm != null and _rm.has_method("get_current_room_id") else ""
	var compiled_world_id: String = _rm.get_current_compiled_world_id() if _rm != null and _rm.has_method("get_current_compiled_world_id") else ""
	var visible_rooms: PackedStringArray = _rm.get_visible_compiled_world_room_ids() if _rm != null and _rm.has_method("get_visible_compiled_world_room_ids") else PackedStringArray()
	var room: Node = _rm.get_current_room() if _rm != null and _rm.has_method("get_current_room") else null
	var room_origin := _get_room_world_origin(room)
	var player_pos := _player.global_position if _player != null else Vector3.ZERO
	var view_camera: Camera3D = _player.get_view_camera() if _player != null and _player.has_method("get_view_camera") else _player_camera
	var camera_pos := view_camera.global_position if view_camera != null else Vector3.ZERO
	var yaw_deg := _player.rotation_degrees.y if _player != null else 0.0
	var pitch_deg: float = _player.get_view_pitch_degrees() if _player != null and _player.has_method("get_view_pitch_degrees") else 0.0
	_capture_manifest_log.append("%s | room=%s | world=%s | room_origin=%s | player=%s | camera=%s | yaw=%.2f | pitch=%.2f | visible=%s" % [
		name,
		room_id,
		compiled_world_id,
		room_origin,
		player_pos,
		camera_pos,
		yaw_deg,
		pitch_deg,
		",".join(PackedStringArray(visible_rooms)),
	])


func _validate_frame_surface_balance(room_id: String, view_camera: Camera3D, is_critical: bool) -> void:
	var viewport := _main.get_viewport() if _main != null else null
	if viewport == null:
		return
	var size := viewport.get_visible_rect().size
	if size.x <= 0 or size.y <= 0:
		return
	var world3d := view_camera.get_world_3d()
	if world3d == null:
		return
	var space := world3d.direct_space_state
	if space == null:
		return
	var top_hits := _sample_surface_band(view_camera, space, size, 0.18)
	var mid_hits := _sample_surface_band(view_camera, space, size, 0.50)
	var bottom_hits := _sample_surface_band(view_camera, space, size, 0.82)
	if top_hits["ceiling"] >= 4 and top_hits["close"] >= 3 and mid_hits["ceiling"] >= 2:
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"Ceiling dominates the first-person frame and reads like a dollhouse cutaway", is_critical)
	if bottom_hits["floor"] >= 4 and bottom_hits["close"] >= 3 and mid_hits["floor"] >= 2:
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"Floor dominates the first-person frame and reads too steeply downward", is_critical)


func _sample_surface_band(view_camera: Camera3D, space: PhysicsDirectSpaceState3D, size: Vector2, band_y: float) -> Dictionary:
	var result := {"floor": 0, "ceiling": 0, "close": 0}
	for sample_x in [0.14, 0.32, 0.5, 0.68, 0.86]:
		var screen_pos := Vector2(size.x * sample_x, size.y * band_y)
		var from := view_camera.project_ray_origin(screen_pos)
		var to := from + view_camera.project_ray_normal(screen_pos) * 8.0
		var hit := _raycast_view(space, from, to)
		if hit.is_empty():
			continue
		var collider_name := _get_collider_name(hit)
		if collider_name.begins_with("FloorCollision"):
			result["floor"] += 1
		elif collider_name.begins_with("CeilingCollision"):
			result["ceiling"] += 1
		if from.distance_to(hit.get("position", from)) <= 3.6:
			result["close"] += 1
	return result


func _raycast_view(space: PhysicsDirectSpaceState3D, from: Vector3, to: Vector3) -> Dictionary:
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = (1 << 0) | (1 << 1)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.exclude = _get_view_raycast_excludes()
	return space.intersect_ray(query)


func _get_collider_name(hit: Dictionary) -> String:
	var collider: Object = hit.get("collider")
	return String(collider.name) if collider != null else ""


func _get_view_raycast_excludes() -> Array:
	var excludes: Array = []
	if _player != null and _player is CollisionObject3D:
		excludes.append((_player as CollisionObject3D).get_rid())
	return excludes


func _get_room_world_origin(room: Node) -> Vector3:
	if room == null:
		return Vector3.ZERO
	if room is Node3D:
		return (room as Node3D).global_position
	return Vector3.ZERO


func _get_primary_anchor(anchors: Array) -> Variant:
	if anchors == null or anchors.is_empty():
		return null
	return anchors[0]


func _find_target_focal_anchor(decl, entry_anchor) -> Variant:
	var target_id: String = entry_anchor.target_anchor_id
	if target_id.is_empty():
		return null
	return _find_anchor_by_id(decl.get("focal_anchors"), target_id)


func _find_anchor_by_id(anchors: Array, anchor_id: String) -> Variant:
	if anchor_id.is_empty():
		return null
	for anchor in anchors:
		if anchor != null and anchor.anchor_id == anchor_id:
			return anchor
	return null


func _yaw_to_target(from: Vector3, target: Vector3) -> float:
	var flat := Vector2(target.x - from.x, target.z - from.z)
	if flat.length() <= 0.001:
		return 0.0
	return rad_to_deg(atan2(-flat.x, -flat.y))


func _find_entry_connection_id(previous_room_id: String, room_id: String) -> String:
	if _world == null or previous_room_id.is_empty():
		return ""
	for conn in _world.connections:
		if conn != null and conn.from_room == previous_room_id and conn.to_room == room_id:
			return conn.id
	return ""


func _find_camera(n: Node) -> Camera3D:
	if n is Camera3D:
		return n as Camera3D
	for ch in n.get_children():
		var f = _find_camera(ch)
		if f:
			return f
	return null


func _find(n: Node, t: String) -> Node:
	if n.name == t:
		return n
	for ch in n.get_children():
		var f: Node = _find(ch, t)
		if f != null:
			return f
	return null
