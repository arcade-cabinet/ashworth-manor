# Codex Packaged Closeout Batch

## Summary

Execute the real remaining downstream stories after the recovered Ralph tranche.
The route program, repo-local freeze, archive/handoff cleanup, and debug
packaged helper support are already in place. The only unfinished ship stories
are packaged critical-path validation and release-candidate proof, plus the
documentation/status surfaces that must be reconciled once those complete.

## Scope

- Included work
  - `US-026` packaged smoke and critical-path validation proof
  - `US-027` release export, install, and launch proof
  - final PRD/checkpoint/progress reconciliation for the remaining tranche
- Explicitly excluded work
  - reopening route logic unless packaged validation exposes a real runtime bug
  - new gameplay or narrative scope
  - speculative device automation work beyond what is needed to close the PRD

## Task List

### T01
- `Title:` Stabilize the packaged critical-path helper surface
- `Why it exists:` `US-026` needs a packaged flow that can be executed on the
  current emulator without OCR guesswork.
- `Status:` pending

### T02
- `Title:` Run and verify packaged critical-path validation on emulator/device
- `Why it exists:` the PRD must end with real launch-to-basement evidence, not
  just a debug helper implementation.
- `Depends on:` T01
- `Status:` pending

### T03
- `Title:` Provision local release signing and produce release install/launch proof
- `Why it exists:` `US-027` is still blocked only by local signing state.
- `Depends on:` T02
- `Status:` pending

### T04
- `Title:` Reconcile PRD, checkpoints, and progress surfaces to the final state
- `Why it exists:` the repo should name what is actually done, not what used to
  be blocked.
- `Depends on:` T02, T03
- `Status:` pending

## Verification

- `godot --headless --path . --quit-after 1`
- `maestro test test/maestro/smoke_test.yaml`
- `maestro test test/maestro/full_playthrough.yaml`
- `godot --headless --path . --export-release "Android Release" build/android/ashworth-manor-release.apk`
- `adb install --no-incremental -r build/android/ashworth-manor-release.apk`
- `adb shell am start -W -n com.arcadecabinet.ashworthmanor/com.godot.game.GodotAppLauncher`

## Resume Rule

Start at the earliest non-`verified_done` task and keep going until:

- `US-026` and `US-027` are both truthfully closed, or
- a new hard blocker appears and is recorded in the checkpoint surfaces.
