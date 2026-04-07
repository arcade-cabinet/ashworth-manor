# Child Route Hidden Room Resolution

## Summary
Build the third and deepest bespoke late-game storyline after the `Elder` route: the `Child` Elizabeth route. This batch exists to turn the attic-directed late game into a sealed-room revelation where childhood memory intrusions, blocked architecture, and attic clues expose the hidden chamber as the true final space and resolve the run through Elizabeth's music box inside the family's foundational lie.

## Scope
- Included work
  - route-specific child clue bias across upper-house and attic approach rooms
  - childhood-memory intrusions that distinguish `Child` from both `Adult` and `Elder`
  - attic clue chain that reveals blocked architecture instead of resolving in the attic proper
  - re-authoring `hidden_chamber` from legacy occult residue into the sealed childhood final space
  - hidden-room music-box solve and `Child` ending logic
  - focused tests, docs, and renderer-backed review for the third canonical route
- Explicitly excluded work
  - reimplementation of `Adult` attic-final or `Elder` crypt-final logic beyond separation fixes
  - broad full-repo cleanup of all remaining stale legacy thread text outside touched rooms and systems
  - post-completion repeat-run randomization tuning
  - optional post-ending epilogue or meta-progression beyond recording the third canonical completion

## Constraints
- Declarations remain canonical.
- This batch assumes the shared-spine tranche is complete through stable midgame house light and walking-stick possession.
- This batch assumes `Adult` and `Elder` are already the completed first and second authored routes.
- `Child` is the deepest revelation and must feel more intimate and devastating than either prior route, not merely smaller in scale.
- The route must begin with attic-directed truth but end in a sealed room, not in the attic proper and not in the crypt.
- The music box remains the invariant final solve object.
- Childhood-memory intrusions must feel authored and specific, not generic ghost montage.
- The hidden chamber must read as architecturally erased family shame, not as a leftover ritual bonus room.
- Elizabeth's laugh only marks significant events; do not use it as ambient filler.
- Visual review is part of done; renderer-backed captures are required.

## Assumptions
- Route progression already enforces `Adult -> Elder -> Child`.
- The player reaches child-route late game through:
  - packet and valise opening
  - dark-house entry
  - first warmth and `firebrand`
  - kitchen service-hatch fall
  - gas restoration
  - stable shared-house light
  - walking-stick phase
  - attic-directed late access already established as part of the route program
- Existing rooms can be selectively rewritten rather than rebuilt wholesale:
  - `upper_hallway`
  - `library`
  - `master_bedroom`
  - `guest_room`
  - `attic_stairs`
  - `attic_storage`
  - `hidden_chamber`
- `hidden_chamber` exists in runtime today but still contains legacy occult / ritual residue that should be treated as stale, not canonical.

## Execution Policy
- Completion standard
  - The batch is complete only when a `Child` run can be played from shared-midgame handoff through attic clue escalation, sealed-room discovery, hidden-room music-box solve, and recorded completion with a route identity clearly distinct from `Adult` and `Elder`.
- Stop conditions
  - Stop if `Adult` and `Elder` route order/progression is not stable enough to hand the player into `Child`.
  - Stop if the hidden-room reveal cannot be expressed cleanly with current declaration/runtime surfaces without broader engine redesign.
  - Stop if the attic clue chain and hidden-room access contradict the canonical route docs.
  - Stop if the route can only be made legible by reviving the old macro PRNG logic.
- Verification cadence
  - Run declaration and interaction checks after each runtime/content slice.
  - Add a dedicated child-route test lane before declaring the route complete.
  - Use renderer-backed captures for attic clue escalation and hidden-room final review.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave the repo with mixed adult/child or elder/child final-room semantics on the same attic surfaces.

## Task Graph

### C01
- `ID:` C01
- `Title:` Audit and map the child-route clue and access surfaces across upper-house rooms, attic, and hidden chamber
- `Depends on:` none
- `Why it exists:` the child route needs a precise clue path through blocked architecture and memory, but the current upper-house and hidden-room surfaces still carry mixed legacy material.
- `Implementation notes:`
  - inspect:
    - `upper_hallway`
    - `library`
    - `master_bedroom`
    - `guest_room`
    - `attic_stairs`
    - `attic_storage`
    - `hidden_chamber`
  - define the child-route clue path from attic suspicion to sealed-room certainty
  - identify which current clues can be retained, rewritten, or removed
  - record the concrete state keys and room-response pivots needed for the child route
- `Acceptance criteria:`
  - there is a clear child-route clue topology from upper house to hidden room
  - each critical room has an identified child-route narrative job
  - downstream tasks can implement against named rooms and route states rather than only thematic language
- `Verification:`
  - declaration/doc audit across the target room files
  - update `MEMORY.md` with the agreed child-route clue map
- `Status:` pending

### C02
- `ID:` C02
- `Title:` Re-author child-route clue bias and childhood-memory intrusions before the hidden-room reveal
- `Depends on:` C01
- `Why it exists:` the route must feel childhood-specific before the wall opens, or the sealed-room ending will read as a twist rather than the deepest pattern in the house.
- `Implementation notes:`
  - use `elizabeth_route = child` to bias read in shared upper-house and attic-adjacent rooms
  - prioritize:
    - nursery traces
    - blocked or plastered-over architecture
    - family concealment
    - the player's own childhood memory fragments
  - distinguish this route from `Adult` biography and `Elder` burial continuity
  - keep outside paperwork neutral
