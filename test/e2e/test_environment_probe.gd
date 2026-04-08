extends SceneTree
## Prints the active WorldEnvironment state after loading a room.
## Run: godot --path . --script test/e2e/test_environment_probe.gd

const EstateEnvironmentRegistry = preload("res://builders/estate_environment_registry.gd")

var _main: Node = null
var _rm: Node = null
var _world_env: WorldEnvironment = null
var _gm: Node = null
var _output_dir := "user://screenshots/environment_probe/"


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(_output_dir)
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_run")


func _run() -> void:
	_rm = _find(_main, "RoomManager")
	_world_env = _find(_main, "WorldEnvironment") as WorldEnvironment
	for child in root.get_children():
		if child.name == "GameManager":
			_gm = child
			break
	if _rm == null or _world_env == null or _gm == null:
		push_error("environment probe missing required nodes")
		quit(1)
		return

	_gm.new_game()
	for room_id in ["front_gate", "foyer", "upper_hallway", "storage_basement"]:
		_rm.load_room(room_id)
		await process_frame
		await process_frame
		await process_frame
		_print_probe()
	quit()


func _find(root_node: Node, target_name: String) -> Node:
	if root_node.name == target_name:
		return root_node
	for child in root_node.get_children():
		var found := _find(child, target_name)
		if found != null:
			return found
	return null


func _print_probe() -> void:
	var env := _world_env.environment
	var room: Node = _rm.get_current_room()
	if env == null:
		print("ENV_PROBE none")
		return
	var sky := env.sky
	var sky_material_class := ""
	if sky != null and sky.sky_material != null:
		sky_material_class = sky.sky_material.get_class()
		if _rm.get_current_room_id() == "front_gate" and sky.sky_material is PanoramaSkyMaterial:
			var panorama := (sky.sky_material as PanoramaSkyMaterial).panorama
			if panorama != null:
				var image := panorama.get_image()
				if image != null:
					image.save_png(_output_dir + "front_gate_panorama.png")
	var env_preset := ""
	var substrate_preset := ""
	var region_id := ""
	var floor_surface := ""
	var wall_surface := ""
	var ceiling_surface := ""
	var threshold_surface := ""
	var door_surface := ""
	var gate_leaf_surface := ""
	var window_surface := ""
	var stair_tread_surface := ""
	var stair_structure_surface := ""
	var stair_rail_surface := ""
	var ladder_rail_surface := ""
	var ladder_rung_surface := ""
	if room != null:
		env_preset = String(room.get_meta("environment_preset", ""))
		region_id = String(room.get_meta("region_id", ""))
		substrate_preset = String(room.get_meta("substrate_preset_id", ""))
		floor_surface = String(room.get_meta("resolved_floor_surface", ""))
		wall_surface = String(room.get_meta("resolved_wall_surface", ""))
		ceiling_surface = String(room.get_meta("resolved_ceiling_surface", ""))
		threshold_surface = String(room.get_meta("resolved_threshold_surface", ""))
		door_surface = String(room.get_meta("resolved_door_surface", ""))
		gate_leaf_surface = String(room.get_meta("resolved_gate_leaf_surface", ""))
		window_surface = String(room.get_meta("resolved_window_surface", ""))
		stair_tread_surface = String(room.get_meta("resolved_stair_tread_surface", ""))
		stair_structure_surface = String(room.get_meta("resolved_stair_structure_surface", ""))
		stair_rail_surface = String(room.get_meta("resolved_stair_rail_surface", ""))
		ladder_rail_surface = String(room.get_meta("resolved_ladder_rail_surface", ""))
		ladder_rung_surface = String(room.get_meta("resolved_ladder_rung_surface", ""))
	var allowed_mount_families := PackedStringArray()
	if room != null:
		allowed_mount_families = room.get_meta("allowed_mount_families", PackedStringArray())
	var light_grammar := ""
	var dominant_recipes := PackedStringArray()
	var terrain_preset := ""
	var sky_preset := ""
	var sky_mode := ""
	if not env_preset.is_empty():
		var env_decl := load("res://declarations/environments/%s.tres" % env_preset) as EnvironmentDeclaration
		if env_decl != null:
			light_grammar = env_decl.light_grammar
			dominant_recipes = env_decl.dominant_material_recipes
			terrain_preset = env_decl.terrain_preset_id
			sky_preset = env_decl.sky_preset_id
			if not sky_preset.is_empty():
				var sky_preset_decl := EstateEnvironmentRegistry.load_sky_preset(sky_preset)
				if sky_preset_decl != null:
					sky_mode = sky_preset_decl.sky_mode
	print("ENV_PROBE room=%s region=%s env=%s substrate=%s terrain=%s sky_preset=%s sky_mode=%s floor=%s wall=%s ceiling=%s threshold=%s door=%s gate_leaf=%s window=%s stair_tread=%s stair_structure=%s stair_rail=%s ladder_rail=%s ladder_rung=%s mounts=%s bg=%s fog=%s volumetric=%s ambient_source=%s sky=%s sky_material=%s light_grammar=%s dominant=%s" % [
		_rm.get_current_room_id(),
		region_id,
		env_preset,
		substrate_preset,
		terrain_preset,
		sky_preset,
		sky_mode,
		floor_surface,
		wall_surface,
		ceiling_surface,
		threshold_surface,
		door_surface,
		gate_leaf_surface,
		window_surface,
		stair_tread_surface,
		stair_structure_surface,
		stair_rail_surface,
		ladder_rail_surface,
		ladder_rung_surface,
		",".join(allowed_mount_families),
		str(env.background_mode),
		str(env.fog_enabled),
		str(env.volumetric_fog_enabled),
		str(env.ambient_light_source),
		str(sky != null),
		sky_material_class,
		light_grammar,
		",".join(dominant_recipes)
	])
