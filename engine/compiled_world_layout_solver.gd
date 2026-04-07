class_name CompiledWorldLayoutSolver
extends RefCounted
## Solves relative room offsets inside a compiled world using authored threshold
## alignment. This is the first step toward live multi-room world slices.

const ALIGNMENT_TOLERANCE := 0.35

var _world: WorldDeclaration
var _room_decls: Dictionary = {}


func _init(world: WorldDeclaration, room_decls: Dictionary = {}) -> void:
	_world = world
	_room_decls = room_decls


func solve_world(compiled_world_id: String) -> Dictionary:
	var offsets: Dictionary = {}
	var conflicts: Array[String] = []
	if _world == null or compiled_world_id.is_empty():
		return {
			"offsets": offsets,
			"conflicts": conflicts,
		}

	var room_ids: PackedStringArray = _world.get_rooms_for_compiled_world(compiled_world_id)
	if room_ids.is_empty():
		return {
			"offsets": offsets,
			"conflicts": conflicts,
		}

	var queue: Array[String] = []
	var seeds: PackedStringArray = _world.get_compiled_world_entry_rooms(compiled_world_id)
	if seeds.is_empty():
		seeds.append(room_ids[0])

	for seed_room_id in seeds:
		if offsets.has(seed_room_id):
			continue
		offsets[seed_room_id] = Vector3.ZERO
		queue.append(seed_room_id)
		while not queue.is_empty():
			var from_room_id: String = queue.pop_front()
			var from_offset: Vector3 = offsets.get(from_room_id, Vector3.ZERO)
			for conn in _world.get_connections_from_room(from_room_id):
				if conn == null:
					continue
				if _world.get_compiled_world_for_room(conn.to_room) != compiled_world_id:
					continue
				var candidate := from_offset + _get_from_alignment_point(from_room_id, conn) - _get_to_alignment_point(conn)
				if not offsets.has(conn.to_room):
					offsets[conn.to_room] = candidate
					queue.append(conn.to_room)
					continue
				var existing: Vector3 = offsets[conn.to_room]
				if existing.distance_to(candidate) > ALIGNMENT_TOLERANCE:
					conflicts.append("Compiled world '%s' has inconsistent placement for room '%s' via connection '%s' (%s vs %s)" % [
						compiled_world_id, conn.to_room, conn.id, existing, candidate
					])

	for room_id in room_ids:
		if not offsets.has(room_id):
			conflicts.append("Compiled world '%s' could not derive placement for room '%s'" % [
				compiled_world_id, room_id
			])
			offsets[room_id] = Vector3.ZERO

	return {
		"offsets": offsets,
		"conflicts": conflicts,
	}


func solve_all() -> Dictionary:
	var results: Dictionary = {}
	if _world == null:
		return results
	for compiled_world_id in _world.get_compiled_world_ids():
		results[compiled_world_id] = solve_world(compiled_world_id)
	return results


func _get_from_alignment_point(room_id: String, conn: Connection) -> Vector3:
	var point: Vector3 = conn.position_in_from
	if not conn.from_anchor_id.is_empty():
		var room_decl := _room_decls.get(room_id, null) as RoomDeclaration
		var anchor: Variant = _find_anchor(room_decl, conn.from_anchor_id)
		if anchor != null:
			point = anchor.position
	return _normalize_alignment_point(room_id, point, conn, true)


func _get_to_alignment_point(conn: Connection) -> Vector3:
	var point: Vector3 = conn.position_in_to
	if not conn.to_anchor_id.is_empty():
		var room_decl := _room_decls.get(conn.to_room, null) as RoomDeclaration
		var anchor: Variant = _find_anchor(room_decl, conn.to_anchor_id)
		if anchor != null:
			point = anchor.position
	return _normalize_alignment_point(conn.to_room, point, conn, false)


func _normalize_alignment_point(room_id: String, point: Vector3, conn: Connection, is_source: bool) -> Vector3:
	if conn == null:
		return point
	if _uses_floor_plane_alignment(conn):
		return _project_to_threshold_plane(room_id, point, conn, is_source)
	if _uses_vertical_boundary_alignment(conn):
		return _project_to_vertical_threshold_plane(room_id, point, conn, is_source)
	return point


func _uses_floor_plane_alignment(conn: Connection) -> bool:
	match conn.type:
		"stairs", "ladder", "trapdoor":
			return false
		_:
			return true


func _uses_vertical_boundary_alignment(conn: Connection) -> bool:
	match conn.type:
		"stairs", "ladder", "trapdoor":
			return conn.direction == "up" or conn.direction == "down"
		_:
			return false


func _project_to_threshold_plane(room_id: String, point: Vector3, conn: Connection, is_source: bool) -> Vector3:
	var room_decl := _room_decls.get(room_id, null) as RoomDeclaration
	if room_decl == null:
		return Vector3(point.x, 0.0, point.z)
	var resolved_direction := conn.direction
	if not is_source:
		resolved_direction = _opposite_direction(conn.direction)
	var projected := Vector3(point.x, 0.0, point.z)
	match resolved_direction:
		"north":
			projected.z = room_decl.dimensions.z * 0.5
		"south":
			projected.z = -room_decl.dimensions.z * 0.5
		"east":
			projected.x = room_decl.dimensions.x * 0.5
		"west":
			projected.x = -room_decl.dimensions.x * 0.5
	return projected


func _project_to_vertical_threshold_plane(room_id: String, point: Vector3, conn: Connection, is_source: bool) -> Vector3:
	var room_decl := _room_decls.get(room_id, null) as RoomDeclaration
	if room_decl == null:
		return point
	var resolved_direction := conn.direction
	if not is_source:
		resolved_direction = _opposite_direction(conn.direction)
	var projected := point
	match resolved_direction:
		"up":
			projected.y = room_decl.dimensions.y
		"down":
			projected.y = 0.0
	return projected


func _opposite_direction(direction: String) -> String:
	match direction:
		"north":
			return "south"
		"south":
			return "north"
		"east":
			return "west"
		"west":
			return "east"
		"up":
			return "down"
		"down":
			return "up"
		_:
			return direction


func _find_anchor(room_decl: RoomDeclaration, anchor_id: String):
	if room_decl == null or anchor_id.is_empty():
		return null
	for anchor in room_decl.entry_anchors:
		if anchor != null and anchor.anchor_id == anchor_id:
			return anchor
	for anchor in room_decl.focal_anchors:
		if anchor != null and anchor.anchor_id == anchor_id:
			return anchor
	return null
