# Scene Generation

Two approaches, in order of preference:

## Approach 1: Direct `.tscn` Authoring (PREFERRED)

Write `.tscn` files directly as text using the Write tool. No Godot process needed. Parallelizable. Fastest.

### Format

```
[gd_scene format=3]

[ext_resource type="Script" path="res://scripts/my_script.gd" id="1"]
[ext_resource type="PackedScene" path="res://assets/model.glb" id="2"]

[sub_resource type="BoxShape3D" id="BoxShape3D_1"]
size = Vector3(10, 0.2, 10)

[node name="Root" type="Node3D"]
script = ExtResource("1")
my_export_var = "value"

[node name="Child" type="Node3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 5, 0, 3)

[node name="Model" type="Node3D" parent="Child" instance=ExtResource("2")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

[node name="Collision" type="StaticBody3D" parent="."]
collision_layer = 1

[node name="Shape" type="CollisionShape3D" parent="Collision"]
shape = SubResource("BoxShape3D_1")
```

### Key rules

- `uid` in ext_resource is OPTIONAL — Godot assigns on first load. Omit it.
- `id` in ext_resource is a local reference string (any format: "1", "1_abc", etc.)
- `parent` in node is the path from root: `"."` = root, `"Child"` = direct child named Child, `"Child/Grandchild"` = nested
- `instance=ExtResource("id")` makes a node an instance of a PackedScene (GLB/TSCN)
- `transform` uses Transform3D(basis_x, basis_y, basis_z, origin) — for position-only: `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, X, Y, Z)`
- For rotation: compute the basis matrix, or use Godot's rotation import. For simple Y-rotation of 90°: `Transform3D(0, 0, 1, 0, 1, 0, -1, 0, 0, X, Y, Z)`
- For rotation of 180° on Y: `Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, -1, X, Y, Z)`
- For rotation of -90° on Y: `Transform3D(0, 0, -1, 0, 1, 0, 1, 0, 0, X, Y, Z)`
- Scale: multiply basis vectors. Scale(2,2,2) = `Transform3D(2, 0, 0, 0, 2, 0, 0, 0, 2, X, Y, Z)`
- `sub_resource` IDs must be unique within the file
- Node groups: `groups = ["group_name"]` property on node
- Metadata: `metadata/key = value` property on node
- Area3D collision_layer is a bitmask integer: layer 3 = 4, layer 4 = 8

## Direct `.tres` Resource Authoring

Resources (InteractableData, RoomConnection, materials, etc.) are also text files:

```
[gd_resource type="Resource" script_class="InteractableData" format=3]

[ext_resource type="Script" path="res://scripts/interactable_data.gd" id="1"]

[resource]
script = ExtResource("1")
object_id = "foyer_painting"
object_type = "painting"
title = "Lord Ashworth"
content = "The patriarch stares down with hollow eyes."
on_read_flags = PackedStringArray("seen_lord_portrait")
```

### Key rules for .tres

- `script_class` must match the `class_name` in the GDScript
- Export vars become properties in `[resource]` section
- Arrays: `PackedStringArray("a", "b")`, `Array[String](["a", "b"])`
- Dictionaries: `{ "key": "value", "num": 42 }`
- Colors: `Color(0.5, 0.3, 0.2, 1)`
- Vectors: `Vector3(1, 2, 3)`

### Using .tres in .tscn

Reference a .tres as an ext_resource, then assign it as metadata or export:

```
[ext_resource type="Resource" path="res://resources/interactables/foyer_painting.tres" id="10"]

[node name="FoyerPainting" type="Area3D" parent="Interactables"]
metadata/interactable = ExtResource("10")
```

### Advantages over scene builders

- No Godot process needed — pure text file writing
- Can write ALL rooms in parallel (separate files, no shared state)
- No ownership chain bugs (the format handles it)
- No import step required (resources referenced by path)
- Smaller, cleaner files (no runtime overhead)
- Version-controllable diffs

### Common transforms

Position only (no rotation, no scale):
`Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, X, Y, Z)`

Y-rotation 90° (facing +X):
`Transform3D(0, 0, 1, 0, 1, 0, -1, 0, 0, X, Y, Z)`

Y-rotation -90° (facing -X):
`Transform3D(0, 0, -1, 0, 1, 0, 1, 0, 0, X, Y, Z)`

Y-rotation 180° (facing -Z):
`Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, -1, X, Y, Z)`

Scale S at position (X,Y,Z):
`Transform3D(S, 0, 0, 0, S, 0, 0, 0, S, X, Y, Z)`

## Approach 2: Scene Builders (when dynamic content needed)

Scene builders are GDScript files that run headless in Godot to produce `.tscn` files programmatically. They are NOT runtime scripts — they run once at build-time and exit.

### When to use scene builders instead of direct .tscn

- When you need to compute positions dynamically (grid layouts, procedural placement)
- When you need to measure GLB AABBs for scaling
- When you need to create resources that reference other resources in complex ways

### Scene Builder Output Requirements

