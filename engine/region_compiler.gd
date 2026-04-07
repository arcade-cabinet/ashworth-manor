class_name RegionCompiler
extends RefCounted
## Produces coherent macro-region compile plans from the estate graph.
## This is a planning/validation layer for now; runtime region emission will
## grow here instead of overloading RoomAssembler.

const CompiledWorldLayoutSolver = preload("res://engine/compiled_world_layout_solver.gd")

var _world: WorldDeclaration
var _room_decls: Dictionary = {}


func _init(world: WorldDeclaration, room_decls: Dictionary = {}) -> void:
	_world = world
	_room_decls = room_decls


func compile_plan() -> Dictionary:
	var region_plan := {}
	var compiled_world_plan := {}
	var layout_results: Dictionary = {}
	if not _room_decls.is_empty():
		layout_results = CompiledWorldLayoutSolver.new(_world, _room_decls).solve_all()
	for region in _world.regions:
		if region == null:
			continue
		var room_list := PackedStringArray()
		for room_id in region.room_ids:
			room_list.append(room_id)
		region_plan[region.region_id] = {
			"type": region.region_type,
			"rooms": room_list,
			"neighbors": region.streaming_neighbors,
			"compiled_world_id": region.compiled_world_id,
			"compiled_world_type": region.compiled_world_type,
		}
		if region.compiled_world_id.is_empty():
			continue
		if not compiled_world_plan.has(region.compiled_world_id):
			compiled_world_plan[region.compiled_world_id] = {
				"type": region.compiled_world_type,
				"regions": PackedStringArray(),
				"rooms": PackedStringArray(),
				"neighbors": PackedStringArray(),
				"entry_rooms": PackedStringArray(),
			}
		var world_entry: Dictionary = compiled_world_plan[region.compiled_world_id]
		var world_regions: PackedStringArray = world_entry["regions"]
		var world_rooms: PackedStringArray = world_entry["rooms"]
		world_regions.append(region.region_id)
		world_rooms.append_array(room_list)
		world_entry["regions"] = world_regions
		world_entry["rooms"] = world_rooms
		compiled_world_plan[region.compiled_world_id] = world_entry

	for compiled_world_id in compiled_world_plan.keys():
		var world_entry: Dictionary = compiled_world_plan[compiled_world_id]
		world_entry["neighbors"] = _world.get_compiled_world_neighbors(compiled_world_id)
		world_entry["entry_rooms"] = _world.get_compiled_world_entry_rooms(compiled_world_id)
		var layout_entry: Dictionary = layout_results.get(compiled_world_id, {})
		world_entry["room_offsets"] = layout_entry.get("offsets", {})
		world_entry["layout_conflicts"] = layout_entry.get("conflicts", [])
		compiled_world_plan[compiled_world_id] = world_entry

	return {
		"regions": region_plan,
		"compiled_worlds": compiled_world_plan,
	}
