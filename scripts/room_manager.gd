extends Node3D
## res://scripts/room_manager.gd — Loads/unloads rooms, places models, lights, interactables

signal room_loaded(room_id: String)
signal room_transition_started
signal room_transition_finished

const WALL_THICKNESS: float = 0.3
const FLOOR_THICKNESS: float = 0.2
const FADE_DURATION: float = 0.6

var _current_room_id: String = ""
var _room_container: Node3D = null
var _flickering_lights: Array[Dictionary] = []
var _elapsed_time: float = 0.0
var _fade_rect: ColorRect = null
var _fade_layer: CanvasLayer = null
var _is_transitioning: bool = false

# Collision layers
const LAYER_WALKABLE: int = 1
const LAYER_WALL: int = 2
const LAYER_INTERACTABLE: int = 3
const LAYER_DOOR: int = 4


func _ready() -> void:
	_room_container = Node3D.new()
	_room_container.name = "RoomContainer"
	add_child(_room_container)
	_setup_fade_overlay()


func _process(delta: float) -> void:
	_elapsed_time += delta
	for entry in _flickering_lights:
		var light: Light3D = entry["light"]
		var base_energy: float = entry["base_energy"]
		if is_instance_valid(light):
			light.light_energy = base_energy * (0.85 + sin(_elapsed_time * 2.5) * 0.04 + sin(_elapsed_time * 4.3) * 0.02)


func _setup_fade_overlay() -> void:
	_fade_layer = CanvasLayer.new()
	_fade_layer.name = "FadeLayer"
	_fade_layer.layer = 10
	add_child(_fade_layer)

	_fade_rect = ColorRect.new()
	_fade_rect.name = "FadeRect"
	_fade_rect.color = Color.BLACK
	_fade_rect.modulate.a = 0.0
	_fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_layer.add_child(_fade_rect)


func load_room(room_id: String) -> void:
	var room_data_script = load("res://scripts/room_data.gd")
	var data: Dictionary = room_data_script.get_room(room_id)
	if data.is_empty():
		push_warning("RoomManager: Unknown room '%s'" % room_id)
		return

	_clear_current_room()
	_current_room_id = room_id

	var dimensions: Vector3 = data.get("dimensions", Vector3(10, 4, 10))
	var is_exterior: bool = data.get("is_exterior", false)

	if not is_exterior:
		_build_room_geometry(dimensions)
	else:
		_build_floor_only(dimensions)

	_place_models(data.get("models", []))
	_create_lights(data.get("lights", []))
	_create_interactables(data.get("interactables", []))
	_create_connections(data.get("connections", []), dimensions)

	GameManager.current_room = room_id
	GameManager.mark_visited(room_id)
	room_loaded.emit(room_id)


func transition_to(room_id: String) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	room_transition_started.emit()

	var tween: Tween = create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 1.0, FADE_DURATION)
	tween.tween_callback(_perform_room_switch.bind(room_id))
	tween.tween_interval(0.15)
	tween.tween_property(_fade_rect, "modulate:a", 0.0, FADE_DURATION)
	tween.tween_callback(_on_transition_complete)


func get_current_room_id() -> String:
	return _current_room_id


func get_current_room_data() -> Dictionary:
	var room_data_script = load("res://scripts/room_data.gd")
	return room_data_script.get_room(_current_room_id)


# --- Private ---

func _perform_room_switch(room_id: String) -> void:
	load_room(room_id)


func _on_transition_complete() -> void:
	_is_transitioning = false
	room_transition_finished.emit()


func _clear_current_room() -> void:
	_flickering_lights.clear()
	for child in _room_container.get_children():
		_room_container.remove_child(child)
		child.queue_free()


func _build_room_geometry(dimensions: Vector3) -> void:
	var w: float = dimensions.x
	var h: float = dimensions.y
	var d: float = dimensions.z

	# Floor
	var floor_box: CSGBox3D = CSGBox3D.new()
	floor_box.name = "Floor"
	floor_box.size = Vector3(w, FLOOR_THICKNESS, d)
	floor_box.position = Vector3(0, -FLOOR_THICKNESS / 2.0, 0)
	floor_box.use_collision = true
	floor_box.collision_layer = LAYER_WALKABLE
	floor_box.collision_mask = 0
	floor_box.material = _create_dark_material(Color(0.06, 0.05, 0.05))
	_room_container.add_child(floor_box)

	# Ceiling
	var ceiling_box: CSGBox3D = CSGBox3D.new()
	ceiling_box.name = "Ceiling"
	ceiling_box.size = Vector3(w, FLOOR_THICKNESS, d)
	ceiling_box.position = Vector3(0, h + FLOOR_THICKNESS / 2.0, 0)
	ceiling_box.use_collision = true
	ceiling_box.collision_layer = LAYER_WALL
	ceiling_box.collision_mask = 0
	ceiling_box.material = _create_dark_material(Color(0.04, 0.03, 0.03))
	_room_container.add_child(ceiling_box)

	# Walls: north (+Z), south (-Z), east (+X), west (-X)
	var wall_defs: Array[Dictionary] = [
		{"name": "WallNorth", "size": Vector3(w, h, WALL_THICKNESS), "pos": Vector3(0, h / 2.0, d / 2.0)},
		{"name": "WallSouth", "size": Vector3(w, h, WALL_THICKNESS), "pos": Vector3(0, h / 2.0, -d / 2.0)},
		{"name": "WallEast", "size": Vector3(WALL_THICKNESS, h, d), "pos": Vector3(w / 2.0, h / 2.0, 0)},
		{"name": "WallWest", "size": Vector3(WALL_THICKNESS, h, d), "pos": Vector3(-w / 2.0, h / 2.0, 0)},
	]
	for def in wall_defs:
		var wall: CSGBox3D = CSGBox3D.new()
		wall.name = def["name"]
		wall.size = def["size"]
		wall.position = def["pos"]
		wall.use_collision = true
		wall.collision_layer = LAYER_WALL
		wall.collision_mask = 0
		wall.material = _create_dark_material(Color(0.08, 0.06, 0.06))
		_room_container.add_child(wall)


