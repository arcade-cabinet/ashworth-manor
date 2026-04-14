@tool
extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")


func _ready() -> void:
	if get_child_count() > 0:
		return
	_build()


func _build() -> void:
	var wood := EstateMaterialKit.build("recipe:surface/oak_dark")
	var brass := EstateMaterialKit.build("recipe:surface/brass")
	var paper := EstateMaterialKit.build("recipe:surface/paper")

	var base := _make_box(
		Vector3(0.42, 0.12, 0.28),
		Vector3(0.0, 0.06, 0.0),
		wood,
		"Base"
	)
	add_child(base)

	var lid := _make_box(
		Vector3(0.42, 0.05, 0.28),
		Vector3(0.0, 0.205, -0.06),
		wood,
		"Lid"
	)
	lid.rotation_degrees.x = -28.0
	add_child(lid)

	var hinge_bar := _make_box(
		Vector3(0.34, 0.02, 0.03),
		Vector3(0.0, 0.145, -0.145),
		brass,
		"HingeBar"
	)
	add_child(hinge_bar)

	var inner_panel := _make_box(
		Vector3(0.30, 0.02, 0.16),
		Vector3(0.0, 0.125, 0.01),
		paper,
		"InnerPanel"
	)
	add_child(inner_panel)

	var spindle := _make_cylinder(
		0.015,
		0.09,
		Vector3(0.0, 0.175, 0.0),
		brass,
		"Spindle"
	)
	add_child(spindle)

	var ballerina := _make_box(
		Vector3(0.028, 0.08, 0.028),
		Vector3(0.0, 0.255, 0.0),
		brass,
		"Ballerina"
	)
	add_child(ballerina)

	var skirt := _make_box(
		Vector3(0.065, 0.028, 0.065),
		Vector3(0.0, 0.215, 0.0),
		paper,
		"Skirt"
	)
	skirt.rotation_degrees.y = 45.0
	add_child(skirt)

	var key_post := _make_cylinder(
		0.012,
		0.05,
		Vector3(0.23, 0.08, 0.0),
		brass,
		"KeyPost"
	)
	key_post.rotation_degrees.z = 90.0
	add_child(key_post)

	var key_handle := _make_box(
		Vector3(0.05, 0.012, 0.05),
		Vector3(0.265, 0.08, 0.0),
		brass,
		"KeyHandle"
	)
	key_handle.rotation_degrees.z = 45.0
	add_child(key_handle)


func _make_box(size: Vector3, pos: Vector3, material: Material, node_name: String) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var inst := MeshInstance3D.new()
	inst.name = node_name
	inst.mesh = mesh
	inst.position = pos
	inst.set_surface_override_material(0, material)
	return inst


func _make_cylinder(radius: float, height: float, pos: Vector3, material: Material, node_name: String) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 12
	var inst := MeshInstance3D.new()
	inst.name = node_name
	inst.mesh = mesh
	inst.position = pos
	inst.set_surface_override_material(0, material)
	return inst
