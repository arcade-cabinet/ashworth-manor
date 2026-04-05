extends Control
## res://scripts/ui_overlay.gd — All UI: documents, room names, pause, landing, inventory, endings

const ROOM_NAME_DURATION: float = 3.0
const TEXT_COLOR := Color(0.85, 0.75, 0.55)
const BG_COLOR := Color(0.05, 0.03, 0.02, 0.92)
const PAPER_COLOR := Color(0.82, 0.76, 0.65)
const PAPER_TEXT := Color(0.2, 0.15, 0.1)

var _document_panel: PanelContainer = null
var _doc_title: Label = null
var _doc_content: RichTextLabel = null
var _room_name_label: Label = null
var _landing_panel: Control = null
var _pause_panel: Control = null
var _ending_panel: Control = null
var _is_document_open: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_landing_screen()
	_build_document_overlay()
	_build_room_name_label()
	_build_pause_menu()
	_build_ending_overlay()
	call_deferred("_connect_signals")

	# Title flicker timer
	_flicker_time = 0.0


var _flicker_time: float = 0.0

func _process(delta: float) -> void:
	# Title text subtle flicker (candlelight effect)
	if _landing_panel and _landing_panel.visible:
		_flicker_time += delta
		var title_label: Label = _landing_panel.get_node_or_null("@VBoxContainer@3/TitleLabel") if _landing_panel.has_node("@VBoxContainer@3/TitleLabel") else null
		if title_label == null:
			# Try finding by name
			title_label = _find_child_by_name(_landing_panel, "TitleLabel")
		if title_label:
			var flicker: float = 0.9 + sin(_flicker_time * 3.0) * 0.05 + sin(_flicker_time * 7.3) * 0.03
			title_label.modulate.a = flicker


