# Ralph Final Remaining Stories Batch

## Summary

Execute the real post-Ralph finish tranche from the current integrated branch.
The route program, route unification, declaration migration, and acceptance
rebuild checkpoints are already landed. The remaining work is the final visual
polish, repo-local freeze, archive/handoff cleanup, maintenance baseline, and
truthful release-candidate validation.

## Scope

- Included work
  - `US-020` through `US-027` from `tasks/prd.json`
  - critical-path visual polish and renderer-backed evidence repair
  - repo-local freeze and convergence proof
  - archive/handoff cleanup and maintenance baseline
  - Android/export audit, packaged-validation prep, and release-candidate truth
- Explicitly excluded work
  - redoing shipped route logic unless a verification failure requires repair
  - reopening `Adult / Elder / Child` order or meanings
  - adding new gameplay outside the shipped game

## Constraints

- Declarations remain canonical.
- Route order stays `Adult -> Elder -> Child`.
- `macro_thread` remains compatibility-only.
- Outside paperwork and estate signage remain neutral.
- Visual polish must keep lighting visibly sourced.
- Batch statuses must stay honest: `pending`, `in_progress`, `blocked`,
  `verified_done`, `skipped`.

## Current Execution List

1. finish `US-020` with late-room visual readability fixes and fresh renderer
   captures
2. run `US-021` freeze and convergence proof across the full repo-local
   acceptance bundle
3. execute `US-022` and `US-023` to archive stale weave-era surfaces and record
   the maintenance baseline
4. execute `US-024` through `US-027` to audit Android/export readiness and
   record truthful packaged-validation status

## Task Graph

### US-020
- `ID:` US-020
- `Title:` Polish critical-path assets, materials, silhouette, and sourced lighting
- `Depends on:` shipped route/content baseline
- `Why it exists:` the game must read as intentionally finished, not merely
  functionally complete.
- `Implementation notes:`
  - focus on opening, basement, attic, crypt, and hidden room
  - fix both actual room readability and renderer-backed capture staging
  - keep all dramatic light visibly sourced
- `Acceptance criteria:`
  - critical spaces have distinct visual identity and disciplined materials
  - dramatic lighting remains visibly sourced
  - renderer-backed milestone evidence is readable and useful for review
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` verified_done

### US-021
- `ID:` US-021
- `Title:` Run the repo-local integration freeze and convergence proof
- `Depends on:` US-020
- `Why it exists:` repo-local completion needs one honest freeze gate.
- `Implementation notes:`
  - rerun the full canonical headless and renderer-backed acceptance bundle
  - write one freeze checkpoint that names exactly what passed
- `Acceptance criteria:`
  - freeze command set passes
  - docs, declarations, tests, and captures describe the same game
  - a clean-save journey can complete the shipped route order
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` verified_done

### US-022
- `ID:` US-022
- `Title:` Archive historical weave-era material and tighten contributor handoff
- `Depends on:` US-021
- `Why it exists:` post-freeze contributors need a clean canonical/archive split.
- `Implementation notes:`
  - label retained weave-era docs as archived or superseded
  - tighten source-map, handoff, and regression-lane guidance
- `Acceptance criteria:`
  - retained weave-era docs no longer read as current truth
  - contributor surfaces distinguish canonical, archived, and maintenance docs
- `Verification:`
  - doc/source-map audit
  - `godot --headless --path . --quit-after 1`
- `Status:` verified_done

### US-023
- `ID:` US-023
- `Title:` Establish the post-freeze maintenance baseline and regression register
- `Depends on:` US-021, US-022
- `Why it exists:` maintenance work should begin from a recorded verified state.
- `Implementation notes:`
  - rerun the baseline after freeze
  - record flaky or high-risk regression fronts honestly
- `Acceptance criteria:`
  - post-freeze baseline is recorded
  - maintenance register names real future-risk surfaces
- `Verification:`
  - baseline rerun recorded in checkpoint files
  - `godot --headless --path . --quit-after 1`
- `Status:` verified_done

### US-024
- `ID:` US-024
- `Title:` Audit Android export and packaged-validation prerequisites
- `Depends on:` US-021
- `Why it exists:` release validation must start from honest Android/export
  assumptions.
- `Implementation notes:`
  - audit `export_presets.cfg`, build paths, signing, SDK, emulator/device, and
    existing docs together
  - mark missing prerequisites as real blockers
- `Acceptance criteria:`
  - Android/export prerequisites are explicitly recorded
  - missing local prerequisites are marked as blockers, not ignored
- `Verification:`
  - targeted audit over export config and release docs
  - `godot --headless --path . --quit-after 1`
- `Status:` verified_done

### US-025
- `ID:` US-025
- `Title:` Finish debug-gated packaged test-helper support
- `Depends on:` US-024
- `Why it exists:` packaged automation needs safe helper affordances.
- `Implementation notes:`
  - stabilize or truthfully document packaged helper hooks for debug/test builds
  - keep them gated away from normal runtime
- `Acceptance criteria:`
  - packaged helper affordances are stable and documented, or the story is
    truthfully blocked by missing export prerequisites
  - helper support does not leak into normal play
- `Verification:`
  - packaged debug/helper validation audit
  - `godot --headless --path . --quit-after 1`
- `Status:` verified_done

### US-026
- `ID:` US-026
- `Title:` Author packaged smoke and critical-path validation flows
- `Depends on:` US-025
- `Why it exists:` release readiness needs executable packaged-validation
  guidance.
- `Implementation notes:`
  - document and script packaged launch-to-critical-path validation
  - cover launch, valise, dark entry, first warmth, and one deeper continuation
- `Acceptance criteria:`
  - packaged validation flow is executable and evidence-ready, or blocked only
    by named local prerequisites
  - emulator/device steps are documented in order
- `Verification:`
  - packaged smoke-validation audit
  - `godot --headless --path . --quit-after 1`
- `Status:` blocked

### US-027
- `ID:` US-027
- `Title:` Build the release candidate, validate install and launch, and close release-readiness docs
- `Depends on:` US-024, US-025, US-026
- `Why it exists:` the ship plan should end with real packaged evidence, not
  repo-local confidence alone.
- `Implementation notes:`
  - produce Android release build if the environment supports it
  - validate install and launch on emulator or device if available
  - close release-readiness docs with actual evidence and caveats
- `Acceptance criteria:`
  - Android release build completes, or the exact local blocker is recorded
  - install and launch evidence is captured when environment permits
  - release-readiness docs record actual packaged-validation scope and caveats
- `Verification:`
  - `godot --headless --path . --export-release "Android" build/ashworth-manor.apk`
- `Status:` blocked

## Resume Instructions

- Start from this file, then read:
  - `tasks/prd.json`
  - `docs/GAME_BIBLE.md`
  - `PLAN.md`
  - `MEMORY.md`
  - `.ralph-tui/progress.md`
- Treat the earliest unblocked non-`verified_done` story as active.
- At this checkpoint:
  - `US-020` through `US-025` are complete
  - `US-026` is blocked on semantic helper-label pickup on the current AVD
  - `US-027` is blocked on missing release-signing credentials
- After each executed story:
  - update this batch file status
  - record discoveries and blockers in `MEMORY.md`
  - update `PLAN.md` if execution priorities materially change
  - update `.ralph-tui/progress.md` with factual verification notes
