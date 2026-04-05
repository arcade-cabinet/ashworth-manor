extends RefCounted
## res://scripts/room_data.gd — Static data for all 19 rooms

# Room definition format:
# {
#   "id": String, "name": String, "floor": int,
#   "dimensions": Vector3(w, h, d), "position": Vector3,
#   "ambient_darkness": float, "audio_loop": String,
#   "models": [{"path": String, "pos": Vector3, "rot": Vector3, "scale": Vector3}],
#   "lights": [{"type": String, "pos": Vector3, "color": Color, "intensity": float, "flickering": bool}],
#   "interactables": [{"id": String, "type": String, "pos": Vector3, "data": Dictionary}],
#   "connections": [{"direction": String, "target_room": String, "type": String, "pos": Vector3, "locked": bool, "key_id": String}]
# }

static func get_all_rooms() -> Dictionary:
	return {
		"front_gate": _front_gate(),
		"foyer": _foyer(),
		"parlor": _parlor(),
		"dining_room": _dining_room(),
		"kitchen": _kitchen(),
		"storage_basement": _storage_basement(),
		"boiler_room": _boiler_room(),
		"wine_cellar": _wine_cellar(),
		"upper_hallway": _upper_hallway(),
		"master_bedroom": _master_bedroom(),
		"library": _library(),
		"guest_room": _guest_room(),
		"attic_stairs": _attic_stairs(),
		"attic_storage": _attic_storage(),
		"hidden_room": _hidden_room(),
		"chapel": _chapel(),
		"greenhouse": _greenhouse(),
		"carriage_house": _carriage_house(),
		"family_crypt": _family_crypt(),
	}

static func get_room(room_id: String) -> Dictionary:
	var rooms := get_all_rooms()
	return rooms.get(room_id, {})

# === GROUND FLOOR ===

