extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.35, scale.x),
		maxf(0.5, scale.y),
		maxf(0.35, scale.z)
	)
	scale = Vector3.ONE
	_build_wall()


func _build_wall() -> void:
	var brick := EstateMaterialKit.brick_masonry()
	var cap := EstateMaterialKit.masonry_cap()
	var trim := EstateMaterialKit.oak_header()
	var length := 4.8 * _baked_scale.x
	var height := 3.4 * _baked_scale.y
	var depth := 0.72 * _baked_scale.z

	add_child(ShapeKit.box("Plinth", Vector3(length * 1.02, 0.22, depth * 1.08), Vector3(0.0, 0.11, 0.0), cap))
	add_child(ShapeKit.box("WallMass", Vector3(length, height, depth), Vector3(0.0, 0.22 + height * 0.5, 0.0), brick))
	add_child(ShapeKit.box("BaseBand", Vector3(length * 1.01, 0.12, depth * 1.06), Vector3(0.0, 0.34, 0.0), cap))
	add_child(ShapeKit.box("Cap", Vector3(length * 1.04, 0.18, depth * 1.12), Vector3(0.0, 0.22 + height + 0.09, 0.0), cap))
	add_child(ShapeKit.box("CapLip", Vector3(length * 1.12, 0.06, depth * 1.18), Vector3(0.0, 0.22 + height + 0.2, 0.0), trim))
	add_child(ShapeKit.box("StringCourse", Vector3(length * 1.01, 0.14, depth * 1.04), Vector3(0.0, 0.22 + height * 0.56, 0.0), cap))
	add_child(ShapeKit.box("FieldPanel", Vector3(length * 0.82, height * 0.44, depth * 0.16), Vector3(0.0, 0.22 + height * 0.42, depth * 0.38), cap))

	for side in PackedFloat32Array([-1.0, 1.0]):
		var pier_x := side * length * 0.42
		add_child(ShapeKit.box(
			"Pier_%s" % ("L" if side < 0.0 else "R"),
			Vector3(length * 0.08, height + 0.18, depth * 1.06),
			Vector3(pier_x, 0.22 + (height + 0.18) * 0.5, 0.0),
			cap
		))
		add_child(ShapeKit.box(
			"PierCap_%s" % ("L" if side < 0.0 else "R"),
			Vector3(length * 0.1, 0.12, depth * 1.16),
			Vector3(pier_x, 0.22 + height + 0.24, 0.0),
			cap
		))
