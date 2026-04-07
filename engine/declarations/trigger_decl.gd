@tool
class_name TriggerDecl
extends Resource
## A room-local trigger (entry, exit, conditional).

@export var condition: String = ""           # State expression (empty = always)
@export var once: bool = true                # Only fire once? (tracked by trigger ID)
@export var trigger_id: String = ""          # For tracking "already fired"
@export var actions: Array[ActionDecl] = []
