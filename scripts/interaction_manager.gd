extends Node
## res://scripts/interaction_manager.gd -- Dispatch interactions, door transitions
## Document text via Dialogue Manager. Puzzle logic in puzzle_handler.gd.
## Phantom Camera inspection on key objects.

const InteractableVisuals = preload("res://engine/interactable_visuals.gd")

var _player: Node = null
var _room_manager: Node = null
var _ui_overlay: Control = null
var _puzzle: Node = null
var _audio_manager: Node = null
var _current_dialogue_resource: Resource = null
var _active_inspect_cam: Node3D = null
var _state_schema: Resource = null

var _dialogue_paths: Dictionary = {
	"front_gate": "res://dialogue/grounds/front_gate.dialogue",
	"garden": "res://dialogue/grounds/garden.dialogue",
	"chapel": "res://dialogue/grounds/chapel.dialogue",
	"greenhouse": "res://dialogue/grounds/greenhouse.dialogue",
	"carriage_house": "res://dialogue/grounds/carriage_house.dialogue",
	"family_crypt": "res://dialogue/grounds/family_crypt.dialogue",
	"foyer": "res://dialogue/ground_floor/foyer.dialogue",
	"parlor": "res://dialogue/ground_floor/parlor.dialogue",
	"dining_room": "res://dialogue/ground_floor/dining_room.dialogue",
	"kitchen": "res://dialogue/ground_floor/kitchen.dialogue",
	"upper_hallway": "res://dialogue/upper_floor/upper_hallway.dialogue",
	"master_bedroom": "res://dialogue/upper_floor/master_bedroom.dialogue",
	"library": "res://dialogue/upper_floor/library.dialogue",
	"guest_room": "res://dialogue/upper_floor/guest_room.dialogue",
	"storage_basement": "res://dialogue/basement/storage_basement.dialogue",
	"boiler_room": "res://dialogue/basement/boiler_room.dialogue",
	"wine_cellar": "res://dialogue/basement/wine_cellar.dialogue",
	"attic_stairs": "res://dialogue/attic/attic_stairs.dialogue",
	"attic_storage": "res://dialogue/attic/attic_storage.dialogue",
	"hidden_chamber": "res://dialogue/attic/hidden_chamber.dialogue",
}

func _ready() -> void:
	_puzzle = preload("res://scripts/puzzle_handler.gd").new()
	_puzzle.name = "PuzzleHandler"
	add_child(_puzzle)
	_state_schema = load("res://declarations/state_schema.tres")
	call_deferred("_connect_signals")

func _connect_signals() -> void:
	_player = _find_node("PlayerController")
	_room_manager = _find_node("RoomManager")
	_ui_overlay = _find_node("UIOverlay")
	_audio_manager = _find_node("AudioManager")
	_puzzle.setup(_ui_overlay)
	if _player:
		if _player.has_signal("interacted"):
			var interacted_cb := Callable(self, "_on_interacted")
			if not _player.interacted.is_connected(interacted_cb):
				_player.interacted.connect(interacted_cb)
		if _player.has_signal("door_tapped"):
			var door_cb := Callable(self, "_on_door_tapped")
			if not _player.door_tapped.is_connected(door_cb):
				_player.door_tapped.connect(door_cb)
	if _ui_overlay and _ui_overlay.has_signal("document_closed"):
		var doc_cb := Callable(self, "_release_inspect_cam")
		if not _ui_overlay.document_closed.is_connected(doc_cb):
			_ui_overlay.document_closed.connect(doc_cb)
	if _room_manager and _room_manager.has_signal("room_loaded"):
		var room_cb := Callable(self, "_on_room_loaded")
		if not _room_manager.room_loaded.is_connected(room_cb):
			_room_manager.room_loaded.connect(room_cb)
	var state_cb := Callable(self, "_on_game_state_changed")
	if not GameManager.state_changed.is_connected(state_cb):
		GameManager.state_changed.connect(state_cb)
	var item_add_cb := Callable(self, "_on_game_item_changed")
	if not GameManager.item_acquired.is_connected(item_add_cb):
		GameManager.item_acquired.connect(item_add_cb)
	var item_remove_cb := Callable(self, "_on_game_item_changed")
	if not GameManager.item_removed.is_connected(item_remove_cb):
		GameManager.item_removed.connect(item_remove_cb)

