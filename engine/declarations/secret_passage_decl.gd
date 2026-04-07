@tool
class_name SecretPassageDecl
extends Resource
## A hidden or service-side route that preserves estate plausibility without breaking puzzle order.

const PassageAnchorDecl = preload("res://engine/declarations/passage_anchor_decl.gd")
const PassagePresentationDecl = preload("res://engine/declarations/passage_presentation_decl.gd")

@export var passage_id: String = ""
@export var from_room: String = ""
@export var to_room: String = ""

@export var anchor_from: PassageAnchorDecl = null
@export var anchor_to: PassageAnchorDecl = null

# Discovery/presentation
@export var discovery_mode: String = "hidden_interactable" # hidden_interactable, puzzle_reward, state_reveal, thread_variant, always_visible_but_unreadable
@export var reveal_condition: String = ""
@export var initially_known: bool = false
@export var presentation: PassagePresentationDecl = null

# Traversal semantics
@export var traversal_type: String = "crawl" # crawl, door, panel, stair, ladder, tunnel
@export var functional_role: String = ""     # service_route, family_route, occult_route, escape_route

# State and lock behavior
@export var one_way_until_revealed: bool = false
@export var once_open_always_open: bool = true
@export var locked: bool = false
@export var key_id: String = ""
