extends SceneTree
## E2E Playthrough Test — runs headless, exits with code 0 (pass) or 1 (fail)
## Run: godot --headless --script test/e2e/run_e2e.gd

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _pass_count: int = 0
var _fail_count: int = 0
var _test_name: String = ""


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	call_deferred("_run_all_tests")


func _run_all_tests() -> void:
	# Find nodes
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_ui = _find(_main, "UIOverlay")
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("GameManager found", _gm != null)
	_assert("RoomManager found", _rm != null)
	_assert("InteractionManager found", _im != null)

	# === TEST SUITE ===
	_test_all_rooms_loadable()
	_test_all_rooms_have_gameplay()
	_test_full_freedom_playthrough()
	_test_escape_ending()
	_test_joined_ending()
	_test_save_load()

	# === RESULTS ===
	print("")
	print("========================================")
	print("E2E RESULTS: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")

	if _fail_count > 0:
		quit(1)
	else:
		quit(0)


func _test_all_rooms_loadable() -> void:
	_test_name = "ALL_ROOMS_LOADABLE"
	_gm.new_game()
	var rooms: Array[String] = [
		"front_gate", "foyer", "parlor", "dining_room", "kitchen",
		"upper_hallway", "master_bedroom", "library", "guest_room",
		"storage_basement", "boiler_room", "wine_cellar",
		"attic_stairs", "attic_storage", "hidden_room",
		"chapel", "greenhouse", "carriage_house", "garden", "family_crypt",
	]
	for room_id in rooms:
		_rm.load_room(room_id)
		var room = _rm.get_current_room()
		_assert("load " + room_id, room != null and room.room_id == room_id)
	print("[PASS] All 20 rooms loadable")


func _test_all_rooms_have_gameplay() -> void:
	_test_name = "ROOMS_HAVE_GAMEPLAY"
	_gm.new_game()
	var rooms_with_interactables: int = 0
	var rooms_with_connections: int = 0
	var total_interactables: int = 0
	var total_connections: int = 0

	var rooms: Array[String] = [
		"front_gate", "foyer", "parlor", "dining_room", "kitchen",
		"upper_hallway", "master_bedroom", "library", "guest_room",
		"storage_basement", "boiler_room", "wine_cellar",
		"attic_stairs", "attic_storage", "hidden_room",
		"chapel", "greenhouse", "carriage_house", "garden", "family_crypt",
	]
	for room_id in rooms:
		_rm.load_room(room_id)
		var room = _rm.get_current_room()
		if room == null:
			continue
		var inter: int = room.get_interactables().size()
		var conn: int = room.get_connections().size()
		total_interactables += inter
		total_connections += conn
		if inter > 0:
			rooms_with_interactables += 1
		if conn > 0:
			rooms_with_connections += 1

	_assert("rooms with interactables >= 15", rooms_with_interactables >= 15)
	_assert("rooms with connections >= 18", rooms_with_connections >= 18)
	_assert("total interactables >= 30", total_interactables >= 30)
	_assert("total connections >= 30", total_connections >= 30)
	print("[PASS] Gameplay nodes: %d interactables, %d connections" % [total_interactables, total_connections])


