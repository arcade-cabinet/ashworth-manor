extends CharacterBody3D
## res://scripts/player_controller.gd -- First-person controller
## Input in player_input.gd, camera in camera_controller.gd

signal interacted(object_id: String, object_type: String, object_data: Dictionary)
signal door_tapped(target_room: String, connection_id: String)
signal surface_investigated(surface_data: Dictionary)

const MOVE_SPEED: float = 3.0
const STOP_DISTANCE: float = 0.3
const GRAVITY: float = 9.8
const SENSITIVITY: float = 0.003
# Canonical first-person contract used by runtime entry framing and walkthrough QA.
const CAMERA_HEIGHT: float = 1.7
const DEFAULT_FOV: float = 70.0
const PITCH_LIMIT: float = 45.0
const LAYER_WALKABLE: int = 1
const LAYER_INTERACTABLE: int = 3
const LAYER_DOOR: int = 4
const INSPECT_FOCUS_DURATION: float = 0.22
const INSPECT_RELEASE_DURATION: float = 0.14
const INSPECT_LEAN_MAX: float = 0.28
const INSPECT_DROP_MAX: float = 0.12
const INSPECT_RISE_MAX: float = 0.08
const INSPECT_FOV_MIN: float = 54.0
const INSPECT_FOV_PICKUP: float = 50.0
const INSPECT_FOV_SURFACE: float = 52.0
const INTERACTION_APPROACH_DISTANCE: float = 1.65
const INTERACTION_APPROACH_STANDOFF: float = 0.8
const SURFACE_INVESTIGATION_STANDOFF: float = 0.9
const SURFACE_NORMAL_FLOOR_MIN_Y: float = 0.72
const SURFACE_NORMAL_CEILING_MAX_Y: float = -0.55
const SURFACE_DROP_MAX: float = 0.28
const SURFACE_RISE_MAX: float = 0.12

var _camera: Camera3D = null
var _cam_ctrl: Node = null
var _input_handler: Node = null
var _yaw: float = 0.0
var _pitch: float = 0.0
var _target_position: Vector3 = Vector3.INF
var _is_walking: bool = false
var _walk_marker: MeshInstance3D = null
var _traversal_tween: Tween = null
var _is_traversal_locked: bool = false
var _body_tween: Tween = null
var _interaction_focus_tween: Tween = null
var _pending_arrival_action: Dictionary = {}
var _walk_focus_world_position: Vector3 = Vector3.INF


func _ready() -> void:
	floor_snap_length = 0.5
	up_direction = Vector3.UP
	call_deferred("_connect_room_manager")

	_camera = get_node_or_null("Camera3D") as Camera3D
	if _camera == null:
		_camera = Camera3D.new()
		_camera.name = "Camera3D"
		add_child(_camera)
	_camera.position = Vector3(0, CAMERA_HEIGHT, 0)
	_camera.current = true
	_camera.fov = DEFAULT_FOV

	_cam_ctrl = preload("res://scripts/camera_controller.gd").new()
	_cam_ctrl.name = "CameraController"
	add_child(_cam_ctrl)
	_cam_ctrl.setup(_camera, self)

	_input_handler = preload("res://scripts/player_input.gd").new()
	_input_handler.name = "PlayerInput"
	add_child(_input_handler)
	_input_handler.tap_detected.connect(_handle_tap)
	_input_handler.camera_drag.connect(_rotate_camera)

	_build_walk_marker()


func _build_walk_marker() -> void:
	_walk_marker = MeshInstance3D.new()
	_walk_marker.name = "WalkMarker"
	var mesh := TorusMesh.new()
	mesh.inner_radius = 0.1
	mesh.outer_radius = 0.2
	_walk_marker.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.emission_enabled = true
	mat.emission = Color(0.7, 0.6, 0.4)
	mat.emission_energy_multiplier = 2.0
	mat.albedo_color = Color(0, 0, 0, 0)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_walk_marker.set_surface_override_material(0, mat)
	_walk_marker.rotation_degrees.x = 90
	_walk_marker.visible = false
	get_parent().call_deferred("add_child", _walk_marker)


