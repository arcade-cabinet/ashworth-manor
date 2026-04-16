# Post-Merge Closeout And Release Candidate

## Summary

This batch consolidates the real remaining work after the branch cleanup and
merge pass. PR #6 and PR #7 are already merged, there are no open GitHub PRs
or issues, and `main` is the only live integration surface. The remaining work
is now the truthful ship-closeout tranche: finish the substrate sweep, close
the last visual acceptance gaps, unblock packaged critical-path validation, and
produce a real Android release-candidate evidence trail.

## Scope

- Included work
  - post-merge source-map and status-truth reconciliation
  - remaining substrate closeout across grounds, interiors, and route state
  - renderer-backed visual acceptance for the opening and other critical rooms
  - full repo-local freeze rebaseline after the substrate closeout
  - packaged debug critical-path validation on the current Android AVD
  - Android release-signing setup, release export, install/launch proof, and
    release-readiness docs
  - remaining first-party doc hygiene directly tied to the above work
- Explicitly excluded work
  - new gameplay, new routes, or story-program rewrites
  - reopening already-merged PR archaeology unless a regression requires it
  - third-party addon TODOs under `addons/`
  - storefront, marketing, or publishing tasks beyond release-candidate proof

## Constraints

- Declarations remain canonical.
- `docs/GAME_BIBLE.md` remains the narrative authority.
- `docs/SUBSTRATE_FOUNDATION.md` remains the substrate authority.
- Lighting must stay visibly sourced.
- Imported models remain reserved for discrete props and hero objects, not
  primary room envelopes.
- Visual work is not complete until renderer-backed captures are reviewed.
- Packaged-validation truth must stay honest: emulator/device blockers must be
  recorded as blockers, not hidden behind repo-local confidence.

## Assumptions

- `main` is clean and is the current execution branch.
- There are no open GitHub PRs or issues at the time this batch was written.
- Repo-local declaration and E2E suites are green on the merged baseline.
- Android debug packaging, install, direct launch, and the Maestro smoke flow
  already work on the local `ashworth_test` AVD.
- The current packaged critical-path blocker is Maestro semantic helper-label
  pickup on the AVD surface.
- The current release-export blocker is missing release-signing credentials.

## Execution Policy

- Completion standard
  - The batch is complete only when docs, declarations, renderer evidence,
    packaged automation, and Android release-readiness surfaces all describe
    the same truthful ship state.
- Stop conditions
  - Stop if a task would require reopening the canonical route program.
  - Stop if release-signing credentials or a required Android runtime artifact
    cannot be obtained locally and record the exact blocker.
  - Stop if a visual defect cannot be resolved without introducing a broader
    architecture regression.
- Verification cadence
  - Re-run the smallest meaningful suite after each task.
  - Re-run focused renderer lanes after perception-sensitive opening work.
  - Re-run the full repo-local freeze bundle before starting release-candidate
    export work.
- Partial completion
  - Acceptable only if task status and blocker notes remain factual.
  - Do not mark the release tranche complete while any ship-critical blocker is
    still only “understood” rather than resolved or explicitly blocked.

## Task Graph

### RM-001
- `ID:` RM-001
- `Title:` Reconcile the post-merge source map and execution surfaces
- `Depends on:` none
- `Why it exists:` the repo still carries stale “active batch” and stale status
  surfaces from the pre-merge tranche, which makes the remaining work harder to
  execute honestly.
- `Implementation notes:`
  - reconcile `PLAN.md`, `MEMORY.md`, `.ralph-tui/progress.md`, and the
    overlapping batch docs with the actual merged state
  - make one remaining-work batch the active closeout surface
  - remove stale language that still implies open branches/PRs or outdated
    tranche statuses
- `Acceptance criteria:`
  - contributor-facing source-map files agree on the current remaining-work
    surface
  - stale pre-merge “active execution” wording is removed or explicitly marked
    historical
  - no file still implies there is an open review branch when work is already
    on `main`
- `Verification:`
  - targeted review of `PLAN.md`, `MEMORY.md`, `.ralph-tui/progress.md`, and
    the touched batch files
- `Status:` pending

### RM-002
- `ID:` RM-002
- `Title:` Finish opening exterior visual acceptance
- `Depends on:` RM-001
- `Why it exists:` the opening remains the clearest live visual blocker. The
  latest checkpoints still call out hedge-face richness, drive-floor craft,
  outward-road village credibility, twilight atmosphere, and contextual
  sign/valise composition as unfinished.
- `Implementation notes:`
  - focus on `front_gate`, `drive_lower`, `drive_upper`, `front_steps`, the
    hedge builder, outward-road frontage, and sky composition together
  - prioritize the four named blockers from the latest opening diagnostic:
    hedge close-up, drive surface craft, village persuasion, and contextual
    sign/valise framing
  - keep the sign/valise cluster materially grounded; do not solve the frame by
    inventing HUD-like emphasis
