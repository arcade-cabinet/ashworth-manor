# Service Basement and Midgame Spine

## Summary
Complete the next shared-spine tranche after the kitchen service-hatch fall: the player must survive the dark basement landing, restore the house-side gas service through a concise maintenance sequence, and transition cleanly into the walking-stick midgame phase. This batch exists to make the early mansion stop feeling like disconnected beats and start feeling like a single authored progression from improvised light to reclaimed house order.

## Scope
- Included work
  - storage-basement post-fall survival beat
  - improvised relight and pressure/fume gameplay
  - boiler-room gas restoration sequence
  - persistent restored-light house state for the shared accessible mansion
  - post-restoration return route through shared/utilitarian circulation
  - walking-stick acquisition and first meaningful use
  - focused tests, docs, and renderer-backed walkthrough coverage for this spine
- Explicitly excluded work
  - `Adult`, `Elder`, or `Child` late-route divergence
  - attic trapdoor, blackout, lantern, crypt, or endgame hook work
  - chapel/greenhouse/grounds re-authoring beyond any dependency needed for stable tests
  - full macro-text migration away from legacy `macro_thread` references outside this spine

## Constraints
- Declarations remain the canonical content layer.
- Do not reintroduce the old macro PRNG as active design; `macro_thread` is compatibility only.
- Keep the house dark on first arrival; stable estate light belongs to the post-restoration phase.
- Lighting must remain visibly sourced. No ambient “fix it in fill” shortcuts.
- The gas-restoration sequence must feel like pressured navigation plus a few decisive actions, not a boiler simulator.
- Do not add combat, enemies, or HUD-like helper UI.
- Preserve diegetic interaction style and tap-to-walk / swipe-to-look control assumptions.
- Treat visual review as part of completion, not optional polish.
- Reuse shell sessions for verification where practical; do not open needless extra long-lived exec processes.

## Assumptions
- T06 is complete and verified:
  - front-gate packet/valise flow is live
  - keyed front-door dark entry is live
  - parlor hearth starts the `firebrand` phase
  - kitchen service hatch triggers Elizabeth’s first seizure and the storage-basement fall
- The player can already arrive in `storage_basement` with:
  - `kitchen_service_descent_triggered = true`
  - `storage_basement_fall_landing_pending = false` after the landing beat
  - no `firebrand`
  - `elizabeth_aware = true`
- Existing boiler-room props and machinery can be repurposed rather than replaced wholesale.
- The walking stick should be acquired after gas restoration from shared/utilitarian circulation, not from the basement landing itself.

## Execution Policy
- Completion standard
  - The shared spine is only complete when a player can move from dark basement landing to restored house-state light and into a new midgame held-tool phase without the sequence feeling like separate prototypes.
- Stop conditions
  - Stop if gas restoration cannot be expressed cleanly with the declaration/runtime surface without a broader engine redesign.
  - Stop if a required architectural change conflicts with the current canonical route program or room topology docs.
  - Stop if visual acceptance fails in renderer-backed walkthroughs after the logic is green.
- Verification cadence
  - Run focused declaration/interaction tests after each room/runtime slice.
  - Re-run room-spec coverage after any connection/light/state-surface change.
  - Re-run renderer-backed walkthrough once the spine visually changes.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave the repo with half-implemented gas-restoration state or mixed firebrand/walking-stick semantics.

## Task Graph

### B01
- `ID:` B01
- `Title:` Audit and collapse the existing service-basement / boiler-room logic into a single shared-spine state map
- `Depends on:` none
- `Why it exists:` the current basement, boiler, and light-state logic still assumes older clue/puzzle beats and must be reduced to one coherent progression before downstream implementation.
- `Implementation notes:`
  - inspect `storage_basement`, `boiler_room`, `world.tres`, `state_schema.tres`, and current e2e coverage together
  - define the minimum canonical states for:
    - makeshift relight below
    - fume pressure active
    - gas restored
    - basement sconces awake
    - house stable light active
    - walking stick acquired
  - remove or quarantine any old boiler-room branches that would confuse the shared spine
- `Acceptance criteria:`
  - a single state progression exists from fall landing to restored gas
  - stale or conflicting old-path assumptions are identified and either removed or explicitly deferred
  - downstream tasks can name concrete state keys rather than relying on ambiguous old puzzle flags
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - focused diff review of affected declaration/runtime surfaces
- `Status:` in_progress

### B02
- `ID:` B02
- `Title:` Implement the storage-basement survival beat: improvised relight, fumes, and first real consequence pressure
- `Depends on:` B01
- `Why it exists:` the basement landing only works if the player must actively recover enough light and momentum to move deeper, rather than simply stand up in a readable room.
- `Implementation notes:`
  - add the immediate post-fall interaction beat in `storage_basement`
  - the player should recover usable temporary light through the agreed match + oily-rag logic
  - encode the fume/bad-air pressure as a gameplay constraint without turning it into timer UI
  - use authored text, light-state changes, and room affordances to make the danger legible
  - keep this beat concise; it should add dread and consequence, not stall the route
