# Code & Architecture Standards

## GDScript

- **Max 200 LOC per script** — if it's bigger, decompose
- **Single responsibility** — one script, one job
- **No monolithic data files** — data lives in `.tres` resources or scene `@export` vars
- **Typed everything** — `var x: int`, `func foo() -> void:`, `Array[String]`
- **No magic strings** — use `StringName`, enums, or constants
- **No `load()` of other scripts to access static data** — use resources or autoloads

## Scene Files (.tscn)

- **Each room is a self-contained `.tscn`** — everything it needs is IN the scene
- **Interactables are Area3D nodes** with `InteractableData` `.tres` resources
- **Connections are Area3D nodes** with `RoomConnection` `.tres` resources
- **Room metadata** via `@export` vars on root script, NOT external data files
- **Scene hierarchy**:
  ```
  RoomName (Node3D) [room_base.gd]
  ├── Geometry/
  ├── Models/
  ├── Lighting/
  ├── Interactables/    ← Area3D children with InteractableData
  └── Connections/      ← Area3D children with RoomConnection
  ```

## Resources (.tres)

- **InteractableData** — object_id, type, title, content, flags, items
- **RoomConnection** — target scene path, connection type, locked state, key_id
- Resources are inspector-editable — no code needed to configure them

## Collision Layers

| Layer | Name | Usage |
|-------|------|-------|
| 1 | walkable | Floor CSGBox3D |
| 2 | walls | Wall/ceiling CSGBox3D |
| 3 | interactables | Interactable Area3D |
| 4 | connections | Connection Area3D |

## File Organization

```
scripts/
├── game_manager.gd      ≤200 LOC — state, save/load
├── room_manager.gd       ≤200 LOC — scene instancing, transitions
├── room_base.gd          ≤100 LOC — room root script
├── player_controller.gd  ≤200 LOC — movement, input, raycasting
├── interaction_manager.gd ≤200 LOC — interaction dispatch
├── audio_manager.gd      ≤150 LOC — ambient loops, crossfade
├── ui/
│   ├── landing_screen.gd ≤100 LOC
│   ├── document_overlay.gd ≤100 LOC
│   ├── room_name_display.gd ≤50 LOC
│   ├── pause_menu.gd     ≤100 LOC
│   └── ending_overlay.gd ≤100 LOC
├── interactable_data.gd  ≤50 LOC — Resource class
└── room_connection.gd    ≤20 LOC — Resource class

scenes/
├── main.tscn
└── rooms/{floor}/{room}.tscn  ← 20 scenes, each self-contained

resources/
├── interactables/{room_id}/   ← .tres files for each interactable
└── connections/{room_id}/     ← .tres files for each connection
```

## What NOT to Do

- ❌ Monolithic data scripts (room_data.gd was 1020 LOC)
- ❌ Runtime scene generation from code (CSGBox3D in scripts)
- ❌ Empty scene containers that need code to populate
- ❌ Scripts that `load()` other scripts to read static data
- ❌ Single UI script handling 5 different concerns (565 LOC)
- ❌ Metadata dictionaries passed as untyped `Dictionary` — use Resources
