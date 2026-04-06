class_name RoomAssembler
extends RefCounted
## Core engine: reads RoomDeclaration → generates complete Node3D scene tree.
## Calls builders for geometry, places interactables, connections, lights, props, audio.

var _world: WorldDeclaration


func _init(world: WorldDeclaration) -> void:
	_world = world


## Assemble a complete room scene from its declaration.
## Returns the root Node3D ready to be added to the scene tree.
func assemble(room_decl: RoomDeclaration) -> Node3D:
	var root := Node3D.new()
	root.name = room_decl.room_id.capitalize().replace("_", "")

	# Attach room_base script metadata
	root.set_meta("room_id", room_decl.room_id)
	root.set_meta("room_name", room_decl.room_name)
	root.set_meta("ambient_loop", room_decl.ambient_loop)
	root.set_meta("tension_loop", room_decl.tension_loop)
	root.set_meta("spawn_position", room_decl.spawn_position)
	root.set_meta("spawn_rotation_y", room_decl.spawn_rotation_y)
	root.set_meta("environment_preset", room_decl.environment_preset)
	root.set_meta("is_exterior", room_decl.is_exterior)
	root.set_meta("footstep_surface", room_decl.footstep_surface)

	var w := room_decl.dimensions.x
	var h := room_decl.dimensions.y
	var d := room_decl.dimensions.z

	# --- Geometry ---
	var geometry := Node3D.new()
	geometry.name = "Geometry"

	if not room_decl.is_exterior:
		# Floor
		var floor_node := FloorBuilder.build(w, d, room_decl.floor_texture, room_decl.footstep_surface)
		geometry.add_child(floor_node)

		# Ceiling
		var ceiling_node := CeilingBuilder.build(w, h, d, room_decl.ceiling_texture)
		geometry.add_child(ceiling_node)

		# Walls
		var wall_tex := room_decl.wall_texture
		if room_decl.wall_north.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_north, wall_tex, "north", w, d))
		if room_decl.wall_south.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_south, wall_tex, "south", w, d))
		if room_decl.wall_east.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_east, wall_tex, "east", w, d))
		if room_decl.wall_west.size() > 0:
			geometry.add_child(WallBuilder.build(room_decl.wall_west, wall_tex, "west", w, d))
	else:
		# Exterior: ground plane only, no walls/ceiling
		var floor_node := FloorBuilder.build(w, d, room_decl.floor_texture, room_decl.footstep_surface)
		geometry.add_child(floor_node)

	root.add_child(geometry)

	# --- Doors ---
	var doors := Node3D.new()
	doors.name = "Doors"
	_build_doors(room_decl, doors)
	root.add_child(doors)

	# --- Windows ---
	var windows := Node3D.new()
	windows.name = "Windows"
	_build_windows(room_decl, windows)
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
	_build_connection_areas(room_decl, connections)
	root.add_child(connections)

	# --- Props ---
	var props := Node3D.new()
	props.name = "Props"
	_build_props(room_decl.props, props)
	root.add_child(props)

	# --- Audio ---
	var audio := Node3D.new()
	audio.name = "Audio"
	_build_audio_zone(room_decl, audio)
	root.add_child(audio)

	return root


func _build_doors(room_decl: RoomDeclaration, parent: Node3D) -> void:
	# Find connections that reference this room as from_room
	for conn in _world.connections:
		if conn.from_room != room_decl.room_id:
			continue
		if conn.type in ["door", "double_door", "heavy_door", "hidden_door", "gate"]:
			var door := DoorBuilder.build(conn)
			door.position = conn.position_in_from
			parent.add_child(door)


func _build_windows(room_decl: RoomDeclaration, parent: Node3D) -> void:
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
				var window := WindowBuilder.build(layout[i], "")
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

		# Store full declaration as metadata
		area.set_meta("interactable_id", decl.id)
		area.set_meta("interactable_type", decl.type)
		area.set_meta("declaration", decl)

		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = decl.collision_size
		shape.shape = box
		area.add_child(shape)

		# If model specified, load and attach
		if not decl.model.is_empty() and ResourceLoader.exists(decl.model):
			var scene: PackedScene = load(decl.model)
			if scene:
				var model_inst := scene.instantiate()
				model_inst.name = "Model"
				area.add_child(model_inst)

		parent.add_child(area)


func _build_connection_areas(room_decl: RoomDeclaration, parent: Node3D) -> void:
	# Non-door connections (stairs, trapdoor, ladder, path)
	for conn in _world.connections:
		if conn.from_room != room_decl.room_id:
			continue
		match conn.type:
			"stairs":
				var stairs := StairsBuilder.build(conn, room_decl.dimensions.y)
				stairs.position = conn.position_in_from
				parent.add_child(stairs)
			"trapdoor":
				var trapdoor := TrapdoorBuilder.build(conn)
				trapdoor.position = conn.position_in_from
				parent.add_child(trapdoor)
			"ladder":
				var ladder := LadderBuilder.build(conn, room_decl.dimensions.y)
				ladder.position = conn.position_in_from
				parent.add_child(ladder)
			"path":
				# Simple area trigger for outdoor paths
				var area := Area3D.new()
				area.name = "Path_%s" % conn.id
				area.collision_layer = 8  # Layer 4 -- Connection
				area.collision_mask = 0
				area.position = conn.position_in_from
				area.set_meta("connection_id", conn.id)
				area.set_meta("target_room", conn.to_room)

				var shape := CollisionShape3D.new()
				var box := BoxShape3D.new()
				box.size = Vector3(2.0, 2.0, 2.0)
				shape.shape = box
				area.add_child(shape)
				parent.add_child(area)


func _build_props(props: Array[PropDecl], parent: Node3D) -> void:
	for prop_decl in props:
		if prop_decl.model.is_empty() or not ResourceLoader.exists(prop_decl.model):
			continue
		var scene: PackedScene = load(prop_decl.model)
		if not scene:
			continue
		var inst := scene.instantiate()
		inst.name = prop_decl.id if not prop_decl.id.is_empty() else "Prop"
		inst.position = prop_decl.position
		inst.rotation_degrees.y = prop_decl.rotation_y
		if prop_decl.scale != 1.0:
			inst.scale = Vector3.ONE * prop_decl.scale
		parent.add_child(inst)


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
