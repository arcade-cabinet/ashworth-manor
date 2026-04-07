extends SceneTree
## Room Spec Validation — checks assembled declaration rooms match shipped specs.
## Run: godot --headless --script test/e2e/test_room_specs.gd
##
## Spec data in room_spec_data.gd (RoomSpecData class).

var _main: Node = null
var _rm: Node = null
var _gm: Node = null
var _pass_count: int = 0
var _fail_count: int = 0
var _test_name: String = ""


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	call_deferred("_run_all_tests")


func _run_all_tests() -> void:
	_rm = _find(_main, "RoomManager")
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("GameManager found", _gm != null)
	_assert("RoomManager found", _rm != null)
	_gm.new_game()

	var all_specs: Dictionary = RoomSpecData.get_all()
	for room_id in all_specs:
		_test_room(room_id, all_specs[room_id])

	print("")
	print("========================================")
	print("ROOM SPEC RESULTS: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _test_room(room_id: String, spec: Dictionary) -> void:
	_test_name = room_id.to_upper()
	_rm.load_room(room_id)
	var room = _rm.get_current_room()

	_assert("loads", room != null)
	if room == null:
		print("[SKIP] %s — failed to load" % room_id)
		return
	_assert("room_id matches", room.room_id == room_id)

	_assert("has Geometry", _find(room, "Geometry") != null)
	_assert("has Lighting", _find(room, "Lighting") != null)
	_assert("has Interactables", _find(room, "Interactables") != null)
	_assert("has Connections", _find(room, "Connections") != null)

	var found_ids: Array[String] = []
	for area in room.get_interactables():
		if area.has_meta("id"):
			found_ids.append(area.get_meta("id"))
	for eid in spec.get("interactables", []):
		_assert("interactable '%s'" % eid, found_ids.has(eid))

	var found_targets: Array[String] = []
	for area in room.get_connections():
		if area.has_meta("target_room"):
			found_targets.append(area.get_meta("target_room"))
	for et in spec.get("connections", []):
		_assert("connection → '%s'" % et, found_targets.has(et))

	var lc: int = _count_lights(room)
	var ml: int = spec.get("min_lights", 1)
	_assert("lights >= %d (found %d)" % [ml, lc], lc >= ml)

	if spec.get("has_flickering", false):
		_assert("has flickering light", _has_flickering(room))

	var require_spawn: bool = spec.get("require_spawn", true)
	if require_spawn:
		_assert("spawn set", room.spawn_position != Vector3.ZERO or room_id == "front_gate")

	var has_audio: bool = not room.audio_loop.is_empty()
	var is_ext: bool = room.is_exterior if "is_exterior" in room else false
	_assert("audio or exterior", has_audio or is_ext)

	print("[%s] %s — %d/%d inter, %d/%d conn, %d lights" % [
		"OK", room_id, found_ids.size(), spec.get("interactables", []).size(),
		found_targets.size(), spec.get("connections", []).size(), lc])


func _count_lights(n: Node) -> int:
	var c: int = 1 if n is Light3D else 0
	for ch in n.get_children():
		c += _count_lights(ch)
	return c


func _has_flickering(n: Node) -> bool:
	if n is Light3D and n.has_meta("flickering") and n.get_meta("flickering"):
		return true
	for ch in n.get_children():
		if _has_flickering(ch):
			return true
	return false


func _assert(d: String, c: bool) -> void:
	if c:
		_pass_count += 1
	else:
		_fail_count += 1
		print("[FAIL] %s :: %s" % [_test_name, d])


func _find(n: Node, t: String) -> Node:
	if n.name == t:
		return n
	for ch in n.get_children():
		var f: Node = _find(ch, t)
		if f != null:
			return f
	return null