func _find_child_by_name(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var found: Node = _find_child_by_name(child, target)
		if found:
			return found
	return null


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
	if _is_document_open:
		if event is InputEventMouseButton:
			var mb: InputEventMouseButton = event as InputEventMouseButton
			if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
				hide_document()
				get_viewport().set_input_as_handled()
				return
		if event is InputEventScreenTouch:
			var touch: InputEventScreenTouch = event as InputEventScreenTouch
			if touch.pressed:
				hide_document()
				get_viewport().set_input_as_handled()
				return
	if event.is_action_pressed("pause"):
		if GameManager.current_screen == GameManager.Screen.GAME:
			_toggle_pause()
			get_viewport().set_input_as_handled()


# === Landing Screen ===

func _build_landing_screen() -> void:
	_landing_panel = Control.new()
	_landing_panel.name = "LandingScreen"
	_landing_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_landing_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	# Dark vignette background
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.02, 0.01, 0.02)
	_landing_panel.add_child(bg)

	# Radial vignette overlay for depth
	var vignette := ColorRect.new()
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.color = Color(0, 0, 0, 0)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_landing_panel.add_child(vignette)

	var center := VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.position = Vector2(-250, -180)
	center.custom_minimum_size = Vector2(500, 360)
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 16)
	_landing_panel.add_child(center)

	# Decorative line above title
	var line_top := HSeparator.new()
	line_top.custom_minimum_size = Vector2(300, 2)
	line_top.add_theme_color_override("separator", Color(0.4, 0.3, 0.2, 0.5))
	center.add_child(line_top)

	var title := Label.new()
	title.name = "TitleLabel"
	title.text = "ASHWORTH MANOR"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", TEXT_COLOR)
	center.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Est. 1847 — Abandoned 1891"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.5, 0.4, 0.3))
	center.add_child(subtitle)

	# Decorative line below subtitle
	var line_bot := HSeparator.new()
	line_bot.custom_minimum_size = Vector2(300, 2)
	line_bot.add_theme_color_override("separator", Color(0.4, 0.3, 0.2, 0.5))
	center.add_child(line_bot)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	center.add_child(spacer)

	# Styled buttons
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.08, 0.06, 0.05)
	btn_style.border_color = Color(0.4, 0.3, 0.2, 0.6)
	btn_style.border_width_bottom = 1
	btn_style.border_width_top = 1
	btn_style.border_width_left = 1
	btn_style.border_width_right = 1
	btn_style.corner_radius_top_left = 2
	btn_style.corner_radius_top_right = 2
	btn_style.corner_radius_bottom_left = 2
	btn_style.corner_radius_bottom_right = 2
	btn_style.content_margin_top = 12.0
	btn_style.content_margin_bottom = 12.0

	var btn_hover := StyleBoxFlat.new()
	btn_hover.bg_color = Color(0.15, 0.1, 0.08)
	btn_hover.border_color = Color(0.6, 0.45, 0.3, 0.8)
	btn_hover.border_width_bottom = 1
	btn_hover.border_width_top = 1
	btn_hover.border_width_left = 1
	btn_hover.border_width_right = 1
	btn_hover.corner_radius_top_left = 2
	btn_hover.corner_radius_top_right = 2
	btn_hover.corner_radius_bottom_left = 2
	btn_hover.corner_radius_bottom_right = 2
	btn_hover.content_margin_top = 12.0
	btn_hover.content_margin_bottom = 12.0

	var new_btn := Button.new()
	new_btn.text = "New Game"
	new_btn.custom_minimum_size = Vector2(280, 0)
	new_btn.add_theme_font_size_override("font_size", 22)
	new_btn.add_theme_color_override("font_color", TEXT_COLOR)
	new_btn.add_theme_color_override("font_hover_color", Color(1.0, 0.85, 0.6))
	new_btn.add_theme_stylebox_override("normal", btn_style)
	new_btn.add_theme_stylebox_override("hover", btn_hover)
	new_btn.add_theme_stylebox_override("pressed", btn_hover)
	new_btn.pressed.connect(_on_new_game)
	center.add_child(new_btn)

	var cont_btn := Button.new()
	cont_btn.text = "Continue"
	cont_btn.custom_minimum_size = Vector2(280, 0)
	cont_btn.add_theme_font_size_override("font_size", 22)
	cont_btn.add_theme_color_override("font_color", TEXT_COLOR)
	cont_btn.add_theme_color_override("font_hover_color", Color(1.0, 0.85, 0.6))
	cont_btn.add_theme_stylebox_override("normal", btn_style)
	cont_btn.add_theme_stylebox_override("hover", btn_hover)
	cont_btn.add_theme_stylebox_override("pressed", btn_hover)
	cont_btn.pressed.connect(_on_continue)
	cont_btn.visible = GameManager.has_save()
	cont_btn.name = "ContinueBtn"
	center.add_child(cont_btn)

	add_child(_landing_panel)


func _on_new_game() -> void:
	GameManager.new_game()
	_landing_panel.visible = false
	var room_mgr: Node = _find_node("RoomManager")
	if room_mgr and room_mgr.has_method("load_room"):
		room_mgr.load_room("front_gate")
	var player: Node = _find_node("PlayerController")
	if player and player.has_method("set_room_position"):
		player.set_room_position(Vector3(0, 0, -12))
		# Face the mansion (Y=180 looks along +Z in Godot)
		player.rotation_degrees.y = 180.0


func _on_continue() -> void:
	if GameManager.load_game():
		_landing_panel.visible = false
		var room_mgr: Node = _find_node("RoomManager")
		if room_mgr and room_mgr.has_method("load_room"):
			room_mgr.load_room(GameManager.current_room)


# === Document Overlay ===

