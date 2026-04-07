extends Node
## res://scripts/flashback_manager.gd -- Horror flashback system
## PSX dither fade -> spawn horror model -> display text -> despawn -> return.
## Each flashback is a one-time flagged event.

signal flashback_started(flashback_id: String)
signal flashback_ended(flashback_id: String)

var _room_manager: Node = null
var _ui_overlay: Control = null
var _shake_profiles: Node = null
var _active_model: Node3D = null
var _is_playing: bool = false

# Flashback definitions: room_id -> {id, flag, model, scale, position, text}
const FLASHBACKS: Dictionary = {
	"parlor": {
		"id": "flashback_parlor",
		"flag": "seen_parlor_flashback",
		"model": "res://assets/horror/models/bloodwraith.glb",
		"scale": Vector3(0.6, 0.6, 0.6),
		"position": Vector3(0, 0, -1),
		"text": "She used to sit here. Every afternoon. Waiting.",
	},
	"master_bedroom": {
		"id": "flashback_bedroom",
		"flag": "seen_bedroom_flashback",
		"model": "res://assets/horror/models/plague_doctor.glb",
		"scale": Vector3(1, 1, 1),
		"position": Vector3(2, 0, 3),
		"text": "The doctor came every night. No one heard her cry.",
	},
	"library": {
		"id": "flashback_library",
		"flag": "seen_library_flashback",
		"model": "res://assets/horror/models/plague_doctor.glb",
		"scale": Vector3(1, 1, 1),
		"position": Vector3(0, 0, 2),
		"text": "He wrote the binding. Page by careful page.",
	},
	"foyer": {
		"id": "flashback_foyer",
		"flag": "seen_foyer_flashback",
		"model": "res://assets/horror/models/bloodwraith.glb",
		"scale": Vector3(1, 1, 1),
		"position": Vector3(0, 0, 0),
		"text": "She stood here the night it happened. Watching them leave.",
	},
	"dining_room": {
		"id": "flashback_dining",
		"flag": "seen_dining_flashback",
		"model": "",
		"scale": Vector3(1, 1, 1),
		"position": Vector3(0, 0, 0),
		"text": "All eight, seated. The last supper of the Ashworths.",
	},
	"family_crypt": {
		"id": "flashback_crypt",
		"flag": "seen_crypt_flashback",
		"model": "res://assets/horror/models/bloodwraith.glb",
		"scale": Vector3(0.8, 0.8, 0.8),
		"position": Vector3(0, 0, 1),
		"text": "Lady Ashworth knelt here. Begging forgiveness that never came.",
	},
}

func _ready() -> void:
	call_deferred("_connect_signals")

func _connect_signals() -> void:
	_room_manager = _find_node("RoomManager")
	_ui_overlay = _find_node("UIOverlay") as Control
	_shake_profiles = _find_node("ShakeProfiles")

	if _room_manager and _room_manager.has_signal("room_loaded"):
		_room_manager.room_loaded.connect(_on_room_loaded)

func _on_room_loaded(room_id: String) -> void:
	if _is_playing:
		return
	# Only trigger flashbacks during horror or resolution phase
	var gsm: Node = _find_node("GameStateMachine")
	if gsm and gsm.has_method("is_horror_or_later"):
		if not gsm.is_horror_or_later():
			return
	elif not GameManager.has_flag("elizabeth_aware"):
		return

	var fb: Dictionary = FLASHBACKS.get(room_id, {})
	if fb.is_empty():
		return
	var flag: String = fb.get("flag", "")
	if flag.is_empty() or GameManager.has_flag(flag):
		return

	# Trigger flashback after short delay
	GameManager.set_flag(flag)
	get_tree().create_timer(2.0).timeout.connect(
		_play_flashback.bind(fb)
	)

func _play_flashback(fb: Dictionary) -> void:
	if _is_playing:
		return
	_is_playing = true
	var fb_id: String = fb.get("id", "")
	flashback_started.emit(fb_id)

	# Camera shake
	if _shake_profiles and _shake_profiles.has_method("_apply_profile"):
		_shake_profiles._apply_profile("mirror_event")

	# Fade to dither black
	var rm: Node = _room_manager
	var fade_rect: ColorRect = null
	if rm:
		fade_rect = rm.get_node_or_null("FadeLayer/FadeRect")

	if fade_rect and fade_rect.material is ShaderMaterial:
		var shader_mat: ShaderMaterial = fade_rect.material as ShaderMaterial
		var tween: Tween = create_tween()
		# Fade out
		tween.tween_method(_set_fade.bind(shader_mat), 0, 200, 0.5)
		tween.tween_callback(_spawn_model.bind(fb))
		tween.tween_interval(0.3)
		# Fade back in with model visible
		tween.tween_method(_set_fade.bind(shader_mat), 200, 0, 0.5)
		tween.tween_interval(0.5)
		# Show text
		tween.tween_callback(_show_text.bind(fb.get("text", "")))
		tween.tween_interval(4.0)
		# Fade out to remove model
		tween.tween_method(_set_fade.bind(shader_mat), 0, 200, 0.5)
		tween.tween_callback(_despawn_model)
		tween.tween_interval(0.2)
		# Fade back in
		tween.tween_method(_set_fade.bind(shader_mat), 200, 0, 0.5)
		tween.tween_callback(_end_flashback.bind(fb_id))
	else:
		# Fallback without shader fade
		_spawn_model(fb)
		_show_text(fb.get("text", ""))
		get_tree().create_timer(4.0).timeout.connect(
			func():
				_despawn_model()
				_end_flashback(fb_id)
		)

func _set_fade(value: int, shader_mat: ShaderMaterial) -> void:
	shader_mat.set_shader_parameter("alpha", value)

func _spawn_model(fb: Dictionary) -> void:
	var model_path: String = fb.get("model", "")
	if model_path.is_empty() or not ResourceLoader.exists(model_path):
		return
	var scene: PackedScene = load(model_path)
	if scene == null:
		return
	_active_model = scene.instantiate() as Node3D
	if _active_model == null:
		return

	var room = _room_manager.get_current_room() if _room_manager else null
	if room:
		_active_model.position = fb.get("position", Vector3.ZERO)
		_active_model.scale = fb.get("scale", Vector3.ONE)
		room.add_child(_active_model)

func _despawn_model() -> void:
	if _active_model and is_instance_valid(_active_model):
		_active_model.queue_free()
		_active_model = null

func _show_text(text: String) -> void:
	if _ui_overlay and _ui_overlay.has_method("show_document"):
		_ui_overlay.show_document("", text)

func _end_flashback(fb_id: String) -> void:
	_is_playing = false
	if _ui_overlay and _ui_overlay.has_method("hide_document"):
		_ui_overlay.hide_document()
	flashback_ended.emit(fb_id)

func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
