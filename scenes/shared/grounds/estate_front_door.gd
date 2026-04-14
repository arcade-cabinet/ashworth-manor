extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var door_width: float = 2.28
@export var door_height: float = 4.18
@export var door_depth: float = 0.16

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.8, scale.x),
		maxf(0.8, scale.y),
		maxf(0.8, scale.z)
	)
	scale = Vector3.ONE
	_build()


func _build() -> void:
	var oak := EstateMaterialKit.oak_dark()
	var trim := EstateMaterialKit.oak_header()
	var stone := EstateMaterialKit.masonry_cap()
	var brass := EstateMaterialKit.brass()
	var shadow := EstateMaterialKit.shadow_void_tinted(Color(0.05, 0.03, 0.025, 1.0))
	var glass := EstateMaterialKit.door_lamplit_glass()

	var width := door_width * _baked_scale.x
	var height := door_height * _baked_scale.y
	var depth := door_depth * _baked_scale.z
	var leaf_width := width * 0.48
	var frame_depth := depth * 1.24
	var sidelight_width := width * 0.12
	var door_body_width := width * 0.78

	add_child(ShapeKit.box("Threshold", Vector3(width * 1.14, 0.08, depth * 1.34), Vector3(0.0, 0.04, 0.0), stone))
	add_child(ShapeKit.box("StepNose", Vector3(width * 1.02, 0.05, depth * 0.48), Vector3(0.0, 0.09, depth * 0.32), brass))
	add_child(ShapeKit.box("OuterFrameTop", Vector3(width * 1.06, 0.18, frame_depth), Vector3(0.0, height + 0.06, -depth * 0.08), stone))
	add_child(ShapeKit.box("OuterFrameLeft", Vector3(0.14, height * 0.96, frame_depth), Vector3(-width * 0.53, height * 0.48 + 0.06, -depth * 0.08), stone))
	add_child(ShapeKit.box("OuterFrameRight", Vector3(0.14, height * 0.96, frame_depth), Vector3(width * 0.53, height * 0.48 + 0.06, -depth * 0.08), stone))
	add_child(ShapeKit.box("CapstoneLip", Vector3(width * 1.14, 0.1, frame_depth * 0.86), Vector3(0.0, height + 0.18, -depth * 0.05), stone))
	add_child(ShapeKit.box("DoorShadowWell", Vector3(width * 0.94, height * 0.94, depth * 0.48), Vector3(0.0, height * 0.47 + 0.08, -depth * 0.06), shadow))
	add_child(ShapeKit.box("SidelightLeft", Vector3(sidelight_width, height * 0.66, depth * 0.16), Vector3(-width * 0.4, height * 0.39 + 0.12, depth * 0.08), glass))
	add_child(ShapeKit.box("SidelightRight", Vector3(sidelight_width, height * 0.66, depth * 0.16), Vector3(width * 0.4, height * 0.39 + 0.12, depth * 0.08), glass))
	add_child(ShapeKit.box("SidelightFrameLeft", Vector3(sidelight_width * 1.18, height * 0.72, depth * 0.06), Vector3(-width * 0.4, height * 0.39 + 0.12, depth * 0.0), stone))
	add_child(ShapeKit.box("SidelightFrameRight", Vector3(sidelight_width * 1.18, height * 0.72, depth * 0.06), Vector3(width * 0.4, height * 0.39 + 0.12, depth * 0.0), stone))
	add_child(ShapeKit.box("DoorLeafLeft", Vector3(leaf_width, height * 0.82, depth), Vector3(-door_body_width * 0.245, height * 0.41 + 0.1, 0.0), oak))
	add_child(ShapeKit.box("DoorLeafRight", Vector3(leaf_width, height * 0.82, depth), Vector3(door_body_width * 0.245, height * 0.41 + 0.1, 0.0), oak))
	add_child(ShapeKit.box("MeetingStile", Vector3(0.06, height * 0.82, depth * 1.02), Vector3(0.0, height * 0.41 + 0.1, 0.0), trim))
	add_child(ShapeKit.box("MidRail", Vector3(door_body_width * 0.94, 0.08, depth * 0.42), Vector3(0.0, height * 0.49, depth * 0.08), trim))
	add_child(ShapeKit.box("LockRail", Vector3(door_body_width * 0.94, 0.08, depth * 0.42), Vector3(0.0, height * 0.27, depth * 0.08), trim))
	add_child(ShapeKit.box("TransomFrame", Vector3(width, height * 0.14, depth * 0.72), Vector3(0.0, height * 0.9, -depth * 0.04), stone))
	add_child(ShapeKit.box("TransomGlass", Vector3(width * 0.9, height * 0.1, depth * 0.18), Vector3(0.0, height * 0.9, depth * 0.06), glass))
	add_child(ShapeKit.box("TransomMullion", Vector3(0.05, height * 0.1, depth * 0.2), Vector3(0.0, height * 0.9, depth * 0.07), trim))
	add_child(ShapeKit.box("TransomMullionLeft", Vector3(0.04, height * 0.1, depth * 0.18), Vector3(-width * 0.18, height * 0.9, depth * 0.07), trim))
	add_child(ShapeKit.box("TransomMullionRight", Vector3(0.04, height * 0.1, depth * 0.18), Vector3(width * 0.18, height * 0.9, depth * 0.07), trim))

	for side in PackedFloat32Array([-1.0, 1.0]):
		var side_name := "L" if side < 0.0 else "R"
		var x := side * door_body_width * 0.245
		add_child(ShapeKit.box("PanelUpper_%s" % side_name, Vector3(width * 0.26, height * 0.22, depth * 0.28), Vector3(x, height * 0.62 + 0.1, depth * 0.08), trim))
		add_child(ShapeKit.box("PanelLower_%s" % side_name, Vector3(width * 0.26, height * 0.28, depth * 0.28), Vector3(x, height * 0.3 + 0.1, depth * 0.08), trim))
		add_child(ShapeKit.box("PanelUpperInset_%s" % side_name, Vector3(width * 0.18, height * 0.14, depth * 0.08), Vector3(x, height * 0.62 + 0.1, depth * 0.15), shadow))
		add_child(ShapeKit.box("PanelLowerInset_%s" % side_name, Vector3(width * 0.18, height * 0.2, depth * 0.08), Vector3(x, height * 0.3 + 0.1, depth * 0.15), shadow))
		add_child(ShapeKit.box("HandlePlate_%s" % side_name, Vector3(0.07, 0.26, depth * 0.18), Vector3(side * width * 0.08, height * 0.45, depth * 0.1), brass))
		add_child(ShapeKit.cylinder("Handle_%s" % side_name, 0.022, 0.18, Vector3(side * width * 0.08, height * 0.45, depth * 0.16), brass, 8))
		add_child(ShapeKit.box("KickPlate_%s" % side_name, Vector3(width * 0.14, 0.14, depth * 0.06), Vector3(x, 0.44, depth * 0.14), brass))
