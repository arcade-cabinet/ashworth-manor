extends SceneTree
## Runtime validation for declaration-authored interaction responses.
## Run: godot --headless --path . --script test/e2e/test_declared_interactions.gd

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _room_events: Node = null
var _ui: Control = null
var _gm: Node = null
var _pass_count: int = 0
var _fail_count: int = 0


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_room_events = _find(_main, "RoomEvents")
	_ui = _find(_main, "UIOverlay") as Control
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("GameManager found", _gm != null)
	_assert("RoomManager found", _rm != null)
	_assert("InteractionManager found", _im != null)
	_assert("RoomEvents found", _room_events != null)
	_assert("UIOverlay found", _ui != null)

	if _gm == null or _rm == null or _im == null or _room_events == null or _ui == null:
		_finish()
		return

	_disable_nonessential_runtime_systems()

	if _im.has_method("_connect_signals"):
		_im._connect_signals()
	if _room_events.has_method("_connect_signals"):
		_room_events._connect_signals()

	await _test_front_gate_entry_trigger()
	await _test_front_gate_threshold_gate()
	await _test_front_gate_menu_new_game()
	_test_front_gate_menu_load_game_without_save()
	_test_front_gate_menu_settings_toggle()
	_test_front_gate_conditional_response()
	_test_front_gate_thread_response()
	_test_front_gate_conditional_beats_thread_flavor()
	await _test_foyer_entry_threshold()
	await _test_foyer_sovereign_entry_threshold()
	_test_foyer_thread_response()
	_test_foyer_conditional_beats_thread_flavor()
	await _test_attic_stairwell_threshold()
	_test_storage_basement_service_stack()
	_test_storage_basement_entry_beat()
	_test_parlor_conditional_beats_thread_flavor()
	await _test_parlor_first_warmth_firebrand()
	await _test_parlor_tea_visual_states()
	_test_dining_room_core_interactions()
	await _test_dining_wine_glass_visual_states()
	_test_kitchen_core_interactions()
	await _test_kitchen_service_descent_trigger()
	await _test_kitchen_bucket_visual_states()
	await _test_chapel_font_visual_states()
	_test_boiler_room_core_interactions()
	_test_boiler_room_walking_cane()
	_test_kitchen_service_return()
	_test_attic_stairs_lantern_hook()
	_test_attic_music_box_adult_resolution()
	_test_wine_cellar_core_interactions()
	_test_library_key_and_book_path()
	_test_guest_room_core_interactions()
	await _test_threshold_mechanism_assemblies()
	await _test_hidden_chamber_core_interactions()
	await _test_library_binding_aftershock()
	await _test_parlor_music_box_auto_event()
	_finish()


func _test_front_gate_entry_trigger() -> void:
	_gm.new_game()
	_rm.load_room("front_gate")
	_assert("front_gate entry sets visited_front_gate", _gm.has_flag("visited_front_gate"))
	_assert("front_gate entry sets game_started", _gm.has_flag("game_started"))
	_assert("front_gate entry remains document-neutral", _get_document_content().is_empty())


func _test_front_gate_threshold_gate() -> void:
	_gm.new_game()
	_rm.load_room("front_gate")
	_im._on_door_tapped("drive_lower")
	_assert("front_gate threshold blocked text", "valise still sits unopened" in _get_document_content())
	_ui.hide_document()
	var decl: InteractableDecl = _find_decl("gate_luggage")
	_assert("gate_luggage declaration found for threshold", decl != null)
	if decl == null:
		return
	_im._on_interacted("gate_luggage", decl.type, {})
	_assert("gate valise grants solicitor packet", _gm.has_item("solicitor_packet"))
	_assert("gate valise grants front door key", _gm.has_item("front_door_key"))
	_assert("gate valise grants winding key", _gm.has_item("music_box_winding_key"))
	_assert("front_gate threshold acknowledged", _gm.get_state("front_gate_threshold_acknowledged", false) == true)
	await create_timer(0.2).timeout
	var room = _rm.get_current_room()
	var gate_light: Light3D = null
	var gate_light_base: float = -1.0
	if room != null and room.has_method("find_light_by_id"):
		gate_light = room.find_light_by_id("gate_lamp_light")
	if room != null and room.has_method("get_light_base_energy"):
		gate_light_base = room.get_light_base_energy("gate_lamp_light")
	_assert("front_gate threshold lamp found", gate_light != null)
	_assert("front_gate threshold lamp pulses", gate_light_base > 2.5)
	_im._on_door_tapped("drive_lower")
	var loaded_room := await _await_room_id("drive_lower")
	_assert("front_gate threshold transitions to drive_lower", loaded_room and _gm.current_room == "drive_lower")
	_ui.hide_document()


func _test_front_gate_menu_new_game() -> void:
	_rm.load_room("front_gate")
	var decl: InteractableDecl = _find_decl("gate_sign_new_game")
	_assert("gate_sign_new_game declaration found", decl != null)
	if decl == null:
		return
	_im._on_interacted("gate_sign_new_game", decl.type, {})
	await process_frame
	await process_frame
	_assert("gate_sign_new_game stores selection", _gm.get_state("front_gate_menu_selection", "") == "new_game")
	_assert("gate_sign_new_game presents packet", _gm.get_state("front_gate_packet_presented", false) == true)
	_assert("gate_sign_new_game shows solicitor packet", "final acting caretaker" in _get_document_content())
	_assert("gate_sign_new_game does not skip the valise gate", _gm.get_state("front_gate_threshold_acknowledged", false) == false)
	_assert("gate_sign_new_game keeps front gate active", _rm.get_current_room_id() == "front_gate")
	_ui.hide_document()


func _test_front_gate_menu_load_game_without_save() -> void:
	_clear_save_data()
	_gm.new_game()
	_rm.load_room("front_gate")
	var decl: InteractableDecl = _find_decl("gate_sign_load_game")
	_assert("gate_sign_load_game declaration found", decl != null)
	if decl == null:
		return
	_im._on_interacted("gate_sign_load_game", decl.type, {})
	_assert("gate_sign_load_game no-save text", "No prior journey hangs on the sign's chain" in _get_document_content())
	_ui.hide_document()


