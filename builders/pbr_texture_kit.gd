class_name PBRTextureKit
extends RefCounted

const STANDARD_SLOTS := [
	"albedo",
	"normal",
	"roughness",
	"opacity",
	"height",
	"thickness",
	"detail",
	"hdri",
	"ao",
]

static var MAP_SUFFIXES := {
	"normal": PackedStringArray(["_NormalGL", "_normal_gl"]),
	"roughness": PackedStringArray(["_Roughness", "_roughness"]),
	"ao": PackedStringArray(["_AmbientOcclusion", "_ao"]),
	"opacity": PackedStringArray(["_Opacity", "_opacity"]),
	"height": PackedStringArray(["_Displacement", "_displacement", "_Height", "_height"]),
	"thickness": PackedStringArray(["_Thickness", "_thickness"]),
}

static var COLOR_SUFFIXES := PackedStringArray(["_Color", "_color", "_Albedo", "_albedo"])


static func get_standard_slots() -> PackedStringArray:
	return PackedStringArray(STANDARD_SLOTS)


static func is_supported_slot(slot_key: String) -> bool:
	return STANDARD_SLOTS.has(_normalize_slot_key(slot_key))


static func build_material(texture_path: String, options: Dictionary = {}) -> StandardMaterial3D:
	var slots := normalize_slots(options.get("slots", {}))
	var resolved_path := _resolve_texture_path(texture_path)
	if slots.get("albedo", "").is_empty() and not resolved_path.is_empty():
		slots["albedo"] = resolved_path
		slots["normal"] = _resolve_texture_path(String(options.get("normal_path", _infer_map_path(resolved_path, "normal"))))
		slots["roughness"] = _resolve_texture_path(String(options.get("roughness_path", _infer_map_path(resolved_path, "roughness"))))
		slots["ao"] = _resolve_texture_path(String(options.get("ao_path", _infer_map_path(resolved_path, "ao"))))
		slots["opacity"] = _resolve_texture_path(String(options.get("opacity_path", _infer_map_path(resolved_path, "opacity"))))
		slots["height"] = _resolve_texture_path(String(options.get("height_path", options.get("displacement_path", _infer_map_path(resolved_path, "height")))))
		slots["thickness"] = _resolve_texture_path(String(options.get("thickness_path", _infer_map_path(resolved_path, "thickness"))))
	return build_material_from_slots(slots, options)


static func build_material_from_slots(slots: Dictionary, options: Dictionary = {}) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	apply_slots(material, slots, options)
	return material


static func apply_maps(material: StandardMaterial3D, texture_path: String, options: Dictionary = {}) -> void:
	if material == null:
		return
	var slots := normalize_slots(options.get("slots", {}))
	var resolved_path := _resolve_texture_path(texture_path)
	if slots.get("albedo", "").is_empty() and not resolved_path.is_empty():
		slots["albedo"] = resolved_path
		slots["normal"] = _resolve_texture_path(String(options.get("normal_path", _infer_map_path(resolved_path, "normal"))))
		slots["roughness"] = _resolve_texture_path(String(options.get("roughness_path", _infer_map_path(resolved_path, "roughness"))))
		slots["ao"] = _resolve_texture_path(String(options.get("ao_path", _infer_map_path(resolved_path, "ao"))))
		slots["opacity"] = _resolve_texture_path(String(options.get("opacity_path", _infer_map_path(resolved_path, "opacity"))))
		slots["height"] = _resolve_texture_path(String(options.get("height_path", options.get("displacement_path", _infer_map_path(resolved_path, "height")))))
		slots["thickness"] = _resolve_texture_path(String(options.get("thickness_path", _infer_map_path(resolved_path, "thickness"))))
	apply_slots(material, slots, options)


static func apply_slots(material: StandardMaterial3D, slots: Dictionary, options: Dictionary = {}) -> void:
	if material == null:
		return

	_apply_common_options(material, options)
	var normalized := normalize_slots(slots)
	var albedo_path := String(normalized.get("albedo", ""))
	var opacity_path := String(normalized.get("opacity", ""))

	if not albedo_path.is_empty() and ResourceLoader.exists(albedo_path):
		if bool(options.get("alpha_scissor", false)) and not opacity_path.is_empty() and ResourceLoader.exists(opacity_path):
			var combined_texture := _build_albedo_with_opacity(albedo_path, opacity_path)
			material.albedo_texture = combined_texture if combined_texture != null else load(albedo_path)
		else:
			material.albedo_texture = load(albedo_path)

	var normal_path := String(normalized.get("normal", ""))
	if not normal_path.is_empty() and ResourceLoader.exists(normal_path):
		material.normal_enabled = true
		material.normal_texture = load(normal_path)
		material.normal_scale = float(options.get("normal_scale", 1.0))

	var roughness_path := String(normalized.get("roughness", ""))
	if not roughness_path.is_empty() and ResourceLoader.exists(roughness_path):
		material.roughness_texture = load(roughness_path)
		material.roughness_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_RED

	var ao_path := String(normalized.get("ao", ""))
	if not ao_path.is_empty() and ResourceLoader.exists(ao_path):
		material.ao_enabled = true
		material.ao_texture = load(ao_path)
		material.ao_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_RED
		material.ao_light_affect = float(options.get("ao_light_affect", 0.35))

	if bool(options.get("alpha_scissor", false)):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.alpha_scissor_threshold = float(options.get("alpha_scissor_threshold", 0.42))
		material.alpha_antialiasing_mode = BaseMaterial3D.ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE


