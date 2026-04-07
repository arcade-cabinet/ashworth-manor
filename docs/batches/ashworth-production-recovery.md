# Ashworth Manor Polished Completion

## Summary

Drive Ashworth Manor from partial recovery into a shippable, authored game with
one coherent premise, one shared mansion spine, and three bespoke Elizabeth
storylines (`Adult`, `Elder`, `Child`). This batch exists to replace the old
PRNG/weave-centric recovery plan with an execution graph that can carry docs,
runtime, declarations, art direction, and acceptance to polished completion.

## Scope

- Included work:
  - migration off the old `Captive / Mourning / Sovereign` framing
  - opening solicitor-packet and valise flow
  - shared early/mid mansion spine
  - tool and light progression
  - adult route implementation
  - elder route implementation
  - child route implementation
  - room/declaration/doc migration
  - renderer-backed polish and end-to-end acceptance
- Explicitly excluded work:
  - combat or enemy systems
  - non-diegetic HUD redesign
  - preserving legacy save compatibility
  - broad content expansion unrelated to the three canonical routes

## Constraints

- Declarations remain the canonical content layer unless a subsystem is
  intentionally replaced
- The playable present is near-post-Victorian, not a modern ruin
- Outside paperwork and estate signage remain neutral
- The old weave docs and thread text are legacy material, not canonical target
  behavior
- Procedural shell > inset model detail > procedural moving mechanism remains
  the architectural stack
- Creative direction is procedural-first and model-assisted
- Lighting must feel sourced; no source-less ambient uplift
- Visual acceptance must come from runtime capture lanes, not code inspection
  alone

## Assumptions

- Existing tests may be rewritten or extended as needed to match the new canon
- It is acceptable to break legacy story assumptions if doing so is required to
  land the new route program cleanly
- The first three completions are fixed: `Adult -> Elder -> Child`
- The music box is the invariant solve object for every route
- Shared early/mid implementation should be completed before bespoke late-route
  polish fans out aggressively

## Execution Policy

- Completion standard:
  - no task is complete until its acceptance criteria and verification both pass
- Stop conditions:
  - critical blocker
  - contradictory requirements
  - failing verification with no credible local fix
  - user redirect
- Verification cadence:
  - run targeted checks at the end of each task
  - run broader regression suites at each critical gate
  - review renderer-driven lanes whenever critical-path staging changes
- Partial completion is not acceptable for route-critical tasks; partial work is
  only acceptable for clearly marked supporting polish tasks

## Task Graph

### T01
- `Title:` Migrate the canonical narrative surfaces to the three-route program
- `Depends on:` none
- `Why it exists:` runtime work will drift unless docs, route order, and route
  identity are made explicit everywhere
- `Implementation notes:`
  - finish high-level doc migration
  - add explicit deprecation notes where old weave docs remain
  - ensure `Adult -> Elder -> Child` is unambiguous
- `Acceptance criteria:`
  - top-level narrative docs describe the same game
  - no high-level canonical doc claims PRNG macro routes or the old weave as
    shipped canon
- `Verification:`
  - docs spot-check across `PLAYER_PREMISE.md`, `NARRATIVE.md`,
    `ELIZABETH_ROUTE_PROGRAM.md`, `MASTER_SCRIPT.md`, `script/MASTER_SCRIPT.md`
- `Status:` completed

### T02
- `Title:` Encode route order and storyline identity in runtime state
- `Depends on:` T01
- `Why it exists:` the game needs an actual progression model for `Adult`,
  `Elder`, and `Child`
- `Implementation notes:`
  - add route identity and completion state to the canonical game state layer
  - make first/second/third completion order enforceable
  - prevent stray old thread-state assumptions from driving macro story
- `Acceptance criteria:`
  - runtime can identify active route
  - first run resolves to `Adult`
  - second run resolves to `Elder`
  - third run resolves to `Child`
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - targeted route-state test coverage
- `Status:` verified_done

### T03
- `Title:` Implement the solicitor-packet and valise opening flow
- `Depends on:` T01
- `Why it exists:` the current boot flow does not yet match the canonical heir
  return premise
