extends Control
## res://scripts/ui/ui_ending.gd -- Ending overlay: typewriter-style ending sequences
## Extracted from ui_overlay.gd to keep each UI piece under 200 LOC.

const TEXT_COLOR := Color(0.85, 0.75, 0.55)

var _panel: Control = null
var _content: VBoxContainer = null


func _ready() -> void:
	name = "EndingOverlay"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func _build() -> void:
	_panel = Control.new()
	_panel.name = "EndingPanel"
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.visible = false
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.95)
	_panel.add_child(bg)

	_content = VBoxContainer.new()
	_content.name = "EndingContent"
	_content.set_anchors_preset(Control.PRESET_CENTER)
	_content.position = Vector2(-300, -100)
	_content.custom_minimum_size = Vector2(600, 200)
	_content.alignment = BoxContainer.ALIGNMENT_CENTER
	_content.add_theme_constant_override("separation", 20)
	_panel.add_child(_content)

	add_child(_panel)


func show_ending(ending_id: String) -> void:
	if _panel == null or _content == null:
		return
	# Clear previous ending text
	for child in _content.get_children():
		child.queue_free()

	var texts: Array[String] = _get_ending_texts(ending_id)
	_panel.visible = true
	_panel.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(_panel, "modulate:a", 1.0, 2.0)
	tween.tween_interval(1.0)

	for text_line in texts:
		var label := Label.new()
		label.text = text_line
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_color", TEXT_COLOR)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.modulate.a = 0.0
		_content.add_child(label)
		tween.tween_property(label, "modulate:a", 1.0, 1.5)
		tween.tween_interval(3.0)

	tween.tween_interval(5.0)
	tween.tween_property(_panel, "modulate:a", 0.0, 3.0)


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
				"The front door won't open. Every door \u2014 sealed.",
				"The clock ticks to 3:34 AM.",
				"In every mirror: Elizabeth. Smiling.",
				"\"Welcome home.\"",
				"Two silhouettes in the attic window now.",
			]
		_:
			return ["The End."]
