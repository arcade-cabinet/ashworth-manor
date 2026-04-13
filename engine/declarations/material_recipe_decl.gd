@tool
class_name MaterialRecipeDecl
extends Resource
## Declarative material recipe entry for the shared substrate library.

@export var recipe_id: String = ""
@export var family: String = "surface" # surface, foliage, terrain, liquid, glass, sky
@export var shader_family: String = "estate_surface"
@export var slots: Dictionary = {}
@export var options: Dictionary = {}
@export var notes: String = ""
