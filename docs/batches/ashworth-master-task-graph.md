# Ashworth Manor Master Task Graph

## Summary

Ship Ashworth Manor as one coherent game by implementing the shared early/mid
spine, all three authored Elizabeth routes, the unified music-box finale
system, complete canonical documentation, acceptance rebuild, release-candidate
validation, and post-freeze handoff. This batch supersedes the fragmented
execution chain as the single master implementation contract for the whole
project.

## Scope

- Included work
  - canonical documentation for the whole game
  - shared-spine implementation from packet arrival through walking-stick
    midgame
  - `Adult`, `Elder`, and `Child` route implementation
  - route-unified finale and progression systems
  - critical-path room-doc and declaration-text migration
  - automated and renderer-backed acceptance rebuild
  - archive/handoff hygiene
  - post-freeze maintenance posture
  - Android release-candidate/export validation
- Explicitly excluded work
  - new routes beyond `Adult`, `Elder`, and `Child`
  - combat, enemies, or HUD-first redesign
  - modernized setting or new macro-weave resurrection
  - storefront/publishing work beyond build and device validation

## Constraints

- Declarations remain canonical.
- The shipped route order is `Adult -> Elder -> Child`.
- Outside paperwork and estate signage remain neutral.
- The music box is the invariant final solve object.
- Lighting must remain visibly sourced.
- The project stays procedural-first and model-assisted.
- Do not revive the old `Captive / Mourning / Sovereign` weave as active
  design.
- Visual review is required for critical-path completion.
- Batch statuses must stay honest: `pending`, `in_progress`, `blocked`,
  `verified_done`, `skipped`.

## Assumptions

- The front-gate packet/valise sequence, keyed dark entry, parlor firebrand,
  and kitchen service-hatch fall already exist in partial runtime form.
- Canonical narrative docs already exist but require consolidation and
  migration:
  - `docs/PLAYER_PREMISE.md`
  - `docs/ELIZABETH_ROUTE_PROGRAM.md`
  - `docs/NARRATIVE.md`
  - `docs/MASTER_SCRIPT.md`
  - `docs/script/MASTER_SCRIPT.md`
- Many room docs and some declaration-era text still reflect the old weave.
- Existing focused batches can remain as historical support, but this file is
  now the primary execution contract.

## Execution Policy

- Completion standard
  - The batch is complete only when the runtime, declarations, docs, tests,
    renderer captures, and packaged-validation surfaces all describe the same
    shipped game.
- Stop conditions
  - Stop if a task requires reopening the fundamental route program.
  - Stop if a required environment artifact cannot be created or inferred
    safely.
  - Stop if verification repeatedly fails after a reasonable repair attempt.
- Verification cadence
  - Run the smallest meaningful verification surface after each task.
  - Re-run renderer-backed lanes for perception-sensitive work.
  - Re-run full acceptance at major phase boundaries.
- Partial completion
  - Acceptable only at verified checkpoint boundaries.
  - Do not leave the repo with mixed canonical and legacy truth on the same
    critical path.

## Task Graph

### P01
- `ID:` P01
- `Title:` Consolidate the whole-game canonical documentation surface
- `Depends on:` none
- `Why it exists:` the repo needs one whole-game canonical document before
  implementation and migration can converge.
- `Implementation notes:`
  - create or update a single whole-game source of truth
  - define premise, room program, route program, tools, lights, endings, and
    acceptance surface together
- `Acceptance criteria:`
  - one doc covers the whole shipped game coherently
  - conflicting older top-level descriptions are superseded
- `Verification:`
  - targeted doc review across canonical top-level docs
- `Status:` pending

### P02
- `ID:` P02
- `Title:` Repoint docs index and checkpoint surfaces to the canonical whole-game docs
- `Depends on:` P01
- `Why it exists:` contributors need to find the canonical doc surface first,
  not by archaeology.
- `Implementation notes:`
  - update index and checkpoint surfaces
  - identify older docs as support or legacy where needed
