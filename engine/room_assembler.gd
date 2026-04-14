class_name RoomAssembler
extends RefCounted
## Core engine: reads RoomDeclaration → generates complete Node3D scene tree.
## Calls builders for geometry, places interactables, connections, lights, props, audio.

var _world: WorldDeclaration
var _room_base_script := load("res://scripts/room_base.gd")
const WORLD_LABEL_FONT = preload("res://assets/fonts/Cinzel-SemiBold.ttf")
const SecretPassageDecl = preload("res://engine/declarations/secret_passage_decl.gd")
const MountSlotDecl = preload("res://engine/declarations/mount_slot_decl.gd")
const MountPayloadDecl = preload("res://engine/declarations/mount_payload_decl.gd")
const RegionDecl = preload("res://engine/declarations/region_decl.gd")
const ConnectionAssembly = preload("res://builders/connection_assembly.gd")
const EstateEnvironmentRegistry = preload("res://builders/estate_environment_registry.gd")
const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const EstateSubstrateRegistry = preload("res://builders/estate_substrate_registry.gd")
const InteractableVisuals = preload("res://engine/interactable_visuals.gd")
const WindowBuilder = preload("res://builders/window_builder.gd")
const MODEL_SCALE_OVERRIDES := {
	"res://assets/shared/furniture/bookcase.glb": 0.32,
	"res://assets/shared/furniture/table.glb": 0.52,
	"res://assets/shared/furniture/study_desk.glb": 0.48,
	"res://assets/shared/decor/fireplace.glb": 0.34,
	"res://assets/shared/structure/stairs0.glb": 0.72,
	"res://assets/shared/structure/stairs1.glb": 0.72,
	"res://assets/shared/structure/stairbanister.glb": 0.68,
	"res://assets/shared/structure/banisterbase.glb": 0.28,
	"res://assets/shared/structure/window_clean.glb": 0.86,
	"res://assets/shared/structure/window_ray.glb": 0.38,
	"res://assets/shared/decor/statue.glb": 0.22,
	"res://assets/shared/decor/candle_holder.glb": 0.52,
}
const PROCEDURAL_WINDOW_MODEL := "res://assets/shared/structure/window_clean.glb"
const PROCEDURAL_WINDOW_RAY_MODEL := "res://assets/shared/structure/window_ray.glb"
const PROCEDURAL_STAIRCASE_MODEL := "res://assets/shared/structure/stairs0.glb"
const PROCEDURAL_BANISTER_MODEL := "res://assets/shared/structure/stairbanister.glb"
const PROCEDURAL_NEWEL_MODEL := "res://assets/shared/structure/banisterbase.glb"
const PROCEDURAL_STONE_SLAB_MODEL := "res://assets/shared/structure/floor3.glb"
const PROCEDURAL_PLINTH_LEFT_MODEL := "res://assets/shared/structure/pillar0_002.glb"
const PROCEDURAL_PLINTH_RIGHT_MODEL := "res://assets/shared/structure/pillar0_003.glb"
const PROCEDURAL_FOYER_PILLAR_MODEL := "res://assets/shared/structure/pillar1.glb"
const LEGACY_PROCEDURAL_PROP_KINDS := {
	PROCEDURAL_WINDOW_MODEL: "window_frame",
	PROCEDURAL_WINDOW_RAY_MODEL: "window_ray",
	PROCEDURAL_STAIRCASE_MODEL: "stair_run",
	PROCEDURAL_BANISTER_MODEL: "banister_run",
	PROCEDURAL_NEWEL_MODEL: "newel_post",
	PROCEDURAL_STONE_SLAB_MODEL: "stone_slab",
	PROCEDURAL_PLINTH_LEFT_MODEL: "plinth_tall",
	PROCEDURAL_PLINTH_RIGHT_MODEL: "plinth_tall",
	PROCEDURAL_FOYER_PILLAR_MODEL: "round_pillar",
}


func _init(world: WorldDeclaration) -> void:
	_world = world


