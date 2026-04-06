@tool
class_name StateVarDecl
extends Resource
## A single state variable declaration.

@export var name: String = ""
@export var type: String = "bool"            # bool, int, string, list
@export var initial_value: String = "false"  # Serialized initial value
@export var description: String = ""         # What this variable means
@export var set_by: PackedStringArray = []   # What interactables/triggers SET this
@export var read_by: PackedStringArray = []  # What responses/triggers READ this
@export var prng_eligible: bool = false      # Can PRNG shuffle what sets this?
