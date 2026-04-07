extends Control
## res://scripts/ui/ui_pause.gd -- Pause menu with inventory display, quest progress, save
## Extracted from ui_overlay.gd to keep each UI piece under 200 LOC.

const TEXT_COLOR := Color(0.85, 0.75, 0.55)
const BG_COLOR := Color(0.05, 0.03, 0.02, 0.92)

var _panel: PanelContainer = null
var _inv_label: Label = null
var _quest_label: Label = null


func _ready() -> void:
	name = "PauseMenu"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func _build() -> void:
	_panel = PanelContainer.new()
	_panel.name = "PausePanel"
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.custom_minimum_size = Vector2(340, 380)
	_panel.position = Vector2(-170, -190)
	_panel.visible = false
	_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var style := StyleBoxFlat.new()
	style.bg_color = BG_COLOR
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 20.0
	style.content_margin_right = 20.0
	style.content_margin_top = 20.0
	style.content_margin_bottom = 20.0
	_panel.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_panel.add_child(vbox)

	var title := Label.new()
	title.text = "PAUSED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", TEXT_COLOR)
	vbox.add_child(title)

	var resume_btn := Button.new()
	resume_btn.text = "Resume"
	resume_btn.custom_minimum_size = Vector2(200, 40)
	resume_btn.pressed.connect(_on_resume)
	resume_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(resume_btn)

	# Inventory section
	_inv_label = Label.new()
	_inv_label.name = "InventoryLabel"
	_inv_label.text = "Inventory: (empty)"
	_inv_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_inv_label.add_theme_font_size_override("font_size", 14)
	_inv_label.add_theme_color_override("font_color", Color(0.6, 0.5, 0.4))
	_inv_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_inv_label.custom_minimum_size = Vector2(200, 40)
	_inv_label.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(_inv_label)

	# Quest progress section
	_quest_label = Label.new()
	_quest_label.name = "QuestLabel"
	_quest_label.text = "Quests: none"
	_quest_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_quest_label.add_theme_font_size_override("font_size", 14)
	_quest_label.add_theme_color_override("font_color", Color(0.55, 0.5, 0.4))
	_quest_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_quest_label.custom_minimum_size = Vector2(200, 40)
	_quest_label.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(_quest_label)

	var sep := HSeparator.new()
	sep.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(sep)

	var save_btn := Button.new()
	save_btn.text = "Save Game"
	save_btn.custom_minimum_size = Vector2(200, 40)
	save_btn.pressed.connect(func(): GameManager.save_game())
	save_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(save_btn)

	var quit_btn := Button.new()
	quit_btn.text = "Return to Gate"
	quit_btn.custom_minimum_size = Vector2(200, 40)
	quit_btn.pressed.connect(_on_quit_to_menu)
	quit_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(quit_btn)

	add_child(_panel)


func toggle_pause() -> void:
	if _panel == null:
		return
	var is_paused: bool = not get_tree().paused
	get_tree().paused = is_paused
	_panel.visible = is_paused
	GameManager.current_screen = GameManager.Screen.PAUSED if is_paused else GameManager.Screen.GAME

	if is_paused:
		_update_inventory_display()
		_update_quest_display()


func _update_inventory_display() -> void:
	if _inv_label == null:
		return
	var items: Array[String] = GameManager.get_inventory_items()
	if items.is_empty():
		_inv_label.text = "Inventory: (empty)"
	else:
		var text: String = ""
		for item_id in items:
			if not text.is_empty():
				text += ", "
			text += item_id.replace("_", " ").capitalize()
		_inv_label.text = "Inventory: " + text


func _update_quest_display() -> void:
	if _quest_label == null:
		return
	var qh: Node = _find_node("QuestHandler")
	if qh == null or not qh.has_method("get_quest_count"):
		_quest_label.text = "Quests: none"
		return
	var counts: Dictionary = qh.get_quest_count()
	var active_names: Array[String] = qh.get_active_quest_names()
	var completed: int = counts.get("completed", 0)

	if active_names.is_empty() and completed == 0:
		_quest_label.text = "Quests: none"
		return

	var parts: Array[String] = []
	if not active_names.is_empty():
		parts.append("Active: " + ", ".join(active_names))
	if completed > 0:
		parts.append("Solved: %d/6" % completed)
	_quest_label.text = "\n".join(parts)


func _on_resume() -> void:
	get_tree().paused = false
	_panel.visible = false
	GameManager.current_screen = GameManager.Screen.GAME


func _on_quit_to_menu() -> void:
	get_tree().paused = false
	_panel.visible = false
	GameManager.abandon_to_front_gate()
	var room_mgr: Node = _find_node("RoomManager")
	if room_mgr and room_mgr.has_method("load_room"):
		room_mgr.load_room(GameManager.current_room)


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
