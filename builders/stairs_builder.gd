class_name StairsBuilder
extends RefCounted
## Generates a procedural stair assembly sized to the threshold, then layers
## decorative trim on top. This keeps stairs scalable and animation-friendly.

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")

const STEP_HEIGHT := 0.18
const STEP_DEPTH := 0.32
const STEP_THICKNESS := 0.06
const DEFAULT_WIDTH := 1.8
const STRINGER_WIDTH := 0.08
const POST_WIDTH := 0.08
const RAIL_HEIGHT := 0.92
const POST_SPACING_STEPS := 2

const DEFAULT_TREAD_SURFACE := "recipe:surface/oak_board"
const DEFAULT_STRUCTURE_SURFACE := "recipe:surface/oak_header"
const DEFAULT_RAIL_SURFACE := "recipe:surface/oak_dark"
const DEFAULT_PRESENTATION_TYPE := "stairs_threshold"


static func build(connection: Connection, room_height: float = 2.4, tread_surface_ref: String = "", structure_surface_ref: String = "", rail_surface_ref: String = "") -> Node3D:
	var stairs_root := Node3D.new()
	stairs_root.name = "Stairs_%s" % connection.id

	var rise := clampf(room_height * 0.58, 2.1, 3.2)
	var width := connection.interaction_size.x if connection.interaction_size.x > 0.0 else DEFAULT_WIDTH
	var step_count := maxi(10, ceili(rise / STEP_HEIGHT))
	rise = step_count * STEP_HEIGHT
	var total_depth := step_count * STEP_DEPTH

	var visual := Node3D.new()
	visual.name = "StairVisual"
	stairs_root.add_child(visual)

	for i in range(step_count):
		var step := _make_box(
			Vector3(width, STEP_THICKNESS, STEP_DEPTH),
			Vector3(0, i * STEP_HEIGHT + STEP_THICKNESS * 0.5, (i + 0.5) * STEP_DEPTH),
			EstateMaterialKit.resolve_surface_reference(tread_surface_ref, DEFAULT_TREAD_SURFACE)
		)
		step.name = "Step_%d" % i
		visual.add_child(step)

		var riser := _make_box(
			Vector3(width, STEP_HEIGHT, 0.05),
			Vector3(0, i * STEP_HEIGHT + STEP_HEIGHT * 0.5, i * STEP_DEPTH + 0.03),
			EstateMaterialKit.resolve_surface_reference(structure_surface_ref, DEFAULT_STRUCTURE_SURFACE)
		)
		riser.name = "Riser_%d" % i
		visual.add_child(riser)

	var landing_depth := STEP_DEPTH * 1.4
	var landing := _make_box(
		Vector3(width, STEP_THICKNESS, landing_depth),
		Vector3(0, rise + STEP_THICKNESS * 0.5, total_depth + landing_depth * 0.5),
		EstateMaterialKit.resolve_surface_reference(tread_surface_ref, DEFAULT_TREAD_SURFACE)
	)
	landing.name = "TopLanding"
	visual.add_child(landing)

	var side_depth := total_depth + landing_depth
	var side_center_z := side_depth * 0.5
	var side_center_y := (rise + STEP_THICKNESS) * 0.5

	var stringer_left := _make_box(
		Vector3(STRINGER_WIDTH, rise + STEP_THICKNESS, side_depth),
		Vector3(-width * 0.5 - STRINGER_WIDTH * 0.5, side_center_y, side_center_z),
		EstateMaterialKit.resolve_surface_reference(structure_surface_ref, DEFAULT_STRUCTURE_SURFACE)
	)
	stringer_left.name = "StringerLeft"
	visual.add_child(stringer_left)

	var stringer_right := _make_box(
		Vector3(STRINGER_WIDTH, rise + STEP_THICKNESS, side_depth),
		Vector3(width * 0.5 + STRINGER_WIDTH * 0.5, side_center_y, side_center_z),
		EstateMaterialKit.resolve_surface_reference(structure_surface_ref, DEFAULT_STRUCTURE_SURFACE)
	)
	stringer_right.name = "StringerRight"
	visual.add_child(stringer_right)

	_build_rail_run(visual, width, step_count, rise, total_depth, -1.0, EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))
	_build_rail_run(visual, width, step_count, rise, total_depth, 1.0, EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))
	_add_newel(visual, Vector3(-width * 0.5 - 0.08, 0, 0.18), EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))
	_add_newel(visual, Vector3(width * 0.5 + 0.08, 0, 0.18), EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))
	_add_newel(visual, Vector3(-width * 0.5 - 0.08, rise, total_depth + landing_depth * 0.78), EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))
	_add_newel(visual, Vector3(width * 0.5 + 0.08, rise, total_depth + landing_depth * 0.78), EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))
	if connection.direction == "up":
		_build_top_portal(
			visual,
			width,
			rise,
			total_depth,
			landing_depth,
			EstateMaterialKit.resolve_surface_reference(structure_surface_ref, DEFAULT_STRUCTURE_SURFACE),
			EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE)
		)

	var body := StaticBody3D.new()
	body.name = "StairsCollision"
	body.collision_layer = 1
	body.collision_mask = 0

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(width, rise, total_depth)
	shape.shape = box
	shape.position = Vector3(0, rise * 0.5, total_depth * 0.5)
	shape.rotation.x = -atan2(rise, total_depth)
	body.add_child(shape)
	stairs_root.add_child(body)

	var area := Area3D.new()
	area.name = "StairsArea"
	area.collision_layer = 8
	area.collision_mask = 0
	area.add_to_group("connections")
	area.set_meta("connection_id", connection.id)
	area.set_meta("target_room", connection.to_room)
	area.set_meta("conn_type", connection.type)
	area.set_meta("locked", connection.locked)
	area.set_meta("key_id", connection.key_id)
	area.set_meta("required_state", connection.required_state)
	area.set_meta("blocked_text", connection.blocked_text)
	area.set_meta("declaration", connection)
	area.set_meta("presentation_type", _resolve_presentation_type(connection))
	area.set_meta("mechanism_type", _resolve_mechanism_type(connection))
	area.set_meta("mechanism_state", _resolve_mechanism_state(connection))
	area.set_meta("reveal_state", _resolve_reveal_state(connection))

	var area_shape := CollisionShape3D.new()
	var area_box := BoxShape3D.new()
	area_box.size = connection.interaction_size if connection.interaction_size != Vector3.ZERO else Vector3(width + 0.8, rise + 0.8, total_depth + landing_depth)
	area_shape.shape = area_box
	area_shape.position = Vector3(0, area_box.size.y * 0.5, total_depth * 0.5)
	area.add_child(area_shape)
	stairs_root.add_child(area)

	if connection.direction == "down":
		stairs_root.rotation_degrees.y = 180.0
	stairs_root.set_meta("resolved_stair_tread_surface", EstateMaterialKit.resolve_surface_reference(tread_surface_ref, DEFAULT_TREAD_SURFACE))
	stairs_root.set_meta("resolved_stair_structure_surface", EstateMaterialKit.resolve_surface_reference(structure_surface_ref, DEFAULT_STRUCTURE_SURFACE))
	stairs_root.set_meta("resolved_stair_rail_surface", EstateMaterialKit.resolve_surface_reference(rail_surface_ref, DEFAULT_RAIL_SURFACE))

	return stairs_root


