@tool
class_name MountSlotDecl
extends Resource
## Stable host slot on the shared substrate where payloads may be mounted.

@export var slot_id: String = ""
@export var slot_family: String = "wall" # wall, floor, ceiling, threshold, gate_leaf, table, shelf, sill, mantel, path_edge, hedge_terminator, water_edge, facade_anchor
@export var target_node: String = "Props"
@export var position: Vector3 = Vector3.ZERO
@export var rotation_degrees: Vector3 = Vector3.ZERO
@export var scale_3d: Vector3 = Vector3.ONE
@export var tags: PackedStringArray = []
