extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var facade_width: float = 30.0
@export var facade_depth: float = 1.24
@export var lower_story_height: float = 5.4
@export var upper_story_height: float = 4.8

var _brick: Material
var _stone: Material
var _trim_dark: Material
var _iron: Material
var _void: StandardMaterial3D
var _glass_dark: Material
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
	_init_materials()
	_build_facade()


func _init_materials() -> void:
	_brick = EstateMaterialKit.brick_masonry()
	_stone = EstateMaterialKit.masonry_cap()
	_trim_dark = EstateMaterialKit.oak_header()
	_iron = EstateMaterialKit.wrought_iron()
	_void = EstateMaterialKit.shadow_void_tinted(Color(0.03, 0.03, 0.05, 1.0))
	_glass_dark = EstateMaterialKit.facade_dark_glass()


func _build_facade() -> void:
	var width := facade_width * _baked_scale.x
	var depth := facade_depth * _baked_scale.z
	var lower_h := lower_story_height * _baked_scale.y
	var upper_h := upper_story_height * _baked_scale.y
	var total_h := lower_h + upper_h
	var front_z := depth * 0.5
	var face_z := depth - 0.06

	add_child(ShapeKit.box("Plinth", Vector3(width * 1.02, 0.48, depth * 1.08), Vector3(0.0, 0.24, front_z), _stone))
	add_child(ShapeKit.box("BasePlinthBand", Vector3(width * 1.03, 0.18, depth * 1.14), Vector3(0.0, 0.66, front_z + depth * 0.08), _stone))
	add_child(ShapeKit.box("LowerWall", Vector3(width, lower_h, depth), Vector3(0.0, 0.48 + lower_h * 0.5, front_z), _brick))
	add_child(ShapeKit.box("RusticationBandLower", Vector3(width * 1.01, 0.18, depth * 1.12), Vector3(0.0, 1.08, front_z + depth * 0.08), _stone))
	add_child(ShapeKit.box("RusticationBandMid", Vector3(width * 0.99, 0.16, depth * 1.08), Vector3(0.0, 2.18, front_z + depth * 0.06), _stone))
	add_child(ShapeKit.box("RusticationBandUpper", Vector3(width * 0.98, 0.14, depth * 1.06), Vector3(0.0, 3.26, front_z + depth * 0.05), _stone))
	add_child(ShapeKit.box("StringCourse", Vector3(width * 1.01, 0.2, depth * 1.04), Vector3(0.0, 0.48 + lower_h + 0.1, front_z), _stone))
	add_child(ShapeKit.box("UpperWall", Vector3(width * 0.98, upper_h, depth * 0.96), Vector3(0.0, 0.68 + lower_h + upper_h * 0.5, front_z), _brick))
	add_child(ShapeKit.box("Cornice", Vector3(width * 1.03, 0.28, depth * 1.12), Vector3(0.0, 0.68 + total_h + 0.14, front_z), _stone))
	add_child(ShapeKit.box("Parapet", Vector3(width * 0.94, 0.74, depth * 0.9), Vector3(0.0, 0.68 + total_h + 0.51, front_z), _brick))

	add_child(ShapeKit.box("CentralProjectionLower", Vector3(width * 0.34, lower_h * 0.98, depth * 1.56), Vector3(0.0, 0.48 + lower_h * 0.49, front_z + depth * 0.24), _brick))
	add_child(ShapeKit.box("CentralProjectionUpper", Vector3(width * 0.3, upper_h * 0.96, depth * 1.42), Vector3(0.0, 0.68 + lower_h + upper_h * 0.48, front_z + depth * 0.18), _brick))
	add_child(ShapeKit.box("CentralProjectionCap", Vector3(width * 0.34, 0.2, depth * 1.54), Vector3(0.0, 0.68 + total_h + 0.22, front_z + depth * 0.2), _stone))
	add_child(ShapeKit.box("CentralProjectionBase", Vector3(width * 0.36, 0.22, depth * 1.6), Vector3(0.0, 0.59, front_z + depth * 0.22), _stone))
	add_child(ShapeKit.box("CentralProjectionString", Vector3(width * 0.31, 0.12, depth * 1.48), Vector3(0.0, 2.98, front_z + depth * 0.18), _stone))
	add_child(ShapeKit.box("BalconySlab", Vector3(width * 0.18, 0.14, depth * 0.7), Vector3(0.0, 0.82 + lower_h, front_z + depth * 0.58), _stone))
	add_child(ShapeKit.box("BalconyThreshold", Vector3(width * 0.12, 0.1, depth * 0.18), Vector3(0.0, 0.88 + lower_h, front_z + depth * 0.66), _trim_dark))
	for rail_x in PackedFloat32Array([-1.9, -0.95, 0.0, 0.95, 1.9]):
		add_child(ShapeKit.cylinder("BalconyPost_%s" % str(rail_x), 0.035, 0.78, Vector3(rail_x, 0.78 + lower_h, front_z + depth * 0.64), _iron, 8))
	add_child(ShapeKit.box("BalconyRailTop", Vector3(width * 0.16, 0.06, 0.08), Vector3(0.0, 1.16 + lower_h, front_z + depth * 0.64), _iron))
	add_child(ShapeKit.box("BalconyRailMid", Vector3(width * 0.16, 0.05, 0.08), Vector3(0.0, 0.92 + lower_h, front_z + depth * 0.64), _iron))

	for wing in PackedFloat32Array([-1.0, 1.0]):
		add_child(ShapeKit.box(
			"WingReturn_%s" % ("L" if wing < 0.0 else "R"),
			Vector3(width * 0.16, total_h * 0.9, depth * 1.72),
			Vector3(wing * width * 0.43, 0.68 + total_h * 0.45, front_z + depth * 0.18),
			_brick
		))
		add_child(ShapeKit.box(
			"WingCap_%s" % ("L" if wing < 0.0 else "R"),
			Vector3(width * 0.18, 0.18, depth * 1.78),
			Vector3(wing * width * 0.43, 0.68 + total_h * 0.9 + 0.09, front_z + depth * 0.18),
			_stone
		))
		add_child(ShapeKit.box(
			"WingPlinth_%s" % ("L" if wing < 0.0 else "R"),
			Vector3(width * 0.17, 0.18, depth * 1.76),
			Vector3(wing * width * 0.43, 0.74, front_z + depth * 0.16),
			_stone
		))

	for x in PackedFloat32Array([-width * 0.42, -width * 0.24, width * 0.24, width * 0.42]):
		add_child(ShapeKit.box("Pilaster_%s" % str(x), Vector3(0.42, total_h + 0.42, depth * 1.06), Vector3(x, 0.48 + (total_h + 0.42) * 0.5, front_z), _stone))
		add_child(ShapeKit.box("PilasterCap_%s" % str(x), Vector3(0.58, 0.12, depth * 1.1), Vector3(x, total_h + 0.86, front_z + depth * 0.04), _stone))

	for x in PackedFloat32Array([-width * 0.12, width * 0.12]):
		add_child(ShapeKit.box("ProjectionQuoin_%s" % str(x), Vector3(0.26, lower_h * 0.92, depth * 1.34), Vector3(x, 0.62 + lower_h * 0.46, front_z + depth * 0.28), _stone))

	for panel_x in PackedFloat32Array([-width * 0.17, width * 0.17]):
		add_child(ShapeKit.box("LowerPanel_%s" % str(panel_x), Vector3(width * 0.12, lower_h * 0.54, 0.08), Vector3(panel_x, 1.76, face_z + 0.12), _stone))
		add_child(ShapeKit.box("UpperPanel_%s" % str(panel_x), Vector3(width * 0.1, upper_h * 0.38, 0.07), Vector3(panel_x, 6.9, face_z + 0.12), _stone))

	_build_door_surround(face_z)
	_build_window(Vector3(-6.2, 1.98, face_z), Vector2(2.2, 3.18), true)
	_build_window(Vector3(-2.9, 1.92, face_z + depth * 0.1), Vector2(1.96, 2.96), true)
	_build_window(Vector3(2.9, 1.92, face_z + depth * 0.1), Vector2(1.96, 2.96), true)
	_build_window(Vector3(6.2, 1.98, face_z), Vector2(2.2, 3.18), true)
	_build_window(Vector3(-6.5, 7.26, face_z), Vector2(2.0, 2.52), false)
	_build_window(Vector3(-2.7, 7.34, face_z + depth * 0.12), Vector2(1.84, 2.58), false)
	_build_window(Vector3(0.0, 7.48, face_z + depth * 0.18), Vector2(2.02, 2.7), false)
	_build_window(Vector3(2.7, 7.34, face_z + depth * 0.12), Vector2(1.84, 2.58), false)
	_build_window(Vector3(6.5, 7.26, face_z), Vector2(2.0, 2.52), false)


