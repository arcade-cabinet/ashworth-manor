extends Node3D
## res://scripts/room_manager.gd -- Declaration-first room lifecycle with simple full-screen fades

const RegionCompilerScript = preload("res://engine/region_compiler.gd")
const RoomAnchorDeclScript = preload("res://engine/declarations/room_anchor_decl.gd")

signal room_loaded(room_id: String)
signal room_transition_started
signal room_transition_finished
signal region_changed(previous_region_id: String, current_region_id: String)
signal compiled_world_changed(previous_world_id: String, current_world_id: String)

const COMPILED_WORLD_VISIBILITY_DEPTH := 1

# Transition durations by connection type
const FADE_DURATIONS: Dictionary = {
	"door": 0.6,
	"stairs": 0.8,
	"ladder": 1.0,
	"trapdoor": 0.9,
	"path": 0.5,
}

var _current_room: RoomBase = null
var _current_room_id: String = ""
var _room_container: Node3D = null
var _fade_rect: ColorRect = null
var _fade_layer: CanvasLayer = null
var _is_transitioning: bool = false
var _world: WorldDeclaration = null
var _world_runtime_manager: Node = null
var _assembler: RoomAssembler = null
var _declaration_registry: Dictionary = {}
var _pending_entry_connection_id: String = ""
var _current_region_id: String = ""
var _current_region = null
var _current_compiled_world_id: String = ""
var _region_plan: Dictionary = {}
var _compiled_world_plan: Dictionary = {}
var _loaded_compiled_world_id: String = ""
var _compiled_world_instances: Dictionary = {}

# Room registry: room_id -> scene path
var _room_registry: Dictionary = {
	"front_gate": "res://scenes/rooms/grounds/front_gate.tscn",
	"garden": "res://scenes/rooms/grounds/garden.tscn",
	"chapel": "res://scenes/rooms/grounds/chapel.tscn",
	"greenhouse": "res://scenes/rooms/grounds/greenhouse.tscn",
	"carriage_house": "res://scenes/rooms/grounds/carriage_house.tscn",
	"family_crypt": "res://scenes/rooms/grounds/family_crypt.tscn",
	"foyer": "res://scenes/rooms/ground_floor/foyer.tscn",
	"parlor": "res://scenes/rooms/ground_floor/parlor.tscn",
	"dining_room": "res://scenes/rooms/ground_floor/dining_room.tscn",
	"kitchen": "res://scenes/rooms/ground_floor/kitchen.tscn",
	"upper_hallway": "res://scenes/rooms/upper_floor/hallway.tscn",
	"master_bedroom": "res://scenes/rooms/upper_floor/master_bedroom.tscn",
	"library": "res://scenes/rooms/upper_floor/library.tscn",
	"guest_room": "res://scenes/rooms/upper_floor/guest_room.tscn",
	"storage_basement": "res://scenes/rooms/basement/storage.tscn",
	"boiler_room": "res://scenes/rooms/basement/boiler_room.tscn",
	"wine_cellar": "res://scenes/rooms/deep_basement/wine_cellar.tscn",
	"attic_stairs": "res://scenes/rooms/attic/stairwell.tscn",
	"attic_storage": "res://scenes/rooms/attic/storage.tscn",
	"hidden_chamber": "res://scenes/rooms/attic/hidden_chamber.tscn",
}


func _ready() -> void:
	_load_world_registry()
	_room_container = Node3D.new()
	_room_container.name = "RoomContainer"
	add_child(_room_container)
	_setup_fade_overlay()
	call_deferred("_load_initial_room")


func load_room(room_id: String, entry_connection_id: String = "") -> void:
	var target_compiled_world_id: String = get_compiled_world_for_room_id(room_id)
	var room_instance: Node = null

	if not target_compiled_world_id.is_empty():
		_ensure_compiled_world_loaded(target_compiled_world_id)
		room_instance = _compiled_world_instances.get(room_id, null)
	else:
		_clear_room_container()
		room_instance = _instantiate_room(room_id)
		if room_instance != null:
			_room_container.add_child(room_instance)

	if room_instance == null:
		push_warning("RoomManager: Failed to load room '%s'" % room_id)
		return
	_pending_entry_connection_id = entry_connection_id
	_activate_room_instance(room_instance, room_id, true)


