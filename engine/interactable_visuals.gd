class_name InteractableVisuals
extends RefCounted

const StateMachineScript = preload("res://engine/state_machine.gd")
const STATE_SCHEMA = preload("res://declarations/state_schema.tres")
const SHARED_VISUAL_KIND_PATHS := {
	"kitchen_bucket_still": "res://scenes/shared/kitchen/kitchen_bucket_still.tscn",
	"kitchen_bucket_rippled": "res://scenes/shared/kitchen/kitchen_bucket_rippled.tscn",
	"front_gate_valise_closed": "res://scenes/shared/front_gate/front_gate_valise_closed.tscn",
	"front_gate_valise_open": "res://scenes/shared/front_gate/front_gate_valise_open.tscn",
	"front_gate_lamp_lit": "res://assets/grounds/front_gate/lamp_mx_1_b_on.glb",
	"front_gate_bench": "res://assets/grounds/front_gate/bench_mx_1.glb",
	"garden_fountain": "res://assets/grounds/garden/fountain01_round.glb",
	"garden_gazebo": "res://assets/grounds/garden/gazebo.glb",
	"greenhouse_lily_pot_intact": "res://scenes/shared/greenhouse/greenhouse_lily_pot_intact.tscn",
	"greenhouse_lily_pot_disturbed": "res://scenes/shared/greenhouse/greenhouse_lily_pot_disturbed.tscn",
	"music_box_display": "res://scenes/shared/items/music_box_display.tscn",
	"parlor_tea_set": "res://scenes/shared/parlor/parlor_tea_service_set.tscn",
	"parlor_tea_disturbed": "res://scenes/shared/parlor/parlor_tea_service_disturbed.tscn",
	"chapel_font_still": "res://scenes/shared/chapel/baptismal_font_still.tscn",
	"chapel_font_disturbed": "res://scenes/shared/chapel/baptismal_font_disturbed.tscn",
	"chapel_font_searched": "res://scenes/shared/chapel/baptismal_font_searched.tscn",
	"dining_wine_still": "res://scenes/shared/dining_room/dining_wine_glass_still.tscn",
	"dining_wine_agitated": "res://scenes/shared/dining_room/dining_wine_glass_agitated.tscn",
}


static func ensure_visual(area: Area3D) -> void:
	if area == null:
		return
	var decl = area.get_meta("declaration") if area.has_meta("declaration") else null
	if decl is not InteractableDecl:
		return
	var visual_root := area.get_node_or_null("VisualRoot") as Node3D
	if visual_root == null:
		visual_root = Node3D.new()
		visual_root.name = "VisualRoot"
		area.add_child(visual_root)

	var visual_state := _resolve_visual_state(decl)
	var visual_path := _resolve_visual_path(decl, visual_state)
	var current_state := String(area.get_meta("visual_state")) if area.has_meta("visual_state") else ""
	var current_path := String(area.get_meta("visual_path")) if area.has_meta("visual_path") else ""
	if current_state == visual_state and current_path == visual_path and visual_root.get_child_count() > 0:
		return

	for child in visual_root.get_children():
		visual_root.remove_child(child)
		child.queue_free()

	if not visual_path.is_empty() and ResourceLoader.exists(visual_path):
		var scene := load(visual_path) as PackedScene
		if scene != null:
			var inst := scene.instantiate() as Node3D
			if inst != null:
				inst.name = "Model"
				visual_root.add_child(inst)

	area.set_meta("visual_state", visual_state)
	area.set_meta("visual_path", visual_path)


static func _resolve_visual_state(decl: InteractableDecl) -> String:
	if _should_use_inactive_visual(decl):
		return "inactive"

	var ordered_states: PackedStringArray = decl.visual_state_order
	if ordered_states.is_empty():
		for key in decl.visual_state_conditions.keys():
			ordered_states.append(String(key))

	for state_name in ordered_states:
		var condition := String(decl.visual_state_conditions.get(state_name, ""))
		if condition.is_empty():
			continue
		if _evaluate_state_expression(condition):
			return state_name

	return decl.default_visual_state


static func _resolve_visual_path(decl: InteractableDecl, visual_state: String) -> String:
	if not visual_state.is_empty() and decl.state_visual_kind_map.has(visual_state):
		return _resolve_visual_kind_path(String(decl.state_visual_kind_map[visual_state]))
	if not visual_state.is_empty() and decl.state_model_map.has(visual_state):
		return String(decl.state_model_map[visual_state])
	if visual_state == "inactive":
		if not decl.inactive_visual_kind.is_empty():
			return _resolve_visual_kind_path(decl.inactive_visual_kind)
		if not decl.inactive_scene_path.is_empty():
			return decl.inactive_scene_path
		if not decl.inactive_model.is_empty():
			return decl.inactive_model
	if not decl.visual_kind.is_empty():
		return _resolve_visual_kind_path(decl.visual_kind)
	if not decl.scene_path.is_empty():
		return decl.scene_path
	if not decl.model.is_empty():
		return decl.model
	if not decl.inactive_scene_path.is_empty():
		return decl.inactive_scene_path
	if not decl.inactive_model.is_empty():
		return decl.inactive_model
	return ""


static func _should_use_inactive_visual(decl: InteractableDecl) -> bool:
	if decl.thread_active.is_empty():
		return false
	var game_manager := _game_manager()
	var active_thread := ""
	if game_manager != null and game_manager.has_method("get_state"):
		active_thread = String(game_manager.call("get_state", "macro_thread", ""))
	if active_thread.is_empty() or not decl.thread_active.has(active_thread):
		return not decl.inactive_visual_kind.is_empty() or not decl.inactive_scene_path.is_empty() or not decl.inactive_model.is_empty()
	return false


static func _evaluate_state_expression(expression: String) -> bool:
	if expression.is_empty():
		return false
	var state_machine := StateMachineScript.new()
	state_machine.init_from_schema(STATE_SCHEMA)
	var game_manager := _game_manager()
	if game_manager != null:
		var flags: Variant = game_manager.get("flags")
		if flags is Dictionary:
			for key in flags:
				state_machine.set_var(String(key), flags[key])
		var visited_rooms: Variant = game_manager.get("visited_rooms")
		if visited_rooms is Array:
			for room_id in visited_rooms:
				state_machine.visit_room(String(room_id))
		if game_manager.has_method("get_inventory_items"):
			state_machine.set_inventory(game_manager.call("get_inventory_items"))
	return state_machine.evaluate(expression)


static func _game_manager() -> Node:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		return null
	return tree.root.get_node_or_null("GameManager")


static func _resolve_visual_kind_path(kind: String) -> String:
	return String(SHARED_VISUAL_KIND_PATHS.get(kind, ""))
