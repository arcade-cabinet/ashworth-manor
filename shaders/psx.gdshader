shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_disabled;

// PSX-style vertex snapping and affine texture warping
uniform float snap_resolution : hint_range(32.0, 320.0) = 160.0;
uniform float color_depth : hint_range(2.0, 32.0) = 16.0;
uniform sampler2D albedo_tex : source_color, filter_nearest, repeat_enable;
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float emission_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 emission_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

varying float vertex_dist;

void vertex() {
	// Transform to clip space
	vec4 clip_pos = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);

	// Vertex snapping (PS1-style grid snap)
	float w = clip_pos.w;
	clip_pos.xy = floor(clip_pos.xy / w * snap_resolution + 0.5) / snap_resolution * w;

	POSITION = clip_pos;

	// Affine texture mapping (divide UVs by W for that warped PS1 look)
	vertex_dist = length((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz);
}

void fragment() {
	// Sample texture with nearest filtering (set on uniform)
	vec4 tex_color = texture(albedo_tex, UV);
	vec3 color = tex_color.rgb * albedo_color.rgb;

	// Color depth reduction (posterize)
	color = floor(color * color_depth + 0.5) / color_depth;

	ALBEDO = color;
	ALPHA = tex_color.a * albedo_color.a;

	// Optional emission for interactable glow
	EMISSION = emission_color.rgb * emission_strength;
}
