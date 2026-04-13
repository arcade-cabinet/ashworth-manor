extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var road_length: float = 18.0
@export var road_width: float = 2.76
@export var shoulder_width: float = 0.12
@export var verge_width: float = 0.22

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.55, scale.x),
		maxf(0.8, scale.y),
		maxf(0.55, scale.z)
	)
	scale = Vector3.ONE
	_build()


func _build() -> void:
	var road_material := EstateMaterialKit.carriage_road()
	var lane_material := EstateMaterialKit.carriage_road()
	var track_material := EstateMaterialKit.carriage_road_track()
	var earth_material := EstateMaterialKit.roadside_earth()
	lane_material.albedo_color = Color(0.35, 0.32, 0.28, 1.0)
	road_material.albedo_color = Color(0.25, 0.22, 0.19, 1.0)
	track_material.albedo_color = Color(0.15, 0.13, 0.11, 1.0)
	earth_material.albedo_color = Color(0.18, 0.15, 0.11, 1.0)

	var length := road_length * _baked_scale.z
	var road := road_width * _baked_scale.x
	var shoulder := shoulder_width * _baked_scale.x
	var verge := verge_width * _baked_scale.x
	var total_width := road + shoulder * 2.0 + verge * 2.0
	var earth_bed_width := maxf(total_width + 4.6 * _baked_scale.x, road + 4.4)

	add_child(ShapeKit.box(
		"Roadbed",
		Vector3(earth_bed_width, 0.08, length),
		Vector3(0.0, -0.075, 0.0),
		earth_material
	))
	add_child(ShapeKit.box(
		"LaneField",
		Vector3(road * 0.72, 0.02, length * 0.992),
		Vector3(0.0, -0.02, 0.0),
		lane_material
	))
	add_child(ShapeKit.box(
		"CenterStrip",
		Vector3(road * 0.16, 0.012, length * 0.964),
		Vector3(0.0, -0.012, 0.0),
		earth_material
	))
	add_child(ShapeKit.box(
		"CenterRidge",
		Vector3(road * 0.08, 0.006, length * 0.9),
		Vector3(0.0, -0.009, 0.0),
		earth_material
	))

	var rut_offset := road * 0.22
	for side in PackedFloat32Array([-1.0, 1.0]):
		add_child(ShapeKit.box(
			"WheelLane_%s" % ("L" if side < 0.0 else "R"),
			Vector3(road * 0.2, 0.02, length * 0.982),
			Vector3(rut_offset * side, -0.014, 0.0),
			lane_material
		))
		add_child(ShapeKit.box(
			"Track_%s" % ("L" if side < 0.0 else "R"),
			Vector3(road * 0.16, 0.014, length * 0.978),
			Vector3(rut_offset * side, -0.008, 0.0),
			road_material
		))
		add_child(ShapeKit.box(
			"TrackBlend_%s" % ("L" if side < 0.0 else "R"),
			Vector3(road * 0.22, 0.006, length * 0.95),
			Vector3((rut_offset + road * 0.02) * side, -0.012, 0.0),
			track_material
		))
		add_child(ShapeKit.box(
			"TrackMound_%s" % ("L" if side < 0.0 else "R"),
			Vector3(road * 0.06, 0.01, length * 0.84),
			Vector3((rut_offset + road * 0.12) * side, -0.006, 0.0),
			earth_material
		))

	for side in PackedFloat32Array([-1.0, 1.0]):
		add_child(ShapeKit.box(
			"Shoulder_%s" % ("L" if side < 0.0 else "R"),
			Vector3(shoulder, 0.018, length * 0.99),
			Vector3((road * 0.5 + shoulder * 0.5) * side, -0.026, 0.0),
			track_material
		))
		add_child(ShapeKit.box(
			"Verge_%s" % ("L" if side < 0.0 else "R"),
			Vector3(verge, 0.02, length * 0.98),
			Vector3((road * 0.5 + shoulder + verge * 0.5) * side, -0.06, 0.0),
			earth_material
		))
		add_child(ShapeKit.box(
			"EdgeShadow_%s" % ("L" if side < 0.0 else "R"),
			Vector3(0.08, 0.01, length * 0.96),
			Vector3((road * 0.5 + 0.02) * side, -0.016, 0.0),
			track_material
		))
		add_child(ShapeKit.box(
			"Gutter_%s" % ("L" if side < 0.0 else "R"),
			Vector3(0.16, 0.012, length * 0.88),
			Vector3((road * 0.5 + shoulder * 0.12) * side, -0.032, 0.0),
			track_material
		))

	for i in range(5):
		var t := float(i) / 4.0
		var streak_z := lerpf(-length * 0.34, length * 0.32, t)
		var streak_x := lerpf(-road * 0.14, road * 0.14, t)
		var streak := ShapeKit.box(
			"TrackWear_%d" % i,
			Vector3(road * 0.08, 0.004, length * 0.12),
			Vector3(streak_x, -0.004, streak_z),
			track_material
		)
		streak.rotation_degrees.y = lerpf(-10.0, 10.0, t)
		add_child(streak)

	for i in range(8):
		var t := float(i) / 7.0
		var patch_z := lerpf(-length * 0.4, length * 0.4, t)
		var patch_x := lerpf(-road * 0.18, road * 0.18, _baked_scale.x * 0.5 + t * 0.5)
		var patch := ShapeKit.box(
			"GravelPatch_%d" % i,
			Vector3(road * 0.1, 0.004, 0.3 + float(i % 3) * 0.08),
			Vector3(patch_x, -0.006, patch_z),
			lane_material if i % 2 == 0 else road_material
		)
		patch.rotation_degrees.y = lerpf(-18.0, 18.0, t)
		add_child(patch)

	for side in PackedFloat32Array([-1.0, 1.0]):
		for i in range(4):
			var t := float(i) / 3.0
			var bite_z := lerpf(-length * 0.3, length * 0.26, t)
			add_child(ShapeKit.box(
				"EdgeBreak_%s_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(road * 0.08, 0.006, 0.54),
				Vector3(side * (road * 0.38 + shoulder * 0.16), -0.004, bite_z),
				earth_material
			))

	for side in PackedFloat32Array([-1.0, 1.0]):
		for i in range(6):
			var t := 0.0 if i == 0 else float(i) / 5.0
			var clump_z := lerpf(-length * 0.38, length * 0.38, t)
			var clump_x := side * (road * 0.5 + shoulder * 0.54 + sin(t * PI * 2.2) * 0.05)
			add_child(ShapeKit.box(
				"ShoulderWear_%s_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(0.28, 0.01, 0.42),
				Vector3(clump_x, -0.028, clump_z),
				earth_material
			))