func _on_room_loaded(room_id: String) -> void:
	_release_inspect_cam()
	var path: String = _dialogue_paths.get(room_id, "")
	if path.is_empty() or not ResourceLoader.exists(path):
		_current_dialogue_resource = null
	else:
		_current_dialogue_resource = load(path)
	_refresh_current_room_visuals()


func _on_game_state_changed(_key: String, _value: Variant) -> void:
	call_deferred("_refresh_current_room_visuals")


func _on_game_item_changed(_item_id: String) -> void:
	call_deferred("_refresh_current_room_visuals")

func _on_interacted(object_id: String, object_type: String, object_data: Dictionary) -> void:
	GameManager.mark_interacted(object_id)
	_begin_embodied_focus(object_id, object_data)
	_try_inspect_camera(object_id)
	var decl: InteractableDecl = _find_interactable_decl(object_id)
	if decl != null and _handle_special_interactable(decl):
		return
	match object_type:
		"note", "painting", "photo", "mirror", "clock", "observation":
			if decl != null and _handle_declared_interaction(decl):
				return
			_apply_flags(object_data)
			_handle_document(object_id, object_data)
		"switch":
			if decl != null and _handle_declared_interaction(decl):
				return
			_handle_switch(object_data)
		"box":
			if decl != null and _handle_declared_interaction(decl):
				return
			_apply_flags(object_data)
			_puzzle.handle_box(object_id, object_data, _current_dialogue_resource)
		"locked_door":
			_apply_flags(object_data)
			var target: String = _puzzle.handle_locked_door(object_data, _current_dialogue_resource)
			if not target.is_empty():
				_transition_to(target)
		"doll":
			_apply_flags(object_data)
			_puzzle.handle_doll(object_id, object_data, _current_dialogue_resource)
		"ritual":
			_apply_flags(object_data)
			_puzzle.handle_ritual(object_data, _current_dialogue_resource)
		_:
			_apply_flags(object_data)
			if object_data.has("content"):
				_handle_document(object_id, object_data)


func _handle_special_interactable(decl: InteractableDecl) -> bool:
	if decl == null:
		return false
	if decl.state_tags.has("gate_menu_new_game"):
		_handle_front_gate_new_game()
		return true
	if decl.state_tags.has("gate_menu_load_game"):
		_handle_front_gate_load_game()
		return true
	if decl.state_tags.has("gate_menu_settings"):
		_handle_front_gate_settings()
		return true
	return false


func _handle_front_gate_new_game() -> void:
	GameManager.new_game()
	GameManager.set_state("front_gate_menu_selection", "new_game")
	GameManager.set_state("front_gate_threshold_acknowledged", true)
	GameManager.set_state("front_gate_menu_committed", true)
	_play_declared_sfx("gate_creak")
	if _room_manager != null and _room_manager.has_method("load_room"):
		_room_manager.load_room("front_gate")


func _handle_front_gate_load_game() -> void:
	if not GameManager.has_save():
		_show("Load Game", "No prior journey hangs on the sign's chain yet.")
		return
	if not GameManager.load_game():
		_show("Load Game", "The old route slips away before you can follow it.")
		return
	GameManager.set_state("front_gate_menu_selection", "load_game")
	if _room_manager != null and _room_manager.has_method("load_room"):
		_room_manager.load_room(GameManager.current_room)


func _handle_front_gate_settings() -> void:
	if _ui_overlay != null and _ui_overlay.has_method("toggle_pause_menu"):
		_ui_overlay.toggle_pause_menu()