- `Acceptance criteria:`
  - repo entry points name the canonical source map clearly
- `Verification:`
  - review `docs/INDEX.md`, `PLAN.md`, `MEMORY.md`, `STRUCTURE.md`
- `Status:` pending

### P03
- `ID:` P03
- `Title:` Replace fragmented execution references with one master task graph
- `Depends on:` P01, P02
- `Why it exists:` execution should flow from one master contract rather than a
  chain of smaller planning artifacts.
- `Implementation notes:`
  - mark this file as primary
  - repoint checkpoint files to it
- `Acceptance criteria:`
  - the repo names one authoritative implementation batch
- `Verification:`
  - targeted checkpoint review
- `Status:` pending

### P04
- `ID:` P04
- `Title:` Capture the current runtime baseline and state-surface audit
- `Depends on:` P03
- `Why it exists:` implementation needs a verified starting point before
  changing basement, route, and acceptance systems.
- `Implementation notes:`
  - audit shared-spine state keys, route order state, and active test lanes
- `Acceptance criteria:`
  - baseline runtime and state assumptions are recorded in `MEMORY.md`
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `Status:` pending

### P05
- `ID:` P05
- `Title:` Establish the canonical shared-spine state map
- `Depends on:` P04
- `Why it exists:` basement, gas, and tool logic need one coherent state map.
- `Implementation notes:`
  - define the minimum canonical states for basement relight, fume pressure,
    gas restored, basement lights awake, stable house light, and walking-stick
    phase
- `Acceptance criteria:`
  - downstream shared-spine work can target concrete state keys
- `Verification:`
  - declaration/runtime diff review
- `Status:` pending

### P06
- `ID:` P06
- `Title:` Finalize the solicitor packet and valise opening flow
- `Depends on:` P04
- `Why it exists:` the game must open cleanly on legal duty and embodied
  arrival.
- `Implementation notes:`
  - ensure packet, valise, initial items, and first arrival mutter work as
    intended
- `Acceptance criteria:`
  - opening always lands on the canonical heir-return sequence
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### P07
- `ID:` P07
- `Title:` Finalize front gate composition and threshold behavior
- `Depends on:` P06
- `Why it exists:` the gate is the first embodied room and social threshold.
- `Implementation notes:`
  - validate sign, lamp, valise placement, and gate commitment logic
- `Acceptance criteria:`
  - front gate reads as respectable, eerie, and materially grounded
- `Verification:`
  - renderer-backed opening capture review
- `Status:` pending

### P08
- `ID:` P08
- `Title:` Finalize the ceremonial drive and mansion-withheld approach
- `Depends on:` P07
- `Why it exists:` the approach teaches wealth, distance, and emptiness.
- `Implementation notes:`
  - align drive lower/upper with hedge discipline and withheld mansion reads
- `Acceptance criteria:`
  - the opening walk feels singular, long, and controlled
- `Verification:`
  - renderer-backed opening capture review
- `Status:` pending

### P09
- `ID:` P09
- `Title:` Finalize the forecourt reveal and locked side-gate logic
- `Depends on:` P08
- `Why it exists:` the forecourt is the first revelation of the estate's wider
  plan.
- `Implementation notes:`
  - keep center stair dominant and side routes peripheral but legible
- `Acceptance criteria:`
  - front steps reveal future grounds access without flattening the approach
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### P10
- `ID:` P10
- `Title:` Finalize keyed dark-house entry and first foyer state
- `Depends on:` P09
- `Why it exists:` the house must be dark and unreceptive on arrival.
- `Implementation notes:`
  - confirm front-door key, dark foyer, and threshold text/lighting logic
- `Acceptance criteria:`
  - entry into the mansion feels cold, private, and unwelcoming
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### P11
- `ID:` P11
- `Title:` Finalize the first-warmth trigger logic across early-family rooms
- `Depends on:` P10
- `Why it exists:` the first house answer needs one coherent rule set.
- `Implementation notes:`
  - align foyer/parlor/kitchen/dining early cluster expectations with current
    canonical route program