func _test_front_gate_menu_settings_toggle() -> void:
	_gm.new_game()
	_rm.load_room("front_gate")
	var decl: InteractableDecl = _find_decl("gate_sign_settings")
	_assert("gate_sign_settings declaration found", decl != null)
	if decl == null:
		return
	var tree := _main.get_tree() if _main != null else null
	var was_paused: bool = tree.paused if tree != null else false
	_im._on_interacted("gate_sign_settings", decl.type, {})
	_assert("gate_sign_settings opens pause menu", tree != null and tree.paused == true)
	_im._on_interacted("gate_sign_settings", decl.type, {})
	_assert("gate_sign_settings closes pause menu", tree != null and tree.paused == was_paused)


func _clear_save_data() -> void:
	var save_system := root.get_node_or_null("SaveSystem")
	if save_system != null and save_system.has_method("delete_all"):
		save_system.delete_all()


func _await_room_id(room_id: String, max_frames: int = 120) -> bool:
	for _i in range(max_frames):
		if _rm != null and _rm.get_current_room_id() == room_id:
			return true
		await process_frame
	return _rm != null and _rm.get_current_room_id() == room_id


func _test_front_gate_conditional_response() -> void:
	_gm.new_game()
	_rm.load_room("front_gate")
	_gm.set_state("macro_thread", "")
	_gm.set_state("knows_full_truth", true)
	var decl: InteractableDecl = _find_decl("gate_plaque")
	_assert("gate_plaque declaration found", decl != null)
	if decl == null:
		return

	var handled: bool = _im._handle_declared_interaction(decl)
	_assert("gate_plaque handled", handled)

	var title := _get_document_title()
	var content := _get_document_content()
	_assert("gate_plaque title", title == "Ashworth Manor")
	_assert("gate_plaque truth text", "make the world forget Elizabeth existed" in content)

	_ui.hide_document()


func _test_foyer_thread_response() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "mourning")
	_rm.load_room("foyer")
	var decl: InteractableDecl = _find_decl("foyer_painting")
	_assert("foyer_painting declaration found", decl != null)
	if decl == null:
		return

	var handled: bool = _im._handle_declared_interaction(decl)
	_assert("foyer_painting handled", handled)

	var title := _get_document_title()
	var content := _get_document_content()
	_assert("foyer_painting title", title == "Lord Ashworth")
	_assert("foyer_painting mourning thread text", "yellowed with age" in content)

	_ui.hide_document()


func _test_foyer_conditional_beats_thread_flavor() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "mourning")
	_gm.set_state("read_ashworth_diary", true)
	_rm.load_room("foyer")
	var decl: InteractableDecl = _find_decl("foyer_painting")
	_assert("foyer_painting declaration found for conditional precedence", decl != null)
	if decl == null:
		return

	var handled: bool = _im._handle_declared_interaction(decl)
	_assert("foyer_painting handled for conditional precedence", handled)

	var content := _get_document_content()
	_assert("foyer_painting diary truth overrides thread flavor", "locked his daughter in the attic" in content)

	_ui.hide_document()


func _test_foyer_entry_threshold() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "mourning")
	_gm.set_state("visited_foyer", false)
	_gm.set_state("foyer_threshold_crossed", false)
	_gm.set_state("foyer_chandelier_awakened", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("foyer_first_entry")
		_room_events._trigger_engine._fired_triggers.erase("foyer_first_entry_sovereign")
	_rm.load_room("front_gate")
	var decl: InteractableDecl = _find_decl("gate_plaque")
	_assert("gate_plaque declaration found for foyer entry", decl != null)
	if decl == null:
		return
	_im._handle_declared_interaction(decl)
	_rm.load_room("foyer")
	_assert("foyer room loaded after threshold", _gm.current_room == "foyer")
	_assert("foyer threshold crossed state", _gm.get_state("foyer_threshold_crossed", false) == true)
	_assert("foyer first-entry text keeps the hall dark", "Whatever warmth once lived here will have to be made by hand" in _get_document_content())
	await create_timer(0.2).timeout
	var room = _rm.get_current_room()
	var chandelier_base: float = -1.0
	if room != null and room.has_method("get_light_base_energy"):
		chandelier_base = room.get_light_base_energy("foyer_chandelier")
	_assert("foyer chandelier stays dark on standard entry", chandelier_base >= 0.0 and chandelier_base < 0.2)
	_ui.hide_document()


func _test_foyer_sovereign_entry_threshold() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "sovereign")
	_gm.set_state("visited_foyer", false)
	_gm.set_state("foyer_threshold_crossed", false)
	_gm.set_state("foyer_chandelier_awakened", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("foyer_first_entry")
		_room_events._trigger_engine._fired_triggers.erase("foyer_first_entry_sovereign")
	_rm.load_room("foyer")
	_assert("foyer sovereign threshold crossed state", _gm.get_state("foyer_threshold_crossed", false) == true)
	_assert("foyer sovereign chandelier awakened state", _gm.get_state("foyer_chandelier_awakened", false) == true)
	_assert("foyer sovereign text", "thin gold bloom" in _get_document_content())
	await create_timer(0.2).timeout
	var room = _rm.get_current_room()
	var chandelier_base: float = -1.0
	if room != null and room.has_method("get_light_base_energy"):
		chandelier_base = room.get_light_base_energy("foyer_chandelier")
	_assert("foyer sovereign chandelier answers on entry", chandelier_base > 1.5)
	_ui.hide_document()


func _test_front_gate_thread_response() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "sovereign")
	_rm.load_room("front_gate")
	var decl: InteractableDecl = _find_decl("gate_lamp")
	_assert("gate_lamp declaration found", decl != null)
	if decl == null:
		return

	var handled: bool = _im._handle_declared_interaction(decl)
	_assert("gate_lamp handled", handled)

	var title := _get_document_title()
	var content := _get_document_content()
	_assert("gate_lamp title", title == "Gas Lamp")
	_assert("gate_lamp remains neutral despite legacy thread compatibility", "maintained until recently" in content)

	_ui.hide_document()


