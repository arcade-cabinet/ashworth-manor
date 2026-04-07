# Ashworth Manor — Documentation Index

This index now distinguishes canonical source-of-truth docs from support and
legacy material.

If you need the actual shipped game, start with the canonical surface below.

---

## Canonical Surface

| Document | What It Covers |
|----------|---------------|
| **[GAME_BIBLE.md](./GAME_BIBLE.md)** | **START HERE.** Whole-game canonical reference: premise, room program, shared spine, routes, tools, endings, and acceptance surface. |
| **[MASTER_SCRIPT.md](./MASTER_SCRIPT.md)** | Canonical narrative spine and stage order. |
| [PLAYER_PREMISE.md](./PLAYER_PREMISE.md) | Playable-present framing, player position, packet, arrival, and lighting doctrine. |
| [ELIZABETH_ROUTE_PROGRAM.md](./ELIZABETH_ROUTE_PROGRAM.md) | The three-route authored structure: `Adult`, `Elder`, `Child`. |
| [NARRATIVE.md](./NARRATIVE.md) | Story overview, route signatures, shared spine, and narrative priorities. |
| [script/MASTER_SCRIPT.md](./script/MASTER_SCRIPT.md) | Script-facing mirror of the canonical story spine. |

## Execution Surface

| Document | What It Covers |
|----------|---------------|
| **[batches/ashworth-master-task-graph.md](./batches/ashworth-master-task-graph.md)** | **Primary execution contract.** Full implementation graph for the whole game. |
| [../PLAN.md](../PLAN.md) | Current high-level execution priorities and product status. |
| [../MEMORY.md](../MEMORY.md) | Execution memory, discoveries, misalignments, and acceptance notes. |
| [../STRUCTURE.md](../STRUCTURE.md) | Runtime architecture, canonical source map, and acceptance surfaces. |

## Design and Support Docs

| Document | What It Covers |
|----------|---------------|
| [VISION.md](./VISION.md) | Design philosophy — Myst-inspired, "world that exists without you", no horror tricks |
| [ART_DIRECTION.md](./ART_DIRECTION.md) | Color palette, lighting philosophy, materials, post-processing, emotional tone |
| [puzzles/README.md](./puzzles/README.md) | Puzzle and solve-system support material |
| [items/README.md](./items/README.md) | Item catalog and support material |
| [AUDIO_WIRING_PLAN.md](./AUDIO_WIRING_PLAN.md) | Audio support plan and event wiring reference |
| [MAESTRO_E2E_PLAN.md](./MAESTRO_E2E_PLAN.md) | Android/export validation and Maestro automation direction |

---

## Game Systems and Support Plans

| Document | What It Covers |
|----------|---------------|
| [ADDON_EVALUATION.md](./ADDON_EVALUATION.md) | Master addon registry, rejected addons, interconnection diagram |
| [INTERACTIVE_DOORS_PLAN.md](./INTERACTIVE_DOORS_PLAN.md) | Procedural door/window frames and threshold implementation support |

---

## Addon Integration Plans

Each addon has a focused plan doc in `docs/addons/`:

| Plan | Addon | Key Decision |
|------|-------|-------------|
| [shader-plan.md](./addons/shader-plan.md) | godot-psx | Screen-space ONLY. No per-material shaders on PSX assets. Delete custom shaders. |
| [dialogue-plan.md](./addons/dialogue-plan.md) | godot_dialogue_manager | Document/observation system, NOT NPC dialogue. `.dialogue` files per room. |
| [inventory-plan.md](./addons/inventory-plan.md) | gloot | Resource-based inventory with ProtoTree. Wraps GameManager API. |
| [audio-plan.md](./addons/audio-plan.md) | AdaptiSound | 3-layer audio (base + tension + stinger). Reverb zones per room type. |
| [footsteps-plan.md](./addons/footsteps-plan.md) | godot-material-footsteps | **TO INSTALL.** 9 surface types, metadata detection on floor meshes. |
| [phantom-camera-plan.md](./addons/phantom-camera-plan.md) | phantom-camera | **TO INSTALL.** Document inspection zoom + ending cinematics. |
| [state-machine-plan.md](./addons/state-machine-plan.md) | limboai | **TO INSTALL.** HSM for game phases + Elizabeth presence. |
| [camera-fx-plan.md](./addons/camera-fx-plan.md) | shaky-camera-3d | Subtle shake for horror moments only. No strobing. |
| [quest-plan.md](./addons/quest-plan.md) | quest-system | 6 quests for player-visible puzzle progress. Flags remain for granular state. |
| [save-plan.md](./addons/save-plan.md) | SaveMadeEasy | Encrypted save. Auto-save on room transitions. |
| [testing-plan.md](./addons/testing-plan.md) | gdUnit4 | Per-room structure, interactable, connection, puzzle, lighting, ending tests. |