func transition_to(room_id: String, conn_type: String = "door", connection_id: String = "") -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	_pending_entry_connection_id = connection_id
	room_transition_started.emit()

	var profile := _resolve_transition_profile(room_id, conn_type, connection_id)
	var duration: float = profile.get("duration", FADE_DURATIONS.get(conn_type, 0.6))
	var hold: float = profile.get("hold", 0.0)
	var do_fade: bool = profile.get("fade", true)
	var traversal_anim: bool = profile.get("traversal_anim", false)

	if traversal_anim:
		var player := get_node_or_null("/root/Main/PlayerController")
		if player != null and player.has_method("play_traversal_animation"):
			player.play_traversal_animation(conn_type, duration, Callable(self, "_execute_transition_after_traversal").bind(room_id, do_fade, duration, hold))
			return

	_execute_transition_after_traversal(room_id, do_fade, duration, hold)


func get_current_room_id() -> String:
	return _current_room_id


func get_current_room() -> RoomBase:
	return _current_room


func get_current_room_data() -> Dictionary:
	if _current_room == null:
		return {}
	return {
		"room_id": _current_room.room_id,
		"room_name": _current_room.room_name,
		"audio_loop": _current_room.audio_loop,
		"region_id": _current_region_id,
		"compiled_world_id": _current_compiled_world_id,
	}


func get_current_region_id() -> String:
	return _current_region_id


func get_current_region():
	return _current_region


func get_region_plan() -> Dictionary:
	return _region_plan.duplicate(true)


func get_compiled_world_plan() -> Dictionary:
	return _compiled_world_plan.duplicate(true)


func get_current_region_neighbors() -> PackedStringArray:
	if _current_region == null:
		return PackedStringArray()
	return _current_region.streaming_neighbors


func get_current_compiled_world_id() -> String:
	return _current_compiled_world_id


func get_current_compiled_world_neighbors() -> PackedStringArray:
	if _world_runtime_manager != null and _world_runtime_manager.has_method("get_prewarmed_world_ids"):
		return _world_runtime_manager.get_prewarmed_world_ids()
	if _world == null or _current_compiled_world_id.is_empty():
		return PackedStringArray()
	return _world.get_compiled_world_neighbors(_current_compiled_world_id)


func get_loaded_compiled_world_id() -> String:
	return _loaded_compiled_world_id


func get_loaded_compiled_world_room_ids() -> PackedStringArray:
	var room_ids := PackedStringArray()
	for room_id in _compiled_world_instances.keys():
		room_ids.append(String(room_id))
	return room_ids


func get_visible_compiled_world_room_ids() -> PackedStringArray:
	var room_ids := PackedStringArray()
	for room_id in _compiled_world_instances.keys():
		var room_instance: Node = _compiled_world_instances.get(room_id, null)
		if room_instance == null:
			continue
		if room_instance is Node3D and (room_instance as Node3D).visible:
			room_ids.append(String(room_id))
	return room_ids


func get_region_for_room_id(room_id: String):
	if _world == null or room_id.is_empty():
		return null
	return _world.get_region_for_room(room_id)


func get_compiled_world_for_room_id(room_id: String) -> String:
	if _world_runtime_manager != null and _world_runtime_manager.has_method("get_compiled_world_for_room_id"):
		return _world_runtime_manager.get_compiled_world_for_room_id(room_id)
	if _world == null or room_id.is_empty():
		return ""
	return _world.get_compiled_world_for_room(room_id)


# --- Private ---

