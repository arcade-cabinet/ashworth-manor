extends SceneTree
## Verifies representative mounted payloads resolve through declared slots.
## Run: godot --headless --path . --script test/e2e/test_mount_payloads.gd

var _main: Node = null
var _rm: Node = null
var _gm: Node = null
var _passes := 0
var _fails := 0


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break
	if _rm == null or _gm == null:
		push_error("mount payload test missing required nodes")
		quit(1)
		return

	_gm.new_game()
	_gm.set_route_context("adult")
	await _load_room("foyer")
	_expect_node("adult foyer west lamp mount", "Props/drawers/foyer_table_lamp_west_payload", true)
	_expect_node("adult foyer east lamp mount", "Props/drawers_east/foyer_table_lamp_east_payload", true)
	_expect_node("adult foyer east wall mount", "Props/foyer_wall_picture_east_payload", true)
	_expect_node("adult foyer standard portrait", "Props/foyer_upper_portrait_standard", true)
	_expect_node("adult foyer elder portrait absent", "Props/foyer_upper_portrait_elder", false)

	await _load_room("front_gate")
	_expect_node("front gate sign mount", "Props/gate_pillar_l/front_gate_menu_sign_payload", true)
	_expect_node("front gate off-lamp mount", "Props/gate_pillar_r/gate_lamp_off_payload", true)

	await _load_room("storage_basement")
	_expect_node("storage basement stair sconce mount", "Props/storage_sconce_stairs_payload", true)
	_expect_node("storage basement cage sconce mount", "Props/storage_sconce_cage_payload", true)

	_gm.set_route_context("elder")
	await _load_room("foyer")
	_expect_node("elder foyer standard portrait absent", "Props/foyer_upper_portrait_standard", false)
	_expect_node("elder foyer elder portrait", "Props/foyer_upper_portrait_elder", true)

	print("\n========================================")
	print("MOUNT PAYLOAD RESULTS: %d passed, %d failed" % [_passes, _fails])
	print("========================================")
	quit(1 if _fails > 0 else 0)


func _load_room(room_id: String) -> void:
	_rm.load_room(room_id)
	await process_frame
	await process_frame
	await process_frame


func _expect_node(label: String, node_path: String, should_exist: bool) -> void:
	var room: Node = _rm.get_current_room()
	var exists := room != null and room.get_node_or_null(node_path) != null
	if exists == should_exist:
		_passes += 1
		print("[OK] %s" % label)
	else:
		_fails += 1
		print("[FAIL] %s (path=%s expected=%s got=%s)" % [label, node_path, str(should_exist), str(exists)])


func _find(root_node: Node, target_name: String) -> Node:
	if root_node.name == target_name:
		return root_node
	for child in root_node.get_children():
		var found := _find(child, target_name)
		if found != null:
			return found
	return null
