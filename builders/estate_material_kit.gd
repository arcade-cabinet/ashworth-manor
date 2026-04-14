class_name EstateMaterialKit
extends RefCounted
## Shared recipe registry for authored Victorian substrate materials.

const PBRTextureKit = preload("res://builders/pbr_texture_kit.gd")
const FOLIAGE_SHADER := preload("res://shaders/foliage/estate_foliage_forward_plus.gdshader")
const GLASS_SHADER_PATH := "res://shaders/glass/estate_glass_forward_plus.gdshader"
const WATER_SHADER_PATH := "res://shaders/water/stylized_water_surface.gdshader"

const BRICK_TEXTURE := "res://assets/shared/pbr/masonry/brick_victorian_color.jpg"
const BRICK_NORMAL := "res://assets/shared/pbr/masonry/brick_victorian_normal_gl.jpg"
const BRICK_ROUGHNESS := "res://assets/shared/pbr/masonry/brick_victorian_roughness.jpg"
const BRICK_AO := "res://assets/shared/pbr/masonry/brick_victorian_ao.jpg"
const CHAPEL_STONE_TEXTURE := "res://assets/grounds/chapel/Horror_Stone_02-512x512.png"
const EARTH_TEXTURE := "res://assets/shared/pbr/grounds/estate_earth_color.jpg"
const EARTH_NORMAL := "res://assets/shared/pbr/grounds/estate_earth_normal_gl.jpg"
const EARTH_ROUGHNESS := "res://assets/shared/pbr/grounds/estate_earth_roughness.jpg"
const EARTH_AO := "res://assets/shared/pbr/grounds/estate_earth_ao.jpg"
const GRAVEL_TEXTURE := "res://assets/shared/pbr/grounds/carriage_pathway003_color.jpg"
const GRAVEL_NORMAL := "res://assets/shared/pbr/grounds/carriage_pathway003_normal_gl.jpg"
const GRAVEL_ROUGHNESS := "res://assets/shared/pbr/grounds/carriage_pathway003_roughness.jpg"
const GRAVEL_AO := "res://assets/shared/pbr/grounds/carriage_pathway003_ao.jpg"
const CARRIAGE_TEXTURE := "res://assets/shared/pbr/grounds/carriage_gravel042_color.jpg"
const CARRIAGE_NORMAL := "res://assets/shared/pbr/grounds/carriage_gravel042_normal_gl.jpg"
const CARRIAGE_ROUGHNESS := "res://assets/shared/pbr/grounds/carriage_gravel042_roughness.jpg"
const CARRIAGE_AO := "res://assets/shared/pbr/grounds/carriage_gravel042_ao.jpg"
const HEDGE_MASS_TEXTURE := "res://assets/shared/pbr/foliage/hedge_mass_grass007_color.jpg"
const HEDGE_MASS_NORMAL := "res://assets/shared/pbr/foliage/hedge_mass_grass007_normal_gl.jpg"
const HEDGE_MASS_ROUGHNESS := "res://assets/shared/pbr/foliage/hedge_mass_grass007_roughness.jpg"
const HEDGE_MASS_AO := "res://assets/shared/pbr/foliage/hedge_mass_grass007_ao.jpg"
const HEDGE_CARD_TEXTURE := "res://assets/shared/pbr/foliage/hedge_atlas_albedo.png"
const HEDGE_CARD_NORMAL := "res://assets/shared/pbr/foliage/hedge_atlas_normal_gl.jpg"
const HEDGE_CARD_OPACITY := "res://assets/shared/pbr/foliage/hedge_atlas_opacity.jpg"
const HEDGE_WALL_TEXTURE := "res://assets/shared/pbr/foliage/hedge_wall_color.png"
static var SUPPORTED_RECIPE_KINDS := PackedStringArray(["standard", "foliage_shader", "shader_material"])

