@tool
class_name RoomDeclaration
extends Resource
## Complete room definition -- geometry, interactables, lighting, audio, triggers.

const RoomAnchorDecl = preload("res://engine/declarations/room_anchor_decl.gd")

# Identity
@export var room_id: String = ""
@export var room_name: String = ""
@export var floor_name: String = ""          # "ground_floor", "upper_floor", etc

# Environment -- references a key in WorldDeclaration.area_environments
@export var environment_preset: String = ""  # "grounds", "ground_floor", "upper_floor", "basement", "deep_basement", "attic"

# Geometry
@export var dimensions: Vector3 = Vector3(12, 4.8, 10) # width, height, depth
@export var is_exterior: bool = false
@export var spatial_class: String = "interior_room" # interior_room, exterior_ground, glazed_room, threshold_room, service_space
@export var exposure_faces: PackedStringArray = []
@export var outlook_zones: Dictionary = {} # {"north": "estate_garden", "roof": "open_sky"}
@export var window_view_mode: String = "none" # none, local_outlook, distant_backdrop, glazed_enclosure, facade_view

# Textures (256x256 standalone PNGs)
@export var wall_texture: String = "wall0_texture"
@export var floor_texture: String = "floor0_texture"
@export var ceiling_texture: String = "ceiling0_texture"

# Wall layout -- per side, what goes in each 2m segment
# Each segment: "wall" | "doorway:{connection_id}" | "window" | "window_boarded" | "window_shuttered"
@export var wall_north: PackedStringArray = []
@export var wall_south: PackedStringArray = []
@export var wall_east: PackedStringArray = []
@export var wall_west: PackedStringArray = []

# Audio
@export var ambient_loop: String = ""        # Path relative to audio/loops/
@export var tension_loop: String = ""        # Path relative to audio/tension/
@export var reverb_bus: String = "Room"       # Audio bus name
@export var footstep_surface: String = "wood_parquet"

# Spawn (used when entering this room from a connection that doesn't specify position_in_to)
@export var spawn_position: Vector3 = Vector3.ZERO
@export var spawn_rotation_y: float = 0.0

# Canonical composition anchors
@export var entry_anchors: Array[RoomAnchorDecl] = []
@export var focal_anchors: Array[RoomAnchorDecl] = []

# Interactables -- declared inline, not separate files
@export var interactables: Array[InteractableDecl] = []

# Lighting
@export var lights: Array[LightDecl] = []

# Props (non-interactive models)
@export var props: Array[PropDecl] = []

# Triggers
@export var on_entry: Array[TriggerDecl] = []
@export var on_exit: Array[TriggerDecl] = []
@export var ambient_events: Array[AmbientEventDecl] = []
@export var conditional_events: Array[ConditionalEventDecl] = []
@export var flashbacks: Array[FlashbackDecl] = []
