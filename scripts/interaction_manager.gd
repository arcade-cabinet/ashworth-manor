extends Node
## res://scripts/interaction_manager.gd -- Dispatch interactions, door transitions
## Document text via Dialogue Manager. Puzzle logic in puzzle_handler.gd.
## Phantom Camera inspection on key objects.

var _player: Node = null
var _room_manager: Node = null
var _ui_overlay: Control = null
var _puzzle: Node = null
var _current_dialogue_resource: Resource = null
var _active_inspect_cam: Node3D = null

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
	"hidden_room": "res://dialogue/attic/hidden_chamber.dialogue",
}

func _ready() -> void:
	_puzzle = preload("res://scripts/puzzle_handler.gd").new()
	_puzzle.name = "PuzzleHandler"
	add_child(_puzzle)
	call_deferred("_connect_signals")

func _connect_signals() -> void:
	_player = _find_node("PlayerController")
	_room_manager = _find_node("RoomManager")
	_ui_overlay = _find_node("UIOverlay")
	_puzzle.setup(_ui_overlay)
	if _player:
		if _player.has_signal("interacted"):
			_player.interacted.connect(_on_interacted)
		if _player.has_signal("door_tapped"):
			_player.door_tapped.connect(_on_door_tapped)
	if _ui_overlay and _ui_overlay.has_signal("document_closed"):
		_ui_overlay.document_closed.connect(_release_inspect_cam)
	if _room_manager and _room_manager.has_signal("room_loaded"):
		_room_manager.room_loaded.connect(_on_room_loaded)

func _on_room_loaded(room_id: String) -> void:
	_release_inspect_cam()
	var path: String = _dialogue_paths.get(room_id, "")
	if path.is_empty() or not ResourceLoader.exists(path):
		_current_dialogue_resource = null
		return
	_current_dialogue_resource = load(path)

func _on_interacted(object_id: String, object_type: String, object_data: Dictionary) -> void:
	GameManager.mark_interacted(object_id)
	_apply_flags(object_data)
	_try_inspect_camera(object_id)
	match object_type:
		"note", "painting", "photo", "mirror", "clock", "observation":
			_handle_document(object_id, object_data)
		"switch":
			_handle_switch(object_data)
		"box":
			_puzzle.handle_box(object_id, object_data, _current_dialogue_resource)
		"locked_door":
			var target: String = _puzzle.handle_locked_door(object_data, _current_dialogue_resource)
			if not target.is_empty():
				_transition_to(target)
		"doll":
			_puzzle.handle_doll(object_id, object_data, _current_dialogue_resource)
		"ritual":
			_puzzle.handle_ritual(object_data, _current_dialogue_resource)
		_:
			if object_data.has("content"):
				_handle_document(object_id, object_data)

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

func _on_door_tapped(target_room: String) -> void:
	if target_room.is_empty():
		return
	_release_inspect_cam()
	var conn_type: String = "door"
	if _room_manager and _room_manager.has_method("get_current_room"):
		var room = _room_manager.get_current_room()
		if room and room.has_method("get_connections"):
			for area in room.get_connections():
				var conn_res = area.get_meta("connection") if area.has_meta("connection") else null
				if conn_res is RoomConnection:
					var target_id: String = _scene_path_to_id(conn_res.target_scene_path)
					if target_id == target_room:
						conn_type = conn_res.conn_type
						if conn_res.locked and not conn_res.key_id.is_empty():
							if not GameManager.has_item(conn_res.key_id):
								_show("Locked", "You need the %s." % conn_res.key_id.replace("_", " "))
								return
						break
	if target_room == "front_gate" and GameManager.current_room != "front_gate":
		if GameManager.has_flag("counter_ritual_complete"):
			_transition_with_type(target_room, conn_type)
			return
		elif GameManager.check_escape_ending():
			GameManager.trigger_ending("escape")
			return
		elif GameManager.check_joined_ending():
			GameManager.trigger_ending("joined")
			return
	_transition_with_type(target_room, conn_type)
	GameManager.save_game()

# === HELPERS ===

func _transition_to(room_id: String) -> void:
	_transition_with_type(room_id, "door")

func _transition_with_type(room_id: String, conn_type: String) -> void:
	if _room_manager and _room_manager.has_method("transition_to"):
		_room_manager.transition_to(room_id, conn_type)
	if _player and _player.has_method("set_room_position"):
		_player.set_room_position(Vector3(0, 0, -3))

func _show(title: String, content: String) -> void:
	if _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document(title, content)

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