const RECIPE_LIBRARY := {
	"surface/brass": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.67, 0.55, 0.3, 1.0),
			"roughness": 0.38,
			"metallic": 0.82,
			"clearcoat_enabled": true,
			"clearcoat": 0.18,
			"clearcoat_roughness": 0.2,
		},
	},
	"surface/chain_iron": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.21, 0.19, 0.18, 1.0),
			"roughness": 0.64,
			"metallic": 0.62,
		},
	},
	"surface/wrought_iron": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.12, 0.11, 0.12, 1.0),
			"roughness": 0.64,
			"metallic": 0.86,
		},
	},
	"surface/oak_dark": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.34, 0.22, 0.13, 1.0),
			"roughness": 0.84,
		},
	},
	"surface/oak_board": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.26, 0.17, 0.1, 1.0),
			"roughness": 0.9,
		},
	},
	"surface/oak_header": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.18, 0.11, 0.07, 1.0),
			"roughness": 0.92,
		},
	},
	"surface/leather_valise": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.2, 0.12, 0.07, 1.0),
			"roughness": 0.9,
			"metallic": 0.02,
		},
	},
	"surface/paper": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.88, 0.84, 0.75, 1.0),
			"roughness": 0.96,
		},
	},
	"surface/cloth_brown": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.48, 0.39, 0.32, 1.0),
			"roughness": 0.98,
		},
	},
	"surface/lining_tan": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.64, 0.55, 0.47, 1.0),
			"roughness": 0.96,
		},
	},
	"surface/branch_dark": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.12, 0.09, 0.06, 1.0),
			"roughness": 1.0,
		},
	},
	"surface/brick_masonry": {
		"family": "surface",
		"kind": "standard",
		"slots": {
			"albedo": BRICK_TEXTURE,
			"normal": BRICK_NORMAL,
			"roughness": BRICK_ROUGHNESS,
			"ao": BRICK_AO,
		},
		"options": {
			"albedo_color": Color(0.62, 0.58, 0.57, 1.0),
			"roughness": 0.94,
			"triplanar": true,
			"uv1_scale": Vector3(1.34, 0.9, 1.12),
		},
	},
	"surface/masonry_cap": {
		"family": "surface",
		"kind": "standard",
		"slots": {
			"albedo": GRAVEL_TEXTURE,
			"normal": GRAVEL_NORMAL,
			"roughness": GRAVEL_ROUGHNESS,
			"ao": GRAVEL_AO,
		},
		"options": {
			"albedo_color": Color(0.56, 0.54, 0.51, 1.0),
			"roughness": 0.98,
			"triplanar": true,
			"uv1_scale": Vector3(2.2, 1.0, 2.2),
		},
	},
	"surface/greenhouse_frame": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.28, 0.24, 0.18, 1.0),
			"roughness": 0.56,
			"metallic": 0.18,
		},
	},
	"surface/terracotta_pot": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.49, 0.235, 0.11, 1.0),
			"roughness": 0.88,
			"metallic": 0.0,
		},
	},
	"surface/soil_dark": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.11, 0.07, 0.045, 1.0),
			"roughness": 1.0,
			"metallic": 0.0,
		},
	},
	"surface/lily_petal": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.96, 0.96, 0.91, 1.0),
			"roughness": 0.72,
			"emission_enabled": true,
			"emission": Color(0.6, 0.52, 0.32, 1.0),
			"emission_energy": 1.0,
		},
	},
	"surface/linen_ash": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.42, 0.39, 0.34, 1.0),
			"roughness": 0.95,
		},
	},
	"surface/tea_ceramic": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.87, 0.831, 0.753, 1.0),
			"roughness": 0.78,
			"clearcoat_enabled": true,
			"clearcoat": 0.1,
			"clearcoat_roughness": 0.18,
		},
	},
	"surface/tea_tray": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.357, 0.235, 0.122, 1.0),
			"roughness": 0.82,
		},
	},
	"surface/chapel_stone": {
		"family": "surface",
		"kind": "standard",
		"slots": {
			"albedo": CHAPEL_STONE_TEXTURE,
		},
		"options": {
			"roughness": 0.95,
		},
	},
	"surface/pedestal_stone": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.22, 0.18, 0.14, 1.0),
			"roughness": 0.86,
		},
	},
	"surface/warm_flame": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(1.0, 0.78, 0.36, 1.0),
			"roughness": 0.18,
			"emission_enabled": true,
			"emission": Color(1.0, 0.72, 0.28, 1.0),
			"emission_energy": 6.0,
		},
	},
	"surface/fallback_wood": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.35, 0.27, 0.18, 1.0),
			"roughness": 0.92,
		},
	},
	"surface/fallback_metal": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.18, 0.17, 0.18, 1.0),
			"roughness": 0.7,
			"metallic": 0.75,
		},
	},
	"surface/shadow_void": {
		"family": "surface",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.08, 0.08, 0.12, 1.0),
			"roughness": 1.0,
		},
	},
	"glass/window_glass": {
		"family": "glass",
		"kind": "shader_material",
		"shader_path": GLASS_SHADER_PATH,
		"shader_params": {
			"base_color": Color(0.65, 0.75, 0.84, 0.14),
			"edge_color": Color(0.86, 0.92, 0.98, 1.0),
			"roughness": 0.05,
			"metallic": 0.0,
			"base_specular": 0.58,
			"fresnel_power": 4.8,
			"min_alpha": 0.11,
			"edge_alpha_boost": 0.22,
			"refraction_strength": 0.006,
			"refraction_mix": 0.58,
			"tint_strength": 0.22,
			"clearcoat": 0.35,
			"rim_strength": 0.12,
			"refracted_edge_boost": 0.04,
			"edge_emission_strength": 0.0,
		},
	},
	"glass/facade_dark": {
		"family": "glass",
		"kind": "shader_material",
		"shader_path": GLASS_SHADER_PATH,
		"shader_params": {
			"base_color": Color(0.12, 0.13, 0.17, 0.16),
			"edge_color": Color(0.72, 0.78, 0.84, 1.0),
			"roughness": 0.08,
			"metallic": 0.0,
			"base_specular": 0.56,
			"fresnel_power": 4.4,
			"min_alpha": 0.08,
			"edge_alpha_boost": 0.16,
			"refraction_strength": 0.004,
			"refraction_mix": 0.46,
			"tint_strength": 0.2,
			"clearcoat": 0.28,
			"rim_strength": 0.08,
			"refracted_edge_boost": 0.02,
			"edge_emission_strength": 0.0,
		},
	},
	"glass/door_lamplit": {
		"family": "glass",
		"kind": "shader_material",
		"shader_path": GLASS_SHADER_PATH,
		"shader_params": {
			"base_color": Color(0.18, 0.16, 0.13, 0.24),
			"edge_color": Color(0.86, 0.78, 0.62, 1.0),
			"roughness": 0.12,
			"metallic": 0.0,
			"base_specular": 0.52,
			"fresnel_power": 3.9,
			"min_alpha": 0.16,
			"edge_alpha_boost": 0.18,
			"refraction_strength": 0.003,
			"refraction_mix": 0.34,
			"tint_strength": 0.38,
			"clearcoat": 0.24,
			"rim_strength": 0.08,
			"refracted_edge_boost": 0.015,
			"edge_emission_strength": 0.05,
		},
	},
	"glass/crystal_glass": {
		"family": "glass",
		"kind": "shader_material",
		"shader_path": GLASS_SHADER_PATH,
		"shader_params": {
			"base_color": Color(0.83, 0.9, 0.96, 0.09),
			"edge_color": Color(0.95, 0.98, 1.0, 1.0),
			"roughness": 0.02,
			"metallic": 0.0,
			"base_specular": 0.78,
			"fresnel_power": 4.2,
			"min_alpha": 0.05,
			"edge_alpha_boost": 0.34,
			"refraction_strength": 0.013,
			"refraction_mix": 0.84,
			"tint_strength": 0.1,
			"clearcoat": 0.72,
			"rim_strength": 0.2,
			"refracted_edge_boost": 0.08,
			"edge_emission_strength": 0.0,
		},
	},
	"glass/greenhouse_glass": {
		"family": "glass",
		"kind": "shader_material",
		"shader_path": GLASS_SHADER_PATH,
		"shader_params": {
			"base_color": Color(0.6, 0.74, 0.84, 0.34),
			"edge_color": Color(0.88, 0.94, 0.98, 1.0),
			"roughness": 0.06,
			"metallic": 0.0,
			"base_specular": 0.82,
			"fresnel_power": 3.6,
			"min_alpha": 0.24,
			"edge_alpha_boost": 0.38,
			"refraction_strength": 0.007,
			"refraction_mix": 0.32,
			"tint_strength": 0.52,
			"clearcoat": 0.45,
			"rim_strength": 0.24,
			"refracted_edge_boost": 0.08,
			"edge_emission_strength": 0.12,
		},
	},
	"liquid/estate_pond_water": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.25,
			"max_depth": 2.2,
			"refraction_strength": 0.22,
			"refraction_distance_fade": 6.0,
			"base_tint_color": Color(0.06666667, 0.12156863, 0.15686275, 1.0),
			"deep_color": Color(0.019607844, 0.05882353, 0.10980392, 1.0),
			"water_absorption": Color(0.21568628, 0.29803923, 0.38039216, 1.0),
			"underwater_fog_color": Color(0.019607844, 0.050980393, 0.09019608, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 18.0,
			"sea_height": 0.06,
			"sea_choppy": 0.95,
			"sea_speed": 0.32,
			"sea_freq": 0.22,
			"roughness": 0.08,
			"metallic": 0.0,
			"specular": 0.6,
			"foam_color": Color(0.8392157, 0.8862745, 0.9411765, 1.0),
			"foam_depth_start": 0.18,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 1.15,
			"foam_noise_speed": 0.18,
			"foam_cutoff": 0.94,
			"foam_crest_threshold": 0.985,
			"foam_crest_amount": 0.12,
			"foam_edge_color": Color(0.0, 0.0, 0.019607844, 1.0),
			"foam_edge_offset": Vector2(0.01, 0.01),
			"voronoi_scale": 5.0,
			"voronoi_strength": 0.18,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.02,
				"gradient_offsets": [0.0, 0.52, 1.0],
				"gradient_colors": [
					Color(0.019607844, 0.027450981, 0.047058824, 1.0),
					Color(0.17254902, 0.21568628, 0.27450982, 1.0),
					Color(0.7019608, 0.7372549, 0.8117647, 1.0),
				],
			},
			"caustics_scale": 1.1,
			"caustics_speed": 0.04,
			"caustics_intensity": 0.12,
			"caustics_depth_fade": 0.5,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/wine_still": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.002,
			"max_depth": 0.025,
			"refraction_strength": 0.02,
			"refraction_distance_fade": 0.25,
			"base_tint_color": Color(0.33333334, 0.05490196, 0.07058824, 1.0),
			"deep_color": Color(0.14901961, 0.011764706, 0.02745098, 1.0),
			"water_absorption": Color(0.39215687, 0.08627451, 0.09411765, 1.0),
			"underwater_fog_color": Color(0.12156863, 0.011764706, 0.023529412, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 1.0,
			"sea_height": 0.0009,
			"sea_choppy": 0.06,
			"sea_speed": 0.008,
			"sea_freq": 0.35,
			"roughness": 0.08,
			"metallic": 0.0,
			"specular": 0.42,
			"foam_color": Color(0.54509807, 0.14901961, 0.16862746, 1.0),
			"foam_depth_start": 0.0,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.2,
			"foam_noise_speed": 0.0,
			"foam_cutoff": 0.999,
			"foam_crest_threshold": 0.999,
			"foam_crest_amount": 0.0,
			"foam_edge_color": Color(0.0, 0.0, 0.0, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 1.0,
			"voronoi_strength": 0.01,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.04,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.10980392, 0.011764706, 0.019607844, 1.0),
					Color(0.28235295, 0.03529412, 0.05490196, 1.0),
					Color(0.47058824, 0.10980392, 0.1254902, 1.0),
				],
			},
			"caustics_scale": 0.12,
			"caustics_speed": 0.002,
			"caustics_intensity": 0.01,
			"caustics_depth_fade": 0.1,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/wine_agitated": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.002,
			"max_depth": 0.025,
			"refraction_strength": 0.04,
			"refraction_distance_fade": 0.25,
			"base_tint_color": Color(0.34901962, 0.05882353, 0.078431375, 1.0),
			"deep_color": Color(0.15686275, 0.015686275, 0.03137255, 1.0),
			"water_absorption": Color(0.40784314, 0.09411765, 0.101960786, 1.0),
			"underwater_fog_color": Color(0.12156863, 0.011764706, 0.023529412, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 1.0,
			"sea_height": 0.0035,
			"sea_choppy": 0.22,
			"sea_speed": 0.07,
			"sea_freq": 0.5,
			"roughness": 0.07,
			"metallic": 0.0,
			"specular": 0.45,
			"foam_color": Color(0.58431375, 0.17254902, 0.1882353, 1.0),
			"foam_depth_start": 0.0,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.3,
			"foam_noise_speed": 0.01,
			"foam_cutoff": 0.999,
			"foam_crest_threshold": 0.999,
			"foam_crest_amount": 0.0,
			"foam_edge_color": Color(0.0, 0.0, 0.0, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 1.2,
			"voronoi_strength": 0.02,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.055,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.10980392, 0.011764706, 0.019607844, 1.0),
					Color(0.31764707, 0.043137256, 0.0627451, 1.0),
					Color(0.50980395, 0.13333334, 0.15294118, 1.0),
				],
			},
			"caustics_scale": 0.14,
			"caustics_speed": 0.004,
			"caustics_intensity": 0.012,
			"caustics_depth_fade": 0.1,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/font_still": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.02,
			"max_depth": 0.55,
			"refraction_strength": 0.1,
			"refraction_distance_fade": 2.0,
			"base_tint_color": Color(0.09019608, 0.15686275, 0.21176471, 1.0),
			"deep_color": Color(0.03137255, 0.06666667, 0.12156863, 1.0),
			"water_absorption": Color(0.23529412, 0.31764707, 0.39215687, 1.0),
			"underwater_fog_color": Color(0.023529412, 0.050980393, 0.09019608, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 6.0,
			"sea_height": 0.008,
			"sea_choppy": 0.25,
			"sea_speed": 0.03,
			"sea_freq": 0.8,
			"roughness": 0.07,
			"metallic": 0.0,
			"specular": 0.55,
			"foam_color": Color(0.85882354, 0.9019608, 0.9529412, 1.0),
			"foam_depth_start": 0.04,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.6,
			"foam_noise_speed": 0.02,
			"foam_cutoff": 0.995,
			"foam_crest_threshold": 0.998,
			"foam_crest_amount": 0.02,
			"foam_edge_color": Color(0.0, 0.0, 0.011764706, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 2.2,
			"voronoi_strength": 0.04,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.03,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.023529412, 0.039215688, 0.06666667, 1.0),
					Color(0.12156863, 0.1882353, 0.2509804, 1.0),
					Color(0.7176471, 0.8, 0.9019608, 1.0),
				],
			},
			"caustics_scale": 0.45,
			"caustics_speed": 0.01,
			"caustics_intensity": 0.05,
			"caustics_depth_fade": 0.35,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/font_disturbed": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.02,
			"max_depth": 0.55,
			"refraction_strength": 0.16,
			"refraction_distance_fade": 2.0,
			"base_tint_color": Color(0.09019608, 0.15686275, 0.21176471, 1.0),
			"deep_color": Color(0.03137255, 0.06666667, 0.12156863, 1.0),
			"water_absorption": Color(0.23529412, 0.31764707, 0.39215687, 1.0),
			"underwater_fog_color": Color(0.023529412, 0.050980393, 0.09019608, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 6.0,
			"sea_height": 0.02,
			"sea_choppy": 0.55,
			"sea_speed": 0.22,
			"sea_freq": 0.85,
			"roughness": 0.07,
			"metallic": 0.0,
			"specular": 0.58,
			"foam_color": Color(0.8784314, 0.92156863, 0.96862745, 1.0),
			"foam_depth_start": 0.06,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.9,
			"foam_noise_speed": 0.12,
			"foam_cutoff": 0.985,
			"foam_crest_threshold": 0.992,
			"foam_crest_amount": 0.08,
			"foam_edge_color": Color(0.0, 0.0, 0.011764706, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 2.6,
			"voronoi_strength": 0.1,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.035,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.023529412, 0.039215688, 0.06666667, 1.0),
					Color(0.12156863, 0.1882353, 0.2509804, 1.0),
					Color(0.7176471, 0.8, 0.9019608, 1.0),
				],
			},
			"caustics_scale": 0.5,
			"caustics_speed": 0.02,
			"caustics_intensity": 0.06,
			"caustics_depth_fade": 0.35,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/font_searched": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.02,
			"max_depth": 0.55,
			"refraction_strength": 0.08,
			"refraction_distance_fade": 2.0,
			"base_tint_color": Color(0.078431375, 0.14117648, 0.19607843, 1.0),
			"deep_color": Color(0.02745098, 0.05882353, 0.105882354, 1.0),
			"water_absorption": Color(0.21568628, 0.28627452, 0.36078432, 1.0),
			"underwater_fog_color": Color(0.019607844, 0.043137256, 0.078431375, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 6.0,
			"sea_height": 0.006,
			"sea_choppy": 0.18,
			"sea_speed": 0.02,
			"sea_freq": 0.72,
			"roughness": 0.08,
			"metallic": 0.0,
			"specular": 0.45,
			"foam_color": Color(0.81960785, 0.87058824, 0.92941177, 1.0),
			"foam_depth_start": 0.035,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.5,
			"foam_noise_speed": 0.01,
			"foam_cutoff": 0.998,
			"foam_crest_threshold": 0.999,
			"foam_crest_amount": 0.01,
			"foam_edge_color": Color(0.0, 0.0, 0.011764706, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 2.0,
			"voronoi_strength": 0.03,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.03,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.019607844, 0.027450981, 0.047058824, 1.0),
					Color(0.10980392, 0.16470589, 0.22352941, 1.0),
					Color(0.65882355, 0.7294118, 0.8352941, 1.0),
				],
			},
			"caustics_scale": 0.4,
			"caustics_speed": 0.01,
			"caustics_intensity": 0.04,
			"caustics_depth_fade": 0.3,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/bucket_still": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.01,
			"max_depth": 0.2,
			"refraction_strength": 0.05,
			"refraction_distance_fade": 1.0,
			"base_tint_color": Color(0.07058824, 0.08627451, 0.09803922, 1.0),
			"deep_color": Color(0.02745098, 0.03529412, 0.043137256, 1.0),
			"water_absorption": Color(0.16862746, 0.20392157, 0.23137255, 1.0),
			"underwater_fog_color": Color(0.019607844, 0.023529412, 0.03137255, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 4.0,
			"sea_height": 0.0035,
			"sea_choppy": 0.16,
			"sea_speed": 0.015,
			"sea_freq": 0.55,
			"roughness": 0.1,
			"metallic": 0.0,
			"specular": 0.45,
			"foam_color": Color(0.6117647, 0.67058825, 0.7294118, 1.0),
			"foam_depth_start": 0.01,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.4,
			"foam_noise_speed": 0.01,
			"foam_cutoff": 0.999,
			"foam_crest_threshold": 0.999,
			"foam_crest_amount": 0.0,
			"foam_edge_color": Color(0.0, 0.0, 0.0, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 1.5,
			"voronoi_strength": 0.02,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.025,
				"gradient_offsets": [0.0, 0.6, 1.0],
				"gradient_colors": [
					Color(0.023529412, 0.02745098, 0.03529412, 1.0),
					Color(0.09019608, 0.105882354, 0.11764706, 1.0),
					Color(0.31764707, 0.3529412, 0.3882353, 1.0),
				],
			},
			"caustics_scale": 0.25,
			"caustics_speed": 0.005,
			"caustics_intensity": 0.02,
			"caustics_depth_fade": 0.2,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/bucket_rippled": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.01,
			"max_depth": 0.24,
			"refraction_strength": 0.11,
			"refraction_distance_fade": 1.0,
			"base_tint_color": Color(0.078431375, 0.09803922, 0.11372549, 1.0),
			"deep_color": Color(0.02745098, 0.039215688, 0.050980393, 1.0),
			"water_absorption": Color(0.18039216, 0.21960784, 0.24705882, 1.0),
			"underwater_fog_color": Color(0.023529412, 0.02745098, 0.03529412, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 4.0,
			"sea_height": 0.012,
			"sea_choppy": 0.42,
			"sea_speed": 0.12,
			"sea_freq": 0.7,
			"roughness": 0.08,
			"metallic": 0.0,
			"specular": 0.5,
			"foam_color": Color(0.7058824, 0.7607843, 0.81960785, 1.0),
			"foam_depth_start": 0.015,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.8,
			"foam_noise_speed": 0.08,
			"foam_cutoff": 0.991,
			"foam_crest_threshold": 0.994,
			"foam_crest_amount": 0.03,
			"foam_edge_color": Color(0.0, 0.0, 0.0, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 2.0,
			"voronoi_strength": 0.06,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.035,
				"gradient_offsets": [0.0, 0.6, 1.0],
				"gradient_colors": [
					Color(0.023529412, 0.02745098, 0.03529412, 1.0),
					Color(0.10980392, 0.1254902, 0.14117648, 1.0),
					Color(0.3882353, 0.43137255, 0.4745098, 1.0),
				],
			},
			"caustics_scale": 0.3,
			"caustics_speed": 0.012,
			"caustics_intensity": 0.03,
			"caustics_depth_fade": 0.2,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/tea_still": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.003,
			"max_depth": 0.03,
			"refraction_strength": 0.03,
			"refraction_distance_fade": 0.4,
			"base_tint_color": Color(0.36078432, 0.19215687, 0.078431375, 1.0),
			"deep_color": Color(0.18039216, 0.09019608, 0.03529412, 1.0),
			"water_absorption": Color(0.40784314, 0.2627451, 0.13725491, 1.0),
			"underwater_fog_color": Color(0.14509805, 0.078431375, 0.03137255, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 2.0,
			"sea_height": 0.0015,
			"sea_choppy": 0.1,
			"sea_speed": 0.01,
			"sea_freq": 0.4,
			"roughness": 0.14,
			"metallic": 0.0,
			"specular": 0.35,
			"foam_color": Color(0.7490196, 0.6156863, 0.47058824, 1.0),
			"foam_depth_start": 0.0,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.2,
			"foam_noise_speed": 0.0,
			"foam_cutoff": 0.999,
			"foam_crest_threshold": 0.999,
			"foam_crest_amount": 0.0,
			"foam_edge_color": Color(0.0, 0.0, 0.0, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 1.2,
			"voronoi_strength": 0.01,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.03,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.16862746, 0.08235294, 0.03137255, 1.0),
					Color(0.3529412, 0.18039216, 0.07058824, 1.0),
					Color(0.5921569, 0.34509805, 0.14509805, 1.0),
				],
			},
			"caustics_scale": 0.15,
			"caustics_speed": 0.002,
			"caustics_intensity": 0.01,
			"caustics_depth_fade": 0.1,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"liquid/tea_disturbed": {
		"family": "liquid",
		"kind": "shader_material",
		"shader_path": WATER_SHADER_PATH,
		"shader_params": {
			"fade_start_depth": 0.003,
			"max_depth": 0.03,
			"refraction_strength": 0.06,
			"refraction_distance_fade": 0.4,
			"base_tint_color": Color(0.38039216, 0.21176471, 0.09019608, 1.0),
			"deep_color": Color(0.19607843, 0.09411765, 0.039215688, 1.0),
			"water_absorption": Color(0.42745098, 0.27058825, 0.14901961, 1.0),
			"underwater_fog_color": Color(0.14509805, 0.078431375, 0.03137255, 1.0),
			"normal_epsilon": 0.01,
			"normal_smoothness_dist": 2.0,
			"sea_height": 0.005,
			"sea_choppy": 0.32,
			"sea_speed": 0.08,
			"sea_freq": 0.55,
			"roughness": 0.12,
			"metallic": 0.0,
			"specular": 0.38,
			"foam_color": Color(0.77254903, 0.6431373, 0.4862745, 1.0),
			"foam_depth_start": 0.0,
			"foam_depth_end": 0.0,
			"foam_noise_scale": 0.35,
			"foam_noise_speed": 0.01,
			"foam_cutoff": 0.999,
			"foam_crest_threshold": 0.999,
			"foam_crest_amount": 0.0,
			"foam_edge_color": Color(0.0, 0.0, 0.0, 1.0),
			"foam_edge_offset": Vector2(0.004, 0.004),
			"voronoi_scale": 1.5,
			"voronoi_strength": 0.03,
			"caustics_texture": {
				"type": "noise_texture_2d",
				"frequency": 0.05,
				"gradient_offsets": [0.0, 0.55, 1.0],
				"gradient_colors": [
					Color(0.16862746, 0.08235294, 0.03137255, 1.0),
					Color(0.3764706, 0.20392157, 0.08235294, 1.0),
					Color(0.6313726, 0.3764706, 0.16470589, 1.0),
				],
			},
			"caustics_scale": 0.18,
			"caustics_speed": 0.004,
			"caustics_intensity": 0.015,
			"caustics_depth_fade": 0.1,
			"ITER_GEOMETRY": 2,
			"ITER_FRAGMENT": 4,
		},
	},
	"terrain/carriage_road": {
		"family": "terrain_path",
		"kind": "standard",
		"slots": {
			"albedo": CARRIAGE_TEXTURE,
			"normal": CARRIAGE_NORMAL,
			"roughness": CARRIAGE_ROUGHNESS,
			"ao": CARRIAGE_AO,
		},
		"options": {
			"ao_light_affect": 0.78,
			"normal_scale": 1.18,
			"albedo_color": Color(0.28, 0.26, 0.23, 1.0),
			"roughness": 0.92,
			"triplanar": true,
			"uv1_scale": Vector3(1.52, 1.0, 1.52),
		},
	},
	"terrain/carriage_track": {
		"family": "terrain_path",
		"kind": "standard",
		"slots": {
			"albedo": CARRIAGE_TEXTURE,
			"normal": CARRIAGE_NORMAL,
			"roughness": CARRIAGE_ROUGHNESS,
			"ao": CARRIAGE_AO,
		},
		"options": {
			"ao_light_affect": 0.82,
			"normal_scale": 1.24,
			"albedo_color": Color(0.18, 0.16, 0.14, 1.0),
			"roughness": 0.96,
			"triplanar": true,
			"uv1_scale": Vector3(1.72, 1.0, 1.72),
		},
	},
	"terrain/roadside_earth": {
		"family": "terrain_path",
		"kind": "standard",
		"slots": {
			"albedo": EARTH_TEXTURE,
			"normal": EARTH_NORMAL,
			"roughness": EARTH_ROUGHNESS,
			"ao": EARTH_AO,
		},
		"options": {
			"ao_light_affect": 0.76,
			"normal_scale": 1.05,
			"albedo_color": Color(0.2, 0.17, 0.12, 1.0),
			"roughness": 0.9,
			"triplanar": true,
			"uv1_scale": Vector3(1.54, 1.0, 1.54),
		},
	},
	"foliage/hedge_mass": {
		"family": "foliage",
		"kind": "standard",
		"slots": {
			"albedo": HEDGE_MASS_TEXTURE,
			"normal": HEDGE_MASS_NORMAL,
			"roughness": HEDGE_MASS_ROUGHNESS,
			"ao": HEDGE_MASS_AO,
		},
		"options": {
			"ao_light_affect": 0.58,
			"normal_scale": 1.22,
			"albedo_color": Color(0.18, 0.27, 0.16, 1.0),
			"roughness": 0.72,
			"metallic": 0.0,
			"triplanar": true,
			"uv1_scale": Vector3(1.45, 1.0, 1.45),
			"rim_enabled": true,
			"rim": 0.008,
			"rim_tint": 0.03,
		},
	},
	"foliage/hedge_card": {
		"family": "foliage",
		"kind": "foliage_shader",
		"slots": {
			"albedo": HEDGE_CARD_TEXTURE,
			"normal": HEDGE_CARD_NORMAL,
			"opacity": HEDGE_CARD_OPACITY,
			"thickness": HEDGE_CARD_OPACITY,
		},
		"options": {
			"base_tint": Color(0.24, 0.35, 0.2, 1.0),
			"roughness": 0.9,
			"specular_strength": 0.12,
			"sigma": 0.54,
			"scale": 1.65,
			"power": 4.8,
			"alpha_cutoff": 0.2,
			"vertex_sway_enabled": false,
		},
	},
	"foliage/hedge_panel": {
		"family": "foliage",
		"kind": "standard",
		"slots": {
			"albedo": HEDGE_WALL_TEXTURE,
		},
		"options": {
			"albedo_color": Color(0.2, 0.29, 0.18, 1.0),
			"roughness": 0.95,
			"double_sided": true,
			"uv1_scale": Vector3(8.0, 2.4, 1.0),
		},
	},
	"foliage/lily_leaf": {
		"family": "foliage",
		"kind": "standard",
		"slots": {},
		"options": {
			"albedo_color": Color(0.28, 0.42, 0.22, 1.0),
			"roughness": 0.86,
			"double_sided": true,
			"rim_enabled": true,
			"rim": 0.02,
			"rim_tint": 0.08,
		},
	},
}

