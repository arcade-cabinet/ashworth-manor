# Elder Route Crypt Resolution

## Summary
Build the second bespoke late-game storyline after the `Adult` route: the `Elder` Elizabeth route. This batch exists to turn the restored-house midgame and attic-side late rupture into a burial-driven endgame where the player descends through wine-cellar and crypt truth, confronts Elizabeth's impossible old age, and resolves the run through the music box in the crypt.

## Scope
- Included work
  - route-specific clue bias for `Elder` across the great-hall/foyer volume and late shared rooms
  - attic-side late rupture that redirects the player away from attic-final truth
  - blackout, loss of stable light, and descent into the lantern-on-hook phase
  - elder-route traversal through `wine_cellar` and `family_crypt`
  - caretaker residue, burial records, and continuity clues that support old-age Elizabeth
  - crypt final chamber, buried music-box solve, and elder-route ending logic
  - focused tests, docs, and renderer-backed review for the second canonical route
- Explicitly excluded work
  - `Adult` route attic-final implementation beyond any dependency cleanup needed for route separation
  - `Child` sealed-room route implementation
  - broad repo-wide cleanup of every stale legacy thread reference outside rooms or systems touched by this route
  - late post-crypt `lantern hook` utility in greenhouse, carriage house, or other optional reach/pull spaces not needed for the elder completion

## Constraints
- Declarations remain canonical.
- This batch assumes the shared-spine tranche is complete through stable midgame house light and walking-stick possession.
- This batch assumes the `Adult` route is the shipped first completion and must remain distinct.
- `Elder` is the second canonical completion and must feel like escalation, not like attic route reuse with different text.
- The route must pivot away from attic-final truth and make burial space personal.
- The music box remains the invariant final solve object.
- The blackout and lantern-on-hook turn must feel authored, dangerous, and bodily rather than UI-scripted.
- Elizabeth's laugh only marks significant events; do not use it as ambient filler.
- Keep outside paperwork and estate signage neutral.
- Visual review is part of done; renderer-backed captures are required.

## Assumptions
- Route progression already enforces `Adult -> Elder -> Child`.
- The player reaches elder midgame through:
  - packet and valise opening
  - dark-house entry
  - first warmth and `firebrand`
  - kitchen service-hatch fall
  - gas restoration
  - stable shared-house light
  - walking-stick phase
- `foyer` is the runtime surface corresponding to the great-hall emotional job.
- Existing rooms can be selectively rewritten rather than rebuilt wholesale:
  - `foyer`
  - `upper_hallway`
  - `attic_stairs`
  - `attic_storage`
  - `wine_cellar`
  - `family_crypt`
- Late-game blackout, lantern-on-hook traversal, and crypt-final elder resolution are not yet implemented as a complete route.

## Execution Policy
- Completion standard
  - The batch is complete only when an `Elder` run can be played from shared-midgame handoff through blackout, burial descent, crypt music-box solve, and recorded completion with coherent clue pressure and a route identity distinct from `Adult`.
- Stop conditions
  - Stop if the shared-spine batch has not actually landed stable light and walking-stick semantics.
  - Stop if the `Adult` route is not yet complete enough to preserve route-order progression cleanly.
  - Stop if attic rupture, blackout, or crypt access requires broader topology changes that contradict the canonical route docs.
  - Stop if the route can only be expressed by reviving the old macro PRNG logic.
- Verification cadence
  - Run declaration and interaction checks after each runtime/content slice.
  - Add a dedicated elder-route test lane before declaring the route complete.
  - Use renderer-backed captures for blackout, wine cellar, and crypt review.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave the repo with mixed adult/elder late-route logic on the same critical thresholds.

## Task Graph

### E01
- `ID:` E01
- `Title:` Audit and map the elder-route clue and access surfaces across great-hall/foyer, attic rupture, wine cellar, and crypt
- `Depends on:` none
- `Why it exists:` the elder route should center continuity, burial, and caretaker residue, but the current rooms still contain mixed old-weave and pre-route material.
- `Implementation notes:`
  - inspect:
    - `foyer`
    - `upper_hallway`
    - `attic_stairs`
    - `attic_storage`
    - `wine_cellar`
    - `family_crypt`
  - define the elder-route clue path from midgame stability to burial-side truth
  - identify which current clues can be retained, rewritten, or removed
  - record the concrete state keys and room-response pivots needed for the elder route
- `Acceptance criteria:`
  - there is a clear elder-route clue topology from great hall to crypt
  - each critical room has an identified elder-route narrative job
  - downstream tasks can implement against named rooms and route states rather than only thematic language
- `Verification:`
  - declaration/doc audit across the target room files
  - update `MEMORY.md` with the agreed elder-route clue map
- `Status:` pending

### E02
- `ID:` E02
- `Title:` Re-author elder-route clue bias in shared and upper-house rooms before the late rupture
- `Depends on:` E01
- `Why it exists:` the route needs to feel old, buried, and accusatory before the player ever reaches the crypt.
- `Implementation notes:`
  - use `elizabeth_route = elder` to bias read in shared rooms
  - prioritize:
    - burial records
    - caretaker residue
    - altered family memory
    - signs of a life preserved beyond its rightful span
  - focus first on the great-hall/foyer volume and the upper-house approach rooms
  - keep the route distinct from the adult attic-biography tone
