@tool
class_name SkyDeclaration
extends Resource
## PSX sky configuration for outdoor rooms.

@export var enabled: bool = true              # false for indoor rooms
@export var shader_path: String = "res://shaders/psx_sky.gdshader"

# Night sky parameters (uniforms passed to sky shader)
@export var sky_color_top: Color = Color(0.02, 0.02, 0.06)
@export var sky_color_horizon: Color = Color(0.05, 0.04, 0.08)
@export var star_density: float = 0.3
@export var star_brightness: float = 0.6
@export var moon_size: float = 0.02
@export var moon_color: Color = Color(0.7, 0.75, 0.85)
@export var cloud_density: float = 0.4
@export var cloud_color: Color = Color(0.08, 0.07, 0.1)
@export var dither_strength: float = 0.3
@export var color_depth: float = 15.0
