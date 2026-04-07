class_name RoomSpecData
## Static room spec data for test_room_specs.gd
## Each entry: room_id → { interactables, connections, min_lights, has_flickering, require_spawn }

static func get_all() -> Dictionary:
	return {
		"front_gate": {
			"interactables": ["gate_sign_new_game", "gate_sign_load_game", "gate_sign_settings", "gate_plaque", "gate_luggage", "gate_bench", "iron_gate", "gate_lamp"],
			"connections": ["drive_lower"],
			"min_lights": 3, "has_flickering": true, "require_spawn": true,
		},
		"drive_lower": {
			"interactables": ["drive_lower_path", "drive_lower_hedge"],
			"connections": ["front_gate", "drive_upper"],
			"min_lights": 1, "has_flickering": false, "require_spawn": true,
		},
		"drive_upper": {
			"interactables": ["drive_upper_ascent", "drive_upper_statue"],
			"connections": ["drive_lower", "front_steps"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"front_steps": {
			"interactables": ["front_steps_door", "front_steps_lamp", "front_steps_service_gate", "front_steps_garden_gate"],
			"connections": ["drive_upper", "foyer"],
			"min_lights": 4, "has_flickering": true, "require_spawn": true,
		},
		"foyer": {
			"interactables": ["foyer_painting", "foyer_mirror", "foyer_clock", "entry_switch", "foyer_mail", "foyer_stairs"],
			"connections": ["parlor", "dining_room", "kitchen", "upper_hallway", "front_steps"],
			"min_lights": 6, "has_flickering": true, "require_spawn": true,
		},
		"parlor": {
			"interactables": ["parlor_painting_1", "parlor_note", "music_box", "parlor_fireplace", "parlor_tea"],
			"connections": ["foyer"],
			"min_lights": 3, "has_flickering": true, "require_spawn": true,
		},
		"dining_room": {
			"interactables": ["dinner_photo", "pushed_chair", "wine_glass", "dining_candles", "service_bell"],
			"connections": ["foyer"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"kitchen": {
			"interactables": ["service_hatch_prop", "kitchen_note", "kitchen_hearth"],
			"connections": ["foyer", "storage_basement", "garden"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"upper_hallway": {
			"interactables": ["attic_door", "children_painting", "hallway_mask", "hallway_poster", "hallway_switch"],
			"connections": ["foyer", "master_bedroom", "library", "guest_room", "attic_stairs"],
			"min_lights": 3, "has_flickering": true, "require_spawn": false,
		},
		"master_bedroom": {
			"interactables": ["diary_lord", "bedroom_mirror", "jewelry_box", "master_bed", "bedroom_book", "bedroom_wardrobe", "bedroom_broken_bottle"],
			"connections": ["upper_hallway"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"library": {
			"interactables": ["library_globe", "binding_book", "family_tree", "library_artifact", "library_shelves", "library_gears"],
			"connections": ["upper_hallway"],
			"min_lights": 2, "has_flickering": false, "require_spawn": true,
		},
		"guest_room": {
			"interactables": ["guest_ledger", "helena_photo", "guest_luggage", "guest_bed", "guest_lamp"],
			"connections": ["upper_hallway"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"storage_basement": {
			"interactables": ["scratched_portrait", "basement_cage", "service_stack", "basement_mattress", "improvised_relight"],
			"connections": ["kitchen", "boiler_room", "wine_cellar", "carriage_house"],
			"min_lights": 4, "has_flickering": true, "require_spawn": false,
		},
		"boiler_room": {
			"interactables": ["maintenance_log", "boiler_clock", "boiler_observation", "gas_restore", "boiler_pipes", "walking_cane"],
			"connections": ["storage_basement"],
			"min_lights": 4, "has_flickering": true, "require_spawn": true,
		},
		"wine_cellar": {
			"interactables": ["wine_note", "wine_box", "wine_racks", "wine_footprints"],
			"connections": ["storage_basement"],
			"min_lights": 2, "has_flickering": true, "require_spawn": false,
		},
		"attic_stairs": {
			"interactables": ["stairwell_debris", "stairwell_wall", "lantern_hook"],
			"connections": ["upper_hallway", "attic_storage"],
			"min_lights": 2, "has_flickering": true, "require_spawn": false,
		},
		"attic_storage": {
			"interactables": ["elizabeth_portrait", "porcelain_doll", "elizabeth_letter", "attic_window", "elizabeth_trunk", "ritual_mask", "attic_music_box"],
			"connections": ["attic_stairs", "hidden_chamber"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"hidden_chamber": {
			"interactables": ["elizabeth_final_note", "chamber_drawings", "hidden_mirror", "ritual_circle", "chamber_artifact"],
			"connections": ["attic_storage"],
			"min_lights": 3, "has_flickering": true, "require_spawn": true,
		},
		"garden": {
			"interactables": ["garden_lily", "garden_fountain", "garden_gazebo", "garden_beds", "garden_bench"],
			"connections": ["kitchen", "chapel", "greenhouse", "family_crypt"],
			"min_lights": 2, "has_flickering": true, "require_spawn": false,
		},
		"chapel": {
			"interactables": ["baptismal_font", "chapel_altar", "chapel_pews", "chapel_stained_glass_interactable", "chapel_bones"],
			"connections": ["garden"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
		"greenhouse": {
			"interactables": ["greenhouse_pot", "greenhouse_dead_plants", "greenhouse_glass", "greenhouse_bench"],
			"connections": ["garden"],
			"min_lights": 2, "has_flickering": false, "require_spawn": false,
		},
		"carriage_house": {
			"interactables": ["carriage_portrait", "carriage_mattress", "carriage_tools"],
			"connections": ["storage_basement"],
			"min_lights": 2, "has_flickering": true, "require_spawn": false,
		},
		"family_crypt": {
			"interactables": ["crypt_graves", "crypt_note", "crypt_flagstone", "crypt_bones"],
			"connections": ["garden"],
			"min_lights": 2, "has_flickering": true, "require_spawn": true,
		},
	}