- `Implementation notes:`
  - open on an inner solicitor page
  - resolve first-person as the hired cab departs
  - place the valise beneath the estate sign
  - establish diegetic inventory from the valise
- `Acceptance criteria:`
  - the opening begins with packet reading rather than detached menu/UI logic
  - the player opens the valise before entering the grounds
  - the front-door key and packet are grounded in-world
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` verified_done

### T04
- `Title:` Finish the front-gate, drive, and forecourt opening composition
- `Depends on:` T03
- `Why it exists:` the gate/drive/steps chain must communicate wealth, burden,
  and withheld estate scale immediately
- `Implementation notes:`
  - preserve the neutral sign
  - keep the mansion mostly withheld on first approach
  - show side-route promise only at the forecourt via locked side gates
- `Acceptance criteria:`
  - opening frames read as a coherent ceremonial approach
  - the player sees a believable burden-estate rather than a flat stage facade
  - the forecourt reveals controlled estate complexity without diagramming it
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - renderer screenshots for gate, drive, front steps, and front-door approach
- `Status:` verified_done

### T05
- `Title:` Implement dark-house entry and first warmth/light occupation
- `Depends on:` T03, T04
- `Why it exists:` the mansion must feel unwelcoming and physically occupied by
  the player, not pre-lit and passive
- `Implementation notes:`
  - keep the house dark on arrival
  - player unlocks the front door personally
  - land the first family-centered answer through room and hearth/chandelier
    logic
  - start the `firebrand` phase here
- `Acceptance criteria:`
  - house entry is dark and sourced
  - first warmth/light beat feels authored rather than abstract
  - firebrand becomes the early held-light state
- `Verification:`
  - targeted opening playthrough
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` verified_done

### T06
- `Title:` Build the early ground-floor cluster and first Elizabeth seizure
- `Depends on:` T05
- `Why it exists:` the player needs a brief sense of agency before Elizabeth
  violently redirects the route
- `Implementation notes:`
  - let foyer/parlor/kitchen/dining function as a readable cluster
  - use the kitchen-side service opening as the descent trigger
  - use the existing laugh OGG as the first undeniable major event cue
- `Acceptance criteria:`
  - early cluster exploration feels intentional and navigable
  - Elizabeth's laugh only fires when the descent event occurs
  - the forced descent reads as authored service architecture, not random trap
- `Verification:`
  - targeted interaction lane
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `Status:` verified_done

### T07
- `Title:` Complete the service-basement gas restoration sequence
- `Depends on:` T06
- `Why it exists:` this is the shared-spine turn from improvised survival to
  restored house-state light
- `Implementation notes:`
  - keep the basement a real service-maintenance world
  - use pressured navigation plus a few decisive actions rather than simulation
  - local basement sconces should answer immediately when gas returns
- `Acceptance criteria:`
  - the player can relight under pressure below
  - gas restoration changes basement and house state coherently
  - the sequence feels like reclaiming infrastructure, not solving boiler cosplay
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - targeted basement/gas test coverage
- `Status:` in_progress

### T08
- `Title:` Implement the midgame walking-stick investigation phase
- `Depends on:` T07
- `Why it exists:` Ashworth needs a second embodied investigation mode after the
  fragile firebrand phase ends
- `Implementation notes:`
  - transition from firebrand to walking stick
  - emerge via shared/utilitarian circulation
  - use the stick for stability, probing, and deliberate investigation
- `Acceptance criteria:`
  - walking stick clearly replaces the firebrand phase
  - the midgame house feels more legible and possessed rather than merely lit
  - the player can use the stick in at least one meaningful investigative verb
- `Verification:`
  - targeted midgame traversal checks
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### T09
- `Title:` Re-author midgame clue topology around the new route program
- `Depends on:` T07, T08
- `Why it exists:` route-specific clue pressure currently assumes the old weave
  and cannot support bespoke storylines cleanly
- `Implementation notes:`
  - reframe clue emphasis for `Adult`, `Elder`, and `Child`
  - keep shared rooms useful across routes while changing what matters inside
    them
  - bias rooms, documents, and reveals toward each route's signature
- `Acceptance criteria:`
  - midgame clue read differs meaningfully by route
  - route identity is apparent before the final chamber without spoiling it
