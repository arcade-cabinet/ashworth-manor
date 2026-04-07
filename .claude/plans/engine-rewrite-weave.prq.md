# PRD: Ashworth Engine Rewrite + Weave System

**Created**: 2026-04-05
**Version**: 1.0
**Timeframe**: Multi-sprint (5 phases, sequential)
**Priority**: P0 - Complete rebuild of game engine and narrative system

## Overview

Replace the current hand-built room scenes and hardcoded game scripts with a fully data-driven engine. Every room, puzzle, item, connection, trigger, and narrative variant is declared once in `.tres` resource files. The engine interprets declarations at runtime to generate scenes, handle interactions, manage state, and run tests. On top of this engine, implement the Weave system: 3 macro threads (Captive/Mourning/Sovereign), 6 diamond junctions, 3 swap puzzles, PRNG seed variation, producing 48 unique playthrough configurations.

## Source Documents

| Document | Role |
|----------|------|
| `docs/ENGINE_SPEC.md` | Declaration format, resource classes, engine architecture, PSX sky shader, addon integration |
| `docs/WEAVE_ARCHITECTURE.md` | 3 macro threads, diamonds, swaps, junction system, content inventory |
| `docs/WEAVE_BALANCE.md` | Per-room content budget, total content counts, agent team breakdown |
| `docs/WEAVE_PLAYTEST.md` | Validated playtests showing zero gaps |
| `docs/PAPER_PLAYTEST.md` | All gaps found and fixed in declaration format |
| `docs/INTERACTIVE_DOORS_PLAN.md` | Door/window system using Mansion PSX kit models |
| `docs/AUDIO_WIRING_PLAN.md` | How all 280 audio files connect to game systems |
| `docs/UNRESOLVED.md` | Room scale, player position, exterior spaces questions |

## Asset Inventory

- 571 GLB models (shared 131, per-room 229, horror 6, medieval 175, mansion_psx 20)
- 280 audio files (loops 36, tension 10, SFX 234)
- 531 textures (mansion 65, SBS horror 200, retro doors/windows 240, medieval 191, mansion_psx 5)
- 19 fonts (Cinzel 7, Cormorant 12)

## Current State

- `scripts/` has old hand-built scripts (game_manager, room_manager, interaction_manager, etc.)
- `scenes/rooms/` has 20 hand-built .tscn files (to be replaced by engine-generated scenes)
- `shaders/` has psx_dither.gdshader and psx_fade.gdshader (keep)
- `scripts/procedural/` has door_single.gd, door_double.gd (partial, to be replaced by builders)
- `engine/declarations/world_declaration.gd` exists as a skeleton (to be expanded)
- All 20 room docs exist at `docs/rooms/{room}/` with README, floorplan, interactables, dialogue, lighting, connections, triggers, props
- No `declarations/` directory yet (the .tres data files)
- No `builders/` directory yet

---

## Phase 1: ENGINE FOUNDATION

Build all Resource class scripts, builder scripts, engine scripts, and the PSX sky shader. This is the pure infrastructure layer. No game content yet -- just the system that interprets declarations.

### Agent Role: Engine Coder
### Estimated: ~3,000 LOC across ~36 scripts

---

## Phase 2: ROOM DECLARATIONS

Convert all 20 rooms from their room docs into `.tres` declaration files. Also create world.tres, state_schema.tres, all item declarations, all connection declarations, and environment presets. This is data entry, not code -- translating the existing docs into the structured resource format.

### Agent Role: Room Assembler (Data Entry)
### Estimated: ~60 .tres files

---

## Phase 3: CREATIVE CONTENT

Write all thread-variant dialogue text (~90 entries across 3 macro threads), 9 key narrative texts (3 diaries, 3 letters, 3 final notes), 6 ending text sequences, and puzzle clue text for all junction variants. This is the writing work that makes the Weave system real.

### Agent Role: Narrative Writer
### Estimated: ~15,000 words of narrative text

---

## Phase 4: JUNCTION + PUZZLE IMPLEMENTATION

Implement all 12 diamond puzzle variants (6 puzzles x 2 paths), 6 swap puzzle implementations (3 rooms x 2 variants), the PRNG engine, junction resolution, constraint validation, and puzzle dependency graph verification.

### Agent Role: Puzzle Designer + Coder
### Estimated: ~1,500 LOC + puzzle declarations

---

## Phase 5: INTEGRATION + TESTING

Wire all addons (11 addons per ENGINE_SPEC addon integration map), generate tests from declarations, validate all 48 configurations, run bidirectional connection checks, and build Android APK.

### Agent Role: Test Generator + QA
### Estimated: ~1,000 LOC tests + integration work