- `Acceptance criteria:`
  - first warmth and first answer are unambiguous and bodily
- `Verification:`
  - targeted interaction tests
- `Status:` pending

### P12
- `ID:` P12
- `Title:` Complete the parlor hearth and firebrand acquisition
- `Depends on:` P11
- `Why it exists:` the early carried-light phase starts here.
- `Implementation notes:`
  - ensure the hearth interaction, text, and item/state effects are coherent
- `Acceptance criteria:`
  - the player reliably enters the `firebrand` phase through the first-warmth
    beat
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `Status:` pending

### P13
- `ID:` P13
- `Title:` Finalize early ground-floor cluster pacing and service-hatch trigger conditions
- `Depends on:` P12
- `Why it exists:` the player needs brief agency before Elizabeth seizes the
  route.
- `Implementation notes:`
  - align foyer/parlor/kitchen/dining room flow and service-hatch availability
- `Acceptance criteria:`
  - early exploration breathes and still leads cleanly to the seizure
- `Verification:`
  - opening and interaction E2E review
- `Status:` pending

### P14
- `ID:` P14
- `Title:` Finalize Elizabeth's first laugh and forced kitchen-side descent
- `Depends on:` P13
- `Why it exists:` Elizabeth's first undeniable agency beat must be authored and
  stable.
- `Implementation notes:`
  - ensure the laugh, firebrand loss, and forced descent transition are
    coherent
- `Acceptance criteria:`
  - kitchen service descent reliably triggers and feels intentional rather than
    glitchy
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### P15
- `ID:` P15
- `Title:` Implement the storage-basement forced-fall landing beat
- `Depends on:` P05, P14
- `Why it exists:` the basement needs a real landing event, not just a room
  load.
- `Implementation notes:`
  - land on oily rags, lose breath, and establish dark service-world pressure
- `Acceptance criteria:`
  - the first basement arrival is consequential and legible
- `Verification:`
  - targeted basement entry assertions
- `Status:` pending

### P16
- `ID:` P16
- `Title:` Implement improvised relight in the storage basement
- `Depends on:` P15
- `Why it exists:` the player must recover light bodily before proceeding.
- `Implementation notes:`
  - use match + oily-rag logic
  - keep it concise and embodied
- `Acceptance criteria:`
  - the player cannot wander comfortably without reclaiming some light
- `Verification:`
  - targeted interaction tests
- `Status:` pending

### P17
- `ID:` P17
- `Title:` Implement basement bad-air pressure and its failure consequences
- `Depends on:` P16
- `Why it exists:` the basement needs real urgency and risk.
- `Implementation notes:`
  - make fumes materially present without HUD timers
- `Acceptance criteria:`
  - the bad-air condition pressures movement and can fail the player
- `Verification:`
  - targeted basement survival assertions
- `Status:` pending

### P18
- `ID:` P18
- `Title:` Re-author the boiler room as concise service machinery
- `Depends on:` P05, P17
- `Why it exists:` the boiler room must support gas reclamation cleanly.
- `Implementation notes:`
  - remove or quarantine stale occult/simulation-heavy logic
- `Acceptance criteria:`
  - the boiler room reads as service machinery, not abstract boiler cosplay
- `Verification:`
  - targeted declaration/runtime review
- `Status:` pending

### P19
- `ID:` P19
- `Title:` Implement the decisive gas-restoration sequence
- `Depends on:` P18
- `Why it exists:` this is the turn from personal light to estate
  infrastructure.
- `Implementation notes:`
  - use a few meaningful actions only
- `Acceptance criteria:`
  - gas restoration is shorter than a simulation and stronger than a single tap
- `Verification:`
  - targeted boiler-room interaction tests
- `Status:` pending

