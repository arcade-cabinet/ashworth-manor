class_name FloorBuilder
extends RefCounted
## Generates tiled floor geometry with walkable collision (Layer 1).

const TILE_SIZE := 2.0

## Build floor from room dimensions and texture.
## Returns Node3D with tiled QuadMesh + StaticBody3D collision.
static func build(
	room_width: float,
	room_depth: float,
	texture_path: String,
	footstep_surface: String
) -> Node3D:
	var floor_root := Node3D.new()
	floor_root.name = "Floor"

	# Tiled floor quads
	var tiles_x := ceili(room_width / TILE_SIZE)
	var tiles_z := ceili(room_depth / TILE_SIZE)
	var offset_x := (tiles_x * TILE_SIZE) * 0.5 - TILE_SIZE * 0.5
	var offset_z := (tiles_z * TILE_SIZE) * 0.5 - TILE_SIZE * 0.5

	var mat := _create_material(texture_path)

	for ix in range(tiles_x):
		for iz in range(tiles_z):
			var tile := MeshInstance3D.new()
			tile.name = "FloorTile_%d_%d" % [ix, iz]
			var quad := QuadMesh.new()
			quad.size = Vector2(TILE_SIZE, TILE_SIZE)
			quad.orientation = PlaneMesh.FACE_Y
			tile.mesh = quad
			tile.position = Vector3(
				ix * TILE_SIZE - offset_x,
				0.0,
				iz * TILE_SIZE - offset_z
			)
			if mat:
				tile.set_surface_override_material(0, mat)
			floor_root.add_child(tile)

	# Collision -- single box for whole floor
	var body := StaticBody3D.new()
	body.name = "FloorCollision"
	body.collision_layer = 1  # Layer 1 -- Walkable floor
	body.collision_mask = 0

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(room_width, 0.2, room_depth)
	shape.shape = box
	shape.position = Vector3(0, -0.1, 0)
	body.add_child(shape)

	# Tag floor collision with footstep surface for godot-material-footsteps
	body.set_meta("footstep_surface", footstep_surface)

	floor_root.add_child(body)
	return floor_root


static func _create_material(texture_path: String) -> StandardMaterial3D:
	if texture_path.is_empty():
		return null
	var mat := StandardMaterial3D.new()
	if ResourceLoader.exists(texture_path):
		mat.albedo_texture = load(texture_path)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mat.uv1_scale = Vector3(1, 1, 1)
	return mat
