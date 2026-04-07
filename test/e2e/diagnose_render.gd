extends SceneTree

var _main: Node = null
var _frame: int = 0


func _initialize() -> void:
	_main = load("res://scenes/main.tscn").instantiate()
	root.add_child(_main)
	current_scene = _main
	call_deferred("_setup")


func _setup() -> void:
	var gm: Node = root.get_node_or_null("GameManager")
	if gm != null and gm.has_method("new_game"):
		gm.new_game()


func _process(_delta: float) -> bool:
	_frame += 1
	if _frame < 30:
		return false

	var rm: Node = _find(_main, "RoomManager")
	var player: Node = _find(_main, "PlayerController")
	var camera: Camera3D = _find_camera(_main)
	var viewport: Viewport = _main.get_viewport()
	var room: Node = null
	if rm != null and rm.has_method("get_current_room"):
		room = rm.get_current_room()

	print("=== Render Diagnose ===")
	print("room_loaded=", room != null)
	if room != null:
		print("room_name=", room.name)
		print("room_id=", room.get("room_id"))
		print("children=", room.get_child_count())
		print("meshes=", _count_nodes_of_type(room, MeshInstance3D))
		print("lights=", _count_nodes_of_type(room, Light3D))
		print("areas=", _count_nodes_of_type(room, Area3D))
	if player != null:
		print("player_pos=", player.global_position)
		print("player_rot=", player.rotation_degrees)
	if camera != null:
		print("camera_current=", camera.current)
		print("camera_pos=", camera.global_position)
		print("camera_rot=", camera.rotation_degrees)
	print("viewport_camera_matches=", viewport.get_camera_3d() == camera)

	await RenderingServer.frame_post_draw
	var img := viewport.get_texture().get_image()
	print("img_size=", img.get_size())
	print("avg_luma=", _average_luma(img))
	img.save_png("user://screenshots/diagnose_render.png")
	print("saved=", ProjectSettings.globalize_path("user://screenshots/diagnose_render.png"))

	if camera != null:
		await _capture_pose(viewport, camera, camera.global_position, camera.global_basis.get_euler(), "diagnose_render_spawn")
		camera.global_position = Vector3(0, 5.5, -18.0)
		camera.look_at(Vector3(0, 2.5, 12.0), Vector3.UP)
		await _capture_pose(viewport, camera, camera.global_position, camera.global_basis.get_euler(), "diagnose_render_overview")
		camera.global_position = Vector3(0, 2.0, 4.0)
		camera.look_at(Vector3(0, 2.5, 13.5), Vector3.UP)
		await _capture_pose(viewport, camera, camera.global_position, camera.global_basis.get_euler(), "diagnose_render_facade")
	quit()
	return true


func _capture_pose(viewport: Viewport, camera: Camera3D, position: Vector3, rotation: Vector3, name: String) -> void:
	camera.global_position = position
	camera.global_rotation = rotation
	await RenderingServer.frame_post_draw
	var img := viewport.get_texture().get_image()
	print(name, "_avg_luma=", _average_luma(img))
	img.save_png("user://screenshots/%s.png" % name)
	print(name, "_saved=", ProjectSettings.globalize_path("user://screenshots/%s.png" % name))


func _average_luma(img: Image) -> float:
	if img == null:
		return -1.0
	var sample_points := [
		Vector2i(10, 10),
		Vector2i(img.get_width() / 2, img.get_height() / 2),
		Vector2i(img.get_width() - 10, img.get_height() - 10),
		Vector2i(img.get_width() / 4, img.get_height() / 4),
		Vector2i((img.get_width() * 3) / 4, (img.get_height() * 3) / 4),
	]
	var total := 0.0
	var count := 0
	for point in sample_points:
		if point.x >= 0 and point.y >= 0 and point.x < img.get_width() and point.y < img.get_height():
			var c := img.get_pixelv(point)
			total += (c.r + c.g + c.b) / 3.0
			count += 1
	if count == 0:
		return -1.0
	return total / float(count)


func _count_nodes_of_type(node: Node, kind) -> int:
	var total := 0
	if is_instance_of(node, kind):
		total += 1
	for child in node.get_children():
		total += _count_nodes_of_type(child, kind)
	return total


func _find_camera(n: Node) -> Camera3D:
	if n is Camera3D:
		return n as Camera3D
	for ch in n.get_children():
		var f = _find_camera(ch)
		if f:
			return f
	return null


func _find(n: Node, t: String) -> Node:
	if n.name == t:
		return n
	for ch in n.get_children():
		var f: Node = _find(ch, t)
		if f != null:
			return f
	return null