func _test_front_gate_conditional_beats_thread_flavor() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "sovereign")
	_gm.set_state("elizabeth_aware", true)
	_rm.load_room("front_gate")
	var decl: InteractableDecl = _find_decl("gate_lamp")
	_assert("gate_lamp declaration found for conditional precedence", decl != null)
	if decl == null:
		return

	var handled: bool = _im._handle_declared_interaction(decl)
	_assert("gate_lamp handled for conditional precedence", handled)

	var content := _get_document_content()
	_assert("gate_lamp aware text overrides thread flavor", "breathing in sync with it" in content)

	_ui.hide_document()


func _test_attic_stairwell_threshold() -> void:
	_gm.new_game()
	_gm.set_state("entered_attic", false)
	_gm.set_state("elizabeth_aware", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("attic_first_entry")
	_rm.load_room("attic_stairs")
	_assert("attic stairwell sets entered_attic", _gm.get_state("entered_attic", false) == true)
	_assert("attic stairwell sets elizabeth_aware", _gm.get_state("elizabeth_aware", false) == true)


func _test_storage_basement_service_stack() -> void:
	_gm.new_game()
	_gm.set_state("noticed_service_route", false)
	_rm.load_room("storage_basement")
	var decl: InteractableDecl = _find_decl("service_stack")
	_assert("service_stack declaration found", decl != null)
	if decl == null:
		return
	var handled: bool = _im._handle_declared_interaction(decl)
	_assert("service_stack handled", handled)
	_assert("service_stack state set", _gm.get_state("noticed_service_route", false) == true)
	_assert("service_stack text", "conceal movement, not clutter" in _get_document_content())
	_ui.hide_document()


func _test_threshold_mechanism_assemblies() -> void:
	_gm.new_game()
	_rm.load_room("foyer")
	var door_root := _find_connection_root("foyer_to_kitchen")
	_assert("foyer_to_kitchen assembly exists", door_root != null)
	if door_root != null:
		var controller = door_root.get_node_or_null("ConnectionMechanism")
		_assert("door assembly has mechanism controller", controller != null)
		if controller != null and controller.has_method("play_transition_visual"):
			var duration: Variant = controller.play_transition_visual()
			if duration is float and duration > 0.0:
				await create_timer(duration + 0.05).timeout
			var hinge := door_root.get_node_or_null("DoorHinge") as Node3D
			_assert("door hinge visibly opens", hinge != null and absf(hinge.rotation_degrees.y) > 60.0)

	_rm.load_room("storage_basement")
	var hidden_root := _find_connection_root("storage_basement_to_carriage_house")
	_assert("secret passage assembly exists", hidden_root != null)
	if hidden_root != null:
		var hidden_controller = hidden_root.get_node_or_null("ConnectionMechanism")
		_assert("secret passage has mechanism controller", hidden_controller != null)
		if hidden_controller != null and hidden_controller.has_method("play_transition_visual"):
			var hidden_duration: Variant = hidden_controller.play_transition_visual()
			if hidden_duration is float and hidden_duration > 0.0:
				await create_timer(hidden_duration + 0.05).timeout
			var cover := hidden_root.get_node_or_null("SecretPanelMask") as Node3D
			var hidden_hinge := hidden_root.get_node_or_null("DoorHinge") as Node3D
			_assert("secret panel reveals on play", cover == null or not cover.visible or cover.position.x > 0.5)
			_assert("secret door visibly opens", hidden_hinge != null and absf(hidden_hinge.rotation_degrees.y) > 60.0)

	_rm.load_room("kitchen")
	var stairs_root := _find_connection_root("kitchen_to_storage_basement")
	_assert("trapdoor assembly exists", stairs_root != null)
	if stairs_root != null:
		var stairs_controller = stairs_root.get_node_or_null("ConnectionMechanism")
		_assert("trapdoor assembly has mechanism controller", stairs_controller != null)
		if stairs_controller != null and stairs_controller.has_method("play_transition_visual"):
			var stairs_duration: Variant = stairs_controller.play_transition_visual()
			if stairs_duration is float and stairs_duration > 0.0:
				await create_timer(stairs_duration + 0.05).timeout
			var trap_hinge := stairs_root.get_node_or_null("TrapdoorHinge") as Node3D
			_assert("trapdoor hinge visibly opens", trap_hinge != null and trap_hinge.rotation_degrees.x < -70.0)


func _test_storage_basement_entry_beat() -> void:
	_gm.new_game()
	_gm.set_state("visited_storage_basement", false)
	_gm.set_state("storage_basement_fall_landing_pending", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("storage_basement_forced_fall_entry")
		_room_events._trigger_engine._fired_triggers.erase("storage_basement_first_entry")
	_rm.load_room("storage_basement")
	_assert("storage_basement first-entry text", "could not admit upstairs" in _get_document_content())
	_ui.hide_document()


func _test_parlor_conditional_beats_thread_flavor() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "mourning")
	_gm.set_state("read_ashworth_diary", true)
	_rm.load_room("parlor")
	var portrait_decl: InteractableDecl = _find_decl("parlor_painting_1")
	_assert("parlor portrait declaration found for conditional precedence", portrait_decl != null)
	if portrait_decl != null:
		var handled_portrait: bool = _im._handle_declared_interaction(portrait_decl)
		_assert("parlor portrait handled for conditional precedence", handled_portrait)
		_assert("parlor portrait diary truth overrides thread flavor", "mourning Elizabeth before Elizabeth was gone" in _get_document_content())
		_ui.hide_document()

	_gm.set_state("elizabeth_aware", true)
	_gm.set_state("visited_attic_storage", true)
	var music_decl: InteractableDecl = _find_decl("music_box")
	_assert("music_box declaration found for conditional precedence", music_decl != null)
	if music_decl != null:
		var handled_music: bool = _im._handle_declared_interaction(music_decl)
		_assert("music_box handled for conditional precedence", handled_music)
		_assert("music_box aware text overrides thread flavor", "begins to play on its own" in _get_document_content())
		_ui.hide_document()


func _test_parlor_tea_visual_states() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "")
	_rm.load_room("parlor")
	await process_frame
	var tea_area := _find_interactable_area("parlor_tea")
	_assert("parlor tea area found", tea_area != null)
	if tea_area == null:
		return
	_assert("parlor tea starts set", String(tea_area.get_meta("visual_state")) == "set")
	var decl: InteractableDecl = _find_decl("parlor_tea")
	_assert("parlor_tea declaration found", decl != null)
	if decl == null:
		return
	var handled_first: bool = _im._handle_declared_interaction(decl)
	_assert("parlor_tea first interaction handled", handled_first)
	await process_frame
	_assert("parlor tea state set", _gm.get_state("examined_parlor_tea", false) == true)
	_assert("parlor tea disturbs after inspection", String(tea_area.get_meta("visual_state")) == "disturbed")
	_assert("parlor tea default text", "teapot is empty" in _get_document_content())
	_ui.hide_document()
	_gm.set_state("read_guest_ledger", true)
	var handled_second: bool = _im._handle_declared_interaction(decl)
	_assert("parlor_tea second interaction handled", handled_second)
	await process_frame
	_assert("parlor tea keeps disturbed visual", String(tea_area.get_meta("visual_state")) == "disturbed")
	_assert("parlor tea ledger text", "Helena Pierce" in _get_document_content())
	_ui.hide_document()