func _apply_flags(data: Dictionary) -> void:
	var flags_val: Variant = data.get("on_read_flags", [])
	if flags_val is String and not (flags_val as String).is_empty():
		var parts: PackedStringArray = (flags_val as String).split(",")
		for i in parts.size():
			var flag_name: String = parts[i].strip_edges()
			if not flag_name.is_empty():
				GameManager.set_flag(flag_name)
	elif flags_val is Array:
		for f in flags_val:
			if f is String and not f.is_empty():
				GameManager.set_flag(f)

func _handle_document(object_id: String, data: Dictionary) -> void:
	if _current_dialogue_resource != null and _has_dialogue_manager():
		DialogueManager.show_dialogue_balloon(_current_dialogue_resource, object_id)
		return
	_show(data.get("title", ""), data.get("content", ""))
	if data.get("pickable", false):
		var item_id: String = data.get("item_id", "")
		if not item_id.is_empty() and not GameManager.has_item(item_id):
			GameManager.give_item(item_id)

func _handle_switch(data: Dictionary) -> void:
	var controls_light: String = data.get("controls_light", "")
	if not controls_light.is_empty():
		GameManager.toggle_light(controls_light)


func _handle_declared_interaction(decl: InteractableDecl) -> bool:
	var interaction_engine: InteractionEngine = _build_interaction_engine()
	if interaction_engine == null:
		return false
	var response: ResponseDecl = interaction_engine.interact(decl)
	if response == null:
		return false

	if not response.title.is_empty() or not response.text.is_empty():
		_show(response.title, response.text)
	if not response.play_sfx.is_empty():
		_play_declared_sfx(response.play_sfx)
	return true


func _build_interaction_engine() -> InteractionEngine:
	var state_machine := StateMachine.new()
	if _state_schema != null and state_machine.has_method("init_from_schema"):
		state_machine.init_from_schema(_state_schema)

	for key in GameManager.flags:
		state_machine.set_var(key, GameManager.flags[key])
	for room_id in GameManager.visited_rooms:
		state_machine.visit_room(room_id)

	var inventory: Array[String] = GameManager.get_inventory_items()
	state_machine.set_inventory(inventory)

	var interaction_engine := InteractionEngine.new(state_machine)
	var macro_thread: Variant = GameManager.get_state("macro_thread", "")
	if macro_thread is String and not macro_thread.is_empty():
		interaction_engine.set_thread(macro_thread)
	interaction_engine.set_inventory(inventory)
	interaction_engine.state_changed.connect(_on_interaction_state_changed)
	interaction_engine.item_given.connect(_on_interaction_item_given)
	return interaction_engine


func _on_interaction_state_changed(variable: String, value: Variant) -> void:
	GameManager.set_state(variable, value)


func _on_interaction_item_given(item_id: String) -> void:
	if not GameManager.has_item(item_id):
		GameManager.give_item(item_id)


func _find_interactable_decl(object_id: String) -> InteractableDecl:
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		return null
	var room = _room_manager.get_current_room()
	if room == null or not room.has_method("get_interactables"):
		return null
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == object_id:
			var decl = area.get_meta("declaration") if area.has_meta("declaration") else null
			if decl is InteractableDecl:
				return decl
	return null


func _refresh_current_room_visuals() -> void:
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		return
	var room = _room_manager.get_current_room()
	if room == null or not room.has_method("get_interactables"):
		return
	for area in room.get_interactables():
		if area is Area3D:
			InteractableVisuals.ensure_visual(area as Area3D)


func _evaluate_state_expression(expression: String) -> bool:
	var state_machine := StateMachine.new()
	if _state_schema != null:
		state_machine.init_from_schema(_state_schema)
	for key in GameManager.flags:
		state_machine.set_var(key, GameManager.flags[key])
	for room_id in GameManager.visited_rooms:
		state_machine.visit_room(room_id)
	state_machine.set_inventory(GameManager.get_inventory_items())
	return state_machine.evaluate(expression)

# === Phantom Camera Inspection ===