func _unhandled_input(event: InputEvent) -> void:
	var ui: Control = get_node_or_null("/root/Main/UILayer/UIOverlay")
	if ui and ui.get("_is_document_open") == true:
		return
	if get_tree().paused:
		return
	_input_handler.handle_input(event)


func _physics_process(delta: float) -> void:
	if _is_traversal_locked:
		velocity = Vector3.ZERO
		if _cam_ctrl:
			_cam_ctrl.update_exploration_cam(global_position, _pitch, _yaw)
		if _camera:
			_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0.0

	if _is_walking and _target_position != Vector3.INF:
		var to_target: Vector3 = _target_position - global_position
		to_target.y = 0.0
		if to_target.length() < STOP_DISTANCE:
			_is_walking = false
			velocity.x = 0.0
			velocity.z = 0.0
			if _walk_marker:
				_walk_marker.visible = false
			_complete_arrival_action()
		else:
			_update_walk_focus(delta)
			var dir: Vector3 = to_target.normalized()
			velocity.x = dir.x * MOVE_SPEED
			velocity.z = dir.z * MOVE_SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	if _walk_marker and _walk_marker.visible:
		var pulse: float = 0.7 + sin(Time.get_ticks_msec() / 300.0) * 0.3
		_walk_marker.scale = Vector3(pulse, pulse, pulse)

	if _cam_ctrl:
		_cam_ctrl.update_exploration_cam(global_position, _pitch, _yaw)
	if _camera:
		_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)
	move_and_slide()


func _rotate_camera(relative: Vector2) -> void:
	_cancel_interaction_focus()
	_yaw -= relative.x * SENSITIVITY
	_pitch -= relative.y * SENSITIVITY
	_pitch = clampf(_pitch, deg_to_rad(-PITCH_LIMIT), deg_to_rad(PITCH_LIMIT))
	rotation.y = _yaw
	_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)


func _handle_tap(screen_pos: Vector2) -> void:
	if _camera == null:
		return
	if _is_traversal_locked:
		return
	var from: Vector3 = _camera.project_ray_origin(screen_pos)
	var dir: Vector3 = _camera.project_ray_normal(screen_pos)
	var to: Vector3 = from + dir * 100.0
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	if space == null:
		return

	var hit: Dictionary = _raycast(space, from, to, 1 << (LAYER_INTERACTABLE - 1), true)
	if not hit.is_empty() and hit["collider"] is Area3D:
		var a: Area3D = hit["collider"] as Area3D
		if a.has_meta("id"):
			var interaction_data: Dictionary = a.get_meta("data") if a.has_meta("data") else {}
			interaction_data = interaction_data.duplicate(true)
			interaction_data["interaction_world_position"] = hit.get("position", a.global_position)
			interaction_data["interaction_normal"] = hit.get("normal", Vector3.ZERO)
			interaction_data["interaction_distance"] = from.distance_to(interaction_data["interaction_world_position"])
			if a.has_meta("scene_role"):
				interaction_data["scene_role"] = a.get_meta("scene_role")
			if a.has_meta("state_tags"):
				interaction_data["state_tags"] = a.get_meta("state_tags")
			if _queue_interaction_approach_if_needed(a, interaction_data):
				return
			interacted.emit(a.get_meta("id"),
				a.get_meta("type") if a.has_meta("type") else "",
				interaction_data)
			return

	hit = _raycast(space, from, to, 1 << (LAYER_DOOR - 1), true)
	if not hit.is_empty() and hit["collider"] is Area3D:
		release_interaction_focus()
		var a: Area3D = hit["collider"] as Area3D
		if a.has_meta("target_room"):
			var threshold_data := {
				"target_room": String(a.get_meta("target_room")),
				"connection_id": String(a.get_meta("connection_id")) if a.has_meta("connection_id") else "",
				"interaction_world_position": hit.get("position", a.global_position),
				"interaction_normal": hit.get("normal", Vector3.ZERO),
			}
			if _queue_threshold_approach_if_needed(a, threshold_data):
				return
			_emit_threshold_action(a, threshold_data)
			return

	hit = _raycast(space, from, to, 1 << (LAYER_WALKABLE - 1), false)
	if not hit.is_empty():
		release_interaction_focus()
		var surface_position: Vector3 = hit.get("position", global_position)
		var surface_normal: Vector3 = hit.get("normal", Vector3.UP)
		if surface_normal.y < SURFACE_NORMAL_FLOOR_MIN_Y:
			begin_surface_investigation(surface_position, surface_normal)
			return
		_queue_walk_target(surface_position, {})


