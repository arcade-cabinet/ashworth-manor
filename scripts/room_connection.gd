@tool
class_name RoomConnection
extends Resource
## Custom resource for room-to-room connections (doors, stairs, ladders, paths)

@export var target_scene_path: String = ""  # res://scenes/rooms/ground_floor/parlor.tscn
@export var direction: String = ""  # north, south, east, west, up, down
@export_enum("door", "stairs", "ladder", "path") var conn_type: String = "door"
@export var locked: bool = false
@export var key_id: String = ""
