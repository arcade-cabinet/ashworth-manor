class_name ConnectionAssembly
extends RefCounted
## Central assembly entrypoint for threshold mechanisms.

const ConnectionMechanism = preload("res://scripts/connection_mechanism.gd")
const EstateMaterialKit = preload("res://builders/estate_material_kit.gd")
const DEFAULT_HIDDEN_DOOR_CONCEALMENT_KIND := "procedural_secret_panel"
const DEFAULT_HIDDEN_DOOR_CONCEALMENT_SIZE := Vector3(1.02, 2.24, 0.06)

static func build(connection: Connection, room_height: float = 2.4, surface_overrides: Dictionary = {}) -> Node3D:
	var root: Node3D = null
	match connection.type:
		"door", "double_door", "heavy_door", "hidden_door", "gate":
			root = DoorBuilder.build(
				connection,
				String(surface_overrides.get("threshold", "")),
				_resolve_leaf_surface(connection, surface_overrides)
			)
		"stairs":
			root = StairsBuilder.build(
				connection,
				room_height,
				String(surface_overrides.get("stair_tread", "")),
				String(surface_overrides.get("stair_structure", "")),
				String(surface_overrides.get("stair_rail", ""))
			)
		"trapdoor":
			root = TrapdoorBuilder.build(
				connection,
				String(surface_overrides.get("threshold", "")),
				_resolve_leaf_surface(connection, surface_overrides)
			)
		"ladder":
			root = LadderBuilder.build(
				connection,
				room_height,
				String(surface_overrides.get("ladder_rail", "")),
				String(surface_overrides.get("ladder_rung", ""))
			)
		"path":
			root = _build_path_threshold(connection)
		_:
			root = DoorBuilder.build(
				connection,
				String(surface_overrides.get("threshold", "")),
				_resolve_leaf_surface(connection, surface_overrides)
			)

	_apply_threshold_metadata(root, connection)
	_attach_mechanism_controller(root, connection)
	if connection.type == "hidden_door":
		_attach_secret_cover(root, connection)
	return root


static func _apply_threshold_metadata(root: Node3D, connection: Connection) -> void:
	if root == null:
		return
	root.set_meta("connection", connection)
	root.set_meta("connection_id", connection.id)
	root.set_meta("target_room", connection.to_room)
	root.set_meta("conn_type", connection.type)
	root.set_meta("presentation_type", _resolve_presentation_type(connection))
	root.set_meta("mechanism_type", _resolve_mechanism_type(connection))
	root.set_meta("mechanism_state", _resolve_mechanism_state(connection))
	root.set_meta("reveal_state", _resolve_reveal_state(connection))
	root.set_meta("resolved_concealment_kind", _resolve_concealment_kind(connection))


static func _attach_mechanism_controller(root: Node3D, connection: Connection) -> void:
	if root == null:
		return
	var controller := ConnectionMechanism.new()
	controller.name = "ConnectionMechanism"
	controller.setup(connection)
	root.add_child(controller)


static func _build_path_threshold(connection: Connection) -> Node3D:
	var area := Area3D.new()
	area.name = "Path_%s" % connection.id
	area.collision_layer = 8
	area.collision_mask = 0
	area.add_to_group("connections")
	area.set_meta("connection_id", connection.id)
	area.set_meta("target_room", connection.to_room)
	area.set_meta("conn_type", connection.type)
	area.set_meta("locked", connection.locked)
	area.set_meta("key_id", connection.key_id)
	area.set_meta("required_state", connection.required_state)
	area.set_meta("blocked_text", connection.blocked_text)
	area.set_meta("declaration", connection)
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = connection.interaction_size if connection.interaction_size != Vector3.ZERO else Vector3(2.0, 2.0, 2.0)
	shape.shape = box
	area.add_child(shape)
	var root := Node3D.new()
	root.name = "PathAssembly_%s" % connection.id
	root.add_child(area)
	return root


static func _attach_secret_cover(root: Node3D, connection: Connection) -> void:
	var concealment := Node3D.new()
	concealment.name = "SecretPanelMask"
	concealment.position = Vector3(0, 0, 0.06)

	var panel := MeshInstance3D.new()
	panel.name = "Panel"
	var box := BoxMesh.new()
	box.size = DEFAULT_HIDDEN_DOOR_CONCEALMENT_SIZE
	panel.mesh = box
	panel.position.y = DEFAULT_HIDDEN_DOOR_CONCEALMENT_SIZE.y * 0.5
	var surface_ref := String(root.get_meta("resolved_threshold_surface", "recipe:surface/oak_header"))
	var material := EstateMaterialKit.build_surface_reference(surface_ref)
	if material != null:
		panel.set_surface_override_material(0, material)
	concealment.add_child(panel)
	root.add_child(concealment)


static func _resolve_concealment_kind(connection: Connection) -> String:
	return DEFAULT_HIDDEN_DOOR_CONCEALMENT_KIND


static func _resolve_presentation_type(connection: Connection) -> String:
	if not connection.presentation_type.is_empty():
		return connection.presentation_type
	match connection.type:
		"gate":
			return "gate_threshold"
		"hidden_door":
			return "secret_panel"
		"trapdoor":
			return "trapdoor_hatch"
		"ladder":
			return "ladder_drop"
		"stairs":
			return "stairs_threshold"
		"path":
			return "path_threshold"
		_:
			return "door_threshold"


static func _resolve_mechanism_type(connection: Connection) -> String:
	if not connection.mechanism_type.is_empty():
		return connection.mechanism_type
	match connection.type:
		"trapdoor":
			return "lift"
		"ladder":
			return "drop"
		"hidden_door":
			return "slide"
		"path":
			return "threshold"
		_:
			return "swing"


static func _resolve_mechanism_state(connection: Connection) -> String:
	if not connection.mechanism_state.is_empty():
		return connection.mechanism_state
	if connection.locked:
		return "locked"
	if connection.type == "hidden_door":
		return "concealed"
	return "idle"


static func _resolve_reveal_state(connection: Connection) -> String:
	if not connection.reveal_state.is_empty():
		return connection.reveal_state
	return "concealed" if connection.type == "hidden_door" else "visible"


static func _resolve_leaf_surface(connection: Connection, surface_overrides: Dictionary) -> String:
	if connection.type == "gate" and surface_overrides.has("gate_leaf"):
		return String(surface_overrides.get("gate_leaf", ""))
	return String(surface_overrides.get("door", ""))
