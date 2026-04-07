extends Control
## res://scripts/ui_overlay.gd -- Thin coordinator for all UI components.
## Delegates to: ui_landing, ui_document, ui_pause, ui_ending, ui_room_name.
## Each component is under 200 LOC. This file is the public API.

signal document_closed

var _document: Control = null
var _pause: Control = null
var _ending: Control = null
var _room_name: Control = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_document = preload("res://scripts/ui/ui_document.gd").new()
	_pause = preload("res://scripts/ui/ui_pause.gd").new()
	_ending = preload("res://scripts/ui/ui_ending.gd").new()
	_room_name = preload("res://scripts/ui/ui_room_name.gd").new()

	add_child(_document)
	add_child(_room_name)
	add_child(_pause)
	add_child(_ending)

	# Forward document_closed signal
	if _document.has_signal("document_closed"):
		_document.document_closed.connect(func(): document_closed.emit())

	call_deferred("_connect_signals")


func _connect_signals() -> void:
	if GameManager.has_signal("screen_changed"):
		GameManager.screen_changed.connect(_on_screen_changed)
	if GameManager.has_signal("ending_triggered"):
		GameManager.ending_triggered.connect(_on_ending_triggered)
	if GameManager.has_signal("item_acquired"):
		GameManager.item_acquired.connect(_on_item_acquired)
	var room_mgr: Node = _find_node("RoomManager")
	if room_mgr and room_mgr.has_signal("room_loaded"):
		room_mgr.room_loaded.connect(_on_room_loaded)


func _input(event: InputEvent) -> void:
	# Pause toggle (only when game is active, not reading document)
	if _document and _document.is_document_open():
		return
	if event.is_action_pressed("pause"):
		if GameManager.current_screen == GameManager.Screen.GAME:
			_toggle_pause()
			get_viewport().set_input_as_handled()


# === Public API (backward-compatible) ===

func show_document(doc_title: String, content: String) -> void:
	if _document and _document.has_method("show_document"):
		_document.show_document(doc_title, content)


func hide_document() -> void:
	if _document and _document.has_method("hide_document"):
		_document.hide_document()


func show_room_name(room_name: String) -> void:
	if _room_name and _room_name.has_method("show_room_name"):
		_room_name.show_room_name(room_name)


func show_ending(ending_id: String) -> void:
	if _ending and _ending.has_method("show_ending"):
		_ending.show_ending(ending_id)


func toggle_pause_menu() -> void:
	_toggle_pause()


# === Signal Handlers ===

func _toggle_pause() -> void:
	if _pause and _pause.has_method("toggle_pause"):
		_pause.toggle_pause()


func _on_screen_changed(new_screen: String) -> void:
	match new_screen:
		"game":
			pass


func _on_ending_triggered(ending_id: String) -> void:
	show_ending(ending_id)


func _on_room_loaded(_room_id: String) -> void:
	var rm: Node = _find_node("RoomManager")
	if rm and rm.has_method("get_current_room"):
		var room = rm.get_current_room()
		if room and "room_name" in room:
			show_room_name(room.room_name)
			return
	show_room_name(_room_id.replace("_", " ").capitalize())


func _on_item_acquired(item_id: String) -> void:
	show_room_name("Acquired: " + item_id.replace("_", " ").capitalize())


# === Utility ===

func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
