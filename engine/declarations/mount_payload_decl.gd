@tool
class_name MountPayloadDecl
extends Resource
## Payload that attaches to a declared mount slot instead of hardcoding bespoke scene placement.
## route_modes may target active route ids (adult/elder/child), legacy thread ids,
## or broader replay/progression modes.

@export var payload_id: String = ""
@export var slot_id: String = ""
@export var scene_role: String = "mounted_payload"
@export var substrate_prop_kind: String = ""
@export var scene_path: String = ""
@export var model: String = ""
@export var direct_payload_reason: String = ""
@export var state_condition: String = ""
@export var route_modes: PackedStringArray = []
@export var offset: Vector3 = Vector3.ZERO
@export var rotation_degrees: Vector3 = Vector3.ZERO
@export var scale_3d: Vector3 = Vector3.ONE
@export var tags: PackedStringArray = []
