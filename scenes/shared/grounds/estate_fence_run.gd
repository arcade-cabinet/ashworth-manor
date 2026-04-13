extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var run_length: float = 1.9
@export var fence_height: float = 1.7
@export var bar_count: int = 6

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.55, scale.x),
		maxf(0.72, scale.y),
		maxf(0.55, scale.z)
	)
	scale = Vector3.ONE
	_build()


func _build() -> void:
	var iron := EstateMaterialKit.wrought_iron()
	var length := run_length * _baked_scale.x
	var height := fence_height * _baked_scale.y
	var depth := 0.08 * _baked_scale.z
	var half_length := length * 0.5

	add_child(ShapeKit.box("BottomRail", Vector3(length, 0.08, depth), Vector3(0.0, 0.24, 0.0), iron))
	add_child(ShapeKit.box("MidRail", Vector3(length * 0.98, 0.06, depth), Vector3(0.0, height * 0.48, 0.0), iron))
	add_child(ShapeKit.box("TopRail", Vector3(length, 0.08, depth), Vector3(0.0, height - 0.16, 0.0), iron))
	add_child(ShapeKit.box("EndPostLeft", Vector3(0.08, height, depth), Vector3(-half_length, height * 0.5, 0.0), iron))
	add_child(ShapeKit.box("EndPostRight", Vector3(0.08, height, depth), Vector3(half_length, height * 0.5, 0.0), iron))

	for i in range(bar_count):
		var t := float(i + 1) / float(bar_count + 1)
		var x := lerpf(-half_length, half_length, t)
		add_child(ShapeKit.cylinder("Bar_%d" % i, 0.022, height - 0.36, Vector3(x, height * 0.5, 0.0), iron, 6))
		add_child(ShapeKit.cylinder("FinialStem_%d" % i, 0.016, 0.22, Vector3(x, height + 0.01, 0.0), iron, 6))
		var finial := ShapeKit.sphere("Finial_%d" % i, 0.035, Vector3(x, height + 0.14, 0.0), iron)
		finial.scale = Vector3(0.72, 1.16, 0.72)
		add_child(finial)
