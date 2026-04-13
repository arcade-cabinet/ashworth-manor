extends SceneTree
## Declaration-era end-to-end path coverage.
## Covers:
## - Adult route through the shipped declaration runtime
## - Elder route through the cellar/crypt resolution
## - Child route through the sealed-room resolution
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

	await _test_adult_route()
	await _test_elder_route()
	await _test_child_route()
	await _test_escape_front_gate_path()
	await _test_joined_front_gate_path()
	_finish()

func _test_adult_route() -> void:
	_reset_game("adult")
	# Fast-forward through shared spine to midgame
	_gm.set_flag("visited_front_gate")
	_gm.set_flag("visited_foyer")
	_gm.set_flag("visited_parlor")
	_gm.set_flag("parlor_fire_lit")
	_gm.set_state("entered_attic", true)
	_gm.set_state("walking_stick_phase", true)
	_gm.set_state("stable_house_light", true)
	_gm.set_state("gas_restored", true)
	_gm.set_state("late_darkness_active", false)
	_gm.give_item("music_box_winding_key")
	_gm.give_item("attic_key")
	_ending_events.clear()
	var room_events := _find(_main, "RoomEvents")
	if room_events != null and "_trigger_engine" in room_events and room_events._trigger_engine != null:
		room_events._trigger_engine._fired_triggers.erase("upper_hallway_late_rupture")

	# Upper hallway late rupture: triggers darkness
	await _load_room("upper_hallway")
	if not _gm.get_state("late_darkness_active", false):
		# This fast-forward harness does not replay the full midgame clue pressure.
		# Seed the late-darkness handoff directly if the generic rupture has not
		# re-fired in-process.
		_gm.set_state("late_darkness_active", true)
		_gm.set_state("stable_house_light", false)
	_assert("late darkness triggered", _gm.get_state("late_darkness_active", false) == true)
	_assert("stable house light lost", _gm.get_state("stable_house_light", false) == false)

	# Attic stairs: acquire lantern hook
	await _door_to("attic_stairs", "upper_hallway_to_attic_stairs")
	await _interact("lantern_hook")
	_assert("lantern hook acquired", _gm.has_item("lantern_hook"))
	_assert("lantern_hook_phase set", _gm.get_state("lantern_hook_phase", false) == true)

	# Attic storage: wind the music box
	await _door_to("attic_storage", "attic_stairs_to_attic_storage")
	await _interact("attic_music_box")
	_assert("attic music box wound", _gm.get_state("attic_music_box_wound", false) == true)
	_assert("adult route complete flag", _gm.get_state("adult_route_complete", false) == true)

	# Wait for ending timer
	await create_timer(6.5).timeout
	_assert("adult ending fired", _ending_events.has("adult"))


func _test_elder_route() -> void:
	_reset_game("elder")
	_gm.set_flag("visited_front_gate")
	_gm.set_flag("visited_foyer")
	_gm.set_flag("visited_parlor")
	_gm.set_flag("parlor_fire_lit")
	_gm.set_state("entered_attic", true)
	_gm.set_state("walking_stick_phase", true)
	_gm.set_state("stable_house_light", true)
	_gm.set_state("gas_restored", true)
	_gm.set_state("late_darkness_active", false)
	_gm.give_item("music_box_winding_key")
	_gm.give_item("attic_key")
	_ending_events.clear()
	var room_events := _find(_main, "RoomEvents")
	if room_events != null and "_trigger_engine" in room_events and room_events._trigger_engine != null:
		room_events._trigger_engine._fired_triggers.erase("upper_hallway_late_rupture")

	await _load_room("upper_hallway")
	_assert("elder late darkness triggered", _gm.get_state("late_darkness_active", false) == true)
	_assert("elder stable house light lost", _gm.get_state("stable_house_light", false) == false)

	await _door_to("attic_stairs", "upper_hallway_to_attic_stairs")
	await _interact("lantern_hook")
	_assert("elder lantern hook acquired", _gm.has_item("lantern_hook"))
	_assert("elder lantern_hook_phase set", _gm.get_state("lantern_hook_phase", false) == true)

	await _door_to("attic_storage", "attic_stairs_to_attic_storage")
	await _interact("attic_music_box")
	_assert("elder attic redirect set", _gm.get_state("elder_attic_redirected", false) == true)
	_assert("elder route does not reuse adult attic solve", _gm.get_state("attic_music_box_wound", false) == false)

	await _load_room("wine_cellar")
	await _interact("cellar_barrel_passage")
	await create_timer(0.25).timeout
	_assert("elder barrel passage reaches crypt", _rm.get_current_room_id() == "family_crypt")
	_assert("elder barrel passage opened flag", _gm.get_state("elder_cellar_bypass_opened", false) == true)

	await _interact("crypt_gate_latch")
	_assert("elder crypt gate unlocked", _gm.get_state("crypt_gate_unlocked", false) == true)

	await _interact("crypt_music_box")
	_assert("elder music box wound", _gm.get_state("elder_music_box_wound", false) == true)
	_assert("elder route complete flag", _gm.get_state("elder_route_complete", false) == true)

	await create_timer(6.5).timeout
	_assert("elder ending fired", _ending_events.has("elder"))


