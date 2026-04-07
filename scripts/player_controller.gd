extends CharacterBody3D
## res://scripts/player_controller.gd -- First-person controller
## Input in player_input.gd, camera in camera_controller.gd

signal interacted(object_id: String, object_type: String, object_data: Dictionary)
signal door_tapped(target_room: String, connection_id: String)

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
		else:
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
			interacted.emit(a.get_meta("id"),
				a.get_meta("type") if a.has_meta("type") else "",
				a.get_meta("data") if a.has_meta("data") else {})
			return

	hit = _raycast(space, from, to, 1 << (LAYER_DOOR - 1), true)
	if not hit.is_empty() and hit["collider"] is Area3D:
		var a: Area3D = hit["collider"] as Area3D
		if a.has_meta("target_room"):
			var connection_id: String = a.get_meta("connection_id") if a.has_meta("connection_id") else ""
			door_tapped.emit(a.get_meta("target_room"), connection_id)
			return

	hit = _raycast(space, from, to, 1 << (LAYER_WALKABLE - 1), false)
	if not hit.is_empty():
		_target_position = hit["position"]
		_target_position.y = global_position.y
		_is_walking = true
		if _walk_marker:
			_walk_marker.global_position = hit["position"] + Vector3(0, 0.05, 0)
			_walk_marker.visible = true


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
	global_position = pos
	_target_position = Vector3.INF
	_is_walking = false
	velocity = Vector3.ZERO
	if _walk_marker:
		_walk_marker.visible = false


func set_room_rotation_y(rotation_y_deg: float) -> void:
	_cancel_traversal_animation()
	_cancel_body_tween()
	rotation_degrees.y = rotation_y_deg
	_yaw = rotation.y
	_pitch = 0.0
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


func _set_pitch_degrees(value: float) -> void:
	_pitch = deg_to_rad(value)
	if _camera != null:
		_camera.global_rotation = Vector3(_pitch, _yaw, 0.0)
