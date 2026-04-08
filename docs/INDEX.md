# Ashworth Manor — Documentation Index

If you need the actual shipped game, start with `GAME_BIBLE.md`. It is the
single canonical authority. Everything else is a supplement or support doc.

---

## Canonical Authority

| Document | What It Covers |
|----------|---------------|
| **[GAME_BIBLE.md](./GAME_BIBLE.md)** | **THE SINGLE SOURCE OF TRUTH.** Premise, room program, shared spine, route program, tool/light grammar, endings, and acceptance surface (repo-local + downstream). If any other doc disagrees, this wins. |
| **[SUBSTRATE_FOUNDATION.md](./SUBSTRATE_FOUNDATION.md)** | **Shared physical authority.** Primitive families, shader/material families, mount families, region matrix, and substrate decision rules. |

## Focused Supplements

These add depth to specific areas but defer to GAME_BIBLE.md on any overlap:

| Document | Focused Scope |
|----------|--------------|
| [PLAYER_PREMISE.md](./PLAYER_PREMISE.md) | Extended player-position, arrival, lighting, and emotional-frame detail. |
| [ELIZABETH_ROUTE_PROGRAM.md](./ELIZABETH_ROUTE_PROGRAM.md) | Route design rationale, divergence rules, and migration context. |
| [NARRATIVE.md](./NARRATIVE.md) | Emotional framing, narrative priorities, and memory layers. |
| [MASTER_SCRIPT.md](./MASTER_SCRIPT.md) | Stage-by-stage beat detail for script authoring. |
| [script/MASTER_SCRIPT.md](./script/MASTER_SCRIPT.md) | Authoring-oriented mirror (defers to MASTER_SCRIPT.md). |

## Execution Surface

| Document | What It Covers |
|----------|---------------|
| **[batches/hard-substrate-freeze.md](./batches/hard-substrate-freeze.md)** | **Active execution contract.** Shared substrate freeze, shared library buildout, region/preset wiring, and whole-game substrate adoption. |
| [batches/ashworth-master-task-graph.md](./batches/ashworth-master-task-graph.md) | Whole-game scope contract. The master task graph for the shipped game. |
| [batches/ralph-remaining-stories-batch.md](./batches/ralph-remaining-stories-batch.md) | Historical recovered Ralph tranche after `US-001` through `US-010`. |
| [batches/ralph-final-remaining-stories.md](./batches/ralph-final-remaining-stories.md) | Downstream finish tranche for `US-020` through `US-027`, including release-readiness blockers. |
| [../PLAN.md](../PLAN.md) | Current high-level execution priorities and product status. |
| [../MEMORY.md](../MEMORY.md) | Execution memory, discoveries, misalignments, and acceptance notes. |
| [../STRUCTURE.md](../STRUCTURE.md) | Runtime architecture, canonical source map, and acceptance surfaces. |

> **Note:** `hard-substrate-freeze.md` is the active execution contract until the
> substrate sweep is complete. The master task graph remains the whole-game
> scope contract. Other batch files are support or historical detail.

## Checkpoints

