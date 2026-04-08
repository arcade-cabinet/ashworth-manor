@tool
class_name SkyPresetDecl
extends Resource
## Declarative twilight/night sky profile for an authored estate region.

@export var preset_id: String = ""
@export var sky_mode: String = "generated_twilight" # generated_twilight, hdri_backed, legacy_sky
@export_file("*") var hdri_path: String = ""
@export var sky_color_top: Color = Color(0.02, 0.02, 0.06)
@export var sky_color_horizon: Color = Color(0.05, 0.04, 0.08)
@export var star_density: float = 0.3
@export var star_brightness: float = 0.6
@export var moon_size: float = 0.02
@export var moon_color: Color = Color(0.7, 0.75, 0.85)
@export var cloud_density: float = 0.4
@export var cloud_color: Color = Color(0.08, 0.07, 0.1)
@export var distant_glow_color: Color = Color(0.12, 0.08, 0.05)
@export var notes: String = ""
