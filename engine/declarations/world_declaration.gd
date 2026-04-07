@tool
class_name WorldDeclaration
extends Resource
## Top-level game definition. Everything the game IS.

const SecretPassageDecl = preload("res://engine/declarations/secret_passage_decl.gd")
const RegionDecl = preload("res://engine/declarations/region_decl.gd")

# === Game start ===
@export var starting_room: String = "front_gate"
@export var starting_position: Vector3 = Vector3(0, 0, -8)
@export var starting_rotation_y: float = 180.0

# === Room registry -- validated bidirectional connectivity ===
@export var rooms: Array[RoomRef] = []
@export var connections: Array[Connection] = []
@export var secret_passages: Array[SecretPassageDecl] = []
@export var regions: Array[RegionDecl] = []

# === Environments -- per-area presets, rooms reference by name ===
@export var area_environments: Dictionary = {}

# === WEAVE SYSTEM -- Three-layer narrative threading ===

# Macro threads -- 3 emotional perspectives on the same story
@export var macro_threads: Array[MacroThread] = []

# Junctions -- where the needle picks A or B (diamonds and swaps)
@export var junctions: Array[JunctionDecl] = []

# PRNG seed -- 0 = random each playthrough
@export var prng_seed: int = 0

# === Game phases (HSM) ===
@export var phases: Array[PhaseDecl] = []
@export var phase_transitions: Array[PhaseTransition] = []

# === Elizabeth presence sub-HSM ===
@export var elizabeth_states: Array[ElizabethStateDecl] = []
@export var elizabeth_transitions: Array[ElizabethTransition] = []

# === Global triggers -- fire on state conditions regardless of current room ===
@export var global_triggers: Array[GlobalTrigger] = []

# === Endings -- 3 positive (per macro thread) + 2 negative (shared) ===
@export var endings: Array[EndingDecl] = []

# === Player config ===
@export var player: PlayerDeclaration = null

# === Accessibility ===
@export var accessibility: AccessibilityDecl = null


func get_connection(connection_id: String) -> Connection:
	for conn in connections:
		if conn != null and conn.id == connection_id:
			return conn
	return null


func get_connections_from_room(room_id: String) -> Array[Connection]:
	var matches: Array[Connection] = []
	for conn in connections:
		if conn != null and conn.from_room == room_id:
			matches.append(conn)
	return matches


func get_region_by_id(region_id: String) -> RegionDecl:
	for region in regions:
		if region != null and region.region_id == region_id:
			return region
	return null


func get_region_for_room(room_id: String) -> RegionDecl:
	for region in regions:
		if region == null:
			continue
		for region_room_id in region.room_ids:
			if region_room_id == room_id:
				return region
	return null


func get_region_neighbors(region_id: String) -> PackedStringArray:
	var region := get_region_by_id(region_id)
	return region.streaming_neighbors if region != null else PackedStringArray()


func get_regions_for_compiled_world(compiled_world_id: String) -> Array[RegionDecl]:
	var matches: Array[RegionDecl] = []
	if compiled_world_id.is_empty():
		return matches
	for region in regions:
		if region != null and region.compiled_world_id == compiled_world_id:
			matches.append(region)
	return matches


func get_compiled_world_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	var seen: Dictionary = {}
	for region in regions:
		if region == null or region.compiled_world_id.is_empty():
			continue
		if seen.has(region.compiled_world_id):
			continue
		seen[region.compiled_world_id] = true
		ids.append(region.compiled_world_id)
	return ids


func get_compiled_world_for_region(region_id: String) -> String:
	var region := get_region_by_id(region_id)
	if region == null:
		return ""
	return region.compiled_world_id


func get_compiled_world_for_room(room_id: String) -> String:
	var region := get_region_for_room(room_id)
	if region == null:
		return ""
	return region.compiled_world_id


func get_compiled_world_neighbors(compiled_world_id: String) -> PackedStringArray:
	var neighbors := PackedStringArray()
	if compiled_world_id.is_empty():
		return neighbors
	var seen: Dictionary = {}
	for region in get_regions_for_compiled_world(compiled_world_id):
		for neighbor_region_id in region.streaming_neighbors:
			var neighbor_world_id := get_compiled_world_for_region(neighbor_region_id)
			if neighbor_world_id.is_empty() or neighbor_world_id == compiled_world_id or seen.has(neighbor_world_id):
				continue
			seen[neighbor_world_id] = true
			neighbors.append(neighbor_world_id)
	return neighbors


func get_rooms_for_compiled_world(compiled_world_id: String) -> PackedStringArray:
	var room_ids := PackedStringArray()
	for region in get_regions_for_compiled_world(compiled_world_id):
		for room_id in region.room_ids:
			room_ids.append(room_id)
	return room_ids


func get_compiled_world_entry_rooms(compiled_world_id: String) -> PackedStringArray:
	var entry_rooms := PackedStringArray()
	if compiled_world_id.is_empty():
		return entry_rooms
	var seen: Dictionary = {}
	var world_rooms := get_rooms_for_compiled_world(compiled_world_id)
	for room_id in world_rooms:
		seen[room_id] = false
	if world_rooms.has(starting_room):
		seen[starting_room] = true
	for conn in connections:
		if conn == null:
			continue
		var to_world_id := get_compiled_world_for_room(conn.to_room)
		if to_world_id != compiled_world_id:
			continue
		var from_world_id := get_compiled_world_for_room(conn.from_room)
		if from_world_id != compiled_world_id:
			seen[conn.to_room] = true
	for room_id in seen:
		if seen[room_id]:
			entry_rooms.append(room_id)
	return entry_rooms
