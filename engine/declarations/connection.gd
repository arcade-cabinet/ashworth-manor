@tool
class_name Connection
extends Resource
## A traversable link between two rooms.

@export var id: String = ""                  # Unique connection ID
@export var from_room: String = ""
@export var to_room: String = ""
@export var direction: String = ""           # north/south/east/west/up/down
@export var type: String = "door"            # door, double_door, heavy_door, hidden_door, gate, stairs, trapdoor, ladder, path
@export var position_in_from: Vector3 = Vector3.ZERO  # Where the connection sits in the source room
@export var position_in_to: Vector3 = Vector3.ZERO    # Where player spawns in the target room
@export var spawn_rotation_y: float = 0.0

# Lock
@export var locked: bool = false
@export var key_id: String = ""

# Visual
@export var door_texture: String = ""        # From retro textures pack
@export var frame_texture: String = ""       # Frame material

# Audio
@export var open_sfx: String = ""
@export var close_sfx: String = ""
