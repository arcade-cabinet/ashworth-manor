class_name TrapdoorBuilder
extends RefCounted
## Generates floor hatch with hinge on one edge (rotates on X axis).

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")

const DEFAULT_SIZE := 1.0
const FRAME_WIDTH := 0.08

## Build a trapdoor from a Connection declaration.
## Returns Node3D with frame, panel on hinge, and interaction zone.
static func build(connection: Connection, frame_surface_ref: String = "", panel_surface_ref: String = "") -> Node3D:
	var trapdoor_root := Node3D.new()
	trapdoor_root.name = "Trapdoor_%s" % connection.id

	# Floor-level frame
	var frame := _build_frame(frame_surface_ref if not frame_surface_ref.is_empty() else connection.frame_texture)
	trapdoor_root.add_child(frame)

	# Trapdoor panel on hinge (hinge at north edge, opens toward south)
	var hinge := Node3D.new()
	hinge.name = "TrapdoorHinge"
	hinge.position = Vector3(0, 0, -DEFAULT_SIZE * 0.5)

	var panel := MeshInstance3D.new()
	panel.name = "TrapdoorPanel"
	var quad := QuadMesh.new()
	quad.size = Vector2(DEFAULT_SIZE, DEFAULT_SIZE)
	quad.orientation = PlaneMesh.FACE_Y
	panel.mesh = quad
	panel.position = Vector3(0, 0, DEFAULT_SIZE * 0.5)
	_apply_texture(panel, panel_surface_ref if not panel_surface_ref.is_empty() else connection.door_texture)

	# AnimatableBody3D for physics
	var body := AnimatableBody3D.new()
	body.name = "TrapdoorBody"
	body.collision_layer = 1  # Layer 1 -- Floor initially
	body.collision_mask = 0
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(DEFAULT_SIZE, 0.05, DEFAULT_SIZE)
	shape.shape = box
	shape.position = Vector3(0, 0, DEFAULT_SIZE * 0.5)
	body.add_child(shape)

	hinge.add_child(panel)
	hinge.add_child(body)
	trapdoor_root.add_child(hinge)

	# Connection Area3D below the hatch
	var area := Area3D.new()
	area.name = "TrapdoorArea"
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
	area_box.size = connection.interaction_size if connection.interaction_size != Vector3.ZERO else Vector3(DEFAULT_SIZE, 0.5, DEFAULT_SIZE)
	area_shape.shape = area_box
	area_shape.position = Vector3(0, -0.25, 0)
	area.add_child(area_shape)
	trapdoor_root.add_child(area)
	trapdoor_root.set_meta("resolved_threshold_surface", frame_surface_ref if not frame_surface_ref.is_empty() else connection.frame_texture)
	trapdoor_root.set_meta("resolved_panel_surface", panel_surface_ref if not panel_surface_ref.is_empty() else connection.door_texture)

	return trapdoor_root


static func _build_frame(surface_ref: String) -> Node3D:
	var frame := Node3D.new()
	frame.name = "TrapdoorFrame"

	var beams := [
		Vector3(DEFAULT_SIZE + FRAME_WIDTH * 2, FRAME_WIDTH, FRAME_WIDTH),  # North
		Vector3(DEFAULT_SIZE + FRAME_WIDTH * 2, FRAME_WIDTH, FRAME_WIDTH),  # South
		Vector3(FRAME_WIDTH, FRAME_WIDTH, DEFAULT_SIZE),                     # East
		Vector3(FRAME_WIDTH, FRAME_WIDTH, DEFAULT_SIZE),                     # West
	]
	var positions := [
		Vector3(0, 0, -DEFAULT_SIZE * 0.5),
		Vector3(0, 0, DEFAULT_SIZE * 0.5),
		Vector3(DEFAULT_SIZE * 0.5, 0, 0),
		Vector3(-DEFAULT_SIZE * 0.5, 0, 0),
	]

	for i in range(4):
		var beam := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = beams[i]
		beam.mesh = box
		beam.position = positions[i]
		if not surface_ref.is_empty():
			var mat := EstateMaterialKit.build_surface_reference(surface_ref)
			beam.set_surface_override_material(0, mat)
		frame.add_child(beam)

	return frame


static func _apply_texture(mesh: MeshInstance3D, surface_ref: String) -> void:
	if surface_ref.is_empty():
		return
	var mat := EstateMaterialKit.build_surface_reference(surface_ref, {"double_sided": true})
	mesh.set_surface_override_material(0, mat)