### P20
- `ID:` P20
- `Title:` Wake basement sconces immediately on gas restoration
- `Depends on:` P19
- `Why it exists:` the player must feel the restoration locally and at once.
- `Implementation notes:`
  - update basement lights and immediate response text
- `Acceptance criteria:`
  - basement lighting visibly changes the moment gas is restored
- `Verification:`
  - room spec / interaction test coverage
- `Status:` pending

### P21
- `ID:` P21
- `Title:` Propagate stable midgame house light across the shared accessible mansion
- `Depends on:` P19, P20
- `Why it exists:` the house should stop feeling like separate dark prototypes.
- `Implementation notes:`
  - sync restored-light state across relevant room loads
- `Acceptance criteria:`
  - ordinary navigation no longer depends on carried fire after restoration
- `Verification:`
  - room spec coverage and walkthrough review
- `Status:` pending

### P22
- `ID:` P22
- `Title:` Build the shared/utilitarian return route out of the service world
- `Depends on:` P21
- `Why it exists:` re-emergence should teach classed circulation, not snap back
  to ceremonial space.
- `Implementation notes:`
  - return through practical/shared circulation
- `Acceptance criteria:`
  - the player exits the basement through socially coherent practical routing
- `Verification:`
  - targeted traversal tests
- `Status:` pending

### P23
- `ID:` P23
- `Title:` Implement walking-stick acquisition as the midgame tool transition
- `Depends on:` P22
- `Why it exists:` the shared spine must hand the player into a new held-tool
  identity.
- `Implementation notes:`
  - consume the early light phase decisively
  - acquire stick in plausible overlap circulation
- `Acceptance criteria:`
  - `walking stick` replaces the earlier phase cleanly
- `Verification:`
  - interaction tests for tool state
- `Status:` pending

### P24
- `ID:` P24
- `Title:` Give the walking stick an immediate first meaningful use
- `Depends on:` P23
- `Why it exists:` the tool should matter immediately, not exist as symbolic
  inventory.
- `Implementation notes:`
  - use probing, balance, or a first physical manipulation beat
- `Acceptance criteria:`
  - the player immediately understands why the walking stick matters
- `Verification:`
  - targeted interaction tests
- `Status:` pending

### P25
- `ID:` P25
- `Title:` Audit and map adult-route clue surfaces
- `Depends on:` P24
- `Why it exists:` the first full route needs a concrete clue topology.
- `Implementation notes:`
  - audit upper floor and attic spaces for `Adult`
- `Acceptance criteria:`
  - adult-route clue map is recorded and implementable
- `Verification:`
  - update `MEMORY.md` with the clue map
- `Status:` pending

### P26
- `ID:` P26
- `Title:` Re-author adult clue bias across shared and upper-house rooms
- `Depends on:` P25
- `Why it exists:` `Adult` must feel biographical before the attic finale.
- `Implementation notes:`
  - bias toward letters, portraits, private effects, and denied adulthood
- `Acceptance criteria:`
  - adult-route identity is legible before the final chamber
- `Verification:`
  - targeted route interaction tests
- `Status:` pending

### P27
- `ID:` P27
- `Title:` Implement adult late rupture and attic-directed access
- `Depends on:` P26
- `Why it exists:` the first route must commit to attic truth.
- `Implementation notes:`
  - make the attic the final truth architecture
- `Acceptance criteria:`
  - adult late game clearly aims at attic resolution
- `Verification:`
  - targeted traversal tests
- `Status:` pending

### P28
- `ID:` P28
- `Title:` Build the adult attic final chamber
- `Depends on:` P27
- `Why it exists:` the attic must work as a full end chamber, not a clue room.
- `Implementation notes:`
  - stage lost adulthood and private life evidence in the attic chamber
- `Acceptance criteria:`
  - attic functions as the true final room for `Adult`
- `Verification:`
  - route-specific chamber tests
- `Status:` pending

### P29
- `ID:` P29
- `Title:` Implement the adult music-box solve and ending
- `Depends on:` P28
- `Why it exists:` the first route must resolve through the music box
  specifically.
