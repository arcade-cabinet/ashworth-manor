extends SceneTree
## Declaration validation suite. Loads main.tscn first to register all
## class_name types, then validates declarations.
## Run: godot --headless --script test/generated/test_declarations.gd

const RoomAnchorDeclScript = preload("res://engine/declarations/room_anchor_decl.gd")
const RegionCompilerScript = preload("res://engine/region_compiler.gd")
const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const EstateEnvironmentRegistry = preload("res://builders/estate_environment_registry.gd")
const EstateSubstrateRegistry = preload("res://builders/estate_substrate_registry.gd")
const FloorBuilder = preload("res://builders/floor_builder.gd")
const CeilingBuilder = preload("res://builders/ceiling_builder.gd")
const WallBuilder = preload("res://builders/wall_builder.gd")
const DoorBuilder = preload("res://builders/door_builder.gd")
const WindowBuilder = preload("res://builders/window_builder.gd")
const StairsBuilder = preload("res://builders/stairs_builder.gd")
const LadderBuilder = preload("res://builders/ladder_builder.gd")
const TrapdoorBuilder = preload("res://builders/trapdoor_builder.gd")
const DoorSingleScript = preload("res://scripts/procedural/door_single.gd")
const DoorDoubleScript = preload("res://scripts/procedural/door_double.gd")
const InteractableVisualsScript = preload("res://engine/interactable_visuals.gd")
const RoomAssembler = preload("res://engine/room_assembler.gd")
const PBRTextureKit = preload("res://builders/pbr_texture_kit.gd")
const SubstratePresetDecl = preload("res://engine/declarations/substrate_preset_decl.gd")
const TerrainPresetDecl = preload("res://engine/declarations/terrain_preset_decl.gd")
const SkyPresetDecl = preload("res://engine/declarations/sky_preset_decl.gd")
const ConnectionDecl = preload("res://engine/declarations/connection.gd")
const MountPayloadDecl = preload("res://engine/declarations/mount_payload_decl.gd")
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
	_test_interactable_visual_contract()
	_test_grounds_scene_prop_contract()
	_test_mount_payload_substrate_contract()
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
	_test_builder_default_contract()
	_test_shared_recipe_scenes()
	_test_grounds_material_contract()
	_test_material_factory_allowlist()
	_test_procedural_compatibility_contract()
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


func _test_interactable_visual_contract() -> void:
	_test_name = "INTERACTABLE_VISUALS"
	var repeated_visuals := [
		{
			"room_path": "res://declarations/rooms/kitchen.tres",
			"id": "kitchen_bucket",
			"visual_kind": "kitchen_bucket_still",
			"base_path": "res://scenes/shared/kitchen/kitchen_bucket_still.tscn",
			"states": {"rippled": "res://scenes/shared/kitchen/kitchen_bucket_rippled.tscn"},
		},
		{
			"room_path": "res://declarations/rooms/front_gate.tres",
			"id": "gate_luggage",
			"visual_kind": "front_gate_valise_closed",
			"base_path": "res://scenes/shared/front_gate/front_gate_valise_closed.tscn",
			"states": {"opened": "res://scenes/shared/front_gate/front_gate_valise_open.tscn"},
		},
		{
			"room_path": "res://declarations/rooms/front_gate.tres",
			"id": "gate_lamp",
			"visual_kind": "front_gate_lamp_lit",
			"base_path": "res://assets/grounds/front_gate/lamp_mx_1_b_on.glb",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/front_gate.tres",
			"id": "gate_bench",
			"visual_kind": "front_gate_bench",
			"base_path": "res://assets/grounds/front_gate/bench_mx_1.glb",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/garden.tres",
			"id": "garden_fountain",
			"visual_kind": "garden_fountain",
			"base_path": "res://assets/grounds/garden/fountain01_round.glb",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/garden.tres",
			"id": "garden_gazebo",
			"visual_kind": "garden_gazebo",
			"base_path": "res://assets/grounds/garden/gazebo.glb",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/greenhouse.tres",
			"id": "greenhouse_pot",
			"visual_kind": "greenhouse_lily_pot_intact",
			"base_path": "res://scenes/shared/greenhouse/greenhouse_lily_pot_intact.tscn",
			"states": {"disturbed": "res://scenes/shared/greenhouse/greenhouse_lily_pot_disturbed.tscn"},
		},
		{
			"room_path": "res://declarations/rooms/parlor.tres",
			"id": "parlor_tea",
			"visual_kind": "parlor_tea_set",
			"base_path": "res://scenes/shared/parlor/parlor_tea_service_set.tscn",
			"states": {"disturbed": "res://scenes/shared/parlor/parlor_tea_service_disturbed.tscn"},
		},
		{
			"room_path": "res://declarations/rooms/chapel.tres",
			"id": "baptismal_font",
			"visual_kind": "chapel_font_still",
			"base_path": "res://scenes/shared/chapel/baptismal_font_still.tscn",
			"states": {
				"disturbed": "res://scenes/shared/chapel/baptismal_font_disturbed.tscn",
				"searched": "res://scenes/shared/chapel/baptismal_font_searched.tscn",
			},
		},
		{
			"room_path": "res://declarations/rooms/dining_room.tres",
			"id": "wine_glass",
			"visual_kind": "dining_wine_still",
			"base_path": "res://scenes/shared/dining_room/dining_wine_glass_still.tscn",
			"states": {"agitated": "res://scenes/shared/dining_room/dining_wine_glass_agitated.tscn"},
		},
		{
			"room_path": "res://declarations/rooms/parlor.tres",
			"id": "music_box",
			"visual_kind": "music_box_display",
			"base_path": "res://scenes/shared/items/music_box_display.tscn",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/hidden_chamber.tres",
			"id": "child_music_box",
			"visual_kind": "music_box_display",
			"base_path": "res://scenes/shared/items/music_box_display.tscn",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/attic_storage.tres",
			"id": "attic_music_box",
			"visual_kind": "music_box_display",
			"base_path": "res://scenes/shared/items/music_box_display.tscn",
			"states": {},
		},
		{
			"room_path": "res://declarations/rooms/family_crypt.tres",
			"id": "crypt_music_box",
			"visual_kind": "music_box_display",
			"base_path": "res://scenes/shared/items/music_box_display.tscn",
			"states": {},
		},
	]
	for entry in repeated_visuals:
		var room = load(String(entry["room_path"]))
		_ok("%s loads" % entry["room_path"], room != null)
		if room == null:
			continue
		var interactable := _find_interactable_by_id(room.interactables, String(entry["id"]))
		_ok("%s present in %s" % [entry["id"], room.room_id], interactable != null)
		if interactable == null:
			continue
		_ok("%s uses visual kind" % interactable.id, interactable.visual_kind == String(entry["visual_kind"]))
		_ok("%s clears direct scene path" % interactable.id, interactable.scene_path.is_empty())
		_ok("%s clears direct model path" % interactable.id, interactable.model.is_empty())
		_ok("%s clears state model map" % interactable.id, interactable.state_model_map.is_empty())
		_ok(
			"%s base visual resolves through visual kind" % interactable.id,
			InteractableVisualsScript._resolve_visual_path(interactable, "") == String(entry["base_path"])
		)
		var state_paths: Dictionary = entry["states"]
		for state_name in state_paths.keys():
			_ok(
				"%s state '%s' uses visual kind map" % [interactable.id, state_name],
				interactable.state_visual_kind_map.has(state_name)
			)
			_ok(
				"%s state '%s' resolves through visual kind" % [interactable.id, state_name],
				InteractableVisualsScript._resolve_visual_path(interactable, String(state_name)) == String(state_paths[state_name])
			)
	print("[DONE] interactable visual contract")