func _set_fade_alpha(value: float) -> void:
	if _fade_rect == null:
		return
	_fade_rect.color = Color(0, 0, 0, clampf(value, 0.0, 1.0))


func _perform_room_switch(room_id: String) -> void:
	load_room(room_id, _pending_entry_connection_id)
	_pending_entry_connection_id = ""


func _on_transition_complete() -> void:
	_is_transitioning = false
	room_transition_finished.emit()


func _clear_room_container() -> void:
	_current_room = null
	_current_room_id = ""
	_current_region = null
	_current_region_id = ""
	_current_compiled_world_id = ""
	_loaded_compiled_world_id = ""
	_compiled_world_instances.clear()
	for child in _room_container.get_children():
		_room_container.remove_child(child)
		child.queue_free()


func _ensure_compiled_world_loaded(compiled_world_id: String) -> void:
	if compiled_world_id.is_empty():
		return
	if _loaded_compiled_world_id == compiled_world_id and not _compiled_world_instances.is_empty():
		return
	_clear_room_container()
	var compiled_world_root := Node3D.new()
	compiled_world_root.name = "CompiledWorld_%s" % compiled_world_id
	compiled_world_root.set_meta("compiled_world_id", compiled_world_id)
	_room_container.add_child(compiled_world_root)

	var world_entry: Dictionary = _compiled_world_plan.get(compiled_world_id, {})
	var room_offsets: Dictionary = world_entry.get("room_offsets", {})
	var room_ids: PackedStringArray = _world.get_rooms_for_compiled_world(compiled_world_id) if _world != null else PackedStringArray()
	for world_room_id in room_ids:
		var room_instance: Node = _instantiate_room(world_room_id)
		if room_instance == null:
			continue
		if room_instance is Node3D:
			(room_instance as Node3D).position = room_offsets.get(world_room_id, Vector3.ZERO)
			room_instance.set_meta("world_offset", (room_instance as Node3D).position)
		compiled_world_root.add_child(room_instance)
		_compiled_world_instances[world_room_id] = room_instance
	_loaded_compiled_world_id = compiled_world_id


func _setup_fade_overlay() -> void:
	_fade_layer = CanvasLayer.new()
	_fade_layer.name = "FadeLayer"
	_fade_layer.layer = 10
	add_child(_fade_layer)

	_fade_rect = ColorRect.new()
	_fade_rect.name = "FadeRect"
	_fade_rect.color = Color(0, 0, 0, 0)
	_fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_layer.add_child(_fade_rect)


func _execute_transition_after_traversal(room_id: String, do_fade: bool, duration: float, hold: float) -> void:
	var same_compiled_world := _is_same_compiled_world_transition(room_id)
	if same_compiled_world and not do_fade:
		_perform_in_place_room_switch(room_id)
		return
	if do_fade:
		var tween: Tween = create_tween()
		tween.tween_method(_set_fade_alpha, 0.0, 1.0, duration)
		tween.tween_callback(_perform_room_switch.bind(room_id))
		if hold > 0.0:
			tween.tween_interval(hold)
		tween.tween_method(_set_fade_alpha, 1.0, 0.0, duration)
		tween.tween_callback(_on_transition_complete)
		return

	_perform_room_switch(room_id)
	_on_transition_complete()


func _perform_in_place_room_switch(room_id: String) -> void:
	var room_instance: Node = _compiled_world_instances.get(room_id, null)
	if room_instance == null:
		_perform_room_switch(room_id)
		_on_transition_complete()
		return
	var conn: Connection = _find_connection(_pending_entry_connection_id)
	var target_pose: Dictionary = _resolve_entry_pose_for_room_instance(room_instance, room_id, conn)
	var player: Node = get_node_or_null("/root/Main/PlayerController")
	var conn_type: String = conn.type if conn != null else "door"
	var move_duration: float = 0.18
	match conn_type:
		"stairs", "ladder", "trapdoor":
			move_duration = 0.28
		"path", "gate":
			move_duration = 0.24
	if conn != null and conn_type in ["door", "path", "gate"]:
		target_pose = _resolve_same_world_threshold_pose(conn)
	_activate_room_instance(room_instance, room_id, false)
	_pending_entry_connection_id = ""
	if player != null and player.has_method("tween_to_pose"):
		player.tween_to_pose(target_pose.get("position", Vector3.ZERO), target_pose.get("rotation_y", 0.0), move_duration, Callable(self, "_complete_in_place_room_switch"))
		return
	_complete_in_place_room_switch()