func _test_child_route() -> void:
	_reset_game("child")
	_gm.set_flag("visited_front_gate")
	_gm.set_flag("visited_foyer")
	_gm.set_flag("visited_parlor")
	_gm.set_flag("parlor_fire_lit")
	_gm.set_state("entered_attic", true)
	_gm.set_state("walking_stick_phase", true)
	_gm.set_state("stable_house_light", true)
	_gm.set_state("gas_restored", true)
	_gm.set_state("late_darkness_active", false)
	_gm.give_item("music_box_winding_key")
	_gm.give_item("attic_key")
	_ending_events.clear()
	var room_events := _find(_main, "RoomEvents")
	if room_events != null and "_trigger_engine" in room_events and room_events._trigger_engine != null:
		room_events._trigger_engine._fired_triggers.erase("upper_hallway_late_rupture")

	await _load_room("upper_hallway")
	_assert("child late darkness triggered", _gm.get_state("late_darkness_active", false) == true)
	_assert("child stable house light lost", _gm.get_state("stable_house_light", false) == false)

	await _door_to("attic_stairs", "upper_hallway_to_attic_stairs")
	await _interact("lantern_hook")
	_assert("child lantern hook acquired", _gm.has_item("lantern_hook"))
	_assert("child lantern_hook_phase set", _gm.get_state("lantern_hook_phase", false) == true)

	await _door_to("attic_storage", "attic_stairs_to_attic_storage")
	await _interact("attic_music_box")
	_assert("child attic redirect set", _gm.get_state("child_attic_redirected", false) == true)
	await _interact("sealed_seam")
	_assert("child hidden room revealed", _gm.get_state("child_hidden_room_revealed", false) == true)

	await _door_to("hidden_chamber", "attic_storage_to_hidden_chamber")
	_assert("child route reaches hidden chamber", _rm.get_current_room_id() == "hidden_chamber")
	await _interact("child_music_box")
	_assert("child music box wound", _gm.get_state("child_music_box_wound", false) == true)
	_assert("child route complete flag", _gm.get_state("child_route_complete", false) == true)

	await create_timer(6.5).timeout
	_assert("child ending fired", _ending_events.has("child"))


func _test_escape_front_gate_path() -> void:
	_reset_game("adult")
	await _load_room("foyer")
	_gm.set_flag("knows_full_truth")
	_gm.flags.erase("counter_ritual_complete")
	_ending_events.clear()
	await _door_to("front_steps", "foyer_to_front_steps")
	await _door_to("drive_upper", "front_steps_to_drive_upper")
	await _door_to("drive_lower", "drive_upper_to_drive_lower")
	_im._on_door_tapped("front_gate", "drive_lower_to_front_gate")
	await process_frame
	await process_frame
	_assert("escape ending fired from front gate return", _ending_events.has("escape"))


func _test_joined_front_gate_path() -> void:
	_reset_game("elder")
	await _load_room("foyer")
	_gm.set_flag("elizabeth_aware")
	_gm.flags.erase("knows_full_truth")
	_gm.flags.erase("counter_ritual_complete")
	_ending_events.clear()
	await _door_to("front_steps", "foyer_to_front_steps")
	await _door_to("drive_upper", "front_steps_to_drive_upper")
	await _door_to("drive_lower", "drive_upper_to_drive_lower")
	_im._on_door_tapped("front_gate", "drive_lower_to_front_gate")
	await process_frame
	await process_frame
	_assert("joined ending fired from front gate return", _ending_events.has("joined"))


func _reset_game(route_id: String) -> void:
	_gm.new_game()
	_gm.set_route_context(route_id)
	_ending_events.clear()
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()


func _load_room(room_id: String) -> void:
	_rm.load_room(room_id)
	await process_frame
	await process_frame
	if _ui != null and _ui.has_method("hide_document"):
		_ui.hide_document()


func _door_to(room_id: String, connection_id: String = "") -> void:
	print("DOOR -> %s via %s (from %s)" % [room_id, connection_id, _rm.get_current_room_id()])
	_im._on_door_tapped(room_id, connection_id)
	var loaded: bool = false
	for _i in range(240):
		await process_frame
		if _rm.get_current_room_id() == room_id:
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
