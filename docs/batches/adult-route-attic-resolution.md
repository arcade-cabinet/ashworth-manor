# Adult Route Attic Resolution

## Summary
Build the first bespoke late-game storyline after the shared spine: the `Adult` Elizabeth route. This batch exists to turn the restored-house midgame into a fully authored attic-driven endgame where the player uncovers Elizabeth's lost adulthood and resolves the run through the music box in the attic.

## Scope
- Included work
  - route-specific midgame clue bias for `Adult`
  - attic access logic as the late-route rupture
  - attic-focused late traversal and investigation
  - adult-life evidence, letters, portraits, and private effects
  - attic music-box discovery and adult-route resolution
  - adult-route ending logic, tests, docs, and renderer-backed review
- Explicitly excluded work
  - `Elder` crypt route implementation
  - `Child` sealed-room route implementation
  - lantern-hook crypt descent as a shipped playable route
  - broad whole-repo migration of all stale route text not touched by the adult route

## Constraints
- Declarations remain canonical.
- This batch assumes the shared spine through stable midgame house light and walking-stick phase already exists.
- `Adult` is the first canonical completion and should be the most legible first full story, not the strangest one.
- The route must feel attic-led, not crypt-led.
- The music box is the invariant final solve object and must remain the route’s end-state center.
- Elizabeth should read here as a woman partially erased from the family record, not as a preserved child and not as an ageless crypt force.
- Keep interactions diegetic and room-authored; do not solve route distinction through overt UI labeling.

## Assumptions
- The player already arrives at midgame through:
  - packet and valise opening
  - dark-house entry
  - parlor first warmth / `firebrand`
  - kitchen service-hatch fall
  - gas restoration
  - walking-stick acquisition
- Route order enforcement is already live and `Adult` is the first-play completion.
- Legacy `macro_thread` can remain as compatibility glue during migration, but `elizabeth_route = adult` is the actual authorial source.
- Existing attic rooms, library, master bedroom, and upper-hallway content can be selectively rewritten rather than wholly replaced.

## Execution Policy
- Completion standard
  - The batch is complete only when an `Adult` run can be played from shared-spine handoff to attic resolution with coherent clue pressure, one readable late-route rupture, and a working ending.
- Stop conditions
  - Stop if the shared-spine batch is not yet complete enough to hand the player into late route logic cleanly.
  - Stop if attic access or late-route tool requirements conflict with the canonical route program.
  - Stop if route text and route runtime cannot be reconciled without re-planning the route structure.
- Verification cadence
  - Run focused declaration and interaction checks after each route slice.
  - Add one dedicated adult-route test lane before calling the route complete.
  - Use renderer-backed captures for the late attic route, not just headless checks.
- Partial completion
  - Acceptable only at verified checkpoints inside this batch.
  - Do not leave the route half-migrated with mixed adult/elder/child signals in the same critical rooms.

## Task Graph

### A01
- `ID:` A01
- `Title:` Audit and map the existing adult-route clue surfaces across upper floor and attic
- `Depends on:` none
- `Why it exists:` the adult route should lean on letters, private effects, portraiture, and unfinished adulthood, but the current rooms still contain mixed old-weave material.
- `Implementation notes:`
  - inspect `upper_hallway`, `library`, `master_bedroom`, `guest_room`, `attic_stairs`, `attic_storage`, and `hidden_chamber`
  - identify which current clues can be retained, rewritten, or removed for `Adult`
  - define the adult-route clue path from shared midgame into attic truth
  - record the concrete route-specific states the runtime will need
- `Acceptance criteria:`
  - there is a clear adult-route clue topology with no major ambiguous late-route overlap
  - every critical upper-floor/attic room has an identified adult-route narrative job
  - downstream tasks can implement against named rooms and states rather than broad theme language
- `Verification:`
  - declaration/doc audit across the target room files
  - update `MEMORY.md` with the agreed adult-route clue map
- `Status:` pending

### A02
- `ID:` A02
- `Title:` Re-author midgame clue emphasis and room responses for the `Adult` route
- `Depends on:` A01
- `Why it exists:` the route needs to feel distinct before the final chamber, and the current shared-room content does not yet consistently bias toward Elizabeth's adulthood.
- `Implementation notes:`
  - use `elizabeth_route = adult` to bias clue read
  - prioritize:
    - adult correspondence
    - portrait evidence
    - private effects
    - proof of prolonged adult confinement or denied life
  - adjust declaration responses, conditional events, and selected docs in shared rooms
  - keep outside paperwork neutral