## Assemble a complete room scene from its declaration.
## Returns the root Node3D ready to be added to the scene tree.
func assemble(room_decl: RoomDeclaration) -> Node3D:
	var root := Node3D.new()
	root.set_script(_room_base_script)
	root.name = room_decl.room_id.capitalize().replace("_", "")
	var resolved_environment_preset := room_decl.environment_preset
	if _world != null:
		resolved_environment_preset = _world.resolve_environment_preset_for_room(room_decl)
	var resolved_region_id := ""
	var region_decl: RegionDecl = null
	if _world != null:
		region_decl = _world.get_region_for_room(room_decl.room_id)
		if region_decl != null:
			resolved_region_id = region_decl.region_id
	var resolved_substrate_preset := EstateSubstrateRegistry.resolve_room_substrate_preset_id(_world, room_decl)
	var env_decl: EnvironmentDeclaration = null
	if _world != null and not resolved_environment_preset.is_empty():
		env_decl = _world.get_environment_declaration(resolved_environment_preset)
	var substrate_decl := EstateSubstrateRegistry.load_preset(resolved_substrate_preset)
	var resolved_allowed_mount_families := _resolve_allowed_mount_families(region_decl, env_decl, substrate_decl)

	# Populate room_base exports and keep metadata for backward compatibility.
	root.set("room_id", room_decl.room_id)
	root.set("room_name", room_decl.room_name)
	root.set("audio_loop", room_decl.ambient_loop)
	root.set("is_exterior", room_decl.is_exterior)
	root.set("spawn_position", room_decl.spawn_position)
	root.set("spawn_rotation_y", room_decl.spawn_rotation_y)
	root.set_meta("room_id", room_decl.room_id)
	root.set_meta("room_name", room_decl.room_name)
	root.set_meta("audio_loop", room_decl.ambient_loop)
	root.set_meta("tension_loop", room_decl.tension_loop)
	root.set_meta("spawn_position", room_decl.spawn_position)
	root.set_meta("spawn_rotation_y", room_decl.spawn_rotation_y)
	root.set_meta("environment_preset", resolved_environment_preset)
	root.set_meta("region_id", resolved_region_id)
	root.set_meta("substrate_preset_id", resolved_substrate_preset)
	root.set_meta("terrain_preset_id", "" if env_decl == null else env_decl.terrain_preset_id)
	root.set_meta("sky_preset_id", "" if env_decl == null else env_decl.sky_preset_id)
	root.set_meta("light_grammar", "" if env_decl == null else env_decl.light_grammar)
	root.set_meta("dominant_material_recipes", PackedStringArray() if env_decl == null else env_decl.dominant_material_recipes)
	root.set_meta("region_allowed_mount_families", PackedStringArray() if region_decl == null else region_decl.allowed_mount_families)
	root.set_meta("environment_allowed_mount_families", PackedStringArray() if env_decl == null else env_decl.allowed_mount_families)
	root.set_meta("substrate_allowed_mount_families", PackedStringArray() if substrate_decl == null else substrate_decl.allowed_mount_families)
	root.set_meta("allowed_mount_families", resolved_allowed_mount_families)
	root.set_meta("primary_architecture_source", room_decl.primary_architecture_source)
	root.set_meta("material_recipe_overrides", room_decl.material_recipe_overrides)
	root.set_meta("mount_slot_count", room_decl.mount_slots.size())
	root.set_meta("mount_payload_count", room_decl.mount_payloads.size())
	root.set_meta("is_exterior", room_decl.is_exterior)
	root.set_meta("footstep_surface", room_decl.footstep_surface)
	root.set_meta("declaration", room_decl)

	var w := room_decl.dimensions.x
	var h := room_decl.dimensions.y
	var d := room_decl.dimensions.z
	var resolved_floor_surface := _resolve_floor_surface_ref(room_decl, env_decl)
	var resolved_wall_surface := _resolve_surface_ref(room_decl, env_decl, "wall", "")
	var resolved_ceiling_surface := _resolve_surface_ref(room_decl, env_decl, "ceiling", "")
	var resolved_threshold_surface := _resolve_surface_ref(room_decl, env_decl, "threshold", "")
	var resolved_door_surface := _resolve_surface_ref(room_decl, env_decl, "door", "")
	var resolved_gate_leaf_surface := _resolve_surface_ref(room_decl, env_decl, "gate_leaf", resolved_door_surface)
	var resolved_window_surface := _resolve_surface_ref(
		room_decl,
		env_decl,
		"window",
		resolved_threshold_surface if not resolved_threshold_surface.is_empty() else resolved_wall_surface
	)
	var resolved_stair_tread_surface := _resolve_surface_ref(room_decl, env_decl, "stair_tread", resolved_floor_surface)
	var resolved_stair_structure_surface := _resolve_surface_ref(
		room_decl,
		env_decl,
		"stair_structure",
		resolved_threshold_surface if not resolved_threshold_surface.is_empty() else resolved_wall_surface
	)
	var resolved_stair_rail_surface := _resolve_surface_ref(
		room_decl,
		env_decl,
		"stair_rail",
		resolved_door_surface if not resolved_door_surface.is_empty() else resolved_threshold_surface
	)
	var resolved_ladder_rail_surface := _resolve_surface_ref(
		room_decl,
		env_decl,
		"ladder_rail",
		resolved_threshold_surface if not resolved_threshold_surface.is_empty() else resolved_wall_surface
	)
	var resolved_ladder_rung_surface := _resolve_surface_ref(
		room_decl,
		env_decl,
		"ladder_rung",
		resolved_door_surface if not resolved_door_surface.is_empty() else resolved_ladder_rail_surface
	)
	root.set_meta("resolved_floor_surface", resolved_floor_surface)
	root.set_meta("resolved_wall_surface", resolved_wall_surface)
	root.set_meta("resolved_ceiling_surface", resolved_ceiling_surface)
	root.set_meta("resolved_threshold_surface", resolved_threshold_surface)
	root.set_meta("resolved_door_surface", resolved_door_surface)
	root.set_meta("resolved_gate_leaf_surface", resolved_gate_leaf_surface)
	root.set_meta("resolved_window_surface", resolved_window_surface)
	root.set_meta("resolved_stair_tread_surface", resolved_stair_tread_surface)
	root.set_meta("resolved_stair_structure_surface", resolved_stair_structure_surface)
	root.set_meta("resolved_stair_rail_surface", resolved_stair_rail_surface)
	root.set_meta("resolved_ladder_rail_surface", resolved_ladder_rail_surface)
	root.set_meta("resolved_ladder_rung_surface", resolved_ladder_rung_surface)

	# --- Geometry ---
	var geometry := Node3D.new()
	geometry.name = "Geometry"

	if not room_decl.is_exterior:
		# Floor
		var floor_node := FloorBuilder.build(w, d, resolved_floor_surface, room_decl.footstep_surface)
		geometry.add_child(floor_node)

		# Ceiling
		var ceiling_node := CeilingBuilder.build(w, h, d, resolved_ceiling_surface)
		geometry.add_child(ceiling_node)

		# Walls
		var wall_tex := resolved_wall_surface
		if room_decl.wall_north.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_north, wall_tex, "north", w, d, h))
		if room_decl.wall_south.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_south, wall_tex, "south", w, d, h))
		if room_decl.wall_east.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_east, wall_tex, "east", w, d, h))
		if room_decl.wall_west.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_west, wall_tex, "west", w, d, h))
	else:
		# Exterior: ground plane only, no walls/ceiling
		var floor_node := FloorBuilder.build(w, d, resolved_floor_surface, room_decl.footstep_surface)
		geometry.add_child(floor_node)

	root.add_child(geometry)

	# --- Doors ---
	var doors := Node3D.new()
	doors.name = "Doors"
	_build_doors(room_decl, doors, resolved_threshold_surface, resolved_door_surface, resolved_gate_leaf_surface)
	root.add_child(doors)

	# --- Windows ---
	var windows := Node3D.new()
	windows.name = "Windows"
	_build_windows(room_decl, windows, resolved_window_surface)
	root.add_child(windows)

	# --- Lighting ---
	var lighting := Node3D.new()
	lighting.name = "Lighting"
	_build_lights(room_decl.lights, lighting)
	root.add_child(lighting)

	# --- Interactables ---
	var interactables := Node3D.new()
	interactables.name = "Interactables"
	_build_interactables(room_decl.interactables, interactables)
	root.add_child(interactables)

	# --- Connections (non-door) ---
	var connections := Node3D.new()
	connections.name = "Connections"
	_build_connection_areas(
		room_decl,
		connections,
		resolved_threshold_surface,
		resolved_door_surface,
		resolved_gate_leaf_surface,
		resolved_stair_tread_surface,
		resolved_stair_structure_surface,
		resolved_stair_rail_surface,
		resolved_ladder_rail_surface,
		resolved_ladder_rung_surface
	)
	root.add_child(connections)

	# --- Props ---
	var props := Node3D.new()
	props.name = "Props"
	_build_props(room_decl.props, props)
	root.add_child(props)
	_build_mount_payloads(room_decl, root, props)

	# --- Audio ---
	var audio := Node3D.new()
	audio.name = "Audio"
	_build_audio_zone(room_decl, audio)
	root.add_child(audio)

	return root


