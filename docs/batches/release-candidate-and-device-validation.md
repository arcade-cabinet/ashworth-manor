# Release Candidate and Device Validation

## Summary
Prepare Ashworth Manor for an actual release-candidate build by verifying Android export readiness, wiring or finishing device-level automation support, running emulator/device smoke validation, and documenting the external validation surface. This batch exists because repo-local completion is not the same thing as proving the game builds, installs, launches, and survives real packaged execution.

## Scope
- Included work
  - audit Android/export prerequisites and current release-candidate gaps
  - verify or finish debug/device automation support needed for Maestro-style flows
  - author or tighten device-level smoke and critical-path validation flows
  - build APKs and run emulator/device validation for the shipped route program
  - capture build/install/run evidence and release-readiness notes in repo docs
- Explicitly excluded work
  - app store submission assets, storefront copy, or publishing operations
  - reopening gameplay canon or route design because of taste rather than packaged-runtime defects
  - non-Android platform packaging unless explicitly added later as a separate batch
  - long-term crash analytics or telemetry infrastructure

## Constraints
- Declarations remain canonical.
- This batch assumes the game is otherwise in post-freeze maintenance posture.
- Device/export validation should prove the shipped game, not introduce alternate gameplay-only debug paths for normal players.
- Debug-only helper surfaces used for Maestro or device automation must stay clearly gated from release behavior.
- External validation must preserve diegetic presentation; do not add permanent HUD/testing overlays to the shipped runtime.
- Packaged-build work is not complete until install, launch, and at least one meaningful gameplay flow are validated on emulator or device.

## Assumptions
- `export_presets.cfg` already contains an Android export target.
- `docs/MAESTRO_E2E_PLAN.md` already describes a viable automation direction for packaged device testing.
- The most likely first packaged target is Android via:
  - `godot --headless --path . --export-release "Android" build/ashworth-manor.apk`
- Debug-only helper code may still need to be created, finished, or integrated before Maestro can target semantic interactables reliably.
- The shipped game’s critical packaged validation path should at minimum include:
  - launch
  - packet/valise opening
  - dark-house entry
  - first warmth beat
  - one route-critical continuation or smoke-complete traversal

## Execution Policy
- Completion standard
  - The batch is complete only when an APK can be built, installed, launched, and exercised through meaningful smoke/critical-path validation with repo-local evidence showing the packaged game still behaves like the accepted desktop/runtime version.
- Stop conditions
  - Stop if Android export prerequisites are missing in ways that require external machine setup the repo cannot solve.
  - Stop if device automation would require invasive runtime changes better handled as a separate tooling project.
  - Stop if packaged behavior exposes design-breaking issues that belong in the maintenance batch before release-candidate work can continue.
- Verification cadence
  - Verify build/export preconditions before writing device flows.
  - Build before automation.
  - Re-run packaged smoke after any helper/runtime change for device validation.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave the repo claiming packaged readiness if build/export/install has not actually been proven.

## Task Graph

### R01
- `ID:` R01
- `Title:` Audit Android export and release-candidate prerequisites
- `Depends on:` none
- `Why it exists:` device validation only makes sense if the repo first knows whether export presets, templates, SDK assumptions, and build paths are materially ready.
- `Implementation notes:`
  - inspect:
    - `export_presets.cfg`
    - `docs/MAESTRO_E2E_PLAN.md`
    - any existing build output paths under `build/`
  - identify missing repo-local versus machine-local prerequisites
  - record the release-candidate prerequisite map in `MEMORY.md`
- `Acceptance criteria:`
  - there is a concrete export/readiness checklist
  - repo-local blockers and machine-local blockers are clearly separated
  - downstream tasks can execute against named packaged-validation assumptions
- `Verification:`
  - targeted review of `export_presets.cfg` and `docs/MAESTRO_E2E_PLAN.md`
  - update `MEMORY.md` with the prerequisite map
- `Status:` pending

### R02
- `ID:` R02
- `Title:` Verify or finish debug-only packaged test-helper support for semantic device automation
- `Depends on:` R01
- `Why it exists:` Maestro/device flows are much more robust if the packaged debug build can expose semantic interactable targets rather than relying on brittle raw coordinates.
- `Implementation notes:`
  - inspect whether a packaged-test helper already exists
  - if missing or incomplete, implement the smallest debug-gated helper needed to expose interactable/connection targets safely
  - keep the helper disabled outside debug/test packaging paths
  - align with the direction in `docs/MAESTRO_E2E_PLAN.md`
- `Acceptance criteria:`
  - packaged debug/test builds expose enough semantic hooks for device automation
  - release behavior remains clean and unaffected
  - helper behavior is documented where maintainers will actually find it
- `Verification:`
  - targeted runtime review
  - debug-build/device-helper smoke check as applicable
