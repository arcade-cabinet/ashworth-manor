class_name PSXBridge
extends RefCounted
## Bridges the godot-psx addon to the declaration engine.
## 1. psx_dither.gdshader -- applied globally via CanvasLayer (already in main.tscn)
## 2. psx_fade.gdshader -- room transitions controlled by room_assembler
## 3. psx_sky.gdshader -- exterior rooms get PSX sky material

const DITHER_SHADER := "res://shaders/psx_dither.gdshader"
const FADE_SHADER := "res://shaders/psx_fade.gdshader"
const SKY_SHADER := "res://shaders/psx_sky.gdshader"

## Default PSX dither parameters (match main.tscn values)
const DEFAULT_COLOR_DEPTH := 5
const DEFAULT_DITHERING := true

## Fade parameters for room transitions
const FADE_DURATION := 0.8  # seconds


## Create a ShaderMaterial for PSX sky from SkyDeclaration.
## Used by WorldEnvironment for exterior rooms.
func create_sky_material(sky_decl: SkyDeclaration) -> ShaderMaterial:
	var shader := load(SKY_SHADER) as Shader
	if not shader:
		push_warning("PSXBridge: Could not load sky shader")
		return null

	var mat := ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("sky_color_top", sky_decl.sky_color_top)
	mat.set_shader_parameter("sky_color_horizon", sky_decl.sky_color_horizon)
	mat.set_shader_parameter("star_density", sky_decl.star_density)
	mat.set_shader_parameter("star_brightness", sky_decl.star_brightness)
	mat.set_shader_parameter("moon_size", sky_decl.moon_size)
	mat.set_shader_parameter("moon_color", sky_decl.moon_color)
	mat.set_shader_parameter("cloud_density", sky_decl.cloud_density)
	mat.set_shader_parameter("cloud_color", sky_decl.cloud_color)
	mat.set_shader_parameter("color_depth", sky_decl.color_depth)
	mat.set_shader_parameter("dither_strength", sky_decl.dither_strength)

	return mat


## Create a Sky resource with PSX shader for exterior WorldEnvironment.
func create_psx_sky(sky_decl: SkyDeclaration) -> Sky:
	var mat := create_sky_material(sky_decl)
	if not mat:
		return null

	var sky := Sky.new()
	sky.sky_material = mat
	# Static sky -- radiance cubemap renders once and caches
	sky.radiance_size = Sky.RADIANCE_SIZE_64

	return sky


## Get the fade shader material for room transitions.
func create_fade_material() -> ShaderMaterial:
	var shader := load(FADE_SHADER) as Shader
	if not shader:
		push_warning("PSXBridge: Could not load fade shader")
		return null

	var mat := ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("fade_amount", 0.0)
	return mat


## Should this room use the PSX sky or keep background?
func should_use_psx_sky(room_decl: RoomDeclaration) -> bool:
	return room_decl.is_exterior


## Build a Godot Environment resource from EnvironmentDeclaration.
## Maps declaration fields to Godot Environment properties.
func build_environment(env_decl: EnvironmentDeclaration) -> Environment:
	var env := Environment.new()

	# Background mode
	match env_decl.background_mode:
		"sky":
			env.background_mode = Environment.BG_SKY
			if env_decl.sky:
				var sky := create_psx_sky(env_decl.sky)
				if sky:
					env.sky = sky
		"color":
			env.background_mode = Environment.BG_COLOR
			env.background_color = env_decl.background_color
		"keep":
			env.background_mode = Environment.BG_KEEP

	# Fog
	env.fog_enabled = env_decl.fog_enabled
	if env_decl.fog_enabled:
		env.fog_light_color = env_decl.fog_color
		env.fog_density = env_decl.fog_density
		env.volumetric_fog_enabled = env_decl.volumetric_fog

	# Tonemap
	match env_decl.tonemap_mode:
		"aces":
			env.tonemap_mode = Environment.TONE_MAP_ACES
		"filmic":
			env.tonemap_mode = Environment.TONE_MAP_FILMIC
		"reinhard":
			env.tonemap_mode = Environment.TONE_MAP_REINHARDT
		_:
			env.tonemap_mode = Environment.TONE_MAP_LINEAR
	env.tonemap_exposure = env_decl.tonemap_exposure

	# Glow
	env.glow_enabled = env_decl.glow_enabled
	if env_decl.glow_enabled:
		env.glow_hdr_threshold = env_decl.glow_threshold
		env.glow_intensity = env_decl.glow_intensity

	# SSAO
	env.ssao_enabled = env_decl.ssao_enabled
	if env_decl.ssao_enabled:
		env.ssao_radius = env_decl.ssao_radius
		env.ssao_intensity = env_decl.ssao_intensity

	# Ambient light
	match env_decl.ambient_source:
		"sky":
			env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
		"color":
			env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		"background":
			env.ambient_light_source = Environment.AMBIENT_SOURCE_BG
		_:
			env.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED
	env.ambient_light_color = env_decl.ambient_color
	env.ambient_light_energy = env_decl.ambient_energy

	return env
