# Inventory Plan — gloot

## Source
- Addon: `peter-kish/gloot`
- Location: `addons/gloot/`
- Docs: https://github.com/peter-kish/gloot

## Purpose

Replace `GameManager.inventory: Array[String]` with a proper resource-based inventory system providing item prototypes, visual inventory UI, and item properties.

## Item Prototype Tree

```
ProtoTree (res://resources/item_prototypes.tres)
├── keys/
│   ├── attic_key      { name: "Brass Key", weight: 0.1, icon: key_brass }
│   ├── cellar_key     { name: "Iron Key", weight: 0.2, icon: key_iron }
│   ├── jewelry_key    { name: "Tiny Brass Key", weight: 0.05, icon: key_tiny }
│   ├── hidden_key     { name: "Tarnished Key", weight: 0.1, icon: key_tarnished }
│   └── gate_key       { name: "Iron Gate Key", weight: 0.2, icon: key_gate }
├── documents/
│   ├── binding_book   { name: "Rituals of Binding", weight: 0.5, ritual: true }
│   └── mothers_confession { name: "Lady Ashworth's Confession", weight: 0.1, ritual: true }
├── artifacts/
│   ├── porcelain_doll { name: "Elizabeth's Doll", weight: 0.3, ritual: true }
│   └── elizabeths_locket { name: "Silver Locket", weight: 0.05 }
├── ritual_components/
│   ├── blessed_water  { name: "Vial of Holy Water", weight: 0.1, consumable: true, ritual: true }
│   └── lock_of_hair   { name: "Lock of Hair", weight: 0.01, ritual: true }
```

## GameManager Wrapper

Keep `GameManager.has_item()` / `give_item()` / `remove_item()` as the public API. They wrap gloot internally:

```gdscript
# In game_manager.gd
var _inventory: Inventory  # gloot Inventory node

func has_item(item_id: String) -> bool:
    return _inventory.get_item_by_id(item_id) != null

func give_item(item_id: String) -> void:
    if not has_item(item_id):
        _inventory.create_and_add_item(item_id)
        item_acquired.emit(item_id)
        set_flag("has_" + item_id)
```

## Pause Menu Inventory Display

Replace the text-based inventory label with `CtrlInventory` from gloot:
- Grid layout showing item icons
- Tap item to see description
- Ritual components highlighted when near Hidden Chamber

## Implementation Steps

1. Create `resources/item_prototypes.tres` ProtoTree with all items
2. Add `Inventory` node to GameManager autoload
3. Update `GameManager` methods to wrap gloot API
4. Create item icons (simple pixel art, 32x32, PSX style)
5. Replace pause menu inventory label with `CtrlInventory`
6. Test: acquire every item, verify persistence across rooms, verify save/load
