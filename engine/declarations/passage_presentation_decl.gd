@tool
class_name PassagePresentationDecl
extends Resource
## How a secret passage is perceived before and after discovery.

@export var visible_form: String = ""       # bookshelf, hearth_panel, servant_door, hedge_gap, tomb_hatch
@export var model_path: String = ""

@export var closed_text: String = ""
@export var discovered_text: String = ""
@export var opened_text: String = ""

@export var discovery_feedback: PackedStringArray = []
@export var fx_on_reveal: Dictionary = {}

@export var sfx_reveal: String = ""
@export var sfx_open: String = ""
