shader_type sky;
// PSX-style night sky: posterized stars, dithered moon, overcast clouds
// Static (no TIME) — renders to radiance cubemap ONCE, then cached

uniform vec3 sky_color_top : source_color = vec3(0.02, 0.02, 0.06);
uniform vec3 sky_color_horizon : source_color = vec3(0.05, 0.04, 0.08);
uniform float star_density : hint_range(0.0, 1.0) = 0.3;
uniform float star_brightness : hint_range(0.0, 1.0) = 0.6;
uniform float moon_size : hint_range(0.001, 0.1) = 0.02;
uniform vec3 moon_color : source_color = vec3(0.7, 0.75, 0.85);
uniform float cloud_density : hint_range(0.0, 1.0) = 0.4;
uniform vec3 cloud_color : source_color = vec3(0.08, 0.07, 0.1);
uniform float color_depth : hint_range(2.0, 32.0) = 15.0;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;
uniform float moon_glow : hint_range(0.0, 1.0) = 0.35;
uniform vec3 twilight_tint : source_color = vec3(0.12, 0.08, 0.09);

// Simple hash for star positions
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 4x4 Bayer dithering
float bayer4(vec2 pos) {
	int x = int(mod(pos.x, 4.0));
	int y = int(mod(pos.y, 4.0));
	int idx = x + y * 4;
	float m[16] = float[16](
		0.0, 8.0, 2.0, 10.0,
		12.0, 4.0, 14.0, 6.0,
		3.0, 11.0, 1.0, 9.0,
		15.0, 7.0, 13.0, 5.0
	);
	return m[idx] / 16.0;
}

void sky() {
	vec3 dir = EYEDIR;

	// Gradient: dark at top, slightly lighter at horizon
	float horizon = smoothstep(-0.1, 0.3, dir.y);
	vec3 sky = mix(sky_color_horizon, sky_color_top, horizon);
	float dusk_band = smoothstep(-0.08, 0.08, dir.y) * (1.0 - smoothstep(0.08, 0.24, dir.y));
	sky = mix(sky, sky + twilight_tint, dusk_band * 0.55);

	// Stars (only above horizon)
	if (dir.y > 0.0) {
		vec2 star_uv = dir.xz / (dir.y + 0.001) * 50.0;
		float star = hash(floor(star_uv));
		if (star > 1.0 - star_density * 0.16) {
			float twinkle = star_brightness * smoothstep(0.98, 1.0, star);
			sky += vec3(twinkle);
		}
	}

	// Moon disc (from DirectionalLight3D)
	if (LIGHT0_ENABLED) {
		float moon_dist = distance(dir, -LIGHT0_DIRECTION);
		if (moon_dist < moon_size) {
			float moon_edge = smoothstep(moon_size, moon_size * 0.8, moon_dist);
			sky = mix(sky, moon_color * LIGHT0_ENERGY, moon_edge);
		} else if (moon_dist < moon_size * 2.4) {
			float glow_band = 1.0 - smoothstep(moon_size, moon_size * 2.4, moon_dist);
			sky += moon_color * moon_glow * glow_band * LIGHT0_ENERGY;
		}
	}

	// Overcast cloud layer (simple, no TIME — static)
	if (cloud_density > 0.0 && dir.y > -0.1) {
		vec2 cloud_uv = dir.xz / max(dir.y, 0.01) * 3.0;
		float cloud = hash(floor(cloud_uv * 2.0)) * 0.5 + hash(floor(cloud_uv * 4.0)) * 0.3;
		cloud = smoothstep(1.0 - cloud_density, 1.0, cloud);
		sky = mix(sky, cloud_color, cloud * 0.6);
	}

	// PSX color depth reduction
	sky = floor(sky * color_depth + 0.5) / color_depth;

	// Bayer dithering (use SCREEN_UV to get pixel position)
	float dither = bayer4(SCREEN_UV * vec2(320.0, 240.0)) - 0.5;
	sky += dither_strength * dither / color_depth;
	sky = floor(sky * color_depth + 0.5) / color_depth;

	COLOR = sky;
}
