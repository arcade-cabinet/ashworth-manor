extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var portico_width: float = 7.4
@export var portico_depth: float = 1.8
@export var column_height: float = 4.8
@export var entablature_height: float = 0.72

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.75, scale.x),
		maxf(0.8, scale.y),
		maxf(0.75, scale.z)
	)
	scale = Vector3.ONE
	_build()


func _build() -> void:
	var stone := EstateMaterialKit.masonry_cap()
	var trim := EstateMaterialKit.oak_header()
	var door := EstateMaterialKit.oak_dark()
	var brass := EstateMaterialKit.brass()
	var shadow := EstateMaterialKit.shadow_void_tinted(Color(0.03, 0.025, 0.03, 1.0))
	var glass := EstateMaterialKit.door_lamplit_glass()

	var width := portico_width * _baked_scale.x
	var depth := portico_depth * _baked_scale.z
	var col_h := column_height * _baked_scale.y
	var ent_h := entablature_height * _baked_scale.y
	var column_x := width * 0.34
	var face_z := depth * 0.5
	var back_wall_z := face_z + depth * 0.22

	add_child(ShapeKit.box("Podium", Vector3(width * 1.06, 0.24, depth * 1.28), Vector3(0.0, 0.12, 0.0), stone))
	add_child(ShapeKit.box("Landing", Vector3(width * 0.9, 0.14, depth * 0.94), Vector3(0.0, 0.31, face_z * 0.18), stone))
	add_child(ShapeKit.box("Soffit", Vector3(width * 0.96, 0.12, depth * 0.92), Vector3(0.0, 0.22 + col_h + 0.02, face_z * 0.92), trim))
	add_child(ShapeKit.box("CeilingPanel", Vector3(width * 0.72, 0.06, depth * 0.48), Vector3(0.0, 0.22 + col_h - 0.04, face_z * 0.96), stone))
	add_child(ShapeKit.box("CeilingStripLeft", Vector3(width * 0.14, 0.05, depth * 0.48), Vector3(-width * 0.26, 0.22 + col_h - 0.03, face_z * 0.96), trim))
	add_child(ShapeKit.box("CeilingStripRight", Vector3(width * 0.14, 0.05, depth * 0.48), Vector3(width * 0.26, 0.22 + col_h - 0.03, face_z * 0.96), trim))
	add_child(ShapeKit.box("LeftColumn", Vector3(0.56, col_h, 0.56), Vector3(-column_x, 0.22 + col_h * 0.5, face_z), stone))
	add_child(ShapeKit.box("RightColumn", Vector3(0.56, col_h, 0.56), Vector3(column_x, 0.22 + col_h * 0.5, face_z), stone))
	add_child(ShapeKit.box("LeftBase", Vector3(0.74, 0.16, 0.74), Vector3(-column_x, 0.08, face_z), stone))
	add_child(ShapeKit.box("RightBase", Vector3(0.74, 0.16, 0.74), Vector3(column_x, 0.08, face_z), stone))
	add_child(ShapeKit.box("LeftPedestal", Vector3(1.02, 0.32, 1.06), Vector3(-column_x, 0.16, face_z), stone))
	add_child(ShapeKit.box("RightPedestal", Vector3(1.02, 0.32, 1.06), Vector3(column_x, 0.16, face_z), stone))
	add_child(ShapeKit.box("Entablature", Vector3(width * 0.94, ent_h, depth * 0.86), Vector3(0.0, 0.22 + col_h + ent_h * 0.5, face_z * 0.95), trim))
	add_child(ShapeKit.box("FriezeBand", Vector3(width * 0.98, 0.14, depth * 0.92), Vector3(0.0, 0.22 + col_h + ent_h + 0.07, face_z * 0.95), stone))
	add_child(ShapeKit.box("Capstone", Vector3(width * 1.02, 0.16, depth * 0.98), Vector3(0.0, 0.22 + col_h + ent_h + 0.18, face_z * 0.95), stone))
	add_child(ShapeKit.box("CorniceShadow", Vector3(width * 0.92, 0.08, depth * 0.84), Vector3(0.0, 0.22 + col_h + ent_h * 0.68, face_z * 0.96), shadow))
	add_child(ShapeKit.box("LeftPilaster", Vector3(0.42, col_h * 0.98, 0.28), Vector3(-width * 0.22, 0.22 + col_h * 0.49, face_z + depth * 0.16), trim))
	add_child(ShapeKit.box("RightPilaster", Vector3(0.42, col_h * 0.98, 0.28), Vector3(width * 0.22, 0.22 + col_h * 0.49, face_z + depth * 0.16), trim))
	add_child(ShapeKit.box("BackWall", Vector3(width * 0.7, col_h * 0.96, 0.16), Vector3(0.0, 0.22 + col_h * 0.48, back_wall_z), stone))
	add_child(ShapeKit.box("BackPanelLeft", Vector3(width * 0.14, col_h * 0.72, 0.05), Vector3(-width * 0.18, 0.24 + col_h * 0.4, back_wall_z + 0.06), trim))
	add_child(ShapeKit.box("BackPanelRight", Vector3(width * 0.14, col_h * 0.72, 0.05), Vector3(width * 0.18, 0.24 + col_h * 0.4, back_wall_z + 0.06), trim))
	add_child(ShapeKit.box("DoorArchitraveTop", Vector3(width * 0.4, 0.16, 0.12), Vector3(0.0, 0.38 + col_h * 0.82, face_z + depth * 0.24), stone))
	add_child(ShapeKit.box("DoorArchitraveLeft", Vector3(0.16, col_h * 0.78, 0.12), Vector3(-width * 0.17, 0.3 + col_h * 0.39, face_z + depth * 0.24), stone))
	add_child(ShapeKit.box("DoorArchitraveRight", Vector3(0.16, col_h * 0.78, 0.12), Vector3(width * 0.17, 0.3 + col_h * 0.39, face_z + depth * 0.24), stone))
	add_child(ShapeKit.box("DoorPediment", Vector3(width * 0.46, 0.08, 0.18), Vector3(0.0, 0.48 + col_h * 0.84, face_z + depth * 0.26), stone))
	add_child(ShapeKit.box("DoorRecess", Vector3(width * 0.34, col_h * 0.94, 0.34), Vector3(0.0, 0.22 + col_h * 0.47, face_z + depth * 0.18), shadow))
	add_child(ShapeKit.box("DoorLeafLeft", Vector3(width * 0.14, col_h * 0.82, 0.12), Vector3(-width * 0.073, 0.34 + col_h * 0.41, face_z + depth * 0.26), door))
	add_child(ShapeKit.box("DoorLeafRight", Vector3(width * 0.14, col_h * 0.82, 0.12), Vector3(width * 0.073, 0.34 + col_h * 0.41, face_z + depth * 0.26), door))
	add_child(ShapeKit.box("DoorMeetingStile", Vector3(0.07, col_h * 0.82, 0.14), Vector3(0.0, 0.34 + col_h * 0.41, face_z + depth * 0.27), trim))
	add_child(ShapeKit.box("DoorPanelLeftUpper", Vector3(width * 0.09, col_h * 0.23, 0.03), Vector3(-width * 0.073, 2.78, face_z + depth * 0.33), trim))
	add_child(ShapeKit.box("DoorPanelRightUpper", Vector3(width * 0.09, col_h * 0.23, 0.03), Vector3(width * 0.073, 2.78, face_z + depth * 0.33), trim))
	add_child(ShapeKit.box("DoorPanelLeftLower", Vector3(width * 0.09, col_h * 0.28, 0.03), Vector3(-width * 0.073, 1.6, face_z + depth * 0.33), trim))
	add_child(ShapeKit.box("DoorPanelRightLower", Vector3(width * 0.09, col_h * 0.28, 0.03), Vector3(width * 0.073, 1.6, face_z + depth * 0.33), trim))
	add_child(ShapeKit.box("FanlightFrame", Vector3(width * 0.29, 0.56, 0.1), Vector3(0.0, 0.22 + col_h * 0.86, face_z + depth * 0.26), trim))
	add_child(ShapeKit.box("FanlightGlass", Vector3(width * 0.25, 0.4, 0.04), Vector3(0.0, 0.22 + col_h * 0.86, face_z + depth * 0.31), glass))
	add_child(ShapeKit.box("FanlightMullion", Vector3(0.05, 0.38, 0.05), Vector3(0.0, 0.22 + col_h * 0.86, face_z + depth * 0.32), trim))
	add_child(ShapeKit.box("ThresholdStone", Vector3(width * 0.34, 0.08, depth * 0.34), Vector3(0.0, 0.3, face_z + depth * 0.25), stone))
	add_child(ShapeKit.cylinder("HandleLeft", 0.026, 0.18, Vector3(-width * 0.03, 2.02, face_z + depth * 0.36), brass, 8))
	add_child(ShapeKit.cylinder("HandleRight", 0.026, 0.18, Vector3(width * 0.03, 2.02, face_z + depth * 0.36), brass, 8))