func _raycast(space: PhysicsDirectSpaceState3D, from: Vector3, to: Vector3,
		mask: int, areas: bool) -> Dictionary:
	var q := PhysicsRayQueryParameters3D.create(from, to)
	q.collision_mask = mask
	q.collide_with_areas = areas
	q.collide_with_bodies = not areas
	return space.intersect_ray(q)


func _connect_room_manager() -> void:
	var rm: Node = get_node_or_null("/root/Main/RoomManager")
	if rm and rm.has_signal("room_loaded"):
		rm.room_loaded.connect(_on_room_loaded)


func _on_room_loaded(_room_id: String) -> void:
	# RoomManager owns room-entry placement for both world swaps and same-world traversal.
	# Keep this signal hook inert so the player controller does not snap back to default room
	# spawns after anchor-driven placement or embodied in-place traversal has been resolved.
	pass


func set_room_position(pos: Vector3) -> void:
	_cancel_traversal_animation()
	_cancel_body_tween()
	_cancel_interaction_focus()
	_clear_pending_arrival_action()
	global_position = pos
	_target_position = Vector3.INF
	_is_walking = false
	_walk_focus_world_position = Vector3.INF
	velocity = Vector3.ZERO
	if _walk_marker:
		_walk_marker.visible = false


func set_room_rotation_y(rotation_y_deg: float) -> void:
	_cancel_traversal_animation()
	_cancel_body_tween()
	_cancel_interaction_focus()
	_clear_pending_arrival_action()
	rotation_degrees.y = rotation_y_deg
	_yaw = rotation.y
	_pitch = 0.0
	_walk_focus_world_position = Vector3.INF
	if _camera:
		_camera.rotation = Vector3.ZERO
		_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)


func get_view_camera() -> Camera3D:
	return _camera


func get_view_transform() -> Transform3D:
	if _camera != null:
		return _camera.global_transform
	return global_transform


func get_view_pitch_degrees() -> float:
	return rad_to_deg(_pitch)


func get_view_yaw_degrees() -> float:
	return rad_to_deg(_yaw)


func get_view_fov() -> float:
	return _camera.fov if _camera != null else DEFAULT_FOV


func get_eye_height() -> float:
	return CAMERA_HEIGHT


