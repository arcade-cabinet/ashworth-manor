extends Node
## res://scripts/quest_handler.gd -- Wires GameManager flags to quest_system lifecycle.
## Starts quests on puzzle discovery, completes them on flag set.
## Displays "Quest Started" / "Puzzle Solved" notifications via UIOverlay.

# Quest resource paths keyed by quest id
const QUEST_PATHS: Dictionary = {
	1: "res://resources/quests/quest_attic_key.tres",
	2: "res://resources/quests/quest_hidden_key.tres",
	3: "res://resources/quests/quest_wine_cellar.tres",
	4: "res://resources/quests/quest_jewelry_box.tres",
	5: "res://resources/quests/quest_crypt_gate.tres",
	6: "res://resources/quests/quest_free_elizabeth.tres",
}

# Flag -> quest id to START (discover the puzzle)
const START_TRIGGERS: Dictionary = {
	"knows_attic_locked": 1,
	"elizabeth_aware": 2,
	"found_wine_box": 3,
	"found_jewelry_box": 4,
	"found_crypt_gate": 5,
	"knows_full_truth": 6,
}

# Flag -> quest id to COMPLETE (puzzle solved)
const COMPLETE_TRIGGERS: Dictionary = {
	"attic_unlocked": 1,
	"hidden_chamber_unlocked": 2,
	"wine_box_unlocked": 3,
	"jewelry_box_opened": 4,
	"crypt_gate_opened": 5,
	"freed_elizabeth": 6,
}

var _quests: Dictionary = {}  # id -> Quest resource
var _ui_overlay: Control = null


func _ready() -> void:
	_load_quest_resources()
	_register_available_quests()
	call_deferred("_connect_signals")


func _load_quest_resources() -> void:
	for quest_id in QUEST_PATHS:
		var path: String = QUEST_PATHS[quest_id]
		if ResourceLoader.exists(path):
			var quest: Quest = load(path)
			if quest:
				_quests[quest_id] = quest


func _register_available_quests() -> void:
	for quest_id in _quests:
		var quest: Quest = _quests[quest_id]
		if not QuestSystem.is_quest_in_pool(quest):
			QuestSystem.mark_quest_as_available(quest)


func _connect_signals() -> void:
	if GameManager.has_signal("flag_set"):
		GameManager.flag_set.connect(_on_flag_set)
	if is_instance_valid(QuestSystem):
		QuestSystem.quest_accepted.connect(_on_quest_accepted)
		QuestSystem.quest_completed.connect(_on_quest_completed)
	_ui_overlay = _find_node("UIOverlay") as Control


func _on_flag_set(flag_name: String) -> void:
	# Check start triggers
	if flag_name in START_TRIGGERS:
		var quest_id: int = START_TRIGGERS[flag_name]
		_try_start_quest(quest_id)
	# Check complete triggers
	if flag_name in COMPLETE_TRIGGERS:
		var quest_id: int = COMPLETE_TRIGGERS[flag_name]
		_try_complete_quest(quest_id)


func _try_start_quest(quest_id: int) -> void:
	if quest_id not in _quests:
		return
	var quest: Quest = _quests[quest_id]
	if QuestSystem.is_quest_available(quest):
		QuestSystem.start_quest(quest)


func _try_complete_quest(quest_id: int) -> void:
	if quest_id not in _quests:
		return
	var quest: Quest = _quests[quest_id]
	if QuestSystem.is_quest_active(quest):
		quest.objective_completed = true
		QuestSystem.complete_quest(quest)


func _on_quest_accepted(quest: Quest) -> void:
	_show_notification("Quest: " + quest.quest_name)


func _on_quest_completed(quest: Quest) -> void:
	_show_notification("Puzzle Solved: " + quest.quest_name)
	GameManager.save_game()


func _show_notification(text: String) -> void:
	if _ui_overlay and _ui_overlay.has_method("show_room_name"):
		_ui_overlay.show_room_name(text)


func get_active_quest_names() -> Array[String]:
	var names: Array[String] = []
	for quest in QuestSystem.get_active_quests():
		names.append(quest.quest_name)
	return names


func get_completed_quest_names() -> Array[String]:
	var names: Array[String] = []
	for quest in QuestSystem.completed.get_all_quests():
		names.append(quest.quest_name)
	return names


func get_quest_count() -> Dictionary:
	return {
		"active": QuestSystem.get_active_quests().size(),
		"completed": QuestSystem.completed.get_all_quests().size(),
		"available": QuestSystem.get_available_quests().size(),
	}


func _find_node(node_name: String) -> Node:
	var stack: Array[Node] = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.name == node_name:
			return n
		stack.append_array(n.get_children())
	return null