func _complete_in_place_room_switch() -> void:
	_on_transition_complete()


func _resolve_transition_profile(room_id: String, conn_type: String, connection_id: String) -> Dictionary:
	var target_compiled_world_id: String = get_compiled_world_for_room_id(room_id)
	var same_compiled_world: bool = not _current_compiled_world_id.is_empty() and _current_compiled_world_id == target_compiled_world_id
	var conn: Connection = _find_connection(connection_id)
	var traversal_mode: String = conn.traversal_mode if conn != null else "auto"

	var duration: float = FADE_DURATIONS.get(conn_type, 0.6)
	var hold := 0.0
	var fade := true
	var traversal_anim := false

	match traversal_mode:
		"seamless":
			fade = false
		"embodied":
			fade = false
			traversal_anim = true
		"soft_transition":
			fade = true
			hold = 0.1
		"hard_transition":
			fade = true
			hold = 0.2
		_:
			if same_compiled_world:
				match conn_type:
					"stairs", "ladder", "trapdoor":
						fade = false
						traversal_anim = true
					_:
						fade = false
			else:
				fade = true
				hold = 0.15
				match conn_type:
					"stairs":
						hold = 0.3
					"ladder":
						hold = 0.4
					"trapdoor":
						hold = 0.35

	return {
		"duration": duration,
		"hold": hold,
		"fade": fade,
		"traversal_anim": traversal_anim,
	}


func _load_initial_room() -> void:
	if _current_room != null or _room_container.get_child_count() > 0:
		return
	var initial_room: String = GameManager.current_room
	if initial_room.is_empty() and _world != null:
		initial_room = _world.starting_room
	if initial_room.is_empty():
		initial_room = "front_gate"
	load_room(initial_room)


func _position_player_for_current_room(entry_connection_id: String = "") -> void:
	if _current_room == null:
		return
	_position_player_for_room_instance(_current_room, _current_room_id, entry_connection_id)


func _position_player_for_room_instance(room_instance: Node, room_id: String, entry_connection_id: String = "") -> void:
	var player: Node = get_node_or_null("/root/Main/PlayerController")
	if player == null or room_instance == null:
		return
	var room_origin: Vector3 = _get_room_world_origin(room_instance)
	var spawn_position: Vector3 = room_instance.spawn_position if room_instance is RoomBase else Vector3.ZERO
	var spawn_rotation_y: float = room_instance.spawn_rotation_y if room_instance is RoomBase else 0.0
	if not entry_connection_id.is_empty():
		var conn: Connection = _find_connection(entry_connection_id)
		if conn != null and conn.to_room == room_id:
			var anchor_pose := _resolve_entry_pose_for_room_instance(room_instance, room_id, conn)
			spawn_position = anchor_pose.get("position", conn.position_in_to)
			spawn_rotation_y = anchor_pose.get("rotation_y", conn.spawn_rotation_y)
	elif room_instance.has_meta("declaration"):
		var room_decl := room_instance.get_meta("declaration") as RoomDeclaration
		if room_decl != null and not room_decl.entry_anchors.is_empty():
			spawn_position = room_decl.entry_anchors[0].position + room_origin
			spawn_rotation_y = room_decl.entry_anchors[0].rotation_y
	if player.has_method("set_room_position"):
		player.set_room_position(spawn_position)
	else:
		player.global_position = spawn_position
		if "velocity" in player:
			player.velocity = Vector3.ZERO
	if player.has_method("set_room_rotation_y"):
		player.set_room_rotation_y(spawn_rotation_y)
	else:
		player.rotation_degrees.y = spawn_rotation_y