const LEGACY_SURFACE_ALIASES := {
	BRICK_TEXTURE: "surface/brick_masonry",
	"res://assets/shared/pbr/grounds/estate_earth_color.jpg": "terrain/roadside_earth",
	"res://assets/shared/pbr/grounds/carriage_gravel_color.jpg": "terrain/carriage_road",
	CARRIAGE_TEXTURE: "terrain/carriage_road",
	HEDGE_MASS_TEXTURE: "foliage/hedge_mass",
	HEDGE_WALL_TEXTURE: "foliage/hedge_panel",
}


static func recipe_exists(recipe_id: String) -> bool:
	return RECIPE_LIBRARY.has(recipe_id)


static func get_recipe_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for recipe_id in RECIPE_LIBRARY.keys():
		ids.append(recipe_id)
	return ids


static func get_recipe_family(recipe_id: String) -> String:
	var recipe: Dictionary = RECIPE_LIBRARY.get(recipe_id, {})
	return String(recipe.get("family", ""))


static func get_recipe_kind(recipe_id: String) -> String:
	var recipe: Dictionary = RECIPE_LIBRARY.get(recipe_id, {})
	return String(recipe.get("kind", ""))


static func get_recipe_definition(recipe_id: String) -> Dictionary:
	var recipe: Dictionary = RECIPE_LIBRARY.get(recipe_id, {})
	return recipe.duplicate(true)


