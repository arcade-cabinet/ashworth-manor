class_name DialogueGenerator
extends RefCounted
## Generates .dialogue files from InteractableDecl responses per room.
## Each room gets one .dialogue file. Dialogue Manager loads them at runtime.
## Format: ~ {title}\n if {condition}\n\t{text}\n elif ...\n else\n\t{default}

var _thread_id: String = ""


func set_thread(thread_id: String) -> void:
	_thread_id = thread_id


## Generate dialogue content for a single room from its declaration.
## Returns the .dialogue file content as a String.
func generate_room_dialogue(room_decl: RoomDeclaration) -> String:
	var lines: PackedStringArray = []
	lines.append("# Auto-generated from %s declaration" % room_decl.room_id)
	lines.append("# Thread: %s" % (_thread_id if not _thread_id.is_empty() else "all"))
	lines.append("")

	for interactable in room_decl.interactables:
		var block := _generate_interactable_block(interactable)
		if not block.is_empty():
			lines.append_array(block)
			lines.append("")

	return "\n".join(lines)


## Generate a dialogue block for one interactable.
func _generate_interactable_block(decl: InteractableDecl) -> PackedStringArray:
	var lines: PackedStringArray = []

	# Title line
	lines.append("~ %s" % decl.id)

	# Thread-specific responses first (if thread is set)
	if not _thread_id.is_empty() and _thread_id in decl.thread_responses:
		var thread_resps: Array = decl.thread_responses[_thread_id]
		_append_responses(lines, thread_resps, false)
		lines.append("=> END")
		return lines

	# Progressive interactions
	if decl.progressive and not decl.progression_steps.is_empty():
		for i in range(decl.progression_steps.size()):
			var step: ProgressionStep = decl.progression_steps[i]
			var step_condition := "%s_step == %d" % [decl.id, i]
			var prefix := "if" if i == 0 else "elif"
			lines.append("%s %s" % [prefix, step_condition])
			if step.response:
				var title_line := step.response.title if not step.response.title.is_empty() else decl.id
				lines.append("\t%s: %s" % [title_line, _escape_text(step.response.text)])
		if decl.fallback_response:
			lines.append("else")
			lines.append("\t%s" % _escape_text(decl.fallback_response.text))
		lines.append("=> END")
		return lines

	# Standard conditional responses
	if not decl.responses.is_empty():
		_append_responses(lines, decl.responses, false)
	elif decl.fallback_response:
		lines.append("%s" % _escape_text(decl.fallback_response.text))

	lines.append("=> END")
	return lines


func _append_responses(lines: PackedStringArray, responses: Array, _is_thread: bool) -> void:
	var first := true
	for response in responses:
		if response is not ResponseDecl:
			continue
		var resp: ResponseDecl = response

		if resp.condition.is_empty():
			if first:
				var title := resp.title if not resp.title.is_empty() else ""
				if not title.is_empty():
					lines.append("%s: %s" % [title, _escape_text(resp.text)])
				else:
					lines.append("%s" % _escape_text(resp.text))
			else:
				lines.append("else")
				lines.append("\t%s" % _escape_text(resp.text))
		else:
			var prefix := "if" if first else "elif"
			lines.append("%s %s" % [prefix, resp.condition])
			var title := resp.title if not resp.title.is_empty() else ""
			if not title.is_empty():
				lines.append("\t%s: %s" % [title, _escape_text(resp.text)])
			else:
				lines.append("\t%s" % _escape_text(resp.text))

		first = false


## Generate all .dialogue files for every room.
## Returns dictionary of room_id -> dialogue_content.
func generate_all(room_decls: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for room_id in room_decls:
		var room: RoomDeclaration = room_decls[room_id]
		var content := generate_room_dialogue(room)
		if not content.strip_edges().is_empty():
			result[room_id] = content
	return result


## Write generated dialogue files to the dialogue/ directory.
## Returns array of written file paths.
func write_dialogue_files(room_decls: Dictionary, output_dir: String = "res://dialogue/") -> PackedStringArray:
	var written: PackedStringArray = []
	var dialogues := generate_all(room_decls)

	for room_id in dialogues:
		var floor_dir := _get_floor_for_room(room_id)
		var path := "%s%s/%s.dialogue" % [output_dir, floor_dir, room_id]
		var content: String = dialogues[room_id]

		# Ensure directory exists
		var dir := DirAccess.open("res://")
		if dir:
			var full_dir := "%s%s" % [output_dir, floor_dir]
			if not dir.dir_exists(full_dir):
				dir.make_dir_recursive(full_dir)

		var file := FileAccess.open(path, FileAccess.WRITE)
		if file:
			file.store_string(content)
			file.close()
			written.append(path)

	return written


func _get_floor_for_room(room_id: String) -> String:
	match room_id:
		"front_gate", "garden", "chapel", "greenhouse", "carriage_house", "family_crypt":
			return "grounds"
		"foyer", "parlor", "dining_room", "kitchen":
			return "ground_floor"
		"upper_hallway", "master_bedroom", "library", "guest_room":
			return "upper_floor"
		"storage_basement", "boiler_room", "wine_cellar":
			return "basement"
		"attic_stairs", "attic_storage", "hidden_chamber":
			return "attic"
		_:
			return "misc"


func _escape_text(text: String) -> String:
	# Escape special dialogue manager characters
	return text.replace("\\", "\\\\").replace("\n", "\\n")