func _activate_room_instance(room_instance: Node, room_id: String, reposition_player: bool) -> void:
	if room_instance is RoomBase:
		_current_room = room_instance
		_current_room_id = room_instance.room_id
	else:
		_current_room = null
		_current_room_id = room_id
	_update_region_state(room_instance)
	_refresh_compiled_world_visibility()
	GameManager.current_room = _current_room_id
	GameManager.mark_visited(_current_room_id)
	if _current_room_id in ["attic_stairs", "attic_storage", "hidden_chamber"]:
		GameManager.set_flag("elizabeth_aware")
		GameManager.set_flag("entered_attic")
	if reposition_player:
		_position_player_for_room_instance(room_instance, _current_room_id, _pending_entry_connection_id)
	room_loaded.emit(_current_room_id)


func _find_connection(connection_id: String) -> Connection:
	if _world == null or connection_id.is_empty():
		return null
	return _world.get_connection(connection_id)


func _is_same_compiled_world_transition(room_id: String) -> bool:
	var target_compiled_world_id: String = get_compiled_world_for_room_id(room_id)
	return not _current_compiled_world_id.is_empty() and _current_compiled_world_id == target_compiled_world_id


func _update_region_state(room_instance: Node) -> void:
	var previous_region_id := _current_region_id
	var previous_compiled_world_id := _current_compiled_world_id
	_current_region = _world.get_region_for_room(_current_room_id) if _world != null else null
	_current_region_id = _current_region.region_id if _current_region != null else ""
	if _world_runtime_manager != null and _world_runtime_manager.has_method("set_active_room"):
		_world_runtime_manager.set_active_room(_current_room_id)
		if _world_runtime_manager.has_method("get_current_compiled_world_id"):
			_current_compiled_world_id = _world_runtime_manager.get_current_compiled_world_id()
	else:
		_current_compiled_world_id = _world.get_compiled_world_for_room(_current_room_id) if _world != null else ""
	if room_instance != null:
		room_instance.set_meta("region_id", _current_region_id)
		room_instance.set_meta("region_type", _current_region.region_type if _current_region != null else "")
		room_instance.set_meta("region_neighbors", _current_region.streaming_neighbors if _current_region != null else PackedStringArray())
		room_instance.set_meta("compiled_world_id", _current_compiled_world_id)
		room_instance.set_meta("compiled_world_neighbors", get_current_compiled_world_neighbors())
	if previous_region_id != _current_region_id:
		region_changed.emit(previous_region_id, _current_region_id)
	if previous_compiled_world_id != _current_compiled_world_id:
		compiled_world_changed.emit(previous_compiled_world_id, _current_compiled_world_id)


func _refresh_compiled_world_visibility() -> void:
	if _compiled_world_instances.is_empty():
		return
	var visible_lookup := _build_compiled_world_visibility_lookup(_current_room_id, COMPILED_WORLD_VISIBILITY_DEPTH)
	if visible_lookup.is_empty() and not _current_room_id.is_empty():
		visible_lookup[_current_room_id] = true
	for room_id in _compiled_world_instances.keys():
		var room_instance: Node = _compiled_world_instances.get(room_id, null)
		if room_instance == null:
			continue
		var should_show := visible_lookup.has(String(room_id))
		if room_instance is Node3D:
			(room_instance as Node3D).visible = should_show
		room_instance.set_meta("compiled_world_visible", should_show)