func _resolve_floor_surface_ref(room_decl: RoomDeclaration, env_decl: EnvironmentDeclaration) -> String:
	var explicit_surface := _resolve_surface_ref(room_decl, env_decl, "floor", "")
	if not room_decl.is_exterior:
		return explicit_surface
	if room_decl.material_recipe_overrides.has("terrain"):
		return _ensure_recipe_prefix(String(room_decl.material_recipe_overrides.get("terrain", "")))
	if env_decl != null and not env_decl.terrain_preset_id.is_empty():
		var terrain_preset := EstateEnvironmentRegistry.load_terrain_preset(env_decl.terrain_preset_id)
		if terrain_preset != null and not terrain_preset.base_recipe_id.is_empty():
			return _ensure_recipe_prefix(terrain_preset.base_recipe_id)
	return explicit_surface if not explicit_surface.is_empty() else "recipe:terrain/roadside_earth"


func _resolve_surface_ref(room_decl: RoomDeclaration, env_decl: EnvironmentDeclaration, key: String, fallback_surface: String) -> String:
	if room_decl.material_recipe_overrides.has(key):
		return _ensure_recipe_prefix(String(room_decl.material_recipe_overrides.get(key, "")))
	if env_decl != null and env_decl.surface_recipe_overrides.has(key):
		return _ensure_recipe_prefix(String(env_decl.surface_recipe_overrides.get(key, "")))
	if not fallback_surface.is_empty():
		return fallback_surface
	if env_decl != null:
		var desired_family := "terrain_path" if key == "terrain" else "surface"
		for recipe_id in env_decl.dominant_material_recipes:
			if EstateMaterialKit.get_recipe_family(recipe_id) == desired_family:
				return _ensure_recipe_prefix(recipe_id)
	return ""


func _ensure_recipe_prefix(surface_ref: String) -> String:
	if surface_ref.is_empty():
		return ""
	if surface_ref.begins_with("recipe:") or surface_ref.begins_with("res://"):
		return surface_ref
	return "recipe:%s" % surface_ref


func _build_doors(room_decl: RoomDeclaration, parent: Node3D, threshold_surface: String, door_surface: String, gate_leaf_surface: String) -> void:
	# Find connections that reference this room as from_room
	for conn in _world.connections:
		if conn.from_room != room_decl.room_id:
			continue
		if conn.type in ["door", "double_door", "heavy_door", "hidden_door", "gate"]:
			var door := ConnectionAssembly.build(conn, room_decl.dimensions.y, {
				"threshold": threshold_surface,
				"door": door_surface,
				"gate_leaf": gate_leaf_surface,
			})
			var door_pos := conn.position_in_from
			door_pos.y = 0.0
			door.position = door_pos
			_apply_secret_passage_metadata(conn, door)
			parent.add_child(door)


func _build_windows(room_decl: RoomDeclaration, parent: Node3D, window_surface: String) -> void:
	# Scan wall layouts for window segments
	var walls := {
		"north": room_decl.wall_north,
		"south": room_decl.wall_south,
		"east": room_decl.wall_east,
		"west": room_decl.wall_west,
	}
	for direction in walls:
		var layout: PackedStringArray = walls[direction]
		var segment_count := layout.size()
		for i in range(segment_count):
			if layout[i].begins_with("window"):
				var local_x := (i * 2.0) - (segment_count * 2.0 * 0.5) + 1.0
				var window := WindowBuilder.build(layout[i], window_surface)
				window.position = WallBuilder._get_segment_position(
					direction, local_x, room_decl.dimensions.x, room_decl.dimensions.z
				)
				window.rotation_degrees.y = WallBuilder._get_wall_rotation(direction)
				parent.add_child(window)


func _build_lights(lights: Array[LightDecl], parent: Node3D) -> void:
	for light_decl in lights:
		var light: Light3D
		match light_decl.type:
			"spot":
				light = SpotLight3D.new()
			"directional":
				light = DirectionalLight3D.new()
			_:
				light = OmniLight3D.new()
				(light as OmniLight3D).omni_range = light_decl.range

		light.name = light_decl.id if not light_decl.id.is_empty() else "Light"
		light.position = light_decl.position
		light.rotation_degrees = light_decl.rotation_degrees
		light.light_color = light_decl.color
		light.light_energy = light_decl.energy
		light.shadow_enabled = light_decl.shadows

		# Metadata for flickering system
		if light_decl.flickering:
			light.set_meta("flickering", true)
			light.set_meta("flicker_pattern", light_decl.flicker_pattern)
			light.set_meta("base_energy", light_decl.energy)

		if light_decl.switchable:
			light.set_meta("switchable", true)
			light.set_meta("switch_id", light_decl.switch_id)

		parent.add_child(light)


func _build_interactables(decls: Array[InteractableDecl], parent: Node3D) -> void:
	for decl in decls:
		var area := Area3D.new()
		area.name = decl.id
		area.position = decl.position
		area.collision_layer = 4  # Layer 3 -- Interactable
		area.collision_mask = 0
		area.add_to_group("interactables")

		# Store full declaration and legacy metadata consumed by the current runtime.
		area.set_meta("id", decl.id)
		area.set_meta("type", decl.type)
		area.set_meta("data", _build_legacy_interactable_data(decl))
		area.set_meta("interactable_id", decl.id)
		area.set_meta("interactable_type", decl.type)
		area.set_meta("scene_role", decl.scene_role)
		area.set_meta("state_tags", decl.state_tags)
		area.set_meta("declaration", decl)

		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = decl.collision_size
		shape.shape = box
		area.add_child(shape)

		_add_interactable_world_label(decl, area)
		InteractableVisuals.ensure_visual(area)

		parent.add_child(area)


