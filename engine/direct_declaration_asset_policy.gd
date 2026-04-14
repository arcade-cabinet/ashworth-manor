class_name DirectDeclarationAssetPolicy
extends RefCounted


static func uses_direct_interactable_visual(decl) -> bool:
	return (not decl.model.is_empty() or not decl.scene_path.is_empty()) and decl.visual_kind.is_empty()


static func has_valid_direct_interactable_visual_reason(decl) -> bool:
	if not uses_direct_interactable_visual(decl):
		return decl.direct_visual_reason.is_empty()
	return not decl.direct_visual_reason.is_empty()


static func uses_direct_mount_payload_asset(decl) -> bool:
	return (not decl.scene_path.is_empty() or not decl.model.is_empty()) and decl.substrate_prop_kind.is_empty()


static func has_valid_direct_mount_payload_reason(decl) -> bool:
	if not uses_direct_mount_payload_asset(decl):
		return decl.direct_payload_reason.is_empty()
	return not decl.direct_payload_reason.is_empty()
