extends Node
## res://scripts/game_manager.gd -- Autoload singleton managing all game state
## Save/load via SaveMadeEasy. Inventory backed by gloot.

const ProtoTreeCache = preload("res://addons/gloot/core/prototree/proto_tree_cache.gd")

signal state_changed(key: String, value: Variant)
signal item_acquired(item_id: String)
signal item_removed(item_id: String)
signal flag_set(flag_name: String)
signal ending_triggered(ending_id: String)
signal screen_changed(screen: String)

enum Screen { LANDING, GAME, PAUSED }

var current_screen: int = Screen.GAME
var current_room: String = "front_gate"
var visited_rooms: Array[String] = []
var interacted_objects: Array[String] = []
var flags: Dictionary = {}
var lights_toggled: Dictionary = {}

# Gloot inventory (replaces Array[String] inventory)
var _gloot_inventory: Inventory = null
const PROTOSET_PATH := "res://resources/item_prototypes.json"
const WORLD_DECLARATION_PATH := "res://declarations/world.tres"

var _world_declaration: WorldDeclaration = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_world_declaration()
	_setup_inventory()

func _setup_inventory() -> void:
	_gloot_inventory = Inventory.new()
	_gloot_inventory.name = "PlayerInventory"
	var protoset_json: JSON = load(PROTOSET_PATH)
	if protoset_json:
		_gloot_inventory.protoset = protoset_json
	add_child(_gloot_inventory)


func _exit_tree() -> void:
	if _gloot_inventory != null:
		_gloot_inventory.reset()
		if _gloot_inventory.get_parent() == self:
			remove_child(_gloot_inventory)
		_gloot_inventory.queue_free()
		_gloot_inventory = null
	ProtoTreeCache.clear_cache()

func new_game() -> void:
	current_room = _get_starting_room()
	visited_rooms.clear()
	interacted_objects.clear()
	flags.clear()
	lights_toggled.clear()
	_gloot_inventory.clear()
	_assign_macro_thread_for_new_game()
	current_screen = Screen.GAME
	screen_changed.emit("game")


func abandon_to_front_gate() -> void:
	new_game()

func has_item(item_id: String) -> bool:
	return _gloot_inventory.has_item_with_prototype_id(item_id)

func give_item(item_id: String) -> void:
	if not has_item(item_id):
		_gloot_inventory.create_and_add_item(item_id)
		item_acquired.emit(item_id)
		set_flag("has_" + item_id)

func remove_item(item_id: String) -> void:
	var item: InventoryItem = _gloot_inventory.get_item_with_prototype_id(item_id)
	if item:
		_gloot_inventory.remove_item(item)
		item_removed.emit(item_id)

func get_inventory_items() -> Array[String]:
	var items: Array[String] = []
	for item in _gloot_inventory.get_items():
		var proto: Variant = item.get_prototype()
		if proto != null:
			items.append(proto.get_prototype_id())
	return items

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func set_flag(flag_name: String) -> void:
	if not flags.get(flag_name, false):
		flags[flag_name] = true
		flag_set.emit(flag_name)
		state_changed.emit(flag_name, true)


func set_state(key: String, value: Variant) -> void:
	var previous: Variant = flags.get(key, null)
	flags[key] = value
	state_changed.emit(key, value)
	if value is bool and value and previous != true:
		flag_set.emit(key)


func get_state(key: String, default_value: Variant = null) -> Variant:
	return flags.get(key, default_value)

func mark_visited(room_id: String) -> void:
	if not visited_rooms.has(room_id):
		visited_rooms.append(room_id)

func mark_interacted(object_id: String) -> void:
	if not interacted_objects.has(object_id):
		interacted_objects.append(object_id)

func has_interacted(object_id: String) -> bool:
	return interacted_objects.has(object_id)

func toggle_light(light_id: String) -> bool:
	var state: bool = not lights_toggled.get(light_id, false)
	lights_toggled[light_id] = state
	return state

func trigger_ending(ending_id: String) -> void:
	ending_triggered.emit(ending_id)

# --- Save / Load via SaveMadeEasy ---

