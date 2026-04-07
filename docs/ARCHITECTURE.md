# Architecture Overview

This document describes the shipped technical architecture of Ashworth Manor.

## Source Of Truth

Ashworth Manor is now a declaration-driven Godot game.

The authoritative content lives in:
- `declarations/world.tres`
- `declarations/rooms/*.tres`
- `declarations/puzzles/*.tres`
- `declarations/endings/*.tres`
- `declarations/threads/*.tres`
- `declarations/state_schema.tres`

Legacy `.tscn` room scenes are reference or fallback material only. They are not the primary game implementation path.

## Runtime Shape

```text
main.tscn
├── managers and autoload integrations
├── player / camera shell
├── room manager
├── interaction manager
├── room events
├── audio manager
└── UI overlay
        │
        ▼
RoomManager loads world declaration
        │
        ▼
RoomAssembler builds current room from declaration data
        │
        ▼
room_base.gd exposes runtime room API
```

## Core Responsibilities

### `scripts/game_manager.gd`
- Global state, inventory, flags, visited rooms, save/load
- Macro-thread assignment and generic declaration state access
- Ending condition support

### `scripts/room_manager.gd`
- Boot path starts in `front_gate`
- Loads room declarations from `world.tres`
- Uses the assembler/builders to construct a runtime room
- Handles transitions, spawn placement, and room lifecycle

### `engine/room_assembler.gd`
- Converts a `RoomDeclaration` into live scene nodes
- Creates geometry, props, lights, interactables, and connections
- Attaches declaration metadata to runtime nodes for interaction/event resolution

### `scripts/room_base.gd`
- Runtime room API for:
  - spawn position / rotation
  - interactable lookup
  - connection lookup
  - light lookup and light energy control

### `scripts/interaction_manager.gd`
- Dispatches runtime interactions
- Resolves declaration-authored responses through the interaction engine
- Handles remaining special-case puzzle logic where needed
- Gates room transitions and front-gate ending behavior

### `scripts/room_events.gd`
- Runs declaration on-entry, conditional, and ambient events
- Applies authored actions such as text, SFX, light changes, and camera shake

### `scripts/ui_overlay.gd`
- Diegetic document display
- Room-name presentation
- Ending presentation

## Data Model

### Rooms
Each room declaration defines:
- dimensions and surface textures
- wall layout / doorway layout
- spawn position
- ambient loop and environment preset
- props
- lights
- interactables
- entry / conditional / ambient triggers

### Interactables
Interactables are authored declaratively with:
- stable `id`
- type
- position / wall anchor / collision bounds
- response list
- optional thread responses
- optional model / effects metadata

### Connections
Connections are validated at the world level and materialized by builders at runtime.
The live graph includes:
- overt room connections
- staged discovery-exterior routing
- the current service/secret route to `carriage_house`

### Secret Passages
Secret passages are first-class declarations, not ad hoc booleans on doors.
They include:
- endpoints
- spatial anchors
- reveal/discovery rules
- presentation data

## Boot And Progression

The current boot contract is:
1. game starts in `front_gate`
2. player acknowledges the threshold
3. transition to `foyer`
4. mansion progression unfolds from the declaration world graph

There is no detached landing screen in the shipped runtime path.

## Validation Model

The active acceptance lanes are:
- boot smoke: `godot --headless --path . --quit-after 1`
- declaration validation: `test/generated/test_declarations.gd`
- runtime interaction contract: `test/e2e/test_declared_interactions.gd`
- room spec validation: `test/e2e/test_room_specs.gd`
- end-to-end progression: `test/e2e/test_full_playthrough.gd`
- all-room walkthrough: `test/e2e/test_room_walkthrough.gd`

These tests target the declaration runtime, not the legacy room-scene model.

## Design Constraints

- Treat declarations as canonical.
- Prefer extending declaration/runtime support over adding new hardcoded branches.
- Keep docs, declarations, and tests aligned in the same change.
- Do not collapse the whole exterior back into `front_gate`.
- Treat the front approach as a sequence inside a broader estate-grounds world.
