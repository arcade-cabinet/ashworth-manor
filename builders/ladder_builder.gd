class_name LadderBuilder
extends RefCounted
## Generates ladder geometry (wall-mounted or drop-down).

const RUNG_SPACING := 0.3
const RUNG_WIDTH := 0.6
const RUNG_RADIUS := 0.025
const RAIL_WIDTH := 0.04

## Build a ladder from a Connection declaration.
## Returns Node3D with rails, rungs, and interaction zone.
static func build(connection: Connection, height: float = 2.4) -> Node3D:
	var ladder_root := Node3D.new()
	ladder_root.name = "Ladder_%s" % connection.id

	var rung_count := ceili(height / RUNG_SPACING)
	var visual := Node3D.new()
	visual.name = "LadderVisual"
	ladder_root.add_child(visual)

	# Left rail
	var rail_l := _make_rail(height, -RUNG_WIDTH * 0.5)
	rail_l.name = "RailLeft"
	visual.add_child(rail_l)

	# Right rail
	var rail_r := _make_rail(height, RUNG_WIDTH * 0.5)
	rail_r.name = "RailRight"
	visual.add_child(rail_r)

	# Rungs
	for i in range(rung_count):
		var rung := _make_rung(i)
		visual.add_child(rung)

	# Collision (thin box approximating the ladder)
	var body := StaticBody3D.new()
	body.name = "LadderCollision"
	body.collision_layer = 1  # Walkable (climbable)
	body.collision_mask = 0

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(RUNG_WIDTH + RAIL_WIDTH * 2, height, RAIL_WIDTH)
	shape.shape = box
	shape.position = Vector3(0, height * 0.5, 0)
	body.add_child(shape)
	ladder_root.add_child(body)

	# Connection Area3D
	var area := Area3D.new()
	area.name = "LadderArea"
	area.collision_layer = 8  # Layer 4 -- Connection
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
	area.set_meta("presentation_type", connection.presentation_type)
	area.set_meta("mechanism_type", connection.mechanism_type)
	area.set_meta("mechanism_state", connection.mechanism_state)
	area.set_meta("reveal_state", connection.reveal_state)

	var area_shape := CollisionShape3D.new()
	var area_box := BoxShape3D.new()
	area_box.size = connection.interaction_size if connection.interaction_size != Vector3.ZERO else Vector3(RUNG_WIDTH + 0.5, height, 1.0)
	area_shape.shape = area_box
	area_shape.position = Vector3(0, height * 0.5, 0.3)
	area.add_child(area_shape)
	ladder_root.add_child(area)

	return ladder_root


static func _make_rail(height: float, x_offset: float) -> MeshInstance3D:
	var rail := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(RAIL_WIDTH, height, RAIL_WIDTH)
	rail.mesh = box
	rail.position = Vector3(x_offset, height * 0.5, 0)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.35, 0.25, 0.15)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	rail.set_surface_override_material(0, mat)

	return rail


static func _make_rung(index: int) -> MeshInstance3D:
	var rung := MeshInstance3D.new()
	rung.name = "Rung_%d" % index
	var box := BoxMesh.new()
	box.size = Vector3(RUNG_WIDTH, RUNG_RADIUS * 2, RUNG_RADIUS * 2)
	rung.mesh = box
	rung.position = Vector3(0, (index + 1) * RUNG_SPACING, 0)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.4, 0.3, 0.2)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	rung.set_surface_override_material(0, mat)

	return rung
