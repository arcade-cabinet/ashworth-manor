@tool
class_name PropDecl
extends Resource
## A non-interactive model placed in a room (furniture, decoration).

@export var id: String = ""
@export var model: String = ""               # GLB path
@export var position: Vector3 = Vector3.ZERO
@export var rotation_y: float = 0.0
@export var scale: float = 1.0
