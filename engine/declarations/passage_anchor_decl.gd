@tool
class_name PassageAnchorDecl
extends Resource
## Exact 3D anchor for one end of a secret passage.

@export var room_id: String = ""
@export var local_position: Vector3 = Vector3.ZERO
@export var local_rotation_y: float = 0.0

# What architectural surface conceals or expresses the passage.
@export var surface_type: String = ""  # wall, floor, fireplace, bookshelf, wardrobe, stair, hedge, gravestone

# Trigger/presentation volume in local room space.
@export var bounds_size: Vector3 = Vector3(1.0, 2.0, 0.3)

# Offset where the player should stand to initiate traversal.
@export var entry_offset: Vector3 = Vector3.ZERO

# Spawn point after traversal reaches this anchor.
@export var spawn_position: Vector3 = Vector3.ZERO
@export var spawn_rotation_y: float = 0.0