func play_traversal_animation(conn_type: String, duration: float, on_complete: Callable = Callable()) -> void:
	_cancel_traversal_animation()
	_cancel_body_tween()
	_cancel_interaction_focus()
	_clear_pending_arrival_action()
	_is_traversal_locked = true
	_target_position = Vector3.INF
	_is_walking = false
	velocity = Vector3.ZERO
	if _walk_marker:
		_walk_marker.visible = false

	var tween := create_tween()
	_traversal_tween = tween
	var start_cam_pos := _camera.position if _camera != null else Vector3(0, CAMERA_HEIGHT, 0)
	var start_pitch := _pitch
	var forward := -global_transform.basis.z.normalized()
	forward.y = 0.0
	if forward.length_squared() < 0.001:
		forward = Vector3.FORWARD
	forward = forward.normalized()

	match conn_type:
		"stairs":
			if _camera != null:
				tween.tween_property(_camera, "position", start_cam_pos + Vector3(0, 0.16, 0) + forward * 0.32, duration * 0.45)
				tween.parallel().tween_method(_set_pitch_degrees, rad_to_deg(start_pitch), rad_to_deg(start_pitch) - 6.0, duration * 0.45)
				tween.tween_property(_camera, "position", start_cam_pos + Vector3(0, 0.28, 0) + forward * 0.68, duration * 0.55)
				tween.parallel().tween_method(_set_pitch_degrees, rad_to_deg(start_pitch) - 6.0, rad_to_deg(start_pitch), duration * 0.55)
		"ladder":
			if _camera != null:
				tween.tween_property(_camera, "position", start_cam_pos + Vector3(0, 0.34, 0) + forward * 0.16, duration * 0.5)
				tween.parallel().tween_method(_set_pitch_degrees, rad_to_deg(start_pitch), rad_to_deg(start_pitch) - 10.0, duration * 0.5)
				tween.tween_property(_camera, "position", start_cam_pos + Vector3(0, 0.62, 0) + forward * 0.28, duration * 0.5)
				tween.parallel().tween_method(_set_pitch_degrees, rad_to_deg(start_pitch) - 10.0, rad_to_deg(start_pitch), duration * 0.5)
		"trapdoor":
			if _camera != null:
				tween.tween_property(_camera, "position", start_cam_pos + Vector3(0, -0.22, 0) + forward * 0.18, duration * 0.5)
				tween.parallel().tween_method(_set_pitch_degrees, rad_to_deg(start_pitch), rad_to_deg(start_pitch) + 10.0, duration * 0.5)
				tween.tween_property(_camera, "position", start_cam_pos + Vector3(0, -0.46, 0) + forward * 0.24, duration * 0.5)
				tween.parallel().tween_method(_set_pitch_degrees, rad_to_deg(start_pitch) + 10.0, rad_to_deg(start_pitch), duration * 0.5)
		"door", "path", "gate", "hidden_door":
			if _camera != null:
				tween.tween_property(_camera, "position", start_cam_pos + forward * 0.36, duration)
		_:
			if _camera != null:
				tween.tween_property(_camera, "position", start_cam_pos + forward * 0.22, duration)

	if on_complete.is_valid():
		tween.tween_callback(on_complete)


func _cancel_traversal_animation() -> void:
	if _traversal_tween != null and _traversal_tween.is_valid():
		_traversal_tween.kill()
	_traversal_tween = null
	_is_traversal_locked = false
	if _camera != null:
		_camera.position = Vector3(0, CAMERA_HEIGHT, 0)
	_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)


func tween_to_pose(target_position: Vector3, target_rotation_y: float, duration: float, on_complete: Callable = Callable()) -> void:
	_cancel_body_tween()
	_cancel_interaction_focus()
	_clear_pending_arrival_action()
	_is_traversal_locked = true
	_target_position = Vector3.INF
	_is_walking = false
	velocity = Vector3.ZERO
	if _walk_marker:
		_walk_marker.visible = false
	var tween := create_tween()
	_body_tween = tween
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", target_position, max(duration, 0.01))
	tween.tween_property(self, "rotation_degrees:y", target_rotation_y, max(duration, 0.01))
	tween.set_parallel(false)
	tween.tween_callback(func() -> void:
		_yaw = rotation.y
		_pitch = 0.0
		if _camera != null:
			_camera.position = Vector3(0, CAMERA_HEIGHT, 0)
			_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)
		_cancel_body_tween()
		if on_complete.is_valid():
			on_complete.call()
	)


func _cancel_body_tween() -> void:
	if _body_tween != null and _body_tween.is_valid():
		_body_tween.kill()
	_body_tween = null
	_is_traversal_locked = false