| Document | What It Covers |
|----------|---------------|
| [checkpoints/SF-001-substrate-inventory.md](./checkpoints/SF-001-substrate-inventory.md) | First hard substrate freeze census, primitive families, NAS/repo inventory, and active contract rebasing |
| [checkpoints/US-003-runtime-baseline.md](./checkpoints/US-003-runtime-baseline.md) | Runtime baseline: engine boot, active test lanes, known gaps |
| [checkpoints/shared-spine-state-map.md](./checkpoints/shared-spine-state-map.md) | Canonical state keys for shared-spine Stages 0–7, test evolution path |
| [checkpoints/adult-route-clue-topology.md](./checkpoints/adult-route-clue-topology.md) | Adult route clue chain, room biases, discovery cascade, state tracking |
| [checkpoints/elder-route-clue-topology.md](./checkpoints/elder-route-clue-topology.md) | Elder route clue chain, late-rupture grammar, burial/caretaker bias, state tracking |
| [checkpoints/child-route-clue-topology.md](./checkpoints/child-route-clue-topology.md) | Child route clue chain, blocked-architecture logic, attic false-answer grammar, state tracking |
| [checkpoints/US-010-adult-attic-resolution.md](./checkpoints/US-010-adult-attic-resolution.md) | Adult late-game transition, lantern hook, attic music box, ending trigger |
| [checkpoints/US-012-elder-crypt-resolution.md](./checkpoints/US-012-elder-crypt-resolution.md) | Elder late-game transition, cellar bypass, crypt gate latch, crypt music box, ending trigger |
| [checkpoints/US-014-child-hidden-room-resolution.md](./checkpoints/US-014-child-hidden-room-resolution.md) | Child late-game transition, attic redirect, sealed seam, sealed-room music box, ending trigger |
| [checkpoints/US-015-route-unification.md](./checkpoints/US-015-route-unification.md) | Route-context API, explicit post-third-run replay mode, route-driven playthrough harness |
| [checkpoints/US-016-critical-doc-migration.md](./checkpoints/US-016-critical-doc-migration.md) | Critical-path room docs migrated to the shipped route program |
| [checkpoints/US-017-declaration-route-migration.md](./checkpoints/US-017-declaration-route-migration.md) | Critical-path declarations now carry route-key aliases with weave shims reduced to compatibility |
| [checkpoints/US-018-automated-coverage.md](./checkpoints/US-018-automated-coverage.md) | Three-route automated regression surface and working gdUnit CLI contract |
| [checkpoints/US-019-renderer-acceptance.md](./checkpoints/US-019-renderer-acceptance.md) | Rebuilt renderer-backed manifests for opening, basement, cellar, crypt, attic, and hidden-room review |
| [checkpoints/opening-visual-diagnostic.md](./checkpoints/opening-visual-diagnostic.md) | First design-oriented read of the rebuilt opening capture surface and the current opening blockers |
| [checkpoints/US-020-visual-polish.md](./checkpoints/US-020-visual-polish.md) | Late critical-path lighting/material polish and refreshed renderer evidence |
| [checkpoints/US-021-freeze-and-convergence.md](./checkpoints/US-021-freeze-and-convergence.md) | Full repo-local freeze rerun: runtime, docs, routes, and renderer evidence converge |
| [checkpoints/US-022-archive-handoff.md](./checkpoints/US-022-archive-handoff.md) | Archived weave-era design docs and tightened contributor handoff surface |
| [checkpoints/US-023-maintenance-baseline.md](./checkpoints/US-023-maintenance-baseline.md) | Post-freeze maintenance baseline and regression register |
| [checkpoints/US-024-android-export-audit.md](./checkpoints/US-024-android-export-audit.md) | Android/export prerequisite map and local environment truth |
| [checkpoints/US-025-packaged-helper.md](./checkpoints/US-025-packaged-helper.md) | Debug-gated Maestro helper wiring and validation surface |
| [checkpoints/US-026-packaged-validation-flows.md](./checkpoints/US-026-packaged-validation-flows.md) | Packaged smoke proof and critical-path automation blocker record |
| [checkpoints/US-027-release-readiness.md](./checkpoints/US-027-release-readiness.md) | Debug APK evidence plus release-signing blocker for final RC |

## Archived Historical Docs

These are retained for reference only. They are not current route, puzzle, or
runtime truth.

| Document | Status |
|----------|--------|
| [WEAVE_ARCHITECTURE.md](./WEAVE_ARCHITECTURE.md) | Archived |
| [WEAVE_BALANCE.md](./WEAVE_BALANCE.md) | Archived |
| [WEAVE_PLAYTEST.md](./WEAVE_PLAYTEST.md) | Archived |
| [PAPER_PLAYTEST.md](./PAPER_PLAYTEST.md) | Historical / archived |

## Design and Support Docs

| Document | What It Covers |
|----------|---------------|
| [VISION.md](./VISION.md) | Design philosophy — Myst-inspired, "world that exists without you", no horror tricks |
| [ART_DIRECTION.md](./ART_DIRECTION.md) | Color palette, lighting philosophy, materials, post-processing, emotional tone |
| [puzzles/README.md](./puzzles/README.md) | Puzzle and solve-system support material |
| [items/README.md](./items/README.md) | Item catalog and support material |
| [AUDIO_WIRING_PLAN.md](./AUDIO_WIRING_PLAN.md) | Audio support plan and event wiring reference |
| [MAESTRO_E2E_PLAN.md](./MAESTRO_E2E_PLAN.md) | Android/export validation and Maestro automation direction |
| [VISUAL_ACCEPTANCE_RUBRIC.md](./VISUAL_ACCEPTANCE_RUBRIC.md) | Screenshot review contract: judge whether the experience is right, not just runnable |

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
