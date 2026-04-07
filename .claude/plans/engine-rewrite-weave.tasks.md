# Batch: Ashworth Engine Rewrite + Weave System

**Created**: 2026-04-05
**Config**: stop_on_failure=false, auto_commit=true
**Source PRD**: `.claude/plans/engine-rewrite-weave.prq.md`
**JSON Config**: `.claude/plans/engine-rewrite-weave.task-batch.json`

## Execution Summary

| Phase | Tasks | Depends On | Parallelism |
|-------|-------|------------|-------------|
| 1. Engine Foundation | 11 tasks | None | P1-01 first, then P1-02..P1-11 parallel |
| 2. Room Declarations | 28 tasks | Phase 1 | P2-01..P2-05 first, then P2-06..P2-28 parallel |
| 3. Creative Content | 13 tasks | Phase 1 | P3-01 first, then P3-02..P3-13 parallel |
| 4. Junction + Puzzle | 12 tasks | Phases 1+2+3 | P4-01 first, then P4-02..P4-10 parallel, P4-11..P4-12 last |
| 5. Integration + Testing | 16 tasks | Phases 1-4 | P5-01..P5-10 parallel, P5-11..P5-16 sequential |
| **Total** | **80 tasks** | | |

---

## Phase 1: ENGINE FOUNDATION (11 tasks)

Agent Role: **Engine Coder** -- ~3,000 LOC

1. [P1] **P1-01**: Create all 20+ Resource class scripts (engine/declarations/)
   - Files: 34 .gd scripts (WorldDeclaration, RoomDeclaration, InteractableDecl, ResponseDecl, ProgressionStep, LightDecl, PropDecl, Connection, RoomRef, MacroThread, JunctionDecl, VariantDecl, PuzzleDeclaration, PuzzleStepDecl, PuzzleVariation, ClueDecl, ItemDeclaration, EndingDecl, PhaseDecl, PhaseTransition, ElizabethStateDecl, ElizabethTransition, GlobalTrigger, TriggerDecl, ActionDecl, AmbientEventDecl, ConditionalEventDecl, FlashbackDecl, StateSchema, StateVarDecl, PlayerDeclaration, AccessibilityDecl, SkyDeclaration, EnvironmentDeclaration)
   - Criteria: All parse in Godot 4.6, @export vars match ENGINE_SPEC exactly

2. [P1] **P1-02**: Create 8 builder scripts (builders/)
   - Files: wall_builder.gd, floor_builder.gd, ceiling_builder.gd, door_builder.gd, window_builder.gd, stairs_builder.gd, trapdoor_builder.gd, ladder_builder.gd
   - Criteria: Each generates Node3D from declaration data, collision layers correct
   - Depends: P1-01

3. [P1] **P1-03**: Create room_assembler.gd (engine/)
   - Files: engine/room_assembler.gd (250-300 LOC)
   - Criteria: Accepts RoomDeclaration, returns complete Node3D tree with Geometry/Doors/Windows/Lighting/Interactables/Connections/Props/Audio
   - Depends: P1-01, P1-02

4. [P1] **P1-04**: Create interaction_engine.gd (engine/)
   - Files: engine/interaction_engine.gd (150-200 LOC)
   - Criteria: Thread-aware, progressive interactions, locked door handling (no-key/wrong-key), functional_slot matching, condition evaluation
   - Depends: P1-01

5. [P1] **P1-05**: Create puzzle_engine.gd (engine/)
   - Files: engine/puzzle_engine.gd (150-200 LOC)
   - Criteria: Loads puzzles, tracks steps, validates dependencies, sets rewards
   - Depends: P1-01

6. [P1] **P1-06**: Create state_machine.gd with expression parser (engine/)
   - Files: engine/state_machine.gd (150-230 LOC)
   - Criteria: Parses AND/OR/NOT/HAS/VISITED/>=, manages phase HSM + Elizabeth sub-HSM
   - Depends: P1-01

7. [P1] **P1-07**: Create audio_engine.gd (engine/)
   - Files: engine/audio_engine.gd (150-200 LOC)
   - Criteria: 3-layer audio (ambient, tension, SFX), crossfade on transition, reverb bus
   - Depends: P1-01

8. [P1] **P1-08**: Create trigger_engine.gd (engine/)
   - Files: engine/trigger_engine.gd (100-150 LOC)
   - Criteria: Entry/exit/timed/conditional/global triggers, ActionDecl execution, once tracking
   - Depends: P1-01

9. [P1] **P1-09**: Create prng_engine.gd (engine/)
   - Files: engine/prng_engine.gd (80-120 LOC)
   - Criteria: Seed -> macro thread + junction resolution, declaration patching, logging
   - Depends: P1-01

10. [P1] **P1-10**: Create test_generator.gd (engine/)
    - Files: engine/test_generator.gd (150-200 LOC)
    - Criteria: Generates tests for rooms, puzzles, connections, PRNG validation
    - Depends: P1-01

