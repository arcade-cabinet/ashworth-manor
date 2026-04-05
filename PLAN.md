# Game Plan: Ashworth Manor — Architecture Redesign

## Game Description

PSX-style Victorian haunted house exploration. 20 rooms, 6 puzzles, 3 endings, 663+ assets. Redesign from monolithic room_data.gd to proper Godot scene-based architecture where each room is its own .tscn file.

## Risk Tasks

### 1. Room Scene Template + RoomManager Instancing
- **Why isolated:** The entire game depends on rooms loading/unloading correctly. Scene instancing with proper metadata, collision layers, and signal connections must work before any room content matters.
- **Verify:** RoomManager can load any room .tscn by path, instance it, connect interactable signals, free it, load another. Fade transition works. Player repositioned. Audio crossfade triggers.

## Main Build

**Architecture overhaul:**

1. **Room base script** (`scripts/room_base.gd`) — extends Node3D, exported vars for room metadata:
   - `@export var room_id: String`
   - `@export var room_name: String`
   - `@export var audio_loop: String`
   - `@export var ambient_darkness: float`
   - `@export var connections: Array[Dictionary]` (stored as .tres)
   - `@export var is_exterior: bool`
   - Auto-registers interactable Area3D children (group "interactables")
   - Auto-registers connection Area3D children (group "connections")

2. **Room connection resource** (`scripts/room_connection.tres` template) — custom Resource:
   - `target_room_path: String` (res://scenes/rooms/foyer.tscn)
   - `type: String` (door/stairs/ladder/path)
   - `locked: bool`
   - `key_id: String`

3. **Interactable resource** (`scripts/interactable_data.tres` template) — custom Resource:
   - `object_id: String`
   - `object_type: String` (note/painting/box/doll/ritual/etc)
   - `title: String`
   - `content: String`
   - `locked: bool`, `key_id: String`, `item_found: String`
   - `on_read_flags: PackedStringArray`
   - `extra_data: Dictionary`

4. **20 room scenes** — each built via Godot MCP or scene builders:
   ```
   scenes/rooms/
   ├── ground_floor/
   │   ├── foyer.tscn
   │   ├── parlor.tscn
   │   ├── dining_room.tscn
   │   └── kitchen.tscn
   ├── upper_floor/
   │   ├── hallway.tscn
   │   ├── master_bedroom.tscn
   │   ├── library.tscn
   │   └── guest_room.tscn
   ├── basement/
   │   ├── storage.tscn
   │   └── boiler_room.tscn
   ├── deep_basement/
   │   └── wine_cellar.tscn
   ├── attic/
   │   ├── stairwell.tscn
   │   ├── storage.tscn
   │   └── hidden_chamber.tscn
   └── grounds/
       ├── front_gate.tscn
       ├── garden.tscn
       ├── chapel.tscn
       ├── greenhouse.tscn
       ├── carriage_house.tscn
       └── family_crypt.tscn
   ```

5. **Refactored RoomManager** — simplified to scene instancing:
   - `transition_to(scene_path: String, conn_type: String)`
   - Instances PackedScene, adds to tree, frees previous
   - Reads room_base exports for metadata
   - Finds children in "interactables" and "connections" groups

6. **Refactored InteractionManager** — reads interactable_data from Area3D metadata instead of raw dictionaries

7. **Delete room_data.gd** — no longer needed

Each room scene contains:
- CSGBox3D geometry with TEXTURED materials (actual .png textures from assets/)
- GLB model instances placed as composed tableaux
- OmniLight3D / SpotLight3D nodes with proper warm colors
- Area3D nodes for interactables (with InteractableData resource)
- Area3D nodes for connections (with RoomConnection resource)

**Per-room composition** — each room built as a Myst-style tableau:
- Macro: room shape, dominant light source, atmosphere
- Meso: furniture arrangement, traffic flow, focal points
- Micro: props that tell stories (half-eaten meal, dropped letter, broken glass)

- **Verify:**
  - Each room .tscn loads independently without errors
  - Room transitions work between all connected rooms
  - Interactables fire correct signals with correct data
  - Textures visible on walls/floors/ceilings — no flat dark boxes
  - Room scale feels like a mansion (high ceilings, wide spaces)
  - Objects composed as scenes (spatial relationships tell stories)
  - All 6 puzzle items in correct rooms
  - All 3 endings triggerable
  - PSX shader active
  - Audio loops play per room
  - No magenta/missing textures
  - **Presentation video:** 30s cinematic tour

## Status

- [x] Risk 1: Room scene template + instancing
- [x] Main Build: 20 room scenes
- [x] Master script alignment verification
- [ ] Presentation video
