extends Node3D

const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const ShapeKit = preload("res://builders/shape_kit.gd")

@export var span_length: float = 28.0
@export var road_width: float = 4.6

var _baked_scale := Vector3.ONE


func _ready() -> void:
	if get_child_count() > 0:
		return
	_baked_scale = Vector3(
		maxf(0.8, scale.x),
		maxf(0.8, scale.y),
		maxf(0.8, scale.z)
	)
	scale = Vector3.ONE
	_build()


func _build() -> void:
	var iron := EstateMaterialKit.wrought_iron()
	var brass := EstateMaterialKit.brass()
	var earth := EstateMaterialKit.roadside_earth()
	var branch := EstateMaterialKit.branch_dark()
	var hedge_dark := EstateMaterialKit.hedge(Color(0.38, 0.46, 0.33, 1.0), Vector3(2.8, 2.8, 6.0), false)
	var hedge_mid := EstateMaterialKit.hedge(Color(0.5, 0.58, 0.42, 1.0), Vector3(2.6, 2.6, 5.4), true)
	var village_body := EstateMaterialKit.brick_masonry()
	var village_roof := EstateMaterialKit.oak_header()
	var masonry_cap := EstateMaterialKit.masonry_cap()
	village_body.uv1_scale = Vector3(3.0, 2.0, 3.0)
	village_roof.uv1_scale = Vector3(2.4, 2.4, 2.4)
	masonry_cap.uv1_scale = Vector3(2.2, 2.2, 2.2)
	village_body.albedo_color = Color(0.34, 0.25, 0.22, 1.0)
	village_roof.albedo_color = Color(0.1, 0.07, 0.06, 1.0)
	masonry_cap.albedo_color = Color(0.37, 0.31, 0.29, 1.0)
	var window_glow := EstateMaterialKit.window_glow()
	var silhouette_wall := EstateMaterialKit.brick_masonry()
	silhouette_wall.uv1_scale = Vector3(3.4, 2.2, 3.4)
	silhouette_wall.albedo_color = Color(0.14, 0.1, 0.11, 1.0)

	var road_scene := load("res://scenes/shared/grounds/estate_carriage_road.tscn")
	if road_scene is PackedScene:
		_add_road_segment(road_scene, "VillageRoadNear", Vector3(0.0, 0.0, 0.0), 0.0, Vector3(0.92, 1.0, maxf(1.45, span_length / 18.0) * _baked_scale.z), 4.1)
		_add_road_segment(road_scene, "VillageRoadMid", Vector3(-0.95, 0.0, span_length * 0.58), -8.0, Vector3(0.88, 1.0, 0.9 * _baked_scale.z), 3.8)
		_add_road_segment(road_scene, "VillageRoadFar", Vector3(-2.35, 0.0, span_length * 1.02), -14.0, Vector3(0.78, 1.0, 0.76 * _baked_scale.z), 3.5)
		_add_road_segment(road_scene, "VillageRoadHorizon", Vector3(-4.1, 0.0, span_length * 1.38), -20.0, Vector3(0.68, 1.0, 0.58 * _baked_scale.z), 3.15)

	add_child(ShapeKit.box(
		"LeftBank",
		Vector3(4.6 * _baked_scale.x, 0.18 * _baked_scale.y, span_length * 1.06 * _baked_scale.z),
		Vector3(-(road_width * 0.5 + 2.8) * _baked_scale.x, 0.04, 0.0),
		earth
	))
	add_child(ShapeKit.box(
		"RightBank",
		Vector3(4.6 * _baked_scale.x, 0.18 * _baked_scale.y, span_length * 1.06 * _baked_scale.z),
		Vector3((road_width * 0.5 + 2.8) * _baked_scale.x, 0.04, 0.0),
		earth
	))

	for side in PackedFloat32Array([-1.0, 1.0]):
		for i in range(3):
			var t := float(i) / 2.0
			var z := lerpf(-span_length * 0.02, span_length * 0.38, t)
			var wall_x := side * lerpf(4.4, 5.1, t) * _baked_scale.x
			add_child(ShapeKit.box(
				"%sGardenWall_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(1.8 + t * 0.5, 0.66, 0.22),
				Vector3(wall_x, 0.33, z),
				village_body
			))
			add_child(ShapeKit.box(
				"%sGardenWallCap_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(1.92 + t * 0.5, 0.08, 0.28),
				Vector3(wall_x, 0.7, z),
				masonry_cap
			))

	for side in PackedFloat32Array([-1.0, 1.0]):
		for i in range(8):
			var z := lerpf(-span_length * 0.16, span_length * 0.48, float(i) / 7.0)
			var x := side * lerpf(5.8, 7.4, float(i % 4) / 3.0) * _baked_scale.x
			var mound := ShapeKit.sphere(
				"%sHedgeMound_%d" % ["L" if side < 0.0 else "R", i],
				0.5,
				Vector3(x, 0.72, z),
				hedge_dark if i % 2 == 0 else hedge_mid
			)
			mound.scale = Vector3(1.9 * _baked_scale.x, 1.18 * _baked_scale.y, 1.45 * _baked_scale.z)
			add_child(mound)

		for i in range(3):
			var z := lerpf(-span_length * 0.04, span_length * 0.34, float(i) / 2.0)
			var x := side * lerpf(7.2, 8.4, float(i) / 2.0) * _baked_scale.x
			var trunk_height := lerpf(3.2, 4.8, float(i) / 2.0) * _baked_scale.y
			add_child(ShapeKit.cylinder(
				"%sPoplarTrunk_%d" % ["L" if side < 0.0 else "R", i],
				0.075 * _baked_scale.x,
				trunk_height,
				Vector3(x, trunk_height * 0.5, z),
				branch,
				8
			))
			var lower_crown := ShapeKit.sphere(
				"%sPoplarCrownLower_%d" % ["L" if side < 0.0 else "R", i],
				0.5,
				Vector3(x + side * 0.06, trunk_height * 0.92, z),
				hedge_dark
			)
			lower_crown.scale = Vector3(0.78 * _baked_scale.x, 1.48 * _baked_scale.y, 0.78 * _baked_scale.z)
			add_child(lower_crown)
			var upper_crown := ShapeKit.sphere(
				"%sPoplarCrownUpper_%d" % ["L" if side < 0.0 else "R", i],
				0.5,
				Vector3(x + side * 0.05, trunk_height * 1.18, z),
				hedge_mid
			)
			upper_crown.scale = Vector3(0.66 * _baked_scale.x, 1.2 * _baked_scale.y, 0.66 * _baked_scale.z)
			add_child(upper_crown)

	for side in PackedFloat32Array([-1.0, 1.0]):
		for i in range(5):
			var z := lerpf(-span_length * 0.18, span_length * 0.42, float(i) / 4.0)
			var x := side * (road_width * 0.5 + 1.0 + float(i % 2) * 0.35) * _baked_scale.x
			add_child(ShapeKit.box(
				"%sFencePost_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(0.08, 0.78, 0.08),
				Vector3(x, 0.39, z),
				branch
			))
		for i in range(4):
			var rail_z := lerpf(-span_length * 0.08, span_length * 0.28, float(i) / 3.0)
			add_child(ShapeKit.box(
				"%sRail_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(0.04, 0.04, 1.35),
				Vector3(side * (road_width * 0.5 + 1.2), 0.56, rail_z),
				branch
			))

	add_child(ShapeKit.cylinder("VillageLampPost", 0.06, 2.5, Vector3(-1.0, 1.25, span_length * 0.16), iron, 8))
	add_child(ShapeKit.box("VillageLampHead", Vector3(0.2, 0.16, 0.2), Vector3(-1.0, 2.34, span_length * 0.16), iron))
	var lamp_glow := ShapeKit.sphere("VillageLampGlow", 0.09, Vector3(-1.0, 2.28, span_length * 0.16), brass)
	var lamp_mat := lamp_glow.get_active_material(0)
	if lamp_mat is StandardMaterial3D:
		(lamp_mat as StandardMaterial3D).emission_enabled = true
		(lamp_mat as StandardMaterial3D).emission = Color(1.0, 0.86, 0.6, 1.0)
		(lamp_mat as StandardMaterial3D).emission_energy_multiplier = 2.8
	add_child(lamp_glow)

	add_child(ShapeKit.cylinder("VillageLampPostFar", 0.05, 2.1, Vector3(1.4, 1.05, span_length * 0.72), iron, 8))
	add_child(ShapeKit.box("VillageLampHeadFar", Vector3(0.16, 0.13, 0.16), Vector3(1.4, 1.98, span_length * 0.72), iron))
	var lamp_glow_far := ShapeKit.sphere("VillageLampGlowFar", 0.07, Vector3(1.4, 1.94, span_length * 0.72), brass)
	var lamp_far_mat := lamp_glow_far.get_active_material(0)
	if lamp_far_mat is StandardMaterial3D:
		(lamp_far_mat as StandardMaterial3D).emission_enabled = true
		(lamp_far_mat as StandardMaterial3D).emission = Color(1.0, 0.84, 0.56, 1.0)
		(lamp_far_mat as StandardMaterial3D).emission_energy_multiplier = 2.1
	add_child(lamp_glow_far)

	for side in PackedFloat32Array([-1.0, 1.0]):
		var village_origin := Vector3(side * 4.4, 0.0, span_length * 0.42)
		for i in range(5):
			var body_w := lerpf(1.28, 2.08, float(i % 3) / 2.0)
			var body_h := lerpf(1.2, 2.08, float((i + 1) % 3) / 2.0)
			var body_d := lerpf(0.86, 1.22, float(i % 2))
			var x := village_origin.x + side * float(i) * 1.18
			var z := village_origin.z + sin(float(i) * 0.8) * 0.34
			_add_village_house(
				"VillageHouse_%s_%d" % ["L" if side < 0.0 else "R", i],
				Vector3(x, 0.0, z),
				Vector3(body_w, body_h, body_d),
				village_body,
				village_roof,
				window_glow,
				(7.0 if i % 2 == 0 else -7.0) * side
			)

	_add_village_house(
		"GateHouseLeft",
		Vector3(-4.9, 0.0, span_length * 0.02),
		Vector3(2.7, 1.74, 1.28),
		village_body,
		village_roof,
		window_glow,
		4.0
	)
	_add_village_house(
		"GateHouseRight",
		Vector3(5.0, 0.0, span_length * 0.05),
		Vector3(2.56, 1.68, 1.24),
		village_body,
		village_roof,
		window_glow,
		-4.0
	)
	_add_lane_lamp("GateLampLeft", Vector3(-3.8, 0.0, span_length * 0.06), 2.22, iron, brass, 1.15)
	_add_lane_lamp("GateLampRight", Vector3(3.9, 0.0, span_length * 0.09), 2.0, iron, brass, 1.0)
	_add_lane_lamp("VillageLaneMidLeft", Vector3(-2.4, 0.0, span_length * 0.34), 2.08, iron, brass, 0.92)
	_add_lane_lamp("VillageLaneMidRight", Vector3(2.6, 0.0, span_length * 0.46), 1.94, iron, brass, 0.82)
	_add_lane_lamp("VillageLaneFarLeft", Vector3(-1.75, 0.0, span_length * 0.72), 1.84, iron, brass, 0.68)
	_add_lane_lamp("VillageLaneFarRight", Vector3(1.55, 0.0, span_length * 0.92), 1.7, iron, brass, 0.6)
	_add_lane_lamp("VillageLaneHorizon", Vector3(-0.55, 0.0, span_length * 1.18), 1.56, iron, brass, 0.48)
	_add_lane_lamp("VillageLaneHorizonFarLeft", Vector3(-2.8, 0.0, span_length * 1.26), 1.42, iron, brass, 0.34)
	_add_lane_lamp("VillageLaneHorizonFarRight", Vector3(2.15, 0.0, span_length * 1.3), 1.36, iron, brass, 0.3)

	_add_village_house(
		"LaneHouseLeft",
		Vector3(-6.2, 0.0, span_length * 0.18),
		Vector3(2.7, 1.86, 1.38),
		village_body,
		village_roof,
		window_glow,
		4.0
	)
	_add_village_house(
		"LaneHouseRight",
		Vector3(6.5, 0.0, span_length * 0.24),
		Vector3(2.3, 1.62, 1.22),
		village_body,
		village_roof,
		window_glow,
		-4.0
	)
	_add_village_house(
		"NearHouseLeft",
		Vector3(-7.2, 0.0, span_length * 0.05),
		Vector3(3.1, 2.1, 1.58),
		village_body,
		village_roof,
		window_glow,
		5.0
	)
	_add_village_house(
		"NearHouseRight",
		Vector3(7.2, 0.0, span_length * 0.08),
		Vector3(2.7, 1.9, 1.42),
		village_body,
		village_roof,
		window_glow,
		-5.0
	)
	_add_rowhouse_terrace(
		"LeftTerrace",
		Vector3(-8.8, 0.0, span_length * 0.28),
		4,
		village_body,
		village_roof,
		window_glow,
		1.0
	)
	_add_rowhouse_terrace(
		"RightTerrace",
		Vector3(8.7, 0.0, span_length * 0.32),
		4,
		village_body,
		village_roof,
		window_glow,
		-1.0
	)
	_add_rowhouse_terrace(
		"FarLeftTerrace",
		Vector3(-7.2, 0.0, span_length * 0.74),
		3,
		village_body,
		village_roof,
		window_glow,
		1.0
	)
	_add_rowhouse_terrace(
		"FarRightTerrace",
		Vector3(7.0, 0.0, span_length * 0.82),
		3,
		village_body,
		village_roof,
		window_glow,
		-1.0
	)
	_add_distant_terrace_silhouette(
		"LeftHorizonSilhouette",
		Vector3(-8.8, 0.0, span_length * 1.04),
		5,
		silhouette_wall,
		village_roof
	)
	_add_distant_terrace_silhouette(
		"RightHorizonSilhouette",
		Vector3(9.2, 0.0, span_length * 1.12),
		5,
		silhouette_wall,
		village_roof
	)
	_add_distant_terrace_silhouette(
		"CenterHorizonSilhouette",
		Vector3(-3.0, 0.0, span_length * 1.18),
		4,
		silhouette_wall,
		village_roof
	)
	_add_spire(
		"DistantSpire",
		Vector3(-4.1, 0.0, span_length * 0.92),
		branch,
		village_roof,
		window_glow
	)
	_add_fog_bank("RoadFogNear", Vector3(0.0, 0.96, span_length * 0.82), Vector2(14.4, 2.2), Color(0.17, 0.17, 0.2, 0.12), 0.12)
	_add_fog_bank("RoadFogFar", Vector3(-0.25, 0.96, span_length * 1.02), Vector2(26.0, 2.6), Color(0.16, 0.16, 0.2, 0.14), 0.12, 0.0)
	_add_fog_bank("RoadDistanceVeil", Vector3(0.0, 1.06, span_length * 1.18), Vector2(28.0, 3.4), Color(0.14, 0.14, 0.18, 0.14), 0.1)
	_add_fog_bank("RoadHorizonBand", Vector3(0.0, 0.78, span_length * 1.26), Vector2(38.0, 1.8), Color(0.12, 0.11, 0.16, 0.12), 0.1)
	_add_fog_bank("RoadHorizonGlow", Vector3(0.0, 1.18, span_length * 1.26), Vector2(38.0, 2.6), Color(0.16, 0.14, 0.17, 0.14), 0.15)
	_add_fog_bank("RoadLeftMist", Vector3(-7.8, 0.9, span_length * 0.72), Vector2(10.0, 2.6), Color(0.15, 0.15, 0.18, 0.11), 0.1, 12.0)
	_add_fog_bank("RoadRightMist", Vector3(7.6, 0.92, span_length * 0.78), Vector2(10.0, 2.6), Color(0.15, 0.15, 0.18, 0.11), 0.1, -12.0)

