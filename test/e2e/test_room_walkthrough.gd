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
var _last_capture_name: String = ""
var _finishing: bool = false

const CRITICAL_ENTRY_ROOMS := {
	"front_gate": true,
	"foyer": true,
	"parlor": true,
	"dining_room": true,
	"kitchen": true,
	"storage_basement": true,
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
const CRITICAL_MILESTONE_CAPTURES := {
	"front_gate_entry": true,
	"foyer_entry": true,
	"storage_basement_entry": true,
	"carriage_house_entry": true,
	"attic_stairs_entry": true,
	"hidden_chamber_entry": true,
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
		_steps.append({"type": "overview", "name": "%s_overview" % room_id})
		_steps.append({"type": "entry", "name": "%s_entry" % room_id})
		for angle in [0, 90, 180, 270]:
			_steps.append({"type": "look", "angle": angle})
			_steps.append({"type": "screenshot", "name": "%s_look_%d" % [room_id, angle]})
		for obj_id in obj_ids:
			_steps.append({"type": "interact", "object_id": obj_id, "room_id": room_id})
			_steps.append({"type": "screenshot", "name": "%s_%s" % [room_id, obj_id]})
			_steps.append({"type": "dismiss"})


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
		"screenshot":
			_capture(s["name"])
		"dismiss":
			if _ui and _ui.has_method("hide_document"):
				_ui.hide_document()
			_clear_dialogue_balloons()


func _do_interact(obj_id: String, room_id: String) -> void:
	var room = _rm.get_current_room()
	if room == null:
		return
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == obj_id:
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


func _hide_qa_overlays() -> void:
	if _ui == null:
		return
	if _ui.has_method("hide_document"):
		_ui.hide_document()
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
	var dims: Vector3 = decl.get("dimensions") if decl.has_method("get") else Vector3(12, 4, 12)
	if dims == Vector3.ZERO:
		dims = Vector3(12, 4, 12)
	var center := Vector3(0, maxf(1.4, dims.y * 0.35), 0)
	var is_exterior: bool = bool(decl.get("is_exterior")) if decl.has_method("get") else false
	var cam_pos := Vector3(
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


func _resolve_entry_pose(room: RoomBase, room_id: String, entry_connection_id: String) -> Dictionary:
	var spawn_position: Vector3 = room.spawn_position
	var spawn_rotation_y: float = room.spawn_rotation_y
	var decl = room.get_meta("declaration") if room.has_meta("declaration") else null
	if decl != null:
		var entry_anchor = _get_primary_anchor(decl.get("entry_anchors"))
		if entry_anchor != null:
			spawn_position = entry_anchor.position
			spawn_rotation_y = entry_anchor.rotation_y
			var focal_anchor = _find_target_focal_anchor(decl, entry_anchor)
			if focal_anchor != null:
				spawn_rotation_y = _yaw_to_target(entry_anchor.position, focal_anchor.position)
	if _world == null or entry_connection_id.is_empty():
		return {"position": spawn_position, "rotation_y": spawn_rotation_y}
	for conn in _world.connections:
		if conn != null and conn.id == entry_connection_id and conn.to_room == room_id:
			if decl != null:
				var entry_anchor = _find_anchor_by_id(decl.get("entry_anchors"), conn.to_anchor_id)
				var focal_anchor = _find_anchor_by_id(decl.get("focal_anchors"), conn.focal_anchor_id)
				if entry_anchor != null:
					spawn_position = entry_anchor.position
					spawn_rotation_y = entry_anchor.rotation_y
					if focal_anchor != null:
						spawn_rotation_y = _yaw_to_target(entry_anchor.position, focal_anchor.position)
					return {"position": spawn_position, "rotation_y": spawn_rotation_y}
			return {"position": conn.position_in_to, "rotation_y": conn.spawn_rotation_y}
	return {"position": spawn_position, "rotation_y": spawn_rotation_y}


func _capture(name: String) -> void:
	if not _capture_enabled:
		if name.ends_with("_entry"):
			_validate_entry_framing(name)
		return
	if name.ends_with("_entry"):
		_validate_entry_framing(name)
		_set_capture_mode("player")
	_hide_qa_overlays()
	call_deferred("_capture_post_draw", name)


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
	var focal_anchor = _resolve_entry_focal_anchor(decl)
	if focal_anchor != null:
		var to_focal: Vector3 = focal_anchor.position - view_camera.global_position
		var forward: Vector3 = -view_camera.global_transform.basis.z
		if to_focal.length_squared() > 0.001 and forward.length_squared() > 0.001:
			var angle_deg := rad_to_deg(acos(clampf(forward.normalized().dot(to_focal.normalized()), -1.0, 1.0)))
			if angle_deg > ENTRY_MAX_FOCAL_ANGLE_DEG:
				_log_framing_issue(room_id, "failure" if is_critical else "warning",
					"Focal anchor '%s' sits %.1f deg off the entry forward cone" % [focal_anchor.anchor_id, angle_deg], is_critical)

	_validate_spawn_blockers(room_id, decl, view_camera.global_position, -view_camera.global_transform.basis.z, is_critical)
	_validate_frame_surface_balance(room_id, view_camera, is_critical)


func _resolve_entry_focal_anchor(decl: RoomDeclaration) -> Variant:
	var entry_anchor = _get_primary_anchor(decl.entry_anchors)
	var focal_anchor = _find_target_focal_anchor(decl, entry_anchor) if entry_anchor != null else null
	if focal_anchor == null:
		focal_anchor = _get_primary_anchor(decl.focal_anchors)
	return focal_anchor


func _validate_spawn_blockers(room_id: String, decl: RoomDeclaration, eye_pos: Vector3, forward: Vector3, is_critical: bool) -> void:
	var forward_flat := forward.normalized()
	for prop in decl.props:
		if prop == null:
			continue
		var to_prop: Vector3 = prop.position - eye_pos
		var flat_dist := Vector2(to_prop.x, to_prop.z).length()
		if flat_dist > ENTRY_MAX_BLOCKER_DISTANCE:
			continue
		if absf(to_prop.y) > ENTRY_MAX_BLOCKER_HEIGHT_DELTA:
			continue
		var angle_deg := _angle_to_forward_deg(forward_flat, to_prop)
		if angle_deg > ENTRY_MAX_BLOCKER_ANGLE_DEG:
			continue
		_log_framing_issue(room_id, "failure" if is_critical else "warning",
			"Prop '%s' intrudes into the entry cone at %.2fm / %.1f deg" % [prop.id, flat_dist, angle_deg], is_critical)
		return


func _angle_to_forward_deg(forward: Vector3, offset: Vector3) -> float:
	var flat_forward := Vector3(forward.x, 0, forward.z)
	var flat_offset := Vector3(offset.x, 0, offset.z)
	if flat_forward.length_squared() <= 0.001 or flat_offset.length_squared() <= 0.001:
		return 180.0
	return rad_to_deg(acos(clampf(flat_forward.normalized().dot(flat_offset.normalized()), -1.0, 1.0)))


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
		var collider: Object = hit.get("collider")
		var collider_name := String(collider.name) if collider != null else ""
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
	return space.intersect_ray(query)


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
