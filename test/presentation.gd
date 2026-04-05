extends SceneTree
## Presentation video — 30s cinematic tour of Ashworth Manor
## Run: godot --rendering-method forward_plus --write-movie screenshots/presentation/output.avi --fixed-fps 30 --quit-after 900 --script test/presentation.gd

var _frame: int = 0
var _main: Node = null
var _player: Node = null
var _cam: Camera3D = null
var _rm: Node = null
var _ui: Control = null

# Cinematic sequence: [frame_start, room_id, camera_pos, camera_rot_y, action]
var _sequence: Array = [
	# Opening: Front gate — slow pan across the grounds
	[0, "front_gate", Vector3(0, 1.7, -12), 180.0, ""],
	[60, "front_gate", Vector3(0, 1.7, -8), 180.0, ""],  # walk forward
	[120, "front_gate", Vector3(0, 1.7, -4), 150.0, ""],  # look right

	# Enter the Foyer
	[180, "foyer", Vector3(0, 1.7, -5), 180.0, ""],
	[240, "foyer", Vector3(0, 1.7, -2), 180.0, ""],  # walk in, see rug
	[300, "foyer", Vector3(0, 1.7, 0), 90.0, ""],  # look right at stairs

	# Parlor — dying fire
	[360, "parlor", Vector3(0, 1.7, -3), 180.0, ""],
	[420, "parlor", Vector3(0, 1.7, 0), 180.0, ""],  # approach fireplace

	# Library — bookcases
	[480, "library", Vector3(0, 1.7, -3), 180.0, ""],
	[540, "library", Vector3(0, 1.7, 0), 90.0, ""],  # look at bookshelves

	# Attic — Elizabeth's prison
	[600, "attic_storage", Vector3(0, 1.7, -4), 180.0, ""],
	[660, "attic_storage", Vector3(0, 1.7, 0), 120.0, ""],  # look at doll area

	# Hidden Chamber — the truth
	[720, "hidden_room", Vector3(0, 1.7, 0), 180.0, ""],

	# Wine Cellar — deepest point
	[780, "wine_cellar", Vector3(0, 1.7, 0), 90.0, ""],

	# Back to front gate — ending
	[840, "front_gate", Vector3(0, 1.7, -12), 180.0, "ending"],
]

var _current_step: int = 0
var _target_pos: Vector3 = Vector3.ZERO
var _target_yaw: float = 0.0


func _initialize() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	_main = main_scene.instantiate()
	root.add_child(_main)

	call_deferred("_start")


func _start() -> void:
	# Find nodes
	_player = _find_by_name(_main, "PlayerController")
	_rm = _find_by_name(_main, "RoomManager")
	_ui = _find_by_name(_main, "UIOverlay")
	_cam = _find_camera(_player)

	# Start game
	var gm: Node = null
	for child in root.get_children():
		if child.name == "GameManager":
			gm = child
			break
	if gm:
		gm.new_game()

	# Hide landing
	if _ui:
		var landing: Node = _find_by_name(_ui, "LandingScreen")
		if landing:
			landing.visible = false

	# Load first room
	if _rm and _rm.has_method("load_room"):
		_rm.load_room("front_gate")

	# Set initial camera
	if _player:
		_player.global_position = Vector3(0, 0, -12)
		_player.rotation_degrees.y = 180.0
	if _cam:
		_cam.current = true


func _process(delta: float) -> bool:
	_frame += 1

	# Find current step
	while _current_step < _sequence.size() - 1 and _frame >= _sequence[_current_step + 1][0]:
		_current_step += 1
		_apply_step(_current_step)

	# Smooth interpolation toward target
	if _player and _target_pos != Vector3.ZERO:
		_player.global_position = _player.global_position.lerp(_target_pos, delta * 2.0)
		var current_yaw: float = _player.rotation_degrees.y
		var diff: float = fmod(_target_yaw - current_yaw + 540.0, 360.0) - 180.0
		_player.rotation_degrees.y = current_yaw + diff * delta * 2.0

	return false


func _apply_step(idx: int) -> void:
	var step: Array = _sequence[idx]
	var room_id: String = step[1]
	_target_pos = step[2]
	_target_yaw = step[3]

	# Load room if different
	if _rm and _rm.has_method("get_current_room_id"):
		var current: String = _rm.get_current_room_id()
		if current != room_id and _rm.has_method("load_room"):
			_rm.load_room(room_id)
			# Snap position immediately on room change
			if _player:
				_player.global_position = _target_pos
				_player.rotation_degrees.y = _target_yaw


func _find_camera(node: Node) -> Camera3D:
	if node == null:
		return null
	if node is Camera3D:
		return node as Camera3D
	for child in node.get_children():
		var found = _find_camera(child)
		if found:
			return found
	return null


func _find_by_name(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var found = _find_by_name(child, target)
		if found:
			return found
	return null