func _build_connection_areas(room_decl: RoomDeclaration, parent: Node3D, threshold_surface: String, door_surface: String, gate_leaf_surface: String, stair_tread_surface: String, stair_structure_surface: String, stair_rail_surface: String, ladder_rail_surface: String, ladder_rung_surface: String) -> void:
	# Non-door connections (stairs, trapdoor, ladder, path)
	for conn in _world.connections:
		if conn.from_room != room_decl.room_id:
			continue
		match conn.type:
			"stairs":
				var stairs := ConnectionAssembly.build(conn, _get_vertical_connection_span(room_decl, conn), {
					"stair_tread": stair_tread_surface,
					"stair_structure": stair_structure_surface,
					"stair_rail": stair_rail_surface,
				})
				var stairs_pos := conn.position_in_from
				stairs_pos.y = 0.0
				stairs.position = stairs_pos
				parent.add_child(stairs)
			"trapdoor":
				var trapdoor := ConnectionAssembly.build(conn, _get_vertical_connection_span(room_decl, conn), {
					"threshold": threshold_surface,
					"door": door_surface,
					"gate_leaf": gate_leaf_surface,
				})
				var trapdoor_pos := conn.position_in_from
				trapdoor_pos.y = 0.0
				trapdoor.position = trapdoor_pos
				parent.add_child(trapdoor)
			"ladder":
				var ladder := ConnectionAssembly.build(conn, _get_vertical_connection_span(room_decl, conn), {
					"ladder_rail": ladder_rail_surface,
					"ladder_rung": ladder_rung_surface,
				})
				var ladder_pos := conn.position_in_from
				ladder_pos.y = 0.0
				ladder.position = ladder_pos
				parent.add_child(ladder)
			"path":
				var path_threshold := ConnectionAssembly.build(conn, room_decl.dimensions.y)
				var path_pos := conn.position_in_from
				path_pos.y = 0.0
				path_threshold.position = path_pos
				_apply_secret_passage_metadata(conn, path_threshold)
				parent.add_child(path_threshold)


func _build_props(props: Array[PropDecl], parent: Node3D) -> void:
	for prop_decl in props:
		var procedural_prop := _build_procedural_prop(prop_decl)
		if procedural_prop != null:
			parent.add_child(procedural_prop)
			continue
		var scene_path := _resolve_prop_scene_path(prop_decl)
		if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
			continue
		var scene: PackedScene = load(scene_path)
		if not scene:
			continue
		var inst := scene.instantiate() as Node3D
		if inst == null:
			continue
		inst.name = prop_decl.id if not prop_decl.id.is_empty() else "Prop"
		inst.position = prop_decl.position
		inst.rotation_degrees.y = prop_decl.rotation_y
		var resolved_scale := prop_decl.scale
		if scene_path == prop_decl.model:
			resolved_scale *= _get_model_scale_override(prop_decl.model)
		var final_scale := prop_decl.scale_3d * resolved_scale
		if final_scale != Vector3.ONE:
			inst.scale = final_scale
		parent.add_child(inst)


func _build_mount_payloads(room_decl: RoomDeclaration, root: Node3D, default_parent: Node3D) -> void:
	if room_decl.mount_payloads.is_empty():
		return
	var slot_map: Dictionary = {}
	var allowed_mount_families := root.get_meta("allowed_mount_families", PackedStringArray()) as PackedStringArray
	for slot in room_decl.mount_slots:
		if slot != null and not slot.slot_id.is_empty():
			slot_map[slot.slot_id] = slot
	for payload in room_decl.mount_payloads:
		if payload == null or not _payload_route_matches(payload):
			continue
		var game_manager := _game_manager()
		if not payload.state_condition.is_empty() and (game_manager == null or not game_manager.has_method("has_flag") or not bool(game_manager.call("has_flag", payload.state_condition))):
			continue
		var inst := _instantiate_mount_payload(payload)
		if inst == null:
			continue
		var mount_slot := slot_map.get(payload.slot_id, null) as MountSlotDecl
		if mount_slot == null:
			push_warning("Mount payload %s in room %s targets missing slot %s" % [payload.payload_id, room_decl.room_id, payload.slot_id])
			continue
		if not allowed_mount_families.has(mount_slot.slot_family):
			push_warning(
				"Mount payload %s in room %s uses disallowed slot family %s" %
				[payload.payload_id, room_decl.room_id, mount_slot.slot_family]
			)
			continue
		var target_parent := _resolve_mount_parent(root, mount_slot, default_parent)
		var final_position := payload.offset
		var final_rotation := payload.rotation_degrees
		var final_scale := payload.scale_3d
		if mount_slot != null:
			final_position += mount_slot.position
			final_rotation += mount_slot.rotation_degrees
			final_scale = mount_slot.scale_3d * payload.scale_3d
		inst.name = payload.payload_id if not payload.payload_id.is_empty() else inst.name
		inst.position = final_position
		inst.rotation_degrees = final_rotation
		inst.scale = final_scale
		inst.set_meta("mount_payload_id", payload.payload_id)
		inst.set_meta("mount_slot_id", payload.slot_id)
		inst.set_meta("scene_role", payload.scene_role)
		target_parent.add_child(inst)


func _resolve_prop_scene_path(prop_decl: PropDecl) -> String:
	if not prop_decl.scene_path.is_empty():
		return prop_decl.scene_path
	return prop_decl.model


func _instantiate_mount_payload(payload: MountPayloadDecl) -> Node3D:
	var scene_path := payload.scene_path if not payload.scene_path.is_empty() else payload.model
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		return null
	var scene: PackedScene = load(scene_path)
	if scene == null:
		return null
	var inst := scene.instantiate() as Node3D
	if inst == null:
		return null
	if scene_path == payload.model:
		inst.scale *= _get_model_scale_override(payload.model)
	return inst


