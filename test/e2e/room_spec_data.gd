class_name RoomSpecData
## Static room spec data for test_room_specs.gd
## Each entry: room_id → { interactables, connections, min_lights, has_flickering }

static func get_all() -> Dictionary:
	return {
		"front_gate": {
			"interactables": ["gate_plaque", "gate_luggage", "gate_bench", "iron_gate", "gate_lamp"],
			"connections": ["foyer", "garden"],
			"min_lights": 2, "has_flickering": true,
		},
		"foyer": {
			"interactables": ["foyer_painting", "foyer_mirror", "grandfather_clock", "entry_switch", "foyer_mail", "foyer_stairs"],
			"connections": ["parlor", "dining_room", "kitchen", "upper_hallway", "front_gate"],
			"min_lights": 4, "has_flickering": true,
		},
		"parlor": {
			"interactables": ["parlor_painting_1", "parlor_note", "music_box", "parlor_fireplace", "parlor_tea"],
			"connections": ["foyer"],
			"min_lights": 3, "has_flickering": true,
		},
		"dining_room": {
			"interactables": ["dinner_photo", "dining_pushed_chair", "dining_wine_glass", "dining_place_settings", "dining_candles", "dining_vessel"],
			"connections": ["foyer"],
			"min_lights": 3, "has_flickering": true,
		},
		"kitchen": {
			"interactables": ["kitchen_note", "kitchen_cutting_board", "kitchen_hearth", "kitchen_knives", "kitchen_bucket"],
			"connections": ["foyer", "storage_basement"],
			"min_lights": 1, "has_flickering": true,
		},
		"upper_hallway": {
			"interactables": ["attic_door", "children_painting", "hallway_mask", "hallway_poster", "hallway_switch"],
			"connections": ["foyer", "master_bedroom", "library", "guest_room"],
			"min_lights": 2, "has_flickering": true,
		},
		"master_bedroom": {
			"interactables": ["diary_lord", "bedroom_mirror", "jewelry_box", "bedroom_bed", "bedroom_book", "bedroom_wardrobe", "bedroom_broken_bottle"],
			"connections": ["upper_hallway"],
			"min_lights": 3, "has_flickering": true,
		},
		"library": {
			"interactables": ["library_globe", "binding_book", "family_tree", "library_artifact", "library_shelves", "library_gears"],
			"connections": ["upper_hallway"],
			"min_lights": 3, "has_flickering": true,
		},
		"guest_room": {
			"interactables": ["guest_ledger", "helena_photo", "guest_luggage", "guest_bed", "guest_lamp"],
			"connections": ["upper_hallway"],
			"min_lights": 2, "has_flickering": true,
		},
		"storage_basement": {
			"interactables": ["scratched_portrait", "storage_mirror", "storage_covered", "storage_trunk"],
			"connections": ["kitchen", "boiler_room", "wine_cellar"],
			"min_lights": 1, "has_flickering": true,
		},
		"boiler_room": {
			"interactables": ["maintenance_log", "boiler_clock", "boiler_observation", "boiler_pipes", "boiler_mask"],
			"connections": ["storage_basement"],
			"min_lights": 1, "has_flickering": true,
		},
		"wine_cellar": {
			"interactables": ["wine_note", "wine_box", "wine_racks", "wine_footprints"],
			"connections": ["storage_basement"],
			"min_lights": 2, "has_flickering": true,
		},
		"attic_stairs": {
			"interactables": ["stairwell_debris", "stairwell_wall"],
			"connections": ["upper_hallway", "attic_storage"],
			"min_lights": 1, "has_flickering": false,
		},
		"attic_storage": {
			"interactables": ["elizabeth_portrait", "porcelain_doll", "elizabeth_letter", "hidden_door", "attic_window", "elizabeth_trunk"],
			"connections": ["attic_stairs"],
			"min_lights": 2, "has_flickering": true,
		},
		"hidden_room": {
			"interactables": ["elizabeth_final_note", "chamber_drawings", "hidden_mirror", "ritual_circle", "chamber_artifact"],
			"connections": ["attic_storage"],
			"min_lights": 2, "has_flickering": true,
		},
		"garden": {
			"interactables": ["garden_lily", "garden_fountain", "garden_gazebo", "garden_beds"],
			"connections": ["front_gate", "chapel", "greenhouse"],
			"min_lights": 1, "has_flickering": false,
		},
		"chapel": {
			"interactables": ["baptismal_font", "chapel_altar", "chapel_pews", "chapel_glass", "chapel_bones"],
			"connections": ["garden"],
			"min_lights": 1, "has_flickering": true,
		},
		"greenhouse": {
			"interactables": ["greenhouse_pot", "greenhouse_dead", "greenhouse_glass"],
			"connections": ["garden"],
			"min_lights": 1, "has_flickering": false,
		},
		"carriage_house": {
			"interactables": ["carriage_portrait", "carriage_mattress", "carriage_boards"],
			"connections": ["front_gate"],
			"min_lights": 1, "has_flickering": false,
		},
		"family_crypt": {
			"interactables": ["crypt_graves", "crypt_note", "crypt_flagstone", "crypt_bones"],
			"connections": ["garden"],
			"min_lights": 1, "has_flickering": false,
		},
	}
