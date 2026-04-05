# Architecture Overview

This document describes the technical architecture of Ashworth Manor, a Godot 4.6 game using GDScript.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Godot Scene Tree                       │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────────┐  │
│  │   Main      │  │ PSXLayer     │  │   UILayer         │  │
│  │  (Node3D)   │  │ (CanvasLayer)│  │  (CanvasLayer)    │  │
│  └─────────────┘  └──────────────┘  └───────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Core Systems                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           GameManager (Autoload Singleton)           │   │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────────────┐  │   │
│  │  │ Inventory │ │   Flags   │ │    Save/Load      │  │   │
│  │  └───────────┘ └───────────┘ └───────────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              RoomManager (Node3D)                    │   │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────────────┐  │   │
│  │  │ Registry  │ │ Instancer │ │  Fade Transitions  │  │   │
│  │  └───────────┘ └───────────┘ └───────────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           InteractionManager (Node)                  │   │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────────────┐  │   │
│  │  │  Puzzles  │ │  Endings  │ │  Document Display  │  │   │
│  │  └───────────┘ └───────────┘ └───────────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Room Scenes (20 .tscn files)              │
│  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │  RoomBase        │  │  Per-room .tscn scene           │  │
│  │  (room_base.gd) │  │  CSGBox3D geometry + GLB models │  │
│  │  Exported vars   │  │  Lights + Interactables + Conns │  │
│  └─────────────────┘  └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Component Responsibilities

### GameManager (Autoload Singleton)
- **File**: `scripts/game_manager.gd`
- **Purpose**: Global game state accessible from any script
- **Responsibilities**:
  - Inventory management (give_item, has_item, remove_item)
  - Flag system (set_flag, has_flag) for story progression
  - Visited rooms and interacted objects tracking
  - Save/load to user:// filesystem
  - Ending condition checks (freedom, escape, joined)
  - Light toggle state

### RoomManager
- **File**: `scripts/room_manager.gd`
- **Purpose**: Room lifecycle management
- **Responsibilities**:
  - Maintains `_room_registry` dict mapping room_id to scene path
  - `load_room(room_id)`: Instance PackedScene, add to RoomContainer
  - `transition_to(room_id, conn_type)`: Fade-to-black, swap rooms, reposition player
  - Frees previous room scene on transition
  - Emits `room_loaded`, `room_transition_started`, `room_transition_finished` signals

### RoomBase
- **File**: `scripts/room_base.gd`
- **Purpose**: Room root script attached to every room .tscn
- **Exported Vars**: room_id, room_name, audio_loop, ambient_darkness, is_exterior, spawn_position, spawn_rotation_y
- **Responsibilities**:
  - Flickering light discovery and update (Light3D with "flickering" meta)
  - `get_interactables()`: Find Area3D children in "interactables" group
  - `get_connections()`: Find Area3D children in "connections" group

### InteractionManager
- **File**: `scripts/interaction_manager.gd`
- **Purpose**: All puzzle logic and interaction handling
- **Responsibilities**:
  - Document/note/painting/photo/mirror/clock display
  - Locked door checks (key_id against inventory)
  - Box/container unlock and item discovery
  - Porcelain doll multi-step puzzle
  - 3-step counter-ritual sequence in Hidden Chamber
  - Ending condition checks on room exit to front_gate

### PlayerController
- **File**: `scripts/player_controller.gd`
- **Purpose**: First-person movement and interaction
- **Type**: CharacterBody3D
- **Responsibilities**:
  - Tap-to-walk movement
  - Swipe/drag-to-look camera control
  - Raycast-based interaction detection
  - Reads spawn_position from room_base on room load

### AudioManager
- **File**: `scripts/audio_manager.gd`
- **Purpose**: Room-based ambient audio
- **Responsibilities**:
  - Crossfade between room audio loops
  - Dual AudioStreamPlayer for seamless transitions

