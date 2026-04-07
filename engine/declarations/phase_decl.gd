@tool
class_name PhaseDecl
extends Resource
## A game phase in the HSM (Exploration, Discovery, Horror, Resolution).

@export var phase_id: String = ""
@export var phase_name: String = ""
@export var description: String = ""
@export var tension_volume: float = 0.0      # AdaptiSound tension layer volume scale
@export var flicker_intensity: float = 1.0   # Multiplier for flickering lights