func _test_dining_room_core_interactions() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "")
	_gm.set_state("visited_dining_room", false)
	_gm.set_state("read_maintenance_log", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("dining_room_first_entry")
	_rm.load_room("dining_room")
	_assert("dining_room first-entry text", "meal stopped in the middle of deciding who would survive the night" in _get_document_content())
	_ui.hide_document()

	var photo_decl: InteractableDecl = _find_decl("dinner_photo")
	_assert("dinner_photo declaration found", photo_decl != null)
	if photo_decl != null:
		var handled_photo: bool = _im._handle_declared_interaction(photo_decl)
		_assert("dinner_photo handled", handled_photo)
		_assert("dinner_photo default text", "stares directly at the camera" in _get_document_content())
		_ui.hide_document()

	_gm.set_state("macro_thread", "mourning")
	_gm.set_state("read_maintenance_log", true)
	var handled_photo_log: bool = _im._handle_declared_interaction(photo_decl)
	_assert("dinner_photo handled for conditional precedence", handled_photo_log)
	_assert("dinner_photo log truth overrides thread flavor", "This photo was taken that night" in _get_document_content())
	_ui.hide_document()

	var chair_decl: InteractableDecl = _find_decl("pushed_chair")
	_assert("pushed_chair declaration found", chair_decl != null)
	if chair_decl != null:
		var handled_chair: bool = _im._handle_declared_interaction(chair_decl)
		_assert("pushed_chair handled", handled_chair)
		_assert("pushed_chair text", "left mid-course -- or was taken" in _get_document_content())
		_ui.hide_document()


func _test_dining_wine_glass_visual_states() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "")
	_rm.load_room("dining_room")
	await process_frame
	var wine_area := _find_interactable_area("wine_glass")
	_assert("dining wine area found", wine_area != null)
	if wine_area == null:
		return
	_assert("dining wine starts still", String(wine_area.get_meta("visual_state")) == "still")
	var decl: InteractableDecl = _find_decl("wine_glass")
	_assert("wine_glass declaration found", decl != null)
	if decl == null:
		return
	var handled_first: bool = _im._handle_declared_interaction(decl)
	_assert("wine_glass first interaction handled", handled_first)
	await process_frame
	_assert("dining wine state set", _gm.get_state("examined_wine_glass", false) == true)
	_assert("dining wine agitates after inspection", String(wine_area.get_meta("visual_state")) == "agitated")
	_assert("dining wine default text", "still full" in _get_document_content())
	_ui.hide_document()
	_gm.set_state("macro_thread", "sovereign")
	var handled_second: bool = _im._handle_declared_interaction(decl)
	_assert("wine_glass second interaction handled", handled_second)
	await process_frame
	_assert("dining wine stays agitated", String(wine_area.get_meta("visual_state")) == "agitated")
	_assert("dining wine sovereign text", "heartbeat" in _get_document_content())
	_ui.hide_document()


func _test_kitchen_core_interactions() -> void:
	_gm.new_game()
	_gm.set_state("visited_kitchen", false)
	_gm.set_state("kitchen_service_descent_triggered", false)
	_gm.set_state("read_cook_note", false)
	_gm.remove_item("cellar_key")
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("kitchen_first_entry")
	_rm.load_room("kitchen")
	_assert("kitchen first-entry text", "less abandoned than interrupted" in _get_document_content())
	_ui.hide_document()

	var note_decl: InteractableDecl = _find_decl("kitchen_note")
	_assert("kitchen_note declaration found", note_decl != null)
	if note_decl != null:
		_gm.set_state("macro_thread", "captive")
		var handled_note: bool = _im._handle_declared_interaction(note_decl)
		_assert("kitchen_note handled", handled_note)
		_assert("kitchen_note state set", _gm.get_state("read_cook_note", false) == true)
		_assert("kitchen_note captive text", "rats whisper NAMES" in _get_document_content())
		_ui.hide_document()

	var hearth_decl: InteractableDecl = _find_decl("kitchen_hearth")
	_assert("kitchen_hearth declaration found", hearth_decl != null)
	if hearth_decl != null:
		_gm.set_state("macro_thread", "")
		var handled_hearth_first: bool = _im._handle_declared_interaction(hearth_decl)
		_assert("kitchen_hearth first interaction handled", handled_hearth_first)
		_assert("kitchen_hearth first pass sets loose flag", _gm.get_state("examined_hearth_loose", false) == true)
		_assert("kitchen_hearth first text", "one is slightly raised" in _get_document_content())
		_ui.hide_document()

		var handled_hearth_second: bool = _im._handle_declared_interaction(hearth_decl)
		_assert("kitchen_hearth second interaction handled", handled_hearth_second)
		_assert("kitchen_hearth yields cellar key", _gm.has_item("cellar_key"))
		_assert("kitchen_hearth second text", "cook hid the spare key" in _get_document_content())
		_ui.hide_document()