---

## Tasks

### Phase 1: ENGINE FOUNDATION

- [ ] P1-01: Create all 20 Resource class scripts (declarations/)
- [ ] P1-02: Create 8 builder scripts (builders/)
- [ ] P1-03: Create room_assembler.gd (engine/)
- [ ] P1-04: Create interaction_engine.gd (engine/)
- [ ] P1-05: Create puzzle_engine.gd (engine/)
- [ ] P1-06: Create state_machine.gd with expression parser (engine/)
- [ ] P1-07: Create audio_engine.gd (engine/)
- [ ] P1-08: Create trigger_engine.gd (engine/)
- [ ] P1-09: Create prng_engine.gd (engine/)
- [ ] P1-10: Create test_generator.gd (engine/)
- [ ] P1-11: Create PSX sky shader (shaders/psx_sky.gdshader)

### Phase 2: ROOM DECLARATIONS

- [ ] P2-01: Create world.tres (top-level game definition)
- [ ] P2-02: Create state_schema.tres (all state variables)
- [ ] P2-03: Create 6 environment declarations (per-area presets)
- [ ] P2-04: Create all Connection resources in world.tres
- [ ] P2-05: Create PlayerDeclaration in world.tres
- [ ] P2-06: Declare Front Gate room
- [ ] P2-07: Declare Foyer room
- [ ] P2-08: Declare Parlor room
- [ ] P2-09: Declare Dining Room
- [ ] P2-10: Declare Kitchen
- [ ] P2-11: Declare Upper Hallway
- [ ] P2-12: Declare Master Bedroom
- [ ] P2-13: Declare Library
- [ ] P2-14: Declare Guest Room
- [ ] P2-15: Declare Storage Basement
- [ ] P2-16: Declare Boiler Room
- [ ] P2-17: Declare Wine Cellar
- [ ] P2-18: Declare Attic Stairwell
- [ ] P2-19: Declare Attic Storage
- [ ] P2-20: Declare Hidden Chamber
- [ ] P2-21: Declare Garden
- [ ] P2-22: Declare Chapel
- [ ] P2-23: Declare Greenhouse
- [ ] P2-24: Declare Carriage House
- [ ] P2-25: Declare Family Crypt
- [ ] P2-26: Create all Item declarations (~30 items)
- [ ] P2-27: Create all 6 Puzzle declarations
- [ ] P2-28: Create 5 Ending declarations (3 positive + 2 negative)

### Phase 3: CREATIVE CONTENT

- [ ] P3-01: Write 3 MacroThread declarations (captive, mourning, sovereign)
- [ ] P3-02: Write Captive thread-variant texts (~30 interactables)
- [ ] P3-03: Write Mourning thread-variant texts (~30 interactables)
- [ ] P3-04: Write Sovereign thread-variant texts (~30 interactables)
- [ ] P3-05: Write 3 diary page texts (one per macro thread)
- [ ] P3-06: Write 3 Elizabeth letter texts (one per macro thread)
- [ ] P3-07: Write 3 Elizabeth final note texts (one per macro thread)
- [ ] P3-08: Write 3 ritual sequence texts (one per macro thread)
- [ ] P3-09: Write Freedom ending text (5 lines)
- [ ] P3-10: Write Forgiveness ending text (5 lines)
- [ ] P3-11: Write Acceptance ending text (5 lines)
- [ ] P3-12: Write Escape ending text (shared, 5 lines)
- [ ] P3-13: Write Joined ending text (shared, 5 lines)

### Phase 4: JUNCTION + PUZZLE IMPLEMENTATION

- [ ] P4-01: Create 9 JunctionDecl resources (6 diamonds + 3 swaps)
- [ ] P4-02: Implement Diamond #1 variants: Globe puzzle (A) + Gear puzzle (B) for attic key
- [ ] P4-03: Implement Diamond #2 variants: Doll puzzle (A) + Mask puzzle (B) for hidden key
- [ ] P4-04: Implement Diamond #3 variants: Portrait trail (A) + Hearth flagstone (B) for cellar key
- [ ] P4-05: Implement Diamond #4 variants: Crypt flagstone (A) + Garden lily (B) for jewelry key
- [ ] P4-06: Implement Diamond #5 variants: Greenhouse pot (A) + Chapel font (B) for gate key
- [ ] P4-07: Implement Diamond #6 variants: Ritual of Reversal (A) + Ritual of Forgiveness (B) for ending
- [ ] P4-08: Implement Swap #1: Foyer clock puzzle (A) + mirror puzzle (B)
- [ ] P4-09: Implement Swap #2: Boiler room pipe valve (A) + electrical panel (B)
- [ ] P4-10: Implement Swap #3: Garden fountain (A) + gazebo lattice (B)
- [ ] P4-11: Implement PRNG junction resolution with macro_preference
- [ ] P4-12: Implement constraint validation (dependency graph, solvability check)