- `Status:` pending

### R03
- `ID:` R03
- `Title:` Author or tighten packaged smoke and critical-path Maestro flows
- `Depends on:` R02
- `Why it exists:` build success alone is insufficient; the packaged game needs a reproducible interaction surface that proves it can actually be played on device.
- `Implementation notes:`
  - prioritize:
    - launch/smoke
    - packet/valise opening
    - front-door/dark-house entry
    - first warmth beat
    - at least one deeper critical-path continuation
  - prefer stable semantic targets over guessed coordinates wherever possible
  - keep flows focused on proving the shipped experience, not exhaustively automating every room immediately
- `Acceptance criteria:`
  - there is a runnable packaged smoke path
  - at least one meaningful critical-path flow exists beyond “app launches”
  - failures in the packaged opening or early spine can be surfaced reproducibly
- `Verification:`
  - `maestro test test/maestro/` or targeted flow commands once packaged prerequisites exist
- `Status:` pending

### R04
- `ID:` R04
- `Title:` Build release-candidate APK and run emulator/device validation
- `Depends on:` R01, R02, R03
- `Why it exists:` the batch only matters if the game is actually exported, installed, and run under packaged conditions.
- `Implementation notes:`
  - build the APK using the current Android export path
  - use emulator and/or connected device depending on available environment
  - validate install, launch, and packaged smoke/critical-path flow execution
  - collect errors, screenshots, and logs sufficient to distinguish export issues from gameplay issues
- `Acceptance criteria:`
  - an APK is produced successfully
  - the APK installs and launches on emulator or device
  - the packaged smoke/critical-path validation path runs with clear pass/fail evidence
- `Verification:`
  - `godot --headless --path . --export-release "Android" build/ashworth-manor.apk`
  - packaged install/launch commands per environment
  - `maestro test ...` or equivalent packaged validation command
- `Status:` pending

### R05
- `ID:` R05
- `Title:` Triage packaged-runtime defects and apply bounded release-candidate fixes
- `Depends on:` R04
- `Why it exists:` packaged execution often reveals issues that desktop/runtime acceptance misses, and those need one bounded repair loop rather than an ad hoc scramble.
- `Implementation notes:`
  - classify packaged defects as:
    - export/config
    - runtime logic
    - visual/performance
    - input/automation
  - fix only concrete release-candidate blockers discovered by packaged validation
  - loop back through the smallest meaningful packaged verification surface after each fix
- `Acceptance criteria:`
  - concrete packaged blockers are fixed or clearly documented as external blockers
  - patched behavior is reproved in packaged validation
  - the batch does not drift into unrelated redesign
- `Verification:`
  - rerun the relevant build/install/maestro/device commands for each fixed blocker
- `Status:` pending

### R06
- `ID:` R06
- `Title:` Finalize release-readiness docs, evidence links, and checkpoint posture
- `Depends on:` R04, R05
- `Why it exists:` release-candidate work is only durable if future contributors can see what was validated, how, and under what assumptions.
- `Implementation notes:`
  - update:
    - `MEMORY.md`
    - `PLAN.md`
    - `STRUCTURE.md`
    - `docs/MAESTRO_E2E_PLAN.md` if reality changed
  - note what was actually validated:
    - build/export
    - install/launch
    - packaged smoke/critical path
  - record residual platform-specific caveats without overstating readiness
- `Acceptance criteria:`
  - repo docs accurately describe the packaged validation surface
  - evidence paths and validation commands are easy to discover
  - checkpoint posture reflects whether release-candidate readiness is proven or still blocked
- `Verification:`
  - targeted review of updated docs/checkpoint files
  - confirm build/validation commands and evidence references are named consistently
- `Status:` pending

## Critical Gates
- Gate 1: R01 must establish concrete export prerequisites before helper or flow work begins.
- Gate 2: R02 and R03 must produce a stable packaged automation surface before build/install validation is considered meaningful.
- Gate 3: R04 must actually prove export/install/launch before any release-readiness claim is made.
- Gate 4: R06 must leave an honest checkpoint posture; “release candidate” is not valid if packaged validation is partial or blocked.

## Resume Instructions
- Start from this file and the post-freeze batches:
  - `docs/batches/final-integration-and-acceptance.md`
  - `docs/batches/archive-and-handoff-hygiene.md`
  - `docs/batches/post-freeze-maintenance-and-regression-triage.md`
- Before editing, verify the current packaged-validation surface:
  - `sed -n '1,220p' docs/MAESTRO_E2E_PLAN.md`
  - `sed -n '1,220p' export_presets.cfg`
  - `sed -n '1,220p' PLAN.md`
  - `sed -n '1,220p' MEMORY.md`
- Resume at R01 unless a current release-candidate prerequisite map already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact packaged-validation blocker in `MEMORY.md`.
