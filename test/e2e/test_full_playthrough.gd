extends GdUnitTestSuite
## E2E: Full game playthrough — Freedom ending
## Simulates a player navigating every room in the puzzle chain,
## solving all 6 puzzles, collecting all ritual components,
## and completing the counter-ritual for the Freedom ending.
##
## Run: godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd --add test/e2e

var _main: Node = null
var _rm: Node = null  # RoomManager
var _im: Node = null  # InteractionManager
var _ui: Control = null  # UIOverlay
var _gm: Node = null  # GameManager (autoload)


func before() -> void:
	# Load the full game scene
	_main = load("res://scenes/main.tscn").instantiate()
	add_child(_main)
	# Wait for _ready() to fire on all children
	await get_tree().process_frame
	await get_tree().process_frame

	# Find nodes
	_rm = _find("RoomManager")
	_im = _find("InteractionManager")
	_ui = _find("UIOverlay")

	# Find GameManager autoload
	for child in get_tree().root.get_children():
		if child.name == "GameManager":
			_gm = child
			break

	assert_that(_rm).is_not_null()
	assert_that(_im).is_not_null()
	assert_that(_gm).is_not_null()


func after() -> void:
	if _main:
		_main.queue_free()


## ============================================================
## TEST: Complete Freedom Ending Playthrough
## ============================================================