Generate a single GDScript file that:
1. `extends SceneTree` (required for headless execution)
2. Implements `_initialize()` as entry point
3. Builds complete node hierarchy with all properties set
4. Sets `owner` on ALL descendants for serialization
5. Attaches scripts from STRUCTURE.md via `set_script()`
6. Saves scene using `PackedScene.pack()` + `ResourceSaver.save()`
7. Calls `quit()` when done

## Owner Chain (CRITICAL)

**MUST call `set_owner_on_new_nodes(root, root)` ONCE at the end**, after all nodes are added.

```gdscript
# At end of _initialize(), AFTER all add_child() calls:
set_owner_on_new_nodes(root, root)

func set_owner_on_new_nodes(node: Node, scene_owner: Node) -> void:
    for child in node.get_children():
        child.owner = scene_owner
        if child.scene_file_path.is_empty():
            # Node created with .new() — recurse into children
            set_owner_on_new_nodes(child, scene_owner)
        # else: instantiated scene (GLB/TSCN) — don't recurse, keeps as reference
```

### Post-Pack Validation

Call after `packed.pack(root)` to verify no nodes were silently dropped:

```gdscript
func validate_packed_scene(packed: PackedScene, expected_count: int, scene_path: String) -> bool:
    var test_instance = packed.instantiate()
    var actual := _count_nodes(test_instance)
    test_instance.free()
    if actual < expected_count:
        push_error("Pack validation failed for %s: expected %d nodes, got %d — nodes were dropped during serialization" % [scene_path, expected_count, actual])
        return false
    return true
```

Use in the scene template between `packed.pack(root)` and `ResourceSaver.save()`. **Gate the save on the validation result:**
```gdscript
    var count := _count_nodes(root)
    var err := packed.pack(root)
    if err != OK:
        push_error("Pack failed: " + str(err))
        quit(1)
        return
    if not validate_packed_scene(packed, count, "res://{output_path}.tscn"):
        quit(1)
        return
```

**WRONG patterns** (cause missing nodes in saved .tscn):
```gdscript
# WRONG: Setting owner only on direct children, forgetting grandchildren
terrain.owner = root  # Terrain's children (Mesh, Collision) have NO owner!

# WRONG: Calling helper on containers instead of root
set_owner_on_new_nodes(track_container, root)  # track_container itself has NO owner!
```

**GLB OWNERSHIP BUG** — Never use unconditional recursion. If you recurse into instantiated GLB models, ALL internal mesh/material nodes get serialized inline as text, causing 100MB+ .tscn files.

## Common Node Compositions

**3D Physics Object:**
```gdscript
var body := RigidBody3D.new()
var collision := CollisionShape3D.new()
var mesh := MeshInstance3D.new()
var shape := BoxShape3D.new()
shape.size = Vector3(1, 1, 1)
collision.shape = shape
body.add_child(collision)
body.add_child(mesh)
```

**Camera Rig:**
```gdscript
var pivot := Node3D.new()
var camera := Camera3D.new()
camera.position.z = 5
pivot.add_child(camera)
```

## Script Attachment (in Scenes)

```gdscript
# Attach scripts listed in STRUCTURE.md "Attaches to" fields
var script := load("res://scripts/player_controller.gd")
player_node.set_script(script)
```

## Asset Loading

**3D models (GLB):**
```gdscript
# MUST type as PackedScene, use = (not :=) for instantiate()
var model_scene: PackedScene = load("res://assets/glb/car.glb")
var model = model_scene.instantiate()
model.name = "CarModel"

# Measure for scaling — find MeshInstance3D (GLB structure varies, may be nested)
var mesh_inst: MeshInstance3D = find_mesh_instance(model)
var aabb: AABB = mesh_inst.get_aabb() if mesh_inst else AABB(Vector3.ZERO, Vector3.ONE)

# Scale to target size (e.g., car should be ~2 units long)
var target_length := 2.0
var scale_factor: float = target_length / aabb.size.x
model.scale = Vector3.ONE * scale_factor
model.position.y = -aabb.position.y * scale_factor  # Fix vertical alignment

parent_node.add_child(model)

func find_mesh_instance(node: Node) -> MeshInstance3D:
    if node is MeshInstance3D:
        return node
    for child in node.get_children():
        var found = find_mesh_instance(child)  # Recursive — use = not :=
        if found:
            return found
    return null
```

**GLB orientation:** Imported models often face the wrong axis. After instantiating, check the AABB: the longest dimension tells you which local axis the model faces. If a car's AABB is longest on Z but your game expects forward=negative Z, no rotation needed; if longest on X, rotate 90°. For animals/characters, the forward-facing axis must align with the direction of movement — an animal moving sideways is a clear bug. Verify this in screenshots: if the bounding box or silhouette doesn't match the movement direction, fix the rotation.

**Collision shapes for 3D models:** Always use simple primitives (BoxShape3D, SphereShape3D, CapsuleShape3D). Never use `create_convex_shape()` or `create_trimesh_shape()` on imported GLB meshes — causes <1 FPS on high-poly models (100k+ triangles).