- `Acceptance criteria:`
  - the player can feel elder-route identity before the blackout/descent begins
  - clue language reads as continuity and endurance, not merely sadness or hidden childhood
  - shared rooms remain usable while meaningfully changing emphasis for `Elder`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add elder-route assertions for at least two shared rooms and one upper-house room
- `Status:` pending

### E03
- `ID:` E03
- `Title:` Implement the elder-route attic rupture, blackout, and lantern-on-hook late transition
- `Depends on:` E01, E02
- `Why it exists:` the elder route needs a late turn that strips away midgame certainty and redirects the player bodily toward buried truth.
- `Implementation notes:`
  - make `attic_stairs` / `attic_storage` the rupture point rather than the final chamber
  - remove stable light abruptly and consume the walking-stick phase
  - use Elizabeth's laugh only at the significant transition moment
  - reveal the lantern-on-hook phase as survival guidance, not as a generic item pickup
  - ensure the route does not read as attic-final after this sequence
- `Acceptance criteria:`
  - the elder route has a readable attic-side late rupture
  - blackout materially changes movement and navigation rather than acting as a cosmetic effect
  - the walking stick is decisively lost and the lantern-on-hook phase begins cleanly
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add targeted elder late-transition assertions
- `Status:` pending

### E04
- `ID:` E04
- `Title:` Build elder-route traversal through wine cellar and crypt, including the first lantern-hook utility shift
- `Depends on:` E03
- `Why it exists:` the route is not elder-specific until the player moves through burial-side architecture and learns that the lantern arrangement is also a tool transition.
- `Implementation notes:`
  - route the player through `wine_cellar` into `family_crypt`
  - make the wine cellar a meaningful lateral or unlocking layer, not disposable scenery
  - stage the lantern first as light, then reveal the hook as necessary for a practical service interaction in readable space
  - keep the crypt gate/passage logic bodily and architectural, not menu-like
  - align clue text, traversal pressure, and room affordances around old-age continuity
- `Acceptance criteria:`
  - the player can traverse from blackout descent into wine cellar and crypt coherently
  - lantern and hook understanding develop in sequence rather than all at once
  - the route materially differs from the adult attic finale in space, tone, and interaction grammar
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add elder-route wine-cellar/crypt traversal assertions
- `Status:` pending

### E05
- `ID:` E05
- `Title:` Build the elder crypt final chamber, buried music-box solve, and progression to `Child`
- `Depends on:` E04
- `Why it exists:` the second canonical completion must end with the personal crypt truth, not simply with atmosphere or traversal novelty.
- `Implementation notes:`
  - make `family_crypt` the true final chamber for `Elder`
  - reveal Elizabeth's impossible old age through burial context, preserved objects, and final text
  - converge the childhood winding key, buried music box, and elder-route truth cleanly
  - record route completion and advance the next new game to `Child`
- `Acceptance criteria:`
  - an `Elder` run resolves through the crypt music box rather than attic truth
  - the player understands that Elizabeth lived into old age and still was never released
  - completion records correctly and progression advances to `Child`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - add `godot --headless --path . --script test/e2e/test_elder_route.gd`
- `Status:` pending

### E06
- `ID:` E06
- `Title:` Finalize docs, checkpoints, and visual acceptance for the elder route
- `Depends on:` E02, E03, E04, E05
- `Why it exists:` the route is not durable if runtime, docs, and capture lanes disagree about what the second authored completion is.
- `Implementation notes:`
  - update:
    - `MEMORY.md`
    - `PLAN.md`
    - `STRUCTURE.md`
    - affected route docs and room docs for `foyer`, `attic_stairs`, `attic_storage`, `wine_cellar`, and `family_crypt`
  - update the parent production batch checkpoint where elder-route status changes
  - capture renderer-backed review images for blackout, wine cellar, and crypt
  - make this batch the explicit predecessor to the eventual `Child` route batch
- `Acceptance criteria:`
  - docs describe the same elder-route late game the runtime now ships
  - visual captures exist for the blackout transition and crypt final chamber
  - the repo checkpoint surface points cleanly from `Adult` completion into `Elder`, then on toward `Child`
- `Verification:`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_elder_route.gd`
  - screenshot output exists under Godot `user://`
- `Status:` pending

## Critical Gates
- Gate 1: E01 must produce a concrete elder-route clue map before blackout or crypt implementation starts.
- Gate 2: E03 must land a coherent attic rupture and lantern-on-hook transition before wine-cellar/crypt work begins.
- Gate 3: E04 and E05 together must produce a playable, recordable `Elder` completion before the route can be called done.
- Gate 4: E06 must include renderer-backed review; headless-only completion is insufficient.

## Resume Instructions
- Start from this file and the parent production batch in `docs/batches/ashworth-production-recovery.md`.
- Assume the shared-spine batch in `docs/batches/service-basement-midgame-spine.md` is the upstream dependency.
- Assume the `Adult` route batch in `docs/batches/adult-route-attic-resolution.md` is the immediate predecessor.
- Before editing, verify the current baseline:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
- Resume at E01 unless an elder-route clue audit already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact elder-route inconsistency in `MEMORY.md`.
