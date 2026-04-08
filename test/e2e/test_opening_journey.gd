extends SceneTree
## Focused opening-sequence acceptance for the diegetic front-gate start.
## Run: godot --path . --script test/e2e/test_opening_journey.gd
## Output: user://screenshots/opening_journey/*.png when renderer is available.

var _main: Node = null
var _rm: Node = null
var _im: Node = null
var _ui: Control = null
var _gm: Node = null
var _player: Node3D = null
var _player_camera: Camera3D = null
var _capture_enabled: bool = true
var _screenshot_dir := "user://screenshots/opening_journey/"
var _pass_count: int = 0
var _fail_count: int = 0
var _manifest: PackedStringArray = []
var _capture_manifest: Array[Dictionary] = []

var Q_GATE_OVERVIEW := PackedStringArray([
	"Does this first frame read as a burden-estate arrival rather than a menu scene?",
	"Is the sign assembly legible as one estate signpost rather than unrelated boards or slabs?",
	"Is the valise clearly placed beneath the sign by a departing driver?",
	"Does the drive feel available for click-to-walk without forcing the player toward a single hotspot?"
])

var Q_GATE_SIGN_CLOSE := PackedStringArray([
	"Can the player read the estate sign and the hanging-board hierarchy from this angle?",
	"Does the sign feel like a plausible Victorian estate marker with attached notices rather than a game menu prop?",
	"Is the sign close enough to inspect without swallowing the drive composition?"
])

var Q_GATE_OUTWARD := PackedStringArray([
	"If the player pivots away from the estate, is the carriage road and outside world legible in the foggy twilight distance?",
	"Does this angle confirm the player begins outside the wall rather than already trapped inside the drive corridor?",
	"Do road, wall, sign, and valise together tell a socially coherent arrival story?"
])

var Q_VALISE_CLOSE := PackedStringArray([
	"Does the valise feel like the player's luggage rather than random set dressing?",
	"Is it visually obvious that the packet and key-bearing contents come from inside this object?",
	"Does opening the case still preserve the dignity of the threshold rather than turning into loot presentation?"
])

var Q_DOCUMENT_REASON := PackedStringArray([
	"Does the document overlay feel motivated by the lack of anyone present to receive the heir?",
	"Can the player still understand where they are standing while the papers are reviewed?",
	"Does this read as confirmation of locale and duty rather than a menu interruption?"
])

var Q_DRIVE_PULL := PackedStringArray([
	"Does the view imply the next action diegetically through composition, distance, and light?",
	"Can the player trust click-anywhere movement here without feeling railroaded to a hotspot?",
	"Is the path legible as a ceremonial estate approach rather than a debug corridor?"
])

var Q_HEDGE_WALL := PackedStringArray([
	"Do the side masses read specifically as clipped estate hedges rather than black boxes or generic walls?",
	"Is there enough top silhouette, face variation, and color separation to sell hedge craft?",
	"Do the hedges frame movement while still feeling like landscape rather than level geometry?"
])

var Q_FRONT_STEPS := PackedStringArray([
	"Does the forecourt feel like the first place where the estate opens laterally?",
	"Are the side-gate promises legible without overpowering the front-door obligation?",
	"Does the house facade feel like a real threshold rather than a flat placeholder pull?"
])

var Q_FOYER_DARK := PackedStringArray([
	"Does the foyer feel intentionally unlit and unwelcoming rather than unfinished?",
	"Is the player invited to reclaim the space rather than simply observe darkness?",
	"Do the stairs and adjacent rooms feel available as spatial promises without visual confusion?"
])

var Q_PARLOR_WARMTH := PackedStringArray([
	"Does the first reclaimed warmth feel like occupation of a family room rather than an arbitrary light puzzle?",
	"Is the firebrand phase visually grounded in a believable source of flame?",
	"Does the room still feel melancholic and cold beyond the hearth circle?"
])