static func is_supported_recipe_kind(recipe_kind: String) -> bool:
	return SUPPORTED_RECIPE_KINDS.has(recipe_kind)


static func get_recipe_slots(recipe_id: String) -> Dictionary:
	var recipe: Dictionary = RECIPE_LIBRARY.get(recipe_id, {})
	return PBRTextureKit.normalize_slots(recipe.get("slots", {}))


static func build(recipe_id: String, overrides: Dictionary = {}) -> Material:
	var recipe: Dictionary = RECIPE_LIBRARY.get(recipe_id, {})
	if recipe.is_empty():
		return null
	var slots := PBRTextureKit.normalize_slots(recipe.get("slots", {}))
	var options := _merge_dictionary(recipe.get("options", {}), overrides)
	var shader_params := _merge_dictionary(recipe.get("shader_params", {}), overrides.get("shader_params", {}))
	if overrides.has("slots"):
		slots = _merge_dictionary(slots, PBRTextureKit.normalize_slots(overrides.get("slots", {})))
	match String(recipe.get("kind", "standard")):
		"foliage_shader":
			return _build_foliage_material(slots, options)
		"shader_material":
			return _build_shader_material(String(recipe.get("shader_path", "")), shader_params, slots, options)
		_:
			return PBRTextureKit.build_material_from_slots(slots, options)