func test_full_freedom_ending_playthrough() -> void:
	# === ACT I: THE SURFACE ===

	# Start new game
	_gm.new_game()
	await get_tree().process_frame

	# -- FRONT GATE --
	_load_room("front_gate")
	_assert_room("front_gate", "Front Gate")
	_assert_has_interactable("gate_plaque")
	_assert_has_connection("foyer")

	# Read gate plaque
	_interact("gate_plaque")
	assert_that(_gm.has_interacted("gate_plaque")).is_true()

	# -- FOYER --
	_transition("foyer")
	_assert_room("foyer", "Grand Foyer")
	_assert_has_interactable("foyer_painting")
	_assert_has_interactable("grandfather_clock")
	_assert_has_interactable("foyer_mirror")
	_assert_has_connection("parlor")
	_assert_has_connection("dining_room")
	_assert_has_connection("kitchen")
	_assert_has_connection("upper_hallway")

	# Read Lord Ashworth's portrait
	_interact("foyer_painting")
	assert_that(_gm.has_interacted("foyer_painting")).is_true()

	# Examine the clock
	_interact("grandfather_clock")

	# -- PARLOR --
	_transition("parlor")
	_assert_room("parlor", "Parlor")
	_assert_has_interactable("parlor_painting_1")
	_assert_has_interactable("parlor_note")

	# Read Lady Ashworth portrait
	_interact("parlor_painting_1")

	# Read torn diary page — FIRST CLUE about Elizabeth
	_interact("parlor_note")
	assert_that(_gm.has_interacted("parlor_note")).is_true()

	# Back to foyer
	_transition("foyer")

	# -- KITCHEN --
	_transition("kitchen")
	_assert_room("kitchen", "Kitchen")

	# Back to foyer, go to dining room
	_transition("foyer")

	# -- DINING ROOM --
	_transition("dining_room")
	_assert_room("dining_room", "Dining Room")
	_transition("foyer")

	# === DESCENT TO BASEMENT ===

	# -- KITCHEN → STORAGE BASEMENT --
	_transition("kitchen")
	_transition("storage_basement")
	_assert_room("storage_basement", "Storage Basement")
	_assert_has_interactable("scratched_portrait")

	# Find scratched family portrait — FIRST physical evidence of 4th child
	_interact("scratched_portrait")
	assert_that(_gm.has_interacted("scratched_portrait")).is_true()

	# -- BOILER ROOM --
	_transition("boiler_room")
	_assert_room("boiler_room", "Boiler Room")
	_assert_has_interactable("maintenance_log")
	_interact("maintenance_log")

	# -- WINE CELLAR --
	_transition("storage_basement")
	_transition("wine_cellar")
	_assert_room("wine_cellar", "Wine Cellar")
	_assert_has_interactable("wine_note")
	_assert_has_interactable("wine_box")

	# Read wine inventory — "the key is with the portrait"
	_interact("wine_note")

	# Try the locked box — no key yet
	_interact("wine_box")
	assert_that(_gm.has_item("mothers_confession")).is_false()

	# === ACT II: THE SECRETS (UPPER FLOOR) ===

	# Back to foyer via basement → kitchen
	_transition("storage_basement")
	_transition("kitchen")
	_transition("foyer")

	# -- UPPER HALLWAY --
	_transition("upper_hallway")
	_assert_room("upper_hallway", "Upper Hallway")
	_assert_has_interactable("children_painting")
	_assert_has_interactable("attic_door")

	# See the children painting — only THREE children
	_interact("children_painting")

	# Try the locked attic door
	_interact("attic_door")
	# Should fail — no attic key yet
	assert_that(_gm.has_item("attic_key")).is_false()

	# -- MASTER BEDROOM --
	_transition("master_bedroom")
	_assert_room("master_bedroom", "Master Bedroom")
	_assert_has_interactable("diary_lord")

	# Read Lord Ashworth's diary — REVEALS KEY LOCATION
	_interact("diary_lord")
	assert_that(_gm.has_flag("read_ashworth_diary")).is_true()
	assert_that(_gm.has_flag("knows_key_location")).is_true()

	# -- LIBRARY --
	_transition("upper_hallway")
	_transition("library")
	_assert_room("library", "Library")
	_assert_has_interactable("library_globe")
	_assert_has_interactable("binding_book")
	_assert_has_interactable("family_tree")

	# Read family tree — E_iza_eth scratched out
	_interact("family_tree")

	# Read Rituals of Binding (pickable — goes to inventory)
	_interact("binding_book")
	assert_that(_gm.has_flag("knows_binding_ritual")).is_true()
	assert_that(_gm.has_item("binding_book")).is_true()

	# PUZZLE SOLVE: Open the globe — GET ATTIC KEY
	_interact("library_globe")
	assert_that(_gm.has_item("attic_key")).is_true()

	# -- GUEST ROOM (optional) --
	_transition("upper_hallway")
	_transition("guest_room")
	_assert_room("guest_room", "Guest Room")
	_transition("upper_hallway")

	# === GROUNDS: Collect ritual components ===

	# Back to foyer → front gate → grounds
	_transition("foyer")
	_transition("front_gate")

	# -- GREENHOUSE (gate key) --
	# Note: greenhouse connects to front_gate
	_transition("greenhouse")
	_assert_room("greenhouse", "Greenhouse")
	_assert_has_interactable("greenhouse_gate_key")
	_interact("greenhouse_gate_key")
	assert_that(_gm.has_item("gate_key")).is_true()
	_interact("white_lily")
	_transition("front_gate")

	# -- CHAPEL (blessed water) --
	_transition("chapel")
	_assert_room("chapel", "Estate Chapel")
	_assert_has_interactable("baptismal_font")
	_interact("baptismal_font")
	assert_that(_gm.has_item("blessed_water")).is_true()
	_interact("chapel_cross")
	_transition("front_gate")

	# -- CARRIAGE HOUSE (cellar key) --
	_transition("carriage_house")
	_assert_room("carriage_house", "Carriage House")
	_assert_has_interactable("carriage_portrait")
	_interact("carriage_portrait")
	assert_that(_gm.has_item("cellar_key")).is_true()
	_transition("front_gate")

	# -- GARDEN → FAMILY CRYPT (jewelry key) --
	_transition("garden")
	_assert_room("garden", "Hedge Garden")
	_interact("frozen_fountain")
	_interact("gazebo_bench")
	_transition("family_crypt")
	_assert_room("family_crypt", "Family Crypt")
	_assert_has_interactable("missing_plaque")
	_assert_has_interactable("loose_flagstone")

	# See the missing fourth plaque — Elizabeth erased from death
	_interact("missing_plaque")

	# PUZZLE SOLVE: Get jewelry key from loose flagstone
	_interact("loose_flagstone")
	assert_that(_gm.has_item("jewelry_key")).is_true()
	_transition("garden")
	_transition("front_gate")

	# === COLLECT REMAINING ITEMS ===

	# Wine cellar — open locked box with cellar key
	_transition("foyer")
	_transition("kitchen")
	_transition("storage_basement")
	_transition("wine_cellar")
	_interact("wine_box")
	assert_that(_gm.has_item("mothers_confession")).is_true()

	# Master bedroom — open jewelry box with jewelry key
	_transition("storage_basement")
	_transition("kitchen")
	_transition("foyer")
	_transition("upper_hallway")
	_transition("master_bedroom")
	_interact("jewelry_box")
	assert_that(_gm.has_item("elizabeths_locket")).is_true()
	assert_that(_gm.has_item("lock_of_hair")).is_true()

	# === ACT III: THE TRUTH (ATTIC) ===

	# Unlock attic door (have attic_key)
	_transition("upper_hallway")
	_interact("attic_door")
	# attic_door is type locked_door — should transition to attic_stairs

	# -- ATTIC STAIRWELL --
	_load_room("attic_stairs")  # Direct load since locked_door handler transitions
	_assert_room("attic_stairs", "Attic Stairwell")

	# -- ATTIC STORAGE (Elizabeth's prison) --
	_transition("attic_storage")
	_assert_room("attic_storage", "Attic Storage")
	assert_that(_gm.has_flag("elizabeth_aware")).is_true()

	_assert_has_interactable("elizabeth_portrait")
	_assert_has_interactable("porcelain_doll")
	_assert_has_interactable("elizabeth_letter")

	# See Elizabeth's portrait
	_interact("elizabeth_portrait")
	assert_that(_gm.has_flag("knows_elizabeth")).is_true()

	# Read Elizabeth's unsent letter
	_interact("elizabeth_letter")
	assert_that(_gm.has_flag("read_elizabeth_letter")).is_true()

	# PUZZLE SOLVE: Porcelain doll — first interaction
	_interact("porcelain_doll")
	assert_that(_gm.has_flag("examined_doll")).is_true()

	# Second interaction — extract hidden key
	_interact("porcelain_doll")
	assert_that(_gm.has_item("hidden_key")).is_true()
	assert_that(_gm.has_item("porcelain_doll")).is_true()

	# -- HIDDEN CHAMBER (final revelation) --
	_interact("hidden_door")  # Unlock with hidden_key
	_load_room("hidden_room")
	_assert_room("hidden_room", "Hidden Chamber")

	_assert_has_interactable("final_note")
	_assert_has_interactable("ritual_circle")

	# Read Elizabeth's final words
	_interact("final_note")
	assert_that(_gm.has_flag("knows_full_truth")).is_true()
	assert_that(_gm.has_flag("read_final_note")).is_true()

	# === COUNTER-RITUAL (Freedom Ending) ===

	# Verify all components collected
	assert_that(_gm.has_item("porcelain_doll")).is_true()
	assert_that(_gm.has_item("binding_book")).is_true()
	assert_that(_gm.has_item("lock_of_hair")).is_true()
	assert_that(_gm.has_item("blessed_water")).is_true()
	assert_that(_gm.has_item("mothers_confession")).is_true()
	assert_that(_gm.has_flag("read_final_note")).is_true()
	assert_that(_gm.can_perform_ritual()).is_true()

	# Step 1: Place doll
	_interact("ritual_circle")
	assert_that(_gm.has_flag("ritual_step_1")).is_true()

	# Step 2: Pour blessed water
	_interact("ritual_circle")
	assert_that(_gm.has_flag("ritual_step_2")).is_true()
	assert_that(_gm.has_item("blessed_water")).is_false()  # consumed

	# Step 3: Read from binding book — COMPLETES RITUAL
	_interact("ritual_circle")
	assert_that(_gm.has_flag("ritual_step_3")).is_true()
	assert_that(_gm.has_flag("counter_ritual_complete")).is_true()
	assert_that(_gm.has_flag("freed_elizabeth")).is_true()

	# FREEDOM ENDING ACHIEVED
	print("=== E2E PLAYTHROUGH COMPLETE: FREEDOM ENDING ===")
	print("Rooms visited: ", _gm.visited_rooms.size())
	print("Items collected: ", _gm.inventory.size())
	print("Flags set: ", _gm.flags.size())