static func normalize_slots(slots: Dictionary) -> Dictionary:
	var normalized := {}
	for key in STANDARD_SLOTS:
		normalized[key] = ""
	for key in slots.keys():
		var normalized_key := _normalize_slot_key(String(key))
		if normalized_key.is_empty():
			continue
		normalized[normalized_key] = _resolve_texture_path(String(slots[key]))
	return normalized


static func _build_albedo_with_opacity(color_path: String, opacity_path: String) -> Texture2D:
	var color_image := Image.load_from_file(ProjectSettings.globalize_path(color_path))
	var opacity_image := Image.load_from_file(ProjectSettings.globalize_path(opacity_path))
	if color_image == null or color_image.is_empty() or opacity_image == null or opacity_image.is_empty():
		return null
	if opacity_image.get_width() != color_image.get_width() or opacity_image.get_height() != color_image.get_height():
		opacity_image.resize(color_image.get_width(), color_image.get_height(), Image.INTERPOLATE_LANCZOS)
	if color_image.get_format() != Image.FORMAT_RGBA8:
		color_image.convert(Image.FORMAT_RGBA8)
	if opacity_image.get_format() != Image.FORMAT_RF:
		opacity_image.convert(Image.FORMAT_RF)
	for y in range(color_image.get_height()):
		for x in range(color_image.get_width()):
			var color := color_image.get_pixel(x, y)
			color.a = opacity_image.get_pixel(x, y).r
			color_image.set_pixel(x, y, color)
	return ImageTexture.create_from_image(color_image)


static func _apply_common_options(material: StandardMaterial3D, options: Dictionary) -> void:
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	material.albedo_color = options.get("albedo_color", Color(1, 1, 1, 1))
	material.roughness = float(options.get("roughness", 1.0))
	material.metallic = float(options.get("metallic", 0.0))
	material.uv1_triplanar = bool(options.get("triplanar", false))
	material.uv1_scale = options.get("uv1_scale", Vector3.ONE)
	material.cull_mode = BaseMaterial3D.CULL_DISABLED if bool(options.get("double_sided", false)) else BaseMaterial3D.CULL_BACK
	material.specular_mode = int(options.get("specular_mode", BaseMaterial3D.SPECULAR_SCHLICK_GGX))

	if options.has("shading_mode"):
		material.shading_mode = int(options["shading_mode"])

	if bool(options.get("rim_enabled", false)):
		material.rim_enabled = true
		material.rim = float(options.get("rim", 0.05))
		material.rim_tint = float(options.get("rim_tint", 0.2))

	if bool(options.get("clearcoat_enabled", false)):
		material.clearcoat_enabled = true
		material.clearcoat = float(options.get("clearcoat", 0.1))
		material.clearcoat_roughness = float(options.get("clearcoat_roughness", 0.2))

	if bool(options.get("emission_enabled", false)):
		material.emission_enabled = true
		material.emission = options.get("emission", Color(0, 0, 0, 1))
		material.emission_energy_multiplier = float(options.get("emission_energy", 1.0))


static func _resolve_texture_path(texture_path: String) -> String:
	if texture_path.is_empty():
		return ""
	if texture_path.begins_with("res://"):
		return texture_path
	return "res://assets/shared/textures/%s.png" % texture_path


static func _normalize_slot_key(slot_key: String) -> String:
	match slot_key:
		"albedo", "color", "base_color":
			return "albedo"
		"normal", "normal_gl":
			return "normal"
		"roughness":
			return "roughness"
		"opacity", "alpha":
			return "opacity"
		"displacement", "height", "heightmap":
			return "height"
		"thickness":
			return "thickness"
		"detail":
			return "detail"
		"hdri":
			return "hdri"
		"ao", "ambient_occlusion":
			return "ao"
	return ""


static func _infer_map_path(color_path: String, map_kind: String) -> String:
	if color_path.is_empty():
		return ""
	var suffixes: PackedStringArray = MAP_SUFFIXES.get(map_kind, PackedStringArray())
	if suffixes.is_empty():
		return ""

	var base := color_path.get_basename()
	var ext := color_path.get_extension()
	for color_suffix in COLOR_SUFFIXES:
		if base.ends_with(color_suffix):
			var stem := base.left(base.length() - color_suffix.length())
			for map_suffix in suffixes:
				return "%s%s.%s" % [stem, map_suffix, ext]
	for map_suffix in suffixes:
		return "%s%s.%s" % [base, map_suffix, ext]
	return ""
