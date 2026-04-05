extends SceneTree
## Scene builder — run: timeout 60 godot --headless --script scenes/build_main.gd

func _initialize() -> void:
	print("Generating: main scene")

	var root := Node3D.new()
	root.name = "Main"

	# --- WorldEnvironment ---
	var world_env := WorldEnvironment.new()
	world_env.name = "WorldEnvironment"
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.02, 0.01, 0.02)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.15, 0.1, 0.08)  # Warm amber ambient (candlelit Victorian)
	env.ambient_light_energy = 1.5
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_white = 2.5
	env.tonemap_exposure = 1.2
	# Fog — warm dust, not cold purple
	env.fog_enabled = true
	env.fog_light_color = Color(0.1, 0.06, 0.04)  # Warm brown dust
	env.fog_density = 0.003
	# Bloom — candle glow
	env.glow_enabled = true
	env.glow_intensity = 0.6
	env.glow_bloom = 0.4
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
	env.glow_hdr_threshold = 0.8
	# SSAO for depth in enclosed rooms
	env.ssao_enabled = true
	env.ssao_radius = 2.0
	env.ssao_intensity = 1.5
	# Color adjustment — warmer, more saturated
	env.adjustment_enabled = true
	env.adjustment_brightness = 1.0
	env.adjustment_contrast = 1.15
	env.adjustment_saturation = 0.9
	world_env.environment = env
	root.add_child(world_env)

	# --- RoomManager (Node3D for holding room geometry) ---
	var room_mgr := Node3D.new()
	room_mgr.name = "RoomManager"
	room_mgr.set_script(load("res://scripts/room_manager.gd"))
	root.add_child(room_mgr)

	# --- PlayerController (CharacterBody3D) ---
	var player := CharacterBody3D.new()
	player.name = "PlayerController"
	player.set_script(load("res://scripts/player_controller.gd"))
	player.position = Vector3(0, 0, 0)
	player.collision_layer = 1
	player.collision_mask = 1 | 2  # floor + walls

	# Player collision shape (capsule)
	var player_col := CollisionShape3D.new()
	player_col.name = "CollisionShape"
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.3
	capsule.height = 1.7
	player_col.shape = capsule
	player_col.position = Vector3(0, 0.85, 0)
	player.add_child(player_col)

	# Camera
	var camera := Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0, 1.7, 0)
	camera.fov = 75.0
	camera.near = 0.1
	camera.far = 100.0
	camera.current = true
	player.add_child(camera)

	root.add_child(player)

	# --- AudioManager ---
	var audio_mgr := Node.new()
	audio_mgr.name = "AudioManager"
	audio_mgr.set_script(load("res://scripts/audio_manager.gd"))

	var ambient_current := AudioStreamPlayer.new()
	ambient_current.name = "AmbientCurrent"
	ambient_current.bus = "Master"
	ambient_current.volume_db = -6.0
	audio_mgr.add_child(ambient_current)

	var ambient_next := AudioStreamPlayer.new()
	ambient_next.name = "AmbientNext"
	ambient_next.bus = "Master"
	ambient_next.volume_db = -80.0
	audio_mgr.add_child(ambient_next)

	var sfx_player := AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "Master"
	sfx_player.volume_db = 0.0
	audio_mgr.add_child(sfx_player)

	root.add_child(audio_mgr)

	# --- InteractionManager ---
	var interaction_mgr := Node.new()
	interaction_mgr.name = "InteractionManager"
	interaction_mgr.set_script(load("res://scripts/interaction_manager.gd"))
	root.add_child(interaction_mgr)

	# --- PSX Post-Processing Layer ---
	var psx_layer := CanvasLayer.new()
	psx_layer.name = "PSXLayer"
	psx_layer.layer = 2  # Below UI (layer 5) but above game

	var psx_rect := ColorRect.new()
	psx_rect.name = "PSXEffect"
	psx_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	psx_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var psx_shader: Shader = load("res://shaders/psx_post.gdshader")
	var psx_mat := ShaderMaterial.new()
	psx_mat.shader = psx_shader
	psx_mat.set_shader_parameter("color_depth", 15.0)
	psx_mat.set_shader_parameter("resolution_scale", 0.5)
	psx_mat.set_shader_parameter("dither_strength", 0.25)
	psx_rect.material = psx_mat
	psx_layer.add_child(psx_rect)

	root.add_child(psx_layer)

	# --- UILayer (CanvasLayer for all UI) ---
	var ui_layer := CanvasLayer.new()
	ui_layer.name = "UILayer"
	ui_layer.layer = 5

	var ui_overlay := Control.new()
	ui_overlay.name = "UIOverlay"
	ui_overlay.set_script(load("res://scripts/ui_overlay.gd"))
	ui_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(ui_overlay)

	root.add_child(ui_layer)

	# NOTE: FadeLayer is created by RoomManager._setup_fade_overlay() at runtime
	# Do NOT add a second one here

	# --- Set ownership chain ---
	set_owner_on_new_nodes(root, root)

	# --- Pack and validate ---
	var count := _count_nodes(root)
	var packed := PackedScene.new()
	var err := packed.pack(root)
	if err != OK:
		push_error("Pack failed: " + str(err))
		quit(1)
		return
	if not validate_packed_scene(packed, count, "res://scenes/main.tscn"):
		quit(1)
		return

	err = ResourceSaver.save(packed, "res://scenes/main.tscn")
	if err != OK:
		push_error("Save failed: " + str(err))
		quit(1)
		return

	print("BUILT: %d nodes" % count)
	print("Saved: res://scenes/main.tscn")
	quit(0)

func set_owner_on_new_nodes(node: Node, scene_owner: Node) -> void:
	for child in node.get_children():
		child.owner = scene_owner
		if child.scene_file_path.is_empty():
			set_owner_on_new_nodes(child, scene_owner)

func _count_nodes(node: Node) -> int:
	var total := 1
	for child in node.get_children():
		total += _count_nodes(child)
	return total

func validate_packed_scene(packed: PackedScene, expected_count: int, scene_path: String) -> bool:
	var test_instance = packed.instantiate()
	var actual := _count_nodes(test_instance)
	test_instance.free()
	if actual < expected_count:
		push_error("Pack validation failed for %s: expected %d nodes, got %d" % [scene_path, expected_count, actual])
		return false
	return true
