@tool
class_name VariantDecl
extends Resource
## One side of a junction (A or B path).

@export var room_id: String = ""                         # Room where this variant lives
@export var interactables_active: PackedStringArray = []  # Dynamic/stateful setpieces that wake up on this branch
@export var interactables_static: PackedStringArray = []  # Dynamic setpieces that collapse back to inert scene dressing
@export var puzzle_steps: Array[PuzzleStepDecl] = []     # The self-contained or cross-room chain on this branch
@export var clue_overrides: Dictionary = {}               # {interactable_id: "clue text for this variant"}
