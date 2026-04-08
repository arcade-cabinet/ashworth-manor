# Hard Substrate Freeze

## Summary

This batch front-loads the shared physical substrate of Ashworth Manor ahead of
further room-by-room polish or downstream export work. The story-complete build
is treated as provisional until the shared substrate is explicit, reusable, and
reapplied across the whole game.

## Scope

- Included work
  - canonical substrate authority and checkpoint surfaces
  - declaration-facing substrate presets, mount slots, and payloads
  - shared material/shader recipe registry
  - shared builder/factory normalization
  - environment/region substrate matrix
  - whole-game substrate validation and renderer-backed evidence rebuild
- Explicitly excluded work
  - new feature scope beyond the existing whole-game ship contract
  - Android/export/device validation except where a repo-local substrate change
    would obviously break those surfaces
  - one-off room polish that does not define or adopt a reusable substrate primitive

## Constraints

- `docs/GAME_BIBLE.md` remains the narrative authority.
- `docs/SUBSTRATE_FOUNDATION.md` is the substrate authority.
- Declarations remain canonical; do not move authoring truth into scenes.
- Existing `psx_*` systems are compatibility/compositor shims, not the target look.
- Imported models are reserved for discrete props and hero objects.
- Visual work is incomplete until renderer-backed captures are reviewed.

## Assumptions

- `/Volumes/home/assets/2DPhotorealistic` is mounted and available as the primary
  surface-input library.
- Foliage atlases are for shader-driven micro silhouette and depth breakup, not
  direct hedge-wall base texturing.
- The master graph remains the whole-game scope contract, but this batch is the
  active execution contract until the substrate sweep is complete.

## Execution Policy

- Completion standard
  - finish substrate tasks only when the shared library exists, declarations resolve
    through it, and validation lanes prove the coverage
- Stop conditions
  - stop only on a real engine/runtime blocker or missing source asset needed for a
    declared substrate primitive
- Verification cadence
  - run declaration tests after schema changes
  - run renderer-backed probes after environment/substrate adoption changes
  - keep the full playthrough lane green as the substrate is adopted
- Partial completion
  - partial completion is acceptable only if the active checkpoint records exactly
    what is still provisional

## Task Graph

### `SF-001`
- Title
  - Canonical substrate inventory and freeze contract
- Depends on
  - none
- Why it exists
  - the repo needs one authoritative “lego box” contract before more content work
- Implementation notes
  - add `docs/SUBSTRATE_FOUNDATION.md`
  - add the tree-based inventory checkpoint
  - rebase source-map docs onto this batch as the active execution contract
- Acceptance criteria
  - the substrate authority doc exists and names the decision rules, primitive families,
    mount families, and region matrix
  - the repo source map points to this batch as active
- Verification
  - file existence and source-map review
- Status
  - in_progress

### `SF-002`
- Title
  - Shared shader and material recipe library
- Depends on
  - `SF-001`
- Why it exists
  - surface language must be named, reusable, and slot-driven instead of ad hoc
- Implementation notes
  - normalize recipe ids in `EstateMaterialKit`
  - reduce `PBRTextureKit` to slot composition and standard material application
  - keep legacy texture-path fallback only as compatibility
- Acceptance criteria
  - recipe ids exist for surface, terrain, and foliage families
  - builders can resolve `recipe:` references
- Verification
  - `godot --headless --path . --script test/generated/test_declarations.gd`
- Status
  - in_progress

### `SF-003`
- Title
  - Shared builder and factory library promotion
- Depends on
  - `SF-002`
- Why it exists
  - core architecture and exterior language must come from shared builders first
- Implementation notes
  - keep walls, floors, ceilings, doors, windows, stairs, ladders, and thresholds on shared builders
  - normalize exterior estate builders as the approved path for walls, hedges, roads, gates, and facades
- Acceptance criteria
  - room assembly and shared scene usage no longer require bespoke architecture assumptions
- Verification
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
- Status
  - in_progress

### `SF-004`
- Title
  - Declaration-facing mount and slot system
- Depends on
  - `SF-002`
- Why it exists
  - route/state dressing must mount onto shared hosts instead of bespoke positional hacks
- Implementation notes
  - add the substrate declaration classes
  - wire `RoomAssembler` to resolve mount payloads before room-specific hacks
