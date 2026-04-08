class_name PSXBridge
extends RefCounted
## Bridges the godot-psx addon to the declaration engine.
## 1. psx_dither.gdshader -- applied globally via CanvasLayer (already in main.tscn)
## 2. psx_fade.gdshader -- room transitions controlled by room_assembler
## 3. exterior grounds now use a generated panorama sky, not a custom sky shader

const DITHER_SHADER := "res://shaders/psx_dither.gdshader"
const FADE_SHADER := "res://shaders/psx_fade.gdshader"
const EstateEnvironmentRegistry = preload("res://builders/estate_environment_registry.gd")

## Default PSX dither parameters (match main.tscn values)
const DEFAULT_COLOR_DEPTH := 5
const DEFAULT_DITHERING := true

## Fade parameters for room transitions
const FADE_DURATION := 0.8  # seconds


func create_psx_sky(sky_decl: SkyDeclaration) -> Sky:
	var image := _compose_panorama_image(sky_decl)
	if image == null:
		return null
	var texture := ImageTexture.create_from_image(image)
	if texture == null:
		return null
	var mat := PanoramaSkyMaterial.new()
	mat.panorama = texture
	var sky := Sky.new()
	sky.sky_material = mat
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
			var resolved_sky_decl := env_decl.sky
			if not env_decl.sky_preset_id.is_empty():
				resolved_sky_decl = EstateEnvironmentRegistry.build_sky_declaration(env_decl.sky_preset_id, env_decl.sky)
			if resolved_sky_decl:
				var sky := create_psx_sky(resolved_sky_decl)
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
			env.tonemap_mode = Environment.TONE_MAPPER_ACES
		"filmic":
			env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
		"reinhard":
			env.tonemap_mode = Environment.TONE_MAPPER_REINHARDT
		_:
			env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
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


func _load_hdri_image(path: String) -> Image:
	if path.is_empty():
		return null
	if not FileAccess.file_exists(path):
		push_warning("PSXBridge: HDRI missing at %s" % path)
		return null
	var image := Image.load_from_file(path)
	if image == null or image.is_empty():
		push_warning("PSXBridge: Failed to load HDRI %s" % path)
		return null
	return image


func _compose_panorama_image(sky_decl: SkyDeclaration) -> Image:
	var generated := _generate_panorama_image(sky_decl)
	if generated == null:
		return null
	var hdri := _load_hdri_image(sky_decl.hdri_path)
	if hdri == null:
		return generated

	var width := generated.get_width()
	var height := generated.get_height()
	if hdri.get_width() != width or hdri.get_height() != height:
		hdri.resize(width, height, Image.INTERPOLATE_LANCZOS)

	var composed := Image.create(width, height, false, Image.FORMAT_RGBA8)
	for y in range(height):
		var v := float(y) / float(height - 1)
		var upper_weight := _smoothstep(0.18, 0.92, 1.0 - v)
		var horizon_weight := 1.0 - upper_weight
		for x in range(width):
			var base := hdri.get_pixel(x, y)
			var overlay := generated.get_pixel(x, y)
			var overlay_luma := maxf(overlay.r, maxf(overlay.g, overlay.b))
			var base_luma := maxf(base.r, maxf(base.g, base.b))
			var lifted_base := base.lerp(base + Color(0.01, 0.02, 0.05, 0.0), 0.08)
			var color := lifted_base
			var soft_overlay := horizon_weight * 0.035 + upper_weight * 0.07
			color = color.lerp(overlay, soft_overlay)
			if overlay_luma > base_luma + 0.03:
				color = color.lerp(overlay, 0.34 + upper_weight * 0.16)
			else:
				color = color.lerp(lifted_base, 0.2 + horizon_weight * 0.14)
			color = color.lerp(color + Color(0.0, 0.012, 0.035, 0.0), upper_weight * 0.22)
			color = color.lerp(color + Color(0.012, 0.008, 0.008, 0.0), horizon_weight * 0.05)
			composed.set_pixel(x, y, Color(
				clampf(color.r, 0.0, 1.0),
				clampf(color.g, 0.0, 1.0),
				clampf(color.b, 0.0, 1.0),
				1.0
			))
	return composed


