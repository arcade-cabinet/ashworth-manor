# Ralph Remaining Stories Batch

## Summary

Execute the unfinished PRD surface after Ralph's recovered `US-001` through
`US-010` tranche. This batch exists to carry Ashworth Manor from the current
shared spine plus `Adult` route baseline through `Elder`, `Child`,
route-unified finale logic, canonical text migration, acceptance rebuild,
freeze, handoff, maintenance, and release-candidate validation.

## Scope

- Included work
  - `US-011` through `US-027` from `tasks/prd.json`
  - `Elder` route implementation, verification, docs, and captures
  - `Child` route implementation, verification, docs, and captures
  - winding-key/music-box unification and hardening of post-third-run behavior
  - room-doc and declaration-text migration off the old weave
  - full three-route automated coverage and renderer-backed acceptance rebuild
  - freeze, archive/handoff, maintenance baseline, and release validation
- Explicitly excluded work
  - redoing `US-001` through `US-010` unless correctness repairs are required
  - new content outside the shipped `Adult / Elder / Child` route program
  - combat, HUD-first redesign, or setting changes

## Constraints

- Declarations remain canonical.
- The route order is fixed to `Adult -> Elder -> Child`.
- `macro_thread` remains compatibility-only and must not re-emerge as canon.
- Outside paperwork and estate signage stay neutral.
- The music box is the invariant solve object across all routes.
- Visual/perception-sensitive work is not done until renderer-backed captures are
  reviewed.
- Batch statuses must stay honest: `pending`, `in_progress`, `blocked`,
  `verified_done`, `skipped`.

## Assumptions

- `US-001` through `US-010` are already integrated on
  `codex/ralph-integration-harvest`.
- Current verified baseline includes:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `docs/GAME_BIBLE.md` is the canonical narrative surface.
- Earlier route-specific batch files remain useful support references but this
  file is the active execution contract for the remaining stories.

## Current Execution List

1. close `US-013` and `US-014` with Child checkpoints, docs, and verified
   renderer-backed evidence
2. execute `US-015` by unifying route-first progression and the invariant
   winding-key/music-box arc
3. execute `US-016` and `US-017` together across critical-path docs and
   declaration-authored route text
4. rebuild acceptance surfaces (`US-019` through `US-020`)
5. run freeze, archive/handoff, maintenance, and release-validation stories
   (`US-021` through `US-027`)

## Execution Policy

- Completion standard
  - The batch is complete only when every unfinished PRD story is either
    `verified_done` or intentionally `skipped`, no unresolved blockers remain,
    and freeze/release validation truthfully reflects the shipped state.
- Stop conditions
  - Stop if a story requires reopening the fixed route order or the canonical
    route meanings.
  - Stop if required Android/export prerequisites cannot be supplied or inferred
    safely.
  - Stop if verification repeatedly fails after a reasonable repair attempt.
- Verification cadence
  - Re-run the smallest meaningful headless lane after each runtime/content
    slice.
  - Re-run renderer-backed lanes after perception-sensitive work.
  - Re-run the full headless bundle at route-completion and freeze boundaries.
- Partial completion
  - Acceptable only at verified checkpoint boundaries.
  - Do not mark a story complete on prose or code inspection alone when runtime
    or visual behavior is part of acceptance.

## Task Graph

### US-011
- `ID:` US-011
- `Title:` Author the Elder-route clue topology and blackout grammar
- `Depends on:` none
- `Why it exists:` the second route needs a concrete clue path and route bias
  before cellar/crypt implementation starts.
- `Implementation notes:`
  - create a canonical elder clue-topology checkpoint
  - re-author shared and upper-house elder-biased text in touched declarations
  - document how elder blackout grammar diverges from adult attic-final logic
- `Acceptance criteria:`
  - elder clue topology is recorded in canonical working surfaces
  - shared/upper-house surfaces bias toward burial, caretaker residue, and
    altered memory
  - elder rupture/blackout grammar is distinct from adult in docs and touched
    declarations
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - renderer-backed walkthrough/opening review for touched spaces
- `Status:` verified_done

### US-012
- `ID:` US-012
- `Title:` Deliver the Elder cellar-to-crypt resolution, ending, docs, and capture proof
- `Depends on:` US-011
- `Why it exists:` the second canonical completion must resolve in burial truth,
  not attic truth.
- `Implementation notes:`
  - implement attic rupture, blackout descent, lantern-on-hook transition,
    wine-cellar bypass, crypt gate/finale, and elder completion recording
- `Acceptance criteria:`
  - elder route plays coherently from rupture through crypt finale
  - music-box solve resolves in the crypt and unlocks `Child`
  - docs and captures agree on the implemented elder route
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - elder-specific declared-interaction and route tests
  - renderer-backed walkthrough/capture review
- `Status:` verified_done

### US-013
- `ID:` US-013
- `Title:` Author the Child-route clue topology and blocked-architecture chain
- `Depends on:` US-008 baseline, US-012
- `Why it exists:` the third route needs a clear architectural clue engine
  before hidden-room implementation.
