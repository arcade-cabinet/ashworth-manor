extends Node
## Tracks compiled-world runtime state separately from per-room assembly/loading.

const RegionCompilerScript = preload("res://engine/region_compiler.gd")

signal compiled_world_changed(previous_world_id: String, current_world_id: String)
signal region_changed(previous_region_id: String, current_region_id: String)

const WORLD_DECLARATION_PATH := "res://declarations/world.tres"

var _world: WorldDeclaration = null
var _compile_plan: Dictionary = {}
var _current_room_id: String = ""
var _current_region_id: String = ""
var _current_compiled_world_id: String = ""
var _prewarmed_world_ids := PackedStringArray()


func _ready() -> void:
	bootstrap()


func bootstrap(world: WorldDeclaration = null, room_decls: Dictionary = {}) -> void:
	if world != null:
		_world = world
	elif ResourceLoader.exists(WORLD_DECLARATION_PATH):
		_world = load(WORLD_DECLARATION_PATH) as WorldDeclaration
	else:
		_world = null
	if _world == null:
		_compile_plan = {}
		_current_room_id = ""
		_current_region_id = ""
		_current_compiled_world_id = ""
		_prewarmed_world_ids = PackedStringArray()
		return
	_compile_plan = RegionCompilerScript.new(_world, room_decls).compile_plan()


func set_active_room(room_id: String) -> void:
	_current_room_id = room_id
	var previous_region_id := _current_region_id
	var previous_world_id := _current_compiled_world_id
	_current_region_id = ""
	_current_compiled_world_id = ""
	_prewarmed_world_ids = PackedStringArray()
	if _world != null and not room_id.is_empty():
		var region := _world.get_region_for_room(room_id)
		if region != null:
			_current_region_id = region.region_id
			_current_compiled_world_id = region.compiled_world_id
		if not _current_compiled_world_id.is_empty():
			_prewarmed_world_ids = _world.get_compiled_world_neighbors(_current_compiled_world_id)
	if previous_region_id != _current_region_id:
		region_changed.emit(previous_region_id, _current_region_id)
	if previous_world_id != _current_compiled_world_id:
		compiled_world_changed.emit(previous_world_id, _current_compiled_world_id)


func get_world() -> WorldDeclaration:
	return _world


func get_compile_plan() -> Dictionary:
	return _compile_plan.duplicate(true)


func get_region_plan() -> Dictionary:
	return _compile_plan.get("regions", {}).duplicate(true)


func get_compiled_world_plan() -> Dictionary:
	return _compile_plan.get("compiled_worlds", {}).duplicate(true)


func get_current_room_id() -> String:
	return _current_room_id


func get_current_region_id() -> String:
	return _current_region_id


func get_current_compiled_world_id() -> String:
	return _current_compiled_world_id


func get_prewarmed_world_ids() -> PackedStringArray:
	return _prewarmed_world_ids


func get_region_for_room_id(room_id: String):
	if _world == null or room_id.is_empty():
		return null
	return _world.get_region_for_room(room_id)


func get_compiled_world_for_room_id(room_id: String) -> String:
	if _world == null or room_id.is_empty():
		return ""
	return _world.get_compiled_world_for_room(room_id)


func get_compiled_world_neighbors(world_id: String) -> PackedStringArray:
	if _world == null or world_id.is_empty():
		return PackedStringArray()
	return _world.get_compiled_world_neighbors(world_id)
