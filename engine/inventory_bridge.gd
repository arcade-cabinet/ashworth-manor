class_name InventoryBridge
extends RefCounted
## Bridges ItemDeclaration resources to gloot's ProtoTree/Inventory system.
## On startup: reads ItemDeclarations -> creates gloot prototypes.
## On give_item: wraps gloot's add_item with declaration metadata.

signal item_added(item_id: String, display_name: String)
signal item_removed(item_id: String)

var _items: Dictionary = {}  # item_id -> ItemDeclaration
var _held_items: Array[String] = []  # Current inventory as item_ids
var _functional_slots: Dictionary = {}  # functional_slot -> item_id


## Load all item declarations and build prototype lookup.
func load_items(items: Array[ItemDeclaration]) -> void:
	for item in items:
		_items[item.item_id] = item
		if not item.functional_slot.is_empty():
			_functional_slots[item.functional_slot] = item.item_id


## Get the ItemDeclaration for an item_id.
func get_declaration(item_id: String) -> ItemDeclaration:
	return _items.get(item_id)


## Give an item to the player. Returns true if added.
func give_item(item_id: String) -> bool:
	if item_id in _held_items:
		return false  # Already have it
	if item_id not in _items:
		push_warning("InventoryBridge: Unknown item '%s'" % item_id)
		_held_items.append(item_id)
		item_added.emit(item_id, item_id)
		return true

	_held_items.append(item_id)
	var decl: ItemDeclaration = _items[item_id]
	item_added.emit(item_id, decl.name)
	return true


## Remove an item from inventory. Returns true if removed.
func remove_item(item_id: String) -> bool:
	var idx := _held_items.find(item_id)
	if idx < 0:
		return false
	_held_items.remove_at(idx)
	item_removed.emit(item_id)
	return true


## Check if player has an item by exact id.
func has_item(item_id: String) -> bool:
	return item_id in _held_items


## Check if player has an item matching a functional_slot.
## Used for key/lock mechanics where different items can fill the same role.
func has_functional_slot(slot: String) -> bool:
	for held_id in _held_items:
		if held_id in _items:
			var decl: ItemDeclaration = _items[held_id]
			if decl.functional_slot == slot:
				return true
	return false


## Get the item_id that fills a functional_slot, or empty string.
func get_item_for_slot(slot: String) -> String:
	for held_id in _held_items:
		if held_id in _items:
			var decl: ItemDeclaration = _items[held_id]
			if decl.functional_slot == slot:
				return held_id
	return ""


## Get all held item IDs.
func get_held_items() -> Array[String]:
	return _held_items.duplicate()


## Get held items as array of item_ids (for StateMachine.set_inventory).
func get_item_ids() -> Array[String]:
	return _held_items.duplicate()


## Get display info for all held items (for UI).
func get_inventory_display() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for item_id in _held_items:
		if item_id in _items:
			var decl: ItemDeclaration = _items[item_id]
			result.append({
				"item_id": item_id,
				"display_name": decl.name,
				"description": decl.description,
				"category": decl.category,
				"functional_slot": decl.functional_slot,
			})
		else:
			result.append({
				"item_id": item_id,
				"display_name": item_id,
				"description": "",
				"category": "unknown",
				"functional_slot": "",
			})
	return result


## Generate gloot ProtoTree data from declarations.
## Returns a Dictionary suitable for creating gloot item prototypes.
func generate_proto_tree() -> Dictionary:
	var prototypes: Dictionary = {}
	for item_id in _items:
		var decl: ItemDeclaration = _items[item_id]
		prototypes[item_id] = {
			"name": decl.name,
			"description": decl.description,
			"category": decl.category,
			"functional_slot": decl.functional_slot,
			"is_consumable": decl.is_consumable,
			"is_ritual_component": decl.is_ritual_component,
		}
	return prototypes


## Clear inventory (for new game).
func clear() -> void:
	_held_items.clear()


## Serialize for save.
func serialize() -> Dictionary:
	return {"held_items": _held_items.duplicate()}


## Deserialize from save.
func deserialize(data: Dictionary) -> void:
	_held_items = data.get("held_items", [])