func _test_full_freedom_playthrough() -> void:
	_test_name = "FREEDOM_ENDING"
	_gm.new_game()

	# ACT I — Ground Floor
	_rm.load_room("front_gate")
	_do_interact("gate_plaque")

	_rm.load_room("foyer")
	_do_interact("foyer_painting")
	_do_interact("grandfather_clock")

	_rm.load_room("parlor")
	_do_interact("parlor_note")

	_rm.load_room("kitchen")

	# Basement
	_rm.load_room("storage_basement")
	_do_interact("scratched_portrait")

	_rm.load_room("boiler_room")
	_do_interact("maintenance_log")

	_rm.load_room("wine_cellar")
	_do_interact("wine_note")

	# ACT II — Upper Floor
	_rm.load_room("upper_hallway")
	_do_interact("children_painting")

	_rm.load_room("master_bedroom")
	_do_interact("diary_lord")
	_assert("diary sets knows_key_location", _gm.has_flag("knows_key_location"))

	_rm.load_room("library")
	_do_interact("family_tree")
	_do_interact("binding_book")
	_assert("binding_book in inventory", _gm.has_item("binding_book"))

	# PUZZLE 1: Attic Key
	_do_interact("library_globe")
	_assert("attic_key acquired", _gm.has_item("attic_key"))

	# Grounds — collect ritual components
	_rm.load_room("greenhouse")
	_do_interact("greenhouse_gate_key")
	_assert("gate_key acquired", _gm.has_item("gate_key"))

	_rm.load_room("chapel")
	_do_interact("baptismal_font")
	_assert("blessed_water acquired", _gm.has_item("blessed_water"))

	_rm.load_room("carriage_house")
	_do_interact("carriage_portrait")
	_assert("cellar_key acquired", _gm.has_item("cellar_key"))

	_rm.load_room("family_crypt")
	_do_interact("loose_flagstone")
	_assert("jewelry_key acquired", _gm.has_item("jewelry_key"))

	# Open locked containers
	_rm.load_room("wine_cellar")
	_do_interact("wine_box")
	_assert("mothers_confession acquired", _gm.has_item("mothers_confession"))

	_rm.load_room("master_bedroom")
	_do_interact("jewelry_box")
	_assert("lock_of_hair acquired", _gm.has_item("lock_of_hair"))

	# ACT III — Attic
	_rm.load_room("attic_storage")
	_assert("elizabeth_aware set", _gm.has_flag("elizabeth_aware"))

	_do_interact("elizabeth_portrait")
	_do_interact("elizabeth_letter")
	_assert("read_elizabeth_letter", _gm.has_flag("read_elizabeth_letter"))

	# PUZZLE 2: Hidden Key (doll)
	_do_interact("porcelain_doll")
	_assert("examined_doll", _gm.has_flag("examined_doll"))
	_do_interact("porcelain_doll")
	_assert("hidden_key acquired", _gm.has_item("hidden_key"))
	_assert("porcelain_doll acquired", _gm.has_item("porcelain_doll"))

	# Hidden Chamber
	_rm.load_room("hidden_room")
	_do_interact("final_note")
	_assert("knows_full_truth", _gm.has_flag("knows_full_truth"))

	# PUZZLE 6: Counter-Ritual
	_assert("can_perform_ritual", _gm.can_perform_ritual())

	_do_interact("ritual_circle")
	_assert("ritual_step_1", _gm.has_flag("ritual_step_1"))

	_do_interact("ritual_circle")
	_assert("ritual_step_2", _gm.has_flag("ritual_step_2"))

	_do_interact("ritual_circle")
	_assert("ritual_step_3", _gm.has_flag("ritual_step_3"))
	_assert("counter_ritual_complete", _gm.has_flag("counter_ritual_complete"))
	_assert("freed_elizabeth", _gm.has_flag("freed_elizabeth"))

	print("[PASS] FREEDOM ENDING — Full playthrough complete")
	print("  Rooms visited: %d" % _gm.visited_rooms.size())
	print("  Items collected: %d" % _gm.inventory.size())
	print("  Flags set: %d" % _gm.flags.size())


func _test_escape_ending() -> void:
	_test_name = "ESCAPE_ENDING"
	_gm.new_game()

	_rm.load_room("library")
	_do_interact("library_globe")
	_rm.load_room("attic_storage")
	_do_interact("elizabeth_letter")
	_do_interact("porcelain_doll")
	_do_interact("porcelain_doll")
	_rm.load_room("hidden_room")
	_do_interact("final_note")

	_assert("escape conditions met", _gm.check_escape_ending())
	print("[PASS] ESCAPE ENDING conditions verified")


func _test_joined_ending() -> void:
	_test_name = "JOINED_ENDING"
	_gm.new_game()

	_rm.load_room("attic_storage")
	_assert("elizabeth_aware", _gm.has_flag("elizabeth_aware"))
	_assert("not knows_full_truth", not _gm.has_flag("knows_full_truth"))
	_assert("joined conditions met", _gm.check_joined_ending())
	print("[PASS] JOINED ENDING conditions verified")


func _test_save_load() -> void:
	_test_name = "SAVE_LOAD"
	_gm.new_game()

	_rm.load_room("foyer")
	_do_interact("foyer_painting")
	_rm.load_room("library")
	_do_interact("library_globe")
	_gm.save_game()

	var saved_room: String = _gm.current_room
	var saved_inventory: Array = _gm.inventory.duplicate()

	_gm.new_game()
	_assert("inventory cleared", _gm.inventory.is_empty())

	var loaded: bool = _gm.load_game()
	_assert("load succeeded", loaded)
	_assert("room restored", _gm.current_room == saved_room)
	_assert("inventory restored", _gm.has_item("attic_key"))
	_assert("interaction restored", _gm.has_interacted("foyer_painting"))
	print("[PASS] SAVE/LOAD verified")


# === Helpers ===

func _do_interact(object_id: String) -> void:
	var room = _rm.get_current_room()
	if room == null:
		return
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == object_id:
			var obj_type: String = area.get_meta("type") if area.has_meta("type") else ""
			var obj_data: Dictionary = area.get_meta("data") if area.has_meta("data") else {}
			_im._on_interacted(object_id, obj_type, obj_data)
			if _ui and _ui.has_method("hide_document"):
				_ui.hide_document()
			return


func _assert(description: String, condition: bool) -> void:
	if condition:
		_pass_count += 1
	else:
		_fail_count += 1
		print("[FAIL] %s :: %s" % [_test_name, description])


func _find(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var found: Node = _find(child, target)
		if found != null:
			return found
	return null
