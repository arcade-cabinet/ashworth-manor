extends Control
## res://scripts/ui/ui_document.gd -- Document overlay for reading notes, letters, paintings
## Extracted from ui_overlay.gd to keep each UI piece under 200 LOC.

signal document_closed

const PAPER_COLOR := Color(0.82, 0.76, 0.65)
const PAPER_TEXT := Color(0.2, 0.15, 0.1)

var _panel: PanelContainer = null
var _doc_title: Label = null
var _doc_content: RichTextLabel = null
var _is_open: bool = false


func _ready() -> void:
	name = "DocumentOverlay"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func _input(event: InputEvent) -> void:
	if not _is_open:
		return
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


func _build() -> void:
	_panel = PanelContainer.new()
	_panel.name = "DocumentPanel"
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.custom_minimum_size = Vector2(500, 350)
	_panel.position = Vector2(-250, -175)
	_panel.visible = false
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP

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
	_panel.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

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
	hint.text = "\u2014 Tap to close \u2014"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 12)
	hint.add_theme_color_override("font_color", Color(0.5, 0.4, 0.35))
	vbox.add_child(hint)

	add_child(_panel)


func show_document(doc_title: String, content: String) -> void:
	if _panel == null:
		return
	_doc_title.text = doc_title
	_doc_title.visible = not doc_title.is_empty()
	_doc_content.text = content
	_panel.visible = true
	_is_open = true


func hide_document() -> void:
	if _panel:
		_panel.visible = false
	_is_open = false
	document_closed.emit()


func is_document_open() -> bool:
	return _is_open