- `Implementation notes:`
  - create child clue-topology checkpoint
  - bias upper-house and attic-adjacent content toward nursery traces,
    concealment, and memory intrusion
  - define the attic false-answer chain
- `Acceptance criteria:`
  - child clue topology is recorded canonically
  - touched rooms bias toward sealed childhood and blocked architecture
  - attic becomes a clue engine, not the final answer
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - renderer-backed walkthrough/opening review for touched spaces
- `Status:` verified_done

### US-014
- `ID:` US-014
- `Title:` Deliver the Child hidden-room resolution, ending, docs, and capture proof
- `Depends on:` US-013
- `Why it exists:` the third canonical completion must expose erased domestic
  truth through the hidden room.
- `Implementation notes:`
  - build the attic redirect, sealed-room discovery, hidden-room final chamber,
    child music-box solve, and completion logic
- `Acceptance criteria:`
  - hidden-room discovery feels architectural and authored
  - hidden chamber reads as erased domestic truth, not occult residue
  - child route completion, docs, and captures agree
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - child-specific route tests
  - renderer-backed walkthrough/capture review
- `Status:` verified_done

### US-015
- `ID:` US-015
- `Title:` Unify the winding-key/music-box system and harden route-order progression
- `Depends on:` US-010, US-012, US-014
- `Why it exists:` all routes must read as one game, not three prototypes.
- `Implementation notes:`
  - reconcile winding-key and music-box behavior across adult/elder/child
  - harden post-third-run progression behavior and hide legacy thread details
- `Acceptance criteria:`
  - one coherent winding-key/music-box arc spans all routes
  - route progression remains fixed and explicit
  - legacy thread compatibility is implementation-only
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `Status:` verified_done

### US-016
- `ID:` US-016
- `Title:` Migrate critical-path room docs off the old weave
- `Depends on:` US-015
- `Why it exists:` room docs must stop misleading future implementation and
  review.
- `Implementation notes:`
  - migrate opening, basement, attic, crypt, and hidden-room docs to the
    shipped route model
- `Acceptance criteria:`
  - critical-path room docs no longer present the weave as current truth
  - any remaining weave-era room docs are clearly archived/historical
- `Verification:`
  - targeted doc audit
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `Status:` verified_done

### US-017
- `ID:` US-017
- `Title:` Migrate declaration-authored route text off the old weave
- `Depends on:` US-015
- `Why it exists:` route-facing interaction text must speak the shipped game.
- `Implementation notes:`
  - rewrite critical-path declaration text to align with adult/elder/child
  - keep only intentional compatibility shims
- `Acceptance criteria:`
  - critical-path declarations align with adult/elder/child
  - weave-era framing is gone or clearly compatibility-only
- `Verification:`
  - search audit over `declarations/`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
- `Status:` verified_done

### US-018
- `ID:` US-018
- `Title:` Expand automated coverage for the full three-route program
- `Depends on:` US-010, US-012, US-014, US-015
- `Why it exists:` the regression surface must actually exercise the shipped
  route order and finales.
- `Implementation notes:`
  - extend headless playthrough and route coverage to all three routes
  - re-enable/report gdUnit-backed coverage flow where documented
- `Acceptance criteria:`
  - full playthrough drives real `Adult -> Elder -> Child`
  - route-order/shared-spine/ending coverage distinguishes all three routes
  - documented gdUnit CLI flow passes
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd`
- `Status:` verified_done

### US-019
- `ID:` US-019
- `Title:` Rebuild renderer-backed debug-view acceptance lanes
- `Depends on:` US-012, US-014, US-018
- `Why it exists:` visual/traversal review needs stable evidence, not ad hoc
  capture work.
- `Implementation notes:`
  - update opening journey and room walkthrough surfaces
  - ensure manifests cover opening, basement, attic, crypt, hidden room, and
    route finales
- `Acceptance criteria:`
  - renderer-backed capture flows reflect the shipped game
  - review evidence is organized and actionable
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` verified_done

### US-020
- `ID:` US-020
- `Title:` Polish critical-path assets, materials, silhouette, and sourced lighting
- `Depends on:` US-012, US-014, US-018
- `Why it exists:` the game must read as intentionally finished, not just
  functionally complete.
- `Implementation notes:`
  - focus on opening, basement, attic, crypt, and hidden room
  - preserve sourced lighting and declaration-first behavior
- `Acceptance criteria:`
  - critical spaces have distinct visual identity and disciplined materials
  - dramatic lighting remains visibly sourced
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - renderer-backed opening/walkthrough review
- `Status:` in_progress

### US-021
- `ID:` US-021
- `Title:` Run the repo-local integration freeze and convergence proof
- `Depends on:` US-015, US-016, US-017, US-018, US-019, US-020
- `Why it exists:` repo-local completion needs one honest freeze gate.
- `Implementation notes:`
  - rerun full canonical headless/renderer acceptance
  - verify a clean-save player journey through all three routes
