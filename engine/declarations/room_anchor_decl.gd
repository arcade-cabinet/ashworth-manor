@tool
class_name RoomAnchorDecl
extends Resource
## Canonical point inside a room used for entry framing, focal composition,
## threshold validation, and region compilation.

@export var anchor_id: String = ""
@export var anchor_type: String = "entry" # entry, focal, threshold, overview
@export var position: Vector3 = Vector3.ZERO
@export var rotation_y: float = 0.0
@export var target_anchor_id: String = ""
@export var tags: PackedStringArray = []

