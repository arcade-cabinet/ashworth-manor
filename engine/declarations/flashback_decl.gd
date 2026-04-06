@tool
class_name FlashbackDecl
extends Resource
## A horror flashback sequence -- spawn model + PSX fade + stinger.

@export var flashback_id: String = ""
@export var condition: String = ""           # State expression to trigger
@export var once: bool = true
@export var model: String = ""               # GLB path for horror model
@export var model_position: Vector3 = Vector3.ZERO
@export var model_scale: float = 1.0
@export var duration: float = 3.0            # How long the model is visible
@export var fade_amount: float = 0.5         # PSX dither fade intensity
@export var stinger_sfx: String = ""         # Stinger sound
@export var camera_shake: float = 0.1        # Trauma amount
