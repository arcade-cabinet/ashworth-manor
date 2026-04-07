# Ashworth Manor Structure

## Core Runtime

### Main Scene
- **File:** `res://scenes/main.tscn`
- **Role:** top-level shell for world environment, room runtime, player, interaction, audio, UI, and compiled-world coordination

### Canonical Content Layer
- **Path:** `res://declarations/`
- **Role:** rooms, world graph, regions, puzzles, items, and authored declaration data

### Runtime/Compilation Layer
- **Path:** `res://engine/`
- **Role:**
  - declaration classes
  - room assembly
  - interaction resolution
  - graph compilation
  - region/compiled-world planning
  - validation and generated test coverage

## World Model

### Authoring Units
- `RoomDeclaration` resources under `declarations/rooms/`

### Runtime Units
- compiled worlds, not isolated room loads

Current intended compiled worlds:
- `entrance_path_world`
- `manor_interior_world`
- `rear_grounds_world`
- `service_basement_world`

### Region / World Runtime
- **File:** `res://scripts/world_runtime_manager.gd`
- **Role:** active compiled world, prewarmed neighbor worlds, compiled-world lookup, transition support

### Room Lifecycle
- **File:** `res://scripts/room_manager.gd`
- **Role:**
  - assemble/load declaration rooms
  - keep compiled-world slices loaded
  - switch active room context inside the loaded compiled world
  - resolve transition profiles
  - place the player via entry/focal anchors

## Scene Graph Expectations

### Runtime Room Root
- **Script:** `res://scripts/room_base.gd`
- **Shape:**
  - `Geometry`
  - `Doors`
  - `Windows`
  - `Lighting`
  - `Interactables`
  - `Connections`
  - `Props`
  - `Audio`

### Runtime Systems
- `scripts/game_manager.gd`
  - flags, inventory, endings, global state
- `scripts/player_controller.gd`
  - tap-to-walk, swipe-to-look, embodied traversal motion
- `scripts/interaction_manager.gd`
  - declaration-driven interaction dispatch and special-case flows
- `scripts/audio_manager.gd`
  - loop playback and crossfade
- `scripts/ui_overlay.gd`
  - diegetic overlays and pause/document presentation
- `scripts/connection_mechanism.gd`
  - threshold animation/state surface
- `engine/interactable_visuals.gd`
  - scene/model resolution for dynamic visual states on interactables

## Architectural Stack

### Procedural > Model > Procedural
- Walls, floors, and ceilings are procedural textured shells
- Frame/moulding/newel/trim assets are inset models
- Doors, windows, trapdoors, ladders, and stairs should stay procedural where motion/scaling matters

### Builders
- `builders/wall_builder.gd`
- `builders/window_builder.gd`
- `builders/door_builder.gd`
- `builders/floor_builder.gd`
- `builders/ceiling_builder.gd`
- `builders/stairs_builder.gd`
- `builders/ladder_builder.gd`
- `builders/trapdoor_builder.gd`
- `builders/connection_assembly.gd`
- `builders/arch_model_fitter.gd`

## Stateful Scene Surfaces

- `res://scenes/shared/chapel/`
  - baptismal font liquid-state scenes
- `res://scenes/shared/kitchen/`
  - kitchen bucket liquid-state scenes
- `res://resources/water/`
  - tuned local water materials for pond/basin/container usage

## Traversal Rules

- Same-world `door` and `path` thresholds should default to seamless traversal
- Same-world `stairs`, `ladder`, and `trapdoor` thresholds should default to embodied traversal
- Inter-world traversal may use soft or hard masking
- Thresholds should be authored as mechanisms, not debug links

## Acceptance Surface

### Logic / Declaration
- `test/generated/test_declarations.gd`
- `test/e2e/test_declared_interactions.gd`
- `test/e2e/test_room_specs.gd`
- `test/e2e/test_full_playthrough.gd`

### Player-Perception / Visual
- `test/e2e/test_room_walkthrough.gd`
- `test/e2e/test_opening_journey.gd`

The visual lanes are part of product acceptance, not optional debug helpers.
