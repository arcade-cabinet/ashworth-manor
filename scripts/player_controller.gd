extends CharacterBody3D
## res://scripts/player_controller.gd -- First-person controller
## Input in player_input.gd, camera in camera_controller.gd

signal interacted(object_id: String, object_type: String, object_data: Dictionary)
signal door_tapped(target_room: String)

const MOVE_SPEED: float = 3.0
const STOP_DISTANCE: float = 0.3
const GRAVITY: float = 9.8
const SENSITIVITY: float = 0.003
const CAMERA_HEIGHT: float = 1.7
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
	_camera.fov = 70.0

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
	move_and_slide()


func _rotate_camera(relative: Vector2) -> void:
	_yaw -= relative.x * SENSITIVITY
	_pitch -= relative.y * SENSITIVITY
	_pitch = clampf(_pitch, deg_to_rad(-PITCH_LIMIT), deg_to_rad(PITCH_LIMIT))
	rotation.y = _yaw
	_camera.rotation.x = _pitch


func _handle_tap(screen_pos: Vector2) -> void:
	if _camera == null:
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
			door_tapped.emit(a.get_meta("target_room"))
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
	var rm: Node = get_node_or_null("/root/Main/RoomManager")
	if rm and rm.has_method("get_current_room"):
		var room = rm.get_current_room()
		if room and "spawn_position" in room:
			set_room_position(room.spawn_position)
			if "spawn_rotation_y" in room:
				rotation_degrees.y = room.spawn_rotation_y


func set_room_position(pos: Vector3) -> void:
	global_position = pos
	_target_position = Vector3.INF
	_is_walking = false
	velocity = Vector3.ZERO
	if _walk_marker:
		_walk_marker.visible = false
