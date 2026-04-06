@tool
class_name AmbientEventDecl
extends Resource
## A timed periodic event in a room (creak, wind gust, drip).

@export var event_id: String = ""
@export var interval_min: float = 10.0       # Minimum seconds between triggers
@export var interval_max: float = 30.0       # Maximum seconds between triggers
@export var condition: String = ""           # State expression (empty = always active)
@export var actions: Array[ActionDecl] = []
