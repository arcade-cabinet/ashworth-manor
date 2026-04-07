@tool
extends Node3D

@export_group("Generation Settings")
@export var generate_island: bool = false : set = _generate_triggered
@export var clear_island: bool = false : set = _clear_triggered
@export var seed_value: int = 0

@export_group("Dimensions")
@export var map_size: int = 128
@export var map_scale: float = 2.0
@export var island_height: float = 35.0
@export var island_radius_falloff: float = 0.45 

@export_group("Visuals")
@export var noise: FastNoiseLite
@export var island_material: Material

@export_group("Vegetation")
@export var palm_trees: Array[PackedScene]
@export var tree_density: float = 0.6 
@export var beach_threshold: float = 3.5 
@export var tree_slope_limit: float = 0.6 
@export var tree_global_scale: float = 1.0 

@export_group("Procedural Rocks")
@export var generate_rocks: bool = true
@export var rock_count: int = 40
@export var rock_global_scale: float = 1.0
@export var rock_material: StandardMaterial3D

@export_group("Underwater Props")
@export var underwater_props: Array[PackedScene]
@export var underwater_density: float = 0.5
@export var underwater_height_min: float = -6.0
@export var underwater_height_max: float = -2.0
@export var underwater_prop_scale: float = 1.0

var _mesh_instance: MeshInstance3D
var _vegetation_container: Node3D
var _rocks_container: Node3D
var _underwater_container: Node3D


func _ready() -> void:
	if Engine.is_editor_hint():
		_generate_triggered(true)

func _generate_triggered(value):
	if value:
		generate_full_island()
		generate_island = false 

func _clear_triggered(value):
	if value:
		_cleanup()
		clear_island = false

func generate_full_island():
	_cleanup()
	
	if not noise:
		printerr("Please assign a FastNoiseLite resource.")
		return
		
	if seed_value == 0:
		seed_value = randi()
	noise.seed = seed_value
	
	var terrain_data = _create_terrain_mesh()
	
	if palm_trees.size() > 0:
		_place_vegetation(terrain_data)

	if generate_rocks:
		_place_procedural_rocks(terrain_data)

	if underwater_props.size() > 0:
		_place_underwater_props(terrain_data)

func _cleanup():
	for child in get_children():
		if child.name == "IslandMesh" or child.name == "Vegetation" or child.name == "Rocks" or child.name == "Underwater":
			child.queue_free()
	
	_mesh_instance = null
	_vegetation_container = null
	_rocks_container = null
	_underwater_container = null

# terrain generation
func _create_terrain_mesh() -> Dictionary:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var surface_positions = [] 
	var offset = (Vector2(map_size, map_size) * map_scale) / 2.0
	
	# add vertices
	for z in range(map_size + 1):
		for x in range(map_size + 1):
			var x_pos = x * map_scale - offset.x
			var z_pos = z * map_scale - offset.y
			var y_pos = _get_procedural_height(x_pos, z_pos)
			
			var uv = Vector2(x, z) / float(map_size)
			
			# vertex color calculation/splatmap
			# we mix 3 channels based on height logic
			# red is wet sand/low, green is dry sand/mid, blue is grass/high
			
			var weight_grass = smoothstep(beach_threshold - 1.5, beach_threshold + 1.0, y_pos)
			var weight_wet = 1.0 - smoothstep(-1.5, 1.5, y_pos)
			var weight_dry = clamp(1.0 - weight_grass - weight_wet, 0.0, 1.0)
			
			var color = Color(weight_wet, weight_dry, weight_grass, 1.0)
			
			st.set_uv(uv)
			st.set_color(color) # apply color before adding vertex
			st.add_vertex(Vector3(x_pos, y_pos, z_pos))
	
	# build indices clockwise
	for z in range(map_size):
		for x in range(map_size):
			var top_left = z * (map_size + 1) + x
			var top_right = top_left + 1
			var bottom_left = (z + 1) * (map_size + 1) + x
			var bottom_right = bottom_left + 1
			
			st.add_index(top_left)
			st.add_index(top_right)
			st.add_index(bottom_left)
			
			st.add_index(top_right)
			st.add_index(bottom_right)
			st.add_index(bottom_left)
			
	st.generate_normals()
	st.generate_tangents()
	
	var mesh = st.commit()
	
	_mesh_instance = MeshInstance3D.new()
	_mesh_instance.name = "IslandMesh"
	_mesh_instance.mesh = mesh
	
	if island_material:
		_mesh_instance.material_override = island_material
		
	add_child(_mesh_instance)
	#_mesh_instance.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else self
	
	_mesh_instance.create_trimesh_collision()
	
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	for i in range(mdt.get_vertex_count()):
		surface_positions.append({
			"pos": mdt.get_vertex(i),
			"normal": mdt.get_vertex_normal(i)
		})
		
	return {"vertices": surface_positions}

func _get_procedural_height(x: float, z: float) -> float:
	var dist = Vector2(x, z).length()
	var max_dist = (map_size * map_scale) * island_radius_falloff
	
	var mask = 1.0 - (dist / max_dist)
	mask = clamp(mask, 0.0, 1.0)
	mask = ease(mask, 0.4) 
	
	if mask <= 0:
		return -10.0
		
	var noise_val = noise.get_noise_2d(x, z)
	var final_height = (noise_val * 0.5 + 0.5) * island_height * mask
	final_height -= (1.0 - mask) * 10.0
	
	return final_height