static func _resolve_presentation_type(connection: Connection) -> String:
	return connection.presentation_type if not connection.presentation_type.is_empty() else DEFAULT_PRESENTATION_TYPE


static func _resolve_mechanism_type(connection: Connection) -> String:
	return connection.mechanism_type if not connection.mechanism_type.is_empty() else "swing"


static func _resolve_mechanism_state(connection: Connection) -> String:
	if not connection.mechanism_state.is_empty():
		return connection.mechanism_state
	return "locked" if connection.locked else "idle"


static func _resolve_reveal_state(connection: Connection) -> String:
	if not connection.reveal_state.is_empty():
		return connection.reveal_state
	return "visible"


static func _build_rail_run(parent: Node3D, width: float, step_count: int, rise: float, total_depth: float, side: float, rail_surface_ref: String) -> void:
	for step_index in range(0, step_count + 1, POST_SPACING_STEPS):
		var progress := float(step_index) / float(step_count)
		var post := _make_box(
			Vector3(POST_WIDTH, STEP_HEIGHT * 4.0, POST_WIDTH),
			Vector3(
				side * (width * 0.5 + STRINGER_WIDTH + POST_WIDTH * 0.5),
				progress * rise + STEP_HEIGHT * 2.0,
				progress * total_depth + 0.12
			),
			rail_surface_ref
		)
		post.name = "RailPost_%s_%d" % [("L" if side < 0.0 else "R"), step_index]
		parent.add_child(post)

	var rail := _make_box(
		Vector3(POST_WIDTH, POST_WIDTH, total_depth + STEP_DEPTH),
		Vector3(
			side * (width * 0.5 + STRINGER_WIDTH + POST_WIDTH * 0.5),
			rise + RAIL_HEIGHT,
			(total_depth + STEP_DEPTH) * 0.5
		),
		rail_surface_ref
	)
	rail.rotation_degrees.x = -rad_to_deg(atan2(rise, total_depth))
	rail.name = "HandRail_%s" % ("L" if side < 0.0 else "R")
	parent.add_child(rail)


