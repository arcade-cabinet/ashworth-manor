shader_type spatial;

render_mode blend_mix, depth_prepass_alpha, cull_disabled, diffuse_burley, specular_schlick_ggx, world_vertex_coords;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap, repeat_enable;
uniform sampler2D opacity_tex : filter_linear_mipmap, repeat_enable;
uniform sampler2D thickness_tex : filter_linear_mipmap, repeat_enable;

uniform vec4 base_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool use_opacity = true;
uniform bool use_thickness_map = false;
uniform float alpha_cutoff : hint_range(0.0, 1.0, 0.01) = 0.18;

uniform float roughness : hint_range(0.0, 1.0, 0.01) = 0.82;
uniform float specular_strength : hint_range(0.0, 1.0, 0.01) = 0.24;

uniform float sigma : hint_range(0.0, 1.0, 0.01) = 0.52;
uniform float power : hint_range(0.0, 24.0, 0.1) = 4.6;
uniform float scale : hint_range(0.0, 8.0, 0.1) = 1.65;
uniform float attenuation_influence : hint_range(0.0, 1.0, 0.01) = 0.62;
uniform float albedo_influence : hint_range(0.0, 1.0, 0.01) = 0.72;
uniform float light_color_influence : hint_range(0.0, 1.0, 0.01) = 0.28;

uniform bool vertex_sway_enabled = false;
uniform float vertex_sway_intensity : hint_range(0.0, 1.0, 0.01) = 0.08;
uniform float sway_speed : hint_range(0.0, 4.0, 0.01) = 0.55;
uniform float gust_scale : hint_range(0.001, 2.0, 0.001) = 0.05;
uniform float gust_speed : hint_range(0.0, 4.0, 0.01) = 0.8;
uniform float gust_strength : hint_range(0.0, 2.0, 0.01) = 0.3;
uniform float gust_frequency : hint_range(0.0, 2.0, 0.01) = 0.5;
uniform vec2 wind_direction = vec2(1.0, 0.2);

varying mat3 tbn;
varying vec3 normal_ws;

float hash2(vec2 p) {
	p = fract(p * vec2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return fract(p.x * p.y);
}

float noise2(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = hash2(i);
	float b = hash2(i + vec2(1.0, 0.0));
	float c = hash2(i + vec2(0.0, 1.0));
	float d = hash2(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float get_sss(vec3 n, vec3 v, vec3 l, float s) {
	vec3 light_dir = normalize(l);
	return pow(max(dot((-light_dir + n * s), v), 0.0), power);
}

void vertex() {
	tbn = mat3(TANGENT, BINORMAL, NORMAL);

	if (vertex_sway_enabled) {
		float height_mask = pow(clamp(1.0 - UV.y, 0.0, 1.0), 1.5);
		vec2 wind_dir = normalize(wind_direction);
		vec2 noise_uv = VERTEX.xz * gust_scale + wind_dir * TIME * gust_speed;
		float gust_noise =
			noise2(noise_uv) * 0.6 +
			noise2(noise_uv * 2.0) * 0.3 +
			noise2(noise_uv * 4.0) * 0.1;
		gust_noise = gust_noise * 2.0 - 1.0;
		float gust_pulse = 0.5 + 0.5 * sin(TIME * sway_speed * max(gust_frequency, 0.01));
		float micro = sin(TIME * (sway_speed * 2.0) + VERTEX.x * 0.3) * 0.2;
		vec2 wind_force = wind_dir * gust_noise * gust_strength * gust_pulse + vec2(micro, micro * 0.5);
		VERTEX.xz += wind_force * height_mask * vertex_sway_intensity;
	}
}

void fragment() {
	vec4 albedo_sample = texture(albedo_tex, UV);
	float opacity = use_opacity ? texture(opacity_tex, UV).r : albedo_sample.a;
	if (opacity < alpha_cutoff) {
		discard;
	}

	ALBEDO = albedo_sample.rgb * base_tint.rgb;
	ALPHA = opacity * base_tint.a;
	ROUGHNESS = roughness;
	SPECULAR = specular_strength;

	vec3 tangent_normal = texture(normal_tex, UV).rgb * 2.0 - 1.0;
	NORMAL_MAP = tangent_normal * 0.5 + 0.5;
	normal_ws = normalize(tbn * tangent_normal);
}

void light() {
	float thickness = use_thickness_map ? 1.0 - texture(thickness_tex, UV).r : sigma;
	float ksss = get_sss(normal_ws, VIEW, LIGHT, thickness);
	vec3 lifted_normal = normalize(mix(normal_ws, vec3(0.0, 1.0, 0.0), 0.18));
	float kd = max(dot(normalize(LIGHT), lifted_normal), 0.0);
	vec3 sss_color = albedo_influence * ALBEDO + light_color_influence * LIGHT_COLOR;
	float attenuation = max(mix(1.0, ATTENUATION, attenuation_influence), 0.001);
	DIFFUSE_LIGHT += sss_color * attenuation * (0.22 + max(kd * scale, ksss * scale));
}
