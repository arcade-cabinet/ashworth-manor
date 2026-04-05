# Ashworth Manor — Documentation Index

Every document in this game's design. Any agent working on this project reads this first.

---

## Master Script & Narrative

| Document | What It Covers |
|----------|---------------|
| **[MASTER_SCRIPT.md](./MASTER_SCRIPT.md)** | **START HERE.** Complete start-to-finish game experience. Every room in play order, every dialogue line, every conditional variant, every flashback, every phase transition. |
| [NARRATIVE.md](./NARRATIVE.md) | Story, characters, timeline, document catalog, themes, endings |
| [VISION.md](./VISION.md) | Design philosophy — Myst-inspired, "world that exists without you", no horror tricks |
| [ART_DIRECTION.md](./ART_DIRECTION.md) | Color palette, lighting philosophy, materials, post-processing, emotional tone |

---

## Game Systems

| Document | What It Covers |
|----------|---------------|
| [puzzles/README.md](./puzzles/README.md) | All 6 puzzles: flowcharts, flag chains, clue redundancy, counter-ritual |
| [items/README.md](./items/README.md) | Complete item catalog: keys, documents, artifacts, ritual components |
| [ADDON_EVALUATION.md](./ADDON_EVALUATION.md) | Master addon registry, rejected addons, interconnection diagram |

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

Each room has its own directory at `docs/rooms/{room}/` containing: README, floorplan, interactables, dialogue, lighting, connections, triggers, props.

### Grounds (Exterior)
| Room | Directory | Status |
|------|-----------|--------|
| Front Gate | [docs/rooms/front_gate/](./rooms/front_gate/) | TODO |
| Garden | [docs/rooms/garden/](./rooms/garden/) | TODO |
| Chapel | [docs/rooms/chapel/](./rooms/chapel/) | TODO |
| Greenhouse | [docs/rooms/greenhouse/](./rooms/greenhouse/) | TODO |
| Carriage House | [docs/rooms/carriage_house/](./rooms/carriage_house/) | TODO |
| Family Crypt | [docs/rooms/family_crypt/](./rooms/family_crypt/) | TODO |

### Ground Floor
| Room | Directory | Status |
|------|-----------|--------|
| Foyer | [docs/rooms/foyer/](./rooms/foyer/) | TODO (migrate from floors/ground-floor/foyer.md) |
| Parlor | [docs/rooms/parlor/](./rooms/parlor/) | TODO (migrate from floors/ground-floor/parlor.md) |
| Dining Room | [docs/rooms/dining_room/](./rooms/dining_room/) | TODO |
| Kitchen | [docs/rooms/kitchen/](./rooms/kitchen/) | TODO |

### Upper Floor
| Room | Directory | Status |
|------|-----------|--------|
| Upper Hallway | [docs/rooms/hallway/](./rooms/hallway/) | TODO |
| Master Bedroom | [docs/rooms/master_bedroom/](./rooms/master_bedroom/) | TODO |
| Library | [docs/rooms/library/](./rooms/library/) | TODO |
| Guest Room | [docs/rooms/guest_room/](./rooms/guest_room/) | TODO |

### Basement
| Room | Directory | Status |
|------|-----------|--------|
| Storage Basement | [docs/rooms/storage_basement/](./rooms/storage_basement/) | TODO |
| Boiler Room | [docs/rooms/boiler_room/](./rooms/boiler_room/) | TODO |

### Deep Basement
| Room | Directory | Status |
|------|-----------|--------|
| Wine Cellar | [docs/rooms/wine_cellar/](./rooms/wine_cellar/) | TODO |

### Attic
| Room | Directory | Status |
|------|-----------|--------|
| Attic Stairwell | [docs/rooms/attic_stairwell/](./rooms/attic_stairwell/) | TODO |
| Attic Storage | [docs/rooms/attic_storage/](./rooms/attic_storage/) | TODO |
| Hidden Chamber | [docs/rooms/hidden_chamber/](./rooms/hidden_chamber/) | TODO |

### Legacy Floor Docs (to be migrated into room directories)
| Floor | Overview |
|-------|----------|
| [Ground Floor](./floors/ground-floor/README.md) | Floor-level summary + [foyer.md](./floors/ground-floor/foyer.md), [parlor.md](./floors/ground-floor/parlor.md) |
| [Upper Floor](./floors/upper-floor/README.md) | Floor-level summary |
| [Basement](./floors/basement/README.md) | Floor-level summary |
| [Deep Basement](./floors/deep-basement/README.md) | Floor-level summary |
| [Attic](./floors/attic/README.md) | Floor-level summary |

---

## What a Complete Room Doc Contains

Every room doc must include (see [foyer.md](./floors/ground-floor/foyer.md) as reference):

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

1. **Write room docs** for all 18 undocumented rooms (docs-first, no code without spec)
2. **Build tests** from room specs (gdUnit4 validates every room against its doc)
3. **Create .tres resources** for all interactables and connections
4. **Write .dialogue files** for all rooms with conditional text
5. **Rebuild .tscn scenes** with all interactables, lighting, connections, footstep tags
6. **Integrate addons** — wire up dialogue, inventory, audio, camera, HSM
7. **Run full test suite** — every room passes structure + content + connection tests
