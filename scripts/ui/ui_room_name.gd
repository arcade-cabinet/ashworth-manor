extends Control
## res://scripts/ui/ui_room_name.gd -- Room name display + notification toasts
## Extracted from ui_overlay.gd to keep each UI piece under 200 LOC.

const TEXT_COLOR := Color(0.85, 0.75, 0.55)
const DISPLAY_DURATION: float = 3.0

var _label: Label = null


func _ready() -> void:
	name = "RoomNameDisplay"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func _build() -> void:
	_label = Label.new()
	_label.name = "RoomNameLabel"
	_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_label.position = Vector2(-200, 40)
	_label.custom_minimum_size = Vector2(400, 50)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 32)
	_label.add_theme_color_override("font_color", TEXT_COLOR)
	_label.modulate.a = 0.0
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_label)


func show_room_name(room_name: String) -> void:
	if _label == null:
		return
	_label.text = room_name
	var tween: Tween = create_tween()
	tween.tween_property(_label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(DISPLAY_DURATION)
	tween.tween_property(_label, "modulate:a", 0.0, 1.0)
