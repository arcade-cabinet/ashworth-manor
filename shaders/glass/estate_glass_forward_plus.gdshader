shader_type spatial;
render_mode blend_premul_alpha, depth_prepass_alpha, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform vec4 base_color : source_color = vec4(0.82, 0.89, 0.95, 0.1);
uniform vec4 edge_color : source_color = vec4(0.95, 0.98, 1.0, 1.0);

uniform float roughness : hint_range(0.0, 1.0, 0.01) = 0.03;
uniform float metallic : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float base_specular : hint_range(0.0, 1.0, 0.01) = 0.7;

uniform float fresnel_power : hint_range(0.5, 8.0, 0.1) = 4.5;
uniform float min_alpha : hint_range(0.0, 1.0, 0.01) = 0.06;
uniform float edge_alpha_boost : hint_range(0.0, 1.0, 0.01) = 0.3;

uniform float refraction_strength : hint_range(0.0, 0.05, 0.001) = 0.012;
uniform float refraction_mix : hint_range(0.0, 1.0, 0.01) = 0.8;
uniform float tint_strength : hint_range(0.0, 1.0, 0.01) = 0.12;

uniform float clearcoat : hint_range(0.0, 1.0, 0.01) = 0.65;
uniform float rim_strength : hint_range(0.0, 1.0, 0.01) = 0.18;
uniform float refracted_edge_boost : hint_range(0.0, 0.5, 0.01) = 0.08;
uniform float edge_emission_strength : hint_range(0.0, 0.5, 0.01) = 0.0;

void fragment() {
	vec3 normal = normalize(NORMAL);
	vec3 view = normalize(VIEW);
	float view_dot = clamp(dot(normal, view), 0.0, 1.0);
	float fresnel = pow(1.0 - view_dot, fresnel_power);

	vec2 refract_uv = clamp(
		SCREEN_UV + normal.xy * refraction_strength * (0.35 + fresnel),
		vec2(0.0),
		vec2(1.0)
	);
	vec3 refracted_scene = texture(screen_texture, refract_uv).rgb;

	vec3 glass_tint = mix(base_color.rgb, edge_color.rgb, fresnel);
	vec3 tinted_refract = mix(refracted_scene, refracted_scene * glass_tint, tint_strength);
	ALBEDO = mix(glass_tint, tinted_refract, refraction_mix);

	float alpha = clamp(base_color.a + fresnel * edge_alpha_boost, min_alpha, 1.0);
	ALPHA = alpha;
	PREMUL_ALPHA_FACTOR = alpha;

	ROUGHNESS = roughness;
	METALLIC = metallic;
	SPECULAR = clamp(base_specular * inversesqrt(max(alpha, 0.08)), 0.0, 1.0);
	CLEARCOAT = clearcoat;

	RIM = rim_strength * fresnel;
	RIM_TINT = 0.0;
	EMISSION = refracted_scene * fresnel * refracted_edge_boost + edge_color.rgb * fresnel * edge_emission_strength;
}
