@tool
class_name ElizabethTransition
extends Resource
## A transition in Elizabeth's presence sub-HSM.

@export var from_state: String = ""
@export var to_state: String = ""
@export var trigger_condition: String = ""   # State expression
