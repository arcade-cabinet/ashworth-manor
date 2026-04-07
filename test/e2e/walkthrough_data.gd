class_name WalkthroughData
## Play-order room visit list for test_room_walkthrough.gd
## Each entry: [room_id, [interactable_ids...], entry_from_room_id]

static func get_play_order() -> Array:
	return [
		# ACT I: Arrival
		["front_gate", ["gate_sign_new_game", "gate_sign_load_game", "gate_sign_settings", "gate_plaque", "iron_gate", "gate_luggage", "gate_bench", "gate_lamp"], ""],
		["drive_lower", ["drive_lower_path", "drive_lower_hedge"], "front_gate"],
		["drive_upper", ["drive_upper_ascent", "drive_upper_statue"], "drive_lower"],
		["front_steps", ["front_steps_door", "front_steps_lamp"], "drive_upper"],
		["foyer", ["foyer_painting", "foyer_mirror", "foyer_clock", "entry_switch", "foyer_mail", "foyer_stairs"], "front_steps"],
		["parlor", ["parlor_painting_1", "parlor_note", "music_box", "parlor_fireplace", "parlor_tea"], "foyer"],
		["dining_room", ["dinner_photo", "pushed_chair", "wine_glass", "dining_candles", "service_bell"], "foyer"],
		["kitchen", ["kitchen_note", "kitchen_hearth"], "foyer"],

		# ACT II: Upper Floor
		["upper_hallway", ["attic_door", "children_painting", "hallway_mask", "hallway_poster", "hallway_switch"], "foyer"],
		["master_bedroom", ["diary_lord", "bedroom_mirror", "jewelry_box", "master_bed", "bedroom_book", "bedroom_wardrobe", "bedroom_broken_bottle"], "upper_hallway"],
		["library", ["library_globe", "binding_book", "family_tree", "library_artifact", "library_shelves", "library_gears"], "upper_hallway"],
		["guest_room", ["guest_ledger", "helena_photo", "guest_luggage", "guest_bed", "guest_lamp"], "upper_hallway"],

		# ACT II-B: Basement
		["storage_basement", ["scratched_portrait", "basement_cage", "service_stack", "basement_mattress"], "kitchen"],
		["boiler_room", ["maintenance_log", "boiler_clock", "boiler_observation", "boiler_pipe_valves", "boiler_electrical_panel", "boiler_mask"], "storage_basement"],
		["wine_cellar", ["wine_note", "wine_box", "wine_racks", "wine_footprints"], "storage_basement"],

		# ACT II-C: Grounds
		["garden", ["garden_lily", "garden_fountain", "garden_gazebo", "garden_beds", "garden_bench"], "kitchen"],
		["chapel", ["baptismal_font", "chapel_altar", "chapel_pews", "chapel_stained_glass_interactable", "chapel_bones"], "garden"],
		["greenhouse", ["greenhouse_pot", "greenhouse_dead_plants", "greenhouse_glass", "greenhouse_bench"], "garden"],
		["carriage_house", ["carriage_portrait", "carriage_mattress", "carriage_tools"], "storage_basement"],
		["family_crypt", ["crypt_graves", "crypt_note", "crypt_flagstone", "crypt_bones"], "garden"],

		# ACT III: Attic
		["attic_stairs", ["stairwell_debris", "stairwell_wall"], "upper_hallway"],
		["attic_storage", ["elizabeth_portrait", "porcelain_doll", "elizabeth_letter", "attic_window", "elizabeth_trunk", "ritual_mask"], "attic_stairs"],
		["hidden_chamber", ["elizabeth_final_note", "chamber_drawings", "hidden_mirror", "ritual_circle", "chamber_artifact"], "attic_storage"],
	]
