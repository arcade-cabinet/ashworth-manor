extends Node
## res://scripts/interaction_manager.gd -- Full puzzle logic, endings, room transitions

var _player: Node = null
var _room_manager: Node = null
var _ui_overlay: Control = null


func _ready() -> void:
	call_deferred("_connect_signals")


func _connect_signals() -> void:
	_player = _find_node("PlayerController")
	_room_manager = _find_node("RoomManager")
	_ui_overlay = _find_node("UIOverlay")

	if _player:
		if _player.has_signal("interacted"):
			_player.interacted.connect(_on_interacted)
		if _player.has_signal("door_tapped"):
			_player.door_tapped.connect(_on_door_tapped)


func _on_interacted(object_id: String, object_type: String, object_data: Dictionary) -> void:
	GameManager.mark_interacted(object_id)

	# Set flags from on_read_flags (handles both String and Array)
	var on_read_flags: Array = _to_array(object_data.get("on_read_flags", []))
	for flag_name in on_read_flags:
		if flag_name is String and not flag_name.is_empty():
			GameManager.set_flag(flag_name)

	match object_type:
		"note", "painting", "photo", "mirror", "clock", "observation":
			_handle_document(object_id, object_type, object_data)
		"switch":
			_handle_switch(object_data)
		"box":
			_handle_box(object_id, object_data)
		"locked_door":
			_handle_locked_door(object_data)
		"doll":
			_handle_doll(object_id, object_data)
		"ritual":
			_handle_ritual(object_data)
		_:
			if object_data.has("content"):
				_handle_document(object_id, object_type, object_data)


# === DOCUMENTS ===

func _handle_document(_object_id: String, object_type: String, data: Dictionary) -> void:
	var title: String = data.get("title", "")
	var content: String = data.get("content", "")
	if title.is_empty():
		match object_type:
			"mirror": title = "Reflection"
			"clock": title = "Clock"
			"observation": title = "Observation"
	_show(title, content)

	var pickable: bool = data.get("pickable", false)
	var item_id: String = data.get("item_id", "")
	if pickable and not item_id.is_empty() and not GameManager.has_item(item_id):
		GameManager.give_item(item_id)


# === SWITCHES ===

func _handle_switch(data: Dictionary) -> void:
	var controls_light: String = data.get("controls_light", "")
	if not controls_light.is_empty():
		GameManager.toggle_light(controls_light)


# === BOXES (keys, locked containers) ===

func _handle_box(object_id: String, data: Dictionary) -> void:
	var locked: bool = data.get("locked", false)
	var key_id: String = data.get("key_id", "")
	var item_found: String = data.get("item_found", "")
	var content: String = data.get("content", "")
	var gives_also: String = data.get("gives_also", "")

	if locked and not key_id.is_empty():
		if GameManager.has_item(key_id):
			GameManager.set_flag(object_id + "_unlocked")
			if not item_found.is_empty():
				GameManager.give_item(item_found)
			if not gives_also.is_empty():
				GameManager.give_item(gives_also)
			var item_content: String = data.get("item_content", content)
			var item_title: String = data.get("item_title", "Unlocked")
			_show(item_title, item_content)
		else:
			var msg: String = data.get("message_locked", "It's locked. You need a key.")
			_show("Locked", msg)
	else:
		if not item_found.is_empty() and not GameManager.has_flag(object_id + "_looted"):
			GameManager.give_item(item_found)
			GameManager.set_flag(object_id + "_looted")
			if not gives_also.is_empty():
				GameManager.give_item(gives_also)
		_show(data.get("title", ""), content)


# === LOCKED DOORS ===

func _handle_locked_door(data: Dictionary) -> void:
	var key_id: String = data.get("key_id", "")
	var target_room: String = data.get("target_room", "")
	var message_locked: String = data.get("message_locked", "The door is locked.")

	if key_id.is_empty() or GameManager.has_item(key_id):
		if not target_room.is_empty():
			GameManager.set_flag(key_id + "_used")
			_transition_to(target_room)
	else:
		_show("Locked", message_locked)


# === PORCELAIN DOLL (special multi-step puzzle) ===

