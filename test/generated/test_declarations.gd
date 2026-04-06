extends SceneTree
## Declaration validation suite. Loads main.tscn first to register all
## class_name types, then validates declarations.
## Run: godot --headless --script test/generated/test_declarations.gd

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
		"front_gate", "foyer", "parlor", "dining_room", "kitchen",
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
	var pairs: Dictionary = {}
	for c in w.connections:
		pairs["%s->%s" % [c.from_room, c.to_room]] = c
	var bad := 0
	for k in pairs:
		var c = pairs[k]
		if "%s->%s" % [c.to_room, c.from_room] not in pairs:
			_ng("no reverse for %s" % k); bad += 1
	_ok("all bidirectional", bad == 0)
	print("[DONE] %d pairs, %d missing" % [pairs.size(), bad])


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
	var puzzles: Array = []
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
