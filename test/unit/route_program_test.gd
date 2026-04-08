# GdUnit generated TestSuite
class_name RouteProgramTest
extends GdUnitTestSuite

const MAIN_SCENE := preload("res://scenes/main.tscn")


func test_route_program_progresses_and_enters_replay_mode(timeout := 5000) -> void:
	var main: Node = auto_free(MAIN_SCENE.instantiate())
	get_tree().root.add_child(main)
	await await_idle_frame()

	var gm := _find_root_node("GameManager")
	assert_object(gm).is_not_null()
	if gm == null:
		return

	var save_system := _find_root_node("SaveSystem")
	if save_system != null and save_system.has_method("delete_all"):
		save_system.delete_all()

	gm.reset_route_progression()
	gm.new_game()
	assert_str(gm.get_active_route()).is_equal("adult")
	assert_str(gm.get_route_mode()).is_equal("canonical_progression")

	gm.mark_route_completed()
	gm.new_game()
	assert_str(gm.get_active_route()).is_equal("elder")

	gm.mark_route_completed()
	gm.new_game()
	assert_str(gm.get_active_route()).is_equal("child")

	gm.mark_route_completed()
	gm.new_game()
	assert_array(gm.get_completed_routes()).contains_exactly(["adult", "elder", "child"])
	assert_array(["adult", "elder", "child"]).contains(gm.get_active_route())
	assert_str(gm.get_route_mode()).is_equal("post_canonical_replay")


func test_route_context_helper_sets_route_and_compatibility_thread(timeout := 3000) -> void:
	var main: Node = auto_free(MAIN_SCENE.instantiate())
	get_tree().root.add_child(main)
	await await_idle_frame()

	var gm := _find_root_node("GameManager")
	assert_object(gm).is_not_null()
	if gm == null:
		return

	gm.set_route_context("elder")
	assert_str(gm.get_active_route()).is_equal("elder")
	assert_str(str(gm.get_state("macro_thread", ""))).is_equal("sovereign")

	gm.set_route_context("child")
	assert_str(gm.get_active_route()).is_equal("child")
	assert_str(str(gm.get_state("macro_thread", ""))).is_equal("captive")

	gm.set_route_context("")
	assert_str(gm.get_active_route()).is_equal("")
	assert_str(str(gm.get_state("macro_thread", ""))).is_equal("")


func _find_root_node(node_name: String) -> Node:
	for child in get_tree().root.get_children():
		if child.name == node_name:
			return child
	return get_tree().root.find_child(node_name, true, false)