- `Acceptance criteria:`
  - freeze command set passes
  - docs, declarations, tests, and captures describe the same game
- `Verification:`
  - full canonical headless bundle
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### US-022
- `ID:` US-022
- `Title:` Archive historical weave-era material and tighten contributor handoff
- `Depends on:` US-021
- `Why it exists:` post-freeze contributors need a clean canonical/archive split.
- `Implementation notes:`
  - label weave-era docs as archived/superseded
  - tighten index/checkpoint/handoff language
- `Acceptance criteria:`
  - retained weave-era docs no longer read as current truth
  - contributor surfaces name canonical sources and regression lanes clearly
- `Verification:`
  - doc/source-map audit
  - `godot --headless --path . --quit-after 1`
- `Status:` pending

### US-023
- `ID:` US-023
- `Title:` Establish the post-freeze maintenance baseline and regression register
- `Depends on:` US-021, US-022
- `Why it exists:` maintenance work should begin from a recorded, verified
  baseline.
- `Implementation notes:`
  - rerun baseline after freeze
  - record flaky/high-risk surfaces and likely regression fronts
- `Acceptance criteria:`
  - post-freeze baseline is recorded
  - maintenance register names real future-risk surfaces
- `Verification:`
  - baseline rerun recorded in checkpoint files
  - `godot --headless --path . --quit-after 1`
- `Status:` pending

### US-024
- `ID:` US-024
- `Title:` Audit Android export and packaged-validation prerequisites
- `Depends on:` US-021
- `Why it exists:` release validation must start from honest Android/export
  assumptions.
- `Implementation notes:`
  - audit `export_presets.cfg`, build paths, signing, emulator/device, and docs
- `Acceptance criteria:`
  - Android/export prerequisites are explicitly recorded
  - missing local prerequisites are marked as blockers, not ignored
- `Verification:`
  - targeted audit over export config and release docs
  - `godot --headless --path . --quit-after 1`
- `Status:` pending

### US-025
- `ID:` US-025
- `Title:` Finish debug-gated packaged test-helper support
- `Depends on:` US-024
- `Why it exists:` packaged automation needs safe helper affordances.
- `Implementation notes:`
  - stabilize test-helper hooks for packaged debug/test builds
  - keep them gated away from normal runtime
- `Acceptance criteria:`
  - packaged helper affordances are stable and documented
  - helper support does not leak into normal play
- `Verification:`
  - packaged debug/helper validation commands
  - `godot --headless --path . --quit-after 1`
- `Status:` pending

### US-026
- `ID:` US-026
- `Title:` Author packaged smoke and critical-path validation flows
- `Depends on:` US-025
- `Why it exists:` release readiness needs executable packaged-validation flows.
- `Implementation notes:`
  - document and script packaged launch-to-critical-path validation
  - cover launch, valise, dark entry, first warmth, and one deeper continuation
- `Acceptance criteria:`
  - packaged validation flow is executable and evidence-ready
  - emulator/device steps are documented in order
- `Verification:`
  - packaged smoke-validation commands
  - `godot --headless --path . --quit-after 1`
- `Status:` pending

### US-027
- `ID:` US-027
- `Title:` Build the release candidate, validate install and launch, and close release-readiness docs
- `Depends on:` US-024, US-025, US-026
- `Why it exists:` the ship plan should end with real packaged evidence, not
  repo-local confidence alone.
- `Implementation notes:`
  - produce Android release build
  - validate install and launch on emulator or device
  - close release-readiness docs with actual evidence and caveats
- `Acceptance criteria:`
  - Android release build completes
  - install and launch are proven with captured evidence
  - release-readiness docs record actual packaged-validation scope and caveats
- `Verification:`
  - `godot --headless --path . --export-release \"Android\" build/ashworth-manor.apk`
- `Status:` pending

## Critical Gates

- Gate 1: `US-011` must produce a concrete elder clue map before elder cellar
  and crypt implementation starts.
- Gate 2: `US-012` now produced the second canonical completion; child route
  work may proceed from attic false-answer and hidden-room clues.
- Gate 3: `US-014` and `US-015` together must stabilize all three canonical
  routes before migration and acceptance rebuild work begins.
- Gate 4: `US-021` is the freeze boundary; downstream work after that is
  archive, maintenance, and packaged validation only.

## Resume Instructions

- Start from this file, then read:
  - `tasks/prd.json`
  - `docs/GAME_BIBLE.md`
  - `PLAN.md`
  - `MEMORY.md`
  - `STRUCTURE.md`
- Treat the earliest unblocked non-`verified_done` story as active. At the time
  of this checkpoint that is `US-019`.
- After each executed story:
  - update this batch file status
  - record discoveries and blockers in `MEMORY.md`
  - update `PLAN.md` if execution priorities materially change
  - update `STRUCTURE.md` if architecture actually changes
- Resume at the earliest unblocked story.
