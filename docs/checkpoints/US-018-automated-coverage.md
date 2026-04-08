# US-018 — Automated Coverage Expansion

## Purpose

Close the remaining automated-coverage gap after the three-route integration by
making the shipped route program provable in both the existing headless E2E
lanes and a real gdUnit4 CLI lane.

## What Landed

- `test/e2e/test_full_playthrough.gd` now drives the shipped
  `Adult -> Elder -> Child` program directly through route ids and asserts:
  - late darkness loss of `stable_house_light`
  - `lantern_hook` acquisition
  - route-specific redirect/finale states
  - route-specific completion flags
  - route-specific ending emission
- `test/e2e/test_route_progression.gd` now proves:
  - first run = `adult`
  - second run = `elder`
  - third run = `child`
  - post-third-run replay mode is explicit and constrained to authored routes
- `test/unit/route_program_test.gd` now provides a focused gdUnit4 lane for:
  - canonical progression sequencing
  - post-canonical replay mode
  - compatibility mapping performed by `set_route_context()`
- `GdUnitRunner.cfg` is present at repo root so gdUnit4 has a project-local
  runner surface.

## gdUnit CLI Contract

The generic gdUnit invocation documented earlier was incomplete for this repo.
This project requires `--ignoreHeadlessMode` when running gdUnit4 headless.

Working command:

```bash
godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode
```

Observed behavior:

- without `--ignoreHeadlessMode`, gdUnit4 aborts with
  `Headless mode is not supported!`
- with the flag, the route-program suite executes successfully and writes
  reports under `reports/report_*/`

## Verification

Verified during this checkpoint:

```bash
godot --headless --path . --script test/generated/test_declarations.gd
godot --headless --path . --script test/e2e/test_room_specs.gd
godot --headless --path . --script test/e2e/test_declared_interactions.gd
godot --headless --path . --script test/e2e/test_route_progression.gd
godot --headless --path . --script test/e2e/test_full_playthrough.gd
godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode
```

All passed at the time this checkpoint was written.

## Result

`US-018` is satisfied at the repo-local layer:

- the shipped three-route program is covered by automated regression lanes
- route ordering is explicit, not implicit
- endings are differentiated by route
- gdUnit4 is no longer documented as a hypothetical addon surface; it is a
  working command in this repo
