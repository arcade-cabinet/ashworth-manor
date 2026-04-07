@tool
class_name PuzzleDeclaration
extends Resource
## A complete puzzle definition with steps, clues, and PRNG variation.

@export var puzzle_id: String = ""
@export var name: String = ""
@export var description: String = ""

# Steps -- the logical chain
@export var steps: Array[PuzzleStepDecl] = []
@export var sequential: bool = false

# Dependencies -- other puzzles that must be complete first
@export var requires_puzzles: PackedStringArray = []

# Completion
@export var completion_state: String = ""    # State expression that means "puzzle solved"
@export var reward_states: Dictionary = {}   # State set on completion
@export var reward_items: PackedStringArray = []

# Clues -- which interactables hint at this puzzle's solution
@export var clue_chain: Array[ClueDecl] = []

# PRNG variation -- what can change per seed
@export var variation_points: Array[PuzzleVariation] = []
