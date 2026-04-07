# Final Integration and Acceptance

## Summary
Complete Ashworth Manor after the three bespoke route batches by unifying the music-box finale system, migrating critical-path legacy weave material off the old macro model, rebuilding the acceptance lanes, and running the final production freeze. This batch exists so the repo can converge into one coherent shipped game rather than a mostly-complete route stack with stale supporting surfaces.

## Scope
- Included work
  - unify the winding-key and music-box finale system across `Adult`, `Elder`, and `Child`
  - migrate critical-path room docs, declaration text, and puzzle/runtime references off the old `Captive / Mourning / Sovereign` model
  - expand automated coverage so the new route program fails loudly when regressed
  - rebuild renderer-backed walkthrough and opening/finale acceptance lanes
  - route-aware art, material, and lighting polish for critical-path spaces
  - final production acceptance freeze and checkpoint closure
- Explicitly excluded work
  - new route design beyond bug fixes or completion polish needed to make existing route batches hold
  - optional post-launch content, repeat-run variation tuning, or meta-progression experiments
  - broad archival rewriting of every historical design doc that is clearly non-canonical and can instead be deprecated
  - new major systems unrelated to route completion, acceptance, or legacy migration

## Constraints
- Declarations remain canonical.
- This batch assumes the shared-spine, `Adult`, `Elder`, and `Child` batches are the intended upstream route sequence.
- Do not revive the old macro PRNG/weave model in runtime or player-facing docs.
- Keep outside paperwork and estate signage neutral.
- Final acceptance must be driven by runtime behavior, declaration truth, and renderer-backed capture lanes, not docs alone.
- Critical-path lighting must remain physically sourced.
- Treat some old weave documents as archive/deprecation surfaces if full rewrite is lower value than explicit retirement.
- No task is complete until both its acceptance criteria and verification pass.

## Assumptions
- Route progression already enforces `Adult -> Elder -> Child`.
- The winding key already exists as an early carried story object and must now converge cleanly with all three route finales.
- There are still many stale references to `Captive`, `Mourning`, `Sovereign`, or “weave” across docs and some declaration-adjacent materials.
- The most important migration target is the critical path:
  - room declarations and room docs the player actually traverses
  - tests and acceptance lanes
  - high-level canonical docs
- Older design explorations can remain if clearly marked as legacy/archive and no longer masquerade as current product truth.

## Execution Policy
- Completion standard
  - The batch is complete only when the runtime, declarations, docs, tests, and renderer captures all describe the same playable three-route game, and no major old-weave assumption remains on the critical path.
- Stop conditions
  - Stop if any of the three upstream route batches is still materially incomplete in runtime.
  - Stop if full-playthrough or renderer lanes reveal route-order or finale contradictions that require route re-planning rather than integration.
  - Stop if critical-path migration would require deleting historical/archive docs that should instead be deprecated and left intact.
- Verification cadence
  - Run focused searches before and after migration slices.
  - Re-run automated suites after each logic/test surface change.
  - Re-run renderer-backed lanes after any visual or walkthrough change.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave the repo with a half-migrated canonical surface where docs, declarations, and acceptance tests disagree about the same room or ending.

## Task Graph

### F01
- `ID:` F01
- `Title:` Audit and classify remaining old-weave references across docs, declarations, and tests
- `Depends on:` none
- `Why it exists:` final migration work is only tractable if remaining `Captive / Mourning / Sovereign` references are separated into critical-path rewrites, compatibility notes, and archive-only surfaces.
- `Implementation notes:`
  - search `docs`, `declarations`, and `test` for:
    - `Captive`
    - `Mourning`
    - `Sovereign`
    - `weave`
  - classify each hit as:
    - rewrite now
    - deprecate/archive
    - safe canonical note about replacement history
  - record the migration map in `MEMORY.md`
- `Acceptance criteria:`
  - there is a concrete list of critical-path stale references to remove or rewrite
  - archive/deprecation candidates are distinguished from canonical blockers
  - downstream tasks can target real files instead of broad “clean up legacy docs” language
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" docs declarations test`
  - update `MEMORY.md` with the classification summary
- `Status:` pending

### F02
- `ID:` F02
- `Title:` Migrate critical-path room docs, declaration text, and puzzle/runtime references off the old weave
- `Depends on:` F01
- `Why it exists:` large parts of the critical path still describe a different game, which undermines implementation, review, and future autonomous work.
- `Implementation notes:`
  - rewrite critical-path room docs first
  - update declaration text and any puzzle/runtime references that still frame content through the old macro model
  - keep explicit deprecation notes where historical docs remain useful but non-canonical
  - prioritize runtime-facing and reviewer-facing surfaces over archive material
- `Acceptance criteria:`
  - critical-path room docs no longer frame themselves through `Captive / Mourning / Sovereign`
  - declaration text and puzzle/runtime language align with `Adult / Elder / Child`
  - remaining old-weave references are either archived or explicitly marked non-canonical
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" docs declarations test`
  - targeted review of touched canonical files
- `Status:` pending

