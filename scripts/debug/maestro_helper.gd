extends CanvasLayer
## Debug-only packaged automation surface for Maestro.

const REFRESH_INTERVAL := 0.2
const PANEL_MARGIN := 18
const PANEL_WIDTH := 360
const PANEL_RIGHT_INSET := 180
const BUTTON_HEIGHT := 52
const STATUS_HEIGHT := 28
const HEADING_HEIGHT := 38

const LABEL_OVERRIDES := {
	"dismiss_document": "01 DISMISS",
	"gate_luggage": "02 OPEN VALISE",
	"parlor_fireplace": "08 LIGHT FIRE",
	"service_hatch_prop": "10 SERVICE HATCH",
}
const CRITICAL_PATH_ACTIONS := [
	{"id": "dismiss_document", "label": "01 DISMISS"},
	{"id": "gate_luggage", "label": "02 OPEN VALISE"},
	{"id": "go_drive_lower", "label": "03 DRIVE LOWER"},
	{"id": "go_drive_upper", "label": "04 DRIVE UPPER"},
	{"id": "go_front_steps", "label": "05 FRONT STEPS"},
	{"id": "go_foyer", "label": "06 FOYER"},
	{"id": "go_parlor", "label": "07 PARLOR"},
	{"id": "parlor_fireplace", "label": "08 LIGHT FIRE"},
	{"id": "go_kitchen", "label": "09 KITCHEN"},
	{"id": "service_hatch_prop", "label": "10 SERVICE HATCH"},
]

var _room_manager: Node = null
var _ui_overlay: Node = null
var _interaction_manager: Node = null
var _panel: PanelContainer = null
var _content: VBoxContainer = null
var _refresh_accum: float = 0.0
var _path_buttons: Dictionary = {}
var _layout_logged := false


func _ready() -> void:
	layer = 64
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	_build_panel()
	print("MaestroHelper active")


func _process(delta: float) -> void:
	_refresh_accum += delta
	if _refresh_accum < REFRESH_INTERVAL:
		return
	_refresh_accum = 0.0
	_refresh_controls()


func _build_panel() -> void:
	_panel = PanelContainer.new()
	_panel.name = "MaestroPanel"
	_panel.anchor_left = 1.0
	_panel.anchor_top = 0.0
	_panel.anchor_right = 1.0
	_panel.anchor_bottom = 1.0
	_panel.offset_left = -float(PANEL_WIDTH + PANEL_RIGHT_INSET)
	_panel.offset_top = PANEL_MARGIN
	_panel.offset_right = -float(PANEL_RIGHT_INSET)
	_panel.offset_bottom = -float(PANEL_MARGIN)
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_panel.z_index = 100
	_panel.self_modulate = Color(0.08, 0.06, 0.05, 0.92)
	add_child(_panel)

	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	_panel.add_child(margin)

	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 8)
	margin.add_child(_content)


func _refresh_controls() -> void:
	if _room_manager == null:
		_room_manager = _find_node("RoomManager")
	if _ui_overlay == null:
		_ui_overlay = _find_node("UIOverlay")
	if _interaction_manager == null:
		_interaction_manager = _find_node("InteractionManager")

	_path_buttons.clear()
	for child in _content.get_children():
		child.queue_free()

	_add_heading("Maestro Helper")
	_add_status_line("Screen", _screen_name())

	if GameManager.current_screen != GameManager.Screen.GAME:
		_add_status_line("State", "Not in game")
		return
	if _room_manager == null or not _room_manager.has_method("get_current_room"):
		_add_status_line("State", "Room manager unavailable")
		return
	var room: Node = _room_manager.get_current_room()
	if room == null:
		_add_status_line("State", "No current room")
		return

	_add_status_line("Room", _humanize_room_name(room.room_id))

	var document_open: bool = (
		_ui_overlay != null
		and _ui_overlay.has_method("is_document_open")
		and _ui_overlay.is_document_open()
	)
	_add_heading("Critical Path", 18)
	for action in CRITICAL_PATH_ACTIONS:
		var action_id: String = String(action.get("id", ""))
		var action_label: String = String(action.get("label", action_id))
		var button := _add_action_button(
			action_label,
			Callable(self, "_on_path_action_pressed").bind(action_id),
			not _is_path_action_available(action_id, room, document_open)
		)
		_path_buttons[action_id] = button

	if not _layout_logged:
		call_deferred("_log_path_button_points")

	if document_open:
		return


func _on_dismiss_document_pressed() -> void:
	if _interaction_manager != null and _interaction_manager.has_method("debug_dismiss_document"):
		_interaction_manager.debug_dismiss_document()


func _on_path_action_pressed(action_id: String) -> void:
	match action_id:
		"dismiss_document":
			_on_dismiss_document_pressed()
		"gate_luggage", "parlor_fireplace", "service_hatch_prop":
			_on_interactable_pressed(action_id)
		"go_drive_lower":
			_on_connection_pressed("drive_lower", "")
		"go_drive_upper":
			_on_connection_pressed("drive_upper", "")
		"go_front_steps":
			_on_connection_pressed("front_steps", "")
		"go_foyer":
			_on_connection_pressed("foyer", "")
		"go_parlor":
			_on_connection_pressed("parlor", "")
		"go_kitchen":
			_on_connection_pressed("kitchen", "")


