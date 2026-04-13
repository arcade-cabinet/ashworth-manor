@tool
class_name SubstratePresetDecl
extends Resource
## Region-facing substrate preset describing the allowed physical language.

@export var preset_id: String = ""
@export var region_family: String = ""
@export var primitive_families: PackedStringArray = []
@export var dominant_material_recipes: PackedStringArray = []
@export var terrain_preset_id: String = ""
@export var sky_preset_id: String = ""
@export var allowed_mount_families: PackedStringArray = []
@export var default_light_grammar: String = ""
@export var approved_builders: PackedStringArray = []
@export var notes: String = ""