func save_game() -> void:
	SaveSystem.set_var("current_room", current_room)
	SaveSystem.set_var("inventory", get_inventory_items())
	# Use duplicate() to deep-copy typed arrays before SaveSystem stores them.
	# Array() wraps by reference; clear() on the original would empty the save.
	SaveSystem.set_var("visited_rooms", visited_rooms.duplicate())
	SaveSystem.set_var("interacted_objects", interacted_objects.duplicate())
	SaveSystem.set_var("flags", flags.duplicate())
	SaveSystem.set_var("lights_toggled", lights_toggled.duplicate())
	if is_instance_valid(QuestSystem):
		SaveSystem.set_var("quest_pool_state", QuestSystem.pool_state_as_dict())
		SaveSystem.set_var("quest_data", QuestSystem.serialize_quests())
	var hsm: Node = _find_node("GameStateMachine")
	if hsm and hsm.has_method("get_current_phase"):
		SaveSystem.set_var("hsm_state", hsm.get_current_phase())
	var eliz: Node = _find_node("ElizabethPresence")
	if eliz and "current_state" in eliz:
		SaveSystem.set_var("elizabeth_state", eliz.current_state)
	SaveSystem.save()

func load_game() -> bool:
	if not has_save():
		return false
	current_room = SaveSystem.get_var("current_room", "front_gate")
	_gloot_inventory.clear()
	var saved_items: Array = SaveSystem.get_var("inventory", [])
	for item_id in saved_items:
		if item_id is String and not item_id.is_empty():
			_gloot_inventory.create_and_add_item(item_id)
	var saved_visited: Array = SaveSystem.get_var("visited_rooms", [])
	visited_rooms.clear()
	for r in saved_visited:
		if r is String:
			visited_rooms.append(r)
	var saved_interacted: Array = SaveSystem.get_var("interacted_objects", [])
	interacted_objects.clear()
	for o in saved_interacted:
		if o is String:
			interacted_objects.append(o)
	flags = SaveSystem.get_var("flags", {})
	lights_toggled = SaveSystem.get_var("lights_toggled", {})
	if is_instance_valid(QuestSystem):
		var pool_state: Dictionary = SaveSystem.get_var("quest_pool_state", {})
		if not pool_state.is_empty():
			var all_quests: Array[Quest] = _get_all_quest_resources()
			QuestSystem.restore_pool_state_from_dict(pool_state, all_quests)
		var quest_data: Dictionary = SaveSystem.get_var("quest_data", {})
		if not quest_data.is_empty():
			QuestSystem.deserialize_quests(quest_data)
	current_screen = Screen.GAME
	screen_changed.emit("game")
	return true

func has_save() -> bool:
	return SaveSystem.has("current_room")

func _get_all_quest_resources() -> Array[Quest]:
	var quests: Array[Quest] = []
	var dir := DirAccess.open("res://resources/quests/")
	if dir == null:
		return quests
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while not file_name.is_empty():
		if file_name.ends_with(".tres"):
			var res := load("res://resources/quests/" + file_name)
			if res is Quest:
				quests.append(res)
		file_name = dir.get_next()
	return quests


func _load_world_declaration() -> void:
	if ResourceLoader.exists(WORLD_DECLARATION_PATH):
		_world_declaration = load(WORLD_DECLARATION_PATH) as WorldDeclaration


func _get_starting_room() -> String:
	if _world_declaration != null and not _world_declaration.starting_room.is_empty():
		return _world_declaration.starting_room
	return "front_gate"


func _assign_macro_thread_for_new_game() -> void:
	if _world_declaration == null or _world_declaration.macro_threads.is_empty():
		return
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var index := rng.randi_range(0, _world_declaration.macro_threads.size() - 1)
	var thread = _world_declaration.macro_threads[index]
	if thread != null and not thread.thread_id.is_empty():
		set_state("macro_thread", thread.thread_id)

# --- Ending Checks ---

func can_perform_ritual() -> bool:
	return (has_item("porcelain_doll") and has_item("binding_book")
		and has_item("lock_of_hair") and has_item("blessed_water")
		and has_item("mothers_confession") and has_flag("read_final_note"))

func check_escape_ending() -> bool:
	return has_flag("knows_full_truth") and not has_flag("counter_ritual_complete")

func check_joined_ending() -> bool:
	return has_flag("elizabeth_aware") and not has_flag("knows_full_truth")

func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
