@tool
class_name JunctionDecl
extends Resource
## A narrative junction where the PRNG needle picks A or B.

@export var junction_id: String = ""
@export var junction_type: String = ""       # "diamond" (cross-room paths) or "swap" (within-room puzzle)
@export var functional_slot: String = ""     # What both variants produce ("attic_access_key")

@export var variant_a: VariantDecl = null
@export var variant_b: VariantDecl = null

# Macro threads suggest which variant maintains emotional coherence
# PRNG can still flip for variety on subsequent playthroughs of same macro thread
@export var macro_preference: Dictionary = {} # {"captive": "A", "mourning": "B", "sovereign": "A"}