func _add_road_segment(
	scene: PackedScene,
	node_name: String,
	position: Vector3,
	yaw: float,
	scale_value: Vector3,
	road_width_value: float
) -> void:
	var road := scene.instantiate() as Node3D
	road.name = node_name
	road.set("road_width", road_width_value)
	road.set("shoulder_width", 0.16)
	road.set("verge_width", 0.08)
	road.position = position
	road.rotation_degrees.y = yaw
	road.scale = scale_value
	add_child(road)


func _add_village_house(
	node_name: String,
	base_position: Vector3,
	body_size: Vector3,
	body_material: Material,
	roof_material: Material,
	window_material: Material,
	roof_tilt: float
) -> void:
	var body := (body_material as StandardMaterial3D).duplicate()
	var roof_mat := (roof_material as StandardMaterial3D).duplicate()
	var trim := EstateMaterialKit.masonry_cap()
	var door_material := EstateMaterialKit.oak_dark()
	body.albedo_color = body.albedo_color.lerp(Color(0.26, 0.2, 0.18, 1.0), 0.18 + float(abs(node_name.hash()) % 3) * 0.06)
	roof_mat.albedo_color = roof_mat.albedo_color.lerp(Color(0.08, 0.06, 0.06, 1.0), 0.24)
	add_child(ShapeKit.box(
		"%sBody" % node_name,
		body_size,
		base_position + Vector3(0.0, body_size.y * 0.5, 0.0),
		body
	))
	add_child(ShapeKit.box(
		"%sStringCourse" % node_name,
		Vector3(body_size.x * 1.02, 0.08, body_size.z * 1.02),
		base_position + Vector3(0.0, body_size.y * 0.56, 0.0),
		trim
	))
	_add_pitched_roof(
		"%sRoof" % node_name,
		base_position + Vector3(0.0, body_size.y, 0.0),
		body_size.x * 1.1,
		body_size.z * 1.1,
		0.26,
		roof_mat,
		trim,
		roof_tilt
	)
	add_child(ShapeKit.box(
		"%sChimney" % node_name,
		Vector3(0.18, 0.58, 0.18),
		base_position + Vector3(body_size.x * 0.18, body_size.y + 0.3, 0.0),
		body
	))
	add_child(ShapeKit.box(
		"%sGardenWallLeft" % node_name,
		Vector3(body_size.x * 0.36, 0.7, 0.22),
		base_position + Vector3(-body_size.x * 0.29, 0.35, body_size.z * 0.72),
		body
	))
	add_child(ShapeKit.box(
		"%sGardenWallRight" % node_name,
		Vector3(body_size.x * 0.36, 0.7, 0.22),
		base_position + Vector3(body_size.x * 0.29, 0.35, body_size.z * 0.72),
		body
	))
	add_child(ShapeKit.box(
		"%sGardenWallCapLeft" % node_name,
		Vector3(body_size.x * 0.4, 0.08, 0.28),
		base_position + Vector3(-body_size.x * 0.29, 0.74, body_size.z * 0.72),
		trim
	))
	add_child(ShapeKit.box(
		"%sGardenWallCapRight" % node_name,
		Vector3(body_size.x * 0.4, 0.08, 0.28),
		base_position + Vector3(body_size.x * 0.29, 0.74, body_size.z * 0.72),
		trim
	))
	add_child(ShapeKit.box(
		"%sGatePostLeft" % node_name,
		Vector3(0.08, 0.82, 0.08),
		base_position + Vector3(-0.28, 0.41, body_size.z * 0.72),
		trim
	))
	add_child(ShapeKit.box(
		"%sGatePostRight" % node_name,
		Vector3(0.08, 0.82, 0.08),
		base_position + Vector3(0.28, 0.41, body_size.z * 0.72),
		trim
	))
	add_child(ShapeKit.box(
		"%sDoor" % node_name,
		Vector3(0.28, 0.64, 0.06),
		base_position + Vector3(0.0, 0.32, body_size.z * 0.52),
		door_material
	))
	add_child(ShapeKit.box(
		"%sDoorLintel" % node_name,
		Vector3(0.36, 0.06, 0.08),
		base_position + Vector3(0.0, 0.68, body_size.z * 0.53),
		trim
	))
	add_child(ShapeKit.box(
		"%sStoop" % node_name,
		Vector3(0.54, 0.08, 0.24),
		base_position + Vector3(0.0, 0.04, body_size.z * 0.66),
		trim
	))
	for w in range(2):
		add_child(ShapeKit.box(
			"%sWindow_%d" % [node_name, w],
			Vector3(0.13, 0.18, 0.012),
			base_position + Vector3((float(w) - 0.5) * 0.34, body_size.y * 0.54, body_size.z * 0.52),
			window_material
		))
		add_child(ShapeKit.box(
			"%sWindowLintel_%d" % [node_name, w],
			Vector3(0.18, 0.04, 0.04),
			base_position + Vector3((float(w) - 0.5) * 0.34, body_size.y * 0.66, body_size.z * 0.53),
			trim
		))