func _build_door_surround(face_z: float) -> void:
	add_child(ShapeKit.box("DoorLintel", Vector3(4.0, 0.42, facade_depth * 0.28), Vector3(0.0, 4.36, face_z + 0.02), _trim_dark))
	add_child(ShapeKit.box("DoorCap", Vector3(4.6, 0.22, facade_depth * 0.34), Vector3(0.0, 4.66, face_z + 0.04), _stone))
	add_child(ShapeKit.box("DoorCapLip", Vector3(4.9, 0.08, facade_depth * 0.38), Vector3(0.0, 4.84, face_z + 0.05), _stone))
	add_child(ShapeKit.box("DoorPilasterL", Vector3(0.46, 4.2, facade_depth * 0.28), Vector3(-1.78, 2.4, face_z + 0.02), _trim_dark))
	add_child(ShapeKit.box("DoorPilasterR", Vector3(0.46, 4.2, facade_depth * 0.28), Vector3(1.78, 2.4, face_z + 0.02), _trim_dark))
	add_child(ShapeKit.box("DoorStoneRevealL", Vector3(0.14, 4.28, facade_depth * 0.18), Vector3(-2.12, 2.42, face_z + 0.01), _stone))
	add_child(ShapeKit.box("DoorStoneRevealR", Vector3(0.14, 4.28, facade_depth * 0.18), Vector3(2.12, 2.42, face_z + 0.01), _stone))
	add_child(ShapeKit.box("DoorInset", Vector3(2.4, 3.9, 0.2), Vector3(0.0, 2.12, face_z + 0.08), _void))
	add_child(ShapeKit.box("DoorFanlight", Vector3(2.18, 0.54, 0.16), Vector3(0.0, 4.18, face_z + 0.09), _void))
	add_child(ShapeKit.box("DoorThresholdStone", Vector3(2.9, 0.12, 0.4), Vector3(0.0, 0.54, face_z + 0.02), _stone))


