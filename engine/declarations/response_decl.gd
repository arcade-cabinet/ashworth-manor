@tool
class_name ResponseDecl
extends Resource
## Conditional text + effects for an interactable response.

# Condition -- state expression evaluated at interaction time
# Empty string = default (always matches if no higher-priority response matched)
@export var condition: String = ""

# Content -- supports PRNG interpolation via {prng:variable_name} placeholders
@export var title: String = ""
@export var text: String = ""

# State mutations -- executed when this response is shown
@export var set_state: Dictionary = {}       # {variable_name: value}

# Item rewards on this specific response
@export var gives_item: String = ""
@export var gives_item_condition: String = ""
@export var also_gives: String = ""

# SFX
@export var play_sfx: String = ""

# Accessibility: subtitle for audio-only narrative events
@export var subtitle_text: String = ""
