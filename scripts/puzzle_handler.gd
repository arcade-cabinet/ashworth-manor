extends Node
## res://scripts/puzzle_handler.gd -- Puzzle logic: boxes, locked doors, doll, ritual
## Called by interaction_manager.gd for puzzle-type interactions.

var _ui_overlay: Control = null


func setup(ui_overlay: Control) -> void:
	_ui_overlay = ui_overlay


func handle_box(object_id: String, data: Dictionary, dialogue_res: Resource) -> void:
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
			if dialogue_res != null and _has_dialogue_manager():
				DialogueManager.show_dialogue_balloon(dialogue_res, object_id)
			else:
				_show(data.get("item_title", "Unlocked"), data.get("item_content", content))
		else:
			_show("Locked", data.get("message_locked", "It's locked. You need a key."))
	else:
		if not item_found.is_empty() and not GameManager.has_flag(object_id + "_looted"):
			GameManager.give_item(item_found)
			GameManager.set_flag(object_id + "_looted")
			if not gives_also.is_empty():
				GameManager.give_item(gives_also)
		if dialogue_res != null and _has_dialogue_manager():
			DialogueManager.show_dialogue_balloon(dialogue_res, object_id)
		else:
			_show(data.get("title", ""), content)


func handle_locked_door(data: Dictionary, dialogue_res: Resource) -> String:
	## Returns target_room if door opens, empty string if locked.
	var key_id: String = data.get("key_id", "")
	var target_room: String = data.get("target_room", "")

	if key_id.is_empty() or GameManager.has_item(key_id):
		if not target_room.is_empty():
			GameManager.set_flag(key_id + "_used")
			return target_room
	else:
		var object_id: String = data.get("id", "")
		if dialogue_res != null and not object_id.is_empty() and _has_dialogue_manager():
			DialogueManager.show_dialogue_balloon(dialogue_res, object_id)
		else:
			_show("Locked", data.get("message_locked", "The door is locked."))
	return ""


func handle_doll(object_id: String, data: Dictionary, dialogue_res: Resource) -> void:
	if dialogue_res != null and _has_dialogue_manager():
		DialogueManager.show_dialogue_balloon(dialogue_res, object_id)

	if not GameManager.has_flag("examined_doll"):
		GameManager.set_flag("examined_doll")
		for f in _to_array(data.get("on_first_flags", [])):
			if f is String and not f.is_empty():
				GameManager.set_flag(f)
		if dialogue_res == null or not _has_dialogue_manager():
			_show("Porcelain Doll", data.get("first_content", "A porcelain doll stares back."))
		return

	var requires_flag: String = data.get("requires_flag", "")
	var item_found: String = data.get("item_found", "")
	if not requires_flag.is_empty() and GameManager.has_flag(requires_flag):
		if not item_found.is_empty() and not GameManager.has_item(item_found):
			for f in _to_array(data.get("on_second_flags", [])):
				if f is String and not f.is_empty():
					GameManager.set_flag(f)
			GameManager.give_item(item_found)
			if data.get("pickable_after_key", false):
				var doll_item_id: String = data.get("item_id", "")
				if not doll_item_id.is_empty():
					GameManager.give_item(doll_item_id)
			if dialogue_res == null or not _has_dialogue_manager():
				_show("Porcelain Doll", data.get("second_content", ""))
			return

	if dialogue_res == null or not _has_dialogue_manager():
		_show("Porcelain Doll", data.get("first_content", "A porcelain doll stares back."))


func handle_ritual(data: Dictionary, dialogue_res: Resource) -> void:
	if not GameManager.has_flag("ritual_step_1") and not GameManager.can_perform_ritual():
		if dialogue_res != null and _has_dialogue_manager():
			DialogueManager.show_dialogue_balloon(dialogue_res, "ritual_circle")
		else:
			_show("", data.get("description", "Something is missing."))
		return

	if not GameManager.has_flag("ritual_step_1"):
		if GameManager.has_item("porcelain_doll"):
			GameManager.set_flag("ritual_step_1")
			_show("", "You place the doll in the center of Elizabeth's drawings.")
		return

	if not GameManager.has_flag("ritual_step_2"):
		if GameManager.has_item("blessed_water"):
			GameManager.set_flag("ritual_step_2")
			GameManager.remove_item("blessed_water")
			_show("", "Water flows over the doll's cracked face.")
		return

	if not GameManager.has_flag("ritual_step_3"):
		if GameManager.has_item("binding_book"):
			GameManager.set_flag("ritual_step_3")
			GameManager.set_flag("counter_ritual_complete")
			GameManager.set_flag("freed_elizabeth")
			_show("", "Elizabeth Ashworth. Born in light. Free.")
			get_tree().create_timer(6.0).timeout.connect(
				func(): GameManager.trigger_ending("freedom")
			)
		return


func _show(title: String, content: String) -> void:
	if _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document(title, content)


func _has_dialogue_manager() -> bool:
	return get_node_or_null("/root/DialogueManager") != null


func _to_array(value: Variant) -> Array:
	if value is Array:
		return value
	if value is String:
		if (value as String).is_empty():
			return []
		if "," in (value as String):
			var parts: Array = []
			var split: PackedStringArray = (value as String).split(",")
			for i in split.size():
				var trimmed: String = split[i].strip_edges()
				if not trimmed.is_empty():
					parts.append(trimmed)
			return parts
		return [value]
	return []
