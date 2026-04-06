@tool
class_name LightDecl
extends Resource
## A light source in a room.

@export var id: String = ""
@export var type: String = "omni"            # omni, directional, spot
@export var position: Vector3 = Vector3.ZERO
@export var color: Color = Color(1, 0.9, 0.7)
@export var energy: float = 1.0
@export var range: float = 8.0
@export var shadows: bool = false
@export var flickering: bool = false
@export var flicker_pattern: String = ""     # "candle", "fire", "torch", "gas"
@export var switchable: bool = false
@export var switch_id: String = ""           # Interactable ID that controls this light
