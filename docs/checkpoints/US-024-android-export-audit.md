# US-024 — Android Export And Packaged-Validation Audit

## Repo-Owned Surface

- Export preset is now named `Android` in `export_presets.cfg`.
- Project icon is configured in `project.godot`.
- Gradle is no longer required for the local export path
  (`gradle_build/use_gradle_build=false`).

## Local Toolchain Audit

Present on this machine:

- SDK root: `/Users/jbogaty/Library/Android/sdk`
- Build tools:
  - `zipalign`
  - `apksigner`
- AVD tooling:
  - `sdkmanager`
  - `avdmanager`
- Existing AVDs:
  - `Pixel_9_Pro_Fold`
  - `Pixel_Tablet`
  - `ashworth_test`
- CLI tools on path:
  - `adb`
  - `maestro`

Local credential state:

- debug signing configured in `.godot/export_credentials.cfg`
- release signing missing in `.godot/export_credentials.cfg`

Device state during audit:

- no physical devices attached
- emulator-based validation available through `ashworth_test`

## Outcome

`US-024` is complete. Android/export prerequisites are now explicit, and the
remaining blockers are no longer hidden in the repo.