### F03
- `ID:` F03
- `Title:` Unify the winding-key and music-box finale system across all three routes
- `Depends on:` F01
- `Why it exists:` the same solve object must carry all three routes without feeling generic or mechanically inconsistent.
- `Implementation notes:`
  - connect the early winding key to all three final music-box interactions
  - preserve route-specific meaning:
    - attic biography for `Adult`
    - buried continuity for `Elder`
    - sealed childhood truth for `Child`
  - align final interaction order, state checks, and ending handoff logic so the object arc is one coherent system
- `Acceptance criteria:`
  - the winding key and music box form one clear symbolic and mechanical arc
  - each route’s final interaction feels authored for that route rather than reskinned
  - route-ending state changes are consistent and testable
- `Verification:`
  - route-ending test review
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - targeted route-ending suites as available
- `Status:` pending

### F04
- `ID:` F04
- `Title:` Expand automated coverage for the final three-route program
- `Depends on:` F03
- `Why it exists:` the project is not stable until route order, shared spine, and distinct endgames are proven by automation rather than memory.
- `Implementation notes:`
  - add or finish:
    - shared-spine coverage
    - route-order coverage
    - `Adult`, `Elder`, and `Child` endgame/ending coverage
    - any full-playthrough assertions needed to catch cross-route regressions
  - make failures explicit around route gating and final solve behavior
- `Acceptance criteria:`
  - automated tests can distinguish `Adult`, `Elder`, and `Child`
  - regressions in route order, shared spine, or endings fail loudly
  - the repo has one credible automated surface for whole-game route behavior
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `Status:` pending

### F05
- `ID:` F05
- `Title:` Rebuild renderer-backed visual walkthrough and opening/finale acceptance lanes
- `Depends on:` F02, F04
- `Why it exists:` the current review lanes still partially reflect older opening and route assumptions and do not yet prove the final three-route game visually.
- `Implementation notes:`
  - update capture sequences to include:
    - packet/valise opening
    - shared basement restoration beat
    - attic finale framing
    - crypt finale framing
    - hidden-room finale framing
  - ensure opening and room-walkthrough lanes reflect the new light/tool grammar
  - review captures for readability, staging, and sourced-light discipline
- `Acceptance criteria:`
  - opening-journey captures show the canonical heir-return sequence
  - walkthrough captures represent the shared spine and all three finale spaces
  - critical visual lanes match the shipped route grammar
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - screenshot output exists under Godot `user://`
- `Status:` pending

### F06
- `ID:` F06
- `Title:` Polish critical-path assets, materials, and lighting across shared spine and route finales
- `Depends on:` F02, F05
- `Why it exists:` the game’s final quality depends on sourced lighting, material identity, and route-specific room character, not just logic completeness.
- `Implementation notes:`
  - follow the procedural-first, model-assisted doctrine
  - prioritize:
    - opening/gate/drive threshold
    - basement restoration spaces
    - attic
    - crypt
    - hidden room
  - confirm visible-source lighting and distinct finale-space visual identity
  - use renderer captures to drive decisions rather than speculative prose
- `Acceptance criteria:`
  - critical-path rooms have clear physical-source lighting
  - finale spaces have distinct visual identity by route
  - imported models are serving silhouette and atmosphere rather than replacing authored architecture
- `Verification:`
  - renderer captures for opening, basement, attic, crypt, and hidden room
  - visual walkthrough review against current canonical docs
- `Status:` pending

### F07
- `ID:` F07
- `Title:` Run production acceptance freeze and close the checkpoint surface
- `Depends on:` F02, F03, F04, F05, F06
- `Why it exists:` the repo should only be called complete once logic, docs, visuals, and route endings all converge and the checkpoint files reflect that fact.
- `Implementation notes:`
  - run the full command surface
  - review final renderer captures
  - confirm no critical room or route still behaves like legacy weave content
  - update:
    - `PLAN.md`
    - `MEMORY.md`
    - `STRUCTURE.md`
    - parent production batch status
  - leave a clean final note about any archive docs intentionally retained as historical material
- `Acceptance criteria:`
  - canonical docs describe the actual playable game
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
- Gate 1: F01 must produce a concrete migration map before canonical-surface cleanup begins.
- Gate 2: F02 and F03 must align the canonical docs/runtime/object arc before final automation and visual rebuilds can be trusted.
- Gate 3: F04 and F05 together must prove the three-route game in both automation and renderer-backed review before final polish/freeze.
- Gate 4: F07 must leave the checkpoint surface honest; “complete” is not valid if `PLAN.md`, `MEMORY.md`, `STRUCTURE.md`, and the parent batch disagree.

## Resume Instructions
- Start from this file and the parent production batch in `docs/batches/ashworth-production-recovery.md`.
- Assume the upstream route batches are:
  - `docs/batches/service-basement-midgame-spine.md`
  - `docs/batches/adult-route-attic-resolution.md`
  - `docs/batches/elder-route-crypt-resolution.md`
  - `docs/batches/child-route-hidden-room-resolution.md`
- Before editing, verify the current baseline:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
- Resume at F01 unless a final migration map already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact final-integration inconsistency in `MEMORY.md`.
