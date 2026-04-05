# AGENTS.md - AI Development Guide for Ashworth Manor

This document provides guidance for AI agents working on the Ashworth Manor codebase.

## Project Context

Ashworth Manor is a **first-person PSX-style Victorian haunted house exploration game** built with **Godot 4.6** and **GDScript**. The game prioritizes atmosphere, immersion, and diegetic design over traditional game UI patterns. It features 20 rooms across 5 interior floors plus exterior grounds, with 1000+ organized asset files.

## Critical Design Constraints

### DO NOT

- Add neon colors, cyberpunk aesthetics, or futuristic elements
- Create floating UI elements or HUD overlays during gameplay
- Add joystick controls or virtual buttons
- Use sans-serif fonts for in-game text
- Create ambient light without a physical source
- Add enemies or combat mechanics (environment-first development)
- Break the Victorian time period (1847-1891)
- Use animated GLBs (static models only)
- Add audio beyond the existing OGG loop system (no audio support beyond loops)

### ALWAYS

- Ensure lighting has a visible physical source (candle, sconce, window, fireplace)
- Maintain the color palette: dark reds, deep browns, aged golds, blacks
- Keep interactions diegetic (in-world responses, not UI popups)
- Preserve tap-to-walk and swipe-to-look controls
- Use serif fonts (Cinzel, Cormorant Garamond) for all text
- Each room is a standalone .tscn scene file, not generated at runtime

## Architecture Overview

```
project.godot              # Godot config: viewport, input maps, autoloads
scenes/
├── main.tscn              # Main scene
├── build_main.gd          # Headless scene builder
└── rooms/                 # 20 room .tscn files
    ├── ground_floor/      # foyer, parlor, dining_room, kitchen
    ├── upper_floor/       # hallway, master_bedroom, library, guest_room
    ├── basement/          # storage, boiler_room
    ├── deep_basement/     # wine_cellar
    ├── attic/             # stairwell, storage, hidden_chamber
    └── grounds/           # front_gate, garden, chapel, greenhouse,
                           # carriage_house, family_crypt
scripts/
├── game_manager.gd        # Autoload singleton: state, inventory, flags, save/load
├── room_manager.gd        # Scene instancing, fade transitions, room registry
├── room_base.gd           # Room root script (exported vars, flickering lights)
├── interactable_data.gd   # Custom Resource for interactable metadata
├── room_connection.gd     # Custom Resource for door/stairs connections
├── player_controller.gd   # CharacterBody3D: tap-to-walk, swipe-to-look
├── interaction_manager.gd # Puzzle logic, endings, document display
├── audio_manager.gd       # Room-based audio loops with crossfade
└── ui_overlay.gd          # Diegetic overlays (documents, room names, endings)
shaders/
├── psx.gdshader           # Per-material PSX vertex shader
└── psx_post.gdshader      # Screen-space canvas_item post-process on CanvasLayer
assets/
├── {floor}/{room}/        # Per-room GLBs and textures
├── shared/                # Shared models: structure, furniture, decor, items
├── horror/                # Horror pack: dolls, textures
└── audio/loops/           # 36 OGG ambient loops
```

## Key Files

### room_manager.gd
Owns room lifecycle. Maintains a `_room_registry` dictionary mapping `room_id` to scene path (e.g. `"foyer"` to `"res://scenes/rooms/ground_floor/foyer.tscn"`). Instances PackedScene into a RoomContainer node, frees previous room on transition. Handles fade-to-black transitions with timing per connection type (door/stairs/ladder/path).

**When modifying**: The registry dict must stay in sync with actual .tscn files. Every room_id used in connections must exist in the registry.

### room_base.gd
Attached to the root Node3D of every room .tscn. Exports: `room_id`, `room_name`, `audio_loop`, `ambient_darkness`, `is_exterior`, `spawn_position`, `spawn_rotation_y`. Auto-discovers flickering lights (Light3D nodes with `flickering` meta) and updates their energy in `_process()`. Provides `get_interactables()` and `get_connections()` to find Area3D children in the respective groups.

