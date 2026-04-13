@tool
class_name TerrainPresetDecl
extends Resource
## Declarative terrain/path profile for exterior grounds and approach spaces.

@export var preset_id: String = ""
@export var base_recipe_id: String = ""
@export var track_recipe_id: String = ""
@export var shoulder_recipe_id: String = ""
@export_file("*") var heightmap_path: String = ""
@export var supports_heightmap: bool = false
@export var path_profile: String = "flat_track"
@export var notes: String = ""