# vegetation placement
func _place_vegetation(data: Dictionary):
	_vegetation_container = Node3D.new()
	_vegetation_container.name = "Vegetation"
	add_child(_vegetation_container)
	#_vegetation_container.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else self

	var verts = data["vertices"]
	
	for v in verts:
		var pos = v["pos"]
		var normal = v["normal"]
		
		if pos.y > beach_threshold:
			var slope = normal.dot(Vector3.UP)
			if slope > (1.0 - tree_slope_limit):
				var n_tree = noise.get_noise_2d(pos.x * 2.5, pos.z * 2.5)
				if randf() < (tree_density * (n_tree * 0.5 + 0.7)):
					_spawn_tree(pos, normal)

func _spawn_tree(pos: Vector3, normal: Vector3):
	var scene = palm_trees.pick_random()
	var inst = scene.instantiate()
	_vegetation_container.add_child(inst)
	inst.position = pos
	inst.rotate_y(randf() * TAU)
	
	var variation = randf_range(0.9, 1.1)
	var s = tree_global_scale * variation
	inst.scale = Vector3(s, s, s)
	
	var target_basis = Basis.looking_at(normal) if normal.is_normalized() else Basis()
	inst.basis = inst.basis.slerp(target_basis, 0.1) 

# procedural rocks
func _place_procedural_rocks(data: Dictionary):
	_rocks_container = Node3D.new()
	_rocks_container.name = "Rocks"
	add_child(_rocks_container)
	#_rocks_container.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else self
	
	var valid_locs = data["vertices"].filter(func(v): return v["pos"].y > 0.0)
	
	for i in range(rock_count):
		if valid_locs.is_empty(): break
		var loc = valid_locs.pick_random()
		
		var rock_mesh = _generate_procedural_rock_mesh()
		var mi = MeshInstance3D.new()
		mi.mesh = rock_mesh
		
		if rock_material:
			mi.material_override = rock_material
		else:
			var rm = StandardMaterial3D.new()
			rm.albedo_color = Color(0.4, 0.4, 0.4)
			rm.cull_mode = BaseMaterial3D.CULL_DISABLED 
			mi.material_override = rm
			
		_rocks_container.add_child(mi)
		mi.position = loc["pos"] - Vector3(0, randf_range(0.1, 0.4), 0)
		
		mi.rotate_y(randf() * TAU)
		mi.rotate_x(randf() * TAU)
		
		# apply global rock scale
		var s = randf_range(1.0, 3.5) * rock_global_scale
		mi.scale = Vector3(s, s, s)

func _generate_procedural_rock_mesh() -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var p1 = Vector3(0, 1, 0) * randf_range(0.8, 1.2)
	var p2 = Vector3(1, -0.5, 1).normalized() * randf_range(0.8, 1.2)
	var p3 = Vector3(-1, -0.5, 1).normalized() * randf_range(0.8, 1.2)
	var p4 = Vector3(0, -0.5, -1).normalized() * randf_range(0.8, 1.2)
	
	# outside facing winding
	st.add_vertex(p1); st.add_vertex(p2); st.add_vertex(p3)
	st.add_vertex(p1); st.add_vertex(p4); st.add_vertex(p2)
	st.add_vertex(p1); st.add_vertex(p3); st.add_vertex(p4)
	st.add_vertex(p2); st.add_vertex(p4); st.add_vertex(p3)
	
	for i in range(12):
		st.add_index(i)
	
	st.generate_normals()
	return st.commit()

# underwater props
func _place_underwater_props(data: Dictionary):
	_underwater_container = Node3D.new()
	_underwater_container.name = "Underwater"
	add_child(_underwater_container)
	#_underwater_container.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else self
	
	var verts = data["vertices"]
	
	for v in verts:
		var pos = v["pos"]
		var normal = v["normal"]
		
		# check height range
		if pos.y >= underwater_height_min and pos.y <= underwater_height_max:
			
			# debug print for first few valid spots
			if randf() < 0.001:
				print("Valid underwater spot at: ", pos, " Range: [", underwater_height_min, ", ", underwater_height_max, "]")

			# use noise for natural distribution
			# we can just use randf() against density, or noise for clumps. 
			if randf() < (underwater_density * 0.1): # scale down density a bit as vertices are dense
				_spawn_underwater_prop(pos, normal)

func _spawn_underwater_prop(pos: Vector3, normal: Vector3):
	if underwater_props.is_empty(): return
	
	var scene = underwater_props.pick_random()
	var inst = scene.instantiate()
	_underwater_container.add_child(inst)
	inst.position = pos
	
	# debug check
	if abs(inst.position.y) < 0.01 and abs(pos.y) > 0.1:
		printerr("Spawned prop at ", inst.position, " but requested ", pos)
	
	# random rotation
	inst.rotate_y(randf() * TAU)
	
	# scale
	var s = randf_range(0.8, 1.2) * underwater_prop_scale
	inst.scale = Vector3(s, s, s)
