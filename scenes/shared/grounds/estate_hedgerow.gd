extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

var _hedge_material: Material
var _hedge_highlight_material: Material
var _hedge_shadow_material: Material
var _hedge_wall_material: Material
var _hedge_card_material: Material
var _hedge_card_highlight_material: Material
var _branch_material: Material
var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.42, scale.x),
		maxf(0.9, scale.y),
		maxf(0.34, scale.z)
	)
	scale = Vector3.ONE
	_init_materials()
	_build_row()


func _init_materials() -> void:
	var dark_bias := _variant_scalar("dark", -0.01, 0.025)
	var light_bias := _variant_scalar("light", -0.01, 0.035)

	_hedge_material = EstateMaterialKit.hedge(
		Color(0.33 + dark_bias * 0.03, 0.38 + light_bias * 0.04, 0.22 + dark_bias * 0.02, 1.0),
		Vector3(6.2, 6.6, 9.6),
		false
	)
	_hedge_highlight_material = EstateMaterialKit.hedge(
		Color(0.36 + dark_bias * 0.03, 0.42 + light_bias * 0.04, 0.25 + dark_bias * 0.02, 1.0),
		Vector3(5.8, 6.2, 9.0),
		true
	)
	_hedge_shadow_material = EstateMaterialKit.hedge(
		Color(0.24 + dark_bias * 0.02, 0.29 + light_bias * 0.025, 0.16 + dark_bias * 0.015, 1.0),
		Vector3(6.6, 7.0, 10.2),
		false
	)
	_hedge_wall_material = EstateMaterialKit.hedge_wall_panel(
		Color(0.54 + dark_bias * 0.05, 0.64 + light_bias * 0.06, 0.46 + dark_bias * 0.04, 1.0)
	)
	_hedge_card_material = EstateMaterialKit.hedge_card(
		Color(0.22 + dark_bias * 0.08, 0.3 + light_bias * 0.12, 0.15 + dark_bias * 0.04, 1.0),
		Vector3(1.0, 1.0, 1.0),
		false
	)
	_hedge_card_highlight_material = EstateMaterialKit.hedge_card(
		Color(0.24 + dark_bias * 0.04, 0.32 + light_bias * 0.08, 0.16 + dark_bias * 0.03, 1.0),
		Vector3(1.0, 1.0, 1.0),
		true
	)
	_branch_material = EstateMaterialKit.branch_dark()


func _build_row() -> void:
	var width_bias := _variant_scalar("width", -0.05, 0.09)
	var height_bias := _variant_scalar("height", -0.12, 0.24)
	var width := 2.0 * _baked_scale.x + width_bias
	var height := 5.1 * _baked_scale.y + height_bias
	var length := 9.4 * _baked_scale.z
	var half_length := length * 0.5
	var lower_height := height * 0.54
	var upper_height := height * 0.2
	var crown_height := height * 0.1
	var face_offset := width * 0.355

	add_child(ShapeKit.box("RootBed", Vector3(width * 1.16, 0.12, length * 1.06), Vector3(0.0, -0.03, 0.0), _branch_material))
	add_child(ShapeKit.box("LowerMass", Vector3(width * 0.92, lower_height, length * 0.996), Vector3(0.0, lower_height * 0.5, 0.0), _hedge_material))
	add_child(ShapeKit.box("UpperMass", Vector3(width * 0.86, upper_height, length * 0.992), Vector3(0.0, lower_height + upper_height * 0.5, 0.0), _hedge_material))
	add_child(ShapeKit.box("TopClip", Vector3(width * 0.74, crown_height, length * 0.986), Vector3(0.0, height - crown_height * 0.45, 0.0), _hedge_material))

	var bay_count := 5
	for i in range(bay_count):
		var t := 0.0 if bay_count == 1 else float(i) / float(bay_count - 1)
		var z := lerpf(-half_length + 1.0, half_length - 1.0, t)
		_add_bulge(
			"CrownBulge_%d" % i,
			Vector3(0.0, height * 0.92 + sin(t * PI) * 0.05, z),
			Vector3(width * 0.52, height * 0.1, 0.58 + _index_variant("crown_z", i) * 0.16),
			_hedge_highlight_material
		)
		for side in PackedFloat32Array([-1.0, 1.0]):
			_add_bulge(
				"%sShoulderBulge_%d" % ["Inner" if side > 0.0 else "Outer", i],
				Vector3(side * width * 0.23, height * 0.62 + cos(t * PI) * 0.04, z),
				Vector3(width * 0.26, height * 0.14, 0.64 + _index_variant("shoulder_z", i) * 0.16),
				_hedge_material if side < 0.0 else _hedge_highlight_material
			)

	_add_face_relief(width, height, length)
	_add_face_sprigs(width, height, length)

	for side in PackedFloat32Array([-1.0, 1.0]):
		var end_name := "Near" if side < 0.0 else "Far"
		var end_z := float(side) * (half_length - 0.3)
		add_child(ShapeKit.box(
			"EndCapBase_%s" % end_name,
			Vector3(width * 0.8, height * 0.56, 0.8),
			Vector3(0.0, height * 0.28, end_z),
			_hedge_material
		))
		var end_roll := ShapeKit.cylinder(
			"EndCapRoll_%s" % end_name,
			width * 0.18,
			width * 0.56,
			Vector3(0.0, height * 0.8, end_z),
			_hedge_highlight_material,
			12
		)
		end_roll.rotation_degrees.z = 90.0
		add_child(end_roll)
		_add_end_foliage(end_name, end_z, width, height)

	_add_face_panels(width, height, length)
	_add_top_card_belt(width, height, length)


