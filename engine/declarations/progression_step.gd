@tool
class_name ProgressionStep
extends Resource
## One step in a multi-step interaction sequence.

@export var step_id: String = ""
@export var required_state: String = ""      # State expression — must be true to reach this step
@export var required_items: PackedStringArray = []
@export var response: ResponseDecl = null    # Text + effects for this step
@export var consume_items: PackedStringArray = [] # Items consumed at this step
