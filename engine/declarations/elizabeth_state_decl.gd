@tool
class_name ElizabethStateDecl
extends Resource
## An Elizabeth presence state in the sub-HSM.

@export var state_id: String = ""            # "dormant", "watching", "active", "confrontation"
@export var shadow_frequency: float = 0.0    # Periodic screen darken (0 = none)
@export var flicker_multiplier: float = 1.0  # Applied to all flickering lights
@export var whisper_sfx_interval: float = 0.0 # Seconds between whisper SFX (0 = none)
@export var whisper_sfx: String = ""
@export var mirror_delay: float = 0.0        # Seconds of reflection delay on mirror-type interactables
@export var affected_types: PackedStringArray = [] # Which interactable types are affected
