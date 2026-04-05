extends SceneTree
## Test harness — captures screenshots of the Foyer loaded with GLB models

var _frame: int = 0
var _cam: Camera3D = null
var _main: Node = null


func _initialize() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	_main = main_scene.instantiate()
	root.add_child(_main)

	# Wait a frame for _ready() to fire
	# Find the camera
	_cam = _find_camera(_main)
	if _cam:
		_cam.current = true

	# Trigger new game after nodes are ready
	call_deferred("_start_game")


func _start_game() -> void:
	# Find GameManager autoload (can't reference by name in SceneTree scripts)
	var gm: Node = null
	for child in root.get_children():
		if child.name == "GameManager":
			gm = child
			break

	if gm and gm.has_method("new_game"):
		gm.new_game()
		gm.set("current_room", "foyer")
		print("ASSERT PASS: GameManager found and initialized")
	else:
		print("ASSERT FAIL: GameManager autoload not found")

	var room_mgr: Node = _find_by_name(_main, "RoomManager")
	if room_mgr and room_mgr.has_method("load_room"):
		room_mgr.load_room("foyer")
		print("ASSERT PASS: Room loaded")
	else:
		print("ASSERT FAIL: Could not find RoomManager")

	# Position player in foyer
	var player: Node = _find_by_name(_main, "PlayerController")
	if player and player.has_method("set_room_position"):
		player.set_room_position(Vector3(0, 0, -4))
		print("ASSERT PASS: Player positioned")

	# Position camera to look at the room
	if _cam:
		_cam.global_position = Vector3(0, 1.7, -4)
		_cam.rotation_degrees = Vector3(0, 0, 0)

	# Hide landing screen
	var ui: Control = _find_by_name(_main, "UIOverlay") as Control
	if ui:
		var landing: Node = _find_by_name(ui, "LandingScreen")
		if landing:
			landing.visible = false


func _process(delta: float) -> bool:
	_frame += 1

	# Slowly rotate camera to show the room
	if _cam and _frame > 5:
		_cam.rotation_degrees.y += 1.5

	# Log at key frames
	if _frame == 5:
		# Count room children
		var room_container: Node = _find_by_name(_main, "RoomContainer")
		if room_container:
			var child_count: int = room_container.get_child_count()
			print("ASSERT PASS: RoomContainer has %d children" % child_count)
			if child_count > 5:
				print("ASSERT PASS: Room populated with models/lights/interactables")
			else:
				print("ASSERT FAIL: Room has too few children (%d)" % child_count)

	return false


func _find_camera(node: Node) -> Camera3D:
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
