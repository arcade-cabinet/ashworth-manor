@tool
class_name PhaseTransition
extends Resource
## A transition between game phases, triggered by state conditions.

@export var from_phase: String = ""
@export var to_phase: String = ""
@export var trigger_condition: String = ""   # State expression
