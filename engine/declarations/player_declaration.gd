@tool
class_name PlayerDeclaration
extends Resource
## Player configuration -- camera, movement, input.

@export var camera_fov: float = 70.0
@export var camera_height: float = 1.7
@export var pitch_limit: float = 45.0
@export var move_speed: float = 3.0
@export var stop_distance: float = 0.3
@export var touch_sensitivity: float = 0.003
@export var tap_threshold: float = 15.0      # Pixels -- distinguishes tap from drag
@export var tap_time_threshold: float = 0.3  # Seconds
