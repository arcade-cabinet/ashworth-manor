@tool
class_name EnvironmentDeclaration
extends Resource
## Per-area environment preset (sky, fog, tonemap, lighting).

# Background
@export var background_mode: String = "sky"  # "sky", "color", "keep"
@export var background_color: Color = Color(0, 0, 0)

# Sky
@export var sky: SkyDeclaration = null

# Fog
@export var fog_enabled: bool = true
@export var fog_density: float = 0.006
@export var fog_color: Color = Color(0.15, 0.12, 0.1)
@export var volumetric_fog: bool = false

# Tonemap
@export var tonemap_mode: String = "aces"    # "linear", "reinhard", "filmic", "aces"
@export var tonemap_exposure: float = 1.0

# Glow/Bloom
@export var glow_enabled: bool = true
@export var glow_threshold: float = 0.75
@export var glow_intensity: float = 0.2

# SSAO
@export var ssao_enabled: bool = true
@export var ssao_radius: float = 1.0
@export var ssao_intensity: float = 0.5

# Ambient light
@export var ambient_source: String = "sky"   # "background", "disabled", "color", "sky"
@export var ambient_color: Color = Color(0.1, 0.08, 0.06)
@export var ambient_energy: float = 0.3

# Vignette (applied by PSX post-process, not Environment)
@export var vignette_color: Color = Color(0.12, 0.1, 0.08)
@export var vignette_weight: float = 0.8
