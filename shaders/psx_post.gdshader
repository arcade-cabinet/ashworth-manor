shader_type canvas_item;

// PSX post-processing: color depth reduction + dithering + resolution downscale
uniform float color_depth : hint_range(4.0, 64.0) = 15.0;
uniform float resolution_scale : hint_range(0.1, 1.0) = 0.5;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

// 4x4 Bayer dithering matrix
float bayer4(vec2 pos) {
	int x = int(mod(pos.x, 4.0));
	int y = int(mod(pos.y, 4.0));
	int idx = x + y * 4;
	// Bayer matrix values (0-15) normalized to 0-1
	float m[16] = float[16](
		0.0, 8.0, 2.0, 10.0,
		12.0, 4.0, 14.0, 6.0,
		3.0, 11.0, 1.0, 9.0,
		15.0, 7.0, 13.0, 5.0
	);
	return m[idx] / 16.0;
}

void fragment() {
	// Resolution downscale: snap UV to lower-res grid
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	vec2 low_res = screen_size * resolution_scale;
	vec2 snapped_uv = floor(SCREEN_UV * low_res) / low_res;

	vec3 color = texture(screen_texture, snapped_uv).rgb;

	// Dithering before color reduction
	float dither = bayer4(FRAGCOORD.xy) - 0.5;
	color += dither_strength * dither / color_depth;

	// Color depth reduction (posterize)
	color = floor(color * color_depth + 0.5) / color_depth;

	COLOR = vec4(color, 1.0);
}
