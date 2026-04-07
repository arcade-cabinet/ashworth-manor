@tool
class_name ConditionalEventDecl
extends Resource
## An event that fires when a state condition becomes true while in this room.

@export var event_id: String = ""
@export var condition: String = ""           # State expression
@export var once: bool = true
@export var actions: Array[ActionDecl] = []
