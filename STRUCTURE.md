# Ashworth Manor Structure

## Core Runtime

### Main Scene

- **File:** `res://scenes/main.tscn`
- **Role:** top-level shell for world environment, room runtime, player,
  interaction, audio, UI, and compiled-world coordination

### Canonical Content Layer

- **Path:** `res://declarations/`
- **Role:** rooms, world graph, regions, puzzles, items, and authored
  declaration data

### Runtime / Compilation Layer

- **Path:** `res://engine/`
- **Role:**
  - declaration classes
  - room assembly
  - interaction resolution
  - graph compilation
  - region and compiled-world planning
  - substrate preset and mount resolution
  - validation and generated test coverage

## Canonical Surfaces

### Narrative Authority

`docs/GAME_BIBLE.md` is the single canonical authority for the shipped game.
If any other doc disagrees with it, GAME_BIBLE.md wins.

### Substrate Authority

`docs/SUBSTRATE_FOUNDATION.md` is the single canonical authority for the shared
physical language of the game. If a room or builder bypasses it, that usage
needs an explicit waiver.

### Active Execution Contract

`docs/batches/hard-substrate-freeze.md` is the active execution contract while
the substrate is being rebuilt and reapplied across the whole game.

### Whole-Game Scope Contract

`docs/batches/ashworth-master-task-graph.md` remains the whole-game task graph
and ship-scope contract.

### Focused Supplements (canonical, defer to GAME_BIBLE on overlap)

- `docs/PLAYER_PREMISE.md` — extended player-position and arrival detail
- `docs/ELIZABETH_ROUTE_PROGRAM.md` — route design rationale
- `docs/NARRATIVE.md` — emotional framing and narrative priorities
- `docs/MASTER_SCRIPT.md` — stage-by-stage beat authoring
- `docs/script/MASTER_SCRIPT.md` — authoring mirror

### Historical / Support Surfaces

- Room docs under `docs/rooms/` — support material, canonical only when
  migrated to match GAME_BIBLE
- Floor-level overviews under `docs/floors/` — legacy reference only
- Individual batch files under `docs/batches/` (other than the master task
  graph) — historical implementation detail, superseded by master task graph
- Weave-era design artifacts:
  - `docs/WEAVE_ARCHITECTURE.md`
  - `docs/WEAVE_BALANCE.md`
  - `docs/WEAVE_PLAYTEST.md`
  - `docs/PAPER_PLAYTEST.md`
  These are archived historical references, not current route or puzzle truth.
- Any doc or declaration text that still assumes the old
  `Captive / Mourning / Sovereign` weave — legacy material pending migration

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

Route-specific late spaces should still resolve through declaration-first
assembly even when they temporarily change traversal logic or active-world
composition.

### Region / World Runtime

- **File:** `res://scripts/world_runtime_manager.gd`
- **Role:** active compiled world, prewarmed neighbor worlds, compiled-world
  lookup, transition support

### Room Lifecycle

- **File:** `res://scripts/room_manager.gd`
- **Role:**
  - assemble and load declaration rooms
  - keep compiled-world slices loaded
  - switch active room context inside the loaded compiled world
  - resolve transition profiles
  - place the player via entry and focal anchors

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
- **Notable runtime API:**
  - `tween_light_energy(light_id, target_energy, duration)`
  - `set_light_energy(light_id, value)` for persistent authored light states

### Runtime Systems

- `scripts/game_manager.gd`
  - flags, inventory, endings, global state
- `scripts/player_controller.gd`
  - tap-to-walk, swipe-to-look, embodied traversal motion
- `scripts/interaction_manager.gd`
  - declaration-driven interaction dispatch and special-case flows
  - opening packet/valise handling
  - persistent foyer/parlor light-state sync on room load
  - first-warmth hearth handling that starts the firebrand phase
  - first kitchen service-hatch seizure that drops the player into the service
    basement and clears the firebrand phase
- `scripts/audio_manager.gd`
  - loop playback, crossfade, and direct-path SFX playback for authored event
    cues
