class_name EstateEnvironmentRegistry
extends RefCounted
## Resolver for terrain and sky preset resources used by the shared substrate.

const TerrainPresetDecl = preload("res://engine/declarations/terrain_preset_decl.gd")
const SkyPresetDecl = preload("res://engine/declarations/sky_preset_decl.gd")
const SkyDeclaration = preload("res://engine/declarations/sky_declaration.gd")

const TERRAIN_ROOT := "res://declarations/terrain_presets"
const SKY_ROOT := "res://declarations/sky_presets"


static func terrain_preset_path(preset_id: String) -> String:
	if preset_id.is_empty():
		return ""
	return "%s/%s.tres" % [TERRAIN_ROOT, preset_id]


static func sky_preset_path(preset_id: String) -> String:
	if preset_id.is_empty():
		return ""
	return "%s/%s.tres" % [SKY_ROOT, preset_id]


static func load_terrain_preset(preset_id: String) -> TerrainPresetDecl:
	var path := terrain_preset_path(preset_id)
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path) as TerrainPresetDecl


static func load_sky_preset(preset_id: String) -> SkyPresetDecl:
	var path := sky_preset_path(preset_id)
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path) as SkyPresetDecl


static func build_sky_declaration(preset_id: String, fallback: SkyDeclaration = null) -> SkyDeclaration:
	if preset_id.is_empty():
		return fallback
	var preset := load_sky_preset(preset_id)
	if preset == null:
		return fallback

	var sky_decl := SkyDeclaration.new()
	if fallback != null:
		sky_decl.enabled = fallback.enabled
		sky_decl.shader_path = fallback.shader_path
		sky_decl.dither_strength = fallback.dither_strength
		sky_decl.color_depth = fallback.color_depth

	sky_decl.hdri_path = preset.hdri_path
	sky_decl.sky_color_top = preset.sky_color_top
	sky_decl.sky_color_horizon = preset.sky_color_horizon
	sky_decl.star_density = preset.star_density
	sky_decl.star_brightness = preset.star_brightness
	sky_decl.moon_size = preset.moon_size
	sky_decl.moon_color = preset.moon_color
	sky_decl.cloud_density = preset.cloud_density
	sky_decl.cloud_color = preset.cloud_color
	return sky_decl
