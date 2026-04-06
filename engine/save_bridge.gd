class_name SaveBridge
extends RefCounted
## Bridges StateMachine + InventoryBridge + PRNGEngine to SaveMadeEasy.
## Serializes all game state into a single Dictionary for save/load.
## Auto-save triggered on room transitions by room_assembler.

signal save_completed(slot: String)
signal load_completed(slot: String)

const SAVE_VERSION := 1
const AUTO_SAVE_SLOT := "autosave"

var _state_machine: StateMachine
var _inventory: InventoryBridge
var _prng_seed: int = 0
var _current_room: String = ""
var _player_position: Vector3 = Vector3.ZERO
var _player_rotation_y: float = 0.0


func _init(state_machine: StateMachine, inventory: InventoryBridge) -> void:
	_state_machine = state_machine
	_inventory = inventory


## Set PRNG seed for save persistence.
func set_prng_seed(seed_val: int) -> void:
	_prng_seed = seed_val


## Update current room/position (called on room transitions).
func update_position(room_id: String, position: Vector3, rotation_y: float) -> void:
	_current_room = room_id
	_player_position = position
	_player_rotation_y = rotation_y


## Serialize all game state into a save Dictionary.
func serialize() -> Dictionary:
	var state_data := _state_machine.serialize_state()
	return {
		"version": SAVE_VERSION,
		"prng_seed": _prng_seed,
		"current_room": _current_room,
		"player_position": {
			"x": _player_position.x,
			"y": _player_position.y,
			"z": _player_position.z,
		},
		"player_rotation_y": _player_rotation_y,
		"state": state_data,
		"inventory": _inventory.serialize(),
	}


## Deserialize save data and restore game state.
func deserialize(data: Dictionary) -> bool:
	if data.get("version", 0) != SAVE_VERSION:
		push_warning("SaveBridge: Incompatible save version %d" % data.get("version", 0))
		return false

	_prng_seed = data.get("prng_seed", 0)
	_current_room = data.get("current_room", "front_gate")

	var pos: Dictionary = data.get("player_position", {})
	_player_position = Vector3(
		pos.get("x", 0.0),
		pos.get("y", 0.0),
		pos.get("z", 0.0),
	)
	_player_rotation_y = data.get("player_rotation_y", 0.0)

	# Restore state via StateMachine serialization
	_state_machine.deserialize_state(data.get("state", {}))

	# Restore inventory
	_inventory.deserialize(data.get("inventory", {}))

	# Sync inventory to state machine for HAS checks
	_state_machine.set_inventory(_inventory.get_item_ids())

	load_completed.emit(AUTO_SAVE_SLOT)
	return true


## Auto-save (called on room transition).
func auto_save() -> Dictionary:
	var save_data := serialize()
	save_completed.emit(AUTO_SAVE_SLOT)
	return save_data


## Get current room for load restoration.
func get_current_room() -> String:
	return _current_room


func get_player_position() -> Vector3:
	return _player_position


func get_player_rotation_y() -> float:
	return _player_rotation_y


func get_prng_seed() -> int:
	return _prng_seed
