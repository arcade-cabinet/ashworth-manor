class_name GraphCompiler
extends RefCounted
## Validates world topology and region coverage before runtime compilation.

const CompiledWorldLayoutSolver = preload("res://engine/compiled_world_layout_solver.gd")

var _world: WorldDeclaration
var _room_decls: Dictionary = {}


func _init(world: WorldDeclaration, room_decls: Dictionary = {}) -> void:
	_world = world
	_room_decls = room_decls


func validate() -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	var region_count := _world.regions.size()
	var compiled_worlds: Dictionary = {}
	var compiled_world_neighbors: Dictionary = {}

	var known_rooms: Dictionary = {}
	for room_ref in _world.rooms:
		known_rooms[room_ref.room_id] = true

	var assigned_rooms: Dictionary = {}
	for region in _world.regions:
		if region == null:
			errors.append("World has null region declaration")
			continue
		if region.region_id.is_empty():
			errors.append("Region with empty region_id")
		if region.compiled_world_id.is_empty():
			errors.append("Region '%s' is missing compiled_world_id" % region.region_id)
		if region.compiled_world_type.is_empty():
			warnings.append("Region '%s' is missing compiled_world_type" % region.region_id)
		if not region.compiled_world_id.is_empty() and not compiled_worlds.has(region.compiled_world_id):
			compiled_worlds[region.compiled_world_id] = []
			compiled_world_neighbors[region.compiled_world_id] = {}
		if not region.compiled_world_id.is_empty():
			var world_regions: Array = compiled_worlds[region.compiled_world_id]
			world_regions.append(region.region_id)
			compiled_worlds[region.compiled_world_id] = world_regions
			for neighbor_region_id in region.streaming_neighbors:
				var neighbor_world_id := _world.get_compiled_world_for_region(neighbor_region_id)
				if not neighbor_world_id.is_empty() and neighbor_world_id != region.compiled_world_id:
					var world_neighbor_map: Dictionary = compiled_world_neighbors[region.compiled_world_id]
					world_neighbor_map[neighbor_world_id] = true
					compiled_world_neighbors[region.compiled_world_id] = world_neighbor_map
		for room_id in region.room_ids:
			if room_id not in known_rooms:
				errors.append("Region '%s' references unknown room '%s'" % [region.region_id, room_id])
			elif room_id in assigned_rooms:
				errors.append("Room '%s' assigned to multiple regions ('%s', '%s')" % [
					room_id, assigned_rooms[room_id], region.region_id
				])
			else:
				assigned_rooms[room_id] = region.region_id

	for room_id in _room_decls:
		var room: RoomDeclaration = _room_decls[room_id]
		if room.entry_anchors.is_empty():
			warnings.append("Room '%s' has no entry anchors" % room_id)
		if room.focal_anchors.is_empty():
			warnings.append("Room '%s' has no focal anchors" % room_id)
		var seen_anchor_ids: Dictionary = {}
		for anchor in room.entry_anchors:
			if anchor.anchor_id.is_empty():
				errors.append("Room '%s' has entry anchor with empty id" % room_id)
			elif anchor.anchor_id in seen_anchor_ids:
				errors.append("Room '%s' has duplicate anchor id '%s'" % [room_id, anchor.anchor_id])
			else:
				seen_anchor_ids[anchor.anchor_id] = true
		for anchor in room.focal_anchors:
			if anchor.anchor_id.is_empty():
				errors.append("Room '%s' has focal anchor with empty id" % room_id)
			elif anchor.anchor_id in seen_anchor_ids:
				errors.append("Room '%s' has duplicate anchor id '%s'" % [room_id, anchor.anchor_id])
			else:
				seen_anchor_ids[anchor.anchor_id] = true

	if region_count == 0:
		warnings.append("World has no macro regions declared")
	else:
		for room_id in known_rooms:
			if room_id not in assigned_rooms:
				errors.append("Room '%s' is not assigned to a region" % room_id)
	for compiled_world_id in compiled_worlds:
		var world_regions: Array = compiled_worlds[compiled_world_id]
		if world_regions.is_empty():
			errors.append("Compiled world '%s' has no regions" % compiled_world_id)
		var entry_rooms := _world.get_compiled_world_entry_rooms(compiled_world_id)
		if entry_rooms.is_empty():
			errors.append("Compiled world '%s' has no valid entry room" % compiled_world_id)
		var neighbor_map: Dictionary = compiled_world_neighbors.get(compiled_world_id, {})
		for neighbor_world_id in neighbor_map.keys():
			var reverse_neighbors: Dictionary = compiled_world_neighbors.get(neighbor_world_id, {})
			if not reverse_neighbors.has(compiled_world_id):
				errors.append("Compiled world '%s' lists '%s' as neighbor but reverse link is missing" % [
					compiled_world_id, neighbor_world_id
				])
	if not _room_decls.is_empty():
		var layout_results: Dictionary = CompiledWorldLayoutSolver.new(_world, _room_decls).solve_all()
		for compiled_world_id in layout_results:
			var layout_entry: Dictionary = layout_results[compiled_world_id]
			for conflict in layout_entry.get("conflicts", []):
				errors.append(conflict)

	return {
		"errors": errors,
		"warnings": warnings,
		"regions_checked": region_count,
		"compiled_worlds_checked": compiled_worlds.size(),
	}