func _add_pitched_roof(
	node_name: String,
	base_position: Vector3,
	width: float,
	depth: float,
	rise: float,
	roof_material: Material,
	ridge_material: Material,
	tilt_bias: float
) -> void:
	var slab_thickness: float = 0.12
	var half_width: float = width * 0.5
	var slope_angle: float = 18.0 + absf(tilt_bias) * 0.5
	for side in PackedFloat32Array([-1.0, 1.0]):
		var slab := ShapeKit.box(
			"%sSlope_%s" % [node_name, "L" if side < 0.0 else "R"],
			Vector3(width * 0.58, slab_thickness, depth),
			base_position + Vector3(side * half_width * 0.24, rise * 0.58, 0.0),
			roof_material
		)
		slab.rotation_degrees = Vector3(0.0, 0.0, (slope_angle + tilt_bias * 0.35) * -side)
		add_child(slab)
	add_child(ShapeKit.box(
		"%sRidge" % node_name,
		Vector3(width * 0.72, 0.06, 0.12),
		base_position + Vector3(0.0, rise + slab_thickness * 0.46, 0.0),
		ridge_material
	))


func _add_lane_lamp(
	node_name: String,
	base_position: Vector3,
	height: float,
	post_material: Material,
	glow_material: Material,
	glow_scale: float = 1.0
) -> void:
	add_child(ShapeKit.cylinder(
		"%sPost" % node_name,
		0.045,
		height,
		base_position + Vector3(0.0, height * 0.5, 0.0),
		post_material,
		8
	))
	add_child(ShapeKit.box(
		"%sHead" % node_name,
		Vector3(0.16, 0.12, 0.16),
		base_position + Vector3(0.0, height - 0.12, 0.0),
		post_material
	))
	var glow := ShapeKit.sphere(
		"%sGlow" % node_name,
		0.07 * glow_scale,
		base_position + Vector3(0.0, height - 0.15, 0.0),
		glow_material
	)
	var glow_mat := glow.get_active_material(0)
	if glow_mat is StandardMaterial3D:
		(glow_mat as StandardMaterial3D).emission_enabled = true
		(glow_mat as StandardMaterial3D).emission = Color(1.0, 0.84, 0.58, 1.0)
		(glow_mat as StandardMaterial3D).emission_energy_multiplier = 2.6 * glow_scale
	add_child(glow)