```gdscript
# Box from AABB — use this for all imported models
var box := BoxShape3D.new()
box.size = aabb.size * model.scale
collision_shape.shape = box
```

**Textures (PNG):**
```gdscript
var mat := StandardMaterial3D.new()
mat.albedo_texture = load("res://assets/img/grass.png")
mesh_instance.set_surface_override_material(0, mat)
```

**Texture UV tiling:** For large surfaces, scale UVs to avoid stretched textures:
```gdscript
mat.uv1_scale = Vector3(10, 10, 1)  # Tile every 2m on a 20m floor
```

## Child Scene Instancing

```gdscript
# MUST type as PackedScene, use = for instantiate()
var car_scene: PackedScene = load("res://scenes/car.tscn")
var car = car_scene.instantiate()
car.name = "PlayerCar"
car.position = Vector3(0, 0, 5)
root.add_child(car)
car.owner = root  # Child internals already have owner — just set on instance root
```

## Scene Template

```gdscript
extends SceneTree

func _initialize() -> void:
    print("Generating: {scene_name}")

    var root := {RootNodeType}.new()
    root.name = "{SceneName}"

    # ... build node hierarchy, add_child(), set properties ...

    # Set ownership chain (skips instantiated scene internals)
    set_owner_on_new_nodes(root, root)

    # Count nodes before packing for verification
    var count := _count_nodes(root)

    # Pack and validate
    var packed := PackedScene.new()
    var err := packed.pack(root)
    if err != OK:
        push_error("Pack failed: " + str(err))
        quit(1)
        return
    if not validate_packed_scene(packed, count, "res://{output_path}.tscn"):
        quit(1)
        return

    # Save (only if validation passed)
    err = ResourceSaver.save(packed, "res://{output_path}.tscn")
    if err != OK:
        push_error("Save failed: " + str(err))
        quit(1)
        return

    print("BUILT: %d nodes" % count)
    print("Saved: res://{output_path}.tscn")
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
```

## Scene Constraints

- Do NOT use `@onready` or scene-time annotations (this runs at build-time)
- Do NOT use `preload()` — use `load()` (preload fails in headless)
- Do NOT connect signals at build-time — scripts aren't instantiated yet. Signal connections belong in runtime scripts' `_ready()` method
- **No spatial methods in `_initialize()`** — `look_at()`, `to_global()`, etc. fail because nodes aren't in the tree yet. Use `rotation_degrees` or compute transforms manually. In runtime scripts (`_ready()`, `_process()`), **always use `look_at()` to orient cameras and objects toward targets** — it's the correct tool there. Manual rotation math is error-prone and unnecessary.
- **2D/3D consistency** — never mix dimensions in the same scene hierarchy.

## Environment & Lighting (3D Scenes)

When building 3D scenes, set up environment and lighting programmatically:

```gdscript
# WorldEnvironment
var world_env := WorldEnvironment.new()
var env := Environment.new()
env.background_mode = Environment.BG_SKY
env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
env.ambient_light_color = Color.WHITE
env.ambient_light_sky_contribution = 0.5
var sky := Sky.new()
sky.sky_material = ProceduralSkyMaterial.new()
env.sky = sky
world_env.environment = env
root.add_child(world_env)

# Sun (DirectionalLight3D)
var sun := DirectionalLight3D.new()
sun.shadow_enabled = true
sun.shadow_bias = 0.05
sun.shadow_blur = 2.0
sun.directional_shadow_max_distance = 30.0
sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
sun.rotation_degrees = Vector3(-45, -30, 0)
root.add_child(sun)
```

## CSG for Rapid Prototyping

CSG nodes generate collision automatically — no separate CollisionShape needed:

```gdscript
var floor := CSGBox3D.new()
floor.size = Vector3(20, 0.5, 20)
floor.use_collision = true
floor.material = ground_mat
root.add_child(floor)

# Subtraction (carve holes): child CSG on parent CSG
var hole := CSGCylinder3D.new()
hole.operation = CSGShape3D.OPERATION_SUBTRACTION
hole.radius = 1.0
hole.height = 1.0
floor.add_child(hole)
```

## Noise/Procedural Textures

```gdscript
var noise := FastNoiseLite.new()
noise.noise_type = FastNoiseLite.TYPE_CELLULAR
noise.frequency = 0.02
noise.fractal_type = FastNoiseLite.FRACTAL_FBM
noise.fractal_octaves = 5

var tex := NoiseTexture2D.new()
tex.noise = noise
tex.width = 1024
tex.height = 1024
tex.seamless = true       # tileable
tex.as_normal_map = true  # for normal maps
tex.bump_strength = 2.0
```

## StandardMaterial3D Extended Properties

Beyond basic albedo, useful properties for richer materials:
- `normal_enabled = true` + `normal_texture` + `normal_scale = 2.0`
- `rim_enabled = true` + `rim_tint = 1.0` — silhouette glow
- `emission_enabled = true` + `emission_texture` — self-illumination
- `texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC`
