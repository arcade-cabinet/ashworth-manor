@tool
class_name VariantDecl
extends Resource
## One side of a junction (A or B path).

@export var room_id: String = ""                         # Room where this variant lives
@export var interactables_active: PackedStringArray = []  # IDs that become interactive
@export var interactables_static: PackedStringArray = []  # IDs that become inert props
@export var puzzle_steps: Array[PuzzleStepDecl] = []     # The puzzle chain
@export var clue_overrides: Dictionary = {}               # {interactable_id: "clue text for this variant"}
