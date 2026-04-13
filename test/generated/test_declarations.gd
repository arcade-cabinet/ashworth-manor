extends SceneTree
## Declaration validation suite. Loads main.tscn first to register all
## class_name types, then validates declarations.
## Run: godot --headless --script test/generated/test_declarations.gd

const RoomAnchorDeclScript = preload("res://engine/declarations/room_anchor_decl.gd")
const RegionCompilerScript = preload("res://engine/region_compiler.gd")
const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const EstateEnvironmentRegistry = preload("res://builders/estate_environment_registry.gd")
const EstateSubstrateRegistry = preload("res://builders/estate_substrate_registry.gd")
const PBRTextureKit = preload("res://builders/pbr_texture_kit.gd")
const SubstratePresetDecl = preload("res://engine/declarations/substrate_preset_decl.gd")
const TerrainPresetDecl = preload("res://engine/declarations/terrain_preset_decl.gd")
const SkyPresetDecl = preload("res://engine/declarations/sky_preset_decl.gd")
const SUPPORTED_MOUNT_ROUTE_MODES := [
	"adult",
	"elder",
	"child",
	"captive",
	"mourning",
	"sovereign",
	"canonical_progression",
	"post_canonical_replay",
]

var _pass_count: int = 0
var _fail_count: int = 0
var _warn_count: int = 0
var _test_name: String = ""


func _initialize() -> void:
	# Load main scene to register all class_name scripts
	var main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	call_deferred("_run_all_tests")


func _run_all_tests() -> void:
	print("=== Declaration Validation Suite ===\n")
	_test_rooms()
	_test_interactables()
	_test_connections()
	_test_secret_passages()
	_test_regions()
	_test_compiled_worlds()
	_test_puzzles()
	_test_items()
	_test_endings()
	_test_threads()
	_test_environments()
	_test_substrate_contract()
	_test_state_schema()
	_test_prng()

	print("\n========================================")
	print("DECLARATION TESTS: %d passed, %d failed, %d warnings" % [
		_pass_count, _fail_count, _warn_count])
	print("========================================")
	quit(1 if _fail_count > 0 else 0)


func _test_rooms() -> void:
	_test_name = "ROOMS"
	var ids := [
		"front_gate", "drive_lower", "drive_upper", "front_steps", "foyer", "parlor", "dining_room", "kitchen",
		"upper_hallway", "master_bedroom", "library", "guest_room",
		"storage_basement", "boiler_room", "wine_cellar",
		"attic_stairs", "attic_storage", "hidden_chamber",
		"garden", "chapel", "greenhouse", "carriage_house", "family_crypt"]
	for rid in ids:
		var p := "res://declarations/rooms/%s.tres" % rid
		_ok("room %s exists" % rid, ResourceLoader.exists(p))
		if ResourceLoader.exists(p):
			var r = load(p)
			_ok("%s has room_id" % rid, r != null and r.room_id != "")
	print("[DONE] %d rooms" % ids.size())


func _test_interactables() -> void:
	_test_name = "INTERACTABLES"
	var total := 0
	var dir := DirAccess.open("res://declarations/rooms/")
	if not dir: _ng("no rooms dir"); return
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if f.ends_with(".tres"):
			var r = load("res://declarations/rooms/" + f)
			if r and "interactables" in r:
				var seen: Dictionary = {}
				for i in r.interactables:
					_ok("id set in %s" % r.room_id, i.id != "")
					if i.id != "":
						_ok("unique '%s'" % i.id, i.id not in seen)
						seen[i.id] = true
					total += 1
		f = dir.get_next()
	print("[DONE] %d interactables" % total)


