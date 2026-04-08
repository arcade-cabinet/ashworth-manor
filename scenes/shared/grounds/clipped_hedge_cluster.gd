extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")
var _hedge_material: StandardMaterial3D
var _hedge_highlight_material: StandardMaterial3D
var _branch_material: StandardMaterial3D


func _ready() -> void:
	if get_child_count() > 0:
		return
	_init_materials()
	_build_cluster()


func _init_materials() -> void:
	var dark_bias := _variant_scalar("dark", -0.01, 0.028)
	var light_bias := _variant_scalar("light", -0.01, 0.04)

	_hedge_material = EstateMaterialKit.hedge(
		Color(0.18 + dark_bias, 0.24 + light_bias, 0.12 + dark_bias * 0.25, 1.0),
		Vector3(0.9, 0.62, 1.34),
		false
	)
	_hedge_highlight_material = EstateMaterialKit.hedge(
		Color(0.22 + dark_bias * 0.55, 0.3 + light_bias * 0.7, 0.14 + dark_bias * 0.18, 1.0),
		Vector3(0.84, 0.56, 1.18),
		true
	)
	_branch_material = EstateMaterialKit.branch_dark()


func _build_cluster() -> void:
	var height_shift := _variant_scalar("height_shift", -0.08, 0.12)
	var width_shift := _variant_scalar("width_shift", -0.26, 0.28)
	var face_depth := _variant_scalar("face_depth", -0.03, 0.14)
	var left_pull := _variant_scalar("left_pull", -0.18, 0.16)
	var right_pull := _variant_scalar("right_pull", -0.16, 0.18)
	var rear_tuck := _variant_scalar("rear_tuck", -0.14, 0.08)
	var lower_spread := _variant_scalar("lower_spread", -0.14, 0.18)

	add_child(ShapeKit.box("Bed", Vector3(3.62, 0.08, 1.18), Vector3(0.0, 0.04, 0.0), _branch_material))
	add_child(ShapeKit.box("LowerSkirt", Vector3(3.12 + lower_spread, 0.22, 0.94), Vector3(0.0, 0.18, 0.0), _hedge_material))
	add_child(ShapeKit.box("CoreMass", Vector3(2.88 + width_shift, 0.96 + height_shift, 0.72), Vector3(0.0, 0.63 + height_shift * 0.32, 0.0), _hedge_material))
	add_child(ShapeKit.box("FrontFace", Vector3(2.96 + width_shift * 0.82, 0.86 + height_shift * 0.22, 0.18), Vector3(0.0, 0.66 + height_shift * 0.16, 0.31 + face_depth), _hedge_highlight_material))
	add_child(ShapeKit.box("RearFace", Vector3(2.76 + width_shift * 0.48, 0.82 + height_shift * 0.18, 0.14), Vector3(0.0, 0.66 + height_shift * 0.16, -0.35 + rear_tuck), _hedge_material))
	add_child(ShapeKit.box("TopClip", Vector3(2.58 + width_shift * 0.45, 0.18, 0.62), Vector3(0.0, 1.16 + height_shift * 0.28, -0.01), _hedge_highlight_material))
	add_child(ShapeKit.box("ShoulderLeft", Vector3(0.4, 0.24, 0.62), Vector3(-1.16 + left_pull * 0.24, 1.0, 0.02), _hedge_material))
	add_child(ShapeKit.box("ShoulderRight", Vector3(0.4, 0.24, 0.62), Vector3(1.16 + right_pull * 0.24, 1.0, 0.02), _hedge_material))
	add_child(ShapeKit.box("EndCapLeft", Vector3(0.46, 0.74, 0.74), Vector3(-1.48 + left_pull * 0.44, 0.6, 0.0), _hedge_material))
	add_child(ShapeKit.box("EndCapRight", Vector3(0.46, 0.74, 0.74), Vector3(1.48 + right_pull * 0.44, 0.6, 0.0), _hedge_material))

	_add_sphere("TopCornerLeft", 0.12, Vector3(-1.02 + left_pull * 0.18, 1.16 + height_shift * 0.2, 0.03), Vector3(0.88, 0.52, 0.7), _hedge_highlight_material)
	_add_sphere("TopCornerRight", 0.12, Vector3(1.02 + right_pull * 0.18, 1.16 + height_shift * 0.2, 0.03), Vector3(0.88, 0.52, 0.7), _hedge_highlight_material)
	_add_sphere("FrontCenterSoftener", 0.12, Vector3(0.0, 0.78, 0.28 + face_depth * 0.7), Vector3(1.1, 0.62, 0.46), _hedge_highlight_material)

	_disable_shadows_recursive(self)


func _add_sphere(node_name: String, radius: float, position: Vector3, scale_value: Vector3, material: Material) -> void:
	var sphere := ShapeKit.sphere(node_name, radius, position, material)
	sphere.scale = scale_value
	add_child(sphere)


func _variant_scalar(seed: String, min_value: float, max_value: float) -> float:
	var hash_value: int = abs(("%s_%s" % [name, seed]).hash())
	var normalized: float = float(hash_value % 991) / 990.0
	return lerpf(min_value, max_value, normalized)


func _disable_shadows_recursive(node: Node) -> void:
	for child in node.get_children():
		if child is GeometryInstance3D:
			var geometry := child as GeometryInstance3D
			geometry.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_disable_shadows_recursive(child)
