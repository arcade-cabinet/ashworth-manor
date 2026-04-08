extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var base_width: float = 5.6
@export var base_height: float = 3.2
@export var leaf_open_angle: float = 54.0
@export var bar_count: int = 5

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.65, scale.x),
		maxf(0.7, scale.y),
		maxf(0.65, scale.z)
	)
	scale = Vector3.ONE
	_build_gate()


func _build_gate() -> void:
	var gate_material := EstateMaterialKit.wrought_iron()
	var total_width := base_width * _baked_scale.x
	var height := base_height * _baked_scale.y
	var depth := 0.08 * _baked_scale.z
	var leaf_width := total_width * 0.5

	add_child(ShapeKit.box(
		"ThresholdPlate",
		Vector3(total_width * 0.98, 0.03, depth * 1.6),
		Vector3(0.0, 0.06, 0.0),
		gate_material
	))

	var hinge_left := Node3D.new()
	hinge_left.name = "DoorHingeLeft"
	hinge_left.position = Vector3(-leaf_width * 0.5, 0.0, 0.0)
	hinge_left.rotation_degrees.y = -leaf_open_angle
	add_child(hinge_left)

	var hinge_right := Node3D.new()
	hinge_right.name = "DoorHingeRight"
	hinge_right.position = Vector3(leaf_width * 0.5, 0.0, 0.0)
	hinge_right.rotation_degrees.y = leaf_open_angle
	add_child(hinge_right)

	_add_leaf(hinge_left, leaf_width, height, depth, gate_material, 1.0)
	_add_leaf(hinge_right, leaf_width, height, depth, gate_material, -1.0)


func _add_leaf(root: Node3D, leaf_width: float, height: float, depth: float, material: Material, direction: float) -> void:
	var frame_offset := direction * leaf_width * 0.5
	var rail_thickness := 0.09
	var stile_thickness := 0.08
	var bar_radius := 0.022
	var finial_radius := 0.04

	root.add_child(ShapeKit.box(
		"BottomRail",
		Vector3(leaf_width, rail_thickness, depth),
		Vector3(-direction * leaf_width * 0.5, 0.22, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"MidRail",
		Vector3(leaf_width * 0.96, rail_thickness * 0.8, depth),
		Vector3(-direction * leaf_width * 0.5, height * 0.48, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"TopRail",
		Vector3(leaf_width, rail_thickness, depth),
		Vector3(-direction * leaf_width * 0.5, height - 0.18, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"HingeStile",
		Vector3(stile_thickness, height, depth),
		Vector3(0.0, height * 0.5, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"LatchStile",
		Vector3(stile_thickness, height, depth),
		Vector3(-direction * leaf_width, height * 0.5, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"HingeStrapLower",
		Vector3(leaf_width * 0.2, 0.04, depth * 1.3),
		Vector3(-direction * leaf_width * 0.1, height * 0.28, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"HingeStrapUpper",
		Vector3(leaf_width * 0.2, 0.04, depth * 1.3),
		Vector3(-direction * leaf_width * 0.1, height * 0.72, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"LatchPlate",
		Vector3(leaf_width * 0.12, 0.16, depth * 1.3),
		Vector3(-direction * leaf_width * 0.94, height * 0.52, 0.0),
		material
	))
	root.add_child(ShapeKit.box(
		"KickBar",
		Vector3(leaf_width * 0.72, 0.03, depth * 1.24),
		Vector3(-direction * leaf_width * 0.5, 0.42, 0.0),
		material
	))

	for i in range(bar_count):
		var t := float(i + 1) / float(bar_count + 1)
		var x := lerpf(0.0, -direction * leaf_width, t)
		root.add_child(ShapeKit.cylinder(
			"Bar_%d" % i,
			bar_radius,
			height - 0.42,
			Vector3(x, height * 0.5, 0.0),
			material,
			6
		))
		root.add_child(ShapeKit.cylinder(
			"FinialStem_%d" % i,
			bar_radius * 0.72,
			0.28,
			Vector3(x, height + 0.02, 0.0),
			material,
			6
		))
		var finial := ShapeKit.sphere("Finial_%d" % i, finial_radius, Vector3(x, height + 0.18, 0.0), material)
		finial.scale = Vector3(0.72, 1.18, 0.72)
		root.add_child(finial)