- `Verification:`
  - route-specific narrative spot-checks
  - docs and declaration diff review
- `Status:` pending

### T10
- `Title:` Implement the late blackout and descent grammar
- `Depends on:` T08
- `Why it exists:` late game needs a singular terror phase that strips away
  midgame certainty
- `Implementation notes:`
  - remove stable house light
  - consume the walking-stick phase
  - use darkness navigation, glowing footprints, and real physical failure risk
    where appropriate
- `Acceptance criteria:`
  - late transition feels categorically different from early and midgame
  - the player loses the walking stick during the blackout transition
  - only route-appropriate guidance remains in true darkness
- `Verification:`
  - targeted late-transition coverage
  - visual walkthrough capture of the blackout sequence
- `Status:` pending

### T11
- `Title:` Build the lantern-on-hook to lantern-hook late-tool transition
- `Depends on:` T10
- `Why it exists:` the final phase needs a reach/pull instrument that emerges
  naturally from late darkness rather than appearing as arbitrary loot
- `Implementation notes:`
  - start with lantern hanging on the hook
  - teach the lantern as light first
  - reveal the hook's reach/pull use second
  - first clear hook use should be a lit-basement service hatch, not an attic
    tutorial
- `Acceptance criteria:`
  - the player first understands the lantern, then the hook
  - the hook's first use is readable and grounded
  - the hook becomes the late held tool without muddying earlier phases
- `Verification:`
  - targeted hook interaction tests
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `Status:` pending

### T12
- `Title:` Ship the Adult route end-to-end
- `Depends on:` T09, T10, T11
- `Why it exists:` `Adult` is the first completion and must anchor the whole
  game's structure
- `Implementation notes:`
  - build the attic as the final adult truth space
  - make adult-life clues and attic resolution coherent
  - resolve the route through the music box
- `Acceptance criteria:`
  - a full `Adult` playthrough is completable from opening to music-box ending
  - attic ending meaning clearly reads as stolen adulthood
  - runtime, docs, and declaration text agree on the route
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - targeted adult-route walkthrough/test lane
- `Status:` pending

### T13
- `Title:` Ship the Elder route end-to-end
- `Depends on:` T12
- `Why it exists:` `Elder` is the second authored completion and must broaden
  the player's understanding rather than repeating Adult in a new room
- `Implementation notes:`
  - use attic-side rupture and burial-side logic to drive the player to the
    crypt
  - make the crypt personal, not generic funerary scenery
  - resolve the route through Elder Elizabeth's buried music box
- `Acceptance criteria:`
  - a full `Elder` playthrough is completable from opening to music-box ending
  - crypt ending meaning clearly reads as continuity that should have ended
  - route feels materially different from `Adult`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - targeted elder-route walkthrough/test lane
- `Status:` pending

### T14
- `Title:` Ship the Child route end-to-end
- `Depends on:` T12, T13
- `Why it exists:` `Child` is the third and deepest revelation; it must feel
  like the foundational wound, not a minor variant
- `Implementation notes:`
  - reuse the attic truth path only until the sealed-room clue chain diverges
  - make childhood-memory pressure stronger and more intimate
  - expose the hidden room as a real architectural discovery
- `Acceptance criteria:`
  - a full `Child` playthrough is completable from opening to music-box ending
  - the sealed hidden room reads as the deepest family lie
  - route feels more revelatory and intimate than either `Adult` or `Elder`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - targeted child-route walkthrough/test lane
- `Status:` pending

### T15
- `Title:` Unify the music-box and winding-key finale system
- `Depends on:` T12, T13, T14
- `Why it exists:` the same solve object must carry all three routes without
  becoming generic
- `Implementation notes:`
  - connect the childhood winding key to the final music-box interaction
  - allow each route to reinterpret the same object differently
  - keep final play centered on the box rather than diffuse ritual junk
- `Acceptance criteria:`
  - the winding key and music box form one coherent symbolic and mechanical arc
  - each route's final interaction feels specific, not reskinned
- `Verification:`
  - targeted ending tests
  - route-ending docs/runtime review
- `Status:` pending