func _test_connections() -> void:
	_test_name = "CONNECTIONS"
	var w = load("res://declarations/world.tres")
	if not w: _ng("no world.tres"); return
	var room_decls: Dictionary = {}
	for room_ref in w.rooms:
		if room_ref != null and ResourceLoader.exists(room_ref.declaration_path):
			room_decls[room_ref.room_id] = load(room_ref.declaration_path)
	var pairs: Dictionary = {}
	for c in w.connections:
		pairs["%s->%s" % [c.from_room, c.to_room]] = c
		if c.to_anchor_id != "":
			_ok("%s target room known" % c.id, c.to_room in room_decls)
			if c.to_room in room_decls:
				_ok("%s target entry anchor exists" % c.id, _room_has_anchor(room_decls[c.to_room].entry_anchors, c.to_anchor_id))
		if c.focal_anchor_id != "":
			_ok("%s target room known for focal" % c.id, c.to_room in room_decls)
			if c.to_room in room_decls:
				_ok("%s target focal anchor exists" % c.id, _room_has_anchor(room_decls[c.to_room].focal_anchors, c.focal_anchor_id))
	var bad := 0
	for k in pairs:
		var c = pairs[k]
		if "%s->%s" % [c.to_room, c.from_room] not in pairs:
			_ng("no reverse for %s" % k); bad += 1
	_ok("all bidirectional", bad == 0)
	print("[DONE] %d pairs, %d missing" % [pairs.size(), bad])


func _test_secret_passages() -> void:
	_test_name = "SECRET_PASSAGES"
	var w = load("res://declarations/world.tres")
	if not w:
		_ng("no world.tres")
		return
	for passage in w.secret_passages:
		_ok("%s has id" % passage.from_room, passage.passage_id != "")
		_ok("%s anchor_from" % passage.passage_id, passage.anchor_from != null)
		_ok("%s anchor_to" % passage.passage_id, passage.anchor_to != null)
		if passage.anchor_from != null:
			_ok("%s from matches anchor" % passage.passage_id, passage.anchor_from.room_id == passage.from_room)
		if passage.anchor_to != null:
			_ok("%s to matches anchor" % passage.passage_id, passage.anchor_to.room_id == passage.to_room)
	print("[DONE] %d secret passages" % w.secret_passages.size())


func _test_regions() -> void:
	_test_name = "REGIONS"
	var w = load("res://declarations/world.tres")
	if not w:
		_ng("no world.tres")
		return
	_ok("has macro regions", not w.regions.is_empty())
	var room_ids: Dictionary = {}
	for room_ref in w.rooms:
		room_ids[room_ref.room_id] = true
	var assigned: Dictionary = {}
	for region in w.regions:
		_ok("%s has id" % region.region_type, region.region_id != "")
		_ok("%s has rooms" % region.region_id, not region.room_ids.is_empty())
		_ok("%s roundtrips by id" % region.region_id, w.get_region_by_id(region.region_id) == region)
		for room_id in region.room_ids:
			_ok("%s room exists" % room_id, room_id in room_ids)
			_ok("%s assigned once" % room_id, room_id not in assigned)
			_ok("%s resolves to region" % room_id, w.get_region_for_room(room_id) == region)
			assigned[room_id] = true
	_ok("all rooms region-assigned", assigned.size() == room_ids.size())
	print("[DONE] %d regions" % w.regions.size())


func _test_compiled_worlds() -> void:
	_test_name = "COMPILED_WORLDS"
	var w = load("res://declarations/world.tres")
	if not w:
		_ng("no world.tres")
		return
	var room_decls: Dictionary = {}
	for room_ref in w.rooms:
		if room_ref != null and ResourceLoader.exists(room_ref.declaration_path):
			room_decls[room_ref.room_id] = load(room_ref.declaration_path)
	var compile_plan: Dictionary = RegionCompilerScript.new(w, room_decls).compile_plan()
	var world_ids: PackedStringArray = w.get_compiled_world_ids()
	_ok("has compiled worlds", not world_ids.is_empty())
	for world_id in world_ids:
		var regions: Array = w.get_regions_for_compiled_world(world_id)
		var rooms: PackedStringArray = w.get_rooms_for_compiled_world(world_id)
		var entry_rooms: PackedStringArray = w.get_compiled_world_entry_rooms(world_id)
		var world_plan: Dictionary = compile_plan.get("compiled_worlds", {}).get(world_id, {})
		var room_offsets: Dictionary = world_plan.get("room_offsets", {})
		_ok("%s has regions" % world_id, not regions.is_empty())
		_ok("%s has rooms" % world_id, not rooms.is_empty())
		_ok("%s has entry room" % world_id, not entry_rooms.is_empty())
		_ok("%s has room offsets for all rooms" % world_id, room_offsets.size() == rooms.size())
		for region in regions:
			_ok("%s region roundtrips compiled world" % region.region_id, w.get_compiled_world_for_region(region.region_id) == world_id)
		for room_id in rooms:
			_ok("%s room roundtrips compiled world" % room_id, w.get_compiled_world_for_room(room_id) == world_id)
		for neighbor_world_id in w.get_compiled_world_neighbors(world_id):
			_ok("%s neighbor reverse link" % world_id, w.get_compiled_world_neighbors(neighbor_world_id).has(world_id))
	print("[DONE] %d compiled worlds" % world_ids.size())