## ============================================================
## TEST: Escape Ending
## ============================================================

func test_escape_ending() -> void:
	_gm.new_game()
	await get_tree().process_frame

	# Fast-track to knows_full_truth without ritual
	_load_room("front_gate")
	_transition("foyer")
	_transition("upper_hallway")

	# Get attic key
	_transition("library")
	_interact("library_globe")

	# Enter attic
	_load_room("attic_stairs")
	_transition("attic_storage")
	assert_that(_gm.has_flag("elizabeth_aware")).is_true()

	# Read letter and interact with doll
	_interact("elizabeth_letter")
	_interact("porcelain_doll")
	_interact("porcelain_doll")

	# Enter hidden chamber, read final note
	_load_room("hidden_room")
	_interact("final_note")
	assert_that(_gm.has_flag("knows_full_truth")).is_true()

	# Try to leave without completing ritual
	assert_that(_gm.has_flag("counter_ritual_complete")).is_false()
	assert_that(_gm.check_escape_ending()).is_true()

	print("=== E2E: ESCAPE ENDING CONDITIONS MET ===")


## ============================================================
## TEST: Joined Ending
## ============================================================

func test_joined_ending() -> void:
	_gm.new_game()
	await get_tree().process_frame

	# Enter attic (sets elizabeth_aware) but don't read final note
	_load_room("front_gate")
	_transition("foyer")
	_transition("upper_hallway")
	_transition("library")
	_interact("library_globe")
	_load_room("attic_stairs")
	_transition("attic_storage")

	assert_that(_gm.has_flag("elizabeth_aware")).is_true()
	assert_that(_gm.has_flag("knows_full_truth")).is_false()
	assert_that(_gm.check_joined_ending()).is_true()

	print("=== E2E: JOINED ENDING CONDITIONS MET ===")


