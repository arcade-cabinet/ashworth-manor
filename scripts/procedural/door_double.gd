class_name DoorDouble
extends Node3D
## Double doors -- two panels swing outward simultaneously.
## Used for formal entrances (Foyer↔Dining Room).

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")

@export var frame_width: float = 2.0
@export var frame_height: float = 2.2
@export var frame_thickness: float = 0.12
@export var post_width: float = 0.08
@export var panel_surface_ref: String = ""
@export var frame_surface_ref: String = ""
@export var legacy_door_texture: Texture2D = null # Retired compatibility-only texture input
@export var legacy_frame_texture: Texture2D = null # Retired compatibility-only texture input
@export var open_angle: float = 90.0
@export var open_speed: float = 0.9
@export var target_room: String = ""

var _is_open: bool = false
var _hinge_l: Node3D = null
var _hinge_r: Node3D = null
var _tween: Tween = null


func _ready() -> void:
	_build_frame()
	_build_panels()
	_build_interaction_area()


func toggle() -> void:
	if _tween and _tween.is_valid():
		return
	var target_l: float = open_angle if not _is_open else 0.0
	var target_r: float = -open_angle if not _is_open else 0.0
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(_hinge_l, "rotation_degrees:y", target_l, open_speed)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(_hinge_r, "rotation_degrees:y", target_r, open_speed)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	_is_open = not _is_open


func _build_frame() -> void:
	var hw: float = frame_width / 2.0
	_add_beam("PostL", Vector3(post_width, frame_height, frame_thickness),
		Vector3(-hw - post_width / 2.0, frame_height / 2.0, 0))
	_add_beam("PostR", Vector3(post_width, frame_height, frame_thickness),
		Vector3(hw + post_width / 2.0, frame_height / 2.0, 0))
	_add_beam("Header", Vector3(frame_width + post_width * 2, post_width, frame_thickness),
		Vector3(0, frame_height + post_width / 2.0, 0))


func _build_panels() -> void:
	var panel_w: float = frame_width / 2.0

	# Left panel -- hinge on left edge, swings outward (+Y)
	_hinge_l = Node3D.new()
	_hinge_l.name = "HingeL"
	_hinge_l.position = Vector3(-frame_width / 2.0, 0, 0)
	add_child(_hinge_l)
	_add_panel(_hinge_l, panel_w, Vector3(panel_w / 2.0, frame_height / 2.0, 0))

	# Right panel -- hinge on right edge, swings outward (-Y)
	_hinge_r = Node3D.new()
	_hinge_r.name = "HingeR"
	_hinge_r.position = Vector3(frame_width / 2.0, 0, 0)
	add_child(_hinge_r)
	_add_panel(_hinge_r, panel_w, Vector3(-panel_w / 2.0, frame_height / 2.0, 0))


func _add_panel(parent: Node3D, w: float, pos: Vector3) -> void:
	var mi := MeshInstance3D.new()
	mi.name = "Panel"
	var quad := QuadMesh.new()
	quad.size = Vector2(w, frame_height)
	mi.mesh = quad
	var material := _resolve_panel_material()
	if material != null:
		mi.set_surface_override_material(0, material)
	mi.position = pos
	parent.add_child(mi)


func _add_beam(beam_name: String, size: Vector3, pos: Vector3) -> void:
	var mi := MeshInstance3D.new()
	mi.name = beam_name
	var box := BoxMesh.new()
	box.size = size
	mi.mesh = box
	var material := _resolve_frame_material()
	if material != null:
		mi.set_surface_override_material(0, material)
	mi.position = pos
	add_child(mi)


func _build_interaction_area() -> void:
	var area := Area3D.new()
	area.name = "DoorArea"
	area.collision_layer = 8
	area.collision_mask = 0
	if not target_room.is_empty():
		area.set_meta("target_room", target_room)
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(frame_width + 0.4, frame_height, 0.6)
	shape.shape = box
	shape.position = Vector3(0, frame_height / 2.0, 0)
	area.add_child(shape)
	add_child(area)


func _resolve_panel_material() -> Material:
	var resolved_surface := EstateMaterialKit.resolve_surface_reference(panel_surface_ref, "recipe:surface/oak_dark")
	if not resolved_surface.is_empty():
		return EstateMaterialKit.build_surface_reference(resolved_surface, {"double_sided": true})
	if legacy_door_texture != null:
		return EstateMaterialKit.legacy_texture_surface(legacy_door_texture, true)
	return null


func _resolve_frame_material() -> Material:
	var resolved_surface := EstateMaterialKit.resolve_surface_reference(frame_surface_ref, "recipe:surface/oak_header")
	if not resolved_surface.is_empty():
		return EstateMaterialKit.build_surface_reference(resolved_surface)
	if legacy_frame_texture != null:
		return EstateMaterialKit.legacy_texture_surface(legacy_frame_texture)
	return null
