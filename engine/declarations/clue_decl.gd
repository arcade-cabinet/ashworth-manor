@tool
class_name ClueDecl
extends Resource
## A clue that hints at a puzzle's solution.

@export var interactable_id: String = ""     # Which interactable holds this clue
@export var room_id: String = ""             # Room the clue is in
@export var clue_text: String = ""           # The clue content
@export var required_state: String = ""      # Condition to reveal this clue