func _generate_panorama_image(sky_decl: SkyDeclaration) -> Image:
	var width := 1024
	var height := 512
	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
	var moon_center := Vector2(0.72, 0.22)
	var moon_radius := clampf(sky_decl.moon_size * 1.0, 0.014, 0.065)

	for y in range(height):
		var v := float(y) / float(height - 1)
		var dir_y := cos(v * PI)
		var horizon := _smoothstep(-0.12, 0.28, dir_y)
		var base_row := sky_decl.sky_color_horizon.lerp(sky_decl.sky_color_top, horizon)
		var dusk_band := _smoothstep(-0.32, 0.02, dir_y) * (1.0 - _smoothstep(0.02, 0.18, dir_y))
		var horizon_glow := _smoothstep(-0.38, 0.0, dir_y) * (1.0 - _smoothstep(0.0, 0.2, dir_y))
		var upper_night := _smoothstep(0.12, 0.84, dir_y)
		var dusk_color := Color(0.11, 0.07, 0.07, 1.0)
		base_row = base_row.lerp(dusk_color, horizon_glow * 0.22)
		base_row = base_row.lerp(base_row + Color(0.08, 0.03, 0.018, 0.0), dusk_band * 0.16)
		base_row = base_row.lerp(Color(0.02, 0.04, 0.11, 1.0), upper_night * 0.48)

		for x in range(width):
			var u := float(x) / float(width - 1)
			var color := base_row

			if dir_y > 0.0:
				var stars := _star_field(Vector2(u, v), dir_y, sky_decl.star_density)
				if stars > 0.0:
					color += sky_decl.moon_color * (sky_decl.star_brightness * stars)
				var major_stars := _major_star_field(Vector2(u, v), dir_y, sky_decl.star_density)
				if major_stars > 0.0:
					color += sky_decl.moon_color * (sky_decl.star_brightness * 1.6 * major_stars)

			var cloud := _cloud_field(Vector2(u, v), dir_y, sky_decl.cloud_density)
			if cloud > 0.0:
				color = color.lerp(sky_decl.cloud_color, cloud * 0.48)

			var moon_uv := Vector2(_wrapped_delta(u, moon_center.x), v - moon_center.y)
			var moon_dist := moon_uv.length()
			if moon_dist < moon_radius * 3.0:
				var moon_glow := 1.0 - _smoothstep(moon_radius, moon_radius * 3.0, moon_dist)
				color += sky_decl.moon_color * moon_glow * 0.12
				if moon_dist < moon_radius:
					var moon_fill := 1.0 - _smoothstep(moon_radius * 0.76, moon_radius, moon_dist)
					color = color.lerp(sky_decl.moon_color, moon_fill * 0.66)

			image.set_pixel(x, y, Color(
				clampf(color.r, 0.0, 1.0),
				clampf(color.g, 0.0, 1.0),
				clampf(color.b, 0.0, 1.0),
				1.0
			))

	return image


func _star_field(uv: Vector2, dir_y: float, density: float) -> float:
	var scale := lerpf(34.0, 76.0, clampf(dir_y, 0.0, 1.0))
	var sample := uv * Vector2(scale * 2.0, scale)
	var cell := Vector2(floor(sample.x), floor(sample.y))
	var local := sample - cell
	var star := _hash_2d(cell)
	var threshold := 1.0 - clampf(density, 0.0, 1.0) * 0.18
	if star < threshold:
		return 0.0
	var center := Vector2(_hash_2d(cell + Vector2(17.0, 13.0)), _hash_2d(cell + Vector2(7.0, 29.0)))
	var dist := local.distance_to(center)
	var sparkle := (1.0 - _smoothstep(0.0, 0.48, dist))
	return sparkle * (0.92 + (star - threshold) * 4.2)


func _major_star_field(uv: Vector2, dir_y: float, density: float) -> float:
	var scale := lerpf(10.0, 18.0, clampf(dir_y, 0.0, 1.0))
	var sample := uv * Vector2(scale * 2.0, scale)
	var cell := Vector2(floor(sample.x), floor(sample.y))
	var local := sample - cell
	var star := _hash_2d(cell + Vector2(91.0, 47.0))
	var threshold := 1.0 - clampf(density, 0.0, 1.0) * 0.065
	if star < threshold:
		return 0.0
	var center := Vector2(_hash_2d(cell + Vector2(5.0, 11.0)), _hash_2d(cell + Vector2(13.0, 23.0)))
	var dist := local.distance_to(center)
	var glow := 1.0 - _smoothstep(0.0, 0.62, dist)
	return glow * (0.85 + (star - threshold) * 3.4)


