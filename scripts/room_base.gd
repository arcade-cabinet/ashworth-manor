class_name RoomBase
extends Node3D
## Base script for all room scenes. Attach to room root node.
## Handles interactable/connection registration and flickering lights.

@export var room_id: String = ""
@export var room_name: String = ""
@export var audio_loop: String = ""
@export var ambient_darkness: float = 0.5
@export var is_exterior: bool = false
@export var spawn_position: Vector3 = Vector3(0, 0, -3)
@export var spawn_rotation_y: float = 0.0

var _flickering_lights: Array[Dictionary] = []
var _elapsed_time: float = 0.0
var _flicker_intensity: float = 1.0


@export var boundary_size: Vector3 = Vector3.ZERO  # If set, creates invisible walls

func _ready() -> void:
	# Some scenes set metadata instead of exports -- sync them
	if room_id.is_empty() and has_meta("room_id"):
		room_id = get_meta("room_id")
	if room_name.is_empty() and has_meta("room_name"):
		room_name = get_meta("room_name")
	if audio_loop.is_empty() and has_meta("audio_loop"):
		audio_loop = get_meta("audio_loop")
	if has_meta("ambient_darkness"):
		ambient_darkness = get_meta("ambient_darkness")
	if has_meta("is_exterior"):
		is_exterior = get_meta("is_exterior")
	if has_meta("spawn_position"):
		spawn_position = get_meta("spawn_position")
	if has_meta("spawn_rotation_y"):
		spawn_rotation_y = get_meta("spawn_rotation_y")

	_find_flickering_lights(self)
	if boundary_size != Vector3.ZERO and is_exterior:
		_create_boundary_walls()


func _process(delta: float) -> void:
	_elapsed_time += delta
	for entry in _flickering_lights:
		var light: Light3D = entry["light"]
		var base_energy: float = entry["base_energy"]
		if is_instance_valid(light):
			var flicker: float = sin(_elapsed_time * 2.5) * 0.04 + sin(_elapsed_time * 4.3) * 0.02
			light.light_energy = base_energy * (0.85 + flicker * _flicker_intensity)


func set_flicker_intensity(multiplier: float) -> void:
	_flicker_intensity = multiplier


func tween_light_energy(light_id: String, target_energy: float, duration: float) -> bool:
	var light: Light3D = find_light_by_id(light_id)
	if light == null:
		return false
	var tween: Tween = create_tween()
	var flicker_entry: Dictionary = _find_flicker_entry(light)
	if not flicker_entry.is_empty():
		var start_energy: float = flicker_entry["base_energy"]
		tween.tween_method(_set_flicker_base_energy.bind(light), start_energy, target_energy, max(duration, 0.01))
	else:
		tween.tween_property(light, "light_energy", target_energy, max(duration, 0.01))
	return true


func find_light_by_id(light_id: String) -> Light3D:
	return _find_light_by_name(self, light_id)


func get_light_base_energy(light_id: String) -> float:
	var light: Light3D = find_light_by_id(light_id)
	if light == null:
		return -1.0
	var flicker_entry: Dictionary = _find_flicker_entry(light)
	if not flicker_entry.is_empty():
		return float(flicker_entry.get("base_energy", light.light_energy))
	return light.light_energy


func get_interactables() -> Array[Area3D]:
	var result: Array[Area3D] = []
	# Find by collision layer 4 (layer 3) OR group "interactables"
	_find_areas_by_layer_or_group(self, 4, "interactables", result)
	return result


func get_connections() -> Array[Area3D]:
	var result: Array[Area3D] = []
	# Find by collision layer 8 (layer 4) OR group "connections"
	_find_areas_by_layer_or_group(self, 8, "connections", result)
	return result


func _find_flickering_lights(node: Node) -> void:
	if node is Light3D and node.has_meta("flickering") and node.get_meta("flickering"):
		_flickering_lights.append({
			"light": node,
			"base_energy": node.light_energy,
		})
	for child in node.get_children():
		_find_flickering_lights(child)


func _find_areas_by_layer_or_group(node: Node, layer_mask: int, group_name: String, result: Array[Area3D]) -> void:
	if node is Area3D:
		if node.collision_layer == layer_mask or node.is_in_group(group_name):
			result.append(node)
	for child in node.get_children():
		_find_areas_by_layer_or_group(child, layer_mask, group_name, result)


func _find_light_by_name(node: Node, light_id: String) -> Light3D:
	if node is Light3D and node.name == light_id:
		return node as Light3D
	for child in node.get_children():
		var found := _find_light_by_name(child, light_id)
		if found != null:
			return found
	return null


func _find_flicker_entry(light: Light3D) -> Dictionary:
	for i in range(_flickering_lights.size()):
		var entry: Dictionary = _flickering_lights[i]
		if entry.get("light") == light:
			return entry
	return {}


func _set_flicker_base_energy(value: float, light: Light3D) -> void:
	for i in range(_flickering_lights.size()):
		var entry: Dictionary = _flickering_lights[i]
		if entry.get("light") == light:
			entry["base_energy"] = value
			_flickering_lights[i] = entry
			light.light_energy = value
			return
	light.light_energy = value


func _create_boundary_walls() -> void:
	# Invisible walls at the edges of exterior rooms to prevent walking into void
	var w: float = boundary_size.x
	var h: float = boundary_size.y if boundary_size.y > 0 else 6.0
	var d: float = boundary_size.z
	var defs: Array = [
		["BoundaryN", Vector3(w, h, 0.3), Vector3(0, h / 2.0, d / 2.0)],
		["BoundaryS", Vector3(w, h, 0.3), Vector3(0, h / 2.0, -d / 2.0)],
		["BoundaryE", Vector3(0.3, h, d), Vector3(w / 2.0, h / 2.0, 0)],
		["BoundaryW", Vector3(0.3, h, d), Vector3(-w / 2.0, h / 2.0, 0)],
	]
	for def in defs:
		var body := StaticBody3D.new()
		body.name = def[0]
		body.position = def[2]
		body.collision_layer = 2
		body.collision_mask = 0
		var col := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = def[1]
		col.shape = shape
		body.add_child(col)
		add_child(body)
