# US-026 — Packaged Smoke And Critical-Path Validation Flows

## Authored Flows

- Passing packaged smoke flow:
  - `test/maestro/smoke_test.yaml`
- Authored helper-backed critical-path flow:
  - `test/maestro/full_playthrough.yaml`

The critical-path flow covers:

- launch / landing
- packet dismissal
- valise interaction
- drive and front steps
- dark foyer entry
- parlor first warmth
- kitchen-side deeper continuation into the storage basement

## Device Validation Result

Validated on AVD:

- `ashworth_test`

Verified:

- `maestro test test/maestro/smoke_test.yaml` passes

Blocked:

- `maestro test test/maestro/full_playthrough.yaml`
- current blocker: semantic helper label detection on this emulator surface,
  first reproduced at `dismiss document`

Current mitigation work landed in repo:

- helper critical-path labels are now short, numbered, and OCR-friendly
  (`01 DISMISS`, `02 OPEN VALISE`, etc.)
- `test/maestro/full_playthrough.yaml` now targets those stronger helper labels
  instead of the longer mixed-case strings

## Outcome

`US-026` is blocked, but only by a named device-side automation surface:
semantic label pickup on the current AVD. The smoke lane is real and green; the
critical-path flow is authored and waiting on device-side stabilization.