### UIOverlay
- **File**: `scripts/ui_overlay.gd`
- **Purpose**: Diegetic UI overlays
- **Responsibilities**:
  - Document/note display with aged paper styling
  - Room name display on entry
  - Ending sequences
  - Pause menu

### Custom Resources
- **InteractableData** (`scripts/interactable_data.gd`): Properties for interactable objects (object_id, object_type, title, content, locked, key_id, item_found, on_read_flags, extra_data)
- **RoomConnection** (`scripts/room_connection.gd`): Properties for room transitions (target_scene_path, conn_type, locked, key_id)

## Data Flow

### Initialization Flow
```
Godot loads main.tscn
    │
    ├─► GameManager autoload starts
    ├─► WorldEnvironment configured
    ├─► PSXLayer (CanvasLayer with psx_post.gdshader)
    ├─► RoomManager._ready() creates RoomContainer + FadeLayer
    ├─► PlayerController._ready()
    ├─► InteractionManager._ready() connects signals
    ├─► AudioManager._ready()
    └─► UIOverlay._ready()
    │
    ▼
RoomManager.load_room("front_gate")
    │
    ├─► Instance PackedScene
    ├─► Add to RoomContainer
    ├─► Read room_base exports
    ├─► Emit room_loaded signal
    └─► AudioManager starts loop, Player repositioned
```

### Interaction Flow
```
Player taps screen
    │
    ▼
PlayerController raycast
    │
    ├─► Hit walkable floor ──► Move to position
    ├─► Hit Area3D in "interactables" group
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
    └─► Hit Area3D in "connections" group
            │
            ▼
        Emit door_tapped(target_room)
            │
            ▼
        InteractionManager._on_door_tapped()
            │
            ├─► Check locked state / key
            ├─► Check ending conditions
            └─► RoomManager.transition_to(room_id, conn_type)
```

### Room Transition Flow
```
RoomManager.transition_to(room_id, conn_type)
    │
    ▼
Tween: Fade rect alpha 0 → 1
    │
    ▼
_perform_room_switch(room_id)
    ├─► _clear_current_room() (queue_free children)
    ├─► load(scene_path).instantiate()
    ├─► Add to RoomContainer
    ├─► Reposition player to spawn_position
    └─► Emit room_loaded
    │
    ▼
Tween: hold interval
    │
    ▼
Tween: Fade rect alpha 1 → 0
    │
    ▼
Emit room_transition_finished
```

## State Management

### GameManager State
```gdscript
var current_room: String
var inventory: Array[String]        # Collected items
var flags: Dictionary               # Story progression flags
var visited_rooms: Array[String]    # Exploration tracking
var interacted_objects: Array[String]
var lights_toggled: Dictionary      # Light switch states
```

### RoomManager State
- `_current_room`: Active RoomBase reference
- `_current_room_id`: Active room string ID
- `_is_transitioning`: Lock during fade transitions
- `_room_registry`: Dictionary of room_id to scene path (20 entries)

## Collision Layers

| Layer | Name | Used By |
|-------|------|---------|
| 1 | walkable | Floor CSGBox3D, player mask |
| 2 | walls | Wall/ceiling CSGBox3D |
| 3 | interactables | Area3D interactable nodes |
| 4 | connections | Area3D door/transition nodes |

## Memory Management

Only one room scene is instanced at a time. On transition:
1. Previous room's children are `queue_free()`d
2. New room PackedScene is instanced and added
3. Godot's garbage collector handles freed nodes

The PSX post-process shader runs on a persistent CanvasLayer and is not affected by room changes.

## PSX Rendering Pipeline

The retro PSX look is achieved through two shaders:
1. **psx.gdshader**: Per-material vertex shader (vertex snapping, affine texture mapping)
2. **psx_post.gdshader**: Screen-space canvas_item shader on a CanvasLayer that applies:
   - Color depth reduction (15 levels)
   - 4x4 Bayer dithering
   - Resolution downscaling (0.5x)

The post-process shader reads from `screen_texture` with `filter_nearest`, giving the characteristic pixelated PS1 look.
