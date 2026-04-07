extends Node
## res://scripts/camera_controller.gd -- Phantom Camera + ShakyCamera3D integration
## Manages PhantomCameraHost, ExplorationCam, inspection cameras, and shake effects.

var _camera: Camera3D = null
var _pcam_host: Node = null
var _exploration_cam: Node3D = null
var _shaky_cam: Node = null
var _shake_tween: Tween = null
var _pcam_available: bool = false


func setup(camera: Camera3D, player: CharacterBody3D) -> void:
	_camera = camera
	# Keep the shipping exploration path on the base Camera3D.
	# Phantom Camera support is optional and currently reserved for
	# explicit future inspection/cinematic work, not the default view.
	_pcam_available = false

	if not _pcam_available:
		return

	# Phantom Camera Host: child of Camera3D, manages PCam priorities
	_pcam_host = _camera.get_node_or_null("PhantomCameraHost")
	if _pcam_host == null:
		_pcam_host = PhantomCameraHost.new()
		_pcam_host.name = "PhantomCameraHost"
		_camera.add_child(_pcam_host)

	# Exploration camera: follows player head, default priority
	_exploration_cam = player.get_node_or_null("ExplorationCam")
	if _exploration_cam == null:
		_exploration_cam = PhantomCamera3D.new()
		_exploration_cam.name = "ExplorationCam"
		(_exploration_cam as PhantomCamera3D).priority = 10
		(_exploration_cam as PhantomCamera3D).follow_mode = PhantomCamera3D.FollowMode.GLUED
		player.add_child(_exploration_cam)
	_exploration_cam.position = Vector3(0, 1.7, 0)


func update_exploration_cam(global_pos: Vector3, pitch: float, yaw: float) -> void:
	if _exploration_cam:
		_exploration_cam.global_position = global_pos + Vector3(0, 1.7, 0)
		_exploration_cam.global_rotation = Vector3(pitch, yaw, 0)


func set_inspection_camera(pcam: Node3D) -> void:
	## Activate an inspection camera (priority 20) for document viewing.
	if pcam and pcam is PhantomCamera3D:
		(pcam as PhantomCamera3D).priority = 20


func reset_inspection_camera(pcam: Node3D) -> void:
	## Deactivate an inspection camera back to default.
	if pcam and pcam is PhantomCamera3D:
		(pcam as PhantomCamera3D).priority = 0


func apply_shake(shake_type: int, mul_pos: float, mul_rot: float, duration: float) -> void:
	## Apply camera shake via ShakyCamera3D addon.
	if _shaky_cam == null and _camera:
		_shaky_cam = _camera.get_node_or_null("ShakyCamera3D")
	if _shaky_cam == null:
		return
	_shaky_cam.type_of_shake = shake_type
	_shaky_cam.multiplier_position = mul_pos
	_shaky_cam.multiplier_rotation = mul_rot
	_shaky_cam.disabled = false
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
	_shake_tween = _camera.create_tween()
	_shake_tween.tween_interval(duration)
	_shake_tween.tween_callback(func(): _shaky_cam.disabled = true)


func stop_shake() -> void:
	if _shaky_cam:
		_shaky_cam.disabled = true
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()


func _is_phantom_camera_available() -> bool:
	return ClassDB.class_exists(&"PhantomCamera3D") or Engine.has_singleton("PhantomCameraManager") or get_node_or_null("/root/PhantomCameraManager") != null
