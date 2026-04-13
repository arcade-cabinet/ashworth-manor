class_name WallBuilder
extends RefCounted
## Generates textured wall geometry from RoomDeclaration layout strings.
## Each wall side is composed of 2m-wide segments.

const SEGMENT_WIDTH := 2.0
const DEFAULT_WALL_HEIGHT := 2.4
const WALL_DEPTH := 0.15
const DOOR_OPENING_WIDTH := 1.15
const DOOR_OPENING_HEIGHT := 2.2
const WINDOW_OPENING_WIDTH := 1.2
const WINDOW_BOTTOM_Y := 1.0
const WINDOW_HEIGHT := 1.0
const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")

## Build a wall from its layout string array.
## Returns Node3D containing all wall segments for one side.
static func build(
	wall_layout: PackedStringArray,
	wall_texture_path: String,
	direction: String,
	room_width: float,
	room_depth: float,
	room_height: float = DEFAULT_WALL_HEIGHT
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
			var panel := _make_wall_panel(wall_texture_path, room_height)
			panel.position = _get_segment_position(direction, local_x, room_width, room_depth)
			panel.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(panel)
		elif segment_type.begins_with("doorway:"):
			var doorway := _make_doorway_panel(wall_texture_path, room_height)
			doorway.position = _get_segment_position(direction, local_x, room_width, room_depth)
			doorway.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(doorway)
		elif segment_type == "window" or segment_type == "window_boarded" or segment_type == "window_shuttered":
			var window_wall := _make_window_panel(wall_texture_path, room_height)
			window_wall.position = _get_segment_position(direction, local_x, room_width, room_depth)
			window_wall.rotation_degrees.y = _get_wall_rotation(direction)
			wall_root.add_child(window_wall)

	# Collision for the entire wall
	var collision_body := StaticBody3D.new()
	collision_body.name = "WallCollision_%s" % direction.capitalize()
	collision_body.collision_layer = 2  # Layer 2 -- Walls
	collision_body.collision_mask = 0

	var collision_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	var total_width := segment_count * SEGMENT_WIDTH
	box.size = Vector3(total_width, room_height, WALL_DEPTH)
	collision_shape.shape = box

	var col_pos := _get_wall_center(direction, room_width, room_depth)
	col_pos.y = room_height * 0.5
	collision_body.position = col_pos
	collision_body.rotation_degrees.y = _get_wall_rotation(direction)
	collision_body.add_child(collision_shape)
	wall_root.add_child(collision_body)

	return wall_root


static func _make_wall_panel(texture_path: String, room_height: float) -> Node3D:
	return _make_box_panel(
		Vector3(SEGMENT_WIDTH, room_height, WALL_DEPTH),
		Vector3(0, room_height * 0.5, 0),
		texture_path
	)


static func _make_lintel(texture_path: String) -> MeshInstance3D:
	return _make_box_panel(
		Vector3(SEGMENT_WIDTH, 0.4, WALL_DEPTH),
		Vector3(0, 0.2, 0),
		texture_path
	)


static func _make_doorway_panel(texture_path: String, room_height: float) -> Node3D:
	var doorway := Node3D.new()
	var jamb_width := maxf((SEGMENT_WIDTH - DOOR_OPENING_WIDTH) * 0.5, 0.2)
	var header_height := maxf(room_height - DOOR_OPENING_HEIGHT, 0.35)

	doorway.add_child(_make_box_panel(
		Vector3(jamb_width, room_height, WALL_DEPTH),
		Vector3(-SEGMENT_WIDTH * 0.5 + jamb_width * 0.5, room_height * 0.5, 0),
		texture_path
	))
	doorway.add_child(_make_box_panel(
		Vector3(jamb_width, room_height, WALL_DEPTH),
		Vector3(SEGMENT_WIDTH * 0.5 - jamb_width * 0.5, room_height * 0.5, 0),
		texture_path
	))
	doorway.add_child(_make_box_panel(
		Vector3(DOOR_OPENING_WIDTH, header_height, WALL_DEPTH),
		Vector3(0, DOOR_OPENING_HEIGHT + header_height * 0.5, 0),
		texture_path
	))
	return doorway


static func _make_window_panel(texture_path: String, room_height: float) -> Node3D:
	var panel := Node3D.new()
	var side_width := maxf((SEGMENT_WIDTH - WINDOW_OPENING_WIDTH) * 0.5, 0.2)
	var top_height := maxf(room_height - (WINDOW_BOTTOM_Y + WINDOW_HEIGHT), 0.35)

	panel.add_child(_make_box_panel(
		Vector3(SEGMENT_WIDTH, WINDOW_BOTTOM_Y, WALL_DEPTH),
		Vector3(0, WINDOW_BOTTOM_Y * 0.5, 0),
		texture_path
	))
	panel.add_child(_make_box_panel(
		Vector3(SEGMENT_WIDTH, top_height, WALL_DEPTH),
		Vector3(0, WINDOW_BOTTOM_Y + WINDOW_HEIGHT + top_height * 0.5, 0),
		texture_path
	))
	panel.add_child(_make_box_panel(
		Vector3(side_width, WINDOW_HEIGHT, WALL_DEPTH),
		Vector3(-SEGMENT_WIDTH * 0.5 + side_width * 0.5, WINDOW_BOTTOM_Y + WINDOW_HEIGHT * 0.5, 0),
		texture_path
	))
	panel.add_child(_make_box_panel(
		Vector3(side_width, WINDOW_HEIGHT, WALL_DEPTH),
		Vector3(SEGMENT_WIDTH * 0.5 - side_width * 0.5, WINDOW_BOTTOM_Y + WINDOW_HEIGHT * 0.5, 0),
		texture_path
	))
	return panel


static func _make_half_panel(texture_path: String, height: float, y_offset: float) -> MeshInstance3D:
	return _make_box_panel(
		Vector3(SEGMENT_WIDTH, height, WALL_DEPTH),
		Vector3(0, y_offset + height * 0.5, 0),
		texture_path
	)


static func _make_box_panel(size: Vector3, pos: Vector3, texture_path: String) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.position = pos
	_apply_texture(mesh_inst, texture_path)
	return mesh_inst


static func _apply_texture(mesh_inst: MeshInstance3D, texture_path: String) -> void:
	if texture_path.is_empty():
		return
	var mat := EstateMaterialKit.build_surface_reference(texture_path, {
		"roughness": 1.0,
	})
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