func _test_puzzles() -> void:
	_test_name = "PUZZLES"
	var dir := DirAccess.open("res://declarations/puzzles/")
	if not dir: _wn("no puzzles dir"); return
	var n := 0
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if f.ends_with(".tres"):
			var r = load("res://declarations/puzzles/" + f)
			_ok("%s loads" % f, r != null)
			if r: _ok("%s has id" % f, r.puzzle_id != "")
			n += 1
		f = dir.get_next()
	print("[DONE] %d puzzles" % n)


func _test_items() -> void:
	_test_name = "ITEMS"
	var dir := DirAccess.open("res://declarations/items/")
	if not dir: _wn("no items dir"); return
	var n := 0
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if f.ends_with(".tres"):
			var r = load("res://declarations/items/" + f)
			_ok("%s loads" % f, r != null)
			if r: _ok("%s has item_id" % f, r.item_id != "")
			n += 1
		f = dir.get_next()
	print("[DONE] %d items" % n)


func _test_endings() -> void:
	_test_name = "ENDINGS"
	for eid in ["freedom", "forgiveness", "acceptance", "escape", "joined"]:
		_ok("%s exists" % eid, ResourceLoader.exists(
			"res://declarations/endings/%s.tres" % eid))
	print("[DONE] 5 endings")


func _test_threads() -> void:
	_test_name = "THREADS"
	for tid in ["captive", "mourning", "sovereign"]:
		_ok("%s exists" % tid, ResourceLoader.exists(
			"res://declarations/threads/%s.tres" % tid))
	print("[DONE] 3 threads")


func _test_environments() -> void:
	_test_name = "ENVS"
	for eid in [
		"grounds",
		"forecourt_lamplit",
		"ground_floor",
		"upper_floor",
		"attic",
		"basement",
		"deep_basement",
		"greenhouse_gaslit",
		"garden_mist",
		"crypt_candle",
	]:
		_ok("%s" % eid, ResourceLoader.exists(
			"res://declarations/environments/%s.tres" % eid))
	print("[DONE] 10 environments")