func _build_window(position: Vector3, size: Vector2, lower_story: bool) -> void:
	var trim_material: Material = _stone if lower_story else _trim_dark
	add_child(ShapeKit.box("WindowVoid_%s" % str(position), Vector3(size.x, size.y, 0.2), position + Vector3(0.0, 0.0, 0.04), _void))
	add_child(ShapeKit.box("WindowGlass_%s" % str(position), Vector3(size.x * 0.84, size.y * 0.86, 0.04), position + Vector3(0.0, 0.0, 0.08), _glass_dark))
	add_child(ShapeKit.box("WindowFrameT_%s" % str(position), Vector3(size.x + 0.28, 0.18, 0.18), position + Vector3(0.0, size.y * 0.5 + 0.08, 0.05), trim_material))
	add_child(ShapeKit.box("WindowFrameB_%s" % str(position), Vector3(size.x + 0.34, 0.16, 0.22), position + Vector3(0.0, -size.y * 0.5 - 0.1, 0.05), _stone))
	add_child(ShapeKit.box("WindowFrameL_%s" % str(position), Vector3(0.16, size.y + 0.18, 0.18), position + Vector3(-size.x * 0.5 - 0.08, 0.0, 0.05), trim_material))
	add_child(ShapeKit.box("WindowFrameR_%s" % str(position), Vector3(0.16, size.y + 0.18, 0.18), position + Vector3(size.x * 0.5 + 0.08, 0.0, 0.05), trim_material))
	add_child(ShapeKit.box("WindowMullionV_%s" % str(position), Vector3(0.08, size.y * 0.86, 0.05), position + Vector3(0.0, 0.0, 0.09), trim_material))
	add_child(ShapeKit.box("WindowMullionH_%s" % str(position), Vector3(size.x * 0.84, 0.07, 0.05), position + Vector3(0.0, 0.0, 0.09), trim_material))
	if lower_story:
		add_child(ShapeKit.box("WindowPedimentBase_%s" % str(position), Vector3(size.x + 0.5, 0.12, 0.22), position + Vector3(0.0, size.y * 0.5 + 0.34, 0.05), _stone))
		add_child(ShapeKit.box("WindowPedimentCap_%s" % str(position), Vector3(size.x + 0.22, 0.12, 0.18), position + Vector3(0.0, size.y * 0.5 + 0.49, 0.05), _trim_dark))