- `scripts/ui_overlay.gd`
  - diegetic overlays and document presentation
- `scripts/connection_mechanism.gd`
  - threshold animation and state surface
- `engine/interactable_visuals.gd`
  - scene and model resolution for dynamic visual states on interactables

## Story Progression Grammar

### Route Order

- first completion: `Adult`
- second completion: `Elder`
- third completion: `Child`

### Tool Phases

- `firebrand`
- `walking stick`
- `lantern hook`

### Light Phases

- early improvised personal light
- midgame restored estate light
- late-game loss of stable house light

## Architectural Stack

### Substrate-First Policy

- primary architecture, terrain, hedges, gates, roads, water, glass, and sky
  must resolve through shared builders, shaders, and factories
- imported models are reserved for props and hero objects
- declarations remain canonical; the substrate is a richer implementation layer
  underneath them

### Declaration-Facing Substrate Types

- `SubstratePresetDecl`
- `MaterialRecipeDecl`
- `TerrainPresetDecl`
- `SkyPresetDecl`
- `MountSlotDecl`
- `MountPayloadDecl`

### Shared Substrate Registries

- `builders/estate_material_kit.gd`
- `builders/pbr_texture_kit.gd`
- `builders/estate_environment_registry.gd`
- `builders/estate_substrate_registry.gd`

### Environment-Owned Surface Grammar

- `EnvironmentDeclaration.surface_recipe_overrides` is now the shared region
  grammar for:
  - `floor`
  - `wall`
  - `ceiling`
  - `threshold`
  - `door`
  - `gate_leaf`
  - `window`
  - `stair_tread`
  - `stair_structure`
  - `stair_rail`
  - `ladder_rail`
  - `ladder_rung`
- `RoomAssembler` resolves those roles before legacy per-room/per-connection
  texture strings
- `DoorBuilder`, `WindowBuilder`, and `ConnectionAssembly` now consume that
  environment-owned grammar while preserving legacy texture strings only as
  compatibility/model-selection fallbacks
- `StairsBuilder` and `LadderBuilder` now consume the same environment-owned
  role grammar, so circulation thresholds no longer sit on hardcoded material
  defaults

### Procedural > Model > Procedural

- walls, floors, and ceilings are shared procedural shells
- frame, moulding, newel, and trim assets are inset models where they earn
  their keep
- doors, windows, trapdoors, ladders, and stairs should stay procedural where
  motion or scaling matters

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
- `builders/shape_kit.gd`

### Shader / Material Families

- `estate_surface`
- `estate_foliage`
- `estate_terrain`
- `estate_glass`
- `estate_water`
- `estate_sky_twilight`

### Stable Mount Families

- `wall`
- `floor`
- `ceiling`
- `threshold`
- `gate_leaf`
- `table`
- `shelf`
- `sill`
- `mantel`
- `path_edge`
- `hedge_terminator`
- `water_edge`
- `facade_anchor`

## Stateful Scene Surfaces

- `res://scenes/shared/chapel/`
  - baptismal font liquid-state scenes
- `res://scenes/shared/kitchen/`
  - kitchen bucket liquid-state scenes
- `res://resources/water/`
  - tuned local water materials for pond, basin, and container usage

## Traversal Rules

- same-world `door` and `path` thresholds should default to seamless traversal
- same-world `stairs`, `ladder`, and `trapdoor` thresholds should default to
  embodied traversal
- inter-world traversal may use soft or hard masking
- thresholds should be authored as mechanisms, not debug links

## Acceptance Surface

### Logic / Declaration

- `test/generated/test_declarations.gd`
- `test/e2e/test_declared_interactions.gd`
- `test/e2e/test_room_specs.gd`
- `test/e2e/test_full_playthrough.gd`

### Player-Perception / Visual

- `test/e2e/test_room_walkthrough.gd`
- `test/e2e/test_opening_journey.gd`
- `test/e2e/test_environment_probe.gd`

The visual lanes are part of product acceptance, not optional debug helpers.
