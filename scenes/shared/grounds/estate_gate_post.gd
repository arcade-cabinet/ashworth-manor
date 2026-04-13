extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export_enum("brick", "stone") var material_mode := "brick"
@export var post_width: float = 0.82
@export var post_depth: float = 0.82
@export var post_height: float = 3.7

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
	var shaft_material := _build_shaft_material()
	var cap_material := _build_cap_material()
	var trim_material := EstateMaterialKit.oak_header()
	var width := post_width * _baked_scale.x
	var depth := post_depth * _baked_scale.z
	var height := post_height * _baked_scale.y

	add_child(ShapeKit.box(
		"Plinth",
		Vector3(width * 1.12, 0.24, depth * 1.12),
		Vector3(0.0, 0.12, 0.0),
		cap_material
	))
	add_child(ShapeKit.box(
		"Shaft",
		Vector3(width, height, depth),
		Vector3(0.0, 0.24 + height * 0.5, 0.0),
		shaft_material
	))
	add_child(ShapeKit.box(
		"BaseBand",
		Vector3(width * 1.04, 0.1, depth * 1.04),
		Vector3(0.0, 0.42, 0.0),
		cap_material
	))
	add_child(ShapeKit.box(
		"StringCourse",
		Vector3(width * 1.06, 0.12, depth * 1.06),
		Vector3(0.0, 0.24 + height * 0.58, 0.0),
		cap_material
	))
	add_child(ShapeKit.box(
		"Capital",
		Vector3(width * 1.1, 0.18, depth * 1.1),
		Vector3(0.0, 0.24 + height + 0.09, 0.0),
		cap_material
	))
	add_child(ShapeKit.box(
		"Cap",
		Vector3(width * 1.22, 0.16, depth * 1.22),
		Vector3(0.0, 0.24 + height + 0.25, 0.0),
		cap_material
	))
	add_child(ShapeKit.box(
		"CapLip",
		Vector3(width * 1.32, 0.06, depth * 1.32),
		Vector3(0.0, 0.24 + height + 0.36, 0.0),
		trim_material
	))


func _build_shaft_material() -> StandardMaterial3D:
	if material_mode == "stone":
		var stone := EstateMaterialKit.masonry_cap()
		stone.albedo_color = Color(0.5, 0.48, 0.47, 1.0)
		stone.roughness = 0.98
		return stone
	var brick := EstateMaterialKit.brick_masonry()
	brick.albedo_color = Color(0.44, 0.25, 0.21, 1.0)
	return brick


func _build_cap_material() -> StandardMaterial3D:
	var cap := EstateMaterialKit.masonry_cap()
	if material_mode == "stone":
		cap.albedo_color = Color(0.62, 0.6, 0.58, 1.0)
	else:
		cap.albedo_color = Color(0.68, 0.64, 0.6, 1.0)
	return cap