func _build_compiled_world_visibility_lookup(origin_room_id: String, max_depth: int) -> Dictionary:
	var visible: Dictionary = {}
	if _world == null or origin_room_id.is_empty():
		return visible
	var compiled_world_id := get_compiled_world_for_room_id(origin_room_id)
	if compiled_world_id.is_empty():
		visible[origin_room_id] = true
		return visible
	var queue: Array[String] = [origin_room_id]
	var depths: Dictionary = {origin_room_id: 0}
	while not queue.is_empty():
		var room_id: String = queue.pop_front()
		var depth: int = int(depths.get(room_id, 0))
		visible[room_id] = true
		if depth >= max_depth:
			continue
		for conn in _world.get_connections_from_room(room_id):
			if conn == null:
				continue
			if not _connection_participates_in_visibility(conn):
				continue
			if get_compiled_world_for_room_id(conn.to_room) != compiled_world_id:
				continue
			if depths.has(conn.to_room):
				continue
			depths[conn.to_room] = depth + 1
			queue.append(conn.to_room)
	return visible


func _connection_participates_in_visibility(conn: Connection) -> bool:
	if conn == null:
		return false
	match conn.type:
		"stairs", "ladder", "trapdoor":
			return false
		_:
			return true


func _resolve_entry_pose_for_room_instance(room_instance: Node, room_id: String, conn: Connection) -> Dictionary:
	var room_origin: Vector3 = _get_room_world_origin(room_instance)
	var fallback_position: Vector3 = room_origin
	var fallback_rotation_y: float = 0.0
	if room_instance is RoomBase:
		fallback_position = room_instance.spawn_position + room_origin
		fallback_rotation_y = room_instance.spawn_rotation_y
	if room_instance == null or not room_instance.has_meta("declaration"):
		return {
			"position": conn.position_in_to + room_origin if conn != null else fallback_position,
			"rotation_y": conn.spawn_rotation_y if conn != null else fallback_rotation_y,
		}
	var room_decl := room_instance.get_meta("declaration") as RoomDeclaration
	if room_decl == null:
		return {
			"position": conn.position_in_to + room_origin if conn != null else fallback_position,
			"rotation_y": conn.spawn_rotation_y if conn != null else fallback_rotation_y,
		}
	var entry_anchor = _find_room_anchor(room_decl.entry_anchors, conn.to_anchor_id if conn != null else "")
	var focal_anchor = _find_room_anchor(room_decl.focal_anchors, conn.focal_anchor_id if conn != null else "")
	var spawn_position: Vector3 = conn.position_in_to + room_origin if conn != null else fallback_position
	var spawn_rotation_y: float = conn.spawn_rotation_y if conn != null else fallback_rotation_y
	if entry_anchor != null:
		spawn_position = entry_anchor.position + room_origin
		spawn_rotation_y = entry_anchor.rotation_y
	elif conn == null and not room_decl.entry_anchors.is_empty():
		spawn_position = room_decl.entry_anchors[0].position + room_origin
		spawn_rotation_y = room_decl.entry_anchors[0].rotation_y
	if entry_anchor != null and focal_anchor != null:
		var direction: Vector3 = (focal_anchor.position + room_origin) - spawn_position
		if direction.length_squared() > 0.001:
			spawn_rotation_y = rad_to_deg(atan2(-direction.x, -direction.z))
	return {
		"position": spawn_position,
		"rotation_y": spawn_rotation_y,
	}


func _get_room_world_origin(room_instance: Node) -> Vector3:
	if room_instance is Node3D:
		return (room_instance as Node3D).global_position
	return Vector3.ZERO


func _resolve_same_world_threshold_pose(conn: Connection) -> Dictionary:
	var player: Node3D = get_node_or_null("/root/Main/PlayerController") as Node3D
	var current_origin: Vector3 = _get_room_world_origin(_current_room)
	var threshold_position: Vector3 = conn.position_in_from + current_origin
	var move_direction: Vector3 = _connection_direction_vector(conn.direction)
	if move_direction == Vector3.ZERO and player != null:
		move_direction = -player.global_transform.basis.z
	move_direction.y = 0.0
	if move_direction.length_squared() < 0.001:
		move_direction = Vector3(0, 0, -1)
	move_direction = move_direction.normalized()
	var target_position := threshold_position + move_direction * 0.9
	if player != null:
		target_position.y = player.global_position.y
		return {
			"position": target_position,
			"rotation_y": player.rotation_degrees.y,
		}
	return {
		"position": target_position,
		"rotation_y": rad_to_deg(atan2(-move_direction.x, -move_direction.z)),
	}


