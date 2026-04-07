extends SceneTree
## Declaration-era end-to-end path coverage.
## Covers:
## - Freedom route through the shipped declaration runtime
## - Escape ending via post-truth return to front gate
## - Joined ending via post-attic return to front gate without full truth

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _ending_events: Array[String] = []
var _pass_count: int = 0
var _fail_count: int = 0


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_ui = _find(_main, "UIOverlay") as Control
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("GameManager found", _gm != null)
	_assert("RoomManager found", _rm != null)
	_assert("InteractionManager found", _im != null)
	_assert("UIOverlay found", _ui != null)
	if _gm == null or _rm == null or _im == null or _ui == null:
		_finish()
		return

	_disable_nonessential_runtime_systems()

	if _gm.has_signal("ending_triggered"):
		var cb := Callable(self, "_on_ending_triggered")
		if not _gm.ending_triggered.is_connected(cb):
			_gm.ending_triggered.connect(cb)

	await _test_freedom_route()
	await _test_escape_front_gate_path()
	await _test_joined_front_gate_path()
	_finish()


func _test_freedom_route() -> void:
	_reset_game("captive")
	await _load_room("front_gate")
	await _interact("gate_plaque")
	_assert("front gate threshold acknowledged", _gm.get_state("front_gate_threshold_acknowledged", false) == true)
	await _door_to("drive_lower")
	_assert("front gate to drive_lower transition works", _gm.current_room == "drive_lower")
	_assert("front drive stays in entrance path world", _rm.get_loaded_compiled_world_id() == "entrance_path_world")
	await _door_to("drive_upper")
	_assert("drive_lower to drive_upper transition works", _gm.current_room == "drive_upper")
	await _door_to("front_steps")
	_assert("drive_upper to front_steps transition works", _gm.current_room == "front_steps")
	await _door_to("foyer")
	_assert("front_steps to foyer transition works", _gm.current_room == "foyer")
	_assert("foyer loads manor interior compiled world", _rm.get_loaded_compiled_world_id() == "manor_interior_world")
	_assert("manor interior world keeps multiple room roots loaded", _rm.get_loaded_compiled_world_room_ids().size() >= 8)

	await _door_to("upper_hallway")
	_assert("foyer to upper_hallway transition works", _gm.current_room == "upper_hallway")
	_assert("foyer to upper_hallway stays in manor interior world", _rm.get_loaded_compiled_world_id() == "manor_interior_world")
	await _door_to("master_bedroom")
	await _interact("diary_lord")
	_assert("master bedroom diary sets read_ashworth_diary", _gm.get_state("read_ashworth_diary", false) == true)
	await _interact("jewelry_box")
	_assert("jewelry box stays locked before key", not _gm.has_item("elizabeth_locket"))

	await _load_room("upper_hallway")
	await _door_to("library")
	await _interact("binding_book")
	await _interact("library_globe")
	_assert("library yields binding book", _gm.has_item("binding_book"))
	_assert("library yields attic key", _gm.has_item("attic_key"))

	await _load_room("kitchen")
	await _door_to("storage_basement")
	_assert("kitchen to storage_basement service route works", _gm.current_room == "storage_basement")
	_assert("storage_basement loads service basement world", _rm.get_loaded_compiled_world_id() == "service_basement_world")
	await _door_to("wine_cellar")
	_assert("storage_basement to wine_cellar stays in service basement world", _rm.get_loaded_compiled_world_id() == "service_basement_world")
	await _interact("wine_note")
	_assert("wine note sets read_wine_note", _gm.get_state("read_wine_note", false) == true)
	await _door_to("storage_basement")
	await _door_to("carriage_house")
	await _interact("carriage_portrait")
	_assert("carriage house yields cellar key", _gm.has_item("cellar_key"))
	await _door_to("storage_basement")
	await _interact("scratched_portrait")
	await _load_room("boiler_room")
	await _interact("maintenance_log")
	await _load_room("wine_cellar")
	await _interact("wine_box")
	_assert("wine cellar yields mother's confession", _gm.has_item("mothers_confession"))

	await _load_room("garden")
	await _interact("garden_lily")
	await _interact("garden_lily")
	_assert("garden yields jewelry key", _gm.has_item("jewelry_key"))
	await _load_room("chapel")
	await _interact("baptismal_font")
	_assert("chapel yields blessed water", _gm.has_item("blessed_water"))
	_assert("chapel yields gate key on current path", _gm.has_item("gate_key"))
	await _load_room("greenhouse")
	await _interact("greenhouse_pot")
	_assert("greenhouse interaction remains valid", _gm.has_item("gate_key"))

	await _load_room("master_bedroom")
	await _interact("jewelry_box")
	_assert("master bedroom yields elizabeth locket", _gm.has_item("elizabeth_locket"))
	_assert("master bedroom yields lock of hair", _gm.has_item("lock_of_hair"))

	await _load_room("upper_hallway")
	await _door_to("attic_stairs")
	_assert("upper hallway to attic stairs route works", _gm.current_room == "attic_stairs")
	_assert("attic stairs stays in manor interior world", _rm.get_loaded_compiled_world_id() == "manor_interior_world")
	await _door_to("attic_storage")
	await _interact("elizabeth_letter")
	await _interact("porcelain_doll")
	await _interact("porcelain_doll")
	_assert("attic doll yields hidden key", _gm.has_item("hidden_key"))
	_assert("attic doll becomes inventory item", _gm.has_item("porcelain_doll"))

	await _door_to("hidden_chamber")
	_assert("attic storage to hidden chamber route works", _gm.current_room == "hidden_chamber")
	await _interact("elizabeth_final_note")
	_assert("hidden chamber reveals full truth", _gm.has_flag("knows_full_truth"))
	_assert("hidden chamber sets read_final_note", _gm.has_flag("read_final_note"))
	_assert("ritual can now be performed", _gm.can_perform_ritual())

	await _interact("ritual_circle")
	await _interact("ritual_circle")
	await _interact("ritual_circle")
	_assert("ritual step 1 set", _gm.has_flag("ritual_step_1"))
	_assert("ritual step 2 set", _gm.has_flag("ritual_step_2"))
	_assert("counter ritual complete", _gm.has_flag("counter_ritual_complete"))
	await create_timer(6.5).timeout
	_assert("freedom ending fired", _ending_events.has("freedom"))


