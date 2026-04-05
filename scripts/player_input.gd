extends Node
## res://scripts/player_input.gd -- Touch/mouse input handling for first-person player
## Emits signals consumed by player_controller.gd

signal tap_detected(screen_pos: Vector2)
signal camera_drag(relative: Vector2)

const TAP_THRESHOLD: float = 15.0
const TAP_TIME_THRESHOLD: float = 0.3

var _touch_start_pos: Vector2 = Vector2.ZERO
var _touch_start_time: float = 0.0
var _is_touching: bool = false
var _touch_index: int = -1
var _mouse_dragging: bool = false


func handle_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event as InputEventScreenTouch
		if touch.pressed:
			_touch_start_pos = touch.position
			_touch_start_time = Time.get_ticks_msec() / 1000.0
			_is_touching = true
			_touch_index = touch.index
		elif _is_touching and touch.index == _touch_index:
			var dist: float = touch.position.distance_to(_touch_start_pos)
			var elapsed: float = (Time.get_ticks_msec() / 1000.0) - _touch_start_time
			if dist < TAP_THRESHOLD and elapsed < TAP_TIME_THRESHOLD:
				tap_detected.emit(touch.position)
			_is_touching = false
			_touch_index = -1

	if event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event as InputEventScreenDrag
		if _is_touching and drag.index == _touch_index:
			camera_drag.emit(drag.relative)

	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			_mouse_dragging = mb.pressed
		elif mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			tap_detected.emit(mb.position)

	if event is InputEventMouseMotion:
		var mm: InputEventMouseMotion = event as InputEventMouseMotion
		if _mouse_dragging:
			camera_drag.emit(mm.relative)
