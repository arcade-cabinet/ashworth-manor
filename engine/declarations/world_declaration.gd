@tool
class_name WorldDeclaration
extends Resource
## Top-level game definition. Everything the game IS.

# === Game start ===
@export var starting_room: String = "front_gate"
@export var starting_position: Vector3 = Vector3(0, 0, -8)
@export var starting_rotation_y: float = 180.0

# === Room registry -- validated bidirectional connectivity ===
@export var rooms: Array[RoomRef] = []
@export var connections: Array[Connection] = []

# === Environments -- per-area presets, rooms reference by name ===
@export var area_environments: Dictionary = {}

# === WEAVE SYSTEM -- Three-layer narrative threading ===

# Macro threads -- 3 emotional perspectives on the same story
@export var macro_threads: Array[MacroThread] = []

# Junctions -- where the needle picks A or B (diamonds and swaps)
@export var junctions: Array[JunctionDecl] = []

# PRNG seed -- 0 = random each playthrough
@export var prng_seed: int = 0

# === Game phases (HSM) ===
@export var phases: Array[PhaseDecl] = []
@export var phase_transitions: Array[PhaseTransition] = []

# === Elizabeth presence sub-HSM ===
@export var elizabeth_states: Array[ElizabethStateDecl] = []
@export var elizabeth_transitions: Array[ElizabethTransition] = []

# === Global triggers -- fire on state conditions regardless of current room ===
@export var global_triggers: Array[GlobalTrigger] = []

# === Endings -- 3 positive (per macro thread) + 2 negative (shared) ===
@export var endings: Array[EndingDecl] = []

# === Player config ===
@export var player: PlayerDeclaration = null

# === Accessibility ===
@export var accessibility: AccessibilityDecl = null