func begin_interaction_focus(focus_hint: Dictionary) -> void:
	if _camera == null or _is_traversal_locked:
		return
	var target_world: Variant = focus_hint.get("interaction_focus_position", focus_hint.get("interaction_world_position", null))
	if target_world is not Vector3:
		return
	var eye := _camera.global_position
	var to_target: Vector3 = (target_world as Vector3) - eye
	if to_target.length_squared() <= 0.001:
		return
	_cancel_interaction_focus(false)
	var flat := Vector2(to_target.x, to_target.z)
	var target_yaw_deg := get_view_yaw_degrees()
	if flat.length() > 0.001:
		target_yaw_deg = rad_to_deg(atan2(-flat.x, -flat.y))
	var target_pitch_deg := clampf(rad_to_deg(atan2(to_target.y, maxf(flat.length(), 0.01))), -PITCH_LIMIT, PITCH_LIMIT)
	var focus_kind := String(focus_hint.get("focus_kind", "inspect"))
	var target_offset := _calculate_focus_camera_offset(target_world as Vector3, focus_kind)
	var target_fov := _calculate_focus_fov(to_target.length(), focus_kind)
	var tween := create_tween()
	_interaction_focus_tween = tween
	tween.set_parallel(true)
	tween.tween_method(_set_yaw_degrees, get_view_yaw_degrees(), target_yaw_deg, INSPECT_FOCUS_DURATION)
	tween.parallel().tween_method(_set_pitch_degrees, get_view_pitch_degrees(), target_pitch_deg, INSPECT_FOCUS_DURATION)
	tween.parallel().tween_property(_camera, "position", target_offset, INSPECT_FOCUS_DURATION)
	tween.parallel().tween_property(_camera, "fov", target_fov, INSPECT_FOCUS_DURATION)
	tween.set_parallel(false)
	tween.tween_callback(func() -> void:
		_interaction_focus_tween = null
	)


func release_interaction_focus() -> void:
	if _camera == null:
		return
	_cancel_interaction_focus(false)
	var tween := create_tween()
	_interaction_focus_tween = tween
	tween.set_parallel(true)
	tween.tween_property(_camera, "position", Vector3(0, CAMERA_HEIGHT, 0), INSPECT_RELEASE_DURATION)
	tween.parallel().tween_property(_camera, "fov", DEFAULT_FOV, INSPECT_RELEASE_DURATION)
	tween.set_parallel(false)
	tween.tween_callback(func() -> void:
		_interaction_focus_tween = null
	)


func _cancel_interaction_focus(reset_camera: bool = true) -> void:
	if _interaction_focus_tween != null and _interaction_focus_tween.is_valid():
		_interaction_focus_tween.kill()
	_interaction_focus_tween = null
	if reset_camera and _camera != null:
		_camera.position = Vector3(0, CAMERA_HEIGHT, 0)
		_camera.fov = DEFAULT_FOV


func _calculate_focus_camera_offset(target_world: Vector3, focus_kind: String) -> Vector3:
	var eye := _camera.global_position
	var to_target := target_world - eye
	var distance := to_target.length()
	var lean_amount := clampf((1.2 - distance) * 0.32, 0.0, INSPECT_LEAN_MAX)
	if focus_kind == "pickup":
		lean_amount = minf(INSPECT_LEAN_MAX, lean_amount + 0.08)
	elif focus_kind == "surface":
		lean_amount = minf(INSPECT_LEAN_MAX, lean_amount + 0.06)
	lean_amount = _compute_safe_focus_lean(eye, to_target, lean_amount)
	var vertical_offset := clampf(to_target.y * 0.12, -INSPECT_DROP_MAX, INSPECT_RISE_MAX)
	if focus_kind == "pickup":
		vertical_offset = clampf(vertical_offset + 0.04, -INSPECT_DROP_MAX, INSPECT_RISE_MAX)
	elif focus_kind == "surface":
		vertical_offset = clampf(to_target.y * 0.18, -SURFACE_DROP_MAX, SURFACE_RISE_MAX)
	return Vector3(0, CAMERA_HEIGHT + vertical_offset, -lean_amount)


func _calculate_focus_fov(distance: float, focus_kind: String) -> float:
	if focus_kind == "pickup":
		return INSPECT_FOV_PICKUP
	if focus_kind == "surface":
		return clampf(INSPECT_FOV_SURFACE + distance * 4.0, INSPECT_FOV_PICKUP, DEFAULT_FOV)
	return clampf(58.0 + distance * 6.0, INSPECT_FOV_MIN, DEFAULT_FOV)


