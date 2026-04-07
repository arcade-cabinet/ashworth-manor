extends SceneTree

const ASSETS := [
	"res://assets/shared/structure/door.glb",
	"res://assets/shared/structure/door1.glb",
	"res://assets/shared/structure/doorway0.glb",
	"res://assets/shared/structure/doorway1.glb",
	"res://assets/shared/structure/doorway7.glb",
	"res://assets/shared/structure/window_clean.glb",
	"res://assets/shared/structure/window_wall0.glb",
	"res://assets/shared/structure/window_wall7.glb",
	"res://assets/shared/structure/wall_0.glb",
	"res://assets/shared/structure/wall_7.glb",
	"res://assets/shared/structure/floor0.glb",
	"res://assets/shared/structure/cieling0.glb",
]


func _initialize() -> void:
	for path in ASSETS:
		_print_asset_bounds(path)
	quit()


func _print_asset_bounds(path: String) -> void:
	if not ResourceLoader.exists(path):
		print("MISSING %s" % path)
		return
	var scene := load(path) as PackedScene
	if scene == null:
		print("FAILED %s" % path)
		return
	var inst := scene.instantiate()
	var bounds := _collect_bounds(inst)
	if bounds == null:
		print("EMPTY %s" % path)
	else:
		print("%s => pos=%s size=%s" % [path, bounds.position, bounds.size])
	inst.queue_free()


func _collect_bounds(node: Node) -> AABB:
	var has_bounds := false
	var merged := AABB()
	if node is VisualInstance3D:
		var visual := node as VisualInstance3D
		var aabb := visual.get_aabb()
		if aabb.size.length_squared() > 0.0:
			merged = aabb
			has_bounds = true
	for child in node.get_children():
		var child_bounds := _collect_bounds(child)
		if child_bounds != null:
			merged = child_bounds if not has_bounds else merged.merge(child_bounds)
			has_bounds = true
	return merged if has_bounds else null