func _test_substrate_contract() -> void:
	_test_name = "SUBSTRATE"
	var substrate_ids := [
		"grounds_twilight",
		"forecourt_lamplit",
		"ground_floor_warmth",
		"upper_floor_moonlit",
		"attic_dust_lantern",
		"basement_bad_air",
		"deep_basement_service",
		"greenhouse_gaslit",
		"garden_mist",
		"crypt_candle",
	]
	for substrate_id in substrate_ids:
		var preset_path := EstateSubstrateRegistry.preset_path(substrate_id)
		_ok("%s preset exists" % substrate_id, ResourceLoader.exists(preset_path))
		if not ResourceLoader.exists(preset_path):
			continue
		var preset := load(preset_path) as SubstratePresetDecl
		_ok("%s loads" % substrate_id, preset != null)
		if preset == null:
			continue
		_ok("%s has region family" % substrate_id, not preset.region_family.is_empty())
		_ok("%s has light grammar" % substrate_id, not preset.default_light_grammar.is_empty())
		_ok("%s has dominant recipes" % substrate_id, not preset.dominant_material_recipes.is_empty())
		if not preset.terrain_preset_id.is_empty():
			_ok("%s terrain preset exists" % substrate_id, ResourceLoader.exists(EstateEnvironmentRegistry.terrain_preset_path(preset.terrain_preset_id)))
		if not preset.sky_preset_id.is_empty():
			_ok("%s sky preset exists" % substrate_id, ResourceLoader.exists(EstateEnvironmentRegistry.sky_preset_path(preset.sky_preset_id)))
		for family in preset.primitive_families:
			_ok("%s primitive family %s supported" % [substrate_id, family], EstateSubstrateRegistry.is_primitive_family_supported(family))
		for family in preset.allowed_mount_families:
			_ok("%s mount family %s supported" % [substrate_id, family], EstateSubstrateRegistry.is_mount_family_supported(family))
		for recipe_id in preset.dominant_material_recipes:
			_ok("%s dominant recipe %s exists" % [substrate_id, recipe_id], EstateMaterialKit.recipe_exists(recipe_id))

	for recipe_id in EstateMaterialKit.get_recipe_ids():
		var recipe_family := EstateMaterialKit.get_recipe_family(recipe_id)
		var recipe_kind := EstateMaterialKit.get_recipe_kind(recipe_id)
		_ok("%s recipe family supported" % recipe_id, ["surface", "terrain_path", "foliage", "glass", "liquid"].has(recipe_family))
		_ok("%s recipe kind supported" % recipe_id, EstateMaterialKit.is_supported_recipe_kind(recipe_kind))
		if recipe_kind == "foliage_shader":
			_ok("%s foliage shader stays in foliage family" % recipe_id, recipe_family == "foliage")
		if recipe_kind == "shader_material":
			var recipe_definition := EstateMaterialKit.get_recipe_definition(recipe_id)
			var shader_path := String(recipe_definition.get("shader_path", ""))
			_ok("%s shader path exists" % recipe_id, not shader_path.is_empty() and ResourceLoader.exists(shader_path))
		var recipe_slots := EstateMaterialKit.get_recipe_slots(recipe_id)
		for slot_name in recipe_slots.keys():
			_ok("%s slot %s supported" % [recipe_id, slot_name], PBRTextureKit.is_supported_slot(String(slot_name)))
			var slot_path := String(recipe_slots.get(slot_name, ""))
			_ok(
				"%s slot %s resource exists" % [recipe_id, slot_name],
				slot_path.is_empty() or FileAccess.file_exists(ProjectSettings.globalize_path(slot_path))
			)
		_ok("%s material builds" % recipe_id, EstateMaterialKit.build(recipe_id) != null)

	var terrain_ids := ["carriage_approach", "forecourt_steps", "garden_paths", "crypt_approach"]
	for terrain_id in terrain_ids:
		var terrain_path := EstateEnvironmentRegistry.terrain_preset_path(terrain_id)
		_ok("%s terrain preset exists" % terrain_id, ResourceLoader.exists(terrain_path))
		if not ResourceLoader.exists(terrain_path):
			continue
		var terrain_preset := load(terrain_path) as TerrainPresetDecl
		_ok("%s terrain preset loads" % terrain_id, terrain_preset != null)
		if terrain_preset == null:
			continue
		_ok("%s terrain base recipe exists" % terrain_id, terrain_preset.base_recipe_id.is_empty() or EstateMaterialKit.recipe_exists(terrain_preset.base_recipe_id))
		_ok("%s terrain track recipe exists" % terrain_id, terrain_preset.track_recipe_id.is_empty() or EstateMaterialKit.recipe_exists(terrain_preset.track_recipe_id))
		_ok("%s terrain shoulder recipe exists" % terrain_id, terrain_preset.shoulder_recipe_id.is_empty() or EstateMaterialKit.recipe_exists(terrain_preset.shoulder_recipe_id))

	var sky_ids := ["grounds_twilight_sky"]
	for sky_id in sky_ids:
		var sky_path := EstateEnvironmentRegistry.sky_preset_path(sky_id)
		_ok("%s sky preset exists" % sky_id, ResourceLoader.exists(sky_path))
		if not ResourceLoader.exists(sky_path):
			continue
		var sky_preset := load(sky_path) as SkyPresetDecl
		_ok("%s sky preset loads" % sky_id, sky_preset != null)
		if sky_preset == null:
			continue
		_ok("%s sky mode set" % sky_id, not sky_preset.sky_mode.is_empty())

	var world := load("res://declarations/world.tres") as WorldDeclaration
	_ok("world declaration loads for substrate contract", world != null)
	if world == null:
		return
	for room_ref in world.rooms:
		if room_ref == null or not ResourceLoader.exists(room_ref.declaration_path):
			continue
		var room_decl := load(room_ref.declaration_path) as RoomDeclaration
		_ok("%s room declaration loads" % room_ref.room_id, room_decl != null)
		if room_decl == null:
			continue
		_ok("%s has architecture source" % room_ref.room_id, not room_decl.primary_architecture_source.is_empty())
		var environment_preset_id := world.resolve_environment_preset_for_room(room_decl)
		_ok("%s environment preset resolves" % room_ref.room_id, not environment_preset_id.is_empty())
		var resolved_env := world.get_environment_declaration(environment_preset_id)
		_ok("%s environment declaration loads" % room_ref.room_id, resolved_env != null)
		if resolved_env != null:
			for key in resolved_env.surface_recipe_overrides.keys():
				var recipe_id := String(resolved_env.surface_recipe_overrides.get(key, ""))
				_ok("%s environment %s recipe exists" % [room_ref.room_id, key], recipe_id.is_empty() or EstateMaterialKit.recipe_exists(recipe_id))
			if not resolved_env.terrain_preset_id.is_empty():
				_ok("%s environment terrain preset exists" % room_ref.room_id, ResourceLoader.exists(EstateEnvironmentRegistry.terrain_preset_path(resolved_env.terrain_preset_id)))
			if not resolved_env.sky_preset_id.is_empty():
				_ok("%s environment sky preset exists" % room_ref.room_id, ResourceLoader.exists(EstateEnvironmentRegistry.sky_preset_path(resolved_env.sky_preset_id)))
		_ok("%s substrate preset resolves" % room_ref.room_id, not world.resolve_substrate_preset_for_room(room_decl).is_empty())
		var resolved_substrate_id := world.resolve_substrate_preset_for_room(room_decl)
		var resolved_substrate := EstateSubstrateRegistry.load_preset(resolved_substrate_id)
		_ok("%s substrate preset loads" % room_ref.room_id, resolved_substrate != null)
		var resolved_region := world.get_region_for_room(room_decl.room_id)
		_ok("%s region resolves" % room_ref.room_id, resolved_region != null)
		if resolved_substrate != null and room_decl.primary_architecture_source != "bespoke_waiver":
			for builder_name in _required_builders_for_room(world, room_decl):
				_ok("%s substrate approves %s" % [room_ref.room_id, builder_name], resolved_substrate.approved_builders.has(builder_name))
		if resolved_env != null and resolved_substrate != null:
			for family in resolved_env.allowed_mount_families:
				_ok(
					"%s env mount family %s approved by substrate" % [room_ref.room_id, family],
					resolved_substrate.allowed_mount_families.has(family)
				)
		if resolved_env != null and resolved_region != null:
			for family in resolved_env.allowed_mount_families:
				_ok(
					"%s env mount family %s approved by region" % [room_ref.room_id, family],
					resolved_region.allowed_mount_families.has(family)
				)
		var slot_map: Dictionary = {}
		for slot in room_decl.mount_slots:
			if slot == null:
				continue
			_ok("%s mount slot has id" % room_ref.room_id, not slot.slot_id.is_empty())
			_ok("%s mount slot family supported" % slot.slot_id, EstateSubstrateRegistry.is_mount_family_supported(slot.slot_family))
			if not slot.slot_id.is_empty():
				_ok("%s mount slot id unique" % slot.slot_id, not slot_map.has(slot.slot_id))
				slot_map[slot.slot_id] = slot
			if resolved_env != null:
				_ok(
					"%s mount slot family %s allowed by environment" % [slot.slot_id, slot.slot_family],
					resolved_env.allowed_mount_families.has(slot.slot_family)
				)
			if resolved_substrate != null:
				_ok(
					"%s mount slot family %s allowed by substrate" % [slot.slot_id, slot.slot_family],
					resolved_substrate.allowed_mount_families.has(slot.slot_family)
				)
			if resolved_region != null:
				_ok(
					"%s mount slot family %s allowed by region" % [slot.slot_id, slot.slot_family],
					resolved_region.allowed_mount_families.has(slot.slot_family)
				)
		for payload in room_decl.mount_payloads:
			if payload == null:
				continue
			_ok("%s mount payload has id" % room_ref.room_id, not payload.payload_id.is_empty())
			_ok("%s mount payload targets slot" % payload.payload_id, not payload.slot_id.is_empty())
			_ok("%s mount payload slot exists" % payload.payload_id, slot_map.has(payload.slot_id))
			_ok(
				"%s mount payload has scene source" % payload.payload_id,
				not payload.scene_path.is_empty() or not payload.model.is_empty()
			)
			for route_mode in payload.route_modes:
				_ok(
					"%s mount payload route mode %s supported" % [payload.payload_id, route_mode],
					SUPPORTED_MOUNT_ROUTE_MODES.has(String(route_mode))
				)
	print("[DONE] substrate contract")


