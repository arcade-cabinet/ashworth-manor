# US-023 — Post-Freeze Maintenance Baseline

## Baseline

The post-freeze baseline is the green `US-021` bundle recorded in
`US-021-freeze-and-convergence.md`.

That baseline currently means:

- repo-local freeze lanes pass
- the route program is fixed to `Adult -> Elder -> Child`
- renderer-backed review evidence exists for opening and walkthrough lanes
- debug Android packaging/install/launch is partially proven downstream

## Regression Register

### High Risk

- Packaged critical-path automation
  - `test/maestro/full_playthrough.yaml` is authored but not yet verified on
    the `ashworth_test` AVD because semantic helper labels are not being picked
    up reliably by Maestro OCR.
- Android release export
  - release export is blocked by missing release keystore credentials.

### Medium Risk

- Renderer-backed walkthrough lane emits a benign engine warning on this Mac:
  - `Interpolated Camera3D triggered from outside physics process: "/root/Main/QACamera3D"`
  - the lane still passes with `0 warnings, 0 failures`, but the engine log
    noise should be watched.
- Device-side Android install state
  - incremental install reported success while package-manager lookup failed.
    non-incremental/streamed install was reliable and is the current documented
    install path.

### Low Risk

- Historical docs
  - archived weave-era docs are now labeled, but future contributors should
    still default to `docs/GAME_BIBLE.md` and `docs/INDEX.md` first.

## Outcome

`US-023` is complete. The repo is now in a maintenance posture with an explicit
known-good baseline and a truthful regression register.
