extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")
const LABEL_FONT = preload("res://assets/fonts/Cinzel-SemiBold.ttf")

const BOARD_TEXT_COLOR := Color(0.7, 0.66, 0.58, 1.0)
const BOARD_OUTLINE_COLOR := Color(0.08, 0.05, 0.025, 0.88)
const PLAQUE_TEXT_COLOR := Color(0.53, 0.41, 0.2, 1.0)

var _wood_material: StandardMaterial3D
var _board_material: StandardMaterial3D
var _header_material: StandardMaterial3D
var _brass_material: StandardMaterial3D
var _chain_material: StandardMaterial3D


func _ready() -> void:
	if get_child_count() > 0:
		return
	_init_materials()
	_build_sign()


func _init_materials() -> void:
	_wood_material = EstateMaterialKit.oak_dark()
	_board_material = EstateMaterialKit.oak_board()
	_header_material = EstateMaterialKit.oak_header()
	_brass_material = EstateMaterialKit.brass()
	_chain_material = EstateMaterialKit.chain_iron()


func _build_sign() -> void:
	add_child(ShapeKit.box("BaseFoot", Vector3(1.12, 0.12, 0.38), Vector3(0.54, 0.06, 0.0), _wood_material))
	add_child(ShapeKit.box("BasePlinth", Vector3(1.12, 0.16, 0.34), Vector3(0.54, 0.2, 0.0), _header_material))
	add_child(ShapeKit.box("PostLeft", Vector3(0.18, 2.86, 0.18), Vector3(0.06, 1.59, 0.0), _wood_material))
	add_child(ShapeKit.box("PostRight", Vector3(0.18, 2.86, 0.18), Vector3(1.02, 1.59, 0.0), _wood_material))
	add_child(ShapeKit.box("Crossbeam", Vector3(1.12, 0.15, 0.2), Vector3(0.54, 2.96, 0.0), _wood_material))
	add_child(ShapeKit.box("CrossbeamTrim", Vector3(1.18, 0.03, 0.03), Vector3(0.54, 3.03, -0.085), _brass_material))
	add_child(ShapeKit.box("PostCapLeft", Vector3(0.24, 0.06, 0.24), Vector3(0.06, 3.08, 0.0), _header_material))
	add_child(ShapeKit.box("PostCapRight", Vector3(0.24, 0.06, 0.24), Vector3(1.02, 3.08, 0.0), _header_material))
	add_child(ShapeKit.sphere("FinialLeft", 0.085, Vector3(0.06, 3.18, 0.0), _brass_material))
	add_child(ShapeKit.sphere("FinialRight", 0.085, Vector3(1.02, 3.18, 0.0), _brass_material))
	add_child(ShapeKit.box("BraceLeft", Vector3(0.12, 0.5, 0.1), Vector3(0.22, 2.72, 0.0), _wood_material))
	add_child(ShapeKit.box("BraceRight", Vector3(0.12, 0.5, 0.1), Vector3(0.86, 2.72, 0.0), _wood_material))
	get_node("BraceLeft").rotation_degrees.z = -34.0
	get_node("BraceRight").rotation_degrees.z = 34.0

	add_child(ShapeKit.box("EstateBoard", Vector3(1.0, 0.42, 0.08), Vector3(0.54, 2.5, -0.08), _header_material))
	add_child(ShapeKit.box("EstateBoardTrimTop", Vector3(1.06, 0.03, 0.025), Vector3(0.54, 2.7, -0.12), _brass_material))
	add_child(ShapeKit.box("EstateBoardTrimBottom", Vector3(1.06, 0.03, 0.025), Vector3(0.54, 2.3, -0.12), _brass_material))
	add_child(ShapeKit.box("EstateBoardTrimLeft", Vector3(0.03, 0.36, 0.025), Vector3(0.055, 2.5, -0.12), _brass_material))
	add_child(ShapeKit.box("EstateBoardTrimRight", Vector3(0.03, 0.36, 0.025), Vector3(1.025, 2.5, -0.12), _brass_material))
	add_child(_make_label(
		"EstateName",
		"Ashworth Manor",
		24,
		0.0058,
		Vector3(0.54, 2.56, -0.16),
		PLAQUE_TEXT_COLOR,
		Color(0.78, 0.63, 0.34, 0.12),
		1
	))
	add_child(_make_label(
		"EstateDate",
		"Est. 1847",
		11,
		0.0052,
		Vector3(0.54, 2.36, -0.16),
		PLAQUE_TEXT_COLOR,
		Color(0.78, 0.63, 0.34, 0.1),
		1
	))

	add_child(ShapeKit.box("DirectoryPanel", Vector3(0.82, 0.86, 0.07), Vector3(0.54, 1.56, -0.065), _header_material))
	add_child(ShapeKit.box("DirectoryPanelTrimTop", Vector3(0.88, 0.028, 0.02), Vector3(0.54, 1.96, -0.1), _brass_material))
	add_child(ShapeKit.box("DirectoryPanelTrimBottom", Vector3(0.88, 0.028, 0.02), Vector3(0.54, 1.16, -0.1), _brass_material))
	add_child(ShapeKit.box("DirectoryPanelTrimLeft", Vector3(0.028, 0.8, 0.02), Vector3(0.14, 1.56, -0.1), _brass_material))
	add_child(ShapeKit.box("DirectoryPanelTrimRight", Vector3(0.028, 0.8, 0.02), Vector3(0.94, 1.56, -0.1), _brass_material))
	add_child(_make_label(
		"DirectoryTitle",
		"Visitor's Directory",
		10,
		0.0042,
		Vector3(0.54, 1.91, -0.12),
		BOARD_TEXT_COLOR,
		BOARD_OUTLINE_COLOR,
		1
	))

	_add_plate(0.54, 1.76, "Enter the Grounds", 8)
	_add_plate(0.54, 1.5, "Resume the Visit", 7)
	_add_plate(0.54, 1.24, "Adjust the House", 7)


func _add_plate(center_x: float, center_y: float, text: String, font_size: int) -> void:
	var board_name := text.to_snake_case().capitalize()
	add_child(ShapeKit.box("%sPlate" % board_name, Vector3(0.68, 0.12, 0.04), Vector3(center_x, center_y, -0.07), _board_material))
	add_child(ShapeKit.box("%sPlateInset" % board_name, Vector3(0.62, 0.072, 0.024), Vector3(center_x, center_y, -0.092), _header_material))
	add_child(ShapeKit.box("%sTrimTop" % board_name, Vector3(0.72, 0.012, 0.018), Vector3(center_x, center_y + 0.05, -0.1), _brass_material))
	add_child(ShapeKit.box("%sTrimBottom" % board_name, Vector3(0.72, 0.012, 0.018), Vector3(center_x, center_y - 0.05, -0.1), _brass_material))
	add_child(_make_label(
		"%sLabel" % board_name,
		text,
		font_size + 1,
		0.0044,
		Vector3(center_x, center_y + 0.002, -0.12),
		BOARD_TEXT_COLOR,
		BOARD_OUTLINE_COLOR,
		1
	))


func _make_label(
	label_name: String,
	text: String,
	font_size: int,
	pixel_size: float,
	position: Vector3,
	color: Color,
	outline_color: Color,
	outline_size: int
) -> Label3D:
	var label := ShapeKit.label(
		label_name,
		text,
		LABEL_FONT,
		font_size,
		pixel_size,
		position,
		Vector3(0.0, 180.0, 0.0),
		color,
		outline_color,
		outline_size
	)
	label.no_depth_test = false
	label.shaded = false
	label.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	label.double_sided = false
	return label