static func build_surface_reference(surface_ref: String, options: Dictionary = {}) -> Material:
	if surface_ref.is_empty():
		return null
	if surface_ref.begins_with("recipe:"):
		return build(surface_ref.trim_prefix("recipe:"), options)
	if LEGACY_SURFACE_ALIASES.has(surface_ref):
		return build(String(LEGACY_SURFACE_ALIASES[surface_ref]), options)
	return PBRTextureKit.build_material(surface_ref, options)


static func resolve_surface_reference(surface_ref: String, fallback_surface_ref: String) -> String:
	if not surface_ref.is_empty():
		return surface_ref
	return fallback_surface_ref


static func brass() -> StandardMaterial3D:
	return build("surface/brass") as StandardMaterial3D


static func chain_iron() -> StandardMaterial3D:
	return build("surface/chain_iron") as StandardMaterial3D


static func wrought_iron() -> StandardMaterial3D:
	return build("surface/wrought_iron") as StandardMaterial3D


static func oak_dark() -> StandardMaterial3D:
	return build("surface/oak_dark") as StandardMaterial3D


static func oak_board() -> StandardMaterial3D:
	return build("surface/oak_board") as StandardMaterial3D


static func oak_header() -> StandardMaterial3D:
	return build("surface/oak_header") as StandardMaterial3D


