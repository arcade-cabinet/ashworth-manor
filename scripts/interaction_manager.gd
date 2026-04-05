extends Node
## res://scripts/interaction_manager.gd — Routes interactions to game logic and UI

# Node references set by the main scene builder or via _ready() find
var _player: Node = null
var _room_manager: Node = null
var _ui_overlay: Control = null


func _ready() -> void:
	# Defer connection so sibling nodes are ready
	call_deferred("_connect_signals")


func _connect_signals() -> void:
	_player = _find_node_in_tree("PlayerController")
	_room_manager = _find_node_in_tree("RoomManager")
	_ui_overlay = _find_node_in_tree("UIOverlay")

	if _player and _player.has_signal("interacted"):
		_player.interacted.connect(_on_interacted)
	if _player and _player.has_signal("door_tapped"):
		_player.door_tapped.connect(_on_door_tapped)


func _find_node_in_tree(node_name: String) -> Node:
	var root: Node = get_tree().root
	return _recursive_find(root, node_name)


func _recursive_find(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var found: Node = _recursive_find(child, target_name)
		if found != null:
			return found
	return null


func _on_interacted(object_id: String, object_type: String, object_data: Dictionary) -> void:
	# Mark as interacted in game state
	GameManager.mark_interacted(object_id)

	# Set any flags from on_read_flags
	var on_read_flags: Array = object_data.get("on_read_flags", [])
	for flag_name in on_read_flags:
		if flag_name is String:
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
		"pickup":
			_handle_pickup(object_data)
		_:
			# Fallback: if it has content, show as document
			if object_data.has("content"):
				_handle_document(object_id, object_type, object_data)


func _handle_document(object_id: String, object_type: String, data: Dictionary) -> void:
	var title: String = data.get("title", "")
	var content: String = data.get("content", "")

	# Type-specific title fallbacks
	if title.is_empty():
		match object_type:
			"mirror":
				title = "Reflection"
			"clock":
				title = "Clock"
			"observation":
				title = "Observation"
			_:
				title = object_id.replace("_", " ").capitalize()

	if _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document(title, content)


func _handle_switch(data: Dictionary) -> void:
	var controls_light: String = data.get("controls_light", "")
	if not controls_light.is_empty():
		GameManager.toggle_light(controls_light)


func _handle_box(object_id: String, data: Dictionary) -> void:
	var locked: bool = data.get("locked", false)
	var key_id: String = data.get("key_id", "")
	var gives_item: String = data.get("gives_item", "")
	var content: String = data.get("content", "")

	if locked and not key_id.is_empty():
		if GameManager.has_item(key_id):
			# Unlock with key
			GameManager.remove_item(key_id)
			GameManager.set_flag(object_id + "_unlocked")
			if not gives_item.is_empty():
				GameManager.give_item(gives_item)
				_show_message("Unlocked", "You used the %s. Found: %s" % [key_id.replace("_", " "), gives_item.replace("_", " ")])
			elif not content.is_empty():
				_show_message("Opened", content)
		else:
			_show_message("Locked", "This is locked. You need a key.")
	else:
		# Not locked
		if not gives_item.is_empty() and not GameManager.has_flag(object_id + "_looted"):
			GameManager.give_item(gives_item)
			GameManager.set_flag(object_id + "_looted")
			_show_message("Found", "Acquired: %s" % gives_item.replace("_", " "))
		elif not content.is_empty():
			_show_message("", content)


func _handle_locked_door(data: Dictionary) -> void:
	var key_id: String = data.get("key_id", "")
	var target_room: String = data.get("target_room", "")

	if key_id.is_empty() or GameManager.has_item(key_id):
		if not target_room.is_empty() and _room_manager and _room_manager.has_method("transition_to"):
			_room_manager.transition_to(target_room)
	else:
		_show_message("Locked Door", "This door is locked. You need the %s." % key_id.replace("_", " "))


func _handle_doll(object_id: String, data: Dictionary) -> void:
	var first_flag: String = object_id + "_first_interaction"
	var content_first: String = data.get("content_first", data.get("content", "A porcelain doll stares back at you with painted eyes."))
	var content_second: String = data.get("content_second", "The doll's head has turned since you last looked. Its smile seems wider.")
	var gives_item: String = data.get("gives_item", "")

	if not GameManager.has_flag(first_flag):
		GameManager.set_flag(first_flag)
		_show_message("Doll", content_first)
	else:
		_show_message("Doll", content_second)
		if not gives_item.is_empty() and not GameManager.has_item(gives_item):
			GameManager.give_item(gives_item)


func _handle_ritual(data: Dictionary) -> void:
	if GameManager.can_perform_ritual():
		GameManager.set_flag("counter_ritual_complete")
		GameManager.trigger_ending("ritual")
	else:
		var content: String = data.get("content", "An altar of dark stone. Something is missing.")
		_show_message("Ritual Site", content)


func _handle_pickup(data: Dictionary) -> void:
	var item_id: String = data.get("item_id", "")
	var content: String = data.get("content", "")
	if not item_id.is_empty() and not GameManager.has_item(item_id):
		GameManager.give_item(item_id)
		if not content.is_empty():
			_show_message("Found Item", content)


func _on_door_tapped(target_room: String) -> void:
	if target_room.is_empty():
		return

	# Check if this connection is locked
	if _room_manager and _room_manager.has_method("get_current_room_data"):
		var room_data: Dictionary = _room_manager.get_current_room_data()
		var connections: Array = room_data.get("connections", [])
		for conn in connections:
			if conn.get("target_room", "") == target_room:
				var locked: bool = conn.get("locked", false)
				var key_id: String = conn.get("key_id", "")
				if locked and not key_id.is_empty() and not GameManager.has_item(key_id):
					_show_message("Locked", "This passage is locked. You need the %s." % key_id.replace("_", " "))
					return
				break

	if _room_manager and _room_manager.has_method("transition_to"):
		_room_manager.transition_to(target_room)


func _show_message(title: String, content: String) -> void:
	if _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document(title, content)