func _build_document_overlay() -> void:
	_document_panel = PanelContainer.new()
	_document_panel.name = "DocumentPanel"
	_document_panel.set_anchors_preset(Control.PRESET_CENTER)
	_document_panel.custom_minimum_size = Vector2(500, 350)
	_document_panel.position = Vector2(-250, -175)
	_document_panel.visible = false
	_document_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var style := StyleBoxFlat.new()
	style.bg_color = PAPER_COLOR
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 30.0
	style.content_margin_right = 30.0
	style.content_margin_top = 25.0
	style.content_margin_bottom = 25.0
	style.shadow_color = Color(0, 0, 0, 0.5)
	style.shadow_size = 10
	_document_panel.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_document_panel.add_child(vbox)

	_doc_title = Label.new()
	_doc_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_doc_title.add_theme_font_size_override("font_size", 24)
	_doc_title.add_theme_color_override("font_color", PAPER_TEXT)
	vbox.add_child(_doc_title)

	var separator := HSeparator.new()
	vbox.add_child(separator)

	_doc_content = RichTextLabel.new()
	_doc_content.bbcode_enabled = false
	_doc_content.fit_content = true
	_doc_content.custom_minimum_size = Vector2(440, 200)
	_doc_content.add_theme_font_size_override("normal_font_size", 16)
	_doc_content.add_theme_color_override("default_color", PAPER_TEXT)
	vbox.add_child(_doc_content)

	var hint := Label.new()
	hint.text = "— Tap to close —"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 12)
	hint.add_theme_color_override("font_color", Color(0.5, 0.4, 0.35))
	vbox.add_child(hint)

	add_child(_document_panel)


func show_document(doc_title: String, content: String) -> void:
	if _document_panel == null:
		return
	_doc_title.text = doc_title
	_doc_title.visible = not doc_title.is_empty()
	_doc_content.text = content
	_document_panel.visible = true
	_is_document_open = true


func hide_document() -> void:
	if _document_panel:
		_document_panel.visible = false
	_is_document_open = false


# === Room Name Display ===

func _build_room_name_label() -> void:
	_room_name_label = Label.new()
	_room_name_label.name = "RoomNameLabel"
	_room_name_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_room_name_label.position = Vector2(-200, 40)
	_room_name_label.custom_minimum_size = Vector2(400, 50)
	_room_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_room_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_room_name_label.add_theme_font_size_override("font_size", 32)
	_room_name_label.add_theme_color_override("font_color", TEXT_COLOR)
	_room_name_label.modulate.a = 0.0
	_room_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_room_name_label)


func show_room_name(room_name: String) -> void:
	if _room_name_label == null:
		return
	_room_name_label.text = room_name
	var tween: Tween = create_tween()
	tween.tween_property(_room_name_label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(ROOM_NAME_DURATION)
	tween.tween_property(_room_name_label, "modulate:a", 0.0, 1.0)


# === Pause Menu ===

func _build_pause_menu() -> void:
	_pause_panel = PanelContainer.new()
	_pause_panel.name = "PauseMenu"
	_pause_panel.set_anchors_preset(Control.PRESET_CENTER)
	_pause_panel.custom_minimum_size = Vector2(300, 280)
	_pause_panel.position = Vector2(-150, -140)
	_pause_panel.visible = false
	_pause_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_panel.mouse_filter = Control.MOUSE_FILTER_STOP

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
	_pause_panel.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_pause_panel.add_child(vbox)

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
	var inv_label := Label.new()
	inv_label.name = "InventoryLabel"
	inv_label.text = "Inventory: (empty)"
	inv_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inv_label.add_theme_font_size_override("font_size", 14)
	inv_label.add_theme_color_override("font_color", Color(0.6, 0.5, 0.4))
	inv_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	inv_label.custom_minimum_size = Vector2(200, 40)
	inv_label.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(inv_label)

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
	quit_btn.text = "Quit to Menu"
	quit_btn.custom_minimum_size = Vector2(200, 40)
	quit_btn.pressed.connect(_on_quit_to_menu)
	quit_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	vbox.add_child(quit_btn)

	add_child(_pause_panel)


func _toggle_pause() -> void:
	if _pause_panel == null:
		return
	var is_paused: bool = not get_tree().paused
	get_tree().paused = is_paused
	_pause_panel.visible = is_paused
	GameManager.current_screen = GameManager.Screen.PAUSED if is_paused else GameManager.Screen.GAME

	# Update inventory display
	if is_paused:
		var inv_label: Label = _find_child_by_name(_pause_panel, "InventoryLabel")
		if inv_label:
			if GameManager.inventory.is_empty():
				inv_label.text = "Inventory: (empty)"
			else:
				var items: String = ""
				for item_id in GameManager.inventory:
					if not items.is_empty():
						items += ", "
					items += item_id.replace("_", " ").capitalize()
				inv_label.text = "Inventory: " + items


func _on_resume() -> void:
	get_tree().paused = false
	_pause_panel.visible = false
	GameManager.current_screen = GameManager.Screen.GAME


func _on_quit_to_menu() -> void:
	get_tree().paused = false
	_pause_panel.visible = false
	_landing_panel.visible = true
	GameManager.current_screen = GameManager.Screen.LANDING


# === Ending Overlay ===

func _build_ending_overlay() -> void:
	_ending_panel = Control.new()
	_ending_panel.name = "EndingOverlay"
	_ending_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_ending_panel.visible = false
	_ending_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.95)
	_ending_panel.add_child(bg)

	var center := VBoxContainer.new()
	center.name = "EndingContent"
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.position = Vector2(-300, -100)
	center.custom_minimum_size = Vector2(600, 200)
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 20)
	_ending_panel.add_child(center)

	add_child(_ending_panel)


