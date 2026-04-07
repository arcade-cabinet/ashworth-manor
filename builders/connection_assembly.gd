class_name ConnectionAssembly
extends RefCounted
## Central assembly entrypoint for threshold mechanisms.

const ConnectionMechanism = preload("res://scripts/connection_mechanism.gd")

static func build(connection: Connection, room_height: float = 2.4) -> Node3D:
	var root: Node3D = null
	match connection.type:
		"door", "double_door", "heavy_door", "hidden_door", "gate":
			root = DoorBuilder.build(connection)
		"stairs":
			root = StairsBuilder.build(connection, room_height)
		"trapdoor":
			root = TrapdoorBuilder.build(connection)
		"ladder":
			root = LadderBuilder.build(connection, room_height)
		"path":
			root = _build_path_threshold(connection)
		_:
			root = DoorBuilder.build(connection)

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
	root.set_meta("visible_model", connection.visible_model)


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
	var cover_model := connection.concealment_model
	if cover_model.is_empty():
		cover_model = "res://assets/shared/structure/wall_7.glb"
	if not ResourceLoader.exists(cover_model):
		return
	var scene: PackedScene = load(cover_model)
	if scene == null:
		return
	var inst := scene.instantiate()
	inst.name = "SecretPanelMask"
	if inst is Node3D:
		(inst as Node3D).position = Vector3(0, 0, 0.06)
		(inst as Node3D).scale = Vector3.ONE * 0.9
	root.add_child(inst)


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