### interaction_manager.gd
Full puzzle logic including document display, locked doors, box/container items, the porcelain doll multi-step puzzle, and the 3-step counter-ritual sequence. Reads InteractableData from Area3D metadata. Handles ending condition checks when the player exits to front_gate.

### game_manager.gd
Autoload singleton. Manages inventory, flags, visited rooms, interacted objects, light toggle state, save/load, and ending triggers.

### interactable_data.gd / room_connection.gd
Custom Resource scripts. InteractableData holds: `object_id`, `object_type`, `title`, `content`, `locked`, `key_id`, `item_found`, `on_read_flags`, `extra_data`. RoomConnection holds: `target_scene_path`, `conn_type`, `locked`, `key_id`.

## Code Patterns

### Adding a New Room

1. Create a .tscn scene file under `scenes/rooms/{floor}/{room_name}.tscn`
2. Set root node to Node3D, attach `room_base.gd`, configure exported vars
3. Add children: Geometry (CSGBox3D walls/floor/ceiling), Models (GLB instances), Lighting, Interactables (Area3D in group "interactables"), Connections (Area3D in group "connections")
4. Add entry to `_room_registry` in `room_manager.gd`
5. Add connection Area3Ds in adjacent rooms pointing to the new scene

### Adding a New Interactable Type

1. Add a match case in `interaction_manager.gd::_on_interacted()` for the new type
2. Create an Area3D in the room scene with group "interactables"
3. Attach an InteractableData resource via metadata with `object_type` set to the new type
4. Handle the interaction logic (show document, give item, trigger event, etc.)

### Room Scene Structure

```
RoomName (Node3D) [room_base.gd]
├── Geometry (Node3D)
│   ├── Floor (CSGBox3D)
│   ├── Ceiling (CSGBox3D)
│   └── WallNorth/South/East/West (CSGBox3D)
├── Models (Node3D)
│   └── [GLB instances]
├── Lighting (Node3D)
│   └── [OmniLight3D, SpotLight3D]
├── Interactables (Node3D)
│   └── [Area3D, group "interactables", InteractableData resource]
└── Connections (Node3D)
    └── [Area3D, group "connections", RoomConnection resource]
```

## Testing Checklist

Before submitting changes:

- [ ] Game loads in Godot editor (F5)
- [ ] Room transitions work between all connected rooms
- [ ] Interactables fire correct signals with correct data
- [ ] Textures visible on walls/floors/ceilings (no magenta/missing)
- [ ] Lighting appears natural with visible sources
- [ ] PSX shader active (dithering, color depth reduction visible)
- [ ] All 6 puzzle items in correct rooms
- [ ] All 3 endings triggerable
- [ ] No errors in Godot output console

## Performance Considerations

- Only one room scene is instanced at a time (previous freed on transition)
- PSX post-process shader runs on CanvasLayer, not per-material
- GLB models have embedded textures (no separate texture loading needed)
- CSGBox3D used for room geometry (collision layers 1-2)
- Flickering lights use simple sine-wave modulation in `_process()`

## Narrative Guidelines

The story follows the Ashworth family tragedy:
- Lord and Lady Ashworth had four children, not three
- Elizabeth (the fourth) was hidden away due to her "abilities"
- She was confined to the attic and eventually "became part of the house"
- Notes and photographs reveal this gradually
- The tone is melancholic horror, not jump-scare horror

When writing in-game text:
- Use formal Victorian language
- Date entries between 1880-1891
- Reference the family: Lord Ashworth, Lady Ashworth, "the children"
- Hint at supernatural elements subtly

## Common Tasks

### Adjusting atmosphere/mood
- `ambient_darkness` export on room_base.gd (per room)
- PSX shader params in `psx_post.gdshader`: `color_depth`, `resolution_scale`, `dither_strength`
- WorldEnvironment settings in main.tscn

### Changing movement speed
In `player_controller.gd`: look for `MOVE_SPEED` constant and camera rotation sensitivity.

### Adding new texture types
Place PNGs in `assets/shared/textures/` or the relevant room directory. Apply as StandardMaterial3D on CSGBox3D nodes in the room .tscn.

## Contact

For architectural decisions or major changes, document reasoning in commit messages and update relevant docs.