func _compute_safe_focus_lean(eye: Vector3, to_target: Vector3, desired_lean: float) -> float:
	if desired_lean <= 0.0:
		return 0.0
	var space := get_world_3d().direct_space_state
	if space == null:
		return desired_lean
	var forward_flat := Vector3(to_target.x, 0.0, to_target.z)
	if forward_flat.length_squared() <= 0.001:
		return 0.0
	forward_flat = forward_flat.normalized()
	var query := PhysicsRayQueryParameters3D.create(eye, eye + forward_flat * (desired_lean + 0.35))
	query.collision_mask = (1 << 0) | (1 << 1)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	var hit := space.intersect_ray(query)
	if hit.is_empty():
		return desired_lean
	var safe_distance := eye.distance_to(hit.get("position", eye)) - 0.22
	return clampf(minf(desired_lean, safe_distance), 0.0, desired_lean)


func _set_yaw_degrees(value: float) -> void:
	_yaw = deg_to_rad(value)
	rotation.y = _yaw
	if _camera != null:
		_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)


func _set_pitch_degrees(value: float) -> void:
	_pitch = deg_to_rad(value)
	if _camera != null:
		_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)


func begin_surface_investigation(surface_world_position: Vector3, surface_normal: Vector3) -> void:
	if _camera == null or _is_traversal_locked:
		return
	var walk_target := _resolve_surface_walk_target(surface_world_position, surface_normal)
	var focus_hint := {
		"interaction_world_position": surface_world_position,
		"interaction_focus_position": _resolve_surface_focus_position(surface_world_position, surface_normal),
		"interaction_normal": surface_normal,
		"focus_kind": "surface",
	}
	_queue_walk_target(walk_target, {
		"kind": "surface",
		"focus_hint": focus_hint,
	})


func begin_threshold_probe(target_room: String, connection_id: String, threshold_world_position: Vector3,
		surface_normal: Vector3 = Vector3.ZERO, concealed_probe: bool = false) -> void:
	if _camera == null or _is_traversal_locked or target_room.is_empty():
		return
	var focus_hint: Dictionary = {}
	if concealed_probe:
		focus_hint = {
			"interaction_world_position": threshold_world_position,
			"interaction_focus_position": _resolve_surface_focus_position(threshold_world_position, surface_normal),
			"interaction_normal": surface_normal,
			"focus_kind": "surface",
		}
	if _camera.global_position.distance_to(threshold_world_position) <= INTERACTION_APPROACH_DISTANCE:
		var immediate_action := {
			"target_room": target_room,
			"connection_id": connection_id,
		}
		if not focus_hint.is_empty():
			immediate_action["focus_hint"] = focus_hint
		_emit_threshold_action_from_data(immediate_action)
		return
	var walk_target := _resolve_approach_target(threshold_world_position, surface_normal, INTERACTION_APPROACH_STANDOFF)
	var arrival_action := {
		"kind": "threshold",
		"target_room": target_room,
		"connection_id": connection_id,
		"focus_world_position": threshold_world_position,
	}
	if not focus_hint.is_empty():
		arrival_action["focus_hint"] = focus_hint
	_queue_walk_target(walk_target, arrival_action)


func _queue_interaction_approach_if_needed(area: Area3D, interaction_data: Dictionary) -> bool:
	if _camera == null or area == null:
		return false
	var target_world: Variant = interaction_data.get("interaction_world_position", null)
	if target_world is not Vector3:
		return false
	if _camera.global_position.distance_to(target_world) <= INTERACTION_APPROACH_DISTANCE:
		return false
	var interaction_normal: Vector3 = interaction_data.get("interaction_normal", Vector3.ZERO)
	var walk_target := _resolve_approach_target(target_world, interaction_normal, INTERACTION_APPROACH_STANDOFF)
	_queue_walk_target(walk_target, {
		"kind": "interaction",
		"object_id": area.get_meta("id") if area.has_meta("id") else "",
		"object_type": area.get_meta("type") if area.has_meta("type") else "",
		"object_data": interaction_data.duplicate(true),
		"focus_world_position": target_world,
	})
	return true


