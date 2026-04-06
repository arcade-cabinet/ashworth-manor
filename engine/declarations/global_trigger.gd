@tool
class_name GlobalTrigger
extends Resource
## Cross-room event that fires when a state condition becomes true, regardless of current room.

@export var trigger_id: String = ""
@export var condition: String = ""           # State expression — evaluated on EVERY state change
@export var once: bool = true
@export var actions: Array[ActionDecl] = []
