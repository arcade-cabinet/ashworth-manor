class_name DoorSingle
extends Node3D
## Interactive door panel that fits inside an existing doorway opening.
## Uses AnimatableBody3D for physics-correct collision during swing.
##
## Node structure (built in _ready):
##   DoorSingle (this Node3D -- position at doorway center, floor level)
##   └── Pivot (Node3D -- offset to hinge edge)
##       └── Body (AnimatableBody3D -- sync_to_physics)
##           ├── Panel (MeshInstance3D -- QuadMesh with door texture)
##           └── Collision (CollisionShape3D -- matches panel size)
##   └── InteractArea (Area3D -- layer 4 for raycast detection)
##
## Place this at a doorway opening. The doorway GLB provides the frame.
## This script provides only the swinging panel.

@export var panel_width: float = 0.9       # Slightly less than doorway width
@export var panel_height: float = 2.1      # Slightly less than doorway height
@export var panel_depth: float = 0.05      # Thin door panel
@export var door_texture: Texture2D = null
@export var open_angle: float = -90.0      # Degrees. Negative = swings inward
@export var open_duration: float = 0.8     # Seconds to open/close
@export var hinge_side: int = -1           # -1 = left hinge, +1 = right hinge
@export var locked: bool = false
@export var key_id: String = ""
@export var target_room: String = ""
@export var interact_id: String = ""       # For interactable metadata

var _is_open: bool = false
var _pivot: Node3D = null
var _body: AnimatableBody3D = null
var _tween: Tween = null


func _ready() -> void:
	_build_pivot_and_panel()
	_build_interact_area()


func toggle() -> void:
	if _tween and _tween.is_valid():
		return
	var target: float = open_angle if not _is_open else 0.0
	_tween = create_tween()
	_tween.tween_property(_pivot, "rotation_degrees:y", target, open_duration)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	_is_open = not _is_open


func is_locked() -> bool:
	return locked


func unlock() -> void:
	locked = false


func _build_pivot_and_panel() -> void:
	# Pivot at hinge edge (left or right side of doorway)
	_pivot = Node3D.new()
	_pivot.name = "Pivot"
	_pivot.position = Vector3(hinge_side * panel_width / 2.0, 0, 0)
	add_child(_pivot)

	# AnimatableBody3D -- pushes player when door swings
	_body = AnimatableBody3D.new()
	_body.name = "Body"
	_body.sync_to_physics = true
	_pivot.add_child(_body)

	# Visual panel
	var mi := MeshInstance3D.new()
	mi.name = "Panel"
	var quad := QuadMesh.new()
	quad.size = Vector2(panel_width, panel_height)
	if door_texture:
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = door_texture
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		quad.material = mat
	mi.mesh = quad
	# Offset panel so hinge edge aligns with pivot
	mi.position = Vector3(-hinge_side * panel_width / 2.0, panel_height / 2.0, 0)
	_body.add_child(mi)

	# Collision shape matching panel
	var col := CollisionShape3D.new()
	col.name = "Collision"
	var box := BoxShape3D.new()
	box.size = Vector3(panel_width, panel_height, panel_depth)
	col.shape = box
	col.position = mi.position
	_body.add_child(col)


func _build_interact_area() -> void:
	var area := Area3D.new()
	area.name = "InteractArea"
	area.collision_layer = 4  # Layer 3 -- interactable
	area.collision_mask = 0

	var mid := interact_id if not interact_id.is_empty() else name.to_snake_case()
	area.set_meta("id", mid)
	area.set_meta("type", "door")
	if not target_room.is_empty():
		area.set_meta("target_room", target_room)
	if locked:
		area.set_meta("locked", true)
		area.set_meta("key_id", key_id)

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(panel_width + 0.3, panel_height, 0.8)
	shape.shape = box
	shape.position = Vector3(0, panel_height / 2.0, 0)
	area.add_child(shape)
	add_child(area)
