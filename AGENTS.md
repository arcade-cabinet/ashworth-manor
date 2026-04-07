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
- Treat `declarations/*.tres` and the declaration runtime as the source of truth

## Architecture Overview

```
project.godot              # Godot config: viewport, input maps, autoloads
declarations/              # Canonical room/world/item/puzzle data
engine/                    # Declaration runtime, assemblers, builders, validators
scenes/
├── main.tscn              # Main scene shell and managers
└── rooms/                 # Legacy fallback scenes only; not source of truth
scripts/
├── game_manager.gd        # Autoload singleton: state, inventory, flags, save/load
├── world_runtime_manager.gd # Compiled-world runtime state and prewarm plan
├── room_manager.gd        # Declaration-first room assembly and transition orchestration
├── room_base.gd           # Runtime room root API (spawn, audio, interactables, lights)
├── player_controller.gd   # CharacterBody3D: tap-to-walk, swipe-to-look
├── interaction_manager.gd # Runtime dispatch for declaration interactions and endings
├── room_events.gd         # Declaration triggers, ambient events, conditional events
├── audio_manager.gd       # Room-based audio loops with crossfade
└── ui_overlay.gd          # Diegetic overlays (documents, room names, endings)
assets/
├── {floor}/{room}/        # Per-room GLBs and textures
├── shared/                # Shared models: structure, furniture, decor, items
├── horror/                # Horror pack: dolls, textures
└── audio/loops/           # 36 OGG ambient loops
```

## Key Files

### room_manager.gd
Owns room assembly and transition orchestration. Loads `world.tres`, assembles rooms from declarations through `RoomAssembler`, and only falls back to legacy `.tscn` scenes when a declaration is unavailable. Same compiled-world thresholds should stay seamless or embodied by default; inter-world swaps are where masking belongs.

**When modifying**: Keep `declarations/world.tres` and the room declaration registry authoritative. Legacy scene fallback should not be the primary implementation path.

### world_runtime_manager.gd
Owns compiled-world runtime state. Tracks the active room, active authoring region, active compiled world, and prewarmed neighbor worlds. This is the seam between declaration-authored rooms and Myst-style runtime worlds.

### room_base.gd
Attached to the assembled runtime room root. Exports: `room_id`, `room_name`, `audio_loop`, `ambient_darkness`, `is_exterior`, `spawn_position`, `spawn_rotation_y`. Auto-discovers flickering lights (Light3D nodes with `flickering` meta) and updates their energy in `_process()`. Provides `get_interactables()` and `get_connections()` to find Area3D children in the respective groups.

### interaction_manager.gd
Runtime interaction dispatch for declaration-authored responses, puzzle-specific flows, and ending checks. Handles document display, locked thresholds, staged reward interactions, the porcelain doll multi-step puzzle, and the 3-step counter-ritual sequence.

### game_manager.gd
Autoload singleton. Manages inventory, flags, visited rooms, interacted objects, light toggle state, save/load, and ending triggers.

### Declaration Resources
Primary runtime content now lives under `engine/declarations/` and `declarations/*.tres`. Older `interactable_data.gd` / `room_connection.gd` resources are legacy/reference material, not the main authoring path.

## Code Patterns

### Adding a New Room

1. Create a new `RoomDeclaration` under `declarations/rooms/`
2. Add the room reference and any world connections in `declarations/world.tres`
3. Populate geometry/layout, lights, props, interactables, triggers, and atmospheric events declaratively
4. Verify the assembled room through the declaration/runtime tests
5. Add or update room docs under `docs/rooms/`

### Adding a New Interactable Type

1. Prefer extending the declaration/runtime path before adding new hardcoded branches
2. Add the declaration fields/runtime support needed in `engine/declarations/*` and `engine/interaction_engine.gd`
3. Only add a new `interaction_manager.gd` special-case if the behavior cannot be expressed declaratively yet
4. Add test coverage in the declaration/runtime suites

### Runtime Room Structure

```
RoomRoot (Node3D) [room_base.gd]
├── Geometry (Node3D)
├── Doors (Node3D)
├── Windows (Node3D)
├── Lighting (Node3D)
├── Interactables (Node3D)
├── Connections (Node3D)
├── Props (Node3D)
└── Audio (Node3D)
```

## Testing Checklist

Before submitting changes:

- [ ] Game loads in Godot editor (F5)
- [ ] Room transitions work between all connected rooms
- [ ] Interactables fire correct signals with correct data
- [ ] Textures visible on walls/floors/ceilings (no magenta/missing)
- [ ] Lighting appears natural with visible sources
- [ ] Boot path starts at `front_gate` and transitions cleanly into `foyer`
- [ ] All 6 puzzle items in correct rooms
- [ ] All 3 endings triggerable
- [ ] No errors in Godot output console

## Performance Considerations

- Rooms remain the authoring unit, but compiled worlds are the intended runtime traversal unit
- Today the runtime may still free and rebuild room content during transitions, but new work should move toward compiled-world continuity rather than reinforcing room-as-runtime assumptions
- Room geometry, interactables, and props are assembled from declarations at load time
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
- Declaration-authored room lights, props, triggers, and ambient loops are the primary atmosphere controls
- WorldEnvironment settings in main.tscn

### Changing movement speed
In `player_controller.gd`: look for `MOVE_SPEED` constant and camera rotation sensitivity.

### Adding new texture types
Place PNGs in `assets/shared/textures/` or the relevant room directory. Wire them through declaration-authored geometry/material assignments or shared builder/material support instead of hand-authoring new scene-only setup.

## Contact

For architectural decisions or major changes, document reasoning in commit messages and update relevant docs.
