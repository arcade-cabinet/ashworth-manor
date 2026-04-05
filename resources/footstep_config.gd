class_name FootstepConfig
## res://resources/footstep_config.gd -- Surface type mapping for rooms

## Room ID → surface type for floor meshes (used by metadata detector)
const ROOM_SURFACES: Dictionary = {
	"front_gate": "gravel",
	"garden": "grass",
	"chapel": "stone",
	"greenhouse": "dirt",
	"carriage_house": "dirt",
	"family_crypt": "stone",
	"foyer": "marble",
	"parlor": "wood_parquet",
	"dining_room": "wood_parquet",
	"kitchen": "stone",
	"upper_hallway": "carpet",
	"master_bedroom": "wood_parquet",
	"library": "wood_parquet",
	"guest_room": "wood_parquet",
	"storage_basement": "stone",
	"boiler_room": "metal_grate",
	"wine_cellar": "stone",
	"attic_stairs": "rough_wood",
	"attic_storage": "rough_wood",
	"hidden_room": "rough_wood",
}

## Surface types and their audio file prefixes
## Each surface needs 4 OGG variations at: assets/audio/footsteps/{surface}_{1-4}.ogg
const SURFACES: PackedStringArray = [
	"marble",
	"wood_parquet",
	"stone",
	"metal_grate",
	"rough_wood",
	"carpet",
	"dirt",
	"grass",
	"gravel",
]
