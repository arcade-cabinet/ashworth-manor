class_name WalkthroughData
## Play-order room visit list for test_room_walkthrough.gd
## Each entry: [room_id, [interactable_ids...]]

static func get_play_order() -> Array:
	return [
		# ACT I: Arrival
		["front_gate", ["gate_plaque", "iron_gate", "gate_luggage", "gate_bench", "gate_lamp"]],
		["foyer", ["foyer_painting", "foyer_mirror", "grandfather_clock", "entry_switch", "foyer_mail", "foyer_stairs"]],
		["parlor", ["parlor_painting_1", "parlor_note", "music_box", "parlor_fireplace", "parlor_tea"]],
		["dining_room", ["dinner_photo", "dining_pushed_chair", "dining_wine_glass", "dining_place_settings", "dining_candles", "dining_vessel"]],
		["kitchen", ["kitchen_note", "kitchen_cutting_board", "kitchen_hearth", "kitchen_knives", "kitchen_bucket"]],

		# ACT II: Upper Floor
		["upper_hallway", ["attic_door", "children_painting", "hallway_mask", "hallway_poster", "hallway_switch"]],
		["master_bedroom", ["diary_lord", "bedroom_mirror", "jewelry_box", "bedroom_bed", "bedroom_book", "bedroom_wardrobe", "bedroom_broken_bottle"]],
		["library", ["library_globe", "binding_book", "family_tree", "library_artifact", "library_shelves", "library_gears"]],
		["guest_room", ["guest_ledger", "helena_photo", "guest_luggage", "guest_bed", "guest_lamp"]],

		# ACT II-B: Basement
		["storage_basement", ["scratched_portrait", "storage_mirror", "storage_covered", "storage_trunk"]],
		["boiler_room", ["maintenance_log", "boiler_clock", "boiler_observation", "boiler_pipes", "boiler_mask"]],
		["wine_cellar", ["wine_note", "wine_box", "wine_racks", "wine_footprints"]],

		# ACT II-C: Grounds
		["garden", ["garden_lily", "garden_fountain", "garden_gazebo", "garden_beds"]],
		["chapel", ["baptismal_font", "chapel_altar", "chapel_pews", "chapel_glass", "chapel_bones"]],
		["greenhouse", ["greenhouse_pot", "greenhouse_dead", "greenhouse_glass"]],
		["carriage_house", ["carriage_portrait", "carriage_mattress", "carriage_boards"]],
		["family_crypt", ["crypt_graves", "crypt_note", "crypt_flagstone", "crypt_bones"]],

		# ACT III: Attic
		["attic_stairs", ["stairwell_debris", "stairwell_wall"]],
		["attic_storage", ["elizabeth_portrait", "porcelain_doll", "elizabeth_letter", "hidden_door", "attic_window", "elizabeth_trunk"]],
		["hidden_room", ["elizabeth_final_note", "chamber_drawings", "hidden_mirror", "ritual_circle", "chamber_artifact"]],
	]