- `Acceptance criteria:`
  - the opening no longer fails the latest renderer-backed visual review on the
    named blockers
  - hedge rows read as clipped topiary mass rather than smooth synthetic slabs
  - the drive reads as authored estate approach rather than broad placeholder
    floor treatment
  - the outward road and sky read as persuasive twilight settlement context
- `Verification:`
  - `godot --path . --script test/e2e/test_front_gate_visual.gd`
  - `godot --path . --script test/e2e/test_drive_visual.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - renderer-backed review of the emitted captures
- `Status:` pending

### RM-003
- `ID:` RM-003
- `Title:` Close grounds topology and exterior estate substrate coverage
- `Depends on:` RM-001, RM-002
- `Why it exists:` `SF-006` remains open until the exterior estate reads as one
  coherent substrate-owned system rather than a collection of mostly-fixed
  slices.
- `Implementation notes:`
  - audit `front_gate`, `front_steps`, `drive_lower`, `drive_upper`, `garden`,
    `family_crypt`, and other exterior estate rooms against the current
    substrate rules
  - remove or explicitly classify any remaining exterior scene/model paths that
    still bypass the substrate/content registries
  - ensure gate families, boundary logic, road language, hedge language, sky,
    and outward frontage all resolve through the declared substrate contract
- `Acceptance criteria:`
  - `SF-006` can be marked complete truthfully
  - exterior rooms no longer rely on unclassified direct asset authoring for
    shared physical language
  - renderer review and declaration validation agree on the same exterior
    substrate story
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --path . --script test/e2e/test_front_gate_visual.gd`
  - `godot --path . --script test/e2e/test_drive_visual.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
- `Status:` pending

### RM-004
- `ID:` RM-004
- `Title:` Close whole-house interior substrate coverage
- `Depends on:` RM-001
- `Why it exists:` `SF-007` remains open until every interior floor is clearly
  on the same substrate policy rather than a mixture of shared builders and
  legacy shell assumptions.
- `Implementation notes:`
  - audit ground floor, upper floor, attic, basement, deep basement, and
    greenhouse interior spaces for remaining non-substrate envelope ownership
  - keep declarations canonical; do not move fixes into scene-authoring drift
  - classify any remaining direct interior asset usage as shared content,
    substrate, or deliberate hero-object exception
- `Acceptance criteria:`
  - `SF-007` can be marked complete truthfully
  - every floor resolves through the region/environment matrix and shared
    builder/content contract
  - imported architecture shells are no longer silently carrying primary room
    envelope responsibility
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### RM-005
- `ID:` RM-005
- `Title:` Close route-state integration on top of the substrate
- `Depends on:` RM-003, RM-004
- `Why it exists:` `SF-008` remains open until route differences are proven to
  live on top of shared substrate and mounted/stateful content rather than
  bespoke environment implementations.
- `Implementation notes:`
  - audit `Adult`, `Elder`, and `Child` route-specific physical differences
  - keep route variance in mounted clues, blocked passages, and stateful
    dressing where possible
  - remove any remaining route-specific environment hacks that bypass the
    shared substrate/content channels
- `Acceptance criteria:`
  - `SF-008` can be marked complete truthfully
  - route-specific physical differences do not require separate environment
    tech stacks
  - the route order `Adult -> Elder -> Child` remains intact on a clean-save
    playthrough
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
- `Status:` pending

### RM-006
- `ID:` RM-006
- `Title:` Rebuild visual evidence and rerun the whole-game freeze
- `Depends on:` RM-002, RM-003, RM-004, RM-005
- `Why it exists:` the repo still needs one final truthful freeze gate after
  the remaining substrate and opening work closes.
- `Implementation notes:`
  - rerun the full canonical headless and renderer-backed acceptance bundle
  - update checkpoints to record what passed, what was visually reviewed, and
    any remaining caveats
  - use this task to close `SF-009` and `SF-010` if the evidence supports it
- `Acceptance criteria:`
  - the repo-local freeze bundle passes
  - critical rooms and route finales have fresh reviewable evidence
  - docs, declarations, tests, and captures describe the same shipped game
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
- `Status:` pending

### RM-007
- `ID:` RM-007
- `Title:` Unblock packaged critical-path automation on the AVD
- `Depends on:` RM-006
- `Why it exists:` `US-026` is still blocked by Maestro semantic helper-label
  pickup on `ashworth_test`, which prevents truthful packaged critical-path
  validation.
- `Implementation notes:`
  - investigate the current failure around helper-label pickup at `dismiss
    document`
  - either stabilize the current label/overlay path or replace it with a more
    reliable packaged-debug automation surface
  - keep helper affordances gated to debug/test builds only
- `Acceptance criteria:`
  - `maestro test test/maestro/full_playthrough.yaml` passes on the current
    local AVD, or the exact remaining blocker is narrowed to a concrete device
    or tool limitation with evidence
  - the packaged helper path stays out of normal play
- `Verification:`
  - `maestro test test/maestro/smoke_test.yaml`
  - `maestro test test/maestro/full_playthrough.yaml`
  - emulator run on `ashworth_test`
- `Status:` pending

### RM-008
- `ID:` RM-008
- `Title:` Close packaged smoke and critical-path validation docs
- `Depends on:` RM-007
- `Why it exists:` authored Maestro flows are only useful if the canonical docs
  describe the real passing surface and real blocker surface clearly.
- `Implementation notes:`
  - update `docs/MAESTRO_E2E_PLAN.md` and the relevant packaged-validation
    checkpoints after the AVD helper lane is revalidated
  - make sure the docs distinguish passing smoke, passing critical path, and
    any remaining environment caveats
- `Acceptance criteria:`
  - `US-026` can be marked complete truthfully
  - the canonical packaged-validation doc is executable from a clean local
    review by following the documented steps
- `Verification:`
  - doc review of `docs/MAESTRO_E2E_PLAN.md`
  - `maestro test test/maestro/smoke_test.yaml`
  - `maestro test test/maestro/full_playthrough.yaml`
- `Status:` pending

### RM-009
- `ID:` RM-009
- `Title:` Configure Android release signing and export the release APK
- `Depends on:` RM-006
- `Why it exists:` `US-027` cannot start truthfully while release export is
  still blocked by missing keystore credentials.
- `Implementation notes:`
  - configure release keystore credentials in the local export path
  - keep secrets out of repo-tracked files
  - verify the `Android` release preset uses the intended signing material
- `Acceptance criteria:`
  - release export is no longer blocked by missing signing configuration
  - the release APK is produced successfully on the local machine
- `Verification:`
  - `godot --headless --path . --export-release "Android" build/android/ashworth-manor-release.apk`
- `Status:` blocked

### RM-010
- `ID:` RM-010
- `Title:` Validate release install and launch, then close release-readiness docs
- `Depends on:` RM-008, RM-009
- `Why it exists:` the whole-game ship plan ends with packaged evidence, not
  just repo-local confidence.
- `Implementation notes:`
  - install the release APK on emulator or device
  - capture launch proof and one critical-path continuation
  - close `US-027` with actual evidence and explicit caveats
- `Acceptance criteria:`
  - release APK installs and launches successfully on a real runtime target
  - release-readiness docs record actual packaged-validation scope, evidence,
    and any remaining caveats
  - `US-027` can be marked complete truthfully, or its final blocker is
    recorded with exact evidence
- `Verification:`
  - `adb install -r build/android/ashworth-manor-release.apk`
  - launch verification on the selected emulator or device
  - review of the touched release-readiness docs
- `Status:` blocked

### RM-011
- `ID:` RM-011
- `Title:` Clear remaining first-party doc TODO/TBD residue
- `Depends on:` RM-001, RM-006
- `Why it exists:` the remaining first-party TODO/TBD surface is now tiny, so
  it should be closed as part of final closeout rather than left to drift.
- `Implementation notes:`
  - clear the room-specific audio-loop `TBD` in
    `docs/rooms/foyer/README.md`
  - sweep first-party docs for any remaining stale placeholder language exposed
    during RM-001 and RM-006
- `Acceptance criteria:`
  - no first-party TODO/TBD markers remain in canonical repo-owned docs unless
    they are explicitly archived/historical
- `Verification:`
  - `rg -n "TODO|FIXME|TBD" engine scripts declarations scenes docs/rooms PLAN.md MEMORY.md STRUCTURE.md .ralph-tui/progress.md -g '!addons/**'`
- `Status:` pending

## Critical Gates

- `G1:` execution surfaces are reconciled and one remaining-work batch is
  authoritative
- `G2:` opening exterior clears renderer-backed review on the named hedge,
  drive, village, sky, and sign/valise blockers
- `G3:` substrate closeout and whole-game freeze rerun complete with fresh
  evidence
- `G4:` packaged debug critical-path flow passes on the local AVD
- `G5:` signed Android release build installs, launches, and has documented
  release-readiness evidence

## Resume Instructions

- Resume from this file first.
- Then read:
  - `PLAN.md`
  - `MEMORY.md`
  - `.ralph-tui/progress.md`
  - `docs/SUBSTRATE_FOUNDATION.md`
  - `docs/checkpoints/opening-visual-diagnostic.md`
  - `docs/MAESTRO_E2E_PLAN.md`
- Treat the earliest non-complete non-blocked task as active.
- At the time this batch was written:
  - there are no open GitHub PRs or issues
  - `RM-009` and `RM-010` are externally blocked by release-signing readiness
  - the first critical task is `RM-001`, because the repo’s remaining-work
    story still needs one truthful active execution surface before more
    closeout work lands