func _test_state_schema() -> void:
	_test_name = "SCHEMA"
	var p := "res://declarations/state_schema.tres"
	_ok("exists", ResourceLoader.exists(p))
	if ResourceLoader.exists(p):
		var r = load(p)
		if r and "variables" in r:
			_ok("has vars", not r.variables.is_empty())
	print("[DONE] schema")


func _test_prng() -> void:
	_test_name = "PRNG"
	var w = load("res://declarations/world.tres")
	if not w: _ng("no world.tres"); return
	var puzzles: Array[PuzzleDeclaration] = []
	var dir := DirAccess.open("res://declarations/puzzles/")
	if dir:
		dir.list_dir_begin()
		var f := dir.get_next()
		while f != "":
			if f.ends_with(".tres"):
				var r = load("res://declarations/puzzles/" + f)
				if r: puzzles.append(r)
			f = dir.get_next()
	var valid := 0; var invalid := 0
	var PrngScript = load("res://engine/prng_engine.gd")
	var tc := {"captive": 0, "mourning": 0, "sovereign": 0}
	for s in range(1, 51):
		var prng = PrngScript.new()
		var tw = w.duplicate()
		tw.prng_seed = s
		var thread = prng.resolve(tw)
		if thread in tc: tc[thread] += 1
		if prng.validate_configuration(tw, puzzles):
			valid += 1
		else:
			invalid += 1
	_ok("50 seeds valid", invalid == 0)
	_ok("3 threads covered", tc["captive"] > 0
		and tc["mourning"] > 0 and tc["sovereign"] > 0)
	print("[DONE] PRNG %d/%d valid, c=%d m=%d s=%d" % [
		valid, valid + invalid, tc["captive"], tc["mourning"], tc["sovereign"]])


