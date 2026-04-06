extends Control
## res://scripts/ui/ui_landing.gd -- Landing screen: New Game / Continue buttons
## Extracted from ui_overlay.gd to keep each UI piece under 200 LOC.

const TEXT_COLOR := Color(0.85, 0.75, 0.55)
var _flicker_time: float = 0.0
var _title_label: Label = null


func _ready() -> void:
	name = "LandingScreen"
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()


func _process(delta: float) -> void:
	if not visible or _title_label == null:
		return
	_flicker_time += delta
	var flicker: float = 0.9 + sin(_flicker_time * 3.0) * 0.05 + sin(_flicker_time * 7.3) * 0.03
	_title_label.modulate.a = flicker


func _build() -> void:
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.02, 0.01, 0.02)
	add_child(bg)

	var vignette := ColorRect.new()
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.color = Color(0, 0, 0, 0)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vignette)

	var center := VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.position = Vector2(-250, -180)
	center.custom_minimum_size = Vector2(500, 360)
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 16)
	add_child(center)

	var line_top := HSeparator.new()
	line_top.custom_minimum_size = Vector2(300, 2)
	line_top.add_theme_color_override("separator", Color(0.4, 0.3, 0.2, 0.5))
	center.add_child(line_top)

	_title_label = Label.new()
	_title_label.name = "TitleLabel"
	_title_label.text = "ASHWORTH MANOR"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 52)
	_title_label.add_theme_color_override("font_color", TEXT_COLOR)
	center.add_child(_title_label)

	var subtitle := Label.new()
	subtitle.text = "Est. 1847 -- Abandoned 1891"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.5, 0.4, 0.3))
	center.add_child(subtitle)

	var line_bot := HSeparator.new()
	line_bot.custom_minimum_size = Vector2(300, 2)
	line_bot.add_theme_color_override("separator", Color(0.4, 0.3, 0.2, 0.5))
	center.add_child(line_bot)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	center.add_child(spacer)

	var btn_style := _make_button_style(Color(0.08, 0.06, 0.05), Color(0.4, 0.3, 0.2, 0.6))
	var btn_hover := _make_button_style(Color(0.15, 0.1, 0.08), Color(0.6, 0.45, 0.3, 0.8))

	var new_btn := _make_button("New Game", btn_style, btn_hover)
	new_btn.pressed.connect(_on_new_game)
	center.add_child(new_btn)

	var cont_btn := _make_button("Continue", btn_style, btn_hover)
	cont_btn.pressed.connect(_on_continue)
	cont_btn.visible = GameManager.has_save()
	cont_btn.name = "ContinueBtn"
	center.add_child(cont_btn)


func _make_button_style(bg: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.border_width_bottom = 1
	s.border_width_top = 1
	s.border_width_left = 1
	s.border_width_right = 1
	s.corner_radius_top_left = 2
	s.corner_radius_top_right = 2
	s.corner_radius_bottom_left = 2
	s.corner_radius_bottom_right = 2
	s.content_margin_top = 12.0
	s.content_margin_bottom = 12.0
	return s


func _make_button(label: String, normal: StyleBoxFlat, hover: StyleBoxFlat) -> Button:
	var btn := Button.new()
	btn.text = label
	btn.custom_minimum_size = Vector2(280, 0)
	btn.add_theme_font_size_override("font_size", 22)
	btn.add_theme_color_override("font_color", TEXT_COLOR)
	btn.add_theme_color_override("font_hover_color", Color(1.0, 0.85, 0.6))
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", hover)
	return btn


func _on_new_game() -> void:
	GameManager.new_game()
	visible = false
	var room_mgr: Node = _find_node("RoomManager")
	if room_mgr and room_mgr.has_method("load_room"):
		room_mgr.load_room("front_gate")
	var player: Node = _find_node("PlayerController")
	if player and player.has_method("set_room_position"):
		player.set_room_position(Vector3(0, 0, -12))
		player.rotation_degrees.y = 180.0


func _on_continue() -> void:
	if GameManager.load_game():
		visible = false
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
