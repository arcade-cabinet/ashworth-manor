class_name WindowBuilder
extends RefCounted
## Generates window inserts: frame + pane + optional boards/shutters.

const FRAME_WIDTH := 0.08
const WINDOW_WIDTH := 1.2
const WINDOW_HEIGHT := 1.0
const WINDOW_Y := 1.0  # Bottom of window from floor

## Build a window insert from segment type.
## segment_type: "window", "window_boarded", "window_shuttered"
static func build(segment_type: String, texture_path: String) -> Node3D:
	var window_root := Node3D.new()
	window_root.name = "Window"

	# Frame
	var frame := _build_frame(texture_path)
	window_root.add_child(frame)

	match segment_type:
		"window":
			var pane := _build_pane()
			window_root.add_child(pane)
		"window_boarded":
			var pane := _build_pane()
			window_root.add_child(pane)
			var boards := _build_boards()
			window_root.add_child(boards)
		"window_shuttered":
			var pane := _build_pane()
			window_root.add_child(pane)
			var shutters := _build_shutters()
			window_root.add_child(shutters)

	window_root.position.y = WINDOW_Y
	return window_root


static func _build_frame(texture_path: String) -> Node3D:
	var frame := Node3D.new()
	frame.name = "WindowFrame"

	var mat: StandardMaterial3D = null
	if not texture_path.is_empty() and ResourceLoader.exists(texture_path):
		mat = StandardMaterial3D.new()
		mat.albedo_texture = load(texture_path)
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

	# Top beam
	var top := _make_beam(Vector3(WINDOW_WIDTH, FRAME_WIDTH, FRAME_WIDTH))
	top.position = Vector3(0, WINDOW_HEIGHT, 0)
	if mat:
		top.set_surface_override_material(0, mat)
	frame.add_child(top)

	# Bottom beam
	var bottom := _make_beam(Vector3(WINDOW_WIDTH, FRAME_WIDTH, FRAME_WIDTH))
	bottom.position = Vector3(0, 0, 0)
	if mat:
		bottom.set_surface_override_material(0, mat)
	frame.add_child(bottom)

	# Left beam
	var left := _make_beam(Vector3(FRAME_WIDTH, WINDOW_HEIGHT, FRAME_WIDTH))
	left.position = Vector3(-WINDOW_WIDTH * 0.5, WINDOW_HEIGHT * 0.5, 0)
	if mat:
		left.set_surface_override_material(0, mat)
	frame.add_child(left)

	# Right beam
	var right := _make_beam(Vector3(FRAME_WIDTH, WINDOW_HEIGHT, FRAME_WIDTH))
	right.position = Vector3(WINDOW_WIDTH * 0.5, WINDOW_HEIGHT * 0.5, 0)
	if mat:
		right.set_surface_override_material(0, mat)
	frame.add_child(right)

	# Center cross
	var cross_h := _make_beam(Vector3(WINDOW_WIDTH, FRAME_WIDTH * 0.5, FRAME_WIDTH * 0.5))
	cross_h.position = Vector3(0, WINDOW_HEIGHT * 0.5, 0)
	frame.add_child(cross_h)

	var cross_v := _make_beam(Vector3(FRAME_WIDTH * 0.5, WINDOW_HEIGHT, FRAME_WIDTH * 0.5))
	cross_v.position = Vector3(0, WINDOW_HEIGHT * 0.5, 0)
	frame.add_child(cross_v)

	return frame


static func _build_pane() -> MeshInstance3D:
	var pane := MeshInstance3D.new()
	pane.name = "WindowPane"
	var quad := QuadMesh.new()
	quad.size = Vector2(WINDOW_WIDTH - FRAME_WIDTH * 2, WINDOW_HEIGHT - FRAME_WIDTH * 2)
	pane.mesh = quad
	pane.position = Vector3(0, WINDOW_HEIGHT * 0.5, 0.01)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.65, 0.7, 0.3)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	pane.set_surface_override_material(0, mat)

	return pane


static func _build_boards() -> Node3D:
	var boards := Node3D.new()
	boards.name = "Boards"

	for i in range(3):
		var board := MeshInstance3D.new()
		board.name = "Board_%d" % i
		var quad := QuadMesh.new()
		quad.size = Vector2(WINDOW_WIDTH * 1.1, 0.15)
		board.mesh = quad
		board.position = Vector3(0, WINDOW_HEIGHT * (0.25 + i * 0.25), 0.02)
		board.rotation_degrees.z = randf_range(-8.0, 8.0)

		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.35, 0.25, 0.15)
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		board.set_surface_override_material(0, mat)

		boards.add_child(board)

	return boards


static func _build_shutters() -> Node3D:
	var shutters := Node3D.new()
	shutters.name = "Shutters"

	# Left shutter
	var left_hinge := Node3D.new()
	left_hinge.name = "LeftShutterHinge"
	left_hinge.position = Vector3(-WINDOW_WIDTH * 0.5, WINDOW_HEIGHT * 0.5, 0.02)
	var left_panel := MeshInstance3D.new()
	var quad_l := QuadMesh.new()
	quad_l.size = Vector2(WINDOW_WIDTH * 0.45, WINDOW_HEIGHT * 0.9)
	left_panel.mesh = quad_l
	left_panel.position = Vector3(WINDOW_WIDTH * 0.225, 0, 0)
	left_hinge.add_child(left_panel)
	shutters.add_child(left_hinge)

	# Right shutter
	var right_hinge := Node3D.new()
	right_hinge.name = "RightShutterHinge"
	right_hinge.position = Vector3(WINDOW_WIDTH * 0.5, WINDOW_HEIGHT * 0.5, 0.02)
	var right_panel := MeshInstance3D.new()
	var quad_r := QuadMesh.new()
	quad_r.size = Vector2(WINDOW_WIDTH * 0.45, WINDOW_HEIGHT * 0.9)
	right_panel.mesh = quad_r
	right_panel.position = Vector3(-WINDOW_WIDTH * 0.225, 0, 0)
	right_hinge.add_child(right_panel)
	shutters.add_child(right_hinge)

	return shutters


static func _make_beam(size: Vector3) -> MeshInstance3D:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	return mesh_inst
