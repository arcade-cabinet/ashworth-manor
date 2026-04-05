extends SceneTree
## Integration Walkthrough — visits every room in play order, interacts with
## every object, captures screenshots for visual review.
## Run: godot --headless --script test/e2e/test_room_walkthrough.gd
## Output: user://screenshots/walkthrough/*.png

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _camera: Camera3D = null
var _frame: int = 0
var _step: int = 0
var _steps: Array = []
var _screenshot_dir: String = "user://screenshots/walkthrough/"
var _pass_count: int = 0
var _fail_count: int = 0


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(_screenshot_dir)
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	call_deferred("_setup")


func _setup() -> void:
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_ui = _find(_main, "UIOverlay")
	_camera = _find_camera(_main)
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	if _ui:
		var landing: Node = _find(_ui, "LandingScreen")
		if landing:
			landing.visible = false

	_gm.new_game()
	_build_walkthrough()
	_step = 0
	print("Walkthrough: %d steps queued" % _steps.size())


func _build_walkthrough() -> void:
	for entry in WalkthroughData.get_play_order():
		var room_id: String = entry[0]
		var obj_ids: Array = entry[1]
		_steps.append({"type": "load_room", "room_id": room_id})
		_steps.append({"type": "screenshot", "name": "%s_overview" % room_id})
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
		_finish()
		return true
	_execute_step(_steps[_step])
	_step += 1
	return false


func _execute_step(s: Dictionary) -> void:
	match s["type"]:
		"load_room":
			_rm.load_room(s["room_id"])
			var room = _rm.get_current_room()
			if room and _camera:
				_camera.global_position = room.spawn_position + Vector3(0, 1.7, 0)
				_camera.rotation_degrees = Vector3(0, room.spawn_rotation_y, 0)
				print("ROOM: %s" % room.room_id)
			else:
				print("[FAIL] load: %s" % s["room_id"])
				_fail_count += 1
		"look":
			if _camera:
				_camera.rotation_degrees.y = s["angle"]
		"interact":
			_do_interact(s["object_id"], s.get("room_id", ""))
		"screenshot":
			_capture(s["name"])
		"dismiss":
			if _ui and _ui.has_method("hide_document"):
				_ui.hide_document()


func _do_interact(obj_id: String, room_id: String) -> void:
	var room = _rm.get_current_room()
	if room == null:
		return
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == obj_id:
			if _camera:
				_camera.look_at(area.global_position, Vector3.UP)
			var t: String = area.get_meta("type") if area.has_meta("type") else ""
			var d: Dictionary = area.get_meta("data") if area.has_meta("data") else {}
			_im._on_interacted(obj_id, t, d)
			_pass_count += 1
			return
	print("[MISS] %s/%s — not in scene" % [room_id, obj_id])
	_fail_count += 1


func _capture(name: String) -> void:
	var img: Image = root.get_texture().get_image()
	if img:
		img.save_png(_screenshot_dir + name + ".png")


func _finish() -> void:
	print("")
	print("========================================")
	print("WALKTHROUGH: %d found, %d missing" % [_pass_count, _fail_count])
	print("Screenshots: %s" % ProjectSettings.globalize_path(_screenshot_dir))
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


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
