# Interaction System

This document details the interaction system, including object types, behaviors, and implementation patterns.

## Overview

Ashworth Manor uses a **diegetic interaction system** where all player interactions occur within the game world rather than through abstract UI elements. When a player interacts with an object, the response feels like examining something in the physical space.

The interaction system is implemented in GDScript across `player_controller.gd` (input/raycast), `interaction_manager.gd` (puzzle logic), and `ui_overlay.gd` (document display).

## Interaction Flow

```
Player Tap
    │
    ▼
PlayerController raycast (collision layers)
    │
    ├─► Layer 1 (walkable floor)
    │       │
    │       ▼
    │   Move to position
    │
    ├─► Layer 3 (interactable Area3D)
    │       │
    │       ▼
    │   Emit interacted(object_id, object_type, data)
    │       │
    │       ▼
    │   InteractionManager._on_interacted()
    │       │
    │       ▼
    │   Match object_type → handle logic
    │       │
    │       ▼
    │   UIOverlay.show_document(title, content)
    │
    └─► Layer 4 (connection Area3D)
            │
            ▼
        Emit door_tapped(target_room)
            │
            ▼
        InteractionManager._on_door_tapped()
            │
            ├─► Check locked/key_id
            ├─► Check ending conditions
            └─► RoomManager.transition_to()
```

## Interactable Object Types

### Paintings

**Purpose**: Environmental storytelling, family history
**Visual**: GLB picture frame model (picture_blank.glb variants) or CSGBox3D on wall
**Interaction Result**: Overlay showing title and description

---

### Notes

**Purpose**: Direct narrative exposition, diary entries, letters
**Visual**: GLB page model (page0.glb etc.) or small CSGBox3D
**Interaction Result**: Overlay with aged paper styling, italic text

---

### Photos

**Purpose**: Visual clues, family documentation
**Visual**: Small GLB or CSGBox3D
**Interaction Result**: Description of photograph contents

---

### Mirrors

**Purpose**: Atmospheric unease, self-reflection themes
**Visual**: CSGBox3D with reflective StandardMaterial3D
**Interaction Result**: Eerie observation about reflection

---

### Clocks

**Purpose**: Time symbolism, frozen moment
**Visual**: CSGBox3D representing grandfather clock
**Interaction Result**: Description noting time (always 3:33 AM)

---

### Switches

**Purpose**: Environmental control, agency
**Visual**: Small CSGBox3D on wall
**Interaction Result**: Toggles associated light via GameManager.toggle_light()

---

### Boxes/Containers

**Purpose**: Item discovery, locked progression
**Visual**: GLB model (treasure.glb, drawers.glb) or CSGBox3D

**Interaction Logic** (in interaction_manager.gd):
```gdscript
func _handle_box(object_id: String, data: Dictionary) -> void:
    var locked: bool = data.get("locked", false)
    var key_id: String = data.get("key_id", "")
    var item_found: String = data.get("item_found", "")
    
    if locked and not key_id.is_empty():
        if GameManager.has_item(key_id):
            # Unlock — keys are NOT consumed
            GameManager.give_item(item_found)
            _show("Unlocked", data.get("item_content", ""))
        else:
            _show("Locked", "It's locked. You need a key.")
    else:
        if not item_found.is_empty():
            GameManager.give_item(item_found)
        _show(data.get("title", ""), data.get("content", ""))
```

---

### Dolls (Special Multi-Step)

**Purpose**: Key puzzle item (porcelain doll contains hidden_key)
**Visual**: GLB model (doll1.glb)
**Interaction Logic**: Multi-step -- first examine, then extract key (requires reading Elizabeth's letter first), then becomes pickable for counter-ritual

---

### Ritual (Counter-Ritual Sequence)

**Purpose**: True ending trigger in Hidden Chamber
**Visual**: Floor circle Area3D
**Interaction Logic**: 3-step sequence requiring all 6 components:
1. Place the doll
2. Pour blessed water
3. Read from the Binding Book

---

### Locked Doors

**Purpose**: Gated progression
**Visual**: GLB door model with Area3D
**Interaction Logic**: Check key_id against inventory, transition if unlocked

---

### Room Transitions (Connections)

**Purpose**: Move between rooms
**Visual**: Area3D at doorways, stairs, ladders, paths
**Data**: RoomConnection resource with target_scene_path, conn_type, locked, key_id
**Result**: RoomManager.transition_to() with fade timing based on conn_type

---

## Interaction Overlay (UIOverlay)

The UIOverlay (scripts/ui_overlay.gd) renders document content as a diegetic overlay on a CanvasLayer:
- Aged paper background with Victorian styling
- Title in serif font (Cinzel)
- Content in serif body font
- Tap anywhere to dismiss

### Styling by Type

| Type | Font Style | Additional |
|------|------------|------------|
| note | Italic | Handwritten feel |
| painting | Normal | Title prominent |
| photo | Normal | Description only |
| mirror | Normal | Eerie tone |
| locked | Normal | Red accent |

---

## Data Schema

### InteractableData Resource (interactable_data.gd)

```gdscript
class_name InteractableData
extends Resource

@export var object_id: String
@export var object_type: String    # note, painting, photo, mirror, clock, switch, box, doll, ritual, locked_door, observation
@export var title: String
@export var content: String
@export var locked: bool = false
@export var key_id: String
@export var item_found: String
@export var on_read_flags: PackedStringArray
@export var extra_data: Dictionary
```

### RoomConnection Resource (room_connection.gd)

```gdscript
class_name RoomConnection
extends Resource

@export var target_scene_path: String   # e.g. "res://scenes/rooms/ground_floor/parlor.tscn"
@export var conn_type: String           # door, stairs, ladder, path
@export var locked: bool = false
@export var key_id: String
```

### Collision Layers

| Layer | Purpose |
|-------|---------|
| 1 | Walkable (floor CSGBox3D) |
| 2 | Walls (wall/ceiling CSGBox3D) |
| 3 | Interactables (Area3D in "interactables" group) |
| 4 | Connections (Area3D in "connections" group) |

---

## Adding New Interaction Types

### Step 1: Add Match Case

In `interaction_manager.gd::_on_interacted()`:
```gdscript
match object_type:
    # ... existing types ...
    "new_type":
        _handle_new_type(object_id, object_data)
```

### Step 2: Create Handler

```gdscript
func _handle_new_type(object_id: String, data: Dictionary) -> void:
    var title: String = data.get("title", "")
    var content: String = data.get("content", "")
    # Custom logic here
    _show(title, content)
```

### Step 3: Add to Room Scene

In the room .tscn, add an Area3D:
- Add to group "interactables"
- Set meta "interactable" with an InteractableData resource
- Set object_type to "new_type"
- Add CollisionShape3D child

---

## State Tracking

All state is managed through GameManager (autoload singleton):

```gdscript
# Interaction history
GameManager.mark_interacted(object_id)

# Inventory
GameManager.give_item(item_id)
GameManager.has_item(item_id)
GameManager.remove_item(item_id)

# Story flags
GameManager.set_flag(flag_name)
GameManager.has_flag(flag_name)

# Light toggles
GameManager.toggle_light(light_id)
```
