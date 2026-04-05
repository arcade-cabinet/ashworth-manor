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


func _ready() -> void:
	# Auto-find flickering lights
	_find_flickering_lights(self)


func _process(delta: float) -> void:
	_elapsed_time += delta
	for entry in _flickering_lights:
		var light: Light3D = entry["light"]
		var base_energy: float = entry["base_energy"]
		if is_instance_valid(light):
			var flicker: float = sin(_elapsed_time * 2.5) * 0.04 + sin(_elapsed_time * 4.3) * 0.02
			light.light_energy = base_energy * (0.85 + flicker)


func get_interactables() -> Array[Area3D]:
	var result: Array[Area3D] = []
	_find_areas_in_group(self, "interactables", result)
	return result


func get_connections() -> Array[Area3D]:
	var result: Array[Area3D] = []
	_find_areas_in_group(self, "connections", result)
	return result


func _find_flickering_lights(node: Node) -> void:
	if node is Light3D and node.has_meta("flickering") and node.get_meta("flickering"):
		_flickering_lights.append({
			"light": node,
			"base_energy": node.light_energy,
		})
	for child in node.get_children():
		_find_flickering_lights(child)


func _find_areas_in_group(node: Node, group_name: String, result: Array[Area3D]) -> void:
	if node is Area3D and node.is_in_group(group_name):
		result.append(node)
	for child in node.get_children():
		_find_areas_in_group(child, group_name, result)
