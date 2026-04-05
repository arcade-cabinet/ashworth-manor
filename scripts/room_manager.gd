extends Node3D
## res://scripts/room_manager.gd — Scene-based room instancing with fade transitions

signal room_loaded(room_id: String)
signal room_transition_started
signal room_transition_finished

const FADE_DURATION: float = 0.6

var _current_room: RoomBase = null
var _current_room_id: String = ""
var _room_container: Node3D = null
var _fade_rect: ColorRect = null
var _fade_layer: CanvasLayer = null
var _is_transitioning: bool = false

# Room registry: room_id → scene path
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
	"hidden_room": "res://scenes/rooms/attic/hidden_chamber.tscn",
}


func _ready() -> void:
	_room_container = Node3D.new()
	_room_container.name = "RoomContainer"
	add_child(_room_container)
	_setup_fade_overlay()


func load_room(room_id: String) -> void:
	var scene_path: String = _room_registry.get(room_id, "")
	if scene_path.is_empty():
		push_warning("RoomManager: Unknown room '%s'" % room_id)
		return
	if not ResourceLoader.exists(scene_path):
		push_warning("RoomManager: Scene not found '%s'" % scene_path)
		return

	_clear_current_room()

	var scene: PackedScene = load(scene_path)
	if scene == null:
		push_warning("RoomManager: Failed to load '%s'" % scene_path)
		return

	var room_instance = scene.instantiate()
	_room_container.add_child(room_instance)

	# Get room metadata from RoomBase script
	if room_instance is RoomBase:
		_current_room = room_instance
		_current_room_id = room_instance.room_id
	else:
		_current_room = null
		_current_room_id = room_id

	GameManager.current_room = _current_room_id
	GameManager.mark_visited(_current_room_id)

	# Set narrative flags based on room entry
	if _current_room_id in ["attic_stairs", "attic_storage", "hidden_room"]:
		GameManager.set_flag("elizabeth_aware")
		GameManager.set_flag("entered_attic")

	room_loaded.emit(_current_room_id)


func transition_to(room_id: String, conn_type: String = "door") -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	room_transition_started.emit()

	var fade_in: float = FADE_DURATION
	var hold: float = 0.15
	var fade_out: float = FADE_DURATION

	match conn_type:
		"stairs":
			fade_in = 0.8
			hold = 0.3
			fade_out = 0.8
		"ladder":
			fade_in = 1.0
			hold = 0.4
			fade_out = 1.0
		"path":
			fade_in = 0.5
			hold = 0.1
			fade_out = 0.5

	var tween: Tween = create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 1.0, fade_in)
	tween.tween_callback(_perform_room_switch.bind(room_id))
	tween.tween_interval(hold)
	tween.tween_property(_fade_rect, "modulate:a", 0.0, fade_out)
	tween.tween_callback(_on_transition_complete)


func get_current_room_id() -> String:
	return _current_room_id


func get_current_room() -> RoomBase:
	return _current_room


func get_current_room_data() -> Dictionary:
	# Returns basic metadata from the live room scene's exports
	if _current_room == null:
		return {}
	return {
		"room_id": _current_room.room_id,
		"room_name": _current_room.room_name,
		"audio_loop": _current_room.audio_loop,
	}


# --- Private ---

func _perform_room_switch(room_id: String) -> void:
	load_room(room_id)
	# Reposition player
	var player: Node = get_node_or_null("/root/Main/PlayerController")
	if player and _current_room:
		player.global_position = _current_room.spawn_position
		player.rotation_degrees.y = _current_room.spawn_rotation_y
		player.velocity = Vector3.ZERO


func _on_transition_complete() -> void:
	_is_transitioning = false
	room_transition_finished.emit()


func _clear_current_room() -> void:
	_current_room = null
	for child in _room_container.get_children():
		_room_container.remove_child(child)
		child.queue_free()


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


func _scene_path_to_room_id(path: String) -> String:
	# Convert "res://scenes/rooms/ground_floor/parlor.tscn" → "parlor"
	var filename: String = path.get_file().get_basename()
	for rid in _room_registry:
		if _room_registry[rid] == path:
			return rid
	return filename