- `Acceptance criteria:`
  - the player can feel the route’s adult identity before reaching the attic
  - route-specific content reads as lost adulthood, not generalized haunting
  - shared rooms remain usable while meaningfully changing emphasis for `Adult`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add adult-route assertions for at least two shared rooms and one attic-adjacent room
- `Status:` pending

### A03
- `ID:` A03
- `Title:` Implement the adult-route late rupture and attic access sequence
- `Depends on:` A01, A02
- `Why it exists:` the route needs a distinct late-game turn that says the attic, not the crypt, is where the final truth waits.
- `Implementation notes:`
  - define how the shared spine hands the player into attic-directed late play
  - keep the rupture bodily and architectural, not menu-like
  - update thresholds, access states, and any held-tool requirements needed for the attic route
  - ensure the late turn feels route-authored without borrowing the elder-route crypt grammar
- `Acceptance criteria:`
  - the player is unmistakably pushed toward attic truth in the adult route
  - attic access feels earned and authored
  - the route no longer depends on crypt-first late logic to resolve
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - targeted adult-route traversal checks
- `Status:` pending

### A04
- `ID:` A04
- `Title:` Build the adult-attic final chamber and music-box solve
- `Depends on:` A03
- `Why it exists:` the route is not complete until the attic contains the final adult-life truth and the music-box resolution.
- `Implementation notes:`
  - use attic space to reveal Elizabeth's unfinished adulthood
  - stage the winding key, music box, and final evidence so they converge cleanly
  - the music box should resolve the route, not act as optional flavor
  - align final room text, object placement, and response order around the adult-route payoff
- `Acceptance criteria:`
  - the attic functions as a true final chamber for `Adult`
  - the childhood winding key and attic music box meet coherently
  - the player understands that Elizabeth lived into adulthood and was denied a full human life
- `Verification:`
  - add a dedicated adult-route resolution test
  - `godot --headless --path . --script test/e2e/test_adult_route.gd`
- `Status:` pending

### A05
- `ID:` A05
- `Title:` Wire the adult-route ending, completion state, and replay consequences
- `Depends on:` A04
- `Why it exists:` the first canonical completion must end cleanly, record correctly, and hand the overall game into the `Elder` route next.
- `Implementation notes:`
  - connect the route’s resolved state to ending presentation and save progression
  - ensure `completed_routes` records `adult`
  - ensure the next new game resolves to `elder`
  - keep ending text specific to adult-route truth
- `Acceptance criteria:`
  - an `Adult` completion records correctly
  - the route’s ending content matches the attic biography payoff
  - progression advances to `Elder` for the next first-time run
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_adult_route.gd`
- `Status:` pending

### A06
- `ID:` A06
- `Title:` Finalize docs, checkpoints, and visual acceptance for the adult route
- `Depends on:` A02, A03, A04, A05
- `Why it exists:` the route is not durable if the runtime, docs, and visual capture lanes disagree about what the first full playthrough is.
- `Implementation notes:`
  - update:
    - `MEMORY.md`
    - `PLAN.md`
    - `STRUCTURE.md`
    - route docs and affected room docs
  - update the parent production batch checkpoint
  - capture renderer-backed attic-route review images
  - ensure the adult-route batch becomes the clear predecessor to the elder-route batch
- `Acceptance criteria:`
  - docs describe the same adult-route late game the runtime now ships
  - visual captures exist for the adult attic rupture and final chamber
  - the repo checkpoint surface points cleanly to the next route frontier
- `Verification:`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_adult_route.gd`
  - screenshot output exists under Godot `user://`
- `Status:` pending

## Critical Gates
- Gate 1: A01 must produce a concrete adult-route clue map before any late attic implementation starts.
- Gate 2: A03 must establish a fully attic-led late rupture before final-chamber work begins.
- Gate 3: A04 and A05 together must produce a playable, recordable `Adult` completion before the route can be considered done.
- Gate 4: A06 must include renderer-backed review; headless-only completion is insufficient.

## Resume Instructions
- Start from this file and the parent production batch in `docs/batches/ashworth-production-recovery.md`.
- Assume the shared-spine batch in `docs/batches/service-basement-midgame-spine.md` is the required upstream dependency.
- Before editing, verify the current baseline for shared-spine logic:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
- Resume at A01 unless an audit for the adult route already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact adult-route inconsistency in `MEMORY.md`.
