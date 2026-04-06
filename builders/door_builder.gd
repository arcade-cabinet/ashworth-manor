class_name DoorBuilder
extends RefCounted
## Generates interactive doors: frame + panel + hinge + AnimatableBody3D.
## Per INTERACTIVE_DOORS_PLAN.md.

const FRAME_POST_WIDTH := 0.1
const FRAME_DEPTH := 0.15
const DEFAULT_WIDTH := 1.0
const DEFAULT_HEIGHT := 2.2

## Build a door from a Connection declaration.
## Returns Node3D with frame, hinge, panel, and interaction area.
static func build(connection: Connection) -> Node3D:
	var door_root := Node3D.new()
	door_root.name = "Door_%s" % connection.id

	var frame_w := DEFAULT_WIDTH
	var frame_h := DEFAULT_HEIGHT

	# Adjust dimensions by door type
	match connection.type:
		"double_door":
			frame_w = 2.0
		"heavy_door":
			frame_h = 2.4
		"gate":
			frame_w = 1.8
			frame_h = 2.6

	# Build frame beams
	var frame := _build_frame(frame_w, frame_h, connection.frame_texture)
	door_root.add_child(frame)

	# Build door panel on hinge
	if connection.type == "double_door":
		_build_double_panel(door_root, frame_w, frame_h, connection.door_texture)
	else:
		_build_single_panel(door_root, frame_w, frame_h, connection.door_texture)

	# Connection Area3D -- player trigger zone
	var area := Area3D.new()
	area.name = "DoorArea"
	area.collision_layer = 8  # Layer 4 -- Connection
	area.collision_mask = 0
	area.set_meta("connection_id", connection.id)
	area.set_meta("target_room", connection.to_room)
	area.set_meta("locked", connection.locked)
	area.set_meta("key_id", connection.key_id)

	var area_shape := CollisionShape3D.new()
	var area_box := BoxShape3D.new()
	area_box.size = Vector3(frame_w + 0.5, frame_h, 1.0)
	area_shape.shape = area_box
	area_shape.position = Vector3(0, frame_h * 0.5, 0)
	area.add_child(area_shape)
	door_root.add_child(area)

	# Store connection data as metadata
	door_root.set_meta("connection", connection)

	return door_root


static func _build_frame(width: float, height: float, texture_path: String) -> Node3D:
	var frame := Node3D.new()
	frame.name = "DoorFrame"

	# Left post
	var left := _make_beam(
		Vector3(FRAME_POST_WIDTH, height, FRAME_DEPTH),
		Vector3(-width * 0.5 - FRAME_POST_WIDTH * 0.5, height * 0.5, 0),
		texture_path
	)
	left.name = "LeftPost"
	frame.add_child(left)

	# Right post
	var right := _make_beam(
		Vector3(FRAME_POST_WIDTH, height, FRAME_DEPTH),
		Vector3(width * 0.5 + FRAME_POST_WIDTH * 0.5, height * 0.5, 0),
		texture_path
	)
	right.name = "RightPost"
	frame.add_child(right)

	# Header
	var header := _make_beam(
		Vector3(width + FRAME_POST_WIDTH * 2, FRAME_POST_WIDTH, FRAME_DEPTH),
		Vector3(0, height + FRAME_POST_WIDTH * 0.5, 0),
		texture_path
	)
	header.name = "Header"
	frame.add_child(header)

	return frame


static func _build_single_panel(parent: Node3D, width: float, height: float, texture_path: String) -> void:
	# DoorHinge pivot at left edge
	var hinge := Node3D.new()
	hinge.name = "DoorHinge"
	hinge.position = Vector3(-width * 0.5, 0, 0)

	# Door panel offset from hinge
	var panel := MeshInstance3D.new()
	panel.name = "DoorPanel"
	var quad := QuadMesh.new()
	quad.size = Vector2(width, height)
	panel.mesh = quad
	panel.position = Vector3(width * 0.5, height * 0.5, 0)
	_apply_door_texture(panel, texture_path)

	hinge.add_child(panel)

	# AnimatableBody3D for physics-aware door
	var body := AnimatableBody3D.new()
	body.name = "DoorBody"
	body.collision_layer = 2  # Layer 2 -- Walls
	body.collision_mask = 0
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(width, height, 0.05)
	shape.shape = box
	shape.position = Vector3(width * 0.5, height * 0.5, 0)
	body.add_child(shape)
	hinge.add_child(body)

	parent.add_child(hinge)


static func _build_double_panel(parent: Node3D, total_width: float, height: float, texture_path: String) -> void:
	var panel_width := total_width * 0.5

	# Left hinge
	var hinge_l := Node3D.new()
	hinge_l.name = "DoorHingeLeft"
	hinge_l.position = Vector3(-total_width * 0.5, 0, 0)

	var panel_l := MeshInstance3D.new()
	panel_l.name = "DoorPanelLeft"
	var quad_l := QuadMesh.new()
	quad_l.size = Vector2(panel_width, height)
	panel_l.mesh = quad_l
	panel_l.position = Vector3(panel_width * 0.5, height * 0.5, 0)
	_apply_door_texture(panel_l, texture_path)
	hinge_l.add_child(panel_l)
	parent.add_child(hinge_l)

	# Right hinge
	var hinge_r := Node3D.new()
	hinge_r.name = "DoorHingeRight"
	hinge_r.position = Vector3(total_width * 0.5, 0, 0)

	var panel_r := MeshInstance3D.new()
	panel_r.name = "DoorPanelRight"
	var quad_r := QuadMesh.new()
	quad_r.size = Vector2(panel_width, height)
	panel_r.mesh = quad_r
	panel_r.position = Vector3(-panel_width * 0.5, height * 0.5, 0)
	_apply_door_texture(panel_r, texture_path)
	hinge_r.add_child(panel_r)
	parent.add_child(hinge_r)


static func _make_beam(size: Vector3, pos: Vector3, texture_path: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.position = pos
	if not texture_path.is_empty() and ResourceLoader.exists(texture_path):
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = load(texture_path)
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		mesh_inst.set_surface_override_material(0, mat)
	return mesh_inst


static func _apply_door_texture(panel: MeshInstance3D, texture_path: String) -> void:
	if texture_path.is_empty():
		return
	var mat := StandardMaterial3D.new()
	if ResourceLoader.exists(texture_path):
		mat.albedo_texture = load(texture_path)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	panel.set_surface_override_material(0, mat)