static func _add_newel(parent: Node3D, pos: Vector3, surface_ref: String) -> void:
	var newel := Node3D.new()
	newel.name = "Newel"
	newel.position = pos

	var base := _make_box(
		Vector3(0.22, 0.18, 0.22),
		Vector3(0, 0.09, 0),
		surface_ref
	)
	base.name = "Base"
	newel.add_child(base)

	var shaft := _make_box(
		Vector3(0.16, 0.74, 0.16),
		Vector3(0, 0.18 + 0.37, 0),
		surface_ref
	)
	shaft.name = "Shaft"
	newel.add_child(shaft)

	var cap := _make_box(
		Vector3(0.24, 0.1, 0.24),
		Vector3(0, 0.18 + 0.74 + 0.05, 0),
		surface_ref
	)
	cap.name = "Cap"
	newel.add_child(cap)

	var finial := _make_box(
		Vector3(0.12, 0.1, 0.12),
		Vector3(0, 0.18 + 0.74 + 0.1 + 0.05, 0),
		surface_ref
	)
	finial.name = "Finial"
	newel.add_child(finial)

	parent.add_child(newel)


static func _build_top_portal(parent: Node3D, width: float, rise: float, total_depth: float, landing_depth: float, structure_surface_ref: String, rail_surface_ref: String) -> void:
	var portal_depth := total_depth + landing_depth
	var jamb_height := 2.3
	var jamb_width := 0.12
	var frame_depth := 0.16
	var opening_width := width - 0.22
	var opening_height := 1.95
	var center_z := portal_depth + frame_depth * 0.5

	var left_jamb := _make_box(
		Vector3(jamb_width, jamb_height, frame_depth),
		Vector3(-opening_width * 0.5 - jamb_width * 0.5, rise + jamb_height * 0.5, center_z),
		structure_surface_ref
	)
	left_jamb.name = "PortalJambLeft"
	parent.add_child(left_jamb)

	var right_jamb := _make_box(
		Vector3(jamb_width, jamb_height, frame_depth),
		Vector3(opening_width * 0.5 + jamb_width * 0.5, rise + jamb_height * 0.5, center_z),
		structure_surface_ref
	)
	right_jamb.name = "PortalJambRight"
	parent.add_child(right_jamb)

	var header := _make_box(
		Vector3(opening_width + jamb_width * 2.0, 0.14, frame_depth),
		Vector3(0, rise + opening_height + 0.07, center_z),
		structure_surface_ref
	)
	header.name = "PortalHeader"
	parent.add_child(header)

	var shadow_fill := _make_colored_box(
		Vector3(opening_width - 0.18, opening_height - 0.18, 0.03),
		Vector3(0, rise + opening_height * 0.5, center_z + 0.05),
		Color(0.08, 0.08, 0.12, 1.0)
	)
	shadow_fill.name = "PortalShadow"
	parent.add_child(shadow_fill)

	var return_depth := 0.48
	var left_return := _make_box(
		Vector3(jamb_width, opening_height, return_depth),
		Vector3(-opening_width * 0.5 - jamb_width * 0.5, rise + opening_height * 0.5, center_z + frame_depth * 0.5 + return_depth * 0.5),
		structure_surface_ref
	)
	left_return.name = "PortalReturnLeft"
	parent.add_child(left_return)

	var right_return := _make_box(
		Vector3(jamb_width, opening_height, return_depth),
		Vector3(opening_width * 0.5 + jamb_width * 0.5, rise + opening_height * 0.5, center_z + frame_depth * 0.5 + return_depth * 0.5),
		structure_surface_ref
	)
	right_return.name = "PortalReturnRight"
	parent.add_child(right_return)

	var landing_backer := _make_box(
		Vector3(opening_width + jamb_width * 2.0, 0.28, 0.08),
		Vector3(0, rise + 0.94, total_depth + landing_depth * 0.6),
		structure_surface_ref
	)
	landing_backer.name = "LandingBacker"
	parent.add_child(landing_backer)

	var landing_rail := _make_box(
		Vector3(opening_width + 0.2, POST_WIDTH, 0.08),
		Vector3(0, rise + RAIL_HEIGHT, total_depth + landing_depth * 0.52),
		rail_surface_ref
	)
	landing_rail.name = "LandingRail"
	parent.add_child(landing_rail)

	var rail_post_left := _make_box(
		Vector3(POST_WIDTH, 0.92, POST_WIDTH),
		Vector3(-opening_width * 0.5, rise + 0.46, total_depth + landing_depth * 0.52),
		rail_surface_ref
	)
	rail_post_left.name = "LandingRailPostLeft"
	parent.add_child(rail_post_left)

	var rail_post_right := _make_box(
		Vector3(POST_WIDTH, 0.92, POST_WIDTH),
		Vector3(opening_width * 0.5, rise + 0.46, total_depth + landing_depth * 0.52),
		rail_surface_ref
	)
	rail_post_right.name = "LandingRailPostRight"
	parent.add_child(rail_post_right)


static func _make_box(size: Vector3, pos: Vector3, surface_ref: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.position = pos
	var mat := EstateMaterialKit.build_surface_reference(surface_ref)
	if mat == null:
		mat = EstateMaterialKit.fallback_wood()
	mesh_inst.set_surface_override_material(0, mat)
	return mesh_inst


static func _make_colored_box(size: Vector3, pos: Vector3, color: Color) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.position = pos
	var mat := EstateMaterialKit.shadow_void()
	if mat != null:
		mat.albedo_color = color
	mesh_inst.set_surface_override_material(0, mat)
	return mesh_inst


static func _apply_material_recursive(root: Node, surface_ref: String) -> void:
	if root == null or surface_ref.is_empty():
		return
	var material := EstateMaterialKit.build_surface_reference(surface_ref)
	if material == null:
		return
	_apply_material_to_node(root, material)


static func _apply_material_to_node(node: Node, material: Material) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		var surface_count := 1
		if mesh_instance.mesh != null:
			surface_count = max(mesh_instance.mesh.get_surface_count(), 1)
		for surface_idx in range(surface_count):
			mesh_instance.set_surface_override_material(surface_idx, material)
	for child in node.get_children():
		_apply_material_to_node(child, material)