- `Implementation notes:`
  - converge winding key, attic music box, and adult ending
- `Acceptance criteria:`
  - adult route resolves cleanly and records completion
- `Verification:`
  - route progression tests and adult-route coverage
- `Status:` pending

### P30
- `ID:` P30
- `Title:` Capture docs and visual acceptance for the adult route
- `Depends on:` P29
- `Why it exists:` `Adult` must be durable as the first canonical completion.
- `Implementation notes:`
  - update docs and capture attic-route visuals
- `Acceptance criteria:`
  - runtime, docs, and captures agree on `Adult`
- `Verification:`
  - renderer-backed adult capture lane
- `Status:` pending

### P31
- `ID:` P31
- `Title:` Audit and map elder-route clue surfaces
- `Depends on:` P30
- `Why it exists:` `Elder` needs distinct burial-side clue pressure.
- `Implementation notes:`
  - audit foyer/great-hall, attic rupture, wine cellar, and crypt
- `Acceptance criteria:`
  - elder-route clue map is recorded and implementable
- `Verification:`
  - update `MEMORY.md`
- `Status:` pending

### P32
- `ID:` P32
- `Title:` Re-author elder clue bias across shared and upper-house rooms
- `Depends on:` P31
- `Why it exists:` the second route must feel old, preserved, and accusatory
  before the crypt.
- `Implementation notes:`
  - bias toward burial records, caretaker residue, altered memory
- `Acceptance criteria:`
  - elder-route identity is legible before blackout and descent
- `Verification:`
  - targeted route tests
- `Status:` pending

### P33
- `ID:` P33
- `Title:` Implement the elder attic rupture and blackout transition
- `Depends on:` P32
- `Why it exists:` `Elder` needs a late turn that strips midgame certainty.
- `Implementation notes:`
  - consume the walking-stick phase
  - begin late darkness and lantern-on-hook logic
- `Acceptance criteria:`
  - elder late rupture is distinct from adult attic-final truth
- `Verification:`
  - targeted elder-transition tests
- `Status:` pending

### P34
- `ID:` P34
- `Title:` Implement the lantern-on-hook phase for elder descent
- `Depends on:` P33
- `Why it exists:` the elder route needs its own late darkness grammar.
- `Implementation notes:`
  - stage lantern first as light, hook second as utility
- `Acceptance criteria:`
  - lantern-on-hook phase is coherent and legible
- `Verification:`
  - targeted route interaction tests
- `Status:` pending

### P35
- `ID:` P35
- `Title:` Build elder traversal through wine cellar
- `Depends on:` P34
- `Why it exists:` the elder route needs a personal burial-side lateral space.
- `Implementation notes:`
  - make wine cellar meaningful, not transitional filler
- `Acceptance criteria:`
  - wine cellar supports elder route distinctly
- `Verification:`
  - traversal and clue tests
- `Status:` pending

### P36
- `ID:` P36
- `Title:` Build the elder crypt final chamber
- `Depends on:` P35
- `Why it exists:` `Elder` must end in the crypt as personal truth.
- `Implementation notes:`
  - make the crypt accusatory, intimate, and not generic funerary scenery
- `Acceptance criteria:`
  - crypt functions as the true final room for `Elder`
- `Verification:`
  - route chamber tests
- `Status:` pending

### P37
- `ID:` P37
- `Title:` Implement the elder music-box solve and progression to Child
- `Depends on:` P36
- `Why it exists:` the second route must end cleanly and hand off to the third.
- `Implementation notes:`
  - converge key, crypt music box, and route progression
- `Acceptance criteria:`
  - elder route resolves and advances the game to `Child`
- `Verification:`
  - route progression tests
- `Status:` pending

### P38
- `ID:` P38
- `Title:` Capture docs and visual acceptance for the elder route
- `Depends on:` P37
- `Why it exists:` `Elder` must be durable as the second canonical completion.
- `Implementation notes:`
  - update docs and capture blackout / wine cellar / crypt visuals