func _ok(d: String, c: bool) -> void:
	if c: _pass_count += 1
	else: _fail_count += 1; print("  [FAIL] %s: %s" % [_test_name, d])

func _ng(d: String) -> void:
	_fail_count += 1; print("  [FAIL] %s: %s" % [_test_name, d])

func _wn(d: String) -> void:
	_warn_count += 1; print("  [WARN] %s: %s" % [_test_name, d])


func _room_has_anchor(anchors: Array, anchor_id: String) -> bool:
	for anchor in anchors:
		if anchor != null and anchor.anchor_id == anchor_id:
			return true
	return false


func _required_builders_for_room(world: WorldDeclaration, room_decl: RoomDeclaration) -> PackedStringArray:
	var required := PackedStringArray()
	_append_unique(required, "floor_builder")
	if not room_decl.is_exterior:
		_append_unique(required, "ceiling_builder")
		_append_unique(required, "wall_builder")
	if _room_has_window_segment(room_decl):
		_append_unique(required, "window_builder")
	for conn in world.get_connections_from_room(room_decl.room_id):
		match conn.type:
			"door", "double_door", "heavy_door", "hidden_door", "gate":
				_append_unique(required, "door_builder")
			"stairs":
				_append_unique(required, "stairs_builder")
			"trapdoor":
				_append_unique(required, "trapdoor_builder")
			"ladder":
				_append_unique(required, "ladder_builder")
	return required


func _room_has_window_segment(room_decl: RoomDeclaration) -> bool:
	for layout in [room_decl.wall_north, room_decl.wall_south, room_decl.wall_east, room_decl.wall_west]:
		for segment in layout:
			if String(segment).begins_with("window"):
				return true
	return false


func _append_unique(values: PackedStringArray, value: String) -> void:
	if not values.has(value):
		values.append(value)