### T16
- `Title:` Migrate room docs, declaration text, and puzzle declarations off the old weave
- `Depends on:` T09, T12, T13, T14
- `Why it exists:` large parts of the repo still describe a different game
- `Implementation notes:`
  - update stale room docs first on the critical path
  - retire or rewrite old thread-conditioned text and declarations
  - keep room docs aligned with the new route signatures
- `Acceptance criteria:`
  - critical-path room docs no longer frame themselves through
    `Captive / Mourning / Sovereign`
  - puzzle docs and declaration text describe the new authored routes
- `Verification:`
  - `rg -n \"Captive|Mourning|Sovereign|weave\" docs declarations`
  - targeted docs/declaration review
- `Status:` pending

### T17
- `Title:` Polish the mansion with route-aware asset, material, and lighting passes
- `Depends on:` T05, T08, T12, T13, T14
- `Why it exists:` the game's final quality depends on sourced lighting,
  material identity, and selective model use, not just logic completeness
- `Implementation notes:`
  - follow the procedural-first, model-assisted doctrine
  - prioritize critical-path rooms and route-unique finales
  - review estate materials, lamps, hearths, glass, cellar/crypt mood, and
    sealed-room reads
- `Acceptance criteria:`
  - critical-path rooms have clear physical-source lighting
  - route finale spaces have distinct visual identity
  - imported models are used where silhouette matters, not as architecture
    crutches
- `Verification:`
  - renderer captures for opening, basement, attic, crypt, and hidden room
  - visual walkthrough review
- `Status:` pending

### T18
- `Title:` Expand automated coverage for the new route program
- `Depends on:` T12, T13, T14, T15
- `Why it exists:` the current tests do not yet prove the new three-route game
- `Implementation notes:`
  - add route-order coverage
  - add shared-spine coverage
  - add route-specific endgame and ending coverage
- `Acceptance criteria:`
  - automated tests can distinguish `Adult`, `Elder`, and `Child`
  - regressions in route order, route gating, or route endings fail loudly
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `Status:` pending

### T19
- `Title:` Rebuild the visual walkthrough and opening-journey acceptance lanes
- `Depends on:` T04, T05, T07, T17
- `Why it exists:` the product-truth lanes must reflect the new opening and
  shared-spine reality
- `Implementation notes:`
  - update capture sequences to include packet/valise opening expectations
  - ensure critical route finale spaces are represented in review lanes
- `Acceptance criteria:`
  - opening-journey captures show the canonical heir-return sequence
  - walkthrough captures represent the new lighting and route grammar
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### T20
- `Title:` Production acceptance freeze
- `Depends on:` T01, T02, T03, T04, T05, T06, T07, T08, T09, T10, T11, T12,
  T13, T14, T15, T16, T17, T18, T19
- `Why it exists:` the repo should only be called complete once logic, docs,
  visuals, and route endings all converge
- `Implementation notes:`
  - run the full command surface
  - review final renderer captures
  - confirm no critical room or route still behaves like legacy weave content
- `Acceptance criteria:`
  - the canonical docs describe the actual playable game
  - shared spine and all three routes are playable
  - critical tests and visual lanes pass
  - no major old-weave assumption remains on the critical path
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

## Critical Gates

- Gate A:
  - canonical narrative docs and route-order runtime state are aligned before
    wide implementation continues
- Gate B:
  - packet/valise opening, dark-house entry, service descent, and gas
    restoration are playable before bespoke late routes branch out
- Gate C:
  - `Adult` route is complete before `Elder` diverges heavily
- Gate D:
  - `Adult` and `Elder` are complete before the `Child` route becomes the
    deeper third revelation
- Gate E:
  - docs, declarations, tests, and renderer captures all agree before final
    freeze

## Resume Instructions

1. Read this file first.
2. Read `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md`.
3. Read `docs/PLAYER_PREMISE.md`, `docs/ELIZABETH_ROUTE_PROGRAM.md`, and
   `docs/MASTER_SCRIPT.md`.
4. Resume from the earliest unblocked task not marked complete.
5. Update task statuses as work progresses.
6. When implementation changes the game's canon, reflect that in docs before
   moving to downstream polish.