func _resolve_mount_parent(root: Node3D, slot: MountSlotDecl, default_parent: Node3D) -> Node3D:
	if slot != null and not slot.target_node.is_empty():
		var target := root.get_node_or_null(slot.target_node)
		if target is Node3D:
			return target as Node3D
	return default_parent


func _payload_route_matches(payload: MountPayloadDecl) -> bool:
	if payload.route_modes.is_empty():
		return true
	var active_modes := PackedStringArray()
	var game_manager := _game_manager()
	if game_manager != null and game_manager.has_method("get_active_route"):
		var active_route := String(game_manager.call("get_active_route"))
		if not active_route.is_empty() and not active_modes.has(active_route):
			active_modes.append(active_route)
	if game_manager != null and game_manager.has_method("get_route_mode"):
		var route_mode := String(game_manager.call("get_route_mode"))
		if not route_mode.is_empty() and not active_modes.has(route_mode):
			active_modes.append(route_mode)
	if game_manager != null and game_manager.has_method("get_state"):
		var macro_thread := String(game_manager.call("get_state", "macro_thread", ""))
		if not macro_thread.is_empty() and not active_modes.has(macro_thread):
			active_modes.append(macro_thread)
	for route_mode in payload.route_modes:
		if active_modes.has(String(route_mode)):
			return true
	return false


func _resolve_allowed_mount_families(region_decl: RegionDecl, env_decl: EnvironmentDeclaration, substrate_decl) -> PackedStringArray:
	var resolved := PackedStringArray()
	var candidate_sources: Array = []
	if region_decl != null:
		candidate_sources.append(region_decl.allowed_mount_families)
	if env_decl != null:
		candidate_sources.append(env_decl.allowed_mount_families)
	if substrate_decl != null:
		candidate_sources.append(substrate_decl.allowed_mount_families)
	if candidate_sources.is_empty():
		return resolved

	for family in candidate_sources[0]:
		var allowed := true
		for i in range(1, candidate_sources.size()):
			if not candidate_sources[i].has(family):
				allowed = false
				break
		if allowed and not resolved.has(family):
			resolved.append(family)
	return resolved


func _get_vertical_connection_span(room_decl: RoomDeclaration, conn: Connection) -> float:
	var source_height := room_decl.dimensions.y if room_decl != null else 2.4
	var target_height := source_height
	if _world != null:
		for room_ref in _world.rooms:
			if room_ref == null or room_ref.room_id != conn.to_room:
				continue
			if room_ref.declaration_path.is_empty() or not ResourceLoader.exists(room_ref.declaration_path):
				break
			var target_decl := load(room_ref.declaration_path) as RoomDeclaration
			if target_decl != null:
				target_height = target_decl.dimensions.y
			break
	var resolved := minf(source_height, target_height)
	return clampf(resolved, 2.1, 3.2)


func _add_interactable_world_label(decl: InteractableDecl, area: Area3D) -> void:
	var label_text := String(decl.visual_effects.get("world_label", ""))
	if label_text.is_empty():
		return
	if bool(decl.visual_effects.get("world_label_board", false)):
		area.add_child(_build_world_label_board(decl))
	var label := Label3D.new()
	label.name = "WorldLabel"
	label.text = label_text
	label.font = WORLD_LABEL_FONT
	label.font_size = int(decl.visual_effects.get("world_label_font_size", 86))
	label.pixel_size = float(decl.visual_effects.get("world_label_pixel_size", 0.012))
	label.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	label.double_sided = true
	label.shaded = false
	label.no_depth_test = true
	label.modulate = _coerce_color(
		decl.visual_effects.get("world_label_color", Color(0.86, 0.77, 0.55, 1.0)),
		Color(0.86, 0.77, 0.55, 1.0)
	)
	label.outline_modulate = _coerce_color(
		decl.visual_effects.get("world_label_outline_color", Color(0.05, 0.03, 0.02, 0.95)),
		Color(0.05, 0.03, 0.02, 0.95)
	)
	label.outline_size = int(decl.visual_effects.get("world_label_outline_size", 10))
	label.position = _coerce_vector3(decl.visual_effects.get("world_label_offset", Vector3.ZERO), Vector3.ZERO)
	label.rotation_degrees = Vector3(
		float(decl.visual_effects.get("world_label_rotation_x", 0.0)),
		float(decl.visual_effects.get("world_label_rotation_y", 0.0)),
		float(decl.visual_effects.get("world_label_rotation_z", 0.0))
	)
	area.add_child(label)


func _build_world_label_board(decl: InteractableDecl) -> Node3D:
	var root := Node3D.new()
	root.name = "WorldLabelBoard"

	var board := MeshInstance3D.new()
	board.name = "Board"
	var board_mesh := BoxMesh.new()
	var board_size := _coerce_vector3(
		decl.visual_effects.get("world_label_board_size", Vector3(2.3, 0.65, 0.08)),
		Vector3(2.3, 0.65, 0.08)
	)
	board_mesh.size = board_size
	board.mesh = board_mesh
	board.position = _coerce_vector3(
		decl.visual_effects.get("world_label_board_offset", Vector3(0, 0, -0.03)),
		Vector3(0, 0, -0.03)
	)
	var board_texture_path := String(decl.visual_effects.get("world_label_board_texture", "res://assets/grounds/front_gate/bench_mx_1_planks_hr_2.png"))
	var board_color := _coerce_color(
		decl.visual_effects.get("world_label_board_color", Color(0.31, 0.20, 0.12, 1.0)),
		Color(0.31, 0.20, 0.12, 1.0)
	)
	var board_texture: Texture2D = null
	if ResourceLoader.exists(board_texture_path):
		board_texture = load(board_texture_path) as Texture2D
	var board_mat := EstateMaterialKit.legacy_texture_unshaded(board_texture, board_color)
	board.set_surface_override_material(0, board_mat)
	root.add_child(board)

	var hanger_height := float(decl.visual_effects.get("world_label_hanger_height", 0.55))
	var hanger_offset := float(decl.visual_effects.get("world_label_hanger_offset_x", maxf(0.4, board_size.x * 0.32)))
	for hanger_x in [-hanger_offset, hanger_offset]:
		var hanger := MeshInstance3D.new()
		var hanger_mesh := BoxMesh.new()
		hanger_mesh.size = Vector3(0.03, hanger_height, 0.03)
		hanger.mesh = hanger_mesh
		hanger.position = Vector3(float(hanger_x), board.position.y + hanger_height * 0.5 + board_size.y * 0.5, board.position.z)
		var hanger_mat := EstateMaterialKit.flat_unshaded(_coerce_color(
			decl.visual_effects.get("world_label_hanger_color", Color(0.22, 0.16, 0.11, 1.0)),
			Color(0.22, 0.16, 0.11, 1.0)
		))
		hanger.set_surface_override_material(0, hanger_mat)
		root.add_child(hanger)

	return root