- `Acceptance criteria:`
  - runtime, docs, and captures agree on `Elder`
- `Verification:`
  - renderer-backed elder capture lane
- `Status:` pending

### P39
- `ID:` P39
- `Title:` Audit and map child-route clue surfaces
- `Depends on:` P38
- `Why it exists:` `Child` needs a precise architecture-and-memory clue path.
- `Implementation notes:`
  - audit upper house, attic, and hidden chamber
- `Acceptance criteria:`
  - child-route clue map is recorded and implementable
- `Verification:`
  - update `MEMORY.md`
- `Status:` pending

### P40
- `ID:` P40
- `Title:` Re-author child clue bias and memory intrusions
- `Depends on:` P39
- `Why it exists:` the third route must feel childhood-specific before the
  hidden-room reveal.
- `Implementation notes:`
  - bias toward nursery traces, blocked architecture, concealment, memory
- `Acceptance criteria:`
  - child-route identity is legible before the hidden room is found
- `Verification:`
  - targeted route tests
- `Status:` pending

### P41
- `ID:` P41
- `Title:` Build the child attic clue chain
- `Depends on:` P40
- `Why it exists:` the attic must become the clue engine, not the answer.
- `Implementation notes:`
  - use attic evidence to redirect the player from attic truth to hidden-room
    truth
- `Acceptance criteria:`
  - child late game is unmistakably about blocked architecture
- `Verification:`
  - targeted attic-discovery tests
- `Status:` pending

### P42
- `ID:` P42
- `Title:` Implement the hidden-room architectural reveal
- `Depends on:` P41
- `Why it exists:` the reveal must feel earned and physical.
- `Implementation notes:`
  - expose blocked architecture through bodily investigation
- `Acceptance criteria:`
  - hidden-room discovery is architectural and authored, not arbitrary
- `Verification:`
  - route-specific traversal tests
- `Status:` pending

### P43
- `ID:` P43
- `Title:` Re-author the hidden chamber as the child final room
- `Depends on:` P42
- `Why it exists:` the existing hidden chamber must stop reading as occult
  residue and start reading as erased domestic truth.
- `Implementation notes:`
  - rewrite room text, props, and reveal order around sealed childhood horror
- `Acceptance criteria:`
  - hidden chamber functions as the true final room for `Child`
- `Verification:`
  - room-specific review and route tests
- `Status:` pending

### P44
- `ID:` P44
- `Title:` Implement the child music-box solve and ending
- `Depends on:` P43
- `Why it exists:` the third route must deliver the deepest family revelation
  through the shared solve object.
- `Implementation notes:`
  - converge key, hidden-room music box, and child ending
- `Acceptance criteria:`
  - child route resolves and records completion cleanly
- `Verification:`
  - route progression tests and child-route coverage
- `Status:` pending

### P45
- `ID:` P45
- `Title:` Capture docs and visual acceptance for the child route
- `Depends on:` P44
- `Why it exists:` the third route must be durable as the deepest revelation.
- `Implementation notes:`
  - update docs and capture attic-clue / hidden-room visuals
- `Acceptance criteria:`
  - runtime, docs, and captures agree on `Child`
- `Verification:`
  - renderer-backed child capture lane
- `Status:` pending

### P46
- `ID:` P46
- `Title:` Unify the winding-key and music-box finale system across all routes
- `Depends on:` P29, P37, P44
- `Why it exists:` the same object arc must carry all three routes coherently.
- `Implementation notes:`
  - align final interaction order, state checks, and meaning across routes
- `Acceptance criteria:`
  - the key/music-box arc is one coherent symbolic and mechanical system
- `Verification:`
  - route-ending tests and doc review
- `Status:` pending

### P47
- `ID:` P47
- `Title:` Harden route-order progression and post-third-run behavior
- `Depends on:` P29, P37, P44, P46
- `Why it exists:` route order and repeat-run semantics must be explicit and
  stable.