func _build_floor_only(dimensions: Vector3) -> void:
	var w: float = dimensions.x
	var d: float = dimensions.z

	var floor_box: CSGBox3D = CSGBox3D.new()
	floor_box.name = "Floor"
	floor_box.size = Vector3(w, FLOOR_THICKNESS, d)
	floor_box.position = Vector3(0, -FLOOR_THICKNESS / 2.0, 0)
	floor_box.use_collision = true
	floor_box.collision_layer = LAYER_WALKABLE
	floor_box.collision_mask = 0
	floor_box.material = _create_dark_material(Color(0.1, 0.08, 0.07))
	_room_container.add_child(floor_box)


func _create_dark_material(base_color: Color) -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = base_color
	mat.roughness = 0.95
	mat.metallic = 0.0
	return mat


func _place_models(models: Array) -> void:
	for model_def in models:
		var path: String = model_def.get("path", "")
		if path.is_empty():
			continue
		if not ResourceLoader.exists(path):
			push_warning("RoomManager: Model not found at '%s'" % path)
			continue
		var scene: PackedScene = load(path)
		if scene == null:
			push_warning("RoomManager: Failed to load scene '%s'" % path)
			continue
		var model = scene.instantiate()
		model.position = model_def.get("pos", Vector3.ZERO)
		model.rotation_degrees = model_def.get("rot", Vector3.ZERO)
		model.scale = model_def.get("scale", Vector3.ONE)
		_room_container.add_child(model)


func _create_lights(lights: Array) -> void:
	for light_def in lights:
		var light_type: String = light_def.get("type", "omni")
		var light: Light3D = null

		if light_type == "omni":
			var omni: OmniLight3D = OmniLight3D.new()
			omni.omni_range = light_def.get("range", 8.0)
			omni.omni_attenuation = 1.5
			light = omni
		elif light_type == "spot":
			var spot: SpotLight3D = SpotLight3D.new()
			spot.spot_range = light_def.get("range", 10.0)
			spot.spot_angle = 45.0
			spot.spot_attenuation = 1.2
			light = spot
		elif light_type == "directional":
			var dir_light: DirectionalLight3D = DirectionalLight3D.new()
			light = dir_light
		else:
			continue

		light.position = light_def.get("pos", Vector3.ZERO)
		light.light_color = light_def.get("color", Color.WHITE)
		light.light_energy = light_def.get("intensity", 1.0)
		light.shadow_enabled = true

		var light_name: String = "Light_%d" % _room_container.get_child_count()
		light.name = light_name
		_room_container.add_child(light)

		var flickering: bool = light_def.get("flickering", false)
		if flickering:
			_flickering_lights.append({
				"light": light,
				"base_energy": light.light_energy,
			})


func _create_interactables(interactables: Array) -> void:
	for inter_def in interactables:
		var inter_id: String = inter_def.get("id", "")
		var inter_type: String = inter_def.get("type", "")
		var inter_pos: Vector3 = inter_def.get("pos", Vector3.ZERO)
		var inter_data: Dictionary = inter_def.get("data", {})

		var area: Area3D = Area3D.new()
		area.name = "Interactable_%s" % inter_id
		area.position = inter_pos
		area.collision_layer = LAYER_INTERACTABLE
		area.collision_mask = 0
		area.set_meta("id", inter_id)
		area.set_meta("type", inter_type)
		area.set_meta("data", inter_data)

		var shape: CollisionShape3D = CollisionShape3D.new()
		var box_shape: BoxShape3D = BoxShape3D.new()
		box_shape.size = Vector3(1.0, 1.0, 1.0)
		shape.shape = box_shape
		area.add_child(shape)

		_room_container.add_child(area)


func _create_connections(connections: Array, dimensions: Vector3) -> void:
	for conn_def in connections:
		var target_room: String = conn_def.get("target_room", "")
		var conn_type: String = conn_def.get("type", "door")
		var conn_pos: Vector3 = conn_def.get("pos", Vector3.ZERO)
		var locked: bool = conn_def.get("locked", false)
		var key_id: String = conn_def.get("key_id", "")
		var direction: String = conn_def.get("direction", "")

		var area: Area3D = Area3D.new()
		area.name = "Connection_%s_%s" % [direction, target_room]
		area.position = conn_pos
		area.collision_layer = LAYER_DOOR
		area.collision_mask = 0
		area.set_meta("target_room", target_room)
		area.set_meta("type", conn_type)
		area.set_meta("locked", locked)
		area.set_meta("key_id", key_id)
		area.set_meta("direction", direction)

		var shape: CollisionShape3D = CollisionShape3D.new()
		var box_shape: BoxShape3D = BoxShape3D.new()
		box_shape.size = Vector3(2.0, 3.0, 1.0)
		shape.shape = box_shape
		area.add_child(shape)

		_room_container.add_child(area)
