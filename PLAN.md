# Ashworth Manor Production Recovery Plan

## Summary

Ashworth Manor is now a declaration-driven Godot 4.6 game with compiled-world runtime scaffolding, renderer-based screenshot QA, and a Forward+-first first-person interaction model. The active recovery work is no longer basic boot or test migration. The product risk is player-facing quality: coherent world traversal, correct first-person staging, threshold feel, and puzzle/story readability.

## Current Architecture

- `declarations/*.tres` are the canonical content layer
- `engine/` owns declaration parsing, room assembly, graph compilation, region/compiled-world planning, and validation
- `scripts/room_manager.gd` now understands compiled worlds and same-world traversal profiles
- `scripts/world_runtime_manager.gd` owns active/prewarmed compiled-world state
- same-world doors default toward seamless traversal
- same-world stairs/ladders/trapdoors default toward embodied traversal
- renderer walkthrough and opening-journey capture are part of acceptance

## Active Recovery Tracks

### 1. Opening Path and First-Person Composition
- Repair `front_gate` so the player starts at a convincing diegetic gate/menu, then walks a hedge-lined moonlit approach toward a readable manor facade
- Repair `foyer` so the front-door handoff lands on the hall axis and stair pull instead of a blocker-heavy threshold frame
- Continue polishing `library`, `kitchen`, and `attic_stairs` until their first frames communicate purpose cleanly
- Verify via:
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`

### 2. Compiled-World Runtime
- Keep rooms as authoring units but compiled worlds as runtime traversal units
- Preserve these primary compiled worlds:
  - `entrance_path_world`
  - `manor_interior_world`
  - `rear_grounds_world`
  - `service_basement_world`
- Continue moving same-world traversal away from room-swap feel and toward live continuous world slices
- Verify via:
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`

### 3. Threshold Mechanisms
- Thresholds are no longer generic links; they are moving toward functional assemblies
- Continue finishing:
  - doors
  - gates
  - ladders
  - trapdoors
  - secret passages
- First fully complete mechanism path remains:
  - `storage_basement <-> carriage_house`
- Verify via:
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`

### 4. Procedural Shell Discipline
- Architectural stack stays:
  - procedural shell
  - inset trim/frame/moulding models
  - procedural moving mechanisms
- Walls/floors/ceilings remain procedural and texture-driven
- Stairs remain procedural even if trimmed with models
- Builder logic, not source asset mutation, owns normalization and fitting

### 5. Validation and Acceptance
- Declaration validation, interaction validation, playthrough validation, and screenshot QA must agree
- Critical-path visuals are not considered complete unless renderer captures are acceptable
- Required command surface:
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`

## Current Priorities

1. Fix `front_gate` facade massing and route framing
2. Fix `foyer` front-door handoff composition
3. Extend stateful setpiece visuals for liquid-bearing and changing objects
4. Keep pushing same-world traversal toward truly continuous navigation
5. Finish threshold mechanism feel and secret-passage completeness
6. Audit puzzles and dynamic setpieces for actual gameplay sense, not just data consistency

## Status

- [x] Declaration runtime is canonical
- [x] Compiled-world scaffolding exists
- [x] Same-world traversal no longer hard-fades by default
- [x] Renderer walkthrough is clean and stable
- [x] Opening-journey capture exists
- [x] Liquid/stateful interactable visuals work for chapel font, kitchen bucket, parlor tea service, and dining-room wine glass
- [x] Forward+ renderer is the canonical visual baseline for glass, water, fog, and lighting response
- [ ] Opening route is visually shippable
- [ ] Manor interior feels fully seamless
- [ ] Threshold mechanisms are fully production-complete
- [ ] Puzzle flow has been fully audited for actual playability
