extends CharacterBody3D
## res://scripts/player_controller.gd — First-person controller with touch/mouse input

signal interacted(object_id: String, object_type: String, object_data: Dictionary)
signal door_tapped(target_room: String)

const MOVE_SPEED: float = 3.0
const STOP_DISTANCE: float = 0.3
const GRAVITY: float = 9.8
const SENSITIVITY: float = 0.003
const TAP_THRESHOLD: float = 15.0
const TAP_TIME_THRESHOLD: float = 0.3
const CAMERA_HEIGHT: float = 1.7
const PITCH_LIMIT: float = 45.0
const LAYER_WALKABLE: int = 1
const LAYER_INTERACTABLE: int = 3
const LAYER_DOOR: int = 4

var _camera: Camera3D = null
var _yaw: float = 0.0
var _pitch: float = 0.0
var _target_position: Vector3 = Vector3.INF
var _is_walking: bool = false

# Touch tracking
var _touch_start_pos: Vector2 = Vector2.ZERO
var _touch_start_time: float = 0.0
var _is_touching: bool = false
var _touch_index: int = -1

# Mouse drag tracking
var _mouse_dragging: bool = false


func _ready() -> void:
	floor_snap_length = 0.5
	up_direction = Vector3.UP

	_camera = Camera3D.new()
	_camera.name = "PlayerCamera"
	_camera.position = Vector3(0, CAMERA_HEIGHT, 0)
	_camera.current = true
	_camera.fov = 70.0
	add_child(_camera)


func _unhandled_input(event: InputEvent) -> void:
	# Block input when document overlay is open or game is paused
	var ui: Control = get_node_or_null("/root/Main/UILayer/UIOverlay")
	if ui and ui.get("_is_document_open") == true:
		return
	if get_tree().paused:
		return

	# Touch begin
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event as InputEventScreenTouch
		if touch.pressed:
			_touch_start_pos = touch.position
			_touch_start_time = Time.get_ticks_msec() / 1000.0
			_is_touching = true
			_touch_index = touch.index
		else:
			if _is_touching and touch.index == _touch_index:
				var dist: float = touch.position.distance_to(_touch_start_pos)
				var elapsed: float = (Time.get_ticks_msec() / 1000.0) - _touch_start_time
				if dist < TAP_THRESHOLD and elapsed < TAP_TIME_THRESHOLD:
					_handle_tap(touch.position)
				_is_touching = false
				_touch_index = -1

	# Touch drag — camera rotation
	if event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event as InputEventScreenDrag
		if _is_touching and drag.index == _touch_index:
			_rotate_camera(drag.relative)

	# Mouse input (desktop)
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			_mouse_dragging = mb.pressed
		elif mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_handle_tap(mb.position)

	if event is InputEventMouseMotion:
		var mm: InputEventMouseMotion = event as InputEventMouseMotion
		if _mouse_dragging:
			_rotate_camera(mm.relative)


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0.0

	# Walk toward target
	if _is_walking and _target_position != Vector3.INF:
		var to_target: Vector3 = _target_position - global_position
		to_target.y = 0.0
		var dist: float = to_target.length()
		if dist < STOP_DISTANCE:
			_is_walking = false
			velocity.x = 0.0
			velocity.z = 0.0
		else:
			var dir: Vector3 = to_target.normalized()
			velocity.x = dir.x * MOVE_SPEED
			velocity.z = dir.z * MOVE_SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

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

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	if space_state == null:
		return

	# Check interactables first (layer 3)
	var interactable_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	interactable_query.collision_mask = (1 << (LAYER_INTERACTABLE - 1))
	interactable_query.collide_with_areas = true
	interactable_query.collide_with_bodies = false

	var interactable_result: Dictionary = space_state.intersect_ray(interactable_query)
	if not interactable_result.is_empty():
		var collider: Object = interactable_result["collider"]
		if collider is Area3D:
			var area: Area3D = collider as Area3D
			if area.has_meta("id"):
				var obj_id: String = area.get_meta("id")
				var obj_type: String = area.get_meta("type") if area.has_meta("type") else ""
				var obj_data: Dictionary = area.get_meta("data") if area.has_meta("data") else {}
				interacted.emit(obj_id, obj_type, obj_data)
				return

	# Check door/connection areas (layer 4)
	var door_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	door_query.collision_mask = (1 << (LAYER_DOOR - 1))
	door_query.collide_with_areas = true
	door_query.collide_with_bodies = false

	var door_result: Dictionary = space_state.intersect_ray(door_query)
	if not door_result.is_empty():
		var collider: Object = door_result["collider"]
		if collider is Area3D:
			var area: Area3D = collider as Area3D
			if area.has_meta("target_room"):
				var target: String = area.get_meta("target_room")
				door_tapped.emit(target)
				return

	# Check floor (layer 1) — walk to point
	var floor_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	floor_query.collision_mask = (1 << (LAYER_WALKABLE - 1))
	floor_query.collide_with_areas = false
	floor_query.collide_with_bodies = true

	var floor_result: Dictionary = space_state.intersect_ray(floor_query)
	if not floor_result.is_empty():
		_target_position = floor_result["position"]
		_target_position.y = global_position.y
		_is_walking = true



func set_room_position(pos: Vector3) -> void:
	global_position = pos
	_target_position = Vector3.INF
	_is_walking = false
	velocity = Vector3.ZERO
