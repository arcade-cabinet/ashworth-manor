shader_type spatial;

render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D albedo_tex : source_color, filter_nearest_mipmap, repeat_enable;
uniform vec4 base_color : source_color = vec4(0.6, 0.5, 0.4, 1.0);
uniform float texture_mix : hint_range(0.0, 1.0) = 0.0;
uniform float uv_scale = 1.0;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.6;
uniform float base_specular : hint_range(0.0, 1.0) = 0.5;
uniform float clearcoat : hint_range(0.0, 1.0) = 0.0;
uniform float clearcoat_roughness : hint_range(0.0, 1.0) = 0.15;
uniform float rim_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 emission_color : source_color = vec4(1.0);
uniform float emission_strength : hint_range(0.0, 4.0) = 0.0;

void fragment() {
	vec4 tex = texture(albedo_tex, UV * uv_scale);
	vec3 tex_albedo = tex.rgb * base_color.rgb;
	ALBEDO = mix(base_color.rgb, tex_albedo, texture_mix);
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = base_specular;
	CLEARCOAT = clearcoat;
	RIM = rim_strength;
	EMISSION = emission_color.rgb * emission_strength;
	ALPHA = base_color.a;
}