func _test_escape_front_gate_path() -> void:
	_reset_game("mourning")
	await _load_room("foyer")
	_gm.set_flag("knows_full_truth")
	_gm.flags.erase("counter_ritual_complete")
	_ending_events.clear()
	await _door_to("front_steps")
	await _door_to("drive_upper")
	await _door_to("drive_lower")
	_im._on_door_tapped("front_gate", "drive_lower_to_front_gate")
	await process_frame
	await process_frame
	_assert("escape ending fired from front gate return", _ending_events.has("escape"))


func _test_joined_front_gate_path() -> void:
	_reset_game("sovereign")
	await _load_room("foyer")
	_gm.set_flag("elizabeth_aware")
	_gm.flags.erase("knows_full_truth")
	_gm.flags.erase("counter_ritual_complete")
	_ending_events.clear()
	await _door_to("front_steps")
	await _door_to("drive_upper")
	await _door_to("drive_lower")
	_im._on_door_tapped("front_gate", "drive_lower_to_front_gate")
	await process_frame
	await process_frame
	_assert("joined ending fired from front gate return", _ending_events.has("joined"))


func _reset_game(thread_id: String) -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", thread_id)
	_ending_events.clear()
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()


func _load_room(room_id: String) -> void:
	_rm.load_room(room_id)
	await process_frame
	await process_frame
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()


func _door_to(room_id: String) -> void:
	print("DOOR -> %s (from %s)" % [room_id, _gm.current_room])
	_im._on_door_tapped(room_id)
	var loaded: bool = false
	for _i in range(240):
		await process_frame
		if _gm.current_room == room_id:
			loaded = true
			break
		if not _ending_events.is_empty():
			break
	_assert("transition loaded %s" % room_id, loaded)
	if loaded:
		for _j in range(240):
			await process_frame
			if not _rm.get("_is_transitioning"):
				break
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()


func _interact(object_id: String) -> void:
	var room = _rm.get_current_room()
	_assert("current room exists for interact %s" % object_id, room != null)
	if room == null:
		return
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == object_id:
			var obj_type: String = area.get_meta("type") if area.has_meta("type") else ""
			var obj_data: Dictionary = area.get_meta("data") if area.has_meta("data") else {}
			_im._on_interacted(object_id, obj_type, obj_data)
			await process_frame
			await process_frame
			return
	_assert("interactable %s exists in %s" % [object_id, _gm.current_room], false)


func _on_ending_triggered(ending_id: String) -> void:
	_ending_events.append(ending_id)


func _assert(name: String, condition: bool) -> void:
	if condition:
		_pass_count += 1
	else:
		_fail_count += 1
		print("[FAIL] %s" % name)


func _finish() -> void:
	call_deferred("_complete_finish")


func _complete_finish() -> void:
	if _gm != null and _gm.has_signal("ending_triggered"):
		var cb := Callable(self, "_on_ending_triggered")
		if _gm.ending_triggered.is_connected(cb):
			_gm.ending_triggered.disconnect(cb)
	var audio := _find(_main, "AudioManager")
	if audio != null and audio.has_method("shutdown"):
		audio.shutdown()
		await process_frame
		await process_frame
	if audio != null and is_instance_valid(audio):
		audio.queue_free()
		await process_frame
	if _main != null:
		_main.queue_free()
		await process_frame
		await process_frame
		await process_frame
		await process_frame
		_main = null
	print("")
	print("========================================")
	print("FULL PLAYTHROUGH: %d passed, %d failed" % [_pass_count, _fail_count])
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _disable_nonessential_runtime_systems() -> void:
	if _im != null:
		_im._dialogue_paths = {}
		_im._current_dialogue_resource = null
		_im._audio_manager = null
	var audio := _find(_main, "AudioManager")
	if audio != null:
		if audio.has_method("shutdown"):
			audio.shutdown()
		audio.queue_free()


func _find(node: Node, target_name: String) -> Node:
	if node == null:
		return null
	if node.name == target_name:
		return node
	for child in node.get_children():
		var found := _find(child, target_name)
		if found != null:
			return found
	return null