func _paint_fixed_stars(image: Image, sky_decl: SkyDeclaration) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var stars := [
		Vector3(0.12, 0.1, 3.4), Vector3(0.18, 0.17, 3.0), Vector3(0.24, 0.12, 3.8),
		Vector3(0.31, 0.19, 3.2), Vector3(0.39, 0.14, 6.0), Vector3(0.46, 0.1, 7.2),
		Vector3(0.52, 0.16, 6.4), Vector3(0.58, 0.11, 5.4), Vector3(0.64, 0.19, 3.6),
		Vector3(0.71, 0.14, 5.8), Vector3(0.79, 0.09, 3.2), Vector3(0.85, 0.15, 3.0),
		Vector3(0.34, 0.27, 3.2), Vector3(0.43, 0.24, 4.1), Vector3(0.5, 0.22, 4.8),
		Vector3(0.57, 0.27, 3.6), Vector3(0.66, 0.24, 3.2), Vector3(0.48, 0.31, 3.0)
	]
	var major_energy := clampf(sky_decl.star_brightness * 1.3, 1.8, 6.0)
	for star in stars:
		_paint_star(image, int(star.x * width), int(star.y * height), star.z, major_energy)


func _paint_star(image: Image, cx: int, cy: int, radius: float, energy: float) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var spread := maxi(2, int(ceil(radius * 2.4)))
	for y in range(cy - spread, cy + spread + 1):
		if y < 0 or y >= height:
			continue
		for x in range(cx - spread, cx + spread + 1):
			if x < 0 or x >= width:
				continue
			var dx := float(x - cx)
			var dy := float(y - cy)
			var dist := sqrt(dx * dx + dy * dy)
			var glow := 1.0 - clampf(dist / radius, 0.0, 1.0)
			if glow <= 0.0:
				continue
			var pixel := image.get_pixel(x, y)
			var intensity := glow * glow * 0.9 * energy
			var color := pixel + Color(0.92, 0.95, 1.0, 0.0) * intensity
			image.set_pixel(x, y, Color(
				clampf(color.r, 0.0, 1.0),
				clampf(color.g, 0.0, 1.0),
				clampf(color.b, 0.0, 1.0),
				1.0
			))
	var arm_len := maxi(2, int(round(radius * 1.8)))
	for offset in range(-arm_len, arm_len + 1):
		var falloff := 1.0 - absf(float(offset)) / float(arm_len + 1)
		if falloff <= 0.0:
			continue
		var arm_intensity := energy * falloff * 0.38
		_blend_star_pixel(image, cx + offset, cy, arm_intensity)
		_blend_star_pixel(image, cx, cy + offset, arm_intensity)


func _blend_star_pixel(image: Image, x: int, y: int, intensity: float) -> void:
	var width := image.get_width()
	var height := image.get_height()
	if x < 0 or x >= width or y < 0 or y >= height:
		return
	var pixel := image.get_pixel(x, y)
	var color := pixel + Color(0.92, 0.95, 1.0, 0.0) * intensity
	image.set_pixel(x, y, Color(
		clampf(color.r, 0.0, 1.0),
		clampf(color.g, 0.0, 1.0),
		clampf(color.b, 0.0, 1.0),
		1.0
	))


func _cloud_field(uv: Vector2, dir_y: float, density: float) -> float:
	if density <= 0.0 or dir_y < -0.06:
		return 0.0
	var sample := Vector2(uv.x * 5.0, uv.y * 3.4)
	var cloud := _value_noise(sample * 2.0) * 0.6 + _value_noise(sample * 4.4) * 0.4
	var threshold := 1.0 - density * 0.9
	return _smoothstep(threshold - 0.08, threshold + 0.04, cloud)


func _value_noise(p: Vector2) -> float:
	var i := Vector2(floor(p.x), floor(p.y))
	var f := p - i
	var u := Vector2(f.x * f.x * (3.0 - 2.0 * f.x), f.y * f.y * (3.0 - 2.0 * f.y))
	var a := _hash_2d(i)
	var b := _hash_2d(i + Vector2(1.0, 0.0))
	var c := _hash_2d(i + Vector2(0.0, 1.0))
	var d := _hash_2d(i + Vector2(1.0, 1.0))
	return lerpf(lerpf(a, b, u.x), lerpf(c, d, u.x), u.y)


func _hash_2d(p: Vector2) -> float:
	return fposmod(sin(p.dot(Vector2(127.1, 311.7))) * 43758.5453, 1.0)


func _wrapped_delta(value: float, center: float) -> float:
	var delta := value - center
	if delta > 0.5:
		delta -= 1.0
	elif delta < -0.5:
		delta += 1.0
	return delta


func _smoothstep(edge0: float, edge1: float, value: float) -> float:
	if is_equal_approx(edge0, edge1):
		return 0.0
	var t := clampf((value - edge0) / (edge1 - edge0), 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)