### Phase 5: INTEGRATION + TESTING

- [ ] P5-01: Wire godot-psx (global dither + fade + sky shader)
- [ ] P5-02: Wire godot_dialogue_manager (generate .dialogue from declarations)
- [ ] P5-03: Wire gloot inventory (ProtoTree from ItemDeclarations)
- [ ] P5-04: Wire AdaptiSound (3-layer audio per room)
- [ ] P5-05: Wire godot-material-footsteps (9 surface types)
- [ ] P5-06: Wire phantom-camera (inspection + room reveal)
- [ ] P5-07: Wire limboai HSM (game phases + Elizabeth sub-HSM)
- [ ] P5-08: Wire shaky-camera-3d (shake profiles from ActionDecl)
- [ ] P5-09: Wire quest-system (auto-generate from PuzzleDeclaration)
- [ ] P5-10: Wire SaveMadeEasy (serialize StateSchema + PRNG seed)
- [ ] P5-11: Generate tests from declarations (test_generator.gd output)
- [ ] P5-12: Validate all 48 configurations (3 threads x 2 paths x 8 swaps)
- [ ] P5-13: Validate bidirectional connections (34 connections, each A->B has B->A)
- [ ] P5-14: Validate puzzle dependency graph per thread (no dead ends)
- [ ] P5-15: Run headless E2E test suite
- [ ] P5-16: Android APK build + smoke test

## Dependencies

### Phase Dependencies (Sequential)
- Phase 2 depends on Phase 1 (need Resource classes before .tres data)
- Phase 3 depends on Phase 1 (need MacroThread resource class)
- Phase 4 depends on Phase 1 + Phase 2 + Phase 3 (need engine + rooms + text)
- Phase 5 depends on Phase 1 + Phase 2 + Phase 3 + Phase 4 (need everything)

### Within-Phase Parallelism
- Phase 1: P1-01 must complete first (Resource classes). Then P1-02..P1-11 can parallel.
- Phase 2: P2-01..P2-05 must complete first (world scaffolding). Then P2-06..P2-28 can parallel.
- Phase 3: P3-01 must complete first (MacroThread declarations). Then P3-02..P3-13 can parallel.
- Phase 4: P4-01 must complete first (JunctionDecl resources). Then P4-02..P4-10 can parallel. P4-11..P4-12 after puzzles.
- Phase 5: P5-01..P5-10 can parallel. P5-11..P5-16 sequential after addon wiring.

## Acceptance Criteria (Summary)

- All 20 Resource class scripts parse without error in Godot 4.6
- All 8 builders generate geometry from declarations
- Room assembler produces complete Node3D tree from any RoomDeclaration
- State expression parser handles AND/OR/NOT/HAS/VISITED/comparisons
- All 20 room .tres files load and validate
- All 34 connections are bidirectional
- All 3 macro threads have complete text variants
- All 9 junctions have A+B variants with puzzle steps
- PRNG engine resolves seed -> thread + junctions -> patched declarations
- Constraint validator confirms all 48 configurations are solvable
- All 11 addons wired per ENGINE_SPEC integration map
- Tests generated from declarations pass
- Android APK builds and launches

## Risks

| Risk | Mitigation |
|------|------------|
| Room assembler complexity (250-300 LOC) | Single-purpose builders isolate geometry generation |
| State expression parser bugs | Exhaustive test cases from PAPER_PLAYTEST scenarios |
| PRNG creating unsolvable configurations | Constraint validation rejects invalid shuffles |
| 48 configurations too many to manually QA | Test generator automates verification |
| Thread text quality inconsistent | One writer per thread, cross-review |
| Addon API changes in Godot 4.6 | Pin addon versions in plug.gd |

## Technical Notes

- All declarations are Godot Resource (.tres) files with @export vars
- Engine scripts go in `engine/`, builders in `builders/`, declarations data in `declarations/`
- Old `scripts/` directory retained during migration, deprecated scripts removed in Phase 5
- PSX sky shader is `shader_type sky`, no TIME uniform, cached radiance cubemap
- Wall layout strings use format: "wall" | "doorway:{connection_id}" | "window" | "window_boarded"
- Connection IDs follow convention: "{from_room}_to_{to_room}"
- State expressions: "flag_name", "NOT flag", "A AND B", "HAS item", "VISITED room", "var >= N"
