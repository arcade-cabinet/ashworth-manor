extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var lid_angle_degrees: float = 0.0
@export var show_packet: bool = false
@export var show_inner_cloth: bool = false
@export var yaw_degrees: float = 12.0
@export var overall_scale: float = 1.4

var _leather_material: StandardMaterial3D
var _paper_material: StandardMaterial3D
var _cloth_material: StandardMaterial3D
var _lining_material: StandardMaterial3D
var _brass_material: StandardMaterial3D


func _ready() -> void:
	if get_child_count() > 0:
		return
	_init_materials()
	_build_valise()


func _init_materials() -> void:
	_leather_material = EstateMaterialKit.leather_valise()
	_paper_material = EstateMaterialKit.paper()
	_cloth_material = EstateMaterialKit.cloth_brown()
	_lining_material = EstateMaterialKit.lining_tan()
	_brass_material = EstateMaterialKit.brass()


func _build_valise() -> void:
	rotation_degrees = Vector3(0.0, yaw_degrees, 0.0)
	scale = Vector3.ONE * overall_scale

	add_child(ShapeKit.box("Base", Vector3(0.8, 0.24, 0.5), Vector3(0.0, 0.12, 0.0), _leather_material))
	add_child(ShapeKit.box("BaseLipFront", Vector3(0.76, 0.04, 0.05), Vector3(0.0, 0.2, 0.205), _brass_material))
	add_child(ShapeKit.box("BaseLipBack", Vector3(0.76, 0.04, 0.05), Vector3(0.0, 0.2, -0.205), _brass_material))
	add_child(ShapeKit.box("BaseLipLeft", Vector3(0.05, 0.04, 0.36), Vector3(-0.355, 0.2, 0.0), _brass_material))
	add_child(ShapeKit.box("BaseLipRight", Vector3(0.05, 0.04, 0.36), Vector3(0.355, 0.2, 0.0), _brass_material))
	add_child(ShapeKit.box("BaseLining", Vector3(0.67, 0.04, 0.36), Vector3(0.0, 0.16, 0.0), _lining_material))

	if show_inner_cloth:
		add_child(ShapeKit.box("InnerCloth", Vector3(0.64, 0.03, 0.35), Vector3(0.0, 0.17, 0.0), _cloth_material))

	if show_packet:
		var packet_pivot := Node3D.new()
		packet_pivot.name = "PacketPivot"
		packet_pivot.position = Vector3(-0.08, 0.19, -0.02)
		packet_pivot.rotation_degrees = Vector3(-14.0, -8.0, 2.0)
		add_child(packet_pivot)
		packet_pivot.add_child(ShapeKit.box("Packet", Vector3(0.36, 0.02, 0.23), Vector3(0.0, 0.0, 0.0), _paper_material))
		packet_pivot.add_child(ShapeKit.box("PacketEnvelope", Vector3(0.2, 0.012, 0.08), Vector3(0.09, 0.014, 0.028), _paper_material))
		packet_pivot.add_child(ShapeKit.box("PacketRibbon", Vector3(0.032, 0.022, 0.24), Vector3(-0.07, 0.004, 0.0), _brass_material))

		add_child(ShapeKit.box("WindingKeyPouch", Vector3(0.16, 0.03, 0.11), Vector3(0.18, 0.18, -0.11), _cloth_material))
		var key_shaft := ShapeKit.cylinder("WindingKeyShaft", 0.012, 0.13, Vector3(0.19, 0.205, -0.06), _brass_material, 8)
		key_shaft.rotation_degrees.z = 90.0
		add_child(key_shaft)
		add_child(ShapeKit.box("WindingKeyHead", Vector3(0.05, 0.012, 0.05), Vector3(0.25, 0.205, -0.06), _brass_material))
		add_child(ShapeKit.box("WindingKeyStem", Vector3(0.014, 0.014, 0.06), Vector3(0.13, 0.205, -0.06), _brass_material))
		add_child(ShapeKit.box("TravelRibbon", Vector3(0.02, 0.008, 0.14), Vector3(-0.18, 0.184, 0.08), _cloth_material))

	var lid_pivot := Node3D.new()
	lid_pivot.name = "LidPivot"
	lid_pivot.position = Vector3(0.0, 0.22, -0.205)
	lid_pivot.rotation_degrees.x = lid_angle_degrees
	add_child(lid_pivot)

	var lid := ShapeKit.box("Lid", Vector3(0.76, 0.07, 0.46), Vector3(0.0, 0.02, 0.205), _leather_material)
	lid_pivot.add_child(lid)
	lid_pivot.add_child(ShapeKit.box("LidLining", Vector3(0.68, 0.02, 0.34), Vector3(0.0, -0.016, 0.2), _lining_material))
	lid_pivot.add_child(ShapeKit.box("LidTrimFront", Vector3(0.76, 0.035, 0.04), Vector3(0.0, 0.04, 0.4), _brass_material))
	lid_pivot.add_child(ShapeKit.box("LidTrimLeft", Vector3(0.04, 0.035, 0.34), Vector3(-0.36, 0.04, 0.205), _brass_material))
	lid_pivot.add_child(ShapeKit.box("LidTrimRight", Vector3(0.04, 0.035, 0.34), Vector3(0.36, 0.04, 0.205), _brass_material))

	var handle_support_left := ShapeKit.box("HandleSupportLeft", Vector3(0.028, 0.08, 0.028), Vector3(-0.12, 0.115, 0.39), _brass_material)
	var handle_support_right := ShapeKit.box("HandleSupportRight", Vector3(0.028, 0.08, 0.028), Vector3(0.12, 0.115, 0.39), _brass_material)
	var handle_bar := ShapeKit.cylinder("HandleBar", 0.018, 0.24, Vector3(0.0, 0.16, 0.39), _brass_material, 10)
	handle_bar.rotation_degrees.z = 90.0
	lid_pivot.add_child(handle_support_left)
	lid_pivot.add_child(handle_support_right)
	lid_pivot.add_child(handle_bar)

	add_child(ShapeKit.box("ClaspLeft", Vector3(0.06, 0.08, 0.025), Vector3(-0.18, 0.17, 0.235), _brass_material))
	add_child(ShapeKit.box("ClaspRight", Vector3(0.06, 0.08, 0.025), Vector3(0.18, 0.17, 0.235), _brass_material))
