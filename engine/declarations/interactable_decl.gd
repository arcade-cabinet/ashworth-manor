@tool
class_name InteractableDecl
extends Resource
## An interactive object in a room — painting, note, mirror, clock, switch, etc.

@export var id: String = ""
@export var type: String = ""                # painting, note, mirror, clock, switch, box, doll, ritual, observation, photo
@export var position: Vector3 = Vector3.ZERO
@export var wall: String = ""                # "north", "south", "east", "west" — for wall-mounted objects
@export var collision_size: Vector3 = Vector3(1.5, 1.5, 1.5)

# Thread visibility — which macro threads make this interactable active
# Empty = always active (on all threads). "captive" = only on captive thread.
@export var thread_active: PackedStringArray = []

# Thread-specific response overrides (keyed by macro thread_id)
# When present, REPLACES the default responses array for that thread
@export var thread_responses: Dictionary = {} # {"captive": [ResponseDecl...], "mourning": [...]}

# Visual
@export var model: String = ""               # GLB path for 3D model, empty for text-only
@export var texture: String = ""             # For procedural visual (door/window texture)

# Visual effects — per-phase rendering changes
@export var visual_effects: Dictionary = {}  # {"mirror_delay": 0.3, "emission_glow": 0.5}

# === Simple interaction: single response set ===
# Ordered by priority (first matching condition wins)
@export var responses: Array[ResponseDecl] = []

# === Progressive interaction: multi-step sequences ===
@export var progressive: bool = false
@export var progression_steps: Array[ProgressionStep] = []
@export var fallback_response: ResponseDecl = null  # Shown when no step's conditions are met

# Lock
@export var locked: bool = false
@export var key_id: String = ""
@export var locked_response_no_key: String = "It's locked. You need a key."
@export var locked_response_wrong_key: String = "This key doesn't fit."

# Item given on interaction
@export var gives_item: String = ""
@export var gives_item_condition: String = ""
@export var also_gives: String = ""

# Switch behavior
@export var controls_light: String = ""

# Connection behavior (for locked_door type)
@export var target_room: String = ""