func _build_procedural_prop(prop_decl: PropDecl) -> Node3D:
	var substrate_kind := prop_decl.substrate_prop_kind
	if substrate_kind.is_empty():
		substrate_kind = String(LEGACY_PROCEDURAL_PROP_KINDS.get(prop_decl.model, ""))
	if substrate_kind == "window_frame":
		var window := WindowBuilder.build("window", "recipe:surface/oak_dark")
		window.name = prop_decl.id if not prop_decl.id.is_empty() else "WindowProp"
		window.position = prop_decl.position
		window.rotation_degrees.y = prop_decl.rotation_y
		window.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_WINDOW_MODEL)
		return window
	if substrate_kind == "window_ray":
		var ray_root := Node3D.new()
		ray_root.name = prop_decl.id if not prop_decl.id.is_empty() else "WindowRayProp"
		var ray := MeshInstance3D.new()
		ray.name = "WindowRay"
		var quad := QuadMesh.new()
		quad.size = Vector2(1.0, 2.4)
		ray.mesh = quad
		ray.position = Vector3(0, 1.2, -0.02)
		ray.rotation_degrees.x = -8.0
		ray.set_surface_override_material(0, EstateMaterialKit.fog_glow(Color(0.78, 0.84, 0.96, 0.18), 0.92))
		ray_root.add_child(ray)
		ray_root.position = prop_decl.position
		ray_root.rotation_degrees.y = prop_decl.rotation_y
		ray_root.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_WINDOW_RAY_MODEL)
		return ray_root
	if substrate_kind == "stair_run":
		var staircase := Node3D.new()
		staircase.name = prop_decl.id if not prop_decl.id.is_empty() else "StaircaseProp"
		var tread_surface := "recipe:surface/oak_board"
		var structure_surface := "recipe:surface/oak_header"
		var width := 2.8
		var step_count := 8
		var step_height := 0.24
		var step_depth := 0.44
		for step_index in range(step_count):
			var step := _make_prop_box(
				Vector3(width, 0.08, step_depth),
				Vector3(0, step_index * step_height + 0.04, step_index * step_depth + step_depth * 0.5),
				tread_surface
			)
			step.name = "Step_%d" % step_index
			staircase.add_child(step)
			var riser := _make_prop_box(
				Vector3(width, step_height, 0.05),
				Vector3(0, step_index * step_height + step_height * 0.5, step_index * step_depth + 0.03),
				structure_surface
			)
			riser.name = "Riser_%d" % step_index
			staircase.add_child(riser)
		var run_depth := step_count * step_depth
		var rise := step_count * step_height
		var left_stringer := _make_prop_box(
			Vector3(0.1, rise + 0.08, run_depth + 0.2),
			Vector3(-width * 0.5 - 0.06, (rise + 0.08) * 0.5, (run_depth + 0.2) * 0.5),
			structure_surface
		)
		left_stringer.name = "StringerLeft"
		staircase.add_child(left_stringer)
		var right_stringer := _make_prop_box(
			Vector3(0.1, rise + 0.08, run_depth + 0.2),
			Vector3(width * 0.5 + 0.06, (rise + 0.08) * 0.5, (run_depth + 0.2) * 0.5),
			structure_surface
		)
		right_stringer.name = "StringerRight"
		staircase.add_child(right_stringer)
		staircase.position = prop_decl.position
		staircase.rotation_degrees.y = prop_decl.rotation_y
		staircase.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_STAIRCASE_MODEL)
		return staircase
	if substrate_kind == "banister_run":
		var banister := Node3D.new()
		banister.name = prop_decl.id if not prop_decl.id.is_empty() else "BanisterProp"
		var rail_surface := "recipe:surface/oak_dark"
		var post_count := 4
		var run_length := 2.4
		for post_index in range(post_count):
			var t := float(post_index) / float(post_count - 1)
			var post := _make_prop_box(
				Vector3(0.12, 0.92, 0.12),
				Vector3(0, 0.46 + t * 0.78, t * run_length),
				rail_surface
			)
			post.name = "Post_%d" % post_index
			banister.add_child(post)
		var rail := _make_prop_box(
			Vector3(0.1, 0.1, run_length + 0.15),
			Vector3(0, 1.18, run_length * 0.5),
			rail_surface
		)
		rail.rotation_degrees.x = -20.0
		rail.name = "Rail"
		banister.add_child(rail)
		banister.position = prop_decl.position
		banister.rotation_degrees.y = prop_decl.rotation_y
		banister.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_BANISTER_MODEL)
		return banister
	if substrate_kind == "newel_post":
		var newel := Node3D.new()
		newel.name = prop_decl.id if not prop_decl.id.is_empty() else "NewelProp"
		var rail_surface := "recipe:surface/oak_dark"
		var base := _make_prop_box(Vector3(0.28, 0.18, 0.28), Vector3(0, 0.09, 0), rail_surface)
		base.name = "Base"
		newel.add_child(base)
		var shaft := _make_prop_box(Vector3(0.18, 0.82, 0.18), Vector3(0, 0.59, 0), rail_surface)
		shaft.name = "Shaft"
		newel.add_child(shaft)
		var cap := _make_prop_box(Vector3(0.3, 0.12, 0.3), Vector3(0, 1.06, 0), rail_surface)
		cap.name = "Cap"
		newel.add_child(cap)
		newel.position = prop_decl.position
		newel.rotation_degrees.y = prop_decl.rotation_y
		newel.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_NEWEL_MODEL)
		return newel
	if substrate_kind == "stone_slab":
		var slab := Node3D.new()
		slab.name = prop_decl.id if not prop_decl.id.is_empty() else "StoneSlabProp"
		var slab_surface := "recipe:surface/stone_dark"
		var top := _make_prop_box(Vector3(2.2, 0.22, 2.2), Vector3(0, 0.11, 0), slab_surface)
		top.name = "Top"
		slab.add_child(top)
		var base := _make_prop_box(Vector3(2.0, 0.18, 2.0), Vector3(0, 0.03, 0), slab_surface)
		base.name = "Base"
		slab.add_child(base)
		slab.position = prop_decl.position
		slab.rotation_degrees.y = prop_decl.rotation_y
		slab.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_STONE_SLAB_MODEL)
		return slab
	if substrate_kind == "plinth_tall":
		var plinth := Node3D.new()
		plinth.name = prop_decl.id if not prop_decl.id.is_empty() else "PlinthProp"
		var stone_surface := "recipe:surface/stone_dark"
		var pedestal_base := _make_prop_box(Vector3(1.22, 0.24, 1.22), Vector3(0, 0.12, 0), stone_surface)
		pedestal_base.name = "Base"
		plinth.add_child(pedestal_base)
		var pedestal_body := _make_prop_box(Vector3(0.9, 1.18, 0.9), Vector3(0, 0.83, 0), stone_surface)
		pedestal_body.name = "Body"
		plinth.add_child(pedestal_body)
		var pedestal_cap := _make_prop_box(Vector3(1.08, 0.18, 1.08), Vector3(0, 1.5, 0), stone_surface)
		pedestal_cap.name = "Cap"
		plinth.add_child(pedestal_cap)
		plinth.position = prop_decl.position
		plinth.rotation_degrees.y = prop_decl.rotation_y
		plinth.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_PLINTH_LEFT_MODEL)
		return plinth
	if substrate_kind == "round_pillar":
		var pillar := Node3D.new()
		pillar.name = prop_decl.id if not prop_decl.id.is_empty() else "RoundPillarProp"
		var pillar_surface := "recipe:surface/oak_header"
		var pillar_base := _make_prop_box(Vector3(0.62, 0.2, 0.62), Vector3(0, 0.1, 0), pillar_surface)
		pillar_base.name = "Base"
		pillar.add_child(pillar_base)
		var shaft := MeshInstance3D.new()
		shaft.name = "Shaft"
		var shaft_mesh := CylinderMesh.new()
		shaft_mesh.top_radius = 0.18
		shaft_mesh.bottom_radius = 0.22
		shaft_mesh.height = 2.7
		shaft.mesh = shaft_mesh
		shaft.position = Vector3(0, 1.55, 0)
		var shaft_material := EstateMaterialKit.build_surface_reference(pillar_surface)
		if shaft_material != null:
			shaft.set_surface_override_material(0, shaft_material)
		pillar.add_child(shaft)
		var pillar_cap := _make_prop_box(Vector3(0.76, 0.2, 0.76), Vector3(0, 2.95, 0), pillar_surface)
		pillar_cap.name = "Cap"
		pillar.add_child(pillar_cap)
		pillar.position = prop_decl.position
		pillar.rotation_degrees.y = prop_decl.rotation_y
		pillar.scale = prop_decl.scale_3d * Vector3.ONE * prop_decl.scale * _get_model_scale_override(PROCEDURAL_FOYER_PILLAR_MODEL)
		return pillar
	if prop_decl.tags.has("procedural_moon"):
		var moon := MeshInstance3D.new()
		moon.name = prop_decl.id if not prop_decl.id.is_empty() else "Moon"
		var mesh := SphereMesh.new()
		mesh.radius = 0.54
		mesh.height = 1.08
		moon.mesh = mesh
		var material := EstateMaterialKit.emissive_unshaded(Color(0.76, 0.8, 0.88, 1.0), 0.46)
		moon.set_surface_override_material(0, material)
		moon.position = prop_decl.position
		moon.rotation_degrees.y = prop_decl.rotation_y
		moon.scale = Vector3.ONE * maxf(0.1, prop_decl.scale)
		return moon
	return null