func _connection_direction_vector(direction: String) -> Vector3:
	match direction:
		"north":
			return Vector3(0, 0, -1)
		"south":
			return Vector3(0, 0, 1)
		"east":
			return Vector3(1, 0, 0)
		"west":
			return Vector3(-1, 0, 0)
		_:
			return Vector3.ZERO


func _find_room_anchor(anchors: Array, anchor_id: String):
	if anchor_id.is_empty():
		return null
	for anchor in anchors:
		if anchor != null and anchor.anchor_id == anchor_id:
			return anchor
	return null


func _scene_path_to_room_id(path: String) -> String:
	var filename: String = path.get_file().get_basename()
	for rid in _declaration_registry:
		if _declaration_registry[rid] == path:
			return rid
	for rid in _room_registry:
		if _room_registry[rid] == path:
			return rid
	return filename


func _load_world_registry() -> void:
	var world_path := "res://declarations/world.tres"
	if not ResourceLoader.exists(world_path):
		return
	_world = load(world_path) as WorldDeclaration
	if _world == null:
		push_warning("RoomManager: Failed to load world declaration")
		return
	_assembler = RoomAssembler.new(_world)
	var room_decls: Dictionary = {}
	for room_ref in _world.rooms:
		if room_ref != null and not room_ref.room_id.is_empty() and not room_ref.declaration_path.is_empty():
			_declaration_registry[room_ref.room_id] = room_ref.declaration_path
			if ResourceLoader.exists(room_ref.declaration_path):
				var room_decl := load(room_ref.declaration_path) as RoomDeclaration
				if room_decl != null:
					room_decls[room_ref.room_id] = room_decl
	_world_runtime_manager = get_node_or_null("/root/Main/WorldRuntimeManager")
	if _world_runtime_manager != null and _world_runtime_manager.has_method("bootstrap"):
		_world_runtime_manager.bootstrap(_world, room_decls)
		if _world_runtime_manager.has_method("get_region_plan"):
			_region_plan = _world_runtime_manager.get_region_plan()
		if _world_runtime_manager.has_method("get_compiled_world_plan"):
			_compiled_world_plan = _world_runtime_manager.get_compiled_world_plan()
	if _region_plan.is_empty() or _compiled_world_plan.is_empty():
		var compile_plan: Dictionary = RegionCompilerScript.new(_world, room_decls).compile_plan()
		_region_plan = compile_plan.get("regions", {})
		_compiled_world_plan = compile_plan.get("compiled_worlds", {})


func _instantiate_room(room_id: String) -> Node:
	var declaration_path: String = _declaration_registry.get(room_id, "")
	if not declaration_path.is_empty():
		if not ResourceLoader.exists(declaration_path):
			push_warning("RoomManager: Declaration not found '%s'" % declaration_path)
		elif _assembler == null:
			push_warning("RoomManager: No RoomAssembler available for '%s'" % room_id)
		else:
			var room_decl := load(declaration_path) as RoomDeclaration
			if room_decl != null:
				return _assembler.assemble(room_decl)
			push_warning("RoomManager: Failed to load declaration '%s'" % declaration_path)

	var scene_path: String = _room_registry.get(room_id, "")
	if scene_path.is_empty():
		push_warning("RoomManager: Unknown room '%s'" % room_id)
		return null
	if not ResourceLoader.exists(scene_path):
		push_warning("RoomManager: Scene not found '%s'" % scene_path)
		return null
	var scene: PackedScene = load(scene_path)
	if scene == null:
		push_warning("RoomManager: Failed to load '%s'" % scene_path)
		return null
	return scene.instantiate()
