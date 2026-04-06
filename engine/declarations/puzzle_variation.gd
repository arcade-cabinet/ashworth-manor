@tool
class_name PuzzleVariation
extends Resource
## A PRNG-variable aspect of a puzzle (item location, clue content, code value).

@export var what_varies: String = ""         # "item_location" | "clue_content" | "code_value"
@export var default_value: String = ""       # Normal placement
@export var alternatives: PackedStringArray = [] # Other valid placements
@export var constraint: String = ""          # "must_be_accessible_before:attic_door"

# PRNG text interpolation
@export var prng_var_name: String = ""       # e.g., "attic_key_location_hint"
@export var text_variants: Dictionary = {}   # {"library_globe": "the library globe", ...}