func _handle_doll(_object_id: String, data: Dictionary) -> void:
	var first_content: String = data.get("first_content", "A porcelain doll stares back.")
	var second_content: String = data.get("second_content", "")
	var requires_flag: String = data.get("requires_flag", "")
	var item_found: String = data.get("item_found", "")

	# First interaction -- examine the doll
	if not GameManager.has_flag("examined_doll"):
		GameManager.set_flag("examined_doll")
		var on_first: Array = _to_array(data.get("on_first_flags", []))
		for f in on_first:
			if f is String and not f.is_empty():
				GameManager.set_flag(f)
		_show("Porcelain Doll", first_content)
		return

	# Second interaction -- requires reading Elizabeth's letter first
	if not requires_flag.is_empty() and GameManager.has_flag(requires_flag):
		if not item_found.is_empty() and not GameManager.has_item(item_found):
			var on_second: Array = _to_array(data.get("on_second_flags", []))
			for f in on_second:
				if f is String and not f.is_empty():
					GameManager.set_flag(f)
			GameManager.give_item(item_found)
			_show("Porcelain Doll", second_content)
			var pickable_after: bool = data.get("pickable_after_key", false)
			var doll_item_id: String = data.get("item_id", "")
			if pickable_after and not doll_item_id.is_empty():
				GameManager.give_item(doll_item_id)
			return
		else:
			_show("Porcelain Doll", "The doll sits quietly. Empty now.")
			return

	# Fallback -- haven't read the letter yet
	_show("Porcelain Doll", first_content)


# === COUNTER-RITUAL (3-step sequence in Hidden Chamber) ===

func _handle_ritual(data: Dictionary) -> void:
	var ritual_started: bool = GameManager.has_flag("ritual_step_1")
	if not ritual_started and not GameManager.can_perform_ritual():
		_show("", data.get("description", "Something is missing."))
		return

	if not GameManager.has_flag("ritual_step_1"):
		if GameManager.has_item("porcelain_doll"):
			GameManager.set_flag("ritual_step_1")
			_show("", "You place the doll in the center of Elizabeth's drawings. The candles flicker.")
		return

	if not GameManager.has_flag("ritual_step_2"):
		if GameManager.has_item("blessed_water"):
			GameManager.set_flag("ritual_step_2")
			GameManager.remove_item("blessed_water")
			_show("", "Water flows over the doll's cracked face. The drawings on the walls seem to shift.")
		return

	if not GameManager.has_flag("ritual_step_3"):
		if GameManager.has_item("binding_book"):
			GameManager.set_flag("ritual_step_3")
			GameManager.set_flag("counter_ritual_complete")
			GameManager.set_flag("freed_elizabeth")
			var overlay: Control = _find_node("UIOverlay")
			if overlay and overlay.has_method("hide_document"):
				overlay.hide_document()
			_show("", "\"Elizabeth Ashworth. Born in light. Free.\"\n\nThe doll cracks open. Light pours from inside. The drawings fade.\n\n\"Thank you.\"")
			get_tree().create_timer(6.0).timeout.connect(
				func():
					if overlay and overlay.has_method("hide_document"):
						overlay.hide_document()
					GameManager.trigger_ending("freedom")
			)
		return


# === DOOR TRANSITIONS (with ending checks) ===

func _on_door_tapped(target_room: String) -> void:
	if target_room.is_empty():
		return

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
								_show("Locked", "This passage is locked. You need the %s." % conn_res.key_id.replace("_", " "))
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

func _to_array(value) -> Array:
	if value is Array:
		return value
	if value is String:
		if value.is_empty():
			return []
		if "," in value:
			var parts: Array = []
			for part in value.split(","):
				var trimmed: String = part.strip_edges()
				if not trimmed.is_empty():
					parts.append(trimmed)
			return parts
		return [value]
	return []


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


func _scene_path_to_id(path: String) -> String:
	if _room_manager and _room_manager.has_method("_scene_path_to_room_id"):
		return _room_manager._scene_path_to_room_id(path)
	return path.get_file().get_basename()


func _find_node(node_name: String) -> Node:
	return _recursive_find(get_tree().root, node_name)


func _recursive_find(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var found: Node = _recursive_find(child, target_name)
		if found != null:
			return found
	return null