static func leather_valise() -> StandardMaterial3D:
	return build("surface/leather_valise") as StandardMaterial3D


static func paper() -> StandardMaterial3D:
	return build("surface/paper") as StandardMaterial3D


static func cloth_brown() -> StandardMaterial3D:
	return build("surface/cloth_brown") as StandardMaterial3D


static func lining_tan() -> StandardMaterial3D:
	return build("surface/lining_tan") as StandardMaterial3D


static func branch_dark() -> StandardMaterial3D:
	return build("surface/branch_dark") as StandardMaterial3D


static func brick_masonry() -> StandardMaterial3D:
	return build("surface/brick_masonry") as StandardMaterial3D


static func masonry_cap() -> StandardMaterial3D:
	return build("surface/masonry_cap") as StandardMaterial3D


static func window_glass() -> Material:
	return build("glass/window_glass")


static func facade_dark_glass() -> Material:
	return build("glass/facade_dark")


static func door_lamplit_glass() -> Material:
	return build("glass/door_lamplit")


static func crystal_glass() -> Material:
	return build("glass/crystal_glass")


static func greenhouse_glass() -> Material:
	return build("glass/greenhouse_glass")


static func fallback_wood() -> StandardMaterial3D:
	return build("surface/fallback_wood") as StandardMaterial3D


