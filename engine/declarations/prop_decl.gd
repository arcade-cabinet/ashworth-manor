@tool
class_name PropDecl
extends Resource
## A non-interactive model placed in a room (furniture, decoration).

const ContentPropRegistry = preload("res://engine/content_prop_registry.gd")

@export var id: String = ""
@export var scene_role: String = "static_model" # static_model, architectural_trim, threshold_trim, clue_dressing
@export var substrate_prop_kind: String = "" # shared procedural/runtime-owned substrate prop kind
@export var content_prop_kind: String = "" # shared imported-content prop kind
@export var substrate_waiver_reason: String = "" # required when architectural/threshold props bypass substrate kinds
@export var model: String = ""               # GLB path
@export var scene_path: String = ""          # Optional authored PackedScene for composite props
@export var position: Vector3 = Vector3.ZERO
@export var rotation_y: float = 0.0
@export var scale: float = 1.0
@export var scale_3d: Vector3 = Vector3.ONE
@export var tags: PackedStringArray = []


func uses_direct_model() -> bool:
	return not model.is_empty() and substrate_prop_kind.is_empty() and content_prop_kind.is_empty()


func uses_content_prop() -> bool:
	return not content_prop_kind.is_empty()


func has_valid_content_prop_contract(room_id: String) -> bool:
	if not uses_content_prop():
		return true
	if not ContentPropRegistry.has_kind(content_prop_kind):
		return false
	var expected_family := ContentPropRegistry.expected_content_family_for_room(room_id)
	if expected_family.is_empty():
		return false
	return ContentPropRegistry.family_for_kind(content_prop_kind) == expected_family
