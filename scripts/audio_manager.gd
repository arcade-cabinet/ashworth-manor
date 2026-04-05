extends Node
## res://scripts/audio_manager.gd — Per-room ambient loops and sound effects

const AMBIENT_BASE_DB: float = -6.0
const SFX_BASE_DB: float = 0.0
const CROSSFADE_DURATION: float = 1.0
const SILENCE_DB: float = -80.0

var _ambient_current: AudioStreamPlayer = null
var _ambient_next: AudioStreamPlayer = null
var _current_loop_name: String = ""
var _crossfade_tween: Tween = null


func _ready() -> void:
	# Use scene-built players if present, otherwise create new ones
	_ambient_current = get_node_or_null("AmbientCurrent")
	if _ambient_current == null:
		_ambient_current = AudioStreamPlayer.new()
		_ambient_current.name = "AmbientCurrent"
		add_child(_ambient_current)
	_ambient_current.bus = &"Master"
	_ambient_current.volume_db = AMBIENT_BASE_DB

	_ambient_next = get_node_or_null("AmbientNext")
	if _ambient_next == null:
		_ambient_next = AudioStreamPlayer.new()
		_ambient_next.name = "AmbientNext"
		add_child(_ambient_next)
	_ambient_next.bus = &"Master"
	_ambient_next.volume_db = SILENCE_DB

	call_deferred("_connect_room_manager")


func _connect_room_manager() -> void:
	var room_manager: Node = _find_node("RoomManager")
	if room_manager and room_manager.has_signal("room_loaded"):
		room_manager.room_loaded.connect(_on_room_loaded)


func _find_node(node_name: String) -> Node:
	var root: Node = get_tree().root
	return _recursive_find(root, node_name)


func _recursive_find(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var found: Node = _recursive_find(child, target_name)
		if found != null:
			return found
	return null


func _on_room_loaded(room_id: String) -> void:
	var room_data_script = load("res://scripts/room_data.gd")
	var data: Dictionary = room_data_script.get_room(room_id)
	var loop_name: String = data.get("audio_loop", "")
	if not loop_name.is_empty():
		play_room_loop(loop_name)


func play_room_loop(loop_name: String) -> void:
	if loop_name == _current_loop_name:
		return

	if loop_name.is_empty():
		stop_all()
		return

	var path: String = "res://assets/audio/loops/%s.ogg" % loop_name
	if not ResourceLoader.exists(path):
		push_warning("AudioManager: Loop not found at '%s'" % path)
		return

	var stream: AudioStream = load(path)
	if stream == null:
		push_warning("AudioManager: Failed to load audio stream '%s'" % path)
		return

	_current_loop_name = loop_name

	# Kill any in-progress crossfade
	if _crossfade_tween and _crossfade_tween.is_valid():
		_crossfade_tween.kill()

	# Set up next player
	_ambient_next.stream = stream
	_ambient_next.volume_db = SILENCE_DB
	_ambient_next.play()

	# Crossfade
	_crossfade_tween = create_tween()
	_crossfade_tween.set_parallel(true)
	_crossfade_tween.tween_property(_ambient_current, "volume_db", SILENCE_DB, CROSSFADE_DURATION)
	_crossfade_tween.tween_property(_ambient_next, "volume_db", AMBIENT_BASE_DB, CROSSFADE_DURATION)
	_crossfade_tween.set_parallel(false)
	_crossfade_tween.tween_callback(_swap_players)


func _swap_players() -> void:
	_ambient_current.stop()
	# Swap references so current is always the playing one
	var temp: AudioStreamPlayer = _ambient_current
	_ambient_current = _ambient_next
	_ambient_next = temp


func play_sfx(sfx_name: String) -> void:
	var path: String = "res://assets/audio/sfx/%s.ogg" % sfx_name
	if not ResourceLoader.exists(path):
		push_warning("AudioManager: SFX not found at '%s'" % path)
		return

	var stream: AudioStream = load(path)
	if stream == null:
		push_warning("AudioManager: Failed to load SFX '%s'" % path)
		return

	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = SFX_BASE_DB
	player.bus = &"Master"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)


func stop_all() -> void:
	if _crossfade_tween and _crossfade_tween.is_valid():
		_crossfade_tween.kill()
	_ambient_current.stop()
	_ambient_next.stop()
	_current_loop_name = ""
