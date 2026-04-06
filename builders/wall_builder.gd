class_name WallBuilder
extends RefCounted
## Generates textured wall geometry from RoomDeclaration layout strings.
## Each wall side is composed of 2m-wide segments.

const SEGMENT_WIDTH := 2.0
const WALL_HEIGHT := 2.4
const WALL_DEPTH := 0.15

## Build a wall from its layout string array.
## Returns Node3D containing all wall segments for one side.
static func build(
	wall_layout: PackedStringArray,
	wall_texture_path: String,
	direction: String,
	room_width: float,
	room_depth: float
) -> Node3D:
	var wall_root := Node3D.new()
	wall_root.name = "Wall_%s" % direction.capitalize()

	var segment_count := wall_layout.size()
	if segment_count == 0:
		return wall_root

	for i in range(segment_count):
		var segment_type := wall_layout[i]
		var local_x := (i * SEGMENT_WIDTH) - (segment_count * SEGMENT_WIDTH * 0.5) + SEGMENT_WIDTH * 0.5

		if segment_type == "wall":
			var panel := _make_wall_panel(wall_texture_path)
			panel.position = _get_segment_position(direction, local_x, room_width, room_depth)
			panel.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(panel)
		elif segment_type.begins_with("doorway:"):
			# Doorway opening — leave gap, door_builder handles the door
			var lintel := _make_lintel(wall_texture_path)
			lintel.position = _get_segment_position(direction, local_x, room_width, room_depth)
			lintel.position.y = WALL_HEIGHT - 0.4
			lintel.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(lintel)
		elif segment_type == "window" or segment_type == "window_boarded" or segment_type == "window_shuttered":
			# Window opening — wall below and above, window_builder handles insert
			var below := _make_half_panel(wall_texture_path, 0.9, 0.0)
			below.position = _get_segment_position(direction, local_x, room_width, room_depth)
			below.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(below)

			var above := _make_half_panel(wall_texture_path, 0.5, 1.9)
			above.position = _get_segment_position(direction, local_x, room_width, room_depth)
			above.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(above)

	# Collision for the entire wall
	var collision_body := StaticBody3D.new()
	collision_body.name = "WallCollision_%s" % direction.capitalize()
	collision_body.collision_layer = 2  # Layer 2 — Walls
	collision_body.collision_mask = 0

	var collision_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	var total_width := segment_count * SEGMENT_WIDTH
	box.size = Vector3(total_width, WALL_HEIGHT, WALL_DEPTH)
	collision_shape.shape = box

	var col_pos := _get_wall_center(direction, room_width, room_depth)
	col_pos.y = WALL_HEIGHT * 0.5
	collision_body.position = col_pos
	collision_body.rotation_degrees.y = _get_wall_rotation(direction)
	collision_body.add_child(collision_shape)
	wall_root.add_child(collision_body)

	return wall_root


static func _make_wall_panel(texture_path: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(SEGMENT_WIDTH, WALL_HEIGHT)
	mesh_inst.mesh = quad
	mesh_inst.position.y = WALL_HEIGHT * 0.5
	_apply_texture(mesh_inst, texture_path)
	return mesh_inst


static func _make_lintel(texture_path: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(SEGMENT_WIDTH, 0.4)
	mesh_inst.mesh = quad
	_apply_texture(mesh_inst, texture_path)
	return mesh_inst


static func _make_half_panel(texture_path: String, height: float, y_offset: float) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(SEGMENT_WIDTH, height)
	mesh_inst.mesh = quad
	mesh_inst.position.y = y_offset + height * 0.5
	_apply_texture(mesh_inst, texture_path)
	return mesh_inst


static func _apply_texture(mesh_inst: MeshInstance3D, texture_path: String) -> void:
	if texture_path.is_empty():
		return
	var mat := StandardMaterial3D.new()
	if ResourceLoader.exists(texture_path):
		mat.albedo_texture = load(texture_path)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh_inst.set_surface_override_material(0, mat)


static func _get_segment_position(direction: String, local_x: float, room_w: float, room_d: float) -> Vector3:
	match direction:
		"north":
			return Vector3(local_x, 0, -room_d * 0.5)
		"south":
			return Vector3(local_x, 0, room_d * 0.5)
		"east":
			return Vector3(room_w * 0.5, 0, local_x)
		"west":
			return Vector3(-room_w * 0.5, 0, local_x)
	return Vector3.ZERO


static func _get_wall_center(direction: String, room_w: float, room_d: float) -> Vector3:
	match direction:
		"north":
			return Vector3(0, 0, -room_d * 0.5)
		"south":
			return Vector3(0, 0, room_d * 0.5)
		"east":
			return Vector3(room_w * 0.5, 0, 0)
		"west":
			return Vector3(-room_w * 0.5, 0, 0)
	return Vector3.ZERO


static func _get_wall_rotation(direction: String) -> float:
	match direction:
		"north":
			return 180.0
		"south":
			return 0.0
		"east":
			return -90.0
		"west":
			return 90.0
	return 0.0