func _add_fog_bank(
	node_name: String,
	position: Vector3,
	size: Vector2,
	color: Color,
	emission_energy: float,
	yaw: float = 0.0
) -> void:
	var fog := MeshInstance3D.new()
	fog.name = node_name
	var mesh := QuadMesh.new()
	mesh.size = size
	fog.mesh = mesh
	fog.position = position
	fog.rotation_degrees = Vector3(0.0, yaw, 0.0)
	var material := EstateMaterialKit.fog_glow(color, emission_energy)
	fog.set_surface_override_material(0, material)
	add_child(fog)


func _add_spire(
	node_name: String,
	base_position: Vector3,
	body_material: Material,
	roof_material: Material,
	window_material: Material
) -> void:
	add_child(ShapeKit.box(
		"%sBase" % node_name,
		Vector3(1.2, 3.0, 1.2),
		base_position + Vector3(0.0, 1.5, 0.0),
		body_material
	))
	add_child(ShapeKit.box(
		"%sStage" % node_name,
		Vector3(0.86, 1.6, 0.86),
		base_position + Vector3(0.0, 3.8, 0.0),
		body_material
	))
	var roof := ShapeKit.box(
		"%sRoof" % node_name,
		Vector3(0.28, 2.4, 0.28),
		base_position + Vector3(0.0, 5.7, 0.0),
		roof_material
	)
	roof.rotation_degrees.z = 45.0
	add_child(roof)
	add_child(ShapeKit.box(
		"%sWindow" % node_name,
		Vector3(0.12, 0.26, 0.012),
		base_position + Vector3(0.0, 3.72, 0.62),
		window_material
	))