static func fallback_metal() -> StandardMaterial3D:
	return build("surface/fallback_metal") as StandardMaterial3D


static func shadow_void() -> StandardMaterial3D:
	return build("surface/shadow_void") as StandardMaterial3D


static func shadow_void_tinted(color: Color) -> StandardMaterial3D:
	var material := shadow_void()
	if material != null:
		material = material.duplicate()
		material.albedo_color = color
	return material


static func flat_unshaded(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.roughness = 1.0
	material.metallic = 0.0
	return material


static func emissive_unshaded(
	color: Color,
	energy: float,
	transparency: BaseMaterial3D.Transparency = BaseMaterial3D.TRANSPARENCY_DISABLED,
	depth_draw_mode: BaseMaterial3D.DepthDrawMode = BaseMaterial3D.DEPTH_DRAW_OPAQUE_ONLY,
	double_sided := false
) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.emission_enabled = true
	material.emission = Color(color.r, color.g, color.b, 1.0)
	material.emission_energy_multiplier = energy
	material.roughness = 0.0
	material.metallic = 0.0
	material.transparency = transparency
	material.depth_draw_mode = depth_draw_mode
	if double_sided:
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
	return material


static func window_glow(color: Color = Color(0.98, 0.8, 0.54, 1.0), energy := 3.1) -> StandardMaterial3D:
	return emissive_unshaded(color, energy)


static func fog_glow(color: Color, energy: float) -> StandardMaterial3D:
	return emissive_unshaded(
		color,
		energy,
		BaseMaterial3D.TRANSPARENCY_ALPHA,
		BaseMaterial3D.DEPTH_DRAW_DISABLED,
		true
	)


static func star_glow(major: bool, variance: float) -> StandardMaterial3D:
	var tint := Color(0.92 + variance * 0.05, 0.94 + variance * 0.04, 1.0, 1.0)
	return emissive_unshaded(tint, 1.0 if major else 0.68)


static func legacy_texture_surface(texture: Texture2D, double_sided := false) -> StandardMaterial3D:
	if texture == null:
		return null
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	if double_sided:
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
	return material


static func legacy_texture_unshaded(texture: Texture2D, color: Color, filter_mode: BaseMaterial3D.TextureFilter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC) -> StandardMaterial3D:
	var material := legacy_texture_surface(texture)
	if material == null:
		material = flat_unshaded(color)
	else:
		material.albedo_color = color
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.texture_filter = filter_mode
	return material


static func pond_water() -> Material:
	return build("liquid/estate_pond_water")


static func wine_still() -> Material:
	return build("liquid/wine_still")


static func wine_agitated() -> Material:
	return build("liquid/wine_agitated")


static func font_water_still() -> Material:
	return build("liquid/font_still")


static func font_water_disturbed() -> Material:
	return build("liquid/font_disturbed")


static func font_water_searched() -> Material:
	return build("liquid/font_searched")


static func bucket_water_still() -> Material:
	return build("liquid/bucket_still")


static func bucket_water_rippled() -> Material:
	return build("liquid/bucket_rippled")


static func tea_still() -> Material:
	return build("liquid/tea_still")


static func tea_disturbed() -> Material:
	return build("liquid/tea_disturbed")


static func carriage_road() -> StandardMaterial3D:
	return build("terrain/carriage_road") as StandardMaterial3D


static func carriage_road_track() -> StandardMaterial3D:
	return build("terrain/carriage_track") as StandardMaterial3D


static func roadside_earth() -> StandardMaterial3D:
	return build("terrain/roadside_earth") as StandardMaterial3D


static func hedge(base_tint: Color, uv_scale: Vector3, highlight := false) -> StandardMaterial3D:
	return build("foliage/hedge_mass", {
		"albedo_color": base_tint,
		"uv1_scale": uv_scale,
		"rim_enabled": true,
		"rim": 0.018 if highlight else 0.008,
		"rim_tint": 0.072 if highlight else 0.03,
	}) as StandardMaterial3D


static func hedge_card(base_tint: Color, _uv_scale: Vector3, highlight := false) -> Material:
	return build("foliage/hedge_card", {
		"base_tint": base_tint,
		"roughness": 0.86 if highlight else 0.9,
		"specular_strength": 0.18 if highlight else 0.12,
		"sigma": 0.62 if highlight else 0.54,
		"scale": 1.95 if highlight else 1.65,
		"power": 4.2 if highlight else 4.8,
		"attenuation_influence": 0.72 if highlight else 0.62,
		"albedo_influence": 0.76 if highlight else 0.72,
		"light_color_influence": 0.24 if highlight else 0.28,
		"use_thickness_map": true,
		"vertex_sway_enabled": true,
		"vertex_sway_intensity": 0.035 if highlight else 0.028,
		"sway_speed": 0.58 if highlight else 0.52,
		"gust_scale": 0.12,
		"gust_speed": 0.82,
		"gust_strength": 0.32 if highlight else 0.24,
		"gust_frequency": 0.48,
		"wind_direction": Vector2(1.0, 0.3),
	})


static func hedge_wall_panel(base_tint: Color) -> StandardMaterial3D:
	return build("foliage/hedge_panel", {
		"albedo_color": base_tint,
	}) as StandardMaterial3D


static func _build_foliage_material(slots: Dictionary, options: Dictionary) -> Material:
	var material := ShaderMaterial.new()
	material.shader = FOLIAGE_SHADER
	material.set_shader_parameter("albedo_tex", _load_texture(String(slots.get("albedo", ""))))
	material.set_shader_parameter("normal_tex", _load_texture(String(slots.get("normal", ""))))
	material.set_shader_parameter("opacity_tex", _load_texture(String(slots.get("opacity", ""))))
	material.set_shader_parameter("thickness_tex", _load_texture(String(slots.get("thickness", ""))))
	material.set_shader_parameter("base_tint", options.get("base_tint", Color(1, 1, 1, 1)))
	material.set_shader_parameter("roughness", float(options.get("roughness", 0.9)))
	material.set_shader_parameter("specular_strength", float(options.get("specular_strength", 0.12)))
	material.set_shader_parameter("sigma", float(options.get("sigma", 0.54)))
	material.set_shader_parameter("scale", float(options.get("scale", 1.65)))
	material.set_shader_parameter("power", float(options.get("power", 4.8)))
	material.set_shader_parameter("attenuation_influence", float(options.get("attenuation_influence", 0.62)))
	material.set_shader_parameter("albedo_influence", float(options.get("albedo_influence", 0.72)))
	material.set_shader_parameter("light_color_influence", float(options.get("light_color_influence", 0.28)))
	material.set_shader_parameter("alpha_cutoff", float(options.get("alpha_cutoff", 0.2)))
	material.set_shader_parameter("vertex_sway_enabled", bool(options.get("vertex_sway_enabled", false)))
	material.set_shader_parameter("vertex_sway_intensity", float(options.get("vertex_sway_intensity", 0.08)))
	material.set_shader_parameter("sway_speed", float(options.get("sway_speed", 0.55)))
	material.set_shader_parameter("gust_scale", float(options.get("gust_scale", 0.05)))
	material.set_shader_parameter("gust_speed", float(options.get("gust_speed", 0.8)))
	material.set_shader_parameter("gust_strength", float(options.get("gust_strength", 1.5)))
	material.set_shader_parameter("gust_frequency", float(options.get("gust_frequency", 0.5)))
	material.set_shader_parameter("wind_direction", options.get("wind_direction", Vector2(1.0, 0.2)))
	material.set_shader_parameter("use_opacity", bool(options.get("use_opacity", true)))
	material.set_shader_parameter("use_thickness_map", bool(options.get("use_thickness_map", not String(slots.get("thickness", "")).is_empty())))
	return material


static func _build_shader_material(shader_path: String, shader_params: Dictionary, slots: Dictionary, options: Dictionary) -> Material:
	if shader_path.is_empty() or not ResourceLoader.exists(shader_path):
		return null
	var shader := load(shader_path) as Shader
	if shader == null:
		return null
	var material := ShaderMaterial.new()
	material.shader = shader

	var slot_bindings: Dictionary = options.get("slot_bindings", {})
	for slot_name in slot_bindings.keys():
		var param_name := String(slot_bindings.get(slot_name, ""))
		var texture_path := String(slots.get(String(slot_name), ""))
		if param_name.is_empty() or texture_path.is_empty():
			continue
		shader_params[param_name] = _load_texture(texture_path)

	for param_name in shader_params.keys():
		material.set_shader_parameter(String(param_name), _resolve_shader_parameter_value(shader_params[param_name]))
	return material


static func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D


static func _resolve_shader_parameter_value(value: Variant) -> Variant:
	if value is String:
		var path := String(value)
		if path.begins_with("res://") and ResourceLoader.exists(path):
			return load(path)
		return value
	if value is Dictionary:
		var spec := value as Dictionary
		match String(spec.get("type", "")):
			"noise_texture_2d":
				return _build_noise_texture(spec)
	return value


static func _build_noise_texture(spec: Dictionary) -> NoiseTexture2D:
	var noise := FastNoiseLite.new()
	noise.frequency = float(spec.get("frequency", 0.02))

	var texture := NoiseTexture2D.new()
	texture.noise = noise

	if spec.has("gradient_colors"):
		var gradient := Gradient.new()
		gradient.offsets = PackedFloat32Array(spec.get("gradient_offsets", []))
		gradient.colors = PackedColorArray(spec.get("gradient_colors", []))
		texture.color_ramp = gradient

	return texture


static func _merge_dictionary(base: Dictionary, overrides: Dictionary) -> Dictionary:
	var merged := base.duplicate(true)
	for key in overrides.keys():
		if key == "slots":
			continue
		merged[key] = overrides[key]
	return merged