var Q_KITCHEN_SERVICE := PackedStringArray([
	"Does the kitchen read as a lived service room rather than a puzzle chamber?",
	"Is the service-side architecture legible enough that a later descent feels authored?",
	"Does the room support free movement and inspection without over-signposting the next event?"
])

var Q_BASEMENT_FALL := PackedStringArray([
	"Does the fall aftermath communicate consequence, disorientation, and service-world truth?",
	"Is the player clearly no longer in the respectable front-house layer?",
	"Does the frame suggest pressure and survival rather than a random teleport?"
])


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(_screenshot_dir)
	_capture_enabled = DisplayServer.get_name() != "headless"
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_im = _find(_main, "InteractionManager")
	_ui = _find(_main, "UIOverlay") as Control
	_player = _find(_main, "PlayerController") as Node3D
	_player_camera = _find_camera(_main)
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	_assert("opening GameManager found", _gm != null)
	_assert("opening RoomManager found", _rm != null)
	_assert("opening InteractionManager found", _im != null)
	_assert("opening PlayerController found", _player != null)
	if _gm == null or _rm == null or _im == null or _player == null:
		_finish()
		return

	_disable_nonessential_runtime_systems()
	_clear_save_data()
	_gm.new_game()
	_rm.load_room("front_gate")
	await _settle()
	_assert("opening starts at front_gate", _rm.get_current_room_id() == "front_gate")
	await _capture_review(
		"00_gate_menu",
		"First arrival overview: burden-estate threshold, sign, valise, and open drive in one frame.",
		Q_GATE_OVERVIEW
	)
	await _stage_pose(
		"00_gate_outward_road",
		Vector3(1.8, 0, -7.6),
		10.0,
		-1.0,
		"Pivot outward from the gate to judge road visibility, twilight openness, and the outside-world read.",
		Q_GATE_OUTWARD
	)
	await _stage_pose(
		"00_gate_sign_focus",
		Vector3(-2.2, 0, -4.7),
		154.0,
		-2.0,
		"Closer three-quarter study of the sign assembly as an estate marker and menu surface.",
		Q_GATE_SIGN_CLOSE
	)

	var new_game_decl := _find_decl("gate_sign_new_game")
	_assert("opening new-game sign exists", new_game_decl != null)
	if new_game_decl == null:
		_finish()
		return
	_im._on_interacted("gate_sign_new_game", new_game_decl.type, {})
	await _settle()
	_assert("opening new-game selection stored", _gm.get_state("front_gate_menu_selection", "") == "new_game")
	_assert("opening sign does not force packet presentation", _gm.get_state("front_gate_packet_presented", false) == false)
	_assert("opening sign gives arrival prompt", "No one to receive me" in _get_document_content())
	await _capture_review(
		"01_packet_open",
		"Arrival-prompt overlay proving why the player re-checks papers at the gate.",
		Q_DOCUMENT_REASON
	)
	_ui.hide_document()
	await _settle()

	var valise_decl := _find_decl("gate_luggage")
	_assert("opening valise exists", valise_decl != null)
	if valise_decl == null:
		_finish()
		return
	_im._on_interacted("gate_luggage", valise_decl.type, {})
	await _settle()
	_assert("opening threshold committed from valise", _gm.get_state("front_gate_threshold_acknowledged", false) == true)
	_assert("opening valise presents the packet", _gm.get_state("front_gate_packet_presented", false) == true)
	_assert("opening valise packet contains the caretaker notice", "final acting caretaker" in _get_document_content())
	_assert("opening inventory gets solicitor packet", _gm.has_item("solicitor_packet"))
	_assert("opening inventory gets front door key", _gm.has_item("front_door_key"))
	_assert("opening inventory gets winding key", _gm.has_item("music_box_winding_key"))
	await _stage_pose(
		"02_valise_opened",
		Vector3(-2.9, 0, -4.24),
		132.0,
		-14.0,
		"Valise opened at the threshold: packet and first carried effects become embodied inventory.",
		Q_VALISE_CLOSE
	)
	_ui.hide_document()

	await _stage_pose(
		"03_gate_threshold",
		Vector3(0.0, 0, -7.4),
		180.0,
		0.0,
		"Committed threshold view from the gate into the ceremonial drive.",
		Q_DRIVE_PULL
	)

	_im._on_door_tapped("drive_lower", "front_gate_to_drive_lower")
	var reached_drive_lower := await _await_room_id("drive_lower", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening reaches drive_lower", reached_drive_lower and _rm.get_current_room_id() == "drive_lower")
	await _capture_review(
		"04_drive_lower_entry",
		"Lower-drive arrival: the approach should read as a dignified funnel, not a corridor placeholder.",
		Q_DRIVE_PULL
	)
	await _stage_pose(
		"04_drive_lower_hedge_left",
		Vector3(-0.8, 0, -0.4),
		126.0,
		-2.0,
		"Side read on the lower-drive hedge wall to judge clipped-landscape believability.",
		Q_HEDGE_WALL
	)
	await _stage_pose(
		"05_drive_lower_commit",
		Vector3(0, 0, 0.6),
		180.0,
		0.0,
		"Forward commitment shot showing whether the player knows to keep walking without coercion.",
		Q_DRIVE_PULL
	)

	_im._on_door_tapped("drive_upper", "drive_lower_to_drive_upper")
	var reached_drive_upper := await _await_room_id("drive_upper", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening reaches drive_upper", reached_drive_upper and _rm.get_current_room_id() == "drive_upper")
	await _capture_review(
		"06_drive_upper_entry",
		"Upper-drive reveal: the mansion should begin to pull the eye without losing hedge discipline.",
		Q_DRIVE_PULL
	)
	await _stage_pose(
		"06_drive_upper_house_pull",
		Vector3(0, 0, 1.0),
		180.0,
		-1.0,
		"Upper-drive commitment shot for house pull, forecourt promise, and path clarity.",
		Q_DRIVE_PULL
	)
	await _stage_pose(
		"06_drive_upper_hedge_right",
		Vector3(0.9, 0, 0.3),
		236.0,
		-2.0,
		"Upper-drive hedge read from the opposite side to check silhouette and massing balance.",
		Q_HEDGE_WALL
	)
	await _stage_pose(
		"07_drive_upper_commit",
		Vector3(0, 0, 1.6),
		180.0,
		0.0,
		"Final approach before the forecourt opens.",
		Q_DRIVE_PULL
	)

	_im._on_door_tapped("front_steps", "drive_upper_to_front_steps")
	var reached_front_steps := await _await_room_id("front_steps", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening reaches front_steps", reached_front_steps and _rm.get_current_room_id() == "front_steps")
	_assert("opening forecourt has service-side gate", _find_decl("front_steps_service_gate") != null)
	_assert("opening forecourt has garden-side gate", _find_decl("front_steps_garden_gate") != null)
	await _capture_review(
		"08_front_steps_entry",
		"Forecourt arrival and side-gate reveal beneath the dark facade.",
		Q_FRONT_STEPS
	)
	await _stage_pose(
		"08_front_steps_lateral",
		Vector3(0.2, 0, -0.2),
		202.0,
		-1.0,
		"Forecourt lateral read to judge whether the side grounds become legible promises.",
		Q_FRONT_STEPS
	)
	await _stage_pose(
		"09_front_steps_commit",
		Vector3(0, 0, -0.8),
		180.0,
		0.0,
		"Front-door commitment shot from the forecourt centerline.",
		Q_FRONT_STEPS
	)

	_im._on_door_tapped("foyer", "front_steps_to_foyer")
	var reached_foyer := await _await_room_id("foyer", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening reaches foyer", reached_foyer and _rm.get_current_room_id() == "foyer")
	var foyer_room = _rm.get_current_room()
	var foyer_chandelier_base: float = -1.0
	if foyer_room != null and foyer_room.has_method("get_light_base_energy"):
		foyer_chandelier_base = foyer_room.get_light_base_energy("foyer_chandelier")
	_assert("opening foyer chandelier stays dark on first route", foyer_chandelier_base >= 0.0 and foyer_chandelier_base < 0.2)
	if _rm.has_method("get_visible_compiled_world_room_ids"):
		var visible_rooms: PackedStringArray = _rm.get_visible_compiled_world_room_ids()
		_assert("opening foyer keeps upper side rooms hidden", not visible_rooms.has("master_bedroom"))
		_assert("opening foyer hides upper hallway shell", not visible_rooms.has("upper_hallway"))
	await _capture_review(
		"10_foyer_handoff",
		"Dark-foyer handoff after the player opens the manor personally.",
		Q_FOYER_DARK
	)
	await _stage_pose(
		"11_foyer_commit",
		Vector3(0.35, 0, -1.35),
		176.0,
		-4.0,
		"Foyer commitment shot showing where the player is likely to move next.",
		Q_FOYER_DARK
	)
	await _stage_pose(
		"12_stairs_pull",
		Vector3(0.18, 0, -0.78),
		176.0,
		-14.0,
		"Stair and upper-volume read for spatial promise without forced gating.",
		Q_FOYER_DARK
	)

	_im._on_door_tapped("parlor", "foyer_to_parlor")
	var reached_parlor := await _await_room_id("parlor", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening reaches parlor", reached_parlor and _rm.get_current_room_id() == "parlor")
	await _capture_review(
		"13_parlor_entry",
		"Parlor entry before first warmth is reclaimed.",
		Q_PARLOR_WARMTH
	)
	var parlor_fireplace_decl := _find_decl("parlor_fireplace")
	_assert("opening parlor fireplace exists", parlor_fireplace_decl != null)
	if parlor_fireplace_decl != null:
		_im._on_interacted("parlor_fireplace", parlor_fireplace_decl.type, {})
		await _settle()
		_assert("opening first warmth grants firebrand", _gm.has_item("firebrand"))
		_assert("opening first warmth sets tool phase", _gm.get_state("current_light_tool", "") == "firebrand")
		await _capture_review(
			"14_parlor_firebrand",
			"First reclaimed warmth and firebrand phase in the parlor.",
			Q_PARLOR_WARMTH
		)

	_im._on_door_tapped("foyer", "parlor_to_foyer")
	var returned_foyer := await _await_room_id("foyer", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening returns to foyer from parlor", returned_foyer and _rm.get_current_room_id() == "foyer")

	_im._on_door_tapped("kitchen", "foyer_to_kitchen")
	var reached_kitchen := await _await_room_id("kitchen", 180)
	await _await_transition_idle()
	await _settle()
	_assert("opening reaches kitchen", reached_kitchen and _rm.get_current_room_id() == "kitchen")
	await _capture_review(
		"15_kitchen_entry",
		"Kitchen/service read before Elizabeth's first seizure of the route.",
		Q_KITCHEN_SERVICE
	)

	_im._on_door_tapped("storage_basement", "kitchen_to_storage_basement")
	var reached_storage: bool = false
	for _i in range(40):
		await create_timer(0.1).timeout
		if _rm.get_current_room_id() == "storage_basement" and not _rm.get("_is_transitioning"):
			reached_storage = true
			break
	await _await_transition_idle()
	await _settle()
	_assert("opening service hatch fall reaches storage basement", reached_storage and _rm.get_current_room_id() == "storage_basement")
	_assert("opening service hatch fall clears firebrand", not _gm.has_item("firebrand"))
	_assert("opening service hatch fall sets elizabeth awareness", _gm.get_state("elizabeth_aware", false) == true)
	await _capture_review(
		"16_storage_basement_fall",
		"Immediate aftermath of the service descent into the storage basement.",
		Q_BASEMENT_FALL
	)

	_finish()


func _stage_pose(
	name: String,
	position: Vector3,
	rotation_y: float,
	pitch_degrees: float = 0.0,
	purpose: String = "",
	questions: PackedStringArray = PackedStringArray()
) -> void:
	_set_player_pose(position, rotation_y, pitch_degrees)
	await _settle()
	await _capture_review(name, purpose, questions)


func _set_player_pose(position: Vector3, rotation_y: float, pitch_degrees: float = 0.0) -> void:
	if _player == null:
		return
	var room_origin := _get_current_room_origin()
	var world_position := position + room_origin
	if _player.has_method("set_room_position"):
		_player.set_room_position(world_position)
	else:
		_player.global_position = world_position
	if _player.has_method("set_room_rotation_y"):
		_player.set_room_rotation_y(rotation_y)
	else:
		_player.rotation_degrees.y = rotation_y
	if _player.has_method("_set_pitch_degrees"):
		_player._set_pitch_degrees(pitch_degrees)


func _find_decl(object_id: String) -> InteractableDecl:
	var room = _rm.get_current_room() if _rm != null else null
	if room == null or not room.has_method("get_interactables"):
		return null
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == object_id:
			var decl = area.get_meta("declaration") if area.has_meta("declaration") else null
			if decl is InteractableDecl:
				return decl
	return null


func _get_current_room_origin() -> Vector3:
	if _rm == null:
		return Vector3.ZERO
	if _rm.has_method("get_room_world_origin"):
		return _rm.get_room_world_origin()
	var room: Node = _rm.get_current_room() if _rm.has_method("get_current_room") else null
	if room is Node3D:
		return (room as Node3D).global_position
	return Vector3.ZERO


func _capture(name: String) -> void:
	_manifest.append(name)
	_hide_overlays()
	if not _capture_enabled:
		return
	await RenderingServer.frame_post_draw
	var viewport: Viewport = _main.get_viewport() if _main != null else null
	if viewport == null:
		return
	var viewport_tex := viewport.get_texture()
	if viewport_tex == null:
		return
	var image := viewport_tex.get_image()
	if image == null:
		return
	image.save_png(_screenshot_dir + name + ".png")


func _capture_review(name: String, purpose: String = "", questions: PackedStringArray = PackedStringArray()) -> void:
	_capture_manifest.append(_build_capture_entry(name, purpose, questions))
	await _capture(name)


func _build_capture_entry(name: String, purpose: String, questions: PackedStringArray) -> Dictionary:
	var local_position := Vector3.ZERO
	if _player != null:
		local_position = _player.global_position - _get_current_room_origin()
	var question_list: Array[String] = []
	for question in questions:
		question_list.append(String(question))
	return {
		"name": name,
		"room_id": _rm.get_current_room_id() if _rm != null else "",
		"purpose": purpose,
		"position": "(%.2f, %.2f, %.2f)" % [local_position.x, local_position.y, local_position.z],
		"yaw": "%.1f" % (_player.get_view_yaw_degrees() if _player != null and _player.has_method("get_view_yaw_degrees") else 0.0),
		"pitch": "%.1f" % (_player.get_view_pitch_degrees() if _player != null and _player.has_method("get_view_pitch_degrees") else 0.0),
		"tool": _gm.get_state("current_light_tool", "") if _gm != null else "",
		"valise_opened": _gm.get_state("front_gate_valise_opened", false) if _gm != null else false,
		"packet_presented": _gm.get_state("front_gate_packet_presented", false) if _gm != null else false,
		"elizabeth_aware": _gm.get_state("elizabeth_aware", false) if _gm != null else false,
		"questions": question_list
	}


func _settle() -> void:
	await process_frame
	await process_frame
	await process_frame


func _await_room_id(room_id: String, max_frames: int = 120) -> bool:
	for _i in range(max_frames):
		if _rm != null and _rm.get_current_room_id() == room_id:
			return true
		await process_frame
	return _rm != null and _rm.get_current_room_id() == room_id


func _await_transition_idle(max_frames: int = 180) -> void:
	for _i in range(max_frames):
		if _rm == null or not _rm.get("_is_transitioning"):
			return
		await process_frame


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


func _hide_overlays() -> void:
	if _ui == null:
		return
	if _ui.has_method("hide_document"):
		_ui.hide_document()
	var room_name_display := _find(_ui, "RoomNameDisplay")
	if room_name_display is Control:
		(room_name_display as Control).visible = false
	var room_name := _find(_ui, "RoomNameLabel")
	if room_name is Label:
		(room_name as Label).visible = false
		(room_name as Label).modulate.a = 0.0


func _get_document_content() -> String:
	var doc := _find(_ui, "DocumentOverlay")
	var content = doc.get("_doc_content") if doc != null else null
	if content is RichTextLabel:
		return (content as RichTextLabel).text
	return ""


func _clear_save_data() -> void:
	var save_system := root.get_node_or_null("SaveSystem")
	if save_system != null and save_system.has_method("delete_all"):
		save_system.delete_all()


func _finish() -> void:
	_write_manifest()
	print("")
	print("========================================")
	print("OPENING JOURNEY: %d passed, %d failed" % [_pass_count, _fail_count])
	if _capture_enabled:
		print("Screenshots: %s" % ProjectSettings.globalize_path(_screenshot_dir))
	else:
		print("Screenshots: skipped in headless mode")
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _write_manifest() -> void:
	var dir_path := ProjectSettings.globalize_path(_screenshot_dir)
	DirAccess.make_dir_recursive_absolute(dir_path)
	var file := FileAccess.open(dir_path.path_join("opening_manifest.txt"), FileAccess.WRITE)
	if file == null:
		return
	file.store_line("Ashworth Manor Opening Journey")
	file.store_line("capture_enabled=%s" % str(_capture_enabled))
	file.store_line("")
	for entry in _manifest:
		file.store_line(entry)
	file.close()
	var markdown := FileAccess.open(dir_path.path_join("opening_manifest.md"), FileAccess.WRITE)
	if markdown == null:
		return
	markdown.store_line("# Ashworth Manor Opening Journey Visual Manifest")
	markdown.store_line("")
	markdown.store_line("Each screenshot exists to answer a player-experience question, not just to prove the route runs.")
	markdown.store_line("")
	for entry in _capture_manifest:
		markdown.store_line("## `%s`" % entry.get("name", ""))
		markdown.store_line("")
		markdown.store_line("- File: `%s.png`" % entry.get("name", ""))
		markdown.store_line("- Room: `%s`" % entry.get("room_id", ""))
		markdown.store_line("- Pose: `%s`, yaw `%s`, pitch `%s`" % [entry.get("position", ""), entry.get("yaw", "0.0"), entry.get("pitch", "0.0")])
		markdown.store_line("- Tool state: `%s`" % entry.get("tool", ""))
		markdown.store_line("- State: `valise_opened=%s`, `packet_presented=%s`, `elizabeth_aware=%s`" % [
			str(entry.get("valise_opened", false)),
			str(entry.get("packet_presented", false)),
			str(entry.get("elizabeth_aware", false))
		])
		var purpose := String(entry.get("purpose", ""))
		if not purpose.is_empty():
			markdown.store_line("- Purpose: %s" % purpose)
		var questions: Array = entry.get("questions", [])
		if not questions.is_empty():
			markdown.store_line("- Review questions:")
			for question in questions:
				markdown.store_line("  - %s" % String(question))
		markdown.store_line("")
	markdown.close()


func _assert(label: String, ok: bool) -> void:
	if ok:
		_pass_count += 1
		print("[PASS] %s" % label)
		return
	_fail_count += 1
	print("[FAIL] %s" % label)


func _find(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var found := _find(child, target)
		if found != null:
			return found
	return null


func _find_camera(node: Node) -> Camera3D:
	if node is Camera3D:
		return node as Camera3D
	for child in node.get_children():
		var found := _find_camera(child)
		if found != null:
			return found
	return null