func _add_rowhouse_terrace(
	node_name: String,
	base_position: Vector3,
	house_count: int,
	body_material: Material,
	roof_material: Material,
	window_material: Material,
	facing: float
) -> void:
	for i in range(house_count):
		var step := float(i)
		var offset_x := facing * step * 1.6
		var width := 1.46 + float(i % 2) * 0.2
		var height := 1.95 + float((i + 1) % 2) * 0.18
		var depth := 1.22
		var origin := base_position + Vector3(offset_x, 0.0, sin(step * 0.6) * 0.18)
		var terrace_body := (body_material as StandardMaterial3D).duplicate()
		var terrace_roof := (roof_material as StandardMaterial3D).duplicate()
		var trim := EstateMaterialKit.masonry_cap()
		terrace_body.albedo_color = terrace_body.albedo_color.lerp(Color(0.28, 0.24, 0.28, 1.0), 0.18 + float(i % 3) * 0.06)
		add_child(ShapeKit.box(
			"%sBody_%d" % [node_name, i],
			Vector3(width, height, depth),
			origin + Vector3(0.0, height * 0.5, 0.0),
			terrace_body
		))
		_add_pitched_roof(
			"%sRoof_%d" % [node_name, i],
			origin + Vector3(0.0, height, 0.0),
			width * 1.06,
			depth * 1.08,
			0.24,
			terrace_roof,
			trim,
			facing * (3.0 if i % 2 == 0 else 5.0)
		)
		add_child(ShapeKit.box(
			"%sChimney_%d" % [node_name, i],
			Vector3(0.16, 0.54, 0.16),
			origin + Vector3(facing * width * 0.22, height + 0.26, 0.0),
			terrace_body
		))
		add_child(ShapeKit.box(
			"%sDoor_%d" % [node_name, i],
			Vector3(0.24, 0.58, 0.05),
			origin + Vector3(0.0, 0.29, depth * 0.52),
			EstateMaterialKit.oak_dark()
		))
		add_child(ShapeKit.box(
			"%sDoorLintel_%d" % [node_name, i],
			Vector3(0.32, 0.04, 0.06),
			origin + Vector3(0.0, 0.62, depth * 0.53),
			trim
		))
		for w in range(2):
			add_child(ShapeKit.box(
				"%sWindow_%d_%d" % [node_name, i, w],
				Vector3(0.11, 0.16, 0.012),
				origin + Vector3((float(w) - 0.5) * 0.32, height * 0.56, depth * 0.52),
				window_material
			))
			add_child(ShapeKit.box(
				"%sWindowLintel_%d_%d" % [node_name, i, w],
				Vector3(0.16, 0.04, 0.04),
				origin + Vector3((float(w) - 0.5) * 0.32, height * 0.67, depth * 0.53),
				trim
			))


func _add_distant_terrace_silhouette(
	node_name: String,
	base_position: Vector3,
	segment_count: int,
	body_material: Material,
	roof_material: Material
) -> void:
	for i in range(segment_count):
		var step := float(i)
		var width := 1.8 + float(i % 2) * 0.3
		var height := 1.5 + float((i + 1) % 3) * 0.18
		var depth := 0.92
		var x := base_position.x + step * 1.28
		var z := base_position.z + sin(step * 0.45) * 0.14
		add_child(ShapeKit.box(
			"%sBody_%d" % [node_name, i],
			Vector3(width, height, depth),
			Vector3(x, height * 0.5, z),
			body_material
		))
		_add_pitched_roof(
			"%sRoof_%d" % [node_name, i],
			Vector3(x, height, z),
			width * 1.04,
			depth * 1.02,
			0.16,
			roof_material,
			roof_material,
			2.0 if i % 2 == 0 else -2.0
		)
