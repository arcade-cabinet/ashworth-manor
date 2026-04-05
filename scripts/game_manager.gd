extends Node
## res://scripts/game_manager.gd — Autoload singleton managing all game state

signal state_changed(key: String, value: Variant)
signal item_acquired(item_id: String)
signal flag_set(flag_name: String)
signal ending_triggered(ending_id: String)
signal screen_changed(screen: String)

enum Screen { LANDING, GAME, PAUSED }

var current_screen: int = Screen.LANDING
var current_room: String = "front_gate"
var inventory: Array[String] = []
var visited_rooms: Array[String] = []
var interacted_objects: Array[String] = []
var flags: Dictionary = {}
var lights_toggled: Dictionary = {}

const SAVE_PATH := "user://save.json"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func new_game() -> void:
	current_room = "front_gate"
	inventory.clear()
	visited_rooms.clear()
	interacted_objects.clear()
	flags.clear()
	lights_toggled.clear()
	current_screen = Screen.GAME
	screen_changed.emit("game")

func has_item(item_id: String) -> bool:
	return inventory.has(item_id)

func give_item(item_id: String) -> void:
	if not inventory.has(item_id):
		inventory.append(item_id)
		item_acquired.emit(item_id)
		set_flag("has_" + item_id)

func remove_item(item_id: String) -> void:
	inventory.erase(item_id)

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func set_flag(flag_name: String) -> void:
	if not flags.get(flag_name, false):
		flags[flag_name] = true
		flag_set.emit(flag_name)

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

# --- Save / Load ---

func save_game() -> void:
	var data := {
		"current_room": current_room,
		"inventory": inventory,
		"visited_rooms": visited_rooms,
		"interacted_objects": interacted_objects,
		"flags": flags,
		"lights_toggled": lights_toggled,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK:
		return false
	var data: Dictionary = json.data
	current_room = data.get("current_room", "front_gate")
	inventory.assign(data.get("inventory", []))
	visited_rooms.assign(data.get("visited_rooms", []))
	interacted_objects.assign(data.get("interacted_objects", []))
	flags = data.get("flags", {})
	lights_toggled = data.get("lights_toggled", {})
	current_screen = Screen.GAME
	screen_changed.emit("game")
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# --- Ending Checks ---

func can_perform_ritual() -> bool:
	return (has_item("porcelain_doll") and has_item("binding_book")
		and has_item("lock_of_hair") and has_item("blessed_water")
		and has_item("mothers_confession") and has_flag("read_final_note"))

func check_escape_ending() -> bool:
	return has_flag("knows_full_truth") and not has_flag("counter_ritual_complete")

func check_joined_ending() -> bool:
	return has_flag("elizabeth_aware") and not has_flag("knows_full_truth")
