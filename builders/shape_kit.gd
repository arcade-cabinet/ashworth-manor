class_name ShapeKit
extends RefCounted
## Reusable primitive-shape helpers for PSX-style authored setpieces.


static func box(name: String, size: Vector3, position: Vector3, material: Material = null) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.position = position
	if material != null:
		node.set_surface_override_material(0, material)
	return node


static func cylinder(name: String, radius: float, height: float, position: Vector3,
		material: Material = null, radial_segments: int = 10) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = radial_segments
	node.mesh = mesh
	node.position = position
	if material != null:
		node.set_surface_override_material(0, material)
	return node


static func sphere(name: String, radius: float, position: Vector3, material: Material = null) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	node.mesh = mesh
	node.position = position
	if material != null:
		node.set_surface_override_material(0, material)
	return node


static func label(name: String, text: String, font: Font, font_size: int, pixel_size: float,
		position: Vector3, rotation_degrees: Vector3, color: Color,
		outline_color: Color, outline_size: int) -> Label3D:
	var node := Label3D.new()
	node.name = name
	node.text = text
	node.font = font
	node.font_size = font_size
	node.pixel_size = pixel_size
	node.position = position
	node.rotation_degrees = rotation_degrees
	node.modulate = color
	node.outline_modulate = outline_color
	node.outline_size = outline_size
	node.double_sided = false
	node.shaded = false
	node.no_depth_test = false
	return node