func _add_face_panels(width: float, height: float, length: float) -> void:
	return


func _add_face_relief(width: float, height: float, length: float) -> void:
	for side in PackedFloat32Array([-1.0, 1.0]):
		var half_length := length * 0.5
		for i in range(4):
			var t := 0.0 if i == 0 else float(i) / 3.0
			var z := lerpf(-half_length + 0.95, half_length - 0.95, t)
			_add_bulge(
				"FaceBulge_%s_%d" % ["Outer" if side < 0.0 else "Inner", i],
				Vector3(
					side * width * (0.31 + _index_variant("face_x", i) * 0.04),
					height * (0.3 + _index_variant("face_y", i) * 0.2),
					z
				),
				Vector3(
					width * (0.12 + _index_variant("face_w", i) * 0.03),
					height * (0.08 + _index_variant("face_h", i) * 0.04),
					1.1 + _index_variant("face_z", i) * 0.28
				),
				_hedge_material
			)

	var half_length := length * 0.5
	for i in range(4):
		var t := 0.0 if i == 0 else float(i) / 3.0
		var z := lerpf(-half_length + 1.2, half_length - 1.2, t)
		_add_bulge(
			"CenterCrown_%d" % i,
			Vector3(0.0, height * 0.84, z),
			Vector3(width * 0.28, height * 0.08, 0.74 + _index_variant("center_z", i) * 0.16),
			_hedge_highlight_material
		)


func _add_top_card_belt(width: float, height: float, length: float) -> void:
	return


func _add_face_sprigs(width: float, height: float, length: float) -> void:
	var half_length := length * 0.5
	for side in PackedFloat32Array([-1.0, 1.0]):
		for row in range(2):
			for i in range(3):
				var t := float(i) / 2.0
				var z := lerpf(-half_length + 1.2, half_length - 1.2, t)
				var base_pos := Vector3(
					side * width * (0.405 + _index_variant("sprig_x_%d" % row, i) * 0.015),
					height * (0.44 + row * 0.15 + _index_variant("sprig_y_%d" % row, i) * 0.04),
					z
				)
				for cross in range(2):
					var outward := side * (0.03 + float(cross) * 0.015)
					var yaw := side * lerpf(76.0, 106.0, _index_variant("sprig_yaw_%d" % row, i + cross))
					_add_foliage_plane(
						"FaceSprig_%s_%d_%d_%d" % ["Outer" if side < 0.0 else "Inner", row, i, cross],
						width * 0.085,
						height * 0.09,
						base_pos + Vector3(outward, float(cross) * 0.03, (float(cross) - 0.5) * 0.08),
						yaw,
						_hedge_card_highlight_material if row == 0 else _hedge_card_material,
						lerpf(-8.0, 8.0, _index_variant("sprig_pitch_%d" % row, i + cross)),
						lerpf(-10.0, 10.0, _index_variant("sprig_roll_%d" % row, i + cross))
					)


func _add_end_foliage(end_name: String, end_z: float, width: float, height: float) -> void:
	for i in range(5):
		var x := lerpf(-width * 0.18, width * 0.18, float(i) / 4.0)
		_add_foliage_plane(
			"EndCard_%s_%d" % [end_name, i],
			width * 0.28,
			height * 0.22,
			Vector3(x, height * 0.46 + float(i) * 0.05, end_z),
			lerpf(-8.0, 8.0, float(i) / 4.0),
			_hedge_card_material,
			lerpf(-6.0, 4.0, float(i) / 4.0)
		)


func _variant_scalar(seed: String, min_value: float, max_value: float) -> float:
	var hash_value: int = abs(("%s_%s" % [name, seed]).hash())
	var normalized: float = float(hash_value % 991) / 990.0
	return lerpf(min_value, max_value, normalized)


func _index_variant(seed: String, index: int) -> float:
	var hash_value: int = abs(("%s_%s_%d" % [name, seed, index]).hash())
	return float(hash_value % 991) / 990.0


func _add_foliage_plane(
	node_name: String,
	width: float,
	height: float,
	position: Vector3,
	yaw: float,
	material: Material,
	pitch: float = 0.0,
	roll: float = 0.0
) -> void:
	var quad := MeshInstance3D.new()
	quad.name = node_name
	var mesh := QuadMesh.new()
	mesh.size = Vector2(width, height)
	quad.mesh = mesh
	quad.position = position
	quad.rotation_degrees = Vector3(pitch, yaw, roll)
	quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	quad.set_surface_override_material(0, material)
	add_child(quad)


func _add_bulge(node_name: String, position: Vector3, scale_3d: Vector3, material: Material) -> void:
	var bulge := ShapeKit.sphere(node_name, 0.5, position, material)
	bulge.scale = scale_3d
	add_child(bulge)