func _try_inspect_camera(object_id: String) -> void:
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		return
	var room = _room_manager.get_current_room()
	if room == null:
		return
	var pcam_name: String = "Inspect_" + object_id
	var pcam: Node3D = _find_pcam(room, pcam_name)
	if pcam:
		_active_inspect_cam = pcam
		var cam_ctrl: Node = _find_child_of(_player, "CameraController")
		if cam_ctrl and cam_ctrl.has_method("set_inspection_camera"):
			cam_ctrl.set_inspection_camera(pcam)

func _release_inspect_cam() -> void:
	if _player != null and _player.has_method("release_interaction_focus"):
		_player.release_interaction_focus()
	if _active_inspect_cam:
		var cam_ctrl: Node = null
		if _player:
			cam_ctrl = _find_child_of(_player, "CameraController")
		if cam_ctrl and cam_ctrl.has_method("reset_inspection_camera"):
			cam_ctrl.reset_inspection_camera(_active_inspect_cam)
		_active_inspect_cam = null

func _find_pcam(node: Node, pcam_name: String) -> Node3D:
	if node is Node3D and node.name == pcam_name:
		return node as Node3D
	for child in node.get_children():
		var found: Node3D = _find_pcam(child, pcam_name)
		if found:
			return found
	return null

func _find_child_of(node: Node, child_name: String) -> Node:
	if node == null:
		return null
	return node.get_node_or_null(child_name)

# === DOOR TRANSITIONS ===

func _on_door_tapped(target_room: String, connection_id: String = "") -> void:
	if target_room.is_empty():
		return
	_release_inspect_cam()
	var conn_type: String = "door"
	var matched_area: Area3D = null
	if _room_manager and _room_manager.has_method("get_current_room"):
		var room = _room_manager.get_current_room()
		if room and room.has_method("get_connections"):
			for area in room.get_connections():
				var area_connection_id: String = area.get_meta("connection_id") if area.has_meta("connection_id") else ""
				var area_target: String = area.get_meta("target_room") if area.has_meta("target_room") else ""
				if not connection_id.is_empty() and area_connection_id != connection_id:
					continue
				if area_target != target_room:
					continue
				var conn_res = area.get_meta("connection") if area.has_meta("connection") else null
				if conn_res is RoomConnection:
					conn_type = conn_res.conn_type
					if conn_res.locked and not conn_res.key_id.is_empty():
						if not GameManager.has_item(conn_res.key_id):
							_show("Locked", "You need the %s." % conn_res.key_id.replace("_", " "))
							return
					matched_area = area
					break
				if area.has_meta("conn_type"):
					conn_type = area.get_meta("conn_type")
				var required_state: String = area.get_meta("required_state") if area.has_meta("required_state") else ""
				if not required_state.is_empty() and not _evaluate_state_expression(required_state):
					var blocked_text: String = area.get_meta("blocked_text") if area.has_meta("blocked_text") else "Something stays your hand at the threshold."
					_show("", blocked_text)
					return
				if area.has_meta("secret_passage_revealed") and not area.get_meta("secret_passage_revealed"):
					var passage_text: String = area.get_meta("secret_passage_closed_text") if area.has_meta("secret_passage_closed_text") else "Something about this surface feels wrong."
					_show("Hidden", passage_text)
					return
				var is_locked: bool = area.get_meta("locked") if area.has_meta("locked") else false
				var key_id: String = area.get_meta("key_id") if area.has_meta("key_id") else ""
				if is_locked and not key_id.is_empty() and not GameManager.has_item(key_id):
					_show("Locked", "You need the %s." % key_id.replace("_", " "))
					return
				matched_area = area
				if connection_id.is_empty():
					connection_id = area_connection_id
				break
	if target_room == "front_gate" and GameManager.current_room != "front_gate":
		if GameManager.has_flag("counter_ritual_complete"):
			await _play_threshold_visual(matched_area)
			_transition_with_type(target_room, conn_type, connection_id)
			return
		elif GameManager.check_escape_ending():
			GameManager.trigger_ending("escape")
			return
		elif GameManager.check_joined_ending():
			GameManager.trigger_ending("joined")
			return
	await _play_threshold_visual(matched_area)
	_transition_with_type(target_room, conn_type, connection_id)
	GameManager.save_game()

