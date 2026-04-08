extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var forecourt_width: float = 10.6
@export var step_count: int = 3
@export var tread_depth: float = 1.0
@export var landing_depth: float = 2.25
@export var riser_height: float = 0.22

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.7, scale.x),
		maxf(0.8, scale.y),
		maxf(0.7, scale.z)
	)
	scale = Vector3.ONE
	_build()


func _build() -> void:
	var stone := EstateMaterialKit.masonry_cap()
	var brick := EstateMaterialKit.brick_masonry()
	var total_depth := (landing_depth + tread_depth * float(step_count)) * _baked_scale.z
	var width := forecourt_width * _baked_scale.x
	var riser := riser_height * _baked_scale.y
	var front_edge := -total_depth * 0.5

	add_child(ShapeKit.box(
		"Subgrade",
		Vector3(width * 1.08, 0.24, total_depth * 1.04),
		Vector3(0.0, -0.1, front_edge + total_depth * 0.5),
		brick
	))

	for i in range(step_count):
		var tier_depth := landing_depth * _baked_scale.z + tread_depth * _baked_scale.z * float(step_count - i)
		var tier_height := riser * float(i + 1)
		var tier_z := front_edge + tier_depth * 0.5
		add_child(ShapeKit.box(
			"StepTier_%d" % i,
			Vector3(width, tier_height, tier_depth),
			Vector3(0.0, tier_height * 0.5, tier_z),
			stone
		))
		add_child(ShapeKit.box(
			"StepNose_%d" % i,
			Vector3(width * 1.01, 0.035, tread_depth * _baked_scale.z * 0.16),
			Vector3(0.0, tier_height + 0.018, front_edge + tier_depth - tread_depth * _baked_scale.z * 0.08),
			brick
		))

	var landing_z := front_edge + (landing_depth * _baked_scale.z) * 0.5 + tread_depth * _baked_scale.z * float(step_count)
	add_child(ShapeKit.box(
		"LandingCap",
		Vector3(width * 1.02, 0.12, landing_depth * _baked_scale.z * 1.02),
		Vector3(0.0, riser * float(step_count) + 0.06, landing_z),
		stone
	))
	add_child(ShapeKit.box(
		"LandingBand",
		Vector3(width * 0.92, 0.035, landing_depth * _baked_scale.z * 0.12),
		Vector3(0.0, riser * float(step_count) + 0.08, landing_z + landing_depth * _baked_scale.z * 0.32),
		brick
	))
	add_child(ShapeKit.box(
		"LandingFieldJoint",
		Vector3(width * 0.02, 0.02, landing_depth * _baked_scale.z * 0.88),
		Vector3(0.0, riser * float(step_count) + 0.08, landing_z),
		brick
	))

	for side in PackedFloat32Array([-1.0, 1.0]):
		var cheek_x := side * (width * 0.5 + 0.34)
		add_child(ShapeKit.box(
			"CheekWall_%s" % ("L" if side < 0.0 else "R"),
			Vector3(0.42, riser * float(step_count) + 0.5, total_depth * 0.92),
			Vector3(cheek_x, (riser * float(step_count) + 0.5) * 0.5 - 0.02, front_edge + total_depth * 0.48),
			brick
		))
		add_child(ShapeKit.box(
			"CheekCap_%s" % ("L" if side < 0.0 else "R"),
			Vector3(0.5, 0.1, total_depth * 0.96),
			Vector3(cheek_x, riser * float(step_count) + 0.52, front_edge + total_depth * 0.48),
			stone
		))
		add_child(ShapeKit.box(
			"CheekPlinth_%s" % ("L" if side < 0.0 else "R"),
			Vector3(0.56, 0.16, total_depth * 0.28),
			Vector3(cheek_x, 0.08, front_edge + total_depth * 0.78),
			stone
		))