- `Acceptance criteria:`
  - the player can feel child-route identity before the hidden chamber is found
  - route content reads as sealed childhood horror and recovered family shame
  - upper-house and attic-approach rooms remain usable while meaningfully changing emphasis for `Child`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add child-route assertions for at least two upper-house rooms and one attic room
- `Status:` pending

### C03
- `ID:` C03
- `Title:` Build the child-route attic clue chain and sealed-room discovery sequence
- `Depends on:` C01, C02
- `Why it exists:` the route only becomes truly distinct when the attic stops being the answer and becomes the place that points at something worse hidden inside the house body.
- `Implementation notes:`
  - use `attic_stairs` and `attic_storage` as the late clue engine
  - reveal blocked architecture through believable architectural evidence, not arbitrary hotspot magic
  - ensure the hidden-room discovery feels earned through accumulated clue pressure and bodily investigation
  - preserve route distinction from the adult attic final chamber
- `Acceptance criteria:`
  - the player is unmistakably redirected from attic truth to sealed-room truth
  - the discovery of the hidden chamber feels architectural and authored
  - the route no longer depends on attic-final or crypt-final grammar to resolve
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - add targeted child-route attic-discovery assertions
- `Status:` pending

### C04
- `ID:` C04
- `Title:` Re-author the hidden chamber into the child-route final room and music-box solve
- `Depends on:` C03
- `Why it exists:` the existing hidden chamber is not yet the sealed childhood room the route needs; the final chamber must carry the foundational family crime.
- `Implementation notes:`
  - replace legacy occult/ritual read with sealed childhood truth
  - stage the room around:
    - blocked domestic history
    - preserved child traces
    - the music box as the room's emotional center
  - align room text, object placement, and reveal order around the hidden-child payoff
  - converge the childhood winding key and hidden-room music box coherently
- `Acceptance criteria:`
  - `hidden_chamber` functions as a true child-route final chamber
  - the player understands the room as an architecturally erased childhood prison, not a generic secret chamber
  - the childhood winding key and music box meet coherently in the final solve
- `Verification:`
  - add `godot --headless --path . --script test/e2e/test_child_route.gd`
- `Status:` pending

### C05
- `ID:` C05
- `Title:` Wire the child-route ending, third completion state, and post-canonical progression behavior
- `Depends on:` C04
- `Why it exists:` the third canonical completion must end cleanly, record correctly, and hand the game into its post-canonical repeat-run state without ambiguity.
- `Implementation notes:`
  - connect the child-route solved state to ending presentation and save progression
  - ensure `completed_routes` records `child`
  - keep ending text specific to erased-child truth
  - update progression semantics for post-third-completion runs only as needed to preserve the canonical order already completed
- `Acceptance criteria:`
  - a `Child` completion records correctly
  - the route's ending content matches the hidden-room childhood payoff
  - the game exits the first-three-run program cleanly after `Child`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_child_route.gd`
- `Status:` pending

### C06
- `ID:` C06
- `Title:` Finalize docs, checkpoints, and visual acceptance for the child route
- `Depends on:` C02, C03, C04, C05
- `Why it exists:` the route is not durable if runtime, docs, and capture lanes disagree about what the third authored completion is and how the overall game transitions after it.
- `Implementation notes:`
  - update:
    - `MEMORY.md`
    - `PLAN.md`
    - `STRUCTURE.md`
    - affected route docs and room docs for `upper_hallway`, `library`, `master_bedroom`, `guest_room`, `attic_stairs`, `attic_storage`, and `hidden_chamber`
  - update the parent production batch checkpoint where child-route status changes
  - capture renderer-backed review images for attic clues and hidden-room final chamber
  - make this batch the explicit predecessor to whole-game acceptance and stale-text migration cleanup
- `Acceptance criteria:`
  - docs describe the same child-route late game the runtime now ships
  - visual captures exist for the attic clue escalation and hidden-room final chamber
  - the repo checkpoint surface points cleanly from `Child` completion into final whole-game acceptance work
- `Verification:`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_child_route.gd`
  - screenshot output exists under Godot `user://`
- `Status:` pending

## Critical Gates
- Gate 1: C01 must produce a concrete child-route clue map before hidden-room discovery work begins.
- Gate 2: C03 must establish a coherent attic clue chain and sealed-room reveal before final-chamber work begins.
- Gate 3: C04 and C05 together must produce a playable, recordable `Child` completion before the route can be called done.
- Gate 4: C06 must include renderer-backed review; headless-only completion is insufficient.

## Resume Instructions
- Start from this file and the parent production batch in `docs/batches/ashworth-production-recovery.md`.
- Assume the shared-spine batch in `docs/batches/service-basement-midgame-spine.md` is the upstream dependency.
- Assume the `Adult` route batch in `docs/batches/adult-route-attic-resolution.md` and the `Elder` route batch in `docs/batches/elder-route-crypt-resolution.md` are the immediate predecessors.
- Before editing, verify the current baseline:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
- Resume at C01 unless a child-route clue audit already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact child-route inconsistency in `MEMORY.md`.
