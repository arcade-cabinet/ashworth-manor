@tool
class_name ActionDecl
extends Resource
## A single action executed by a trigger or response.

# One of these is set -- the action type
@export var set_state: Dictionary = {}       # Set state variables
@export var play_sfx: String = ""            # Play sound effect
@export var show_text: String = ""           # Show observation text
@export var show_room_name: String = ""      # Flash room name
@export var camera_shake: float = 0.0        # Shake trauma amount
@export var light_change: Dictionary = {}    # {light_id: {energy: X, duration: Y}}
@export var spawn_model: Dictionary = {}     # {model: path, position: vec3, scale: float, duration: float}
@export var psx_fade: float = 0.0            # Dither fade amount (0-1)
@export var delay_seconds: float = 0.0       # Wait before applying this action

# Accessibility: subtitle for narrative SFX
@export var subtitle_text: String = ""