func _test_kitchen_service_descent_trigger() -> void:
	_gm.new_game()
	_gm.set_state("kitchen_service_descent_triggered", false)
	_gm.set_state("storage_basement_fall_landing_pending", false)
	_gm.set_state("visited_storage_basement", false)
	_gm.set_state("parlor_fire_lit", false)
	_gm.set_state("current_light_tool", "")
	_gm.remove_item("firebrand")
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("storage_basement_forced_fall_entry")
		_room_events._trigger_engine._fired_triggers.erase("storage_basement_first_entry")
		_room_events._trigger_engine._fired_triggers.erase("parlor_first_entry")
	_rm.load_room("kitchen")
	_im._on_door_tapped("storage_basement", "kitchen_to_storage_basement")
	_assert("kitchen service hatch blocks before firebrand", "service hatch is cut into the kitchen floor" in _get_document_content())
	_assert("kitchen remains active before firebrand", _rm.get_current_room_id() == "kitchen")
	_ui.hide_document()

	_rm.load_room("parlor")
	var hearth_decl: InteractableDecl = _find_decl("parlor_fireplace")
	_assert("parlor_fireplace declaration found for descent trigger", hearth_decl != null)
	if hearth_decl == null:
		return
	_im._on_interacted("parlor_fireplace", hearth_decl.type, {})
	await create_timer(0.2).timeout
	_assert("parlor firebrand acquired for descent trigger", _gm.has_item("firebrand"))

	_rm.load_room("kitchen")
	for _i in range(20):
		if not _rm.get("_is_transitioning"):
			break
		await create_timer(0.1).timeout
	_im._on_door_tapped("storage_basement", "kitchen_to_storage_basement")
	var reached_basement: bool = false
	for _i in range(40):
		await create_timer(0.1).timeout
		if _rm.get_current_room_id() == "storage_basement":
			reached_basement = true
			break
	_assert("kitchen service descent reaches storage basement", reached_basement and _rm.get_current_room_id() == "storage_basement")
	_assert("kitchen service descent sets elizabeth awareness", _gm.get_state("elizabeth_aware", false) == true)
	_assert("kitchen service descent records seizure", _gm.get_state("kitchen_service_descent_triggered", false) == true)
	_assert("kitchen service descent consumes firebrand", not _gm.has_item("firebrand"))
	_assert("kitchen service descent clears current light tool", _gm.get_state("current_light_tool", "") == "")
	_assert("storage basement landing text references oily rags", "old oily rags" in _get_document_content())
	_ui.hide_document()


func _test_parlor_first_warmth_firebrand() -> void:
	_gm.new_game()
	_gm.set_state("parlor_fire_lit", false)
	_gm.set_state("current_light_tool", "")
	_gm.remove_item("firebrand")
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("parlor_first_entry")
	_rm.load_room("parlor")
	var hearth_decl: InteractableDecl = _find_decl("parlor_fireplace")
	_assert("parlor_fireplace declaration found", hearth_decl != null)
	if hearth_decl == null:
		return
	_im._on_interacted("parlor_fireplace", hearth_decl.type, {})
	await create_timer(0.4).timeout
	_assert("parlor fire lights state", _gm.get_state("parlor_fire_lit", false) == true)
	_assert("parlor fire grants firebrand", _gm.has_item("firebrand"))
	_assert("parlor fire sets current light tool", _gm.get_state("current_light_tool", "") == "firebrand")
	_assert("parlor fire text", "draw a burning brand free" in _get_document_content())
	var room = _rm.get_current_room()
	var fireplace_base: float = -1.0
	if room != null and room.has_method("get_light_base_energy"):
		fireplace_base = room.get_light_base_energy("parlor_fireplace_light")
	_assert("parlor fire light wakes with the hearth", fireplace_base > 1.2)
	_ui.hide_document()


func _test_kitchen_bucket_visual_states() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "")
	_rm.load_room("kitchen")
	await process_frame
	var bucket_area := _find_interactable_area("kitchen_bucket")
	_assert("kitchen bucket area found", bucket_area != null)
	if bucket_area == null:
		return
	_assert("kitchen bucket starts still", String(bucket_area.get_meta("visual_state")) == "still")
	var decl: InteractableDecl = _find_decl("kitchen_bucket")
	_assert("kitchen_bucket declaration found", decl != null)
	if decl == null:
		return
	var handled_first: bool = _im._handle_declared_interaction(decl)
	_assert("kitchen_bucket first interaction handled", handled_first)
	await process_frame
	_assert("kitchen bucket state set", _gm.get_state("examined_kitchen_bucket", false) == true)
	_assert("kitchen bucket ripples after inspection", String(bucket_area.get_meta("visual_state")) == "rippled")
	_assert("kitchen bucket default text", "half-full of water" in _get_document_content())
	_ui.hide_document()
	var handled_second: bool = _im._handle_declared_interaction(decl)
	_assert("kitchen_bucket second interaction handled", handled_second)
	await process_frame
	_assert("kitchen bucket keeps rippled visual", String(bucket_area.get_meta("visual_state")) == "rippled")
	_assert("kitchen bucket second text", "shivers before your fingers reach the rim" in _get_document_content())
	_ui.hide_document()


func _test_chapel_font_visual_states() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "")
	_rm.load_room("chapel")
	await process_frame
	var font_area := _find_interactable_area("baptismal_font")
	_assert("chapel font area found", font_area != null)
	if font_area == null:
		return
	_assert("chapel font starts still", String(font_area.get_meta("visual_state")) == "still")
	var decl: InteractableDecl = _find_decl("baptismal_font")
	_assert("baptismal_font declaration found", decl != null)
	if decl == null:
		return
	var handled_first: bool = _im._handle_declared_interaction(decl)
	_assert("baptismal_font first interaction handled", handled_first)
	await process_frame
	_assert("chapel font grants blessed water", _gm.has_item("blessed_water"))
	_assert("chapel font disturbed after first touch", String(font_area.get_meta("visual_state")) == "disturbed")
	var handled_second: bool = _im._handle_declared_interaction(decl)
	_assert("baptismal_font second interaction handled", handled_second)
	await process_frame
	_assert("chapel font searched after key recovery", _gm.get_state("found_gate_key_font", false) == true)
	_assert("chapel font searched visual", String(font_area.get_meta("visual_state")) == "searched")
	_ui.hide_document()