func _on_ending_triggered(ending_id: String) -> void:
	show_ending(ending_id)


func show_ending(ending_id: String) -> void:
	if _ending_panel == null:
		return
	var content_container: VBoxContainer = _ending_panel.get_node_or_null("EndingContent")
	if content_container == null:
		return
	for child in content_container.get_children():
		child.queue_free()

	var texts: Array[String] = _get_ending_texts(ending_id)
	_ending_panel.visible = true
	_ending_panel.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(_ending_panel, "modulate:a", 1.0, 2.0)
	tween.tween_interval(1.0)

	for text_line in texts:
		var label := Label.new()
		label.text = text_line
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_color", TEXT_COLOR)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.modulate.a = 0.0
		content_container.add_child(label)
		tween.tween_property(label, "modulate:a", 1.0, 1.5)
		tween.tween_interval(3.0)

	tween.tween_interval(5.0)
	tween.tween_property(_ending_panel, "modulate:a", 0.0, 3.0)


func _get_ending_texts(ending_id: String) -> Array[String]:
	match ending_id:
		"freedom":
			return [
				"The doll cracks open. Light pours from inside.",
				"The drawings on the walls fade.",
				"Elizabeth's voice: \"Thank you.\"",
				"For the first time, dawn light touches Ashworth Manor.",
				"December 25th, 1891. Christmas Morning.",
			]
		"escape":
			return [
				"You push through the front door into the cold night.",
				"Every window in the mansion is now lit.",
				"A silhouette in every frame. Elizabeth.",
				"The compulsion to return is already building.",
				"You came back.",
			]
		"joined":
			return [
				"The front door won't open. Every door — sealed.",
				"The clock ticks to 3:34 AM.",
				"In every mirror: Elizabeth. Smiling.",
				"\"Welcome home.\"",
				"Two silhouettes in the attic window now.",
			]
		_:
			return ["The End."]


# === Signal Handlers ===

func _on_screen_changed(new_screen: String) -> void:
	if new_screen == "game":
		_landing_panel.visible = false


func _on_room_loaded(_room_id: String) -> void:
	# Read room_name from the live room scene's exported var
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
	var root_node: Node = get_tree().root
	return _recursive_find(root_node, node_name)


func _recursive_find(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var found: Node = _recursive_find(child, target_name)
		if found != null:
			return found
	return null
