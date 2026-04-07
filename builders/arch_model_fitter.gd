class_name ArchModelFitter
extends RefCounted
## Fits imported architectural GLBs into the logical dimensions expected by the
## procedural builders, so declarations can stay in world units.


static func fit(inst: Node, target_size: Vector3, center_xz: bool = true, anchor_bottom: bool = true) -> Node3D:
	var root := Node3D.new()
	root.name = "FittedModel"
	root.add_child(inst)

	if not inst is Node3D:
		return root

	var node_3d: Node3D = inst as Node3D
	var bounds = _collect_bounds(node_3d)
	if bounds == null:
		return root

	var scale := Vector3.ONE
	if target_size.x > 0.0 and bounds.size.x > 0.001:
		scale.x = target_size.x / bounds.size.x
	if target_size.y > 0.0 and bounds.size.y > 0.001:
		scale.y = target_size.y / bounds.size.y
	if target_size.z > 0.0 and bounds.size.z > 0.001:
		scale.z = target_size.z / bounds.size.z
	node_3d.scale = scale

	var offset := Vector3.ZERO
	if center_xz:
		offset.x = -(bounds.position.x + bounds.size.x * 0.5) * scale.x
		offset.z = -(bounds.position.z + bounds.size.z * 0.5) * scale.z
	if anchor_bottom:
		offset.y = -bounds.position.y * scale.y
	else:
		offset.y = -(bounds.position.y + bounds.size.y * 0.5) * scale.y
	node_3d.position = offset

	return root


static func _collect_bounds(node: Node3D):
	var has_bounds := false
	var merged := AABB()

	if node is VisualInstance3D:
		var aabb := (node as VisualInstance3D).get_aabb()
		if aabb.size.length_squared() > 0.0:
			merged = aabb
			has_bounds = true

	for child in node.get_children():
		if not child is Node3D:
			continue
		var child_node: Node3D = child as Node3D
		var child_bounds = _collect_bounds(child_node)
		if child_bounds == null:
			continue
		var transformed = child_node.transform * child_bounds
		merged = transformed if not has_bounds else merged.merge(transformed)
		has_bounds = true

	return merged if has_bounds else null