- `Implementation notes:`
  - preserve `Adult -> Elder -> Child`
  - define post-third-run state cleanly
- `Acceptance criteria:`
  - route order and post-third-run behavior are testable and stable
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
- `Status:` pending

### P48
- `ID:` P48
- `Title:` Migrate critical-path room docs off the old weave
- `Depends on:` P01, P46
- `Why it exists:` critical-path docs must describe the shipped game, not the
  old macro model.
- `Implementation notes:`
  - rewrite critical-path room docs first
- `Acceptance criteria:`
  - critical room docs no longer frame themselves through the old weave
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" docs/rooms`
- `Status:` pending

### P49
- `ID:` P49
- `Title:` Migrate declaration text and route-facing content off the old weave
- `Depends on:` P46
- `Why it exists:` declaration-authored text must match the new route program.
- `Implementation notes:`
  - update route-facing declarations and stale room text
- `Acceptance criteria:`
  - declaration text aligns with `Adult / Elder / Child`
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" declarations`
- `Status:` pending

### P50
- `ID:` P50
- `Title:` Expand automated coverage for the full three-route program
- `Depends on:` P24, P29, P37, P44, P46, P47
- `Why it exists:` the shipped game needs a real regression surface.
- `Implementation notes:`
  - add or finish shared-spine, route-order, and route-ending coverage
- `Acceptance criteria:`
  - automated tests distinguish `Adult`, `Elder`, and `Child`
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `Status:` pending

### P51
- `ID:` P51
- `Title:` Rebuild renderer-backed opening and room-walkthrough acceptance lanes
- `Depends on:` P21, P30, P38, P45, P50
- `Why it exists:` the product-truth lanes must reflect the shipped game
  visually.
- `Implementation notes:`
  - rebuild opening, shared-spine, and finale capture lanes
- `Acceptance criteria:`
  - captures represent the current opening, shared spine, and all route finales
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### P52
- `ID:` P52
- `Title:` Polish critical-path assets, materials, and sourced lighting
- `Depends on:` P21, P30, P38, P45, P51
- `Why it exists:` the final game's quality depends on light, materials, and
  silhouette discipline.
- `Implementation notes:`
  - prioritize opening, basement, attic, crypt, and hidden room
- `Acceptance criteria:`
  - critical spaces have distinct visual identity and sourced lighting
- `Verification:`
  - renderer-backed review
- `Status:` pending

### P53
- `ID:` P53
- `Title:` Run final integration and production acceptance freeze
- `Depends on:` P46, P47, P48, P49, P50, P51, P52
- `Why it exists:` the repo should only be called complete when logic, docs,
  visuals, and route endings converge.
- `Implementation notes:`
  - run the full command surface
  - review captures
- `Acceptance criteria:`
  - canonical docs describe the playable game
  - shared spine and all three routes are playable
  - critical tests and visual lanes pass
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### P54
- `ID:` P54
- `Title:` Archive or deprecate retained weave-era historical docs
- `Depends on:` P53
- `Why it exists:` historical design material may remain, but it must stop
  reading like current truth.
- `Implementation notes:`
  - mark retained weave-era docs as archived or superseded
- `Acceptance criteria:`
  - retained historical docs no longer present as canonical
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" docs`
- `Status:` pending

### P55
- `ID:` P55
- `Title:` Tighten the canonical source map and contributor handoff surface
- `Depends on:` P53, P54
- `Why it exists:` future contributors need one obvious map of current truth.
- `Implementation notes:`
  - finalize canonical source map across docs index and checkpoint files
- `Acceptance criteria:`
  - repo entry points clearly distinguish canonical and archived surfaces
- `Verification:`
  - targeted review of docs index and checkpoints
- `Status:` pending

### P56
- `ID:` P56
- `Title:` Establish post-freeze maintenance baseline and regression register
- `Depends on:` P53, P55
- `Why it exists:` maintenance should begin from a known-good verified state.
- `Implementation notes:`
  - rerun baseline acceptance and record current maintenance frontier