# === HELPERS ===

func _transition_to(room_id: String) -> void:
	_transition_with_type(room_id, "door", "")

func _transition_with_type(room_id: String, conn_type: String, connection_id: String = "") -> void:
	if _room_manager and _room_manager.has_method("transition_to"):
		_room_manager.transition_to(room_id, conn_type, connection_id)


func _play_threshold_visual(area: Area3D) -> void:
	if area == null:
		return
	var assembly_root := area.get_parent()
	if assembly_root == null:
		return
	var controller := assembly_root.get_node_or_null("ConnectionMechanism")
	if controller == null or not controller.has_method("play_transition_visual"):
		return
	var duration: Variant = controller.play_transition_visual()
	if duration is float and duration > 0.0:
		await get_tree().create_timer(duration).timeout

func _show(title: String, content: String) -> void:
	if _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document(title, content)


func _play_declared_sfx(sfx_ref: String) -> void:
	if _audio_manager == null or not _audio_manager.has_method("play_sfx"):
		return
	if sfx_ref.begins_with("res://assets/audio/sfx/"):
		var trimmed := sfx_ref.trim_prefix("res://assets/audio/sfx/")
		if trimmed.ends_with(".ogg"):
			trimmed = trimmed.substr(0, trimmed.length() - 4)
		_audio_manager.play_sfx(trimmed)
		return
	_audio_manager.play_sfx(sfx_ref)

func _has_dialogue_manager() -> bool:
	return get_node_or_null("/root/DialogueManager") != null

func _scene_path_to_id(path: String) -> String:
	if _room_manager and _room_manager.has_method("_scene_path_to_room_id"):
		return _room_manager._scene_path_to_room_id(path)
	return path.get_file().get_basename()

func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null


func _begin_embodied_focus(object_id: String, object_data: Dictionary) -> void:
	if _player == null or not _player.has_method("begin_interaction_focus"):
		return
	var decl := _find_interactable_decl(object_id)
	var hint := _build_interaction_focus_hint(object_id, object_data, decl)
	if hint.is_empty():
		return
	_player.begin_interaction_focus(hint)


func _build_interaction_focus_hint(object_id: String, object_data: Dictionary, decl: InteractableDecl) -> Dictionary:
	var focus_hint: Dictionary = object_data.duplicate(true)
	var area := _find_interactable_area(object_id)
	if not focus_hint.has("interaction_world_position"):
		if area != null:
			focus_hint["interaction_world_position"] = area.global_position
		elif decl != null:
			focus_hint["interaction_world_position"] = decl.position
	var target_pos: Variant = focus_hint.get("interaction_world_position", null)
	if target_pos is not Vector3:
		return {}
	if area != null:
		var collision := area.get_node_or_null("CollisionShape3D") as CollisionShape3D
		if collision != null and collision.shape is BoxShape3D:
			var box := collision.shape as BoxShape3D
			target_pos = area.global_position + Vector3(0, clampf(box.size.y * 0.16, 0.05, 0.18), 0)
			focus_hint["interaction_world_position"] = target_pos
	var focus_kind := "inspect"
	if decl != null and (decl.scene_role == "portable_item" or not decl.gives_item.is_empty()):
		focus_kind = "pickup"
	focus_hint["focus_kind"] = focus_kind
	return focus_hint


func _find_interactable_area(object_id: String) -> Area3D:
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		return null
	var room = _room_manager.get_current_room()
	if room == null or not room.has_method("get_interactables"):
		return null
	for area in room.get_interactables():
		if area is Area3D and area.has_meta("id") and area.get_meta("id") == object_id:
			return area as Area3D
	return null