func _make_prop_box(size: Vector3, pos: Vector3, surface_ref: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.position = pos
	var material := EstateMaterialKit.build_surface_reference(surface_ref)
	if material != null:
		mesh_inst.set_surface_override_material(0, material)
	return mesh_inst


func _coerce_vector3(value: Variant, fallback: Vector3) -> Vector3:
	return value if value is Vector3 else fallback


func _coerce_color(value: Variant, fallback: Color) -> Color:
	return value if value is Color else fallback


func _get_model_scale_override(model_path: String) -> float:
	return float(MODEL_SCALE_OVERRIDES.get(model_path, 1.0))


func _build_audio_zone(room_decl: RoomDeclaration, parent: Node3D) -> void:
	# Reverb zone covering the room
	var reverb_area := Area3D.new()
	reverb_area.name = "ReverbZone"
	reverb_area.collision_layer = 0
	reverb_area.collision_mask = 0
	reverb_area.set_meta("reverb_bus", room_decl.reverb_bus)

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = room_decl.dimensions
	shape.shape = box
	shape.position = Vector3(0, room_decl.dimensions.y * 0.5, 0)
	reverb_area.add_child(shape)
	parent.add_child(reverb_area)


func _apply_secret_passage_metadata(conn: Connection, node: Node) -> void:
	var passage: SecretPassageDecl = _find_secret_passage(conn.from_room, conn.to_room)
	if passage == null:
		return

	var is_revealed := _is_secret_passage_revealed(passage)
	node.set_meta("secret_passage", passage)
	node.set_meta("secret_passage_id", passage.passage_id)
	node.set_meta("secret_passage_role", passage.functional_role)
	node.set_meta("secret_passage_discovery_mode", passage.discovery_mode)
	node.set_meta("secret_passage_revealed", is_revealed)
	var cover := node.get_node_or_null("SecretPanelMask")
	if cover is Node3D:
		(cover as Node3D).visible = not is_revealed

	for area in _collect_areas(node):
		area.set_meta("secret_passage", passage)
		area.set_meta("secret_passage_id", passage.passage_id)
		area.set_meta("secret_passage_role", passage.functional_role)
		area.set_meta("secret_passage_discovery_mode", passage.discovery_mode)
		area.set_meta("secret_passage_revealed", is_revealed)
		if passage.presentation != null:
			area.set_meta("secret_passage_closed_text", passage.presentation.closed_text)
			area.set_meta("secret_passage_discovered_text", passage.presentation.discovered_text)
			area.set_meta("secret_passage_opened_text", passage.presentation.opened_text)


func _find_secret_passage(from_room: String, to_room: String) -> SecretPassageDecl:
	for passage in _world.secret_passages:
		if passage.from_room == from_room and passage.to_room == to_room:
			return passage
	return null


func _is_secret_passage_revealed(passage: SecretPassageDecl) -> bool:
	if passage.initially_known:
		return true
	if passage.reveal_condition.is_empty():
		return true
	var game_manager := _game_manager()
	return game_manager != null and game_manager.has_method("has_flag") and bool(game_manager.call("has_flag", passage.reveal_condition))


func _game_manager() -> Node:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		return null
	return tree.root.get_node_or_null("GameManager")


func _collect_areas(node: Node) -> Array[Area3D]:
	var result: Array[Area3D] = []
	_collect_areas_recursive(node, result)
	return result


func _collect_areas_recursive(node: Node, result: Array[Area3D]) -> void:
	if node is Area3D:
		result.append(node as Area3D)
	for child in node.get_children():
		_collect_areas_recursive(child, result)


func _build_legacy_interactable_data(decl: InteractableDecl) -> Dictionary:
	var data: Dictionary = {}
	if decl.type == "doll":
		var default_response: ResponseDecl = null
		var reward_response: ResponseDecl = null
		for candidate in decl.responses:
			if candidate == null:
				continue
			if reward_response == null and not candidate.gives_item.is_empty():
				reward_response = candidate
			if default_response == null and candidate.condition.is_empty():
				default_response = candidate
		if default_response != null:
			data["title"] = default_response.title
			data["content"] = default_response.text
			data["first_content"] = default_response.text
			if not default_response.set_state.is_empty():
				data["on_read_flags"] = PackedStringArray(default_response.set_state.keys())
				data["on_first_flags"] = PackedStringArray(default_response.set_state.keys())
		if reward_response != null:
			data["second_content"] = reward_response.text
			data["item_found"] = reward_response.gives_item
			data["pickable_after_key"] = true
			data["item_id"] = decl.id
			if not reward_response.condition.is_empty() and not reward_response.condition.contains(" "):
				data["requires_flag"] = reward_response.condition
			if not reward_response.set_state.is_empty():
				data["on_second_flags"] = PackedStringArray(reward_response.set_state.keys())
		return data

	var response: ResponseDecl = null
	if not decl.responses.is_empty():
		response = decl.responses[0]
	elif decl.fallback_response != null:
		response = decl.fallback_response

	if response != null:
		data["title"] = response.title
		data["content"] = response.text
		if not response.set_state.is_empty():
			data["on_read_flags"] = PackedStringArray(response.set_state.keys())

	if decl.locked:
		data["locked"] = true
		data["key_id"] = decl.key_id

	if not decl.gives_item.is_empty():
		data["pickable"] = true
		data["item_id"] = decl.gives_item

	if not decl.controls_light.is_empty():
		data["controls_light"] = decl.controls_light

	if not decl.target_room.is_empty():
		data["target_room"] = decl.target_room

	return data


# ===== Phantom Camera Integration (P5-06) =====

## Add inspection PhantomCamera3D for wall-mounted interactables (painting, note, photo).
## Also adds room reveal camera for first-entry sweep.
func add_phantom_cameras(root: Node3D, room_decl: RoomDeclaration) -> void:
	var cameras := Node3D.new()
	cameras.name = "PhantomCameras"

	# Inspection cameras for wall-mounted interactables
	for decl in room_decl.interactables:
		if decl.type in ["painting", "note", "photo", "document"]:
			var pcam := _create_inspection_camera(decl)
			if pcam:
				cameras.add_child(pcam)

	# Room reveal camera (sweeps on first entry)
	var reveal_cam := _create_room_reveal_camera(room_decl)
	if reveal_cam:
		cameras.add_child(reveal_cam)

	root.add_child(cameras)


func _create_inspection_camera(decl: InteractableDecl) -> Node3D:
	# PhantomCamera3D positioned to look at the interactable
	var pcam := Node3D.new()
	pcam.name = "InspectCam_%s" % decl.id

	# Position the camera 1.5m in front of the interactable, at eye height
	var offset := Vector3(0, 0, -1.5)
	pcam.position = decl.position + offset
	pcam.set_meta("inspection_target", decl.id)
	pcam.set_meta("pcam_priority", 0)  # Inactive by default, set to 20 on interact
	pcam.set_meta("pcam_type", "inspection")

	return pcam


func _create_room_reveal_camera(room_decl: RoomDeclaration) -> Node3D:
	# Room reveal: sweeps from corner to spawn position on first entry
	var has_reveal := false
	for trigger in room_decl.on_entry:
		for action in trigger.actions:
			if "show_room_name" in action.show_text:
				has_reveal = true
				break

	if not has_reveal:
		return null

	var pcam := Node3D.new()
	pcam.name = "RoomRevealCam"
	pcam.position = room_decl.spawn_position + Vector3(0, 3, -2)
	pcam.set_meta("pcam_type", "room_reveal")
	pcam.set_meta("pcam_priority", 0)
	pcam.set_meta("reveal_target", room_decl.spawn_position)

	return pcam


# ===== Footstep Surface Tagging (P5-05) =====

## Tag floor collision bodies with footstep_surface metadata.
## godot-material-footsteps reads this metadata to select audio.
func tag_floor_surfaces(root: Node3D, room_decl: RoomDeclaration) -> void:
	var geometry := root.get_node_or_null("Geometry")
	if not geometry:
		return

	for child in geometry.get_children():
		if child is StaticBody3D:
			# Tag all floor collision bodies
			child.set_meta("footstep_surface", room_decl.footstep_surface)
			child.set_meta("footstep_audio_dir",
				"res://assets/audio/footsteps/%s/" % room_decl.footstep_surface)
