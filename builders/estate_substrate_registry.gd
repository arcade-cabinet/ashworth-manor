class_name EstateSubstrateRegistry
extends RefCounted
## Central resolver for the declaration-facing substrate contract.

const SubstratePresetDecl = preload("res://engine/declarations/substrate_preset_decl.gd")

const PRESET_ROOT := "res://declarations/substrate_presets"
const PRIMITIVE_FAMILIES := [
	"surface",
	"architecture",
	"foliage",
	"terrain_path",
	"liquid_glass_sky",
	"prop",
]
const MOUNT_FAMILIES := [
	"wall",
	"floor",
	"ceiling",
	"threshold",
	"gate_leaf",
	"table",
	"shelf",
	"sill",
	"mantel",
	"path_edge",
	"hedge_terminator",
	"water_edge",
	"facade_anchor",
]


static func preset_path(preset_id: String) -> String:
	if preset_id.is_empty():
		return ""
	return "%s/%s.tres" % [PRESET_ROOT, preset_id]


static func load_preset(preset_id: String) -> SubstratePresetDecl:
	var path := preset_path(preset_id)
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path) as SubstratePresetDecl


static func is_primitive_family_supported(family: String) -> bool:
	return PRIMITIVE_FAMILIES.has(family)


static func is_mount_family_supported(family: String) -> bool:
	return MOUNT_FAMILIES.has(family)


static func resolve_room_substrate_preset_id(world: WorldDeclaration, room_decl: RoomDeclaration) -> String:
	if room_decl == null:
		return ""
	if not room_decl.substrate_preset_id.is_empty():
		return room_decl.substrate_preset_id
	if world == null:
		return ""
	return world.resolve_substrate_preset_for_room(room_decl)