static func _front_gate() -> Dictionary:
	return {
		"id": "front_gate", "name": "Front Gate", "floor": 0,
		"dimensions": Vector3(20, 6, 30), "position": Vector3(0, 0, -40),
		"ambient_darkness": 0.3, "audio_loop": "Tempest Loop1",
		"is_exterior": true,
		"models": [
			{"path": "res://assets/models/mansion/pillar0.glb", "pos": Vector3(-4, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/pillar0_001.glb", "pos": Vector3(4, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-4, 3, 0), "color": Color(1.0, 0.85, 0.5), "intensity": 0.4, "flickering": true, "range": 8.0},
			{"type": "directional", "pos": Vector3(0, 10, 0), "color": Color(0.65, 0.7, 0.85), "intensity": 0.3, "flickering": false, "range": 100.0},
		],
		"interactables": [
			{"id": "gate_plaque", "type": "note", "pos": Vector3(-2, 1.5, -12),
			 "data": {"title": "Gate Plaque", "content": "ASHWORTH MANOR — Est. 1847"}},
			{"id": "gate_footprints", "type": "observation", "pos": Vector3(0, 0.1, -8),
			 "data": {"content": "Footprints in the fresh snow. One set, leading in. None leading out."}},
		],
		"connections": [
			{"direction": "north", "target_room": "foyer", "type": "door", "pos": Vector3(0, 0, 12), "locked": false, "key_id": ""},
		],
	}

static func _foyer() -> Dictionary:
	return {
		"id": "foyer", "name": "Grand Foyer", "floor": 0,
		"dimensions": Vector3(12, 6, 14), "position": Vector3(0, 0, 0),
		"ambient_darkness": 0.4, "audio_loop": "Moonlight Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor0.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chandelier.glb", "pos": Vector3(0, 5.5, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/stairs0.glb", "pos": Vector3(4, 0, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/stairbanister.glb", "pos": Vector3(4, 0, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank.glb", "pos": Vector3(0, 3, -6.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/rug0.glb", "pos": Vector3(0, 0.01, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(-5.5, 3, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(5.5, 3, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/window.glb", "pos": Vector3(0, 4, -6.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(0, 5.5, 0), "color": Color(1.0, 0.85, 0.6), "intensity": 0.8, "flickering": false, "range": 12.0},
			{"type": "omni", "pos": Vector3(-5.5, 3, -3), "color": Color(1.0, 0.7, 0.4), "intensity": 0.5, "flickering": true, "range": 6.0},
			{"type": "omni", "pos": Vector3(5.5, 3, -3), "color": Color(1.0, 0.7, 0.4), "intensity": 0.5, "flickering": true, "range": 6.0},
			{"type": "spot", "pos": Vector3(0, 4, -6.5), "color": Color(0.6, 0.7, 0.9), "intensity": 0.3, "flickering": false, "range": 10.0},
		],
		"interactables": [
			{"id": "foyer_painting", "type": "painting", "pos": Vector3(0, 3, -6.5),
			 "data": {"title": "Lord Ashworth", "content": "The patriarch stares down with hollow eyes. His hand rests on a book titled 'Rites of Passage'."}},
			{"id": "grandfather_clock", "type": "clock", "pos": Vector3(5, 1.5, -4),
			 "data": {"content": "The hands point to 3:33. The pendulum hangs motionless. No ticking breaks the silence."}},
			{"id": "foyer_mirror", "type": "mirror", "pos": Vector3(-5.5, 2.5, 3),
			 "data": {"content": "Your reflection stares back. For a moment, you could swear it moved independently."}},
			{"id": "entry_switch", "type": "switch", "pos": Vector3(-5.5, 1.3, -5),
			 "data": {"controls_light": "foyer_chandelier"}},
		],
		"connections": [
			{"direction": "north", "target_room": "parlor", "type": "door", "pos": Vector3(0, 0, 7), "locked": false, "key_id": ""},
			{"direction": "east", "target_room": "dining_room", "type": "door", "pos": Vector3(6, 0, 0), "locked": false, "key_id": ""},
			{"direction": "west", "target_room": "kitchen", "type": "door", "pos": Vector3(-6, 0, 0), "locked": false, "key_id": ""},
			{"direction": "up", "target_room": "upper_hallway", "type": "stairs", "pos": Vector3(4, 0, -5), "locked": false, "key_id": ""},
			{"direction": "south", "target_room": "front_gate", "type": "door", "pos": Vector3(0, 0, -7), "locked": false, "key_id": ""},
		],
	}

static func _parlor() -> Dictionary:
	return {
		"id": "parlor", "name": "Parlor", "floor": 0,
		"dimensions": Vector3(10, 4, 10), "position": Vector3(0, 0, 16),
		"ambient_darkness": 0.5, "audio_loop": "Comfort Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor1.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/fireplace.glb", "pos": Vector3(0, 0, 4.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/double_sofa.glb", "pos": Vector3(-2, 0, 1), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/sofa.glb", "pos": Vector3(2, 0, 1), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/table.glb", "pos": Vector3(0, 0, 1), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank_001.glb", "pos": Vector3(-4.5, 2, 0), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/rug1.glb", "pos": Vector3(0, 0.01, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle0.glb", "pos": Vector3(-3, 1.0, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle1.glb", "pos": Vector3(3, 1.0, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/page0.glb", "pos": Vector3(2, 0.8, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(0, 1, 4.5), "color": Color(1.0, 0.5, 0.2), "intensity": 0.6, "flickering": true, "range": 8.0},
			{"type": "omni", "pos": Vector3(-3, 1.2, -2), "color": Color(1.0, 0.8, 0.4), "intensity": 0.3, "flickering": true, "range": 4.0},
			{"type": "omni", "pos": Vector3(3, 1.2, -2), "color": Color(1.0, 0.8, 0.4), "intensity": 0.3, "flickering": true, "range": 4.0},
		],
		"interactables": [
			{"id": "parlor_painting_1", "type": "painting", "pos": Vector3(-4.5, 2, 0),
			 "data": {"title": "Lady Ashworth", "content": "She wears a black mourning dress despite this being painted before any family deaths. Prescient or cursed?"}},
			{"id": "parlor_note", "type": "note", "pos": Vector3(2, 0.8, 2),
			 "data": {"title": "Torn Diary Page", "content": "The children have been hearing whispers from the attic again. I've locked the door but they say she still calls to them at night..."}},
			{"id": "music_box", "type": "box", "pos": Vector3(3, 1, -2),
			 "data": {"locked": false, "content": "A delicate music box with a dancing ballerina. It doesn't play when opened — the mechanism is jammed."}},
		],
		"connections": [
			{"direction": "south", "target_room": "foyer", "type": "door", "pos": Vector3(0, 0, -5), "locked": false, "key_id": ""},
		],
	}

static func _dining_room() -> Dictionary:
	return {
		"id": "dining_room", "name": "Dining Room", "floor": 0,
		"dimensions": Vector3(8, 4, 12), "position": Vector3(14, 0, 0),
		"ambient_darkness": 0.55, "audio_loop": "Keep it up Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor1.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chandelier.glb", "pos": Vector3(0, 3.8, 0), "rot": Vector3.ZERO, "scale": Vector3(0.7, 0.7, 0.7)},
			{"path": "res://assets/models/mansion/table.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3(1.5, 1, 2)},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(-2, 0, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(2, 0, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(-2, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(2, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(-2, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(2, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank_002.glb", "pos": Vector3(3.5, 2, -5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle2.glb", "pos": Vector3(-1, 1.0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle2.glb", "pos": Vector3(1, 1.0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(0, 3.8, 0), "color": Color(1.0, 0.85, 0.6), "intensity": 0.7, "flickering": false, "range": 10.0},
			{"type": "omni", "pos": Vector3(-1, 1.2, 0), "color": Color(1.0, 0.8, 0.4), "intensity": 0.25, "flickering": true, "range": 3.0},
			{"type": "omni", "pos": Vector3(1, 1.2, 0), "color": Color(1.0, 0.8, 0.4), "intensity": 0.25, "flickering": true, "range": 3.0},
		],
		"interactables": [
			{"id": "dinner_photo", "type": "photo", "pos": Vector3(3.5, 2, -5),
			 "data": {"title": "Dinner Party Photograph", "content": "The final dinner party. Three of these guests would be dead within the week."}},
		],
		"connections": [
			{"direction": "west", "target_room": "foyer", "type": "door", "pos": Vector3(-4, 0, 0), "locked": false, "key_id": ""},
		],
	}

static func _kitchen() -> Dictionary:
	return {
		"id": "kitchen", "name": "Kitchen", "floor": 0,
		"dimensions": Vector3(8, 3.5, 10), "position": Vector3(-14, 0, 0),
		"ambient_darkness": 0.6, "audio_loop": "Without a Trace Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor2.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/fireplace.glb", "pos": Vector3(-3, 0, 4), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/table.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/drawers.glb", "pos": Vector3(3, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/page1.glb", "pos": Vector3(0, 0.85, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-3, 1, 4), "color": Color(1.0, 0.6, 0.3), "intensity": 0.5, "flickering": true, "range": 7.0},
		],
		"interactables": [
			{"id": "cook_note", "type": "note", "pos": Vector3(0, 0.85, 0),
			 "data": {"title": "Cook's Note", "content": "The master has forbidden anyone from the attic. Says the rats have grown too bold. But I've heard no rats that whisper names..."}},
		],
		"connections": [
			{"direction": "east", "target_room": "foyer", "type": "door", "pos": Vector3(4, 0, 0), "locked": false, "key_id": ""},
			{"direction": "down", "target_room": "storage_basement", "type": "stairs", "pos": Vector3(-2, 0, -3), "locked": false, "key_id": ""},
		],
	}

# === BASEMENT ===

static func _storage_basement() -> Dictionary:
	return {
		"id": "storage_basement", "name": "Storage Basement", "floor": -1,
		"dimensions": Vector3(8, 3, 8), "position": Vector3(0, -3, 0),
		"ambient_darkness": 0.75, "audio_loop": "Echoes at Dusk Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor3.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle0.glb", "pos": Vector3(-2, 0.8, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/rubbish.glb", "pos": Vector3(2, 0, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank_003.glb", "pos": Vector3(-3, 1.5, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/props/crates_barrels.glb", "pos": Vector3(3, 0, -2), "rot": Vector3.ZERO, "scale": Vector3(0.5, 0.5, 0.5)},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-2, 1.2, 2), "color": Color(1.0, 0.8, 0.4), "intensity": 0.4, "flickering": true, "range": 5.0},
		],
		"interactables": [
			{"id": "scratched_portrait", "type": "photo", "pos": Vector3(-3, 1.5, 0),
			 "data": {"title": "Family Portrait", "content": "A stern-looking family stands before the mansion. The youngest child's face has been scratched out."}},
		],
		"connections": [
			{"direction": "up", "target_room": "kitchen", "type": "stairs", "pos": Vector3(0, 0, -3), "locked": false, "key_id": ""},
			{"direction": "east", "target_room": "boiler_room", "type": "door", "pos": Vector3(4, 0, 0), "locked": false, "key_id": ""},
			{"direction": "down", "target_room": "wine_cellar", "type": "ladder", "pos": Vector3(3, 0, 3), "locked": false, "key_id": ""},
		],
	}

static func _boiler_room() -> Dictionary:
	return {
		"id": "boiler_room", "name": "Boiler Room", "floor": -1,
		"dimensions": Vector3(6, 4, 8), "position": Vector3(10, -3, 0),
		"ambient_darkness": 0.7, "audio_loop": "Insufficient Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor4.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/fireplace.glb", "pos": Vector3(0, 0, 3), "rot": Vector3.ZERO, "scale": Vector3(1.5, 1.5, 1.5)},
			{"path": "res://assets/models/mansion/study_desk.glb", "pos": Vector3(-2, 0, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/page2.glb", "pos": Vector3(-2, 0.85, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(0, 1.5, 3), "color": Color(1.0, 0.4, 0.15), "intensity": 0.7, "flickering": true, "range": 8.0},
		],
		"interactables": [
			{"id": "maintenance_log", "type": "note", "pos": Vector3(-2, 0.85, -2),
			 "data": {"title": "Maintenance Log", "content": "Dec 15, 1891 - Strange sounds from the pipes again. The staff refuse to come down here after dark. Something is wrong with this house."}},
		],
		"connections": [
			{"direction": "west", "target_room": "storage_basement", "type": "door", "pos": Vector3(-3, 0, 0), "locked": false, "key_id": ""},
		],
	}

# === DEEP BASEMENT ===

static func _wine_cellar() -> Dictionary:
	return {
		"id": "wine_cellar", "name": "Wine Cellar", "floor": -2,
		"dimensions": Vector3(8, 3, 10), "position": Vector3(0, -6, 0),
		"ambient_darkness": 0.85, "audio_loop": "Empty Hope Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor3.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bookcase.glb", "pos": Vector3(-3.5, 0, 0), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bookcase.glb", "pos": Vector3(3.5, 0, 0), "rot": Vector3(0, -90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(-3.5, 2.2, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(3.5, 2.2, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/props/bottles.glb", "pos": Vector3(-3, 1, -3), "rot": Vector3.ZERO, "scale": Vector3(0.4, 0.4, 0.4)},
			{"path": "res://assets/models/props/crates_barrels.glb", "pos": Vector3(2, 0, 3), "rot": Vector3.ZERO, "scale": Vector3(0.5, 0.5, 0.5)},
			{"path": "res://assets/models/mansion/page3.glb", "pos": Vector3(-3, 1.5, -4), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/props/treasure.glb", "pos": Vector3(2, 0.5, -3), "rot": Vector3.ZERO, "scale": Vector3(0.5, 0.5, 0.5)},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-3.5, 2.5, 0), "color": Color(1.0, 0.6, 0.2), "intensity": 0.6, "flickering": true, "range": 6.0},
			{"type": "omni", "pos": Vector3(3.5, 2.5, 0), "color": Color(1.0, 0.6, 0.2), "intensity": 0.6, "flickering": true, "range": 6.0},
		],
		"interactables": [
			{"id": "wine_note", "type": "note", "pos": Vector3(-3, 1.5, -4),
			 "data": {"title": "Inventory List - 1887", "content": "The 1872 Bordeaux has been moved to the hidden alcove. Master insists no one shall find it. The key is with the portrait."}},
			{"id": "wine_box", "type": "box", "pos": Vector3(2, 0.5, -3),
			 "data": {"locked": true, "key_id": "cellar_key", "item_found": "mothers_confession",
					  "content": "Inside you find a letter in Lady Ashworth's hand...",
					  "item_title": "Lady Ashworth's Confession",
					  "item_content": "I am complicit in what was done to our daughter. When Elizabeth first spoke of seeing the dead, I told myself she was ill. When Edmund brought the occultist, I told myself it was medicine. When they locked her in the attic with that horrible doll, I told myself it was for her safety. I lied. To everyone. To myself. Elizabeth was never dangerous. She was gifted. And we destroyed her for it. — Victoria Ashworth, December 23rd, 1891"}},
		],
		"connections": [
			{"direction": "up", "target_room": "storage_basement", "type": "ladder", "pos": Vector3(0, 0, 4), "locked": false, "key_id": ""},
		],
	}

# === UPPER FLOOR ===

static func _upper_hallway() -> Dictionary:
	return {
		"id": "upper_hallway", "name": "Upper Hallway", "floor": 1,
		"dimensions": Vector3(4, 3.5, 16), "position": Vector3(4, 4, 0),
		"ambient_darkness": 0.5, "audio_loop": "Subtle Changes Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor1.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(-1.5, 2.5, -4), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(-1.5, 2.5, 4), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank_004.glb", "pos": Vector3(1.5, 2, 0), "rot": Vector3(0, -90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/rug2.glb", "pos": Vector3(0, 0.01, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/window.glb", "pos": Vector3(0, 2.5, 7.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-1.5, 2.8, -4), "color": Color(1.0, 0.7, 0.4), "intensity": 0.4, "flickering": true, "range": 5.0},
			{"type": "omni", "pos": Vector3(-1.5, 2.8, 4), "color": Color(1.0, 0.7, 0.4), "intensity": 0.4, "flickering": true, "range": 5.0},
			{"type": "spot", "pos": Vector3(0, 2.5, 7.5), "color": Color(0.7, 0.75, 0.85), "intensity": 0.25, "flickering": false, "range": 8.0},
		],
		"interactables": [
			{"id": "children_painting", "type": "painting", "pos": Vector3(1.5, 2, 0),
			 "data": {"title": "The Children", "content": "Three children in white. The youngest holds a doll that looks remarkably like the figure seen in the attic window."}},
			{"id": "attic_door", "type": "locked_door", "pos": Vector3(0, 0, -7),
			 "data": {"locked": true, "key_id": "attic_key", "target_room": "attic_stairs", "message_locked": "The door is locked. You need a key."}},
		],
		"connections": [
			{"direction": "down", "target_room": "foyer", "type": "stairs", "pos": Vector3(0, 0, 6), "locked": false, "key_id": ""},
			{"direction": "west_south", "target_room": "master_bedroom", "type": "door", "pos": Vector3(-2, 0, -3), "locked": false, "key_id": ""},
			{"direction": "west_north", "target_room": "library", "type": "door", "pos": Vector3(-2, 0, 3), "locked": false, "key_id": ""},
			{"direction": "east", "target_room": "guest_room", "type": "door", "pos": Vector3(2, 0, 0), "locked": false, "key_id": ""},
			{"direction": "north", "target_room": "attic_stairs", "type": "door", "pos": Vector3(0, 0, -7), "locked": true, "key_id": "attic_key"},
		],
	}

static func _master_bedroom() -> Dictionary:
	return {
		"id": "master_bedroom", "name": "Master Bedroom", "floor": 1,
		"dimensions": Vector3(10, 4, 10), "position": Vector3(-8, 4, -3),
		"ambient_darkness": 0.55, "audio_loop": "Lying Down Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor1.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/master_bed.glb", "pos": Vector3(0, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/drawers.glb", "pos": Vector3(-3, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/wardrobe.glb", "pos": Vector3(4, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle0.glb", "pos": Vector3(-3, 0.85, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle1.glb", "pos": Vector3(3, 0.85, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/rug0.glb", "pos": Vector3(0, 0.01, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/window.glb", "pos": Vector3(-4.5, 2, 0), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/page4.glb", "pos": Vector3(-3, 0.9, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-3, 1.2, 3), "color": Color(1.0, 0.85, 0.55), "intensity": 0.35, "flickering": true, "range": 4.0},
			{"type": "omni", "pos": Vector3(3, 1.2, 3), "color": Color(1.0, 0.85, 0.55), "intensity": 0.35, "flickering": true, "range": 4.0},
			{"type": "spot", "pos": Vector3(-4.5, 2, 0), "color": Color(0.7, 0.75, 0.85), "intensity": 0.3, "flickering": false, "range": 8.0},
		],
		"interactables": [
			{"id": "diary_lord", "type": "note", "pos": Vector3(-3, 0.9, 3),
			 "data": {"title": "Lord Ashworth's Diary", "content": "She won't stop crying. Even after we locked her away, I hear her sobbing through the walls. My wife says I'm mad, but I know what I hear. The attic key is hidden in the library globe. No one must find her.",
					  "on_read_flags": ["read_ashworth_diary", "knows_key_location"]}},
			{"id": "bedroom_mirror", "type": "mirror", "pos": Vector3(4.5, 2, 3),
			 "data": {"content": "Your reflection appears a heartbeat too late. As if it had to catch up."}},
			{"id": "jewelry_box", "type": "box", "pos": Vector3(-4, 1, 4),
			 "data": {"locked": true, "key_id": "jewelry_key", "item_found": "elizabeths_locket",
					  "content": "Inside the jewelry box: a tarnished silver locket. You open it. A miniature portrait of an infant with pale eyes. Inscription: 'Our Elizabeth, born in light.' Behind the portrait, wrapped in tissue, a tiny lock of golden hair tied with white ribbon.",
					  "gives_also": "lock_of_hair"}},
		],
		"connections": [
			{"direction": "east", "target_room": "upper_hallway", "type": "door", "pos": Vector3(5, 0, 0), "locked": false, "key_id": ""},
		],
	}

static func _library() -> Dictionary:
	return {
		"id": "library", "name": "Library", "floor": 1,
		"dimensions": Vector3(8, 4, 10), "position": Vector3(-8, 4, 10),
		"ambient_darkness": 0.5, "audio_loop": "Value Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor1.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bookcase.glb", "pos": Vector3(-3.5, 0, 0), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bookcase.glb", "pos": Vector3(-3.5, 0, 3), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bookcase.glb", "pos": Vector3(3.5, 0, 0), "rot": Vector3(0, -90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bookcase.glb", "pos": Vector3(3.5, 0, 3), "rot": Vector3(0, -90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/study_desk.glb", "pos": Vector3(0, 0, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(0, 0, -4), "rot": Vector3(0, 180, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(-3.5, 2.5, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(3.5, 2.5, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle2.glb", "pos": Vector3(0, 0.85, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/openbook0.glb", "pos": Vector3(-2, 1.2, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/page5.glb", "pos": Vector3(3, 2, 4.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-3.5, 2.8, -3), "color": Color(1.0, 0.7, 0.4), "intensity": 0.45, "flickering": true, "range": 5.0},
			{"type": "omni", "pos": Vector3(3.5, 2.8, -3), "color": Color(1.0, 0.7, 0.4), "intensity": 0.45, "flickering": true, "range": 5.0},
			{"type": "omni", "pos": Vector3(0, 1.2, -3), "color": Color(1.0, 0.85, 0.55), "intensity": 0.3, "flickering": true, "range": 3.0},
		],
		"interactables": [
			{"id": "library_globe", "type": "box", "pos": Vector3(3, 1, -4),
			 "data": {"locked": false, "item_found": "attic_key",
					  "content": "Inside the hollow globe, you find an old brass key labeled 'ATTIC'."}},
			{"id": "binding_book", "type": "note", "pos": Vector3(-2, 1.2, 2),
			 "data": {"title": "Rituals of Binding", "content": "To trap a spirit, one must first give it form. The doll shall be the vessel, the blood the seal, and the attic the prison eternal...",
					  "on_read_flags": ["knows_binding_ritual"], "pickable": true, "item_id": "binding_book"}},
			{"id": "family_tree", "type": "note", "pos": Vector3(3, 2, 4.5),
			 "data": {"title": "Family Tree", "content": "The tree shows four children, but the household records only mention three. The fourth name has been scratched out: 'E_iza_eth'."}},
		],
		"connections": [
			{"direction": "east", "target_room": "upper_hallway", "type": "door", "pos": Vector3(4, 0, 0), "locked": false, "key_id": ""},
		],
	}

static func _guest_room() -> Dictionary:
	return {
		"id": "guest_room", "name": "Guest Room", "floor": 1,
		"dimensions": Vector3(8, 3.5, 8), "position": Vector3(14, 4, 0),
		"ambient_darkness": 0.6, "audio_loop": "Lost in Polaroids Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor1.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/bed.glb", "pos": Vector3(0, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/drawers.glb", "pos": Vector3(-3, 0, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_unlit0.glb", "pos": Vector3(-3, 0.85, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/window.glb", "pos": Vector3(3.5, 2, 0), "rot": Vector3(0, -90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank_005.glb", "pos": Vector3(-3, 1.5, 0), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/papers.glb", "pos": Vector3(2, 0.85, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-3, 1.2, 3), "color": Color(1.0, 0.85, 0.55), "intensity": 0.3, "flickering": true, "range": 4.0},
			{"type": "spot", "pos": Vector3(3.5, 2, 0), "color": Color(0.7, 0.75, 0.85), "intensity": 0.25, "flickering": false, "range": 6.0},
		],
		"interactables": [
			{"id": "guest_photo", "type": "photo", "pos": Vector3(-3, 1.5, 0),
			 "data": {"title": "Unknown Guest", "content": "A woman in white stands at the attic window. On the back: 'She sees you too - 1889'"}},
			{"id": "guest_ledger", "type": "note", "pos": Vector3(2, 0.85, -2),
			 "data": {"title": "Guest Ledger", "content": "Mrs. Helena Pierce, arriving Nov 3rd 1891. DEPARTED: [The entry is blank]"}},
		],
		"connections": [
			{"direction": "west", "target_room": "upper_hallway", "type": "door", "pos": Vector3(-4, 0, 0), "locked": false, "key_id": ""},
		],
	}

# === ATTIC ===

static func _attic_stairs() -> Dictionary:
	return {
		"id": "attic_stairs", "name": "Attic Stairwell", "floor": 2,
		"dimensions": Vector3(4, 3, 6), "position": Vector3(4, 8, 10),
		"ambient_darkness": 0.75, "audio_loop": "Silent Voices Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/stairs2.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_unlit1.glb", "pos": Vector3(1, 1, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "spot", "pos": Vector3(0, 2.5, 2), "color": Color(0.5, 0.55, 0.7), "intensity": 0.15, "flickering": false, "range": 6.0},
		],
		"interactables": [],
		"connections": [
			{"direction": "down", "target_room": "upper_hallway", "type": "stairs", "pos": Vector3(0, 0, -2), "locked": false, "key_id": ""},
			{"direction": "north", "target_room": "attic_storage", "type": "door", "pos": Vector3(0, 0, 3), "locked": false, "key_id": ""},
		],
	}

static func _attic_storage() -> Dictionary:
	return {
		"id": "attic_storage", "name": "Attic Storage", "floor": 2,
		"dimensions": Vector3(14, 4, 12), "position": Vector3(0, 8, 22),
		"ambient_darkness": 0.8, "audio_loop": "Lonely Nightmare Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor2.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/window_clean.glb", "pos": Vector3(0, 3, 5.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle0.glb", "pos": Vector3(3, 0.8, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/props/crates_barrels.glb", "pos": Vector3(-4, 0, 3), "rot": Vector3.ZERO, "scale": Vector3(0.5, 0.5, 0.5)},
			{"path": "res://assets/models/mansion/rubbish.glb", "pos": Vector3(4, 0, -3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/picture_blank_006.glb", "pos": Vector3(-6, 2, 0), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/horror/doll1.glb", "pos": Vector3(3, 0.8, 2), "rot": Vector3.ZERO, "scale": Vector3(0.3, 0.3, 0.3)},
			{"path": "res://assets/models/mansion/page0.glb", "pos": Vector3(-3, 0.5, 3), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/door1.glb", "pos": Vector3(-6, 0, -4), "rot": Vector3(0, 90, 0), "scale": Vector3.ONE},
			{"path": "res://assets/models/props/bat.glb", "pos": Vector3(2, 3.5, -2), "rot": Vector3.ZERO, "scale": Vector3(0.3, 0.3, 0.3)},
		],
		"lights": [
			{"type": "spot", "pos": Vector3(0, 3, 5.5), "color": Color(0.5, 0.55, 0.7), "intensity": 0.2, "flickering": false, "range": 10.0},
			{"type": "omni", "pos": Vector3(3, 1.2, 2), "color": Color(1.0, 0.85, 0.55), "intensity": 0.25, "flickering": true, "range": 4.0},
		],
		"interactables": [
			{"id": "elizabeth_portrait", "type": "painting", "pos": Vector3(-6, 2, 0),
			 "data": {"title": "The Fourth Child", "content": "A young girl in a white dress clutches a porcelain doll. Her eyes have been painted over in black. A plaque reads: 'Elizabeth Ashworth, 1880-1889. Beloved daughter. Forgotten by none.'",
					  "on_read_flags": ["seen_elizabeth_portrait", "knows_elizabeth"]}},
			{"id": "porcelain_doll", "type": "doll", "pos": Vector3(3, 0.8, 2),
			 "data": {"first_content": "A porcelain doll with cracked features. Its eyes seem to follow you. Behind it, scratched into the wood: 'SHE NEVER LEFT'",
					  "second_content": "You turn the doll over. Inside the hollow body, wrapped in a child's handkerchief, is a tarnished key. The doll's cracked face seems to relax.",
					  "requires_flag": "read_elizabeth_letter", "item_found": "hidden_key",
					  "on_first_flags": ["examined_doll"], "on_second_flags": ["has_hidden_key"],
					  "pickable_after_key": true, "item_id": "porcelain_doll"}},
			{"id": "elizabeth_letter", "type": "note", "pos": Vector3(-3, 0.5, 3),
			 "data": {"title": "Unsent Letter", "content": "Dearest Mother,\n\nThey say I'm sick but I feel fine. Father won't let me leave my room anymore. The doll talks to me now. She says I'll be here forever.\n\nI'm scared.\n\n- Your Elizabeth",
					  "on_read_flags": ["read_elizabeth_letter"]}},
			{"id": "hidden_door", "type": "locked_door", "pos": Vector3(-6, 0, -4),
			 "data": {"locked": true, "key_id": "hidden_key", "target_room": "hidden_room", "message_locked": "A door hidden behind old furniture. The lock is shaped like an open hand."}},
		],
		"connections": [
			{"direction": "south", "target_room": "attic_stairs", "type": "door", "pos": Vector3(0, 0, -6), "locked": false, "key_id": ""},
			{"direction": "west", "target_room": "hidden_room", "type": "door", "pos": Vector3(-6, 0, -4), "locked": true, "key_id": "hidden_key"},
		],
	}

static func _hidden_room() -> Dictionary:
	return {
		"id": "hidden_room", "name": "Hidden Chamber", "floor": 2,
		"dimensions": Vector3(6, 3, 6), "position": Vector3(-12, 8, 22),
		"ambient_darkness": 0.9, "audio_loop": "I Can't Go On Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor2.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3(0.5, 1, 0.5)},
			{"path": "res://assets/models/mansion/candle_unlit2.glb", "pos": Vector3(-2, 0.5, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_unlit2.glb", "pos": Vector3(2, 0.5, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-2, 1, 2), "color": Color(1.0, 0.85, 0.55), "intensity": 0.2, "flickering": true, "range": 3.0},
			{"type": "omni", "pos": Vector3(2, 1, 2), "color": Color(1.0, 0.85, 0.55), "intensity": 0.2, "flickering": true, "range": 3.0},
		],
		"interactables": [
			{"id": "final_note", "type": "note", "pos": Vector3(0, 1, 2),
			 "data": {"title": "Elizabeth's Last Words", "content": "I understand now. The doll showed me.\n\nI was never sick — they were afraid of what I could see. The house has eyes. The walls have ears. And now I am part of it forever.\n\nFind me. Free me. Or join me.",
					  "on_read_flags": ["knows_full_truth", "read_final_note"]}},
			{"id": "hidden_mirror", "type": "mirror", "pos": Vector3(0, 1.5, -2.5),
			 "data": {"content": "In the mirror, behind you, stands a girl in white. When you turn, nothing is there."}},
			{"id": "ritual_circle", "type": "ritual", "pos": Vector3(0, 0.1, 0),
			 "data": {"description": "A circle drawn on the floor in the center of Elizabeth's drawings."}},
		],
		"connections": [
			{"direction": "east", "target_room": "attic_storage", "type": "door", "pos": Vector3(3, 0, 0), "locked": false, "key_id": ""},
		],
	}

# === GROUNDS (EXTERIOR) ===

static func _chapel() -> Dictionary:
	return {
		"id": "chapel", "name": "Estate Chapel", "floor": 0,
		"dimensions": Vector3(6, 5, 10), "position": Vector3(-20, 0, 10),
		"ambient_darkness": 0.6, "audio_loop": "Silent Voices Loop2",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor3.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(-1.5, 0, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(1.5, 0, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(-1.5, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/chair.glb", "pos": Vector3(1.5, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_unlit0.glb", "pos": Vector3(-1, 1, 4), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_unlit0.glb", "pos": Vector3(1, 1, 4), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/window.glb", "pos": Vector3(0, 3.5, 4.5), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/openbook1.glb", "pos": Vector3(-2, 0.8, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "spot", "pos": Vector3(0, 4, 4.5), "color": Color(0.5, 0.55, 0.75), "intensity": 0.25, "flickering": false, "range": 10.0},
		],
		"interactables": [
			{"id": "baptismal_font", "type": "box", "pos": Vector3(0, 0.8, 3),
			 "data": {"locked": false, "item_found": "blessed_water",
					  "content": "The stone font still holds water. Ice crystals have formed on the surface, but beneath, the water is clear and still. You collect some in a small vial."}},
			{"id": "chapel_cross", "type": "painting", "pos": Vector3(0, 3, 4.8),
			 "data": {"title": "The Cross", "content": "A wooden cross hangs above the altar. Looking closely, you realize it has been mounted upside down. The screws are old — this was done long ago."}},
			{"id": "chapel_prayer_book", "type": "note", "pos": Vector3(-2, 0.8, 2),
			 "data": {"title": "Open Prayer Book", "content": "The Book of Common Prayer lies open to a page about baptism. In the margin, in Lord Ashworth's hand: 'She was never baptized. Perhaps that is why she sees.'"}},
		],
		"connections": [
			{"direction": "south", "target_room": "front_gate", "type": "door", "pos": Vector3(0, 0, -5), "locked": false, "key_id": ""},
		],
	}

static func _greenhouse() -> Dictionary:
	return {
		"id": "greenhouse", "name": "Greenhouse", "floor": 0,
		"dimensions": Vector3(8, 4, 12), "position": Vector3(20, 0, 10),
		"ambient_darkness": 0.4, "audio_loop": "Subtle Changes Loop2",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/window_clean.glb", "pos": Vector3(0, 3, 0), "rot": Vector3.ZERO, "scale": Vector3(2, 1, 3)},
			{"path": "res://assets/models/mansion/openbook2.glb", "pos": Vector3(3, 1, 2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "directional", "pos": Vector3(0, 4, 0), "color": Color(0.7, 0.75, 0.85), "intensity": 0.35, "flickering": false, "range": 20.0},
		],
		"interactables": [
			{"id": "white_lily", "type": "painting", "pos": Vector3(0, 1, 4),
			 "data": {"title": "The White Lily", "content": "Among the dead and frozen plants, a single white lily blooms. Its petals are perfect. It should not be alive. The soil around it is warm to the touch."}},
			{"id": "greenhouse_gate_key", "type": "box", "pos": Vector3(1, 0.5, 4),
			 "data": {"locked": false, "item_found": "gate_key",
					  "content": "Inside the pot next to the living lily, buried in dry soil, you find an iron gate key. It is warm, like the soil around the lily."}},
			{"id": "gardening_journal", "type": "note", "pos": Vector3(3, 1, 2),
			 "data": {"title": "Lady Ashworth's Garden Journal", "content": "June 14th, 1887. Elizabeth asked to plant something today. I gave her a lily bulb for her room. She was so happy. I wonder if I will ever see her happy again. I wonder if I deserve to."}},
		],
		"connections": [
			{"direction": "south", "target_room": "front_gate", "type": "door", "pos": Vector3(0, 0, -6), "locked": false, "key_id": ""},
		],
	}

static func _carriage_house() -> Dictionary:
	return {
		"id": "carriage_house", "name": "Carriage House", "floor": 0,
		"dimensions": Vector3(10, 4, 8), "position": Vector3(-15, 0, -25),
		"ambient_darkness": 0.6, "audio_loop": "Echoes at Dusk Loop1",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor2.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/candle_holder.glb", "pos": Vector3(-3, 2.5, -2), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/props/crates_barrels.glb", "pos": Vector3(-3, 0, 2), "rot": Vector3.ZERO, "scale": Vector3(0.5, 0.5, 0.5)},
			{"path": "res://assets/models/mansion/picture_blank_007.glb", "pos": Vector3(4, 1.5, 3), "rot": Vector3(0, -90, 0), "scale": Vector3.ONE},
		],
		"lights": [
			{"type": "omni", "pos": Vector3(-3, 2.8, -2), "color": Color(1.0, 0.75, 0.4), "intensity": 0.35, "flickering": true, "range": 6.0},
		],
		"interactables": [
			{"id": "carriage_portrait", "type": "box", "pos": Vector3(4, 1.5, 3),
			 "data": {"locked": false, "item_found": "cellar_key",
					  "content": "Behind the portrait's backing, taped to the frame, you find a small iron key. This must be the key 'with the portrait' mentioned in the wine cellar inventory."}},
			{"id": "carriage_trunk", "type": "note", "pos": Vector3(-3, 0.5, 2),
			 "data": {"title": "Packed Trunk", "content": "A trunk packed with children's clothes. Tiny dresses, bonnets, shoes. A tag reads: 'Elizabeth's belongings — to be burned per Lord Ashworth's instruction.' The trunk was never burned."}},
		],
		"connections": [
			{"direction": "east", "target_room": "front_gate", "type": "door", "pos": Vector3(5, 0, 0), "locked": false, "key_id": ""},
		],
	}

static func _family_crypt() -> Dictionary:
	return {
		"id": "family_crypt", "name": "Family Crypt", "floor": 0,
		"dimensions": Vector3(6, 3.5, 8), "position": Vector3(0, 0, 30),
		"ambient_darkness": 0.8, "audio_loop": "Empty Hope Loop2",
		"is_exterior": false,
		"models": [
			{"path": "res://assets/models/mansion/floor3.glb", "pos": Vector3(0, 0, 0), "rot": Vector3.ZERO, "scale": Vector3.ONE},
			{"path": "res://assets/models/mansion/statue.glb", "pos": Vector3(0, 0, 3.5), "rot": Vector3.ZERO, "scale": Vector3(0.5, 0.5, 0.5)},
			{"path": "res://assets/models/mansion/picture_blank_008.glb", "pos": Vector3(-2.5, 1.8, 3.5), "rot": Vector3(0, 90, 0), "scale": Vector3(0.6, 0.6, 0.6)},
			{"path": "res://assets/models/mansion/picture_blank_009.glb", "pos": Vector3(2.5, 1.8, 3.5), "rot": Vector3(0, -90, 0), "scale": Vector3(0.6, 0.6, 0.6)},
		],
		"lights": [
			{"type": "spot", "pos": Vector3(0, 3, 2), "color": Color(0.5, 0.55, 0.7), "intensity": 0.2, "flickering": false, "range": 8.0},
		],
		"interactables": [
			{"id": "sarcophagus_lord", "type": "painting", "pos": Vector3(-2, 0.8, 1),
			 "data": {"title": "Lord Ashworth's Sarcophagus", "content": "The stone lid is pushed aside. Empty. 'Edmund Ashworth, 1820-1891' is carved into the rim. Where is the body?"}},
			{"id": "sarcophagus_lady", "type": "painting", "pos": Vector3(2, 0.8, 1),
			 "data": {"title": "Lady Ashworth's Sarcophagus", "content": "Also empty. 'Victoria Ashworth, 1825-1891'. Two people who simply ceased to exist."}},
			{"id": "missing_plaque", "type": "painting", "pos": Vector3(0, 1.8, 3.8),
			 "data": {"title": "The Blank Wall", "content": "Three memorial plaques line the wall: Charles, Margaret, William. But the wall has space for four. The fourth section is bare stone — no plaque was ever carved. Elizabeth was erased even from death."}},
			{"id": "loose_flagstone", "type": "box", "pos": Vector3(1, 0.1, -1),
			 "data": {"locked": false, "item_found": "jewelry_key",
					  "content": "Beneath the loose flagstone, wrapped in oilcloth, you find a tiny brass key with a heart-shaped bow. A note in Lady Ashworth's hand reads: 'I could not wear it any longer. Forgive me, Elizabeth.'"}},
		],
		"connections": [
			{"direction": "south", "target_room": "front_gate", "type": "door", "pos": Vector3(0, 0, -4), "locked": true, "key_id": "gate_key"},
		],
	}