- `Acceptance criteria:`
  - repo has a current maintenance register and verified baseline
- `Verification:`
  - focused baseline commands and checkpoint update
- `Status:` pending

### P57
- `ID:` P57
- `Title:` Audit Android export and packaged-validation prerequisites
- `Depends on:` P53
- `Why it exists:` repo-local completion is not the same as packaged-build
  readiness.
- `Implementation notes:`
  - inspect export preset, build paths, and packaged validation plan
- `Acceptance criteria:`
  - a concrete release-candidate prerequisite map exists
- `Verification:`
  - targeted export/doc review
- `Status:` pending

### P58
- `ID:` P58
- `Title:` Finish debug-gated packaged test-helper support
- `Depends on:` P57
- `Why it exists:` device automation needs stable semantic targets.
- `Implementation notes:`
  - implement or finish debug-only helper support for packaged automation
- `Acceptance criteria:`
  - packaged debug/test builds expose stable automation hooks safely
- `Verification:`
  - targeted helper/runtime review
- `Status:` pending

### P59
- `ID:` P59
- `Title:` Author packaged smoke and critical-path device validation flows
- `Depends on:` P58
- `Why it exists:` packaged play needs reproducible device-level validation.
- `Implementation notes:`
  - prioritize launch, valise, dark-house entry, first warmth, and one deeper
    continuation
- `Acceptance criteria:`
  - there is a runnable packaged smoke and critical-path validation surface
- `Verification:`
  - Maestro or equivalent packaged-flow commands
- `Status:` pending

### P60
- `ID:` P60
- `Title:` Build release-candidate APK, validate install and launch, and close release-readiness docs
- `Depends on:` P57, P58, P59
- `Why it exists:` the game is not externally validated until it builds,
  installs, launches, and survives packaged critical-path testing.
- `Implementation notes:`
  - build APK
  - validate install/launch on emulator or device
  - document evidence and caveats honestly
- `Acceptance criteria:`
  - APK builds successfully
  - install and launch are proven on emulator or device
  - release-readiness docs reflect actual packaged validation
- `Verification:`
  - `godot --headless --path . --export-release "Android" build/ashworth-manor.apk`
  - packaged install/launch/test commands
- `Status:` pending

## Critical Gates

- Gate 1:
  - `P01` through `P05` must establish canonical docs and the shared state map
    before broad implementation continues.
- Gate 2:
  - `P15` through `P24` must complete the shared spine before route divergence
    work is considered authoritative.
- Gate 3:
  - `P25` through `P30` must complete `Adult` before `Elder` advances heavily.
- Gate 4:
  - `P31` through `P38` must complete `Elder` before `Child` becomes the third
    revelation.
- Gate 5:
  - `P39` through `P45` must complete `Child` before final integration freeze.
- Gate 6:
  - `P46` through `P53` must prove route convergence, docs convergence, and
    acceptance convergence before archive and maintenance posture.
- Gate 7:
  - `P57` through `P60` must prove packaged validation before any release
    candidate claim is made.

## Resume Instructions

- Start from this file.
- Read:
  - `PLAN.md`
  - `MEMORY.md`
  - `STRUCTURE.md`
  - `docs/GAME_BIBLE.md`
  - `docs/PLAYER_PREMISE.md`
  - `docs/ELIZABETH_ROUTE_PROGRAM.md`
  - `docs/NARRATIVE.md`
  - `docs/MASTER_SCRIPT.md`
- Resume from the earliest unblocked task not marked `verified_done`.
- After each task, update:
  - this batch file
  - `PLAN.md`
  - `MEMORY.md`
  - `STRUCTURE.md`
- If new required work is discovered, add it here with explicit dependencies.
- If interrupted, stop at a verified checkpoint or mark the active task
  `blocked` and record the exact blocker in `MEMORY.md`.
