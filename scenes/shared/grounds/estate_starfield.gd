extends Node3D

const ShapeKit = preload("res://builders/shape_kit.gd")

@export var span_width: float = 54.0
@export var span_depth: float = 72.0
@export var min_height: float = 26.0
@export var max_height: float = 44.0
@export var star_count: int = 36


func _ready() -> void:
	if get_child_count() > 0:
		return
	_build()


func _build() -> void:
	for i in range(star_count):
		var major := i % 9 == 0
		var radius := 0.028 if major else 0.014
		var x := lerpf(-span_width * 0.42, span_width * 0.42, _hash01(i, 1))
		var y := lerpf(min_height, max_height, _hash01(i, 2))
		var z := lerpf(-span_depth * 0.34, span_depth * 0.42, _hash01(i, 3))
		var star := ShapeKit.sphere("Star_%d" % i, radius, Vector3(x, y, z), _make_star_material(major, _hash01(i, 4)))
		star.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(star)

	var hero_positions := [
		Vector3(-12.0, 36.0, 14.0),
		Vector3(-4.0, 39.0, -9.0),
		Vector3(8.5, 35.0, 10.5),
		Vector3(16.0, 33.5, -12.0),
	]
	for i in range(hero_positions.size()):
		var hero := ShapeKit.sphere("HeroStar_%d" % i, 0.034, hero_positions[i], _make_star_material(true, 0.92))
		hero.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(hero)


func _make_star_material(major: bool, variance: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	var tint := Color(0.92 + variance * 0.05, 0.94 + variance * 0.04, 1.0, 1.0)
	material.albedo_color = tint
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.emission_enabled = true
	material.emission = tint
	material.emission_energy_multiplier = 1.0 if major else 0.68
	material.roughness = 0.0
	material.metallic = 0.0
	return material


func _hash01(index: int, salt: int) -> float:
	return fposmod(sin(float(index * 97 + salt * 37)) * 43758.5453, 1.0)