func _test_grounds_scene_prop_contract() -> void:
	_test_name = "GROUNDS_SCENE_PROPS"
	var repeated_props := [
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_service_boundary_wall", "kind": "boundary_wall"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_service_gate_inner_pillar", "kind": "gate_post"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_service_gate_prop", "kind": "iron_gate_closed"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_service_fence_stub", "kind": "fence_run"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_forecourt_steps_shell", "kind": "forecourt_steps"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_mansion_facade_shell", "kind": "mansion_facade"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_entry_portico", "kind": "entry_portico"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_facade_lamp_left", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_facade_lamp_right", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "gate_pillar_l", "kind": "gate_post"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "boundary_wall", "kind": "boundary_wall"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "boundary_pole_r", "kind": "front_gate_boundary_pole"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "iron_gate_center", "kind": "iron_gate_open"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "iron_gate_center_r", "kind": "iron_gate_leaf_angled"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree1", "kind": "front_gate_tree_01"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree2", "kind": "front_gate_tree_02"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree3", "kind": "front_gate_tree_03"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree4", "kind": "front_gate_tree_04"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree5", "kind": "front_gate_tree_01"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree6", "kind": "front_gate_tree_02"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "tree7", "kind": "front_gate_tree_03"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "bush1", "kind": "front_gate_bush_01"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "bush2", "kind": "front_gate_bush_02"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "bush3", "kind": "front_gate_bush_03"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "bush4", "kind": "front_gate_bush_04"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "bush5", "kind": "front_gate_bush_01"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "bush6", "kind": "front_gate_bush_02"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "rocks", "kind": "front_gate_rocks"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "gate_lamp_off", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "facade_lamp_left", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "facade_lamp_right", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "statue_left", "kind": "forecourt_statue"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "statue_right", "kind": "forecourt_statue"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "facade_chimney_left", "kind": "front_gate_chimney_left"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "facade_chimney_right", "kind": "front_gate_chimney_right"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "front_gate_main_road", "kind": "carriage_road"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "front_gate_outward_road", "kind": "outward_road"},
		{"room_path": "res://declarations/rooms/front_gate.tres", "id": "front_gate_starfield", "kind": "starfield"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "crypt_pillar_l", "kind": "gate_post_stone"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "crypt_gate", "kind": "iron_gate_closed"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "fountain_model", "kind": "garden_fountain_base"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "fountain_ice", "kind": "garden_fountain_water"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "gazebo_model", "kind": "garden_gazebo_shell"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "path_west", "kind": "garden_path_west"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "path_center", "kind": "garden_path_center"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "path_north", "kind": "garden_path_north"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "path_chapel", "kind": "garden_path_center"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "path_crypt", "kind": "garden_path_crypt"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "north_wall_w", "kind": "garden_north_wall_w"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "north_wall_e", "kind": "garden_north_wall_e"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "east_wall_s", "kind": "garden_east_wall_s"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "east_wall_n", "kind": "garden_east_wall_n"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "corner_ne", "kind": "garden_corner_ne"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "fountain_column_l", "kind": "garden_column_l"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "fountain_column_r", "kind": "garden_column_r"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "vase_l", "kind": "garden_vase_l"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "vase_r", "kind": "garden_vase_r"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "bench_model", "kind": "garden_bench_west"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "gazebo_table", "kind": "garden_gazebo_table"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "bench_north", "kind": "garden_bench_north"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "beds_west", "kind": "garden_beds_west"},
		{"room_path": "res://declarations/rooms/garden.tres", "id": "beds_east", "kind": "garden_beds_east"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "wall_nw", "kind": "chapel_wall_column_fancy"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "wall_n", "kind": "chapel_wall_center"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "wall_ne", "kind": "chapel_wall_column_fancy"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "wall_w", "kind": "chapel_wall_column"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "wall_e", "kind": "chapel_wall_column"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "font_bucket", "kind": "chapel_bucket"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "font_bottle", "kind": "chapel_bottle"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "dead_lamp", "kind": "chapel_dead_lamp"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "loose_bones", "kind": "chapel_bones"},
		{"room_path": "res://declarations/rooms/chapel.tres", "id": "saint_statue", "kind": "forecourt_statue"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "mattress_model", "kind": "carriage_house_mattress"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "shed_a", "kind": "carriage_house_shed_a"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "shed_b", "kind": "carriage_house_shed_b"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "shed_c", "kind": "carriage_house_shed_c"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "shed_d", "kind": "carriage_house_shed_d"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "board_1", "kind": "carriage_house_board_1"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "board_2", "kind": "carriage_house_board_2"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "shovel", "kind": "carriage_house_shovel"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "luggage", "kind": "carriage_house_luggage"},
		{"room_path": "res://declarations/rooms/carriage_house.tres", "id": "dead_lamp", "kind": "carriage_house_dead_lamp"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "plank_bench", "kind": "greenhouse_plank_bench"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "plank_shelf", "kind": "greenhouse_plank_shelf"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "dead_row_w", "kind": "greenhouse_dead_row"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "dead_row_e", "kind": "greenhouse_dead_row"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "dead_end_cap", "kind": "greenhouse_dead_end"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "tall_dead_growth", "kind": "greenhouse_tall_dead"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "winter_growth", "kind": "greenhouse_winter_growth"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "winter_growth_back", "kind": "greenhouse_winter_growth_back"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "nature_cluster", "kind": "greenhouse_nature_cluster"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "bucket_left", "kind": "greenhouse_bucket_small"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "bucket_right", "kind": "greenhouse_bucket_large"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "fertilizer_bottle", "kind": "greenhouse_bottle"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "greenhouse_bottle_secondary", "kind": "greenhouse_bottle"},
		{"room_path": "res://declarations/rooms/greenhouse.tres", "id": "greenhouse_bucket_center", "kind": "greenhouse_bucket_small"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "gate_column_l", "kind": "gate_post_stone"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "crypt_gate_prop", "kind": "iron_gate_closed"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "wall_n", "kind": "family_crypt_wall_capped"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "wall_w", "kind": "family_crypt_wall"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "wall_e", "kind": "family_crypt_wall"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "fence_w", "kind": "family_crypt_fence_run"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "fence_e", "kind": "family_crypt_fence_run"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "grave_edmund", "kind": "family_crypt_grave_marker"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "grave_victoria", "kind": "family_crypt_grave_marker"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "grave_blank", "kind": "family_crypt_grave_marker"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "debris_l", "kind": "family_crypt_debris_left"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "debris_r", "kind": "family_crypt_debris_right"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "mourning_bottle", "kind": "family_crypt_bottle"},
		{"room_path": "res://declarations/rooms/family_crypt.tres", "id": "scattered_bones", "kind": "family_crypt_bones"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_road", "kind": "carriage_road"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_hedge_left_mid", "kind": "hedgerow"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_tree_left", "kind": "front_gate_tree_01"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_tree_right", "kind": "front_gate_tree_02"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_bush_left", "kind": "front_gate_bush_03"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_bush_right", "kind": "front_gate_bush_04"},
		{"room_path": "res://declarations/rooms/drive_lower.tres", "id": "drive_lower_starfield", "kind": "starfield"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_road", "kind": "carriage_road"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_forecourt_steps", "kind": "forecourt_steps"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_mansion_facade_shell", "kind": "mansion_facade"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_entry_portico", "kind": "entry_portico"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_facade_door", "kind": "front_door_assembly"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_facade_lamp_left", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_facade_lamp_right", "kind": "front_gate_lamp"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_statue_left", "kind": "forecourt_statue"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_statue_right", "kind": "forecourt_statue"},
		{"room_path": "res://declarations/rooms/drive_upper.tres", "id": "drive_upper_rocks", "kind": "front_gate_rocks"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_statue_left", "kind": "forecourt_statue"},
		{"room_path": "res://declarations/rooms/front_steps.tres", "id": "front_steps_statue_right", "kind": "forecourt_statue"},
	]
	for entry in repeated_props:
		var room = load(String(entry["room_path"]))
		_ok("%s loads" % entry["room_path"], room != null)
		if room == null:
			continue
		var prop := _find_prop_by_id(room.props, String(entry["id"]))
		_ok("%s present in %s" % [entry["id"], room.room_id], prop != null)
		if prop == null:
			continue
		_ok("%s uses substrate prop kind" % prop.id, prop.substrate_prop_kind == String(entry["kind"]))
		_ok("%s clears direct scene path" % prop.id, prop.scene_path.is_empty())
	print("[DONE] grounds scene prop contract")


func _test_mount_payload_substrate_contract() -> void:
	_test_name = "MOUNT_PAYLOAD_SUBSTRATE"
	var front_gate := load("res://declarations/rooms/front_gate.tres")
	_ok("front_gate loads", front_gate != null)
	if front_gate != null:
		var menu_payload := _find_mount_payload_by_id(front_gate.mount_payloads, "front_gate_menu_sign_payload")
		_ok("front_gate menu payload present", menu_payload != null)
		if menu_payload != null:
			_ok("front_gate menu payload uses substrate kind", menu_payload.substrate_prop_kind == "front_gate_sign")
			_ok("front_gate menu payload clears direct scene path", menu_payload.scene_path.is_empty())
		var lamp_payload := _find_mount_payload_by_id(front_gate.mount_payloads, "gate_lamp_off_payload")
		_ok("front_gate lamp payload present", lamp_payload != null)
		if lamp_payload != null:
			_ok("front_gate lamp payload uses substrate kind", lamp_payload.substrate_prop_kind == "front_gate_lamp")
			_ok("front_gate lamp payload clears direct model path", lamp_payload.model.is_empty())
	var greenhouse := load("res://declarations/rooms/greenhouse.tres")
	_ok("greenhouse loads", greenhouse != null)
	if greenhouse != null:
		var pedestal := _find_prop_by_id(greenhouse.props, "greenhouse_table")
		_ok("greenhouse pedestal prop present", pedestal != null)
		if pedestal != null:
			_ok("greenhouse pedestal uses substrate kind", pedestal.substrate_prop_kind == "greenhouse_pedestal")
			_ok("greenhouse pedestal clears direct scene path", pedestal.scene_path.is_empty())
	print("[DONE] mount payload substrate contract")


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
	var legacy_candle_models := {
		"res://assets/shared/decor/candle_holder.glb": "candle_holder_fixture",
		"res://assets/shared/items/candle0.glb": "candle_single",
	}
	var legacy_frame_models := {
		"res://assets/shared/decor/picture_blank.glb": "picture_frame_blank_000",
		"res://assets/shared/decor/picture_blank_001.glb": "picture_frame_blank_001",
		"res://assets/shared/decor/picture_blank_002.glb": "picture_frame_blank_002",
		"res://assets/shared/decor/picture_blank_003.glb": "picture_frame_blank_003",
		"res://assets/shared/decor/picture_blank_004.glb": "picture_frame_blank_004",
		"res://assets/shared/decor/picture_blank_005.glb": "picture_frame_blank_005",
		"res://assets/shared/decor/picture_blank_006.glb": "picture_frame_blank_006",
	}
	var legacy_rug_models := {
		"res://assets/shared/decor/rug0.glb": "rug_0",
		"res://assets/shared/decor/rug1.glb": "rug_1",
		"res://assets/shared/decor/rug2.glb": "rug_2",
	}
	var legacy_furniture_models := {
		"res://assets/shared/furniture/table.glb": "furniture_table",
		"res://assets/shared/furniture/study_desk.glb": "furniture_study_desk",
		"res://assets/shared/furniture/drawers.glb": "furniture_drawers",
		"res://assets/shared/furniture/chair.glb": "furniture_chair",
		"res://assets/shared/furniture/bookcase.glb": "furniture_bookcase",
		"res://assets/shared/furniture/bed.glb": "furniture_bed",
		"res://assets/shared/decor/chandelier.glb": "chandelier_fixture",
	}
	var legacy_item_display_models := {
		"res://assets/shared/items/page1.glb": "item_page_001",
		"res://assets/shared/items/page2.glb": "item_page_002",
		"res://assets/shared/items/page5.glb": "item_page_005",
		"res://assets/shared/items/openbook0.glb": "item_openbook_000",
		"res://assets/shared/items/openbook1.glb": "item_openbook_001",
	}
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
	for connection in world.connections:
		if connection == null:
			continue
		if connection.type == "door":
			_ok("%s authored door omits default mechanism type" % connection.id, connection.mechanism_type.is_empty())
		if connection.type == "hidden_door":
			_ok("%s hidden door omits default presentation type" % connection.id, connection.presentation_type.is_empty())
			_ok("%s hidden door omits default mechanism type" % connection.id, connection.mechanism_type.is_empty())
		if connection.type == "trapdoor":
			_ok("%s trapdoor omits default mechanism type" % connection.id, connection.mechanism_type.is_empty())
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
			if not room_decl.is_exterior:
				for role in ["floor", "wall", "ceiling"]:
					_ok(
						"%s environment defines %s recipe" % [room_ref.room_id, role],
						resolved_env.surface_recipe_overrides.has(role)
					)
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
		for prop in room_decl.props:
			if prop == null:
				continue
			var legacy_kind := String(legacy_candle_models.get(prop.model, ""))
			if legacy_kind.is_empty():
				legacy_kind = String(legacy_frame_models.get(prop.model, ""))
			if legacy_kind.is_empty():
				legacy_kind = String(legacy_rug_models.get(prop.model, ""))
			if legacy_kind.is_empty():
				legacy_kind = String(legacy_furniture_models.get(prop.model, ""))
			if legacy_kind.is_empty():
				legacy_kind = String(legacy_item_display_models.get(prop.model, ""))
			if not legacy_kind.is_empty():
				_ok("%s prop %s clears raw repeated model path" % [room_ref.room_id, prop.id], prop.model.is_empty())
				_ok("%s prop %s uses repeated substrate kind" % [room_ref.room_id, prop.id], prop.substrate_prop_kind == legacy_kind)
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
				not payload.substrate_prop_kind.is_empty() or not payload.scene_path.is_empty() or not payload.model.is_empty()
			)
			for route_mode in payload.route_modes:
				_ok(
					"%s mount payload route mode %s supported" % [payload.payload_id, route_mode],
					SUPPORTED_MOUNT_ROUTE_MODES.has(String(route_mode))
				)
		for prop in room_decl.props:
			if prop == null:
				continue
			_ok(
				"%s:%s model field stays asset-like, not scene-like" % [room_ref.room_id, prop.id],
				prop.model.is_empty() or not String(prop.model).ends_with(".tscn")
			)
			if prop.scene_role in ["architectural_trim", "threshold_trim"] and prop.substrate_prop_kind.is_empty():
				_ok(
					"%s:%s non-substrate architectural prop has explicit waiver" % [room_ref.room_id, prop.id],
					not prop.substrate_waiver_reason.is_empty()
				)
			_ok(
				"%s:%s has no active substrate waiver" % [room_ref.room_id, prop.id],
				prop.substrate_waiver_reason.is_empty()
			)
	print("[DONE] substrate contract")

	var retired_structure_models := {
		"res://assets/shared/structure/window_clean.glb": "window_frame",
		"res://assets/shared/structure/window_ray.glb": "window_ray",
		"res://assets/shared/structure/stairs0.glb": "stair_run",
		"res://assets/shared/structure/stairbanister.glb": "banister_run",
		"res://assets/shared/structure/banisterbase.glb": "newel_post",
		"res://assets/shared/structure/floor3.glb": "stone_slab",
		"res://assets/shared/structure/pillar0_002.glb": "plinth_tall",
		"res://assets/shared/structure/pillar0_003.glb": "plinth_tall",
		"res://assets/shared/structure/pillar1.glb": "round_pillar",
		"res://assets/shared/structure/door1.glb": "facade_door_leaf",
		"res://assets/mansion_psx/models/SM_Door_Wall.glb": "manor_wall_panel",
		"res://assets/mansion_psx/models/SM_Window_Wall.glb": "manor_window_panel",
		"res://assets/mansion_psx/models/SM_Big_Wall.glb": "manor_wing_panel",
		"res://assets/mansion_psx/models/SM_Wall_Column.glb": "manor_wall_column",
		"res://assets/mansion_psx/models/SM_Door_Frame.glb": "doorway_trim",
		"res://assets/mansion_psx/models/SM_Roof.glb": "manor_roof_panel",
		"res://assets/mansion_psx/models/SM_Big_Roof_Molding.glb": "manor_roof_molding",
		"res://assets/mansion_psx/models/SM_Big_Wall_Molding.glb": "manor_frieze",
	}
	var dir := DirAccess.open("res://declarations/rooms/")
	if dir != null:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var room := load("res://declarations/rooms/" + file_name)
				if room != null and "props" in room:
					for prop in room.props:
						if prop == null:
							continue
						var expected_kind := String(retired_structure_models.get(prop.model, ""))
						if not expected_kind.is_empty():
							_ok(
								"%s:%s migrated repeated structure prop to substrate kind" % [room.room_id, prop.id],
								prop.substrate_prop_kind == expected_kind
							)
			file_name = dir.get_next()


func _room_has_window_segments(room_decl: RoomDeclaration) -> bool:
	for layout in [room_decl.wall_north, room_decl.wall_south, room_decl.wall_east, room_decl.wall_west]:
		for segment in layout:
			if String(segment).begins_with("window"):
				return true
	return false


func _test_shared_recipe_scenes() -> void:
	_test_name = "SHARED_RECIPE_SCENES"
	var recipe_scenes := [
		"res://scenes/shared/greenhouse/greenhouse_glazed_shell.tscn",
		"res://scenes/shared/greenhouse/greenhouse_hanging_lantern.tscn",
		"res://scenes/shared/greenhouse/greenhouse_lily_pedestal.tscn",
		"res://scenes/shared/greenhouse/greenhouse_lily_pot_intact.tscn",
		"res://scenes/shared/greenhouse/greenhouse_lily_pot_disturbed.tscn",
		"res://scenes/shared/parlor/parlor_tea_service_set.tscn",
		"res://scenes/shared/parlor/parlor_tea_service_disturbed.tscn",
		"res://scenes/shared/chapel/baptismal_font_still.tscn",
		"res://scenes/shared/chapel/baptismal_font_disturbed.tscn",
		"res://scenes/shared/chapel/baptismal_font_searched.tscn",
	]
	for scene_path in recipe_scenes:
		_ok("%s exists" % scene_path, ResourceLoader.exists(scene_path))
		if not ResourceLoader.exists(scene_path):
			continue
		var scene := load(scene_path) as PackedScene
		_ok("%s loads" % scene_path, scene != null)
		var text := FileAccess.get_file_as_string(scene_path)
		_ok("%s uses recipe applicator" % scene_path, text.contains("shared_recipe_applicator.gd"))
		_ok("%s has no embedded StandardMaterial3D" % scene_path, not text.contains("[sub_resource type=\"StandardMaterial3D\""))
	print("[DONE] shared recipe scenes")


func _test_grounds_material_contract() -> void:
	_test_name = "GROUNDS_MATERIALS"
	var grounded_scripts := [
		"res://scenes/shared/grounds/estate_front_door.gd",
		"res://scenes/shared/grounds/estate_entry_portico.gd",
		"res://scenes/shared/grounds/estate_mansion_facade.gd",
		"res://scenes/shared/grounds/estate_outward_road.gd",
		"res://scenes/shared/grounds/estate_starfield.gd",
		"res://scripts/procedural/door_single.gd",
		"res://scripts/procedural/door_double.gd",
	]
	for script_path in grounded_scripts:
		_ok("%s exists" % script_path, ResourceLoader.exists(script_path))
		if not ResourceLoader.exists(script_path):
			continue
		var text := FileAccess.get_file_as_string(script_path)
		_ok("%s has no local StandardMaterial3D construction" % script_path, not text.contains("StandardMaterial3D.new()"))
	print("[DONE] grounds material contract")


func _test_material_factory_allowlist() -> void:
	_test_name = "MATERIAL_FACTORY_ALLOWLIST"
	var allowed := {
		"res://builders/estate_material_kit.gd": true,
		"res://builders/pbr_texture_kit.gd": true,
	}
	var roots := [
		"res://builders",
		"res://engine",
		"res://scenes/shared",
		"res://scripts/procedural",
	]
	var offenders: Array[String] = []
	for root_path in roots:
		for file_path in _collect_source_files(root_path):
			var text := FileAccess.get_file_as_string(file_path)
			if text.contains("StandardMaterial3D.new()") and not allowed.has(file_path):
				offenders.append(file_path)
	_ok("local StandardMaterial3D construction confined to factory layer", offenders.is_empty())
	for offender in offenders:
		_ng("unexpected local StandardMaterial3D factory in %s" % offender)
	print("[DONE] material factory allowlist")


func _test_procedural_compatibility_contract() -> void:
	_test_name = "PROCEDURAL_COMPATIBILITY"
	var single_path := "res://scripts/procedural/door_single.gd"
	var double_path := "res://scripts/procedural/door_double.gd"
	var single_text := FileAccess.get_file_as_string(single_path)
	var double_text := FileAccess.get_file_as_string(double_path)
	_ok("door_single uses legacy_door_texture naming", single_text.contains("@export var legacy_door_texture: Texture2D"))
	_ok("door_single no longer exports door_texture", not single_text.contains("@export var door_texture: Texture2D"))
	_ok("door_double uses legacy door texture naming", double_text.contains("@export var legacy_door_texture: Texture2D"))
	_ok("door_double uses legacy frame texture naming", double_text.contains("@export var legacy_frame_texture: Texture2D"))
	_ok("door_double no longer exports door_texture", not double_text.contains("@export var door_texture: Texture2D"))
	_ok("door_double no longer exports frame_texture", not double_text.contains("@export var frame_texture: Texture2D"))
	print("[DONE] procedural compatibility contract")


func _test_builder_default_contract() -> void:
	_test_name = "BUILDER_DEFAULTS"
	var floor := FloorBuilder.build(4.0, 4.0, "", "wood")
	var floor_tile := floor.get_node_or_null("FloorTile_0_0") as MeshInstance3D
	_ok("floor builder emits tile", floor_tile != null)
	_ok("floor builder default material applied", floor_tile != null and floor_tile.get_active_material(0) != null)

	var ceiling := CeilingBuilder.build(4.0, 2.4, 4.0, "")
	var ceiling_tile := ceiling.get_node_or_null("CeilingTile_0_0") as MeshInstance3D
	_ok("ceiling builder emits tile", ceiling_tile != null)
	_ok("ceiling builder default material applied", ceiling_tile != null and ceiling_tile.get_active_material(0) != null)

	var wall := WallBuilder.build(PackedStringArray(["wall"]), "", "north", 4.0, 4.0, 2.4)
	var wall_segment := wall.get_child(0) as MeshInstance3D
	_ok("wall builder emits segment", wall_segment != null)
	_ok("wall builder default material applied", wall_segment != null and wall_segment.get_active_material(0) != null)

	var door_conn := ConnectionDecl.new()
	door_conn.id = "test_door"
	door_conn.type = "door"
	door_conn.to_room = "foyer"
	_ok("connection schema defaults mechanism state empty", door_conn.mechanism_state.is_empty())
	_ok("connection schema defaults reveal state empty", door_conn.reveal_state.is_empty())
	var door := DoorBuilder.build(door_conn)
	_ok("door default threshold recipe", String(door.get_meta("resolved_threshold_surface", "")) == "recipe:surface/oak_header")
	_ok("door default panel recipe", String(door.get_meta("resolved_panel_surface", "")) == "recipe:surface/oak_dark")
	_ok("door frame stays procedural", door.get_node_or_null("DoorFrame/FittedModel") == null)
	_ok("door panel stays procedural", door.get_node_or_null("DoorHinge/DoorPanel/FittedModel") == null)
	_ok("door default presentation type", String((door.get_node("DoorArea") as Area3D).get_meta("presentation_type", "")) == "door_threshold")
	_ok("door default mechanism type", String((door.get_node("DoorArea") as Area3D).get_meta("mechanism_type", "")) == "swing")
	_ok("door default mechanism state", String((door.get_node("DoorArea") as Area3D).get_meta("mechanism_state", "")) == "idle")
	_ok("door default reveal state", String((door.get_node("DoorArea") as Area3D).get_meta("reveal_state", "")) == "visible")

	var gate_conn := ConnectionDecl.new()
	gate_conn.id = "test_gate"
	gate_conn.type = "gate"
	gate_conn.to_room = "drive_lower"
	var gate := DoorBuilder.build(gate_conn)
	_ok("gate default threshold recipe", String(gate.get_meta("resolved_threshold_surface", "")) == "recipe:surface/brick_masonry")
	_ok("gate default panel recipe", String(gate.get_meta("resolved_panel_surface", "")) == "recipe:surface/wrought_iron")
	_ok("gate default presentation type", String((gate.get_node("DoorArea") as Area3D).get_meta("presentation_type", "")) == "gate_threshold")
	_ok("gate default mechanism type", String((gate.get_node("DoorArea") as Area3D).get_meta("mechanism_type", "")) == "swing")

	var hidden_conn := ConnectionDecl.new()
	hidden_conn.id = "test_hidden_door"
	hidden_conn.type = "hidden_door"
	hidden_conn.to_room = "hidden_chamber"
	var hidden_door := DoorBuilder.build(hidden_conn)
	_ok("hidden door default presentation type", String((hidden_door.get_node("DoorArea") as Area3D).get_meta("presentation_type", "")) == "secret_panel")
	_ok("hidden door default mechanism type", String((hidden_door.get_node("DoorArea") as Area3D).get_meta("mechanism_type", "")) == "slide")
	_ok("hidden door default mechanism state", String((hidden_door.get_node("DoorArea") as Area3D).get_meta("mechanism_state", "")) == "concealed")
	_ok("hidden door default reveal state", String((hidden_door.get_node("DoorArea") as Area3D).get_meta("reveal_state", "")) == "concealed")

	var hidden_threshold := ConnectionAssembly.build(hidden_conn)
	_ok("hidden threshold default concealment kind", String(hidden_threshold.get_meta("resolved_concealment_kind", "")) == "procedural_secret_panel")
	_ok("hidden threshold concealment stays procedural", hidden_threshold.get_node_or_null("SecretPanelMask/Panel") != null)

	var window := WindowBuilder.build("window", "")
	_ok("window default recipe", String(window.get_meta("resolved_window_surface", "")) == "recipe:surface/oak_dark")
	_ok("window default frame stays procedural", window.get_node_or_null("WindowFrame/FittedModel") == null)

	var stairs_conn := ConnectionDecl.new()
	stairs_conn.id = "test_stairs"
	stairs_conn.type = "stairs"
	stairs_conn.to_room = "upper_hallway"
	var stairs := StairsBuilder.build(stairs_conn)
	_ok("stairs default tread recipe", String(stairs.get_meta("resolved_stair_tread_surface", "")) == "recipe:surface/oak_board")
	_ok("stairs default structure recipe", String(stairs.get_meta("resolved_stair_structure_surface", "")) == "recipe:surface/oak_header")
	_ok("stairs default rail recipe", String(stairs.get_meta("resolved_stair_rail_surface", "")) == "recipe:surface/oak_dark")
	_ok("stairs default presentation type", String((stairs.get_node("StairsArea") as Area3D).get_meta("presentation_type", "")) == "stairs_threshold")
	_ok("stairs default mechanism state", String((stairs.get_node("StairsArea") as Area3D).get_meta("mechanism_state", "")) == "idle")
	_ok("stairs default reveal state", String((stairs.get_node("StairsArea") as Area3D).get_meta("reveal_state", "")) == "visible")
	_ok("stairs default newel stays procedural", stairs.get_node_or_null("StairVisual/Newel/FittedModel") == null)

	var trapdoor_conn := ConnectionDecl.new()
	trapdoor_conn.id = "test_trapdoor"
	trapdoor_conn.type = "trapdoor"
	trapdoor_conn.to_room = "storage_basement"
	var trapdoor := TrapdoorBuilder.build(trapdoor_conn)
	_ok("trapdoor default threshold recipe", String(trapdoor.get_meta("resolved_threshold_surface", "")) == "recipe:surface/oak_header")
	_ok("trapdoor default panel recipe", String(trapdoor.get_meta("resolved_panel_surface", "")) == "recipe:surface/oak_dark")
	_ok("trapdoor default presentation type", String((trapdoor.get_node("TrapdoorArea") as Area3D).get_meta("presentation_type", "")) == "trapdoor_hatch")
	_ok("trapdoor default mechanism type", String((trapdoor.get_node("TrapdoorArea") as Area3D).get_meta("mechanism_type", "")) == "lift")
	_ok("trapdoor default mechanism state", String((trapdoor.get_node("TrapdoorArea") as Area3D).get_meta("mechanism_state", "")) == "idle")
	_ok("trapdoor default reveal state", String((trapdoor.get_node("TrapdoorArea") as Area3D).get_meta("reveal_state", "")) == "visible")

	var ladder_conn := ConnectionDecl.new()
	ladder_conn.id = "test_ladder"
	ladder_conn.type = "ladder"
	ladder_conn.to_room = "attic_storage"
	var ladder := LadderBuilder.build(ladder_conn)
	_ok("ladder default rail recipe", String(ladder.get_meta("resolved_ladder_rail_surface", "")) == "recipe:surface/chain_iron")
	_ok("ladder default rung recipe", String(ladder.get_meta("resolved_ladder_rung_surface", "")) == "recipe:surface/chain_iron")
	_ok("ladder default presentation type", String((ladder.get_node("LadderArea") as Area3D).get_meta("presentation_type", "")) == "ladder_drop")
	_ok("ladder default mechanism type", String((ladder.get_node("LadderArea") as Area3D).get_meta("mechanism_type", "")) == "drop")
	_ok("ladder default mechanism state", String((ladder.get_node("LadderArea") as Area3D).get_meta("mechanism_state", "")) == "idle")
	_ok("ladder default reveal state", String((ladder.get_node("LadderArea") as Area3D).get_meta("reveal_state", "")) == "visible")

	var legacy_single := DoorSingleScript.new()
	legacy_single._ready()
	var single_panel := legacy_single.get_node_or_null("Pivot/Body/Panel") as MeshInstance3D
	_ok("procedural single door builds panel", single_panel != null)
	_ok("procedural single door recipe material applied", single_panel != null and single_panel.get_active_material(0) != null)

	var legacy_double := DoorDoubleScript.new()
	legacy_double._ready()
	var double_left := legacy_double.get_node_or_null("HingeL/Panel") as MeshInstance3D
	var double_post := legacy_double.get_node_or_null("PostL") as MeshInstance3D
	_ok("procedural double door builds panel", double_left != null)
	_ok("procedural double door panel material applied", double_left != null and double_left.get_active_material(0) != null)
	_ok("procedural double door frame material applied", double_post != null and double_post.get_active_material(0) != null)

	var world := load("res://declarations/world.tres")
	var assembler := RoomAssembler.new(world)
	var procedural_window_decl := PropDecl.new()
	procedural_window_decl.id = "compat_window"
	procedural_window_decl.model = "res://assets/shared/structure/window_clean.glb"
	procedural_window_decl.scale = 1.0
	var procedural_window := assembler._build_procedural_prop(procedural_window_decl)
	_ok("procedural window prop replaces imported window model", procedural_window != null and procedural_window.get_node_or_null("WindowFrame") != null)

	var procedural_ray_decl := PropDecl.new()
	procedural_ray_decl.id = "compat_window_ray"
	procedural_ray_decl.model = "res://assets/shared/structure/window_ray.glb"
	procedural_ray_decl.scale = 1.0
	var procedural_ray := assembler._build_procedural_prop(procedural_ray_decl)
	_ok("procedural window ray prop replaces imported ray model", procedural_ray != null and procedural_ray.get_node_or_null("WindowRay") != null)

	var procedural_stairs_decl := PropDecl.new()
	procedural_stairs_decl.id = "compat_stairs"
	procedural_stairs_decl.model = "res://assets/shared/structure/stairs0.glb"
	procedural_stairs_decl.scale = 1.0
	var procedural_stairs := assembler._build_procedural_prop(procedural_stairs_decl)
	_ok("procedural stair prop replaces imported stair model", procedural_stairs != null and procedural_stairs.get_node_or_null("Step_0") != null)

	var procedural_banister_decl := PropDecl.new()
	procedural_banister_decl.id = "compat_banister"
	procedural_banister_decl.model = "res://assets/shared/structure/stairbanister.glb"
	procedural_banister_decl.scale = 1.0
	var procedural_banister := assembler._build_procedural_prop(procedural_banister_decl)
	_ok("procedural banister prop replaces imported banister model", procedural_banister != null and procedural_banister.get_node_or_null("Rail") != null)

	var procedural_newel_decl := PropDecl.new()
	procedural_newel_decl.id = "compat_newel"
	procedural_newel_decl.model = "res://assets/shared/structure/banisterbase.glb"
	procedural_newel_decl.scale = 1.0
	var procedural_newel := assembler._build_procedural_prop(procedural_newel_decl)
	_ok("procedural newel prop replaces imported base model", procedural_newel != null and procedural_newel.get_node_or_null("Shaft") != null)

	var procedural_slab_decl := PropDecl.new()
	procedural_slab_decl.id = "compat_slab"
	procedural_slab_decl.model = "res://assets/shared/structure/floor3.glb"
	procedural_slab_decl.scale = 1.0
	var procedural_slab := assembler._build_procedural_prop(procedural_slab_decl)
	_ok("procedural slab prop replaces imported floor stone model", procedural_slab != null and procedural_slab.get_node_or_null("Top") != null)

	var procedural_plinth_decl := PropDecl.new()
	procedural_plinth_decl.id = "compat_plinth"
	procedural_plinth_decl.model = "res://assets/shared/structure/pillar0_002.glb"
	procedural_plinth_decl.scale = 1.0
	var procedural_plinth := assembler._build_procedural_prop(procedural_plinth_decl)
	_ok("procedural plinth prop replaces imported pedestal model", procedural_plinth != null and procedural_plinth.get_node_or_null("Body") != null)

	var procedural_pillar_decl := PropDecl.new()
	procedural_pillar_decl.id = "compat_round_pillar"
	procedural_pillar_decl.model = "res://assets/shared/structure/pillar1.glb"
	procedural_pillar_decl.scale = 1.0
	var procedural_pillar := assembler._build_procedural_prop(procedural_pillar_decl)
	_ok("procedural pillar prop replaces imported round pillar model", procedural_pillar != null and procedural_pillar.get_node_or_null("Shaft") != null)

	var procedural_facade_door_decl := PropDecl.new()
	procedural_facade_door_decl.id = "compat_facade_door"
	procedural_facade_door_decl.model = "res://assets/shared/structure/door1.glb"
	procedural_facade_door_decl.scale = 1.0
	var procedural_facade_door := assembler._build_procedural_prop(procedural_facade_door_decl)
	_ok("procedural facade door prop replaces imported shared door model", procedural_facade_door != null and procedural_facade_door.get_node_or_null("DoorLeaf") != null)

	var manor_wall_decl := PropDecl.new()
	manor_wall_decl.id = "compat_manor_wall"
	manor_wall_decl.model = "res://assets/mansion_psx/models/SM_Door_Wall.glb"
	var manor_wall := assembler._build_procedural_prop(manor_wall_decl)
	_ok("procedural manor wall panel replaces imported facade wall model", manor_wall != null and manor_wall.get_node_or_null("Backing") != null)

	var manor_window_panel_decl := PropDecl.new()
	manor_window_panel_decl.id = "compat_manor_window"
	manor_window_panel_decl.model = "res://assets/mansion_psx/models/SM_Window_Wall.glb"
	var manor_window_panel := assembler._build_procedural_prop(manor_window_panel_decl)
	_ok("procedural manor window panel replaces imported window wall model", manor_window_panel != null and manor_window_panel.get_node_or_null("Sill") != null)

	var manor_wing_decl := PropDecl.new()
	manor_wing_decl.id = "compat_manor_wing"
	manor_wing_decl.model = "res://assets/mansion_psx/models/SM_Big_Wall.glb"
	var manor_wing := assembler._build_procedural_prop(manor_wing_decl)
	_ok("procedural manor wing replaces imported big wall model", manor_wing != null and manor_wing.get_node_or_null("Wing") != null)

	var manor_column_decl := PropDecl.new()
	manor_column_decl.id = "compat_manor_column"
	manor_column_decl.model = "res://assets/mansion_psx/models/SM_Wall_Column.glb"
	var manor_column := assembler._build_procedural_prop(manor_column_decl)
	_ok("procedural manor column replaces imported wall column model", manor_column != null and manor_column.get_node_or_null("Shaft") != null)

	var doorway_trim_decl := PropDecl.new()
	doorway_trim_decl.id = "compat_doorway_trim"
	doorway_trim_decl.model = "res://assets/mansion_psx/models/SM_Door_Frame.glb"
	var doorway_trim := assembler._build_procedural_prop(doorway_trim_decl)
	_ok("procedural doorway trim replaces imported door frame model", doorway_trim != null and doorway_trim.get_node_or_null("Lintel") != null)

	var manor_roof_decl := PropDecl.new()
	manor_roof_decl.id = "compat_manor_roof"
	manor_roof_decl.model = "res://assets/mansion_psx/models/SM_Roof.glb"
	var manor_roof := assembler._build_procedural_prop(manor_roof_decl)
	_ok("procedural manor roof replaces imported roof panel model", manor_roof != null and manor_roof.get_node_or_null("RoofPlane") != null)

	var manor_roof_molding_decl := PropDecl.new()
	manor_roof_molding_decl.id = "compat_manor_roof_molding"
	manor_roof_molding_decl.model = "res://assets/mansion_psx/models/SM_Big_Roof_Molding.glb"
	var manor_roof_molding := assembler._build_procedural_prop(manor_roof_molding_decl)
	_ok("procedural manor roof molding replaces imported roof molding model", manor_roof_molding != null and manor_roof_molding.get_node_or_null("Molding") != null)

	var manor_frieze_decl := PropDecl.new()
	manor_frieze_decl.id = "compat_manor_frieze"
	manor_frieze_decl.model = "res://assets/mansion_psx/models/SM_Big_Wall_Molding.glb"
	var manor_frieze := assembler._build_procedural_prop(manor_frieze_decl)
	_ok("procedural manor frieze replaces imported wall molding model", manor_frieze != null and manor_frieze.get_node_or_null("Frieze") != null)

	var front_gate_sign_decl := PropDecl.new()
	front_gate_sign_decl.id = "compat_front_gate_sign"
	front_gate_sign_decl.substrate_prop_kind = "front_gate_sign"
	var front_gate_sign := assembler._build_procedural_prop(front_gate_sign_decl)
	_ok("substrate front gate sign builds from shared substrate kind", front_gate_sign != null)

	var greenhouse_shell_decl := PropDecl.new()
	greenhouse_shell_decl.id = "compat_greenhouse_shell"
	greenhouse_shell_decl.substrate_prop_kind = "greenhouse_shell"
	var greenhouse_shell := assembler._build_procedural_prop(greenhouse_shell_decl)
	_ok("substrate greenhouse shell builds from shared substrate kind", greenhouse_shell != null)

	var greenhouse_lantern_decl := PropDecl.new()
	greenhouse_lantern_decl.id = "compat_greenhouse_lantern"
	greenhouse_lantern_decl.substrate_prop_kind = "greenhouse_lantern"
	var greenhouse_lantern := assembler._build_procedural_prop(greenhouse_lantern_decl)
	_ok("substrate greenhouse lantern builds from shared substrate kind", greenhouse_lantern != null)

	var gate_post_decl := PropDecl.new()
	gate_post_decl.id = "compat_gate_post"
	gate_post_decl.substrate_prop_kind = "gate_post"
	var gate_post := assembler._build_procedural_prop(gate_post_decl)
	_ok("substrate gate post builds from shared substrate kind", gate_post != null)

	var gate_post_stone_decl := PropDecl.new()
	gate_post_stone_decl.id = "compat_gate_post_stone"
	gate_post_stone_decl.substrate_prop_kind = "gate_post_stone"
	var gate_post_stone := assembler._build_procedural_prop(gate_post_stone_decl)
	_ok("substrate stone gate post builds from shared substrate kind", gate_post_stone != null)

	var boundary_wall_decl := PropDecl.new()
	boundary_wall_decl.id = "compat_boundary_wall"
	boundary_wall_decl.substrate_prop_kind = "boundary_wall"
	var boundary_wall := assembler._build_procedural_prop(boundary_wall_decl)
	_ok("substrate boundary wall builds from shared substrate kind", boundary_wall != null)

	var iron_gate_closed_decl := PropDecl.new()
	iron_gate_closed_decl.id = "compat_iron_gate_closed"
	iron_gate_closed_decl.substrate_prop_kind = "iron_gate_closed"
	var iron_gate_closed := assembler._build_procedural_prop(iron_gate_closed_decl)
	_ok("substrate closed iron gate builds from shared substrate kind", iron_gate_closed != null)

	var iron_gate_open_decl := PropDecl.new()
	iron_gate_open_decl.id = "compat_iron_gate_open"
	iron_gate_open_decl.substrate_prop_kind = "iron_gate_open"
	var iron_gate_open := assembler._build_procedural_prop(iron_gate_open_decl)
	_ok("substrate open iron gate builds from shared substrate kind", iron_gate_open != null)

	var fence_run_decl := PropDecl.new()
	fence_run_decl.id = "compat_fence_run"
	fence_run_decl.substrate_prop_kind = "fence_run"
	var fence_run := assembler._build_procedural_prop(fence_run_decl)
	_ok("substrate fence run builds from shared substrate kind", fence_run != null)

	var hedgerow_decl := PropDecl.new()
	hedgerow_decl.id = "compat_hedgerow"
	hedgerow_decl.substrate_prop_kind = "hedgerow"
	var hedgerow := assembler._build_procedural_prop(hedgerow_decl)
	_ok("substrate hedgerow builds from shared substrate kind", hedgerow != null)

	var carriage_road_decl := PropDecl.new()
	carriage_road_decl.id = "compat_carriage_road"
	carriage_road_decl.substrate_prop_kind = "carriage_road"
	var carriage_road := assembler._build_procedural_prop(carriage_road_decl)
	_ok("substrate carriage road builds from shared substrate kind", carriage_road != null)

	var outward_road_decl := PropDecl.new()
	outward_road_decl.id = "compat_outward_road"
	outward_road_decl.substrate_prop_kind = "outward_road"
	var outward_road := assembler._build_procedural_prop(outward_road_decl)
	_ok("substrate outward road builds from shared substrate kind", outward_road != null)

	var mansion_facade_decl := PropDecl.new()
	mansion_facade_decl.id = "compat_mansion_facade"
	mansion_facade_decl.substrate_prop_kind = "mansion_facade"
	var mansion_facade := assembler._build_procedural_prop(mansion_facade_decl)
	_ok("substrate mansion facade builds from shared substrate kind", mansion_facade != null)

	var entry_portico_decl := PropDecl.new()
	entry_portico_decl.id = "compat_entry_portico"
	entry_portico_decl.substrate_prop_kind = "entry_portico"
	var entry_portico := assembler._build_procedural_prop(entry_portico_decl)
	_ok("substrate entry portico builds from shared substrate kind", entry_portico != null)

	var front_door_assembly_decl := PropDecl.new()
	front_door_assembly_decl.id = "compat_front_door_assembly"
	front_door_assembly_decl.substrate_prop_kind = "front_door_assembly"
	var front_door_assembly := assembler._build_procedural_prop(front_door_assembly_decl)
	_ok("substrate front door assembly builds from shared substrate kind", front_door_assembly != null)

	var forecourt_steps_decl := PropDecl.new()
	forecourt_steps_decl.id = "compat_forecourt_steps"
	forecourt_steps_decl.substrate_prop_kind = "forecourt_steps"
	var forecourt_steps := assembler._build_procedural_prop(forecourt_steps_decl)
	_ok("substrate forecourt steps build from shared substrate kind", forecourt_steps != null)

	var starfield_decl := PropDecl.new()
	starfield_decl.id = "compat_starfield"
	starfield_decl.substrate_prop_kind = "starfield"
	var starfield := assembler._build_procedural_prop(starfield_decl)
	_ok("substrate starfield builds from shared substrate kind", starfield != null)

	var front_gate_lamp_decl := PropDecl.new()
	front_gate_lamp_decl.id = "compat_front_gate_lamp"
	front_gate_lamp_decl.substrate_prop_kind = "front_gate_lamp"
	var front_gate_lamp := assembler._build_procedural_prop(front_gate_lamp_decl)
	_ok("substrate front-gate lamp builds from shared substrate kind", front_gate_lamp != null)

	var front_gate_tree_decl := PropDecl.new()
	front_gate_tree_decl.id = "compat_front_gate_tree_01"
	front_gate_tree_decl.substrate_prop_kind = "front_gate_tree_01"
	var front_gate_tree := assembler._build_procedural_prop(front_gate_tree_decl)
	_ok("substrate front-gate winter tree builds from shared substrate kind", front_gate_tree != null)

	var front_gate_bush_decl := PropDecl.new()
	front_gate_bush_decl.id = "compat_front_gate_bush_01"
	front_gate_bush_decl.substrate_prop_kind = "front_gate_bush_01"
	var front_gate_bush := assembler._build_procedural_prop(front_gate_bush_decl)
	_ok("substrate front-gate winter bush builds from shared substrate kind", front_gate_bush != null)

	var front_gate_rocks_decl := PropDecl.new()
	front_gate_rocks_decl.id = "compat_front_gate_rocks"
	front_gate_rocks_decl.substrate_prop_kind = "front_gate_rocks"
	var front_gate_rocks := assembler._build_procedural_prop(front_gate_rocks_decl)
	_ok("substrate front-gate rocks build from shared substrate kind", front_gate_rocks != null)

	var iron_gate_leaf_decl := PropDecl.new()
	iron_gate_leaf_decl.id = "compat_iron_gate_leaf_angled"
	iron_gate_leaf_decl.substrate_prop_kind = "iron_gate_leaf_angled"
	var iron_gate_leaf := assembler._build_procedural_prop(iron_gate_leaf_decl)
	_ok("substrate angled iron gate leaf builds from shared substrate kind", iron_gate_leaf != null)

	var boundary_pole_decl := PropDecl.new()
	boundary_pole_decl.id = "compat_front_gate_boundary_pole"
	boundary_pole_decl.substrate_prop_kind = "front_gate_boundary_pole"
	var boundary_pole := assembler._build_procedural_prop(boundary_pole_decl)
	_ok("substrate front-gate boundary pole builds from shared substrate kind", boundary_pole != null)

	var chimney_left_decl := PropDecl.new()
	chimney_left_decl.id = "compat_front_gate_chimney_left"
	chimney_left_decl.substrate_prop_kind = "front_gate_chimney_left"
	var chimney_left := assembler._build_procedural_prop(chimney_left_decl)
	_ok("substrate front-gate left chimney builds from shared substrate kind", chimney_left != null)

	var chimney_right_decl := PropDecl.new()
	chimney_right_decl.id = "compat_front_gate_chimney_right"
	chimney_right_decl.substrate_prop_kind = "front_gate_chimney_right"
	var chimney_right := assembler._build_procedural_prop(chimney_right_decl)
	_ok("substrate front-gate right chimney builds from shared substrate kind", chimney_right != null)

	var crypt_wall_capped_decl := PropDecl.new()
	crypt_wall_capped_decl.id = "compat_family_crypt_wall_capped"
	crypt_wall_capped_decl.substrate_prop_kind = "family_crypt_wall_capped"
	var crypt_wall_capped := assembler._build_procedural_prop(crypt_wall_capped_decl)
	_ok("substrate family-crypt capped wall builds from shared substrate kind", crypt_wall_capped != null)

	var crypt_wall_decl := PropDecl.new()
	crypt_wall_decl.id = "compat_family_crypt_wall"
	crypt_wall_decl.substrate_prop_kind = "family_crypt_wall"
	var crypt_wall := assembler._build_procedural_prop(crypt_wall_decl)
	_ok("substrate family-crypt wall builds from shared substrate kind", crypt_wall != null)

	var crypt_fence_decl := PropDecl.new()
	crypt_fence_decl.id = "compat_family_crypt_fence"
	crypt_fence_decl.substrate_prop_kind = "family_crypt_fence_run"
	var crypt_fence := assembler._build_procedural_prop(crypt_fence_decl)
	_ok("substrate family-crypt fence run builds from shared substrate kind", crypt_fence != null)

	var crypt_grave_decl := PropDecl.new()
	crypt_grave_decl.id = "compat_family_crypt_grave_marker"
	crypt_grave_decl.substrate_prop_kind = "family_crypt_grave_marker"
	var crypt_grave := assembler._build_procedural_prop(crypt_grave_decl)
	_ok("substrate family-crypt grave marker builds from shared substrate kind", crypt_grave != null)

	var crypt_debris_left_decl := PropDecl.new()
	crypt_debris_left_decl.id = "compat_family_crypt_debris_left"
	crypt_debris_left_decl.substrate_prop_kind = "family_crypt_debris_left"
	var crypt_debris_left := assembler._build_procedural_prop(crypt_debris_left_decl)
	_ok("substrate family-crypt left debris builds from shared substrate kind", crypt_debris_left != null)

	var crypt_debris_right_decl := PropDecl.new()
	crypt_debris_right_decl.id = "compat_family_crypt_debris_right"
	crypt_debris_right_decl.substrate_prop_kind = "family_crypt_debris_right"
	var crypt_debris_right := assembler._build_procedural_prop(crypt_debris_right_decl)
	_ok("substrate family-crypt right debris builds from shared substrate kind", crypt_debris_right != null)

	var crypt_bottle_decl := PropDecl.new()
	crypt_bottle_decl.id = "compat_family_crypt_bottle"
	crypt_bottle_decl.substrate_prop_kind = "family_crypt_bottle"
	var crypt_bottle := assembler._build_procedural_prop(crypt_bottle_decl)
	_ok("substrate family-crypt bottle builds from shared substrate kind", crypt_bottle != null)

	var crypt_bones_decl := PropDecl.new()
	crypt_bones_decl.id = "compat_family_crypt_bones"
	crypt_bones_decl.substrate_prop_kind = "family_crypt_bones"
	var crypt_bones := assembler._build_procedural_prop(crypt_bones_decl)
	_ok("substrate family-crypt bones build from shared substrate kind", crypt_bones != null)

	var garden_fountain_decl := PropDecl.new()
	garden_fountain_decl.id = "compat_garden_fountain_base"
	garden_fountain_decl.substrate_prop_kind = "garden_fountain_base"
	var garden_fountain := assembler._build_procedural_prop(garden_fountain_decl)
	_ok("substrate garden fountain base builds from shared substrate kind", garden_fountain != null)

	var garden_water_decl := PropDecl.new()
	garden_water_decl.id = "compat_garden_fountain_water"
	garden_water_decl.substrate_prop_kind = "garden_fountain_water"
	var garden_water := assembler._build_procedural_prop(garden_water_decl)
	_ok("substrate garden fountain water builds from shared substrate kind", garden_water != null)

	var garden_gazebo_decl := PropDecl.new()
	garden_gazebo_decl.id = "compat_garden_gazebo_shell"
	garden_gazebo_decl.substrate_prop_kind = "garden_gazebo_shell"
	var garden_gazebo := assembler._build_procedural_prop(garden_gazebo_decl)
	_ok("substrate garden gazebo shell builds from shared substrate kind", garden_gazebo != null)

	var garden_path_decl := PropDecl.new()
	garden_path_decl.id = "compat_garden_path_center"
	garden_path_decl.substrate_prop_kind = "garden_path_center"
	var garden_path := assembler._build_procedural_prop(garden_path_decl)
	_ok("substrate garden path segment builds from shared substrate kind", garden_path != null)

	var garden_wall_decl := PropDecl.new()
	garden_wall_decl.id = "compat_garden_north_wall_w"
	garden_wall_decl.substrate_prop_kind = "garden_north_wall_w"
	var garden_wall := assembler._build_procedural_prop(garden_wall_decl)
	_ok("substrate garden wall segment builds from shared substrate kind", garden_wall != null)

	var garden_corner_decl := PropDecl.new()
	garden_corner_decl.id = "compat_garden_corner_ne"
	garden_corner_decl.substrate_prop_kind = "garden_corner_ne"
	var garden_corner := assembler._build_procedural_prop(garden_corner_decl)
	_ok("substrate garden corner builds from shared substrate kind", garden_corner != null)

	var garden_column_decl := PropDecl.new()
	garden_column_decl.id = "compat_garden_column_l"
	garden_column_decl.substrate_prop_kind = "garden_column_l"
	var garden_column := assembler._build_procedural_prop(garden_column_decl)
	_ok("substrate garden column builds from shared substrate kind", garden_column != null)

	var garden_vase_decl := PropDecl.new()
	garden_vase_decl.id = "compat_garden_vase_l"
	garden_vase_decl.substrate_prop_kind = "garden_vase_l"
	var garden_vase := assembler._build_procedural_prop(garden_vase_decl)
	_ok("substrate garden vase builds from shared substrate kind", garden_vase != null)

	var garden_bench_decl := PropDecl.new()
	garden_bench_decl.id = "compat_garden_bench_west"
	garden_bench_decl.substrate_prop_kind = "garden_bench_west"
	var garden_bench := assembler._build_procedural_prop(garden_bench_decl)
	_ok("substrate garden west bench builds from shared substrate kind", garden_bench != null)

	var garden_gazebo_table_decl := PropDecl.new()
	garden_gazebo_table_decl.id = "compat_garden_gazebo_table"
	garden_gazebo_table_decl.substrate_prop_kind = "garden_gazebo_table"
	var garden_gazebo_table := assembler._build_procedural_prop(garden_gazebo_table_decl)
	_ok("substrate garden gazebo table builds from shared substrate kind", garden_gazebo_table != null)

	var garden_bench_north_decl := PropDecl.new()
	garden_bench_north_decl.id = "compat_garden_bench_north"
	garden_bench_north_decl.substrate_prop_kind = "garden_bench_north"
	var garden_bench_north := assembler._build_procedural_prop(garden_bench_north_decl)
	_ok("substrate garden north bench builds from shared substrate kind", garden_bench_north != null)

	var garden_beds_west_decl := PropDecl.new()
	garden_beds_west_decl.id = "compat_garden_beds_west"
	garden_beds_west_decl.substrate_prop_kind = "garden_beds_west"
	var garden_beds_west := assembler._build_procedural_prop(garden_beds_west_decl)
	_ok("substrate garden west flowerbed builds from shared substrate kind", garden_beds_west != null)

	var garden_beds_east_decl := PropDecl.new()
	garden_beds_east_decl.id = "compat_garden_beds_east"
	garden_beds_east_decl.substrate_prop_kind = "garden_beds_east"
	var garden_beds_east := assembler._build_procedural_prop(garden_beds_east_decl)
	_ok("substrate garden east flowerbed builds from shared substrate kind", garden_beds_east != null)

	var chapel_wall_fancy_decl := PropDecl.new()
	chapel_wall_fancy_decl.id = "compat_chapel_wall_fancy"
	chapel_wall_fancy_decl.substrate_prop_kind = "chapel_wall_column_fancy"
	var chapel_wall_fancy := assembler._build_procedural_prop(chapel_wall_fancy_decl)
	_ok("substrate chapel fancy wall column builds from shared substrate kind", chapel_wall_fancy != null)

	var chapel_wall_center_decl := PropDecl.new()
	chapel_wall_center_decl.id = "compat_chapel_wall_center"
	chapel_wall_center_decl.substrate_prop_kind = "chapel_wall_center"
	var chapel_wall_center := assembler._build_procedural_prop(chapel_wall_center_decl)
	_ok("substrate chapel wall center builds from shared substrate kind", chapel_wall_center != null)

	var chapel_wall_column_decl := PropDecl.new()
	chapel_wall_column_decl.id = "compat_chapel_wall_column"
	chapel_wall_column_decl.substrate_prop_kind = "chapel_wall_column"
	var chapel_wall_column := assembler._build_procedural_prop(chapel_wall_column_decl)
	_ok("substrate chapel wall column builds from shared substrate kind", chapel_wall_column != null)

	var chapel_bucket_decl := PropDecl.new()
	chapel_bucket_decl.id = "compat_chapel_bucket"
	chapel_bucket_decl.substrate_prop_kind = "chapel_bucket"
	var chapel_bucket := assembler._build_procedural_prop(chapel_bucket_decl)
	_ok("substrate chapel bucket builds from shared substrate kind", chapel_bucket != null)

	var chapel_bottle_decl := PropDecl.new()
	chapel_bottle_decl.id = "compat_chapel_bottle"
	chapel_bottle_decl.substrate_prop_kind = "chapel_bottle"
	var chapel_bottle := assembler._build_procedural_prop(chapel_bottle_decl)
	_ok("substrate chapel bottle builds from shared substrate kind", chapel_bottle != null)

	var chapel_dead_lamp_decl := PropDecl.new()
	chapel_dead_lamp_decl.id = "compat_chapel_dead_lamp"
	chapel_dead_lamp_decl.substrate_prop_kind = "chapel_dead_lamp"
	var chapel_dead_lamp := assembler._build_procedural_prop(chapel_dead_lamp_decl)
	_ok("substrate chapel dead lamp builds from shared substrate kind", chapel_dead_lamp != null)

	var chapel_bones_decl := PropDecl.new()
	chapel_bones_decl.id = "compat_chapel_bones"
	chapel_bones_decl.substrate_prop_kind = "chapel_bones"
	var chapel_bones := assembler._build_procedural_prop(chapel_bones_decl)
	_ok("substrate chapel bones build from shared substrate kind", chapel_bones != null)

	var carriage_house_mattress_decl := PropDecl.new()
	carriage_house_mattress_decl.id = "compat_carriage_house_mattress"
	carriage_house_mattress_decl.substrate_prop_kind = "carriage_house_mattress"
	var carriage_house_mattress := assembler._build_procedural_prop(carriage_house_mattress_decl)
	_ok("substrate carriage-house mattress builds from shared substrate kind", carriage_house_mattress != null)

	var carriage_house_shed_decl := PropDecl.new()
	carriage_house_shed_decl.id = "compat_carriage_house_shed_a"
	carriage_house_shed_decl.substrate_prop_kind = "carriage_house_shed_a"
	var carriage_house_shed := assembler._build_procedural_prop(carriage_house_shed_decl)
	_ok("substrate carriage-house shed shell builds from shared substrate kind", carriage_house_shed != null)

	var carriage_house_board_decl := PropDecl.new()
	carriage_house_board_decl.id = "compat_carriage_house_board_1"
	carriage_house_board_decl.substrate_prop_kind = "carriage_house_board_1"
	var carriage_house_board := assembler._build_procedural_prop(carriage_house_board_decl)
	_ok("substrate carriage-house board builds from shared substrate kind", carriage_house_board != null)

	var carriage_house_shovel_decl := PropDecl.new()
	carriage_house_shovel_decl.id = "compat_carriage_house_shovel"
	carriage_house_shovel_decl.substrate_prop_kind = "carriage_house_shovel"
	var carriage_house_shovel := assembler._build_procedural_prop(carriage_house_shovel_decl)
	_ok("substrate carriage-house shovel builds from shared substrate kind", carriage_house_shovel != null)

	var carriage_house_luggage_decl := PropDecl.new()
	carriage_house_luggage_decl.id = "compat_carriage_house_luggage"
	carriage_house_luggage_decl.substrate_prop_kind = "carriage_house_luggage"
	var carriage_house_luggage := assembler._build_procedural_prop(carriage_house_luggage_decl)
	_ok("substrate carriage-house luggage builds from shared substrate kind", carriage_house_luggage != null)

	var carriage_house_dead_lamp_decl := PropDecl.new()
	carriage_house_dead_lamp_decl.id = "compat_carriage_house_dead_lamp"
	carriage_house_dead_lamp_decl.substrate_prop_kind = "carriage_house_dead_lamp"
	var carriage_house_dead_lamp := assembler._build_procedural_prop(carriage_house_dead_lamp_decl)
	_ok("substrate carriage-house dead lamp builds from shared substrate kind", carriage_house_dead_lamp != null)

	var candle_holder_decl := PropDecl.new()
	candle_holder_decl.id = "compat_candle_holder_fixture"
	candle_holder_decl.substrate_prop_kind = "candle_holder_fixture"
	var candle_holder_fixture := assembler._build_procedural_prop(candle_holder_decl)
	_ok("substrate candle holder builds from shared substrate kind", candle_holder_fixture != null)

	var candle_single_decl := PropDecl.new()
	candle_single_decl.id = "compat_candle_single"
	candle_single_decl.substrate_prop_kind = "candle_single"
	var candle_single := assembler._build_procedural_prop(candle_single_decl)
	_ok("substrate single candle builds from shared substrate kind", candle_single != null)

	var picture_frame_decl := PropDecl.new()
	picture_frame_decl.id = "compat_picture_frame_blank_000"
	picture_frame_decl.substrate_prop_kind = "picture_frame_blank_000"
	var picture_frame_blank := assembler._build_procedural_prop(picture_frame_decl)
	_ok("substrate blank picture frame builds from shared substrate kind", picture_frame_blank != null)

	var picture_frame_004_decl := PropDecl.new()
	picture_frame_004_decl.id = "compat_picture_frame_blank_004"
	picture_frame_004_decl.substrate_prop_kind = "picture_frame_blank_004"
	var picture_frame_blank_004 := assembler._build_procedural_prop(picture_frame_004_decl)
	_ok("substrate portrait frame variant builds from shared substrate kind", picture_frame_blank_004 != null)

	var rug_0_decl := PropDecl.new()
	rug_0_decl.id = "compat_rug_0"
	rug_0_decl.substrate_prop_kind = "rug_0"
	var rug_0 := assembler._build_procedural_prop(rug_0_decl)
	_ok("substrate rug 0 builds from shared substrate kind", rug_0 != null)

	var rug_2_decl := PropDecl.new()
	rug_2_decl.id = "compat_rug_2"
	rug_2_decl.substrate_prop_kind = "rug_2"
	var rug_2 := assembler._build_procedural_prop(rug_2_decl)
	_ok("substrate rug 2 builds from shared substrate kind", rug_2 != null)

	var furniture_table_decl := PropDecl.new()
	furniture_table_decl.id = "compat_furniture_table"
	furniture_table_decl.substrate_prop_kind = "furniture_table"
	var furniture_table := assembler._build_procedural_prop(furniture_table_decl)
	_ok("substrate table builds from shared substrate kind", furniture_table != null)

	var furniture_study_desk_decl := PropDecl.new()
	furniture_study_desk_decl.id = "compat_furniture_study_desk"
	furniture_study_desk_decl.substrate_prop_kind = "furniture_study_desk"
	var furniture_study_desk := assembler._build_procedural_prop(furniture_study_desk_decl)
	_ok("substrate study desk builds from shared substrate kind", furniture_study_desk != null)

	var furniture_drawers_decl := PropDecl.new()
	furniture_drawers_decl.id = "compat_furniture_drawers"
	furniture_drawers_decl.substrate_prop_kind = "furniture_drawers"
	var furniture_drawers := assembler._build_procedural_prop(furniture_drawers_decl)
	_ok("substrate drawers build from shared substrate kind", furniture_drawers != null)

	var furniture_chair_decl := PropDecl.new()
	furniture_chair_decl.id = "compat_furniture_chair"
	furniture_chair_decl.substrate_prop_kind = "furniture_chair"
	var furniture_chair := assembler._build_procedural_prop(furniture_chair_decl)
	_ok("substrate chair builds from shared substrate kind", furniture_chair != null)

	var furniture_bookcase_decl := PropDecl.new()
	furniture_bookcase_decl.id = "compat_furniture_bookcase"
	furniture_bookcase_decl.substrate_prop_kind = "furniture_bookcase"
	var furniture_bookcase := assembler._build_procedural_prop(furniture_bookcase_decl)
	_ok("substrate bookcase builds from shared substrate kind", furniture_bookcase != null)

	var furniture_bed_decl := PropDecl.new()
	furniture_bed_decl.id = "compat_furniture_bed"
	furniture_bed_decl.substrate_prop_kind = "furniture_bed"
	var furniture_bed := assembler._build_procedural_prop(furniture_bed_decl)
	_ok("substrate bed builds from shared substrate kind", furniture_bed != null)

	var chandelier_fixture_decl := PropDecl.new()
	chandelier_fixture_decl.id = "compat_chandelier_fixture"
	chandelier_fixture_decl.substrate_prop_kind = "chandelier_fixture"
	var chandelier_fixture := assembler._build_procedural_prop(chandelier_fixture_decl)
	_ok("substrate chandelier builds from shared substrate kind", chandelier_fixture != null)

	var item_page_001_decl := PropDecl.new()
	item_page_001_decl.id = "compat_item_page_001"
	item_page_001_decl.substrate_prop_kind = "item_page_001"
	var item_page_001 := assembler._build_procedural_prop(item_page_001_decl)
	_ok("substrate page1 builds from shared substrate kind", item_page_001 != null)

	var item_page_002_decl := PropDecl.new()
	item_page_002_decl.id = "compat_item_page_002"
	item_page_002_decl.substrate_prop_kind = "item_page_002"
	var item_page_002 := assembler._build_procedural_prop(item_page_002_decl)
	_ok("substrate page2 builds from shared substrate kind", item_page_002 != null)

	var item_page_005_decl := PropDecl.new()
	item_page_005_decl.id = "compat_item_page_005"
	item_page_005_decl.substrate_prop_kind = "item_page_005"
	var item_page_005 := assembler._build_procedural_prop(item_page_005_decl)
	_ok("substrate page5 builds from shared substrate kind", item_page_005 != null)

	var item_openbook_000_decl := PropDecl.new()
	item_openbook_000_decl.id = "compat_item_openbook_000"
	item_openbook_000_decl.substrate_prop_kind = "item_openbook_000"
	var item_openbook_000 := assembler._build_procedural_prop(item_openbook_000_decl)
	_ok("substrate openbook0 builds from shared substrate kind", item_openbook_000 != null)

	var item_openbook_001_decl := PropDecl.new()
	item_openbook_001_decl.id = "compat_item_openbook_001"
	item_openbook_001_decl.substrate_prop_kind = "item_openbook_001"
	var item_openbook_001 := assembler._build_procedural_prop(item_openbook_001_decl)
	_ok("substrate openbook1 builds from shared substrate kind", item_openbook_001 != null)

	var greenhouse_plank_bench_decl := PropDecl.new()
	greenhouse_plank_bench_decl.id = "compat_greenhouse_plank_bench"
	greenhouse_plank_bench_decl.substrate_prop_kind = "greenhouse_plank_bench"
	var greenhouse_plank_bench := assembler._build_procedural_prop(greenhouse_plank_bench_decl)
	_ok("substrate greenhouse plank bench builds from shared substrate kind", greenhouse_plank_bench != null)

	var greenhouse_plank_shelf_decl := PropDecl.new()
	greenhouse_plank_shelf_decl.id = "compat_greenhouse_plank_shelf"
	greenhouse_plank_shelf_decl.substrate_prop_kind = "greenhouse_plank_shelf"
	var greenhouse_plank_shelf := assembler._build_procedural_prop(greenhouse_plank_shelf_decl)
	_ok("substrate greenhouse plank shelf builds from shared substrate kind", greenhouse_plank_shelf != null)

	var greenhouse_dead_row_decl := PropDecl.new()
	greenhouse_dead_row_decl.id = "compat_greenhouse_dead_row"
	greenhouse_dead_row_decl.substrate_prop_kind = "greenhouse_dead_row"
	var greenhouse_dead_row := assembler._build_procedural_prop(greenhouse_dead_row_decl)
	_ok("substrate greenhouse dead row builds from shared substrate kind", greenhouse_dead_row != null)

	var greenhouse_dead_end_decl := PropDecl.new()
	greenhouse_dead_end_decl.id = "compat_greenhouse_dead_end"
	greenhouse_dead_end_decl.substrate_prop_kind = "greenhouse_dead_end"
	var greenhouse_dead_end := assembler._build_procedural_prop(greenhouse_dead_end_decl)
	_ok("substrate greenhouse dead end builds from shared substrate kind", greenhouse_dead_end != null)

	var greenhouse_tall_dead_decl := PropDecl.new()
	greenhouse_tall_dead_decl.id = "compat_greenhouse_tall_dead"
	greenhouse_tall_dead_decl.substrate_prop_kind = "greenhouse_tall_dead"
	var greenhouse_tall_dead := assembler._build_procedural_prop(greenhouse_tall_dead_decl)
	_ok("substrate greenhouse tall dead growth builds from shared substrate kind", greenhouse_tall_dead != null)

	var greenhouse_winter_growth_decl := PropDecl.new()
	greenhouse_winter_growth_decl.id = "compat_greenhouse_winter_growth"
	greenhouse_winter_growth_decl.substrate_prop_kind = "greenhouse_winter_growth"
	var greenhouse_winter_growth := assembler._build_procedural_prop(greenhouse_winter_growth_decl)
	_ok("substrate greenhouse winter growth builds from shared substrate kind", greenhouse_winter_growth != null)

	var greenhouse_winter_growth_back_decl := PropDecl.new()
	greenhouse_winter_growth_back_decl.id = "compat_greenhouse_winter_growth_back"
	greenhouse_winter_growth_back_decl.substrate_prop_kind = "greenhouse_winter_growth_back"
	var greenhouse_winter_growth_back := assembler._build_procedural_prop(greenhouse_winter_growth_back_decl)
	_ok("substrate greenhouse rear winter growth builds from shared substrate kind", greenhouse_winter_growth_back != null)

	var greenhouse_nature_cluster_decl := PropDecl.new()
	greenhouse_nature_cluster_decl.id = "compat_greenhouse_nature_cluster"
	greenhouse_nature_cluster_decl.substrate_prop_kind = "greenhouse_nature_cluster"
	var greenhouse_nature_cluster := assembler._build_procedural_prop(greenhouse_nature_cluster_decl)
	_ok("substrate greenhouse nature cluster builds from shared substrate kind", greenhouse_nature_cluster != null)

	var greenhouse_bucket_small_decl := PropDecl.new()
	greenhouse_bucket_small_decl.id = "compat_greenhouse_bucket_small"
	greenhouse_bucket_small_decl.substrate_prop_kind = "greenhouse_bucket_small"
	var greenhouse_bucket_small := assembler._build_procedural_prop(greenhouse_bucket_small_decl)
	_ok("substrate greenhouse bucket fixture builds from shared substrate kind", greenhouse_bucket_small != null)

	var greenhouse_bucket_large_decl := PropDecl.new()
	greenhouse_bucket_large_decl.id = "compat_greenhouse_bucket_large"
	greenhouse_bucket_large_decl.substrate_prop_kind = "greenhouse_bucket_large"
	var greenhouse_bucket_large := assembler._build_procedural_prop(greenhouse_bucket_large_decl)
	_ok("substrate greenhouse large bucket fixture builds from shared substrate kind", greenhouse_bucket_large != null)

	var greenhouse_bottle_decl := PropDecl.new()
	greenhouse_bottle_decl.id = "compat_greenhouse_bottle"
	greenhouse_bottle_decl.substrate_prop_kind = "greenhouse_bottle"
	var greenhouse_bottle := assembler._build_procedural_prop(greenhouse_bottle_decl)
	_ok("substrate greenhouse bottle fixture builds from shared substrate kind", greenhouse_bottle != null)

	var forecourt_statue_decl := PropDecl.new()
	forecourt_statue_decl.id = "compat_forecourt_statue"
	forecourt_statue_decl.substrate_prop_kind = "forecourt_statue"
	var forecourt_statue := assembler._build_procedural_prop(forecourt_statue_decl)
	_ok("substrate forecourt statue builds from shared substrate kind", forecourt_statue != null)

	var greenhouse_pedestal_decl := PropDecl.new()
	greenhouse_pedestal_decl.id = "compat_greenhouse_pedestal"
	greenhouse_pedestal_decl.substrate_prop_kind = "greenhouse_pedestal"
	var greenhouse_pedestal := assembler._build_procedural_prop(greenhouse_pedestal_decl)
	_ok("substrate greenhouse pedestal builds from shared substrate kind", greenhouse_pedestal != null)

	var menu_payload := MountPayloadDecl.new()
	menu_payload.payload_id = "compat_front_gate_menu_sign_payload"
	menu_payload.scene_role = "architectural_trim"
	menu_payload.substrate_prop_kind = "front_gate_sign"
	var mounted_sign := assembler._instantiate_mount_payload(menu_payload)
	_ok("mount payload substrate kind builds through assembler", mounted_sign != null)
	floor.free()
	ceiling.free()
	wall.free()
	door.free()
	gate.free()
	hidden_door.free()
	hidden_threshold.free()
	window.free()
	stairs.free()
	trapdoor.free()
	ladder.free()
	legacy_single.free()
	legacy_double.free()
	if procedural_window != null:
		procedural_window.free()
	if procedural_ray != null:
		procedural_ray.free()
	if procedural_stairs != null:
		procedural_stairs.free()
	if procedural_banister != null:
		procedural_banister.free()
	if procedural_newel != null:
		procedural_newel.free()
	if procedural_slab != null:
		procedural_slab.free()
	if procedural_plinth != null:
		procedural_plinth.free()
	if procedural_pillar != null:
		procedural_pillar.free()
	if procedural_facade_door != null:
		procedural_facade_door.free()
	if manor_wall != null:
		manor_wall.free()
	if manor_window_panel != null:
		manor_window_panel.free()
	if manor_wing != null:
		manor_wing.free()
	if manor_column != null:
		manor_column.free()
	if doorway_trim != null:
		doorway_trim.free()
	if manor_roof != null:
		manor_roof.free()
	if manor_roof_molding != null:
		manor_roof_molding.free()
	if manor_frieze != null:
		manor_frieze.free()
	if front_gate_sign != null:
		front_gate_sign.free()
	if greenhouse_shell != null:
		greenhouse_shell.free()
	if greenhouse_lantern != null:
		greenhouse_lantern.free()
	if gate_post != null:
		gate_post.free()
	if gate_post_stone != null:
		gate_post_stone.free()
	if boundary_wall != null:
		boundary_wall.free()
	if iron_gate_closed != null:
		iron_gate_closed.free()
	if iron_gate_open != null:
		iron_gate_open.free()
	if fence_run != null:
		fence_run.free()
	if hedgerow != null:
		hedgerow.free()
	if carriage_road != null:
		carriage_road.free()
	if outward_road != null:
		outward_road.free()
	if mansion_facade != null:
		mansion_facade.free()
	if entry_portico != null:
		entry_portico.free()
	if front_door_assembly != null:
		front_door_assembly.free()
	if forecourt_steps != null:
		forecourt_steps.free()
	if starfield != null:
		starfield.free()
	if front_gate_lamp != null:
		front_gate_lamp.free()
	if front_gate_tree != null:
		front_gate_tree.free()
	if front_gate_bush != null:
		front_gate_bush.free()
	if front_gate_rocks != null:
		front_gate_rocks.free()
	if iron_gate_leaf != null:
		iron_gate_leaf.free()
	if boundary_pole != null:
		boundary_pole.free()
	if chimney_left != null:
		chimney_left.free()
	if chimney_right != null:
		chimney_right.free()
	if crypt_wall_capped != null:
		crypt_wall_capped.free()
	if crypt_wall != null:
		crypt_wall.free()
	if crypt_fence != null:
		crypt_fence.free()
	if crypt_grave != null:
		crypt_grave.free()
	if crypt_debris_left != null:
		crypt_debris_left.free()
	if crypt_debris_right != null:
		crypt_debris_right.free()
	if crypt_bottle != null:
		crypt_bottle.free()
	if crypt_bones != null:
		crypt_bones.free()
	if garden_fountain != null:
		garden_fountain.free()
	if garden_water != null:
		garden_water.free()
	if garden_gazebo != null:
		garden_gazebo.free()
	if garden_path != null:
		garden_path.free()
	if garden_wall != null:
		garden_wall.free()
	if garden_corner != null:
		garden_corner.free()
	if garden_column != null:
		garden_column.free()
	if garden_vase != null:
		garden_vase.free()
	if garden_bench != null:
		garden_bench.free()
	if garden_gazebo_table != null:
		garden_gazebo_table.free()
	if garden_bench_north != null:
		garden_bench_north.free()
	if garden_beds_west != null:
		garden_beds_west.free()
	if garden_beds_east != null:
		garden_beds_east.free()
	if chapel_wall_fancy != null:
		chapel_wall_fancy.free()
	if chapel_wall_center != null:
		chapel_wall_center.free()
	if chapel_wall_column != null:
		chapel_wall_column.free()
	if chapel_bucket != null:
		chapel_bucket.free()
	if chapel_bottle != null:
		chapel_bottle.free()
	if chapel_dead_lamp != null:
		chapel_dead_lamp.free()
	if chapel_bones != null:
		chapel_bones.free()
	if carriage_house_mattress != null:
		carriage_house_mattress.free()
	if carriage_house_shed != null:
		carriage_house_shed.free()
	if carriage_house_board != null:
		carriage_house_board.free()
	if carriage_house_shovel != null:
		carriage_house_shovel.free()
	if carriage_house_luggage != null:
		carriage_house_luggage.free()
	if carriage_house_dead_lamp != null:
		carriage_house_dead_lamp.free()
	if candle_holder_fixture != null:
		candle_holder_fixture.free()
	if candle_single != null:
		candle_single.free()
	if picture_frame_blank != null:
		picture_frame_blank.free()
	if picture_frame_blank_004 != null:
		picture_frame_blank_004.free()
	if rug_0 != null:
		rug_0.free()
	if rug_2 != null:
		rug_2.free()
	if furniture_table != null:
		furniture_table.free()
	if furniture_study_desk != null:
		furniture_study_desk.free()
	if furniture_drawers != null:
		furniture_drawers.free()
	if furniture_chair != null:
		furniture_chair.free()
	if furniture_bookcase != null:
		furniture_bookcase.free()
	if furniture_bed != null:
		furniture_bed.free()
	if chandelier_fixture != null:
		chandelier_fixture.free()
	if item_page_001 != null:
		item_page_001.free()
	if item_page_002 != null:
		item_page_002.free()
	if item_page_005 != null:
		item_page_005.free()
	if item_openbook_000 != null:
		item_openbook_000.free()
	if item_openbook_001 != null:
		item_openbook_001.free()
	if greenhouse_plank_bench != null:
		greenhouse_plank_bench.free()
	if greenhouse_plank_shelf != null:
		greenhouse_plank_shelf.free()
	if greenhouse_dead_row != null:
		greenhouse_dead_row.free()
	if greenhouse_dead_end != null:
		greenhouse_dead_end.free()
	if greenhouse_tall_dead != null:
		greenhouse_tall_dead.free()
	if greenhouse_winter_growth != null:
		greenhouse_winter_growth.free()
	if greenhouse_winter_growth_back != null:
		greenhouse_winter_growth_back.free()
	if greenhouse_nature_cluster != null:
		greenhouse_nature_cluster.free()
	if greenhouse_bucket_small != null:
		greenhouse_bucket_small.free()
	if greenhouse_bucket_large != null:
		greenhouse_bucket_large.free()
	if greenhouse_bottle != null:
		greenhouse_bottle.free()
	if forecourt_statue != null:
		forecourt_statue.free()
	if greenhouse_pedestal != null:
		greenhouse_pedestal.free()
	if mounted_sign != null:
		mounted_sign.free()
	print("[DONE] builder defaults")


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


func _find_interactable_by_id(interactables: Array, interactable_id: String) -> InteractableDecl:
	for interactable in interactables:
		if interactable != null and interactable.id == interactable_id:
			return interactable
	return null


func _find_prop_by_id(props: Array, prop_id: String) -> PropDecl:
	for prop in props:
		if prop != null and prop.id == prop_id:
			return prop
	return null


func _find_mount_payload_by_id(payloads: Array, payload_id: String) -> MountPayloadDecl:
	for payload in payloads:
		if payload != null and payload.payload_id == payload_id:
			return payload
	return null


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


func _collect_source_files(root_path: String) -> PackedStringArray:
	var files := PackedStringArray()
	var dir := DirAccess.open(root_path)
	if dir == null:
		return files
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry.begins_with("."):
			entry = dir.get_next()
			continue
		var child_path := "%s/%s" % [root_path, entry]
		if dir.current_is_dir():
			files.append_array(_collect_source_files(child_path))
		elif entry.ends_with(".gd"):
			files.append(child_path)
		entry = dir.get_next()
	return files


func _append_unique(values: PackedStringArray, value: String) -> void:
	if not values.has(value):
		values.append(value)
