extends SceneTree
## Route-order validation for the authored Adult -> Elder -> Child progression.
## Run: godot --headless --path . --script test/e2e/test_route_progression.gd

var _main: Node = null
var _gm: Node = null
var _pass_count: int = 0
var _fail_count: int = 0


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	call_deferred("_run")


func _run() -> void:
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("GameManager found", _gm != null)
	if _gm == null:
		_finish()
		return

	_clear_save_data()
	_gm.reset_route_progression()

	_gm.new_game()
	_assert("first new_game picks adult route", _gm.get_active_route() == "adult")
	_assert("adult route keeps mourning as legacy compatibility thread", _gm.get_state("macro_thread", "") == "mourning")

	_gm.mark_route_completed()
	_gm.new_game()
	_assert("second new_game picks elder route", _gm.get_active_route() == "elder")
	_assert("elder route keeps sovereign as legacy compatibility thread", _gm.get_state("macro_thread", "") == "sovereign")

	_gm.mark_route_completed()
	_gm.new_game()
	_assert("third new_game picks child route", _gm.get_active_route() == "child")
	_assert("child route keeps captive as legacy compatibility thread", _gm.get_state("macro_thread", "") == "captive")

	_gm.mark_route_completed()
	_gm.new_game()
	var replay_route: String = _gm.get_active_route()
	_assert("post-unlock replay route stays inside authored route set", ["adult", "elder", "child"].has(replay_route))
	_assert("all three completed routes tracked", _gm.get_completed_routes().size() == 3)

	_finish()


func _clear_save_data() -> void:
	var save_system := root.get_node_or_null("SaveSystem")
	if save_system != null and save_system.has_method("delete_all"):
		save_system.delete_all()


func _assert(name: String, condition: bool) -> void:
	if condition:
		_pass_count += 1
		print("[PASS] %s" % name)
		return
	_fail_count += 1
	print("[FAIL] %s" % name)


func _finish() -> void:
	print("")
	print("========================================")
	print("ROUTE PROGRESSION: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")
	quit(1 if _fail_count > 0 else 0)