func _test_boiler_room_core_interactions() -> void:
	_gm.new_game()
	_gm.set_state("macro_thread", "")
	_gm.set_state("visited_boiler_room", false)
	_gm.set_state("read_maintenance_log", false)
	_gm.set_state("knows_staff_afraid", false)
	_gm.set_state("examined_boiler_clock", false)
	_gm.set_state("gas_restored", false)
	_gm.set_state("basement_relight", true)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("boiler_room_first_entry")
	_rm.load_room("boiler_room")
	_assert("boiler_room first-entry text", "Iron and coal dust" in _get_document_content())
	_ui.hide_document()

	var log_decl: InteractableDecl = _find_decl("maintenance_log")
	_assert("maintenance_log declaration found", log_decl != null)
	if log_decl != null:
		var handled_log: bool = _im._handle_declared_interaction(log_decl)
		_assert("maintenance_log handled", handled_log)
		_assert("maintenance_log state set", _gm.get_state("read_maintenance_log", false) == true)
		_assert("maintenance_log fear state set", _gm.get_state("knows_staff_afraid", false) == true)
		_assert("maintenance_log text", "I am the last one willing to come down here alone" in _get_document_content())
		_ui.hide_document()

	var clock_decl: InteractableDecl = _find_decl("boiler_clock")
	_assert("boiler_clock declaration found", clock_decl != null)
	if clock_decl != null:
		var handled_clock: bool = _im._handle_declared_interaction(clock_decl)
		_assert("boiler_clock handled", handled_clock)
		_assert("boiler_clock state set", _gm.get_state("examined_boiler_clock", false) == true)
		_assert("boiler_clock text", "3:33" in _get_document_content())
		_ui.hide_document()

	var gas_decl: InteractableDecl = _find_decl("gas_restore")
	_assert("gas_restore declaration found", gas_decl != null)
	if gas_decl != null:
		var handled_gas: bool = _im._handle_declared_interaction(gas_decl)
		_assert("gas_restore handled", handled_gas)
		_assert("gas_restored state set", _gm.get_state("gas_restored", false) == true)
		_assert("basement_lights_awake state set", _gm.get_state("basement_lights_awake", false) == true)
		_assert("bad_air cleared", _gm.get_state("bad_air_active", false) == false)
		_assert("gas_restore text", "mains still hold" in _get_document_content())
		_ui.hide_document()


func _test_boiler_room_walking_cane() -> void:
	_gm.new_game()
	_gm.set_state("visited_boiler_room", true)
	_gm.set_state("gas_restored", false)
	_gm.set_state("walking_stick_phase", false)
	_gm.set_state("current_light_tool", "firebrand")
	_gm.set_state("basement_relight", true)
	_rm.load_room("boiler_room")

	var cane_decl: InteractableDecl = _find_decl("walking_cane")
	_assert("walking_cane declaration found", cane_decl != null)
	if cane_decl == null:
		return

	var handled_blocked: bool = _im._handle_declared_interaction(cane_decl)
	_assert("walking_cane blocked before gas restore", handled_blocked)
	_assert("walking_cane blocked text", "more urgent work" in _get_document_content())
	_assert("walking_stick_phase still false", _gm.get_state("walking_stick_phase", false) == false)
	_ui.hide_document()

	_gm.set_state("gas_restored", true)
	var handled_take: bool = _im._handle_declared_interaction(cane_decl)
	_assert("walking_cane taken after gas restore", handled_take)
	_assert("walking_stick_phase set", _gm.get_state("walking_stick_phase", false) == true)
	_assert("current_light_tool is walking_stick", _gm.get_state("current_light_tool", "") == "walking_stick")
	_assert("walking_cane gives item", _gm.has_item("walking_cane"))
	_assert("walking_cane text", "steadier, deliberate" in _get_document_content())
	_ui.hide_document()


