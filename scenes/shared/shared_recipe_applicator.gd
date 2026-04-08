extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")

@export var recipe_groups: Dictionary = {}


func _ready() -> void:
	for recipe_id in recipe_groups.keys():
		var material := EstateMaterialKit.build(String(recipe_id))
		if material == null:
			continue
		var targets: Variant = recipe_groups[recipe_id]
		if targets is PackedStringArray:
			for target in targets:
				_apply_material_to_target(String(target), material)
		elif targets is Array:
			for target in targets:
				_apply_material_to_target(String(target), material)
		elif targets is String:
			_apply_material_to_target(String(targets), material)


func _apply_material_to_target(target_path: String, material: Material) -> void:
	if target_path.is_empty():
		return
	var target := get_node_or_null(NodePath(target_path))
	if target is MeshInstance3D:
		(target as MeshInstance3D).material_override = material