---

## Room Directories

Each room has its own directory at `docs/rooms/{room}/`.

Important:

- room folders are support material unless and until they are migrated to match
  the canonical surface
- when a room folder disagrees with `GAME_BIBLE.md` or the canonical top-level
  docs, the canonical top-level docs win

### Grounds (Exterior)
| Room | Directory | Status |
|------|-----------|--------|
| Front Gate | [docs/rooms/front_gate/](./rooms/front_gate/) | Active |
| Garden | [docs/rooms/garden/](./rooms/garden/) | Active |
| Chapel | [docs/rooms/chapel/](./rooms/chapel/) | Active |
| Greenhouse | [docs/rooms/greenhouse/](./rooms/greenhouse/) | Active |
| Carriage House | [docs/rooms/carriage_house/](./rooms/carriage_house/) | Active |
| Family Crypt | [docs/rooms/family_crypt/](./rooms/family_crypt/) | Active |

### Ground Floor
| Room | Directory | Status |
|------|-----------|--------|
| Foyer | [docs/rooms/foyer/](./rooms/foyer/) | Active |
| Parlor | [docs/rooms/parlor/](./rooms/parlor/) | Active |
| Dining Room | [docs/rooms/dining_room/](./rooms/dining_room/) | Active |
| Kitchen | [docs/rooms/kitchen/](./rooms/kitchen/) | Active |

### Upper Floor
| Room | Directory | Status |
|------|-----------|--------|
| Upper Hallway | [docs/rooms/hallway/](./rooms/hallway/) | Active |
| Master Bedroom | [docs/rooms/master_bedroom/](./rooms/master_bedroom/) | Active |
| Library | [docs/rooms/library/](./rooms/library/) | Active |
| Guest Room | [docs/rooms/guest_room/](./rooms/guest_room/) | Active |

### Basement
| Room | Directory | Status |
|------|-----------|--------|
| Storage Basement | [docs/rooms/storage_basement/](./rooms/storage_basement/) | Active |
| Boiler Room | [docs/rooms/boiler_room/](./rooms/boiler_room/) | Active |

### Deep Basement
| Room | Directory | Status |
|------|-----------|--------|
| Wine Cellar | [docs/rooms/wine_cellar/](./rooms/wine_cellar/) | Active |

### Attic
| Room | Directory | Status |
|------|-----------|--------|
| Attic Stairwell | [docs/rooms/attic_stairwell/](./rooms/attic_stairwell/) | Active |
| Attic Storage | [docs/rooms/attic_storage/](./rooms/attic_storage/) | Active |
| Hidden Chamber | [docs/rooms/hidden_chamber/](./rooms/hidden_chamber/) | Active |

### Legacy Floor Docs (reference/overview only)
| Floor | Overview |
|-------|----------|
| [Ground Floor](./floors/ground-floor/README.md) | Floor-level summary + [foyer.md](./floors/ground-floor/foyer.md), [parlor.md](./floors/ground-floor/parlor.md) |
| [Upper Floor](./floors/upper-floor/README.md) | Floor-level summary |
| [Basement](./floors/basement/README.md) | Floor-level summary |
| [Deep Basement](./floors/deep-basement/README.md) | Floor-level summary |
| [Attic](./floors/attic/README.md) | Floor-level summary |

---

## What a Complete Room Doc Contains

Every room doc should eventually include:

1. **Room Overview** — Narrative purpose, what it feels like
2. **Specifications** — Dimensions, materials, atmosphere (ambient_darkness, fog)
3. **Layout Diagram** — ASCII floor plan with labeled elements
4. **Connections** — Doors/stairs/ladders to other rooms with positions
5. **Lighting** — Every light source: type, position, color, intensity, flickering, shadows
6. **Interactables** — Every interactable object with:
   - ID, type, position, scale
   - Content text (all conditional variants)
   - Narrative function
   - Visual design notes
   - Flags set on interaction
   - Puzzle connections
7. **Events** — First entry events, conditional events, timed events
8. **Atmosphere Notes** — Visual, audio, narrative tone
9. **Developer Notes** — Entry point, spawn position, performance notes

---

## Implementation Order

1. Update declarations first for room/world/item/puzzle changes
2. Sync canonical top-level docs with the live declaration behavior
3. Sync critical-path room docs under `docs/rooms/`
4. Extend declaration/runtime tests for interactions, routing, and endings
5. Touch legacy floor docs only when they add overview value or need de-staling
6. Run the acceptance lanes: boot, declarations, interaction E2E, room specs,
   full playthrough, walkthrough