11. [P2] **P1-11**: Create PSX sky shader (shaders/psx_sky.gdshader)
    - Files: shaders/psx_sky.gdshader
    - Criteria: shader_type sky, no TIME, hash stars, moon from LIGHT0, Bayer dither, color depth
    - No dependencies (can start immediately)

---

## Phase 2: ROOM DECLARATIONS (28 tasks)

Agent Role: **Room Assembler** -- ~60 .tres files

### World Scaffolding (5 tasks, must complete first)

12. [P1] **P2-01**: Create world.tres (top-level game definition)
13. [P1] **P2-02**: Create state_schema.tres (all state variables)
14. [P2] **P2-03**: Create 6 environment declarations
15. [P1] **P2-04**: Create all 34 Connection resources in world.tres
16. [P2] **P2-05**: Create PlayerDeclaration in world.tres

### Room Declarations (20 tasks, can parallel after scaffolding)

17. [P2] **P2-06**: Declare Front Gate (thread-neutral, exterior)
18. [P2] **P2-07**: Declare Foyer (light thread variance, 3 variant interactables)
19. [P2] **P2-08**: Declare Parlor (CRITICAL -- phase transition, diary divergence)
20. [P3] **P2-09**: Declare Dining Room (moderate thread variance)
21. [P2] **P2-10**: Declare Kitchen (junction Diamond #3 B-path)
22. [P2] **P2-11**: Declare Upper Hallway (junction hub, locked attic door)
23. [P2] **P2-12**: Declare Master Bedroom (CRITICAL -- diary room)
24. [P1] **P2-13**: Declare Library (MAJOR junction -- Diamond #1)
25. [P3] **P2-14**: Declare Guest Room (light thread variance)
26. [P3] **P2-15**: Declare Storage Basement (light thread variance)
27. [P2] **P2-16**: Declare Boiler Room (junction Swap #2)
28. [P2] **P2-17**: Declare Wine Cellar (junction Diamond #3 A-path)
29. [P3] **P2-18**: Declare Attic Stairwell (phase transition, thread-neutral)
30. [P1] **P2-19**: Declare Attic Storage (MAJOR junction -- Diamond #2)
31. [P1] **P2-20**: Declare Hidden Chamber (ENDGAME -- thread defines ending)
32. [P2] **P2-21**: Declare Garden (junction Swap #3 + Diamond #4 B-path)
33. [P2] **P2-22**: Declare Chapel (junction Diamond #5 B-path)
34. [P3] **P2-23**: Declare Greenhouse (junction Diamond #5 A-path)
35. [P3] **P2-24**: Declare Carriage House (junction Diamond #3 A-path)
36. [P2] **P2-25**: Declare Family Crypt (junction Diamond #4 A-path)

### Items, Puzzles, Endings (3 tasks)

37. [P2] **P2-26**: Create all Item declarations (~30 items with functional_slots)
38. [P2] **P2-27**: Create all 6 Puzzle declarations (with variation_points)
39. [P2] **P2-28**: Create 5 Ending declarations (3 positive + 2 negative)

---

## Phase 3: CREATIVE CONTENT (13 tasks)

Agent Role: **Narrative Writer** -- ~15,000 words

40. [P1] **P3-01**: Write 3 MacroThread declarations (captive, mourning, sovereign)
41. [P2] **P3-02**: Write Captive thread-variant texts (~30 interactables)
42. [P2] **P3-03**: Write Mourning thread-variant texts (~30 interactables)
43. [P2] **P3-04**: Write Sovereign thread-variant texts (~30 interactables)
44. [P1] **P3-05**: Write 3 diary page texts (one per macro thread) -- FIRST MAJOR CLUE
45. [P1] **P3-06**: Write 3 Elizabeth letter texts (one per macro thread)
46. [P1] **P3-07**: Write 3 Elizabeth final note texts (one per macro thread) -- CLIMAX
47. [P2] **P3-08**: Write 3 ritual sequence texts (9 total step texts)
48. [P2] **P3-09**: Write Freedom ending text (Captive positive)
49. [P2] **P3-10**: Write Forgiveness ending text (Mourning positive)
50. [P2] **P3-11**: Write Acceptance ending text (Sovereign positive)
51. [P3] **P3-12**: Write Escape ending text (shared negative)
52. [P3] **P3-13**: Write Joined ending text (shared negative)

---

## Phase 4: JUNCTION + PUZZLE IMPLEMENTATION (12 tasks)

Agent Role: **Puzzle Designer + Coder** -- ~1,500 LOC + declarations

53. [P1] **P4-01**: Create 9 JunctionDecl resources (6 diamonds + 3 swaps)

### Diamond Puzzles (6 tasks, can parallel after P4-01)

54. [P1] **P4-02**: Diamond #1 -- Globe (A) + Gears (B) -> attic key
55. [P1] **P4-03**: Diamond #2 -- Doll (A) + Mask (B) -> hidden key
56. [P2] **P4-04**: Diamond #3 -- Portrait (A) + Hearth (B) -> cellar key
57. [P2] **P4-05**: Diamond #4 -- Crypt (A) + Lily (B) -> jewelry key
58. [P2] **P4-06**: Diamond #5 -- Greenhouse (A) + Chapel (B) -> gate key
59. [P1] **P4-07**: Diamond #6 -- Reversal (A) + Forgiveness (B) -> ending ritual

### Swap Puzzles (3 tasks, can parallel)

60. [P3] **P4-08**: Swap #1 -- Foyer clock (A) + mirror (B) -- flavor only
61. [P3] **P4-09**: Swap #2 -- Boiler pipes (A) + electrical (B) -- flavor only
62. [P3] **P4-10**: Swap #3 -- Garden fountain (A) + gazebo (B) -- flavor only

### PRNG + Validation (2 tasks, after puzzles)

63. [P1] **P4-11**: PRNG junction resolution with macro_preference
64. [P1] **P4-12**: Constraint validation (dependency graph, all 48 configs solvable)

---

## Phase 5: INTEGRATION + TESTING (16 tasks)

Agent Roles: **Integration** + **Test Generator + QA**

### Addon Wiring (10 tasks, can parallel)

65. [P1] **P5-01**: Wire godot-psx (dither + fade + sky)
66. [P1] **P5-02**: Wire godot_dialogue_manager (generate .dialogue from declarations)
67. [P1] **P5-03**: Wire gloot inventory (ProtoTree from ItemDeclarations)
68. [P2] **P5-04**: Wire AdaptiSound (3-layer audio)
69. [P2] **P5-05**: Wire godot-material-footsteps (9 surfaces)
70. [P3] **P5-06**: Wire phantom-camera (inspection + room reveal)
71. [P1] **P5-07**: Wire limboai HSM (phases + Elizabeth)
72. [P3] **P5-08**: Wire shaky-camera-3d (shake profiles)
73. [P3] **P5-09**: Wire quest-system (auto-generate from puzzles)
74. [P2] **P5-10**: Wire SaveMadeEasy (StateSchema + PRNG seed)

### Testing + Validation (6 tasks, sequential after wiring)

75. [P1] **P5-11**: Generate tests from declarations
76. [P1] **P5-12**: Validate all 48 configurations
77. [P2] **P5-13**: Validate bidirectional connections (34 pairs)
78. [P2] **P5-14**: Validate puzzle dependency graph per thread
79. [P1] **P5-15**: Run headless E2E test suite (all pass, exit 0)
80. [P3] **P5-16**: Android APK build + smoke test

---

## Execution Order (Recommended)

```
WEEK 1: Phase 1 (Engine Foundation)
  Day 1: P1-01 (Resource classes) + P1-11 (sky shader)
  Day 2: P1-02 (builders) + P1-06 (state machine)
  Day 3: P1-03 (room assembler) + P1-04 (interaction engine)
  Day 4: P1-05 (puzzle engine) + P1-07 (audio engine)
  Day 5: P1-08 (trigger engine) + P1-09 (PRNG engine) + P1-10 (test generator)

WEEK 2: Phase 2 (Declarations) + Phase 3 (Creative Content) -- PARALLEL
  Day 1: P2-01 (world.tres) + P2-02 (state_schema) + P3-01 (macro threads)
  Day 2: P2-04 (connections) + P2-03 (environments) + P2-05 (player)
  Day 3-4: P2-06..P2-25 (20 room declarations) -- 5 rooms/day
  Day 5: P2-26 (items) + P2-27 (puzzles) + P2-28 (endings)
  PARALLEL: P3-02..P3-13 (narrative writing throughout week)

WEEK 3: Phase 4 (Junctions + Puzzles)
  Day 1: P4-01 (junction declarations)
  Day 2-3: P4-02..P4-07 (6 diamond puzzles)
  Day 4: P4-08..P4-10 (3 swap puzzles)
  Day 5: P4-11 (PRNG resolution) + P4-12 (constraint validation)

WEEK 4: Phase 5 (Integration + Testing)
  Day 1-2: P5-01..P5-10 (addon wiring -- parallel)
  Day 3: P5-11 (test generation) + P5-12 (48 config validation)
  Day 4: P5-13..P5-15 (connection + dependency + E2E tests)
  Day 5: P5-16 (Android build + smoke test)
```

---

## Key Metrics

| Metric | Target |
|--------|--------|
| Resource class scripts | 34 |
| Builder scripts | 8 |
| Engine scripts | 8 |
| Room declarations | 20 |
| Item declarations | ~30 |
| Puzzle declarations | 6 |
| Junction declarations | 9 |
| Ending declarations | 5 |
| Thread-variant text entries | ~90 |
| Key narrative texts | 9 |
| Ending text sequences | 5 |
| Unique configurations validated | 48 |
| Bidirectional connections validated | 34 |
| Total engine LOC | ~3,000 |
| Total narrative words | ~15,000 |
