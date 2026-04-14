@tool
class_name PropDecl
extends Resource
## A non-interactive model placed in a room (furniture, decoration).

@export var id: String = ""
@export var scene_role: String = "static_model" # static_model, architectural_trim, threshold_trim, clue_dressing
@export var substrate_prop_kind: String = "" # shared procedural/runtime-owned substrate prop kind
@export var substrate_waiver_reason: String = "" # required when architectural/threshold props bypass substrate kinds
@export var model: String = ""               # GLB path
@export var scene_path: String = ""          # Optional authored PackedScene for composite props
@export var position: Vector3 = Vector3.ZERO
@export var rotation_y: float = 0.0
@export var scale: float = 1.0
@export var scale_3d: Vector3 = Vector3.ONE
@export var tags: PackedStringArray = []
