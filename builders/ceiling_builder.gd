class_name CeilingBuilder
extends RefCounted
## Generates tiled ceiling geometry.

const TILE_SIZE := 2.0

## Build ceiling at room height from dimensions and texture.
## Returns Node3D with tiled QuadMesh (no collision needed for ceiling).
static func build(
	room_width: float,
	room_height: float,
	room_depth: float,
	texture_path: String
) -> Node3D:
	var ceiling_root := Node3D.new()
	ceiling_root.name = "Ceiling"

	var tiles_x := ceili(room_width / TILE_SIZE)
	var tiles_z := ceili(room_depth / TILE_SIZE)
	var offset_x := (tiles_x * TILE_SIZE) * 0.5 - TILE_SIZE * 0.5
	var offset_z := (tiles_z * TILE_SIZE) * 0.5 - TILE_SIZE * 0.5

	var mat := _create_material(texture_path)

	for ix in range(tiles_x):
		for iz in range(tiles_z):
			var tile := MeshInstance3D.new()
			tile.name = "CeilingTile_%d_%d" % [ix, iz]
			var quad := QuadMesh.new()
			quad.size = Vector2(TILE_SIZE, TILE_SIZE)
			quad.orientation = PlaneMesh.FACE_Y
			tile.mesh = quad
			tile.rotation_degrees.x = 180.0
			tile.position = Vector3(
				ix * TILE_SIZE - offset_x,
				room_height,
				iz * TILE_SIZE - offset_z
			)
			if mat:
				tile.set_surface_override_material(0, mat)
			ceiling_root.add_child(tile)

	# Ceiling collision for raycast blocking
	var body := StaticBody3D.new()
	body.name = "CeilingCollision"
	body.collision_layer = 2  # Layer 2 -- Walls/ceiling
	body.collision_mask = 0

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(room_width, 0.2, room_depth)
	shape.shape = box
	shape.position = Vector3(0, room_height + 0.1, 0)
	body.add_child(shape)
	ceiling_root.add_child(body)

	return ceiling_root


static func _create_material(texture_path: String) -> StandardMaterial3D:
	if texture_path.is_empty():
		return null
	var mat := StandardMaterial3D.new()
	var resolved_path := _resolve_texture_path(texture_path)
	if ResourceLoader.exists(resolved_path):
		mat.albedo_texture = load(resolved_path)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return mat


static func _resolve_texture_path(texture_path: String) -> String:
	if texture_path.begins_with("res://"):
		return texture_path
	return "res://assets/shared/textures/%s.png" % texture_path

