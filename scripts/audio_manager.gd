extends Node
## res://scripts/audio_manager.gd -- Per-room ambient loops, tension layer, crossfade
## Base layer: room ambient (always playing). Tension layer: activates on elizabeth_aware.

const AMBIENT_BASE_DB: float = -6.0
const TENSION_BASE_DB: float = -12.0
const SFX_BASE_DB: float = 0.0
const CROSSFADE_DURATION: float = 1.0
const SILENCE_DB: float = -80.0

var _ambient_current: AudioStreamPlayer = null
var _ambient_next: AudioStreamPlayer = null
var _tension_player: AudioStreamPlayer = null
var _current_loop_name: String = ""
var _crossfade_tween: Tween = null
var _tension_tween: Tween = null
var _tension_active: bool = false
var _tension_volume_scale: float = 1.0

# Room -> tension loop mapping (rooms where tension layer exists)
var _tension_loops: Dictionary = {
	"foyer": "tension_ground",
	"parlor": "tension_ground",
	"dining_room": "tension_ground",
	"kitchen": "tension_ground",
	"upper_hallway": "tension_upper",
	"master_bedroom": "tension_upper",
	"library": "tension_upper",
	"guest_room": "tension_upper",
	"storage_basement": "tension_basement",
	"boiler_room": "tension_basement",
	"wine_cellar": "tension_deep",
	"attic_stairs": "tension_attic",
	"attic_storage": "tension_attic",
	"hidden_chamber": "tension_attic",
}

func _ready() -> void:
	_ambient_current = _get_or_create_player("AmbientCurrent", AMBIENT_BASE_DB)
	_ambient_next = _get_or_create_player("AmbientNext", SILENCE_DB)
	_tension_player = _get_or_create_player("TensionPlayer", SILENCE_DB)
	call_deferred("_connect_signals")


func _exit_tree() -> void:
	shutdown()


func shutdown() -> void:
	if _crossfade_tween and _crossfade_tween.is_valid():
		_crossfade_tween.kill()
	if _tension_tween and _tension_tween.is_valid():
		_tension_tween.kill()
	_crossfade_tween = null
	_tension_tween = null
	_free_player(_ambient_current)
	_free_player(_ambient_next)
	_free_player(_tension_player)
	_ambient_current = null
	_ambient_next = null
	_tension_player = null
	for child in get_children():
		if child is AudioStreamPlayer:
			_free_player(child as AudioStreamPlayer)
	_current_loop_name = ""

func _get_or_create_player(player_name: String, volume: float) -> AudioStreamPlayer:
	var p: AudioStreamPlayer = get_node_or_null(player_name)
	if p == null:
		p = AudioStreamPlayer.new()
		p.name = player_name
		add_child(p)
	p.bus = &"Master"
	p.volume_db = volume
	return p


func _release_player(player: AudioStreamPlayer) -> void:
	if player == null:
		return
	player.stop()
	player.stream = null


func _free_player(player: AudioStreamPlayer) -> void:
	if player == null or not is_instance_valid(player):
		return
	_release_player(player)
	if player.get_parent() != null:
		player.get_parent().remove_child(player)
	player.free()

func _connect_signals() -> void:
	var rm: Node = _find_node("RoomManager")
	if rm and rm.has_signal("room_loaded"):
		rm.room_loaded.connect(_on_room_loaded)
	# Listen for elizabeth_aware flag to activate tension layer
	if GameManager.has_signal("flag_set"):
		GameManager.flag_set.connect(_on_flag_set)

func _on_flag_set(flag_name: String) -> void:
	if flag_name == "elizabeth_aware" and not _tension_active:
		_tension_active = true
		_update_tension_layer()

func _on_room_loaded(_room_id: String) -> void:
	var rm: Node = _find_node("RoomManager")
	if rm and rm.has_method("get_current_room"):
		var room = rm.get_current_room()
		if room and "audio_loop" in room:
			var loop_name: String = room.audio_loop
			if not loop_name.is_empty():
				play_room_loop(loop_name)
	_update_tension_layer()

func play_room_loop(loop_name: String) -> void:
	if loop_name == _current_loop_name:
		return
	if loop_name.is_empty():
		stop_all()
		return
	var path: String = _resolve_loop_path(loop_name)
	if not ResourceLoader.exists(path):
		push_warning("AudioManager: Loop not found at '%s'" % path)
		return
	var stream: AudioStream = load(path)
	if stream == null:
		return
	_current_loop_name = loop_name
	if _crossfade_tween and _crossfade_tween.is_valid():
		_crossfade_tween.kill()
	_ambient_next.stream = stream
	_ambient_next.volume_db = SILENCE_DB
	_ambient_next.play()
	_crossfade_tween = create_tween()
	_crossfade_tween.set_parallel(true)
	_crossfade_tween.tween_property(_ambient_current, "volume_db", SILENCE_DB, CROSSFADE_DURATION)
	_crossfade_tween.tween_property(_ambient_next, "volume_db", AMBIENT_BASE_DB, CROSSFADE_DURATION)
	_crossfade_tween.set_parallel(false)
	_crossfade_tween.tween_callback(_swap_players)

func set_tension_volume(scale: float) -> void:
	## Called by game_state_machine.gd to adjust tension layer volume per phase.
	## scale: 0.0 = silent, 1.0 = full tension
	_tension_volume_scale = clampf(scale, 0.0, 1.0)
	if _tension_active:
		_update_tension_layer()

func _update_tension_layer() -> void:
	if not _tension_active:
		return
	var room_id: String = GameManager.current_room
	var tension_loop: String = _tension_loops.get(room_id, "")
	if tension_loop.is_empty():
		# Fade out tension in rooms without tension layer
		if _tension_tween and _tension_tween.is_valid():
			_tension_tween.kill()
		_tension_tween = create_tween()
		_tension_tween.tween_property(_tension_player, "volume_db", SILENCE_DB, 0.5)
		return
	# Try WAV first (new packs), then OGG (legacy)
	var path: String = "res://assets/audio/tension/%s.wav" % tension_loop
	if not ResourceLoader.exists(path):
		path = "res://assets/audio/tension/%s.ogg" % tension_loop
	if not ResourceLoader.exists(path):
		return
	var stream: AudioStream = load(path)
	if stream == null:
		return
	if _tension_player.stream != stream:
		_tension_player.stream = stream
		_tension_player.volume_db = SILENCE_DB
		_tension_player.play()
	var target_db: float = TENSION_BASE_DB + (1.0 - _tension_volume_scale) * -20.0
	target_db = clampf(target_db, SILENCE_DB, TENSION_BASE_DB)
	if _tension_tween and _tension_tween.is_valid():
		_tension_tween.kill()
	_tension_tween = create_tween()
	_tension_tween.tween_property(_tension_player, "volume_db", target_db, 1.5)

func _swap_players() -> void:
	_ambient_current.stop()
	var temp: AudioStreamPlayer = _ambient_current
	_ambient_current = _ambient_next
	_ambient_next = temp

func play_sfx(sfx_name: String) -> void:
	var path: String = "res://assets/audio/sfx/%s.ogg" % sfx_name
	if not ResourceLoader.exists(path):
		return
	var stream: AudioStream = load(path)
	if stream == null:
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
	_tension_player.stop()
	_current_loop_name = ""


func _resolve_loop_path(loop_name: String) -> String:
	if loop_name.begins_with("res://"):
		return loop_name
	return "res://assets/audio/loops/%s.ogg" % loop_name

func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