- `Acceptance criteria:`
  - the player cannot simply wander the basement in comfortable darkness after the fall
  - the makeshift relight beat is embodied and understandable
  - bad air/fume pressure is materially present and can fail the player or force urgency
  - the room still reads as a real service/storage layer, not an abstract punishment arena
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add targeted survival-beat assertions to the basement lane
- `Status:` pending

### B03
- `ID:` B03
- `Title:` Re-author the boiler room into the decisive gas-restoration sequence
- `Depends on:` B01, B02
- `Why it exists:` restoring gas is the shared-spine turn from personal improvised light to reactivated estate infrastructure.
- `Implementation notes:`
  - keep the boiler room as service machinery, not occult abstraction
  - replace or simplify the current valve/fuse swap logic so it supports the new shared-spine route directly
  - use a few decisive actions only:
    - find the correct service point
    - feed/stoke/open what matters
    - commit the restoration
  - maintain pressure from the basement survival state while the player performs the sequence
  - ensure the result is legible from both text and immediate light response
- `Acceptance criteria:`
  - the gas-restoration sequence is shorter than a simulation and stronger than a single click
  - the room’s machinery and clue text agree about what the player is doing
  - completing the sequence clearly feels like reclaiming house infrastructure
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add targeted boiler/gas assertions
- `Status:` pending

### B04
- `ID:` B04
- `Title:` Propagate restored gas into the service basement and shared accessible house state
- `Depends on:` B03
- `Why it exists:` the player must feel an immediate and wider consequence when gas returns; otherwise the restoration has no authored payoff.
- `Implementation notes:`
  - wake basement sconces immediately on successful restoration
  - propagate stable light state to the currently accessible house slice without requiring repetitive relighting chores
  - preserve the rule that special late-game spaces can still violate ordinary house lighting later
  - update room-load sync so restored-light rooms remain coherent across transitions
- `Acceptance criteria:`
  - the basement visibly changes the moment gas is restored
  - subsequent shared-spine rooms can remain stably lit without micro-management
  - ordinary room navigation no longer depends on carrying fire after this point
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - targeted opening/shared-spine assertions updated as needed
- `Status:` pending

### B05
- `ID:` B05
- `Title:` Build the post-restoration return route and walking-stick acquisition
- `Depends on:` B04
- `Why it exists:` the midgame needs a new held-tool identity and a spatially meaningful emergence from the service world.
- `Implementation notes:`
  - bring the player back up through shared/utilitarian circulation rather than snapping to ceremonial space
  - place the walking stick in a socially plausible overlap zone where the firebrand no longer makes sense
  - consume the firebrand phase decisively and start the walking-stick phase
  - give the walking stick at least one meaningful first use tied to probing, balance, or reach within the immediate shared-spine route
- `Acceptance criteria:`
  - the player clearly leaves the early light phase behind
  - the walking stick is acquired in a way that feels authored by the estate’s architecture
  - at least one immediate interaction demonstrates why this tool matters
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add walking-stick acquisition/use assertions
- `Status:` pending

### B06
- `ID:` B06
- `Title:` Re-author docs, checkpoints, and visual acceptance for the completed shared-spine tranche
- `Depends on:` B02, B03, B04, B05
- `Why it exists:` this repo is declaration-first and narrative-heavy; the implementation is not durable if docs and visual lanes still describe an older game.
- `Implementation notes:`
  - update:
    - `MEMORY.md`
    - `PLAN.md`
    - `STRUCTURE.md`
    - room docs for `storage_basement`, `boiler_room`, and any shared-circulation room touched by walking-stick acquisition
  - update the parent production batch checkpoint status where this tranche changes it
  - run renderer-backed walkthrough capture for the shared-spine route through basement restoration
- `Acceptance criteria:`
  - docs describe the same spine the runtime now implements
  - the parent batch and checkpoint files point to the next real frontier cleanly
  - visual captures exist for the new basement-to-midgame progression
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - screenshot path exists under Godot `user://` capture output
- `Status:` pending

## Critical Gates
- Gate 1: B02 must land a believable dark-basement survival beat before any gas-restoration logic is considered done.
- Gate 2: B03 and B04 together must produce an immediate local light response plus stable shared-house light state; do not start walking-stick work before this is true.
- Gate 3: B05 must establish the walking-stick phase with at least one meaningful use before this batch can be called complete.
- Gate 4: B06 must include renderer-backed verification; logic-only completion is insufficient.

## Resume Instructions
- Start from this file and the parent batch in `docs/batches/ashworth-production-recovery.md`.
- Assume T06 is complete and verified unless a test proves otherwise.
- Before editing, re-run the focused green baseline:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_opening_journey.gd`
- Resume at B01 if the state map still looks stale; otherwise continue at the first non-complete task.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, leave the repo at a verified checkpoint or record the exact blocking inconsistency in `MEMORY.md` before stopping.
