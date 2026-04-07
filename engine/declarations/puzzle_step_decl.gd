@tool
class_name PuzzleStepDecl
extends Resource
## One step in a puzzle's logical chain.

@export var step_id: String = ""
@export var description: String = ""         # Human-readable
@export var action: String = ""              # "interact", "use_item", "examine"
@export var target_interactable: String = "" # Interactable ID
@export var target_room: String = ""         # Room where this step occurs
@export var required_state: String = ""      # State expression
@export var required_items: PackedStringArray = []
@export var result_states: Dictionary = {}   # State set on step completion
@export var result_items: PackedStringArray = [] # Items given