func _test_kitchen_service_return() -> void:
	_gm.new_game()
	_gm.set_state("visited_kitchen", true)
	_gm.set_state("gas_restored", true)
	_gm.set_state("stable_house_light", false)
	_gm.set_state("walking_stick_phase", true)
	_gm.set_state("service_hatch_propped", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("kitchen_service_return")
	_rm.load_room("kitchen")
	_assert("kitchen service return sets stable_house_light", _gm.get_state("stable_house_light", false) == true)
	_assert("kitchen service return text", "mansion is lit" in _get_document_content())
	_ui.hide_document()

	var hatch_decl: InteractableDecl = _find_decl("service_hatch_prop")
	_assert("service_hatch_prop declaration found", hatch_decl != null)
	if hatch_decl == null:
		return

	var handled_prop: bool = _im._handle_declared_interaction(hatch_decl)
	_assert("service_hatch_prop handled", handled_prop)
	_assert("service_hatch_propped set", _gm.get_state("service_hatch_propped", false) == true)
	_assert("service_hatch_prop text", "iron tip under the frame" in _get_document_content())
	_ui.hide_document()


func _test_attic_stairs_lantern_hook() -> void:
	_gm.new_game()
	_gm.set_state("entered_attic", true)
	_gm.set_state("walking_stick_phase", true)
	_gm.set_state("late_darkness_active", false)
	_gm.set_state("lantern_hook_phase", false)
	_rm.load_room("attic_stairs")

	var hook_decl: InteractableDecl = _find_decl("lantern_hook")
	_assert("lantern_hook declaration found", hook_decl != null)
	if hook_decl == null:
		return

	# Before late darkness: should not allow pickup
	var handled_no_dark: bool = _im._handle_declared_interaction(hook_decl)
	_assert("lantern_hook handled before darkness", handled_no_dark)
	_assert("lantern_hook not taken before darkness", _gm.get_state("lantern_hook_phase", false) == false)
	_assert("lantern_hook pre-dark text", "no reason to take it" in _get_document_content())
	_ui.hide_document()

	# With late darkness: should allow pickup
	_gm.set_state("late_darkness_active", true)
	var handled_dark: bool = _im._handle_declared_interaction(hook_decl)
	_assert("lantern_hook handled with darkness", handled_dark)
	_assert("lantern_hook_phase set", _gm.get_state("lantern_hook_phase", false) == true)
	_assert("lantern_hook gives item", _gm.has_item("lantern_hook"))
	_assert("lantern_hook text", "steadier than the cane" in _get_document_content())
	_ui.hide_document()

	# Already taken: should show taken text
	var handled_taken: bool = _im._handle_declared_interaction(hook_decl)
	_assert("lantern_hook handled when taken", handled_taken)
	_assert("lantern_hook taken text", "bracket is empty" in _get_document_content())
	_ui.hide_document()


func _test_attic_music_box_adult_resolution() -> void:
	_gm.new_game()
	_gm.set_state("entered_attic", true)
	_gm.set_state("late_darkness_active", true)
	_gm.set_state("lantern_hook_phase", false)
	_gm.set_state("attic_music_box_wound", false)
	_rm.load_room("attic_storage")

	var box_decl: InteractableDecl = _find_decl("attic_music_box")
	_assert("attic_music_box declaration found", box_decl != null)
	if box_decl == null:
		return

	# Without lantern: should block
	var handled_no_lantern: bool = _im._handle_declared_interaction(box_decl)
	_assert("music_box handled without lantern", handled_no_lantern)
	_assert("music_box blocked without lantern", _gm.get_state("attic_music_box_wound", false) == false)
	_assert("music_box no-lantern text", "cannot see the keyhole" in _get_document_content())
	_ui.hide_document()

	# With lantern but no key: should block
	_gm.set_state("lantern_hook_phase", true)
	_gm.remove_item("music_box_winding_key")
	_gm.flags.erase("has_music_box_winding_key")
	var handled_no_key: bool = _im._handle_declared_interaction(box_decl)
	_assert("music_box handled without key", handled_no_key)
	_assert("music_box blocked without key", _gm.get_state("attic_music_box_wound", false) == false)
	_assert("music_box no-key text", "need the key" in _get_document_content())
	_ui.hide_document()

	# With lantern and key: should complete
	_gm.give_item("music_box_winding_key")
	var handled_solve: bool = _im._handle_declared_interaction(box_decl)
	_assert("music_box handled for solve", handled_solve)
	_assert("attic_music_box_wound set", _gm.get_state("attic_music_box_wound", false) == true)
	_assert("adult_route_complete set", _gm.get_state("adult_route_complete", false) == true)
	_assert("music_box solve text", "waltz" in _get_document_content())
	_ui.hide_document()

	# Already wound: should show completion text
	var handled_done: bool = _im._handle_declared_interaction(box_decl)
	_assert("music_box handled when wound", handled_done)
	_assert("music_box wound text", "plays on" in _get_document_content())
	_ui.hide_document()


func _test_wine_cellar_core_interactions() -> void:
	_gm.new_game()
	_gm.set_state("visited_wine_cellar", false)
	_gm.set_state("reached_deepest", false)
	_gm.set_state("read_wine_note", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("wine_cellar_first_entry")
	_rm.load_room("wine_cellar")
	_assert("wine_cellar reached deepest state", _gm.get_state("reached_deepest", false) == true)
	_assert("wine_cellar first-entry text", "daylight feels theoretical" in _get_document_content())
	_ui.hide_document()

	var note_decl: InteractableDecl = _find_decl("wine_note")
	_assert("wine_note declaration found", note_decl != null)
	if note_decl != null:
		var handled_note: bool = _im._handle_declared_interaction(note_decl)
		_assert("wine_note handled", handled_note)
		_assert("wine_note state set", _gm.get_state("read_wine_note", false) == true)
		_assert("wine_note text", "NOT wine -- do not open" in _get_document_content())
		_ui.hide_document()

	var racks_decl: InteractableDecl = _find_decl("wine_racks")
	_assert("wine_racks declaration found", racks_decl != null)
	if racks_decl != null:
		var handled_racks: bool = _im._handle_declared_interaction(racks_decl)
		_assert("wine_racks handled", handled_racks)
		_assert("wine_racks text", "removed long after the house died" in _get_document_content())
		_ui.hide_document()

	var footprints_decl: InteractableDecl = _find_decl("wine_footprints")
	_assert("wine_footprints declaration found", footprints_decl != null)
	if footprints_decl != null:
		var handled_footprints: bool = _im._handle_declared_interaction(footprints_decl)
		_assert("wine_footprints handled", handled_footprints)
		_assert("wine_footprints text", "did not leave by any route you can see" in _get_document_content())
		_ui.hide_document()


func _test_library_key_and_book_path() -> void:
	_gm.new_game()
	_gm.set_state("read_ashworth_diary", true)
	_rm.load_room("library")
	var book_decl: InteractableDecl = _find_decl("binding_book")
	_assert("binding_book declaration found", book_decl != null)
	if book_decl == null:
		return
	var handled_book: bool = _im._handle_declared_interaction(book_decl)
	_assert("binding_book handled", handled_book)
	_assert("binding_book title", _get_document_title() == "Rites of Passage")
	_assert("binding_book granted", _gm.has_item("binding_book"))
	_assert("binding_book state set", _gm.get_state("examined_binding_book", false) == true)
	_ui.hide_document()

	var globe_decl: InteractableDecl = _find_decl("library_globe")
	_assert("library_globe declaration found", globe_decl != null)
	if globe_decl == null:
		return
	var handled_globe: bool = _im._handle_declared_interaction(globe_decl)
	_assert("library_globe handled", handled_globe)
	_assert("library_globe title", _get_document_title() == "Globe")
	_assert("library_globe attic key granted", _gm.has_item("attic_key"))
	_assert("library_globe state set", _gm.get_state("found_attic_key_globe", false) == true)
	_ui.hide_document()


func _test_guest_room_core_interactions() -> void:
	_gm.new_game()
	_gm.set_state("visited_guest_room", false)
	_gm.set_state("knows_full_truth", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("guest_room_first_entry")
	_rm.load_room("guest_room")
	_assert("guest_room first-entry text", "departure stopped being possible" in _get_document_content())
	_ui.hide_document()

	var photo_decl: InteractableDecl = _find_decl("helena_photo")
	_assert("helena_photo declaration found", photo_decl != null)
	if photo_decl != null:
		var handled_photo_default: bool = _im._handle_declared_interaction(photo_decl)
		_assert("helena_photo default handled", handled_photo_default)
		_assert("helena_photo default text", "corrected that assumption" in _get_document_content())
		_ui.hide_document()

		_gm.set_state("knows_full_truth", true)
		var handled_photo_truth: bool = _im._handle_declared_interaction(photo_decl)
		_assert("helena_photo truth handled", handled_photo_truth)
		_assert("helena_photo truth text", "subjects to be studied instead of mouths that close" in _get_document_content())
		_ui.hide_document()


func _test_hidden_chamber_core_interactions() -> void:
	_gm.new_game()
	_gm.set_state("found_hidden_chamber", false)
	_gm.set_state("visited_hidden_chamber", false)
	_gm.set_state("read_final_note", false)
	_gm.set_state("knows_full_truth", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("chamber_first_entry")
	_rm.load_room("hidden_chamber")
	_assert("hidden_chamber first-entry text", "It does not feel discovered. It feels admitted." in _get_document_content())
	_ui.hide_document()

	var note_decl: InteractableDecl = _find_decl("elizabeth_final_note")
	_assert("elizabeth_final_note declaration found", note_decl != null)
	if note_decl != null:
		_gm.set_state("macro_thread", "mourning")
		var handled_note: bool = _im._handle_declared_interaction(note_decl)
		_assert("elizabeth_final_note handled", handled_note)
		_assert("elizabeth_final_note sets read_final_note", _gm.get_state("read_final_note", false) == true)
		_assert("elizabeth_final_note sets knows_full_truth", _gm.get_state("knows_full_truth", false) == true)
		_assert("elizabeth_final_note mourning text", "Some things cannot be fixed. They can only be mourned." in _get_document_content())
		_ui.hide_document()


func _test_library_binding_aftershock() -> void:
	_gm.new_game()
	_gm.give_item("binding_book")
	_gm.set_state("library_flashback_triggered", false)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("library_binding_aftershock")
	_rm.load_room("library")
	if _room_events != null and _room_events.has_method("_run_room_conditional_events"):
		_room_events._run_room_conditional_events()
	_assert("library aftershock flag set", _gm.get_state("library_flashback_triggered", false) == true)
	await create_timer(1.5).timeout
	var room = _rm.get_current_room()
	var lamp_base: float = -1.0
	if room != null and room.has_method("get_light_base_energy"):
		lamp_base = room.get_light_base_energy("library_desk_lamp")
	_assert("library desk lamp dims for aftershock", lamp_base > 0.0 and lamp_base < 0.8)
	var aftershock_shown := false
	for _i in range(12):
		await create_timer(0.2).timeout
		if "occultist reading across the desk" in _get_document_content():
			aftershock_shown = true
			break
	_assert("library aftershock text shown", aftershock_shown)
	_ui.hide_document()
	await create_timer(6.3).timeout
	if room != null and room.has_method("get_light_base_energy"):
		lamp_base = room.get_light_base_energy("library_desk_lamp")
	_assert("library desk lamp restores after aftershock", lamp_base > 1.0)


func _test_parlor_music_box_auto_event() -> void:
	_gm.new_game()
	_gm.set_state("elizabeth_aware", true)
	_gm.set_state("visited_attic_storage", true)
	_gm.set_state("music_box_auto_triggered", false)
	_gm.set_state("parlor_fire_lit", true)
	if _room_events != null and "_trigger_engine" in _room_events and _room_events._trigger_engine != null:
		_room_events._trigger_engine._fired_triggers.erase("music_box_auto_play")
	_rm.load_room("parlor")
	if _room_events != null and _room_events.has_method("_run_room_conditional_events"):
		_room_events._run_room_conditional_events()
	_assert("parlor music box auto flag set", _gm.get_state("music_box_auto_triggered", false) == true)
	await create_timer(3.2).timeout
	var room = _rm.get_current_room()
	var fireplace_base: float = -1.0
	if room != null and room.has_method("get_light_base_energy"):
		fireplace_base = room.get_light_base_energy("parlor_fireplace_light")
	_assert("parlor fireplace dims during music box event", fireplace_base > 0.0 and fireplace_base < 0.8)
	await create_timer(5.4).timeout
	if room != null and room.has_method("get_light_base_energy"):
		fireplace_base = room.get_light_base_energy("parlor_fireplace_light")
	_assert("parlor fireplace restores after music box event", fireplace_base > 1.2)


func _find_decl(interactable_id: String) -> InteractableDecl:
	var room = _rm.get_current_room()
	if room == null or not room.has_method("get_interactables"):
		return null
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == interactable_id:
			var decl = area.get_meta("declaration") if area.has_meta("declaration") else null
			if decl is InteractableDecl:
				return decl
	return null


func _find_interactable_area(interactable_id: String) -> Area3D:
	var room = _rm.get_current_room()
	if room == null or not room.has_method("get_interactables"):
		return null
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == interactable_id:
			return area as Area3D
	return null


func _find_connection_root(connection_id: String) -> Node3D:
	var room = _rm.get_current_room()
	if room == null or not room.has_method("get_connections"):
		return null
	for area in room.get_connections():
		if area.has_meta("connection_id") and area.get_meta("connection_id") == connection_id:
			return area.get_parent() as Node3D
	return null


func _get_document_title() -> String:
	var doc := _find(_ui, "DocumentOverlay")
	var title = doc.get("_doc_title") if doc != null else null
	if title is Label:
		return (title as Label).text
	return ""


func _get_document_content() -> String:
	var doc := _find(_ui, "DocumentOverlay")
	var content = doc.get("_doc_content") if doc != null else null
	if content is RichTextLabel:
		return (content as RichTextLabel).text
	return ""


func _assert(name: String, condition: bool) -> void:
	if condition:
		_pass_count += 1
	else:
		_fail_count += 1
		print("[FAIL] %s" % name)


func _finish() -> void:
	call_deferred("_complete_finish")


func _complete_finish() -> void:
	var audio := _find(_main, "AudioManager")
	if audio != null and audio.has_method("shutdown"):
		audio.shutdown()
		await process_frame
		await process_frame
	if audio != null:
		if is_instance_valid(audio):
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
	print("DECLARED INTERACTIONS: %d passed, %d failed" % [_pass_count, _fail_count])
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