func _queue_threshold_approach_if_needed(area: Area3D, threshold_data: Dictionary) -> bool:
	if _camera == null or area == null:
		return false
	var target_world: Variant = threshold_data.get("interaction_world_position", null)
	if target_world is not Vector3:
		return false
	var should_probe := _threshold_requires_probe(area)
	if _camera.global_position.distance_to(target_world) <= INTERACTION_APPROACH_DISTANCE:
		return false
	var interaction_normal: Vector3 = threshold_data.get("interaction_normal", Vector3.ZERO)
	var walk_target := _resolve_approach_target(target_world, interaction_normal, INTERACTION_APPROACH_STANDOFF)
	var arrival_action := {
		"kind": "threshold",
		"target_room": String(threshold_data.get("target_room", "")),
		"connection_id": String(threshold_data.get("connection_id", "")),
		"focus_world_position": target_world,
	}
	if should_probe:
		arrival_action["focus_hint"] = _build_threshold_focus_hint(area, threshold_data)
	_queue_walk_target(walk_target, arrival_action)
	return true


func _queue_walk_target(target_world_position: Vector3, arrival_action: Dictionary) -> void:
	_target_position = target_world_position
	_target_position.y = global_position.y
	_is_walking = true
	_pending_arrival_action = arrival_action.duplicate(true)
	_walk_focus_world_position = _resolve_walk_focus_world_position(arrival_action, target_world_position)
	if _walk_marker:
		_walk_marker.global_position = Vector3(target_world_position.x, target_world_position.y + 0.05, target_world_position.z)
		_walk_marker.visible = true


func _complete_arrival_action() -> void:
	if _pending_arrival_action.is_empty():
		return
	var action := _pending_arrival_action.duplicate(true)
	_pending_arrival_action.clear()
	_walk_focus_world_position = Vector3.INF
	match String(action.get("kind", "")):
		"interaction":
			interacted.emit(
				String(action.get("object_id", "")),
				String(action.get("object_type", "")),
				action.get("object_data", {})
			)
		"threshold":
			_emit_threshold_action_from_data(action)
		"surface":
			var focus_hint: Dictionary = action.get("focus_hint", {})
			if not focus_hint.is_empty():
				begin_interaction_focus(focus_hint)
				surface_investigated.emit(focus_hint)


func _clear_pending_arrival_action() -> void:
	_pending_arrival_action.clear()
	_walk_focus_world_position = Vector3.INF


func _emit_threshold_action(area: Area3D, threshold_data: Dictionary) -> void:
	var action := {
		"target_room": String(threshold_data.get("target_room", "")),
		"connection_id": String(threshold_data.get("connection_id", "")),
	}
	if _threshold_requires_probe(area):
		action["focus_hint"] = _build_threshold_focus_hint(area, threshold_data)
	_emit_threshold_action_from_data(action)


func _emit_threshold_action_from_data(action: Dictionary) -> void:
	var focus_hint: Dictionary = action.get("focus_hint", {})
	if not focus_hint.is_empty():
		begin_interaction_focus(focus_hint)
		surface_investigated.emit(focus_hint)
	door_tapped.emit(
		String(action.get("target_room", "")),
		String(action.get("connection_id", ""))
	)


func _threshold_requires_probe(area: Area3D) -> bool:
	if area == null:
		return false
	if area.has_meta("secret_passage_revealed") and not bool(area.get_meta("secret_passage_revealed")):
		return true
	var conn_type := String(area.get_meta("conn_type")) if area.has_meta("conn_type") else ""
	if conn_type == "hidden_door":
		return true
	var reveal_state := String(area.get_meta("reveal_state")) if area.has_meta("reveal_state") else ""
	return reveal_state == "concealed"


