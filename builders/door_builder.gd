class_name DoorBuilder
extends RefCounted
## Generates interactive doors: frame + panel + hinge + AnimatableBody3D.
## Per INTERACTIVE_DOORS_PLAN.md.

const ArchModelFitter = preload("res://builders/arch_model_fitter.gd")
const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")

const FRAME_POST_WIDTH := 0.1
const FRAME_DEPTH := 0.15
const DEFAULT_WIDTH := 1.0
const DEFAULT_HEIGHT := 2.2
## Build a door from a Connection declaration.
## Returns Node3D with frame, hinge, panel, and interaction area.
static func build(connection: Connection, frame_surface_ref: String = "", panel_surface_ref: String = "") -> Node3D:
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
	var frame := _build_frame(frame_w, frame_h, connection.frame_texture, frame_surface_ref)
	door_root.add_child(frame)

	# Build door panel on hinge
	if connection.type == "double_door":
		_build_double_panel(door_root, frame_w, frame_h, connection.door_texture, panel_surface_ref)
	else:
		_build_single_panel(door_root, frame_w, frame_h, connection.door_texture, panel_surface_ref)

	# Connection Area3D -- player trigger zone
	var area := Area3D.new()
	area.name = "DoorArea"
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
	area_box.size = connection.interaction_size if connection.interaction_size != Vector3.ZERO else Vector3(frame_w + 0.5, frame_h, 1.0)
	area_shape.shape = area_box
	area_shape.position = Vector3(0, frame_h * 0.5, 0)
	area.add_child(area_shape)
	door_root.add_child(area)

	# Store connection data as metadata
	door_root.set_meta("connection", connection)
	door_root.set_meta("resolved_threshold_surface", frame_surface_ref if not frame_surface_ref.is_empty() else connection.frame_texture)
	door_root.set_meta("resolved_panel_surface", panel_surface_ref if not panel_surface_ref.is_empty() else connection.door_texture)

	return door_root


static func _build_frame(width: float, height: float, model_selector: String, surface_ref: String = "") -> Node3D:
	var material_ref := surface_ref if not surface_ref.is_empty() else model_selector
	var model_path := _resolve_frame_model(model_selector)
	if not model_path.is_empty() and ResourceLoader.exists(model_path):
		var scene: PackedScene = load(model_path)
		if scene != null:
			var inst := scene.instantiate()
			var target_size := Vector3(width + FRAME_POST_WIDTH * 2.0, height + FRAME_POST_WIDTH, FRAME_DEPTH)
			var fitted := ArchModelFitter.fit(inst, target_size)
			fitted.name = "DoorFrame"
			_apply_material_recursive(fitted, material_ref)
			return fitted

	var frame := Node3D.new()
	frame.name = "DoorFrame"

	# Left post
	var left := _make_beam(
		Vector3(FRAME_POST_WIDTH, height, FRAME_DEPTH),
		Vector3(-width * 0.5 - FRAME_POST_WIDTH * 0.5, height * 0.5, 0),
		material_ref
	)
	left.name = "LeftPost"
	frame.add_child(left)

	# Right post
	var right := _make_beam(
		Vector3(FRAME_POST_WIDTH, height, FRAME_DEPTH),
		Vector3(width * 0.5 + FRAME_POST_WIDTH * 0.5, height * 0.5, 0),
		material_ref
	)
	right.name = "RightPost"
	frame.add_child(right)

	# Header
	var header := _make_beam(
		Vector3(width + FRAME_POST_WIDTH * 2, FRAME_POST_WIDTH, FRAME_DEPTH),
		Vector3(0, height + FRAME_POST_WIDTH * 0.5, 0),
		material_ref
	)
	header.name = "Header"
	frame.add_child(header)

	return frame


static func _build_single_panel(parent: Node3D, width: float, height: float, model_selector: String, surface_ref: String = "") -> void:
	# DoorHinge pivot at left edge
	var hinge := Node3D.new()
	hinge.name = "DoorHinge"
	hinge.position = Vector3(-width * 0.5, 0, 0)

	# Door panel offset from hinge
	var panel := _make_door_panel(width, height, model_selector, surface_ref)
	panel.name = "DoorPanel"
	panel.position = Vector3(width * 0.5, 0, 0)

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


