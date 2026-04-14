extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")


func _ready() -> void:
	_build_cane()


func _build_cane() -> void:
	var wood := EstateMaterialKit.build_surface_reference("recipe:surface/oak_dark")
	var metal := EstateMaterialKit.build_surface_reference("recipe:surface/wrought_iron")

	var shaft := MeshInstance3D.new()
	shaft.name = "Shaft"
	var shaft_mesh := CylinderMesh.new()
	shaft_mesh.top_radius = 0.03
	shaft_mesh.bottom_radius = 0.034
	shaft_mesh.height = 1.08
	shaft.mesh = shaft_mesh
	shaft.position = Vector3(0, 0.54, 0)
	shaft.set_surface_override_material(0, wood)
	add_child(shaft)

	var handle := MeshInstance3D.new()
	handle.name = "Handle"
	var handle_mesh := TorusMesh.new()
	handle_mesh.inner_radius = 0.015
	handle_mesh.outer_radius = 0.12
	handle.mesh = handle_mesh
	handle.position = Vector3(0, 1.06, 0.08)
	handle.rotation_degrees = Vector3(90, 0, 0)
	handle.scale = Vector3(0.7, 0.38, 0.7)
	handle.set_surface_override_material(0, wood)
	add_child(handle)

	var tip := MeshInstance3D.new()
	tip.name = "Tip"
	var tip_mesh := CylinderMesh.new()
	tip_mesh.top_radius = 0.022
	tip_mesh.bottom_radius = 0.028
	tip_mesh.height = 0.1
	tip.mesh = tip_mesh
	tip.position = Vector3(0, 0.05, 0)
	tip.set_surface_override_material(0, metal)
	add_child(tip)