- Acceptance criteria
  - rooms can declare mount slots and payloads
  - room assembly records and consumes substrate metadata
- Verification
  - `godot --headless --path . --script test/generated/test_declarations.gd`
- Status
  - in_progress

### `SF-005`
- Title
  - Environment and region preset library
- Depends on
  - `SF-001`
- Why it exists
  - every room must resolve through a declared region/environment substrate matrix
- Implementation notes
  - add the ten region substrate presets
  - expand environment declarations beyond the old broad six where needed
  - record default environment/substrate ids on regions
- Acceptance criteria
  - all rooms resolve an environment preset and substrate preset through room, environment, or region
  - environment declarations carry light grammar, dominant recipes, and allowed mount families
- Verification
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
- Status
  - in_progress

### `SF-006`
- Title
  - Grounds topology and exterior estate coverage
- Depends on
  - `SF-002`
  - `SF-003`
  - `SF-005`
- Why it exists
  - the estate exterior must read as one coherent authored substrate, not a patchwork of scene hacks
- Implementation notes
  - front gate/front drive stay the main outward-view spaces
  - hedge corridors must read as wall-like topiary
  - side gates, pond/garden/crypt logic, and outward-road frontage must all use the shared families
- Acceptance criteria
  - exterior rooms read through the shared grounds substrate
  - gate families and boundary logic are unified
- Verification
  - `godot --path . --script test/e2e/test_front_gate_visual.gd`
  - `godot --path . --script test/e2e/test_drive_visual.gd`
  - renderer review
- Status
  - pending

### `SF-007`
- Title
  - Whole-house interior substrate coverage
- Depends on
  - `SF-003`
  - `SF-004`
  - `SF-005`
- Why it exists
  - every floor must adopt the same substrate policy, not just the opening
- Implementation notes
  - reapply the substrate to ground floor, upper floor, attic, basement, and deep basement
  - remove dependence on imported architecture shells for primary room envelopes
- Acceptance criteria
  - every floor resolves through the region matrix and shared builders
- Verification
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- Status
  - pending

### `SF-008`
- Title
  - Route-state integration on top of the substrate
- Depends on
  - `SF-004`
  - `SF-007`
- Why it exists
  - `Adult`, `Elder`, and `Child` should differ by state and mounted content, not separate environment tech
- Implementation notes
  - move route-specific physical differences to mounted clues, blocked passages, and state-driven dressing
- Acceptance criteria
  - route differences do not require bespoke environment implementations
- Verification
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- Status
  - pending

### `SF-009`
- Title
  - Visual QA and evidence rebuild
- Depends on
  - `SF-006`
  - `SF-007`
  - `SF-008`
- Why it exists
  - the renderer-backed surface must judge correctness, not mere runtime success
- Implementation notes
  - extend probe lanes into macro/meso/micro substrate review
  - add static checks for missing substrate presets or unsupported waivers
- Acceptance criteria
  - critical rooms and finales have reviewable evidence with explicit questions
- Verification
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
- Status
  - pending

### `SF-010`
- Title
  - Whole-game sweep and rebaseline
- Depends on
  - `SF-006`
  - `SF-007`
  - `SF-008`
  - `SF-009`
- Why it exists
  - previously “done” work must be reopened if the substrate sweep proves it wrong
- Implementation notes
  - sweep grounds, ground floor, upper floor, attic, basement, deep basement, greenhouse, garden, crypt, and all route finales
  - only return to downstream device/export work after the repo-local substrate gates are green
- Acceptance criteria
  - all rooms and route finales pass the substrate and evidence gates
- Verification
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- Status
  - pending

## Critical Gates

- `Gate A`
  - substrate authority doc, batch, declarations, and region/environment matrix all land
- `Gate B`
  - builders and material registry resolve through the shared substrate contract
- `Gate C`
  - exterior and interior sweeps are rerun with renderer evidence
- `Gate D`
  - whole-game repo-local substrate rebaseline is green before downstream Android/export work resumes

## Resume Instructions

- Resume from the lowest-numbered non-complete `SF-*` task.
- Read `PLAN.md`, `MEMORY.md`, `STRUCTURE.md`, and `docs/checkpoints/SF-001-substrate-inventory.md` first.
- Treat one-off room fixes as out of scope unless they define or adopt a reusable substrate primitive.
- Keep verification honest: if a renderer-backed frame is wrong, record it as wrong.
