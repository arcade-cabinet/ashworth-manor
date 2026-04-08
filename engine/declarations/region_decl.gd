@tool
class_name RegionDecl
extends Resource
## Macro compiled domain inside the estate graph.

@export var region_id: String = ""
@export var region_type: String = "" # entrance_exterior, public_interior, service_interior, private_interior, discovery_exterior
@export var compiled_world_id: String = "" # entrance_path_world, manor_interior_world, rear_grounds_world, service_basement_world
@export var compiled_world_type: String = "" # exterior_path, interior_world, grounds_world, service_world, flashback_world
@export var default_environment_preset: String = ""
@export var default_substrate_preset_id: String = ""
@export var allowed_mount_families: PackedStringArray = []
@export var room_ids: PackedStringArray = []
@export var streaming_neighbors: PackedStringArray = []
@export var notes: String = ""