static func _build_double_panel(parent: Node3D, total_width: float, height: float, model_selector: String, surface_ref: String = "") -> void:
	var panel_width := total_width * 0.5

	# Left hinge
	var hinge_l := Node3D.new()
	hinge_l.name = "DoorHingeLeft"
	hinge_l.position = Vector3(-total_width * 0.5, 0, 0)

	var panel_l := _make_door_panel(panel_width, height, model_selector, surface_ref)
	panel_l.name = "DoorPanelLeft"
	panel_l.position = Vector3(panel_width * 0.5, 0, 0)
	hinge_l.add_child(panel_l)
	parent.add_child(hinge_l)

	# Right hinge
	var hinge_r := Node3D.new()
	hinge_r.name = "DoorHingeRight"
	hinge_r.position = Vector3(total_width * 0.5, 0, 0)

	var panel_r := _make_door_panel(panel_width, height, model_selector, surface_ref)
	panel_r.name = "DoorPanelRight"
	panel_r.position = Vector3(-panel_width * 0.5, 0, 0)
	hinge_r.add_child(panel_r)
	parent.add_child(hinge_r)


static func _make_beam(size: Vector3, pos: Vector3, surface_ref: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.position = pos
	if not surface_ref.is_empty():
		var mat := EstateMaterialKit.build_surface_reference(surface_ref)
		mesh_inst.set_surface_override_material(0, mat)
	return mesh_inst


static func _apply_door_texture(panel: MeshInstance3D, surface_ref: String) -> void:
	if surface_ref.is_empty():
		return
	var mat := EstateMaterialKit.build_surface_reference(surface_ref, {"double_sided": true})
	panel.set_surface_override_material(0, mat)


static func _make_door_panel(width: float, height: float, model_selector: String, surface_ref: String = "") -> Node3D:
	var material_ref := surface_ref if not surface_ref.is_empty() else model_selector
	var model_path := _resolve_panel_model(model_selector)
	if not model_path.is_empty() and ResourceLoader.exists(model_path):
		var scene: PackedScene = load(model_path)
		if scene != null:
			var inst := scene.instantiate()
			var wrapper := ArchModelFitter.fit(inst, Vector3(width, height, 0.05))
			wrapper.name = "DoorPanelWrapper"
			_apply_material_recursive(wrapper, material_ref, {"double_sided": true})
			return wrapper
	var wrapper := Node3D.new()
	wrapper.name = "DoorPanelWrapper"
	var panel := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(width, height, 0.05)
	panel.mesh = box
	panel.position = Vector3(0, height * 0.5, 0)
	_apply_door_texture(panel, material_ref)
	wrapper.add_child(panel)
	return wrapper


static func _resolve_frame_model(texture_path: String) -> String:
	var idx := _extract_texture_index(texture_path)
	if idx.is_empty():
		return ""
	return "res://assets/shared/structure/doorway%s.glb" % int(idx)


static func _resolve_panel_model(texture_path: String) -> String:
	if texture_path.find("door1") != -1:
		return "res://assets/shared/structure/door1.glb"
	if texture_path.find("door") != -1:
		return "res://assets/shared/structure/door.glb"
	return ""


static func _extract_texture_index(texture_path: String) -> String:
	if texture_path.begins_with("res://"):
		var file := texture_path.get_file()
		var stem := file.get_basename()
		if stem.begins_with("door_texture_"):
			return stem.trim_prefix("door_texture_")
	if texture_path.begins_with("wall"):
		return texture_path.trim_prefix("wall").trim_suffix("_texture")
	return ""


static func _apply_material_recursive(root: Node, surface_ref: String, options: Dictionary = {}) -> void:
	if root == null or surface_ref.is_empty():
		return
	var material := EstateMaterialKit.build_surface_reference(surface_ref, options)
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
