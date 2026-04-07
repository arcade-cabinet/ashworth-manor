@tool
class_name ItemDeclaration
extends Resource
## An item that can be found, held, and used.

@export var item_id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var category: String = ""            # key, document, artifact, ritual_component
@export var is_ritual_component: bool = false
@export var is_consumable: bool = false

# Functional slot -- items sharing a slot are interchangeable for puzzle purposes
@export var functional_slot: String = ""

# Thread visibility -- which macro threads this item exists on
@export var thread_active: PackedStringArray = []  # Empty = all threads

# Where it's found (default -- junction variants may redirect this)
@export var found_in_room: String = ""
@export var found_at_interactable: String = ""
@export var found_condition: String = ""

# What it unlocks -- matches on functional_slot OR specific item_id
@export var unlocks_interactable: String = ""
@export var unlocks_in_room: String = ""
