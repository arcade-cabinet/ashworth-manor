class_name StairsBuilder
extends RefCounted
## Generates staircase geometry with side boxing and collision.

const STEP_HEIGHT := 0.2
const STEP_DEPTH := 0.3
const DEFAULT_WIDTH := 1.2

## Build a staircase from a Connection declaration.
## Returns Node3D with steps, side walls, and collision.
static func build(connection: Connection, height: float = 2.4) -> Node3D:
	var stairs_root := Node3D.new()
	stairs_root.name = "Stairs_%s" % connection.id

	var step_count := ceili(height / STEP_HEIGHT)
	var total_depth := step_count * STEP_DEPTH

	# Generate steps
	for i in range(step_count):
		var step := _make_step(i, DEFAULT_WIDTH)
		stairs_root.add_child(step)

	# Side boxing (left wall)
	var side_l := _make_side_wall(step_count, height, total_depth, -DEFAULT_WIDTH * 0.5 - 0.05)
	side_l.name = "SideLeft"
	stairs_root.add_child(side_l)

	# Side boxing (right wall)
	var side_r := _make_side_wall(step_count, height, total_depth, DEFAULT_WIDTH * 0.5 + 0.05)
	side_r.name = "SideRight"
	stairs_root.add_child(side_r)

	# Stair collision -- ramp approximation
	var body := StaticBody3D.new()
	body.name = "StairsCollision"
	body.collision_layer = 1  # Layer 1 -- Walkable
	body.collision_mask = 0

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(DEFAULT_WIDTH, height, total_depth)
	shape.shape = box
	shape.position = Vector3(0, height * 0.5, total_depth * 0.5)
	# Rotate to form a ramp
	var angle := atan2(height, total_depth)
	shape.rotation.x = -angle
	body.add_child(shape)
	stairs_root.add_child(body)

	return stairs_root


static func _make_step(index: int, width: float) -> MeshInstance3D:
	var step := MeshInstance3D.new()
	step.name = "Step_%d" % index
	var box := BoxMesh.new()
	box.size = Vector3(width, STEP_HEIGHT, STEP_DEPTH)
	step.mesh = box
	step.position = Vector3(
		0,
		index * STEP_HEIGHT + STEP_HEIGHT * 0.5,
		index * STEP_DEPTH + STEP_DEPTH * 0.5
	)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.22, 0.15)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	step.set_surface_override_material(0, mat)

	return step


static func _make_side_wall(step_count: int, height: float, depth: float, x_offset: float) -> MeshInstance3D:
	var wall := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(depth, height)
	wall.mesh = quad
	wall.position = Vector3(x_offset, height * 0.5, depth * 0.5)
	wall.rotation_degrees.y = 90.0 if x_offset > 0 else -90.0

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.2, 0.15)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	wall.set_surface_override_material(0, mat)

	return wall
