class_name DirectPropRegistry
extends RefCounted

const ALLOWED_DIRECT_MODEL_FAMILIES := {
	"debris": true,
	"stored_clutter": true,
	"service_infrastructure": true,
	"table_service": true,
	"entry_dressing": true,
	"personal_effects": true,
	"occult_dressing": true,
	"tool_clutter": true,
	"study_dressing": true,
	"hearth_dressing": true,
	"storage_clutter": true,
	"passage_dressing": true,
}

const EXPECTED_DIRECT_MODEL_FAMILY_BY_ROOM := {
	"attic_stairs": "debris",
	"attic_storage": "stored_clutter",
	"boiler_room": "service_infrastructure",
	"dining_room": "table_service",
	"foyer": "entry_dressing",
	"guest_room": "personal_effects",
	"hidden_chamber": "occult_dressing",
	"kitchen": "tool_clutter",
	"library": "study_dressing",
	"master_bedroom": "personal_effects",
	"parlor": "hearth_dressing",
	"storage_basement": "storage_clutter",
	"upper_hallway": "passage_dressing",
	"wine_cellar": "storage_clutter",
}


static func is_allowed_direct_model_family(family: String) -> bool:
	return ALLOWED_DIRECT_MODEL_FAMILIES.has(family)


static func expected_direct_model_family_for_room(room_id: String) -> String:
	return String(EXPECTED_DIRECT_MODEL_FAMILY_BY_ROOM.get(room_id, ""))
