extends Node3D

const ShapeKit = preload("res://builders/shape_kit.gd")
const LABEL_FONT = preload("res://assets/fonts/Cinzel-SemiBold.ttf")
const MAT_WOOD = preload("res://resources/materials/estate_varnished_oak_material.tres")
const MAT_BRASS = preload("res://resources/materials/estate_brass_material.tres")
const MAT_CHAIN = preload("res://resources/materials/estate_chain_iron_material.tres")


func _ready() -> void:
	if get_child_count() > 0:
		return
	_build_sign()


func _build_sign() -> void:
	add_child(ShapeKit.box("LeftPost", Vector3(0.24, 3.5, 0.24), Vector3(-3.2, 1.75, 0.0), MAT_WOOD))
	add_child(ShapeKit.box("RightPost", Vector3(0.24, 3.5, 0.24), Vector3(3.2, 1.75, 0.0), MAT_WOOD))
	add_child(ShapeKit.box("Crossbar", Vector3(6.9, 0.18, 0.24), Vector3(0.0, 3.28, 0.0), MAT_WOOD))
	add_child(ShapeKit.box("CrossbarTrim", Vector3(7.1, 0.08, 0.08), Vector3(0.0, 3.38, 0.1), MAT_BRASS))
	add_child(ShapeKit.sphere("FinialLeft", 0.14, Vector3(-3.2, 3.62, 0.0), MAT_BRASS))
	add_child(ShapeKit.sphere("FinialRight", 0.14, Vector3(3.2, 3.62, 0.0), MAT_BRASS))
	add_child(ShapeKit.box("NumberPlaque", Vector3(1.56, 0.52, 0.06), Vector3(0.0, 2.9, 0.14), MAT_BRASS))
	add_child(ShapeKit.label(
		"HouseNumber",
		"No. 47",
		LABEL_FONT,
		34,
		0.0055,
		Vector3(0.0, 2.88, 0.18),
		Vector3(0.0, 180.0, 0.0),
		Color(0.18, 0.11, 0.03, 1.0),
		Color(0.94, 0.82, 0.54, 0.36),
		4
	))

	for pair in [
		{"center": -2.1, "hanger": 0.72, "offset": 0.31},
		{"center": 0.0, "hanger": 0.82, "offset": 0.42},
		{"center": 2.1, "hanger": 0.72, "offset": 0.31},
	]:
		_add_chain_pair(float(pair["center"]), float(pair["hanger"]), float(pair["offset"]))


func _add_chain_pair(center_x: float, hanger_height: float, offset_x: float) -> void:
	var y := 3.28 - hanger_height * 0.5
	add_child(ShapeKit.cylinder(
		"ChainLeft_%s" % str(center_x),
		0.02,
		hanger_height,
		Vector3(center_x - offset_x, y, 0.02),
		MAT_CHAIN
	))
	add_child(ShapeKit.cylinder(
		"ChainRight_%s" % str(center_x),
		0.02,
		hanger_height,
		Vector3(center_x + offset_x, y, 0.02),
		MAT_CHAIN
	))