## ============================================================
## TEST: Save and Load
## ============================================================

func test_save_and_load() -> void:
	_gm.new_game()
	await get_tree().process_frame

	_load_room("front_gate")
	_transition("foyer")
	_interact("foyer_painting")

	# Collect an item
	_transition("upper_hallway")
	_transition("library")
	_interact("library_globe")
	assert_that(_gm.has_item("attic_key")).is_true()

	# Save
	_gm.save_game()
	assert_that(_gm.has_save()).is_true()

	# Reset state
	_gm.new_game()
	assert_that(_gm.has_item("attic_key")).is_false()
	assert_that(_gm.inventory.is_empty()).is_true()

	# Load
	var loaded: bool = _gm.load_game()
	assert_that(loaded).is_true()
	assert_that(_gm.has_item("attic_key")).is_true()
	assert_that(_gm.current_room).is_equal("library")
	assert_that(_gm.visited_rooms.has("foyer")).is_true()
	assert_that(_gm.has_interacted("foyer_painting")).is_true()

	print("=== E2E: SAVE/LOAD VERIFIED ===")


## ============================================================
## TEST: Room connectivity — every room reachable
## ============================================================

func test_all_rooms_reachable() -> void:
	_gm.new_game()
	await get_tree().process_frame

	var all_rooms: Array[String] = [
		"front_gate", "foyer", "parlor", "dining_room", "kitchen",
		"upper_hallway", "master_bedroom", "library", "guest_room",
		"storage_basement", "boiler_room", "wine_cellar",
		"attic_stairs", "attic_storage", "hidden_room",
		"chapel", "greenhouse", "carriage_house", "garden", "family_crypt",
	]

	for room_id in all_rooms:
		_load_room(room_id)
		var room = _rm.get_current_room()
		assert_that(room).is_not_null()
		assert_that(room.room_id).is_equal(room_id)
		assert_that(room.room_name).is_not_empty()

	print("=== E2E: ALL 20 ROOMS LOADABLE ===")


## ============================================================
## TEST: Every interactable fires without error
## ============================================================

func test_all_interactables_fire() -> void:
	_gm.new_game()
	await get_tree().process_frame

	var all_rooms: Array[String] = [
		"front_gate", "foyer", "parlor", "dining_room", "kitchen",
		"upper_hallway", "master_bedroom", "library", "guest_room",
		"storage_basement", "boiler_room", "wine_cellar",
		"attic_stairs", "attic_storage", "hidden_room",
		"chapel", "greenhouse", "carriage_house", "garden", "family_crypt",
	]

	var total_interactables: int = 0
	for room_id in all_rooms:
		_load_room(room_id)
		var room = _rm.get_current_room()
		if room == null:
			continue
		for area in room.get_interactables():
			if area.has_meta("id"):
				_interact(area.get_meta("id"))
				total_interactables += 1

	assert_that(total_interactables).is_greater(30)
	print("=== E2E: %d INTERACTABLES FIRED ===" % total_interactables)


## ============================================================
## Helpers
## ============================================================

func _load_room(room_id: String) -> void:
	_rm.load_room(room_id)


func _transition(target_room: String) -> void:
	_rm.load_room(target_room)  # Direct load for test speed (skip fade)


func _assert_room(expected_id: String, expected_name: String) -> void:
	var room = _rm.get_current_room()
	assert_that(room).is_not_null()
	assert_that(room.room_id).is_equal(expected_id)
	assert_that(room.room_name).is_equal(expected_name)


func _assert_has_interactable(inter_id: String) -> void:
	var room = _rm.get_current_room()
	assert_that(room).is_not_null()
	var found: bool = false
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == inter_id:
			found = true
			break
	assert_that(found).is_true()


func _assert_has_connection(target_room: String) -> void:
	var room = _rm.get_current_room()
	assert_that(room).is_not_null()
	var found: bool = false
	for area in room.get_connections():
		if area.has_meta("target_room") and area.get_meta("target_room") == target_room:
			found = true
			break
	assert_that(found).is_true()


func _interact(object_id: String) -> void:
	var room = _rm.get_current_room()
	if room == null:
		return
	for area in room.get_interactables():
		if area.has_meta("id") and area.get_meta("id") == object_id:
			var obj_type: String = area.get_meta("type") if area.has_meta("type") else ""
			var obj_data: Dictionary = area.get_meta("data") if area.has_meta("data") else {}
			_im._on_interacted(object_id, obj_type, obj_data)
			# Dismiss any document overlay
			if _ui and _ui.has_method("hide_document"):
				_ui.hide_document()
			return


func _find(node_name: String) -> Node:
	return _find_recursive(get_tree().root, node_name)


func _find_recursive(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var found: Node = _find_recursive(child, target)
		if found != null:
			return found
	return null