func _on_interactable_pressed(interactable_id: String) -> void:
	if _interaction_manager != null and _interaction_manager.has_method("debug_invoke_interactable"):
		_interaction_manager.debug_invoke_interactable(interactable_id)


func _on_connection_pressed(target_room: String, connection_id: String) -> void:
	if _interaction_manager != null and _interaction_manager.has_method("debug_invoke_connection"):
		_interaction_manager.debug_invoke_connection(target_room, connection_id)


func _add_heading(text: String, font_size: int = 24) -> void:
	var label: Label = Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(0.0, HEADING_HEIGHT)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.97, 0.94, 0.82, 0.98))
	label.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.02, 0.98))
	label.add_theme_constant_override("outline_size", 3)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_content.add_child(label)


func _add_status_line(label_text: String, value: String) -> void:
	var label: Label = Label.new()
	label.text = "%s: %s" % [label_text, value]
	label.custom_minimum_size = Vector2(0.0, STATUS_HEIGHT)
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.85, 0.95))
	label.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.02, 0.98))
	label.add_theme_constant_override("outline_size", 2)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_content.add_child(label)


func _add_action_button(text: String, pressed_callback: Callable, disabled: bool = false) -> Button:
	var button: Button = Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0.0, BUTTON_HEIGHT)
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	button.disabled = disabled
	button.add_theme_font_size_override("font_size", 24)
	button.add_theme_color_override("font_color", Color(0.98, 0.97, 0.9, 1.0))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.98, 0.92, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(0.98, 0.97, 0.9, 1.0))
	button.add_theme_color_override("font_focus_color", Color(0.98, 0.97, 0.9, 1.0))
	button.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.02, 0.98))
	button.add_theme_constant_override("outline_size", 3)
	button.pressed.connect(pressed_callback)
	_content.add_child(button)
	return button


func _log_path_button_points() -> void:
	if _layout_logged:
		return
	var viewport := get_viewport()
	if viewport == null:
		return
	var visible_rect := viewport.get_visible_rect()
	if visible_rect.size.x <= 0.0 or visible_rect.size.y <= 0.0:
		return
	for action in CRITICAL_PATH_ACTIONS:
		var action_id: String = String(action.get("id", ""))
		var button: Button = _path_buttons.get(action_id, null)
		if button == null:
			continue
		var rect := button.get_global_rect()
		var center := rect.position + (rect.size * 0.5)
		var pct_x := snappedf((center.x / visible_rect.size.x) * 100.0, 0.1)
		var pct_y := snappedf((center.y / visible_rect.size.y) * 100.0, 0.1)
		print("MaestroHelper point %s = %.1f%%,%.1f%%" % [action_id, pct_x, pct_y])
	_layout_logged = true


func _label_for_interactable(interactable_id: String) -> String:
	if LABEL_OVERRIDES.has(interactable_id):
		return String(LABEL_OVERRIDES[interactable_id])
	return _humanize_identifier(interactable_id)


func _label_for_connection(target_room: String) -> String:
	return "Enter %s" % _humanize_room_name(target_room)


func _humanize_room_name(room_id: String) -> String:
	return _humanize_identifier(room_id)


func _humanize_identifier(raw_text: String) -> String:
	var words: PackedStringArray = raw_text.replace("-", "_").split("_", false)
	for i in words.size():
		words[i] = String(words[i]).capitalize()
	return " ".join(words)


func _screen_name() -> String:
	match GameManager.current_screen:
		GameManager.Screen.LANDING:
			return "Landing"
		GameManager.Screen.GAME:
			return "Game"
		GameManager.Screen.PAUSED:
			return "Paused"
	return "Unknown"


func _is_path_action_available(action_id: String, room: Node, document_open: bool) -> bool:
	match action_id:
		"dismiss_document":
			return document_open
		"gate_luggage", "parlor_fireplace", "service_hatch_prop":
			return not document_open and _room_has_interactable(room, action_id)
		"go_drive_lower":
			return not document_open and _room_has_connection(room, "drive_lower")
		"go_drive_upper":
			return not document_open and _room_has_connection(room, "drive_upper")
		"go_front_steps":
			return not document_open and _room_has_connection(room, "front_steps")
		"go_foyer":
			return not document_open and _room_has_connection(room, "foyer")
		"go_parlor":
			return not document_open and _room_has_connection(room, "parlor")
		"go_kitchen":
			return not document_open and _room_has_connection(room, "kitchen")
	return false


func _room_has_interactable(room: Node, interactable_id: String) -> bool:
	if room == null or not room.has_method("get_interactables"):
		return false
	for area in room.get_interactables():
		if area.has_meta("id") and str(area.get_meta("id")) == interactable_id:
			return true
	return false


func _room_has_connection(room: Node, target_room: String) -> bool:
	if room == null or not room.has_method("get_connections"):
		return false
	for area in room.get_connections():
		if area.has_meta("target_room") and str(area.get_meta("target_room")) == target_room:
			return true
	return false


func _find_node(node_name: String) -> Node:
	var tree: SceneTree = get_tree()
	if tree == null or tree.root == null:
		return null
	var stack: Array[Node] = [tree.root]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		if node.name == node_name:
			return node
		stack.append_array(node.get_children())
	return null
