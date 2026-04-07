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
@export var from_anchor_id: String = ""      # Optional authored threshold anchor in source room
@export var to_anchor_id: String = ""        # Optional authored entry anchor in target room
@export var focal_anchor_id: String = ""     # Optional authored focal target in target room
@export var traversal_mode: String = "auto"  # auto, seamless, embodied, soft_transition, hard_transition

# Threshold presentation / mechanism
@export var presentation_type: String = ""   # facade_door, interior_door, gate_path, ladder_drop, trapdoor_hatch, secret_panel, etc.
@export var mechanism_type: String = ""      # swing, slide, lift, drop, crawl, threshold
@export var mechanism_state: String = "idle" # idle, locked, concealed, revealed, open
@export var reveal_state: String = "visible" # visible, concealed, revealed
@export var interaction_size: Vector3 = Vector3.ZERO
@export var visible_model: String = ""
@export var concealment_model: String = ""

# Lock
@export var locked: bool = false
@export var key_id: String = ""
@export var required_state: String = ""      # State expression gate for traversal
@export var blocked_text: String = ""        # Text shown when required_state fails

# Visual
@export var door_texture: String = ""        # From retro textures pack
@export var frame_texture: String = ""       # Frame material

# Audio
@export var open_sfx: String = ""
@export var close_sfx: String = ""