func _build_threshold_focus_hint(area: Area3D, threshold_data: Dictionary) -> Dictionary:
	var target_world: Vector3 = threshold_data.get("interaction_world_position", area.global_position)
	var interaction_normal: Vector3 = threshold_data.get("interaction_normal", Vector3.ZERO)
	return {
		"interaction_world_position": target_world,
		"interaction_focus_position": _resolve_surface_focus_position(target_world, interaction_normal),
		"interaction_normal": interaction_normal,
		"focus_kind": "surface",
	}


func _resolve_surface_walk_target(surface_world_position: Vector3, surface_normal: Vector3) -> Vector3:
	return _resolve_approach_target(surface_world_position, surface_normal, SURFACE_INVESTIGATION_STANDOFF)


func _resolve_surface_focus_position(surface_world_position: Vector3, surface_normal: Vector3) -> Vector3:
	if surface_normal.y <= SURFACE_NORMAL_CEILING_MAX_Y:
		return surface_world_position + Vector3(0, -0.08, 0)
	if absf(surface_normal.y) < SURFACE_NORMAL_FLOOR_MIN_Y:
		return surface_world_position + surface_normal.normalized() * 0.04
	return surface_world_position


func _resolve_approach_target(target_world_position: Vector3, surface_normal: Vector3, stand_off: float) -> Vector3:
	var flat_normal := Vector3(surface_normal.x, 0.0, surface_normal.z)
	var approach_target := target_world_position
	if flat_normal.length_squared() > 0.001:
		approach_target += flat_normal.normalized() * stand_off
	elif surface_normal.y <= SURFACE_NORMAL_CEILING_MAX_Y:
		approach_target = Vector3(target_world_position.x, global_position.y, target_world_position.z)
	else:
		var from_target := global_position - target_world_position
		from_target.y = 0.0
		if from_target.length_squared() > 0.001:
			approach_target += from_target.normalized() * stand_off
	var floor_probe_start := Vector3(approach_target.x, maxf(global_position.y + 1.8, target_world_position.y + 1.0), approach_target.z)
	var floor_probe_end := floor_probe_start + Vector3(0, -4.0, 0)
	var floor_hit := _raycast(get_world_3d().direct_space_state, floor_probe_start, floor_probe_end, 1 << (LAYER_WALKABLE - 1), false)
	if not floor_hit.is_empty():
		approach_target = floor_hit.get("position", approach_target)
	approach_target.y = global_position.y
	return approach_target


func _resolve_walk_focus_world_position(arrival_action: Dictionary, fallback: Vector3) -> Vector3:
	var focus_hint: Dictionary = arrival_action.get("focus_hint", {})
	var hinted_position: Variant = focus_hint.get("interaction_focus_position", focus_hint.get("interaction_world_position", null))
	if hinted_position is Vector3:
		return hinted_position
	var explicit_focus: Variant = arrival_action.get("focus_world_position", null)
	if explicit_focus is Vector3:
		return explicit_focus
	var object_data: Dictionary = arrival_action.get("object_data", {})
	var object_focus: Variant = object_data.get("interaction_focus_position", object_data.get("interaction_world_position", null))
	if object_focus is Vector3:
		return object_focus
	return fallback


func _update_walk_focus(delta: float) -> void:
	if _camera == null or _walk_focus_world_position == Vector3.INF:
		return
	var eye := _camera.global_position
	var to_target := _walk_focus_world_position - eye
	if to_target.length_squared() <= 0.001:
		return
	var flat := Vector2(to_target.x, to_target.z)
	var target_yaw := _yaw
	if flat.length() > 0.001:
		target_yaw = atan2(-flat.x, -flat.y)
	var target_pitch := clampf(
		atan2(to_target.y, maxf(flat.length(), 0.01)),
		deg_to_rad(-PITCH_LIMIT),
		deg_to_rad(PITCH_LIMIT)
	)
	_yaw = lerp_angle(_yaw, target_yaw, clampf(delta * 7.5, 0.0, 1.0))
	_pitch = lerp_angle(_pitch, target_pitch, clampf(delta * 6.5, 0.0, 1.0))
	rotation.y = _yaw
