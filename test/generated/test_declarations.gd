extends SceneTree
## Declaration validation suite. Loads main.tscn first to register all
## class_name types, then validates declarations.
## Run: godot --headless --script test/generated/test_declarations.gd

const RoomAnchorDeclScript = preload("res://engine/declarations/room_anchor_decl.gd")
const RegionCompilerScript = preload("res://engine/region_compiler.gd")

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
	for eid in ["grounds", "ground_floor", "upper_floor",
			"basement", "deep_basement", "attic"]:
		_ok("%s" % eid, ResourceLoader.exists(
			"res://declarations/environments/%s.tres" % eid))
	print("[DONE] 6 environments")


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
