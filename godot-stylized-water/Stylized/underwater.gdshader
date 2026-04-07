shader_type spatial;
render_mode unshaded, cull_disabled, depth_test_disabled;

// must match the uniforms with the water shader
uniform float sea_height : hint_range(0.0, 5.0) = 1.3;
uniform float sea_choppy : hint_range(0.0, 10.0) = 4.0;
uniform float sea_speed : hint_range(0.0, 5.0) = 1.5;
uniform float sea_freq : hint_range(0.0, 0.5) = 0.08;
uniform float height_offset = 0.0;

group_uniforms Underwater_Settings;
uniform vec3 underwater_color : source_color = vec3(0.0, 0.341, 0.29);
uniform float color_deep_strength : hint_range(0.0, 1.0) = 0.5; 
uniform float beer_factor : hint_range(0.0, 10.0) = 0.5; 
uniform float water_level_fudge : hint_range(-2.0, 2.0) = 0.0; 

group_uniforms Visual_FX;
uniform float refraction_strength : hint_range(0.0, 0.05) = 0.003;
uniform float aberration_strength : hint_range(0.0, 0.02) = 0.002;

group_uniforms Caustics;
uniform float caustic_strength : hint_range(0.0, 1.0) = 0.3;
uniform float caustic_scale : hint_range(0.1, 10.0) = 0.5;
uniform float caustic_speed : hint_range(0.0, 2.0) = 0.2;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

const int ITER_GEOMETRY = 3;
const mat2 octave_m = mat2(vec2(1.6, 1.2), vec2(-1.2, 1.6));

float hash12(vec2 p) {
	uvec2 q = uvec2(ivec2(p)) * uvec2(1597334677u, 3812015801u);
	uint n = (q.x ^ q.y) * 1597334677u;
	return float(n) * (1.0 / 4294967295.0);
}

float noise(in vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return -1.0 + 2.0 * mix(mix(hash12(i + vec2(0.0, 0.0)), hash12(i + vec2(1.0, 0.0)), u.x),
							 mix(hash12(i + vec2(0.0, 1.0)), hash12(i + vec2(1.0, 1.0)), u.x), u.y);
}


float caustic_noise(vec2 uv, float time) {
	vec2 p = floor(uv);
	vec2 f = fract(uv);
	float res = 1.0;
	
	for(int j = -1; j <= 1; j++) {
		for(int i = -1; i <= 1; i++) {
			vec2 b = vec2(float(i), float(j));
			vec2 r = vec2(b) - f + hash12(p + b);
			// Animate the internal points
			r += 0.5 * sin(vec2(time) + 6.2831 * hash12(p + b)); 
			float d = dot(r, r);
			res = min(res, d);
		}
	}
	return 1.0 - res; // inverting to make lines bright
}

float sea_octave(vec2 uv, float choppy) {
	uv += noise(uv);
	vec2 wv = 1.0 - abs(sin(uv));
	vec2 swv = abs(cos(uv));
	wv = mix(wv, swv, wv);
	return pow(1.0 - pow(wv.x * wv.y, 0.65), choppy);
}

varying vec3 var_world_pos;

void vertex() {
	var_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float freq = sea_freq;
	float amp = sea_height;
	float choppy = sea_choppy;
	vec2 uv_wave = var_world_pos.xz;
	uv_wave.x *= 0.75;
	float h_accum = 0.0;
	for (int i = 0; i < ITER_GEOMETRY; i++) {
		float d = sea_octave((uv_wave + TIME * sea_speed) * freq, choppy);
		d += sea_octave((uv_wave - TIME * sea_speed) * freq, choppy);
		h_accum += d * amp;
		uv_wave *= octave_m;
		freq *= 1.9;
		amp *= 0.22;
		choppy = mix(choppy, 1.0, 0.2);
	}
	
	float wave_height_here = h_accum + height_offset + water_level_fudge;
	bool is_underwater = var_world_pos.y < wave_height_here;

	if (!is_underwater) {
		discard;
	}

	// we generate noise based on screen UVs and Time to wiggle the background
	vec2 screen_uv = SCREEN_UV;
	
	// creating a wobbling effect based on time
	float noise_x = noise(screen_uv * 10.0 + vec2(TIME * 0.5, 0.0));
	float noise_y = noise(screen_uv * 10.0 + vec2(0.0, TIME * 0.5));
	vec2 refract_offset = vec2(noise_x, noise_y) * refraction_strength;

	vec2 distorted_uv = screen_uv + refract_offset;

	float depth = texture(DEPTH_TEXTURE, distorted_uv).x;
	vec3 ndc = vec3(distorted_uv * 2.0 - 1.0, depth);
	
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
		ndc.z = depth * 2.0 - 1.0;
	#endif

	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 scene_world_pos = world.xyz / world.w;
	float dist = distance(var_world_pos, scene_world_pos);

	vec3 screen_color;
	screen_color.r = texture(SCREEN_TEXTURE, distorted_uv + vec2(aberration_strength, 0.0)).r;
	screen_color.g = texture(SCREEN_TEXTURE, distorted_uv).g; // Center
	screen_color.b = texture(SCREEN_TEXTURE, distorted_uv - vec2(aberration_strength, 0.0)).b;

	// we project caustics onto the SCENE geometry, not the water volume.
	// we use the scene_world_pos derived from the depth texture.
	
	float caustic_val = 0.0;
	if (dist < 100.0) { // don't calculate caustics for infinite sky
		vec2 caustic_uv = scene_world_pos.xz * caustic_scale;
		float caustic_a = caustic_noise(caustic_uv + TIME * caustic_speed, TIME * 0.5);
		float caustic_b = caustic_noise(caustic_uv * 1.3 - TIME * caustic_speed * 0.8, TIME * 0.6);
		
		// multiply them to get a "network" of light
		caustic_val = pow(min(caustic_a, caustic_b), 2.0) * 5.0; 
		caustic_val *= caustic_strength;
		
		// fade caustics out by depth so they don't look weird at extreme distances
		float caustic_fade = clamp(1.0 - (dist / 50.0), 0.0, 1.0);
		caustic_val *= caustic_fade;
	}
	
	screen_color += vec3(caustic_val);

	// underwater fog via beer law
	float fog_factor = 1.0 - exp(-dist * beer_factor);
	fog_factor = clamp(fog_factor, 0.0, 1.0);
	
	vec3 tinted_scene = mix(screen_color, underwater_color, color_deep_strength);
	ALBEDO = mix(tinted_scene, underwater_color, fog_factor);
}