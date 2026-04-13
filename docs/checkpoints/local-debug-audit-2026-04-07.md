# Local Debug Audit — 2026-04-07

## Purpose

This checkpoint resets the current priority away from Android/export work and
back onto the local debug build. The question is not whether the game can be
packaged. The question is whether the debug build on this machine is
substantively correct in player experience, visual readability, route flow,
dialogue presence, and puzzle continuity.

## Commands Executed

Executed successfully in local debug:

- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_route_progression.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`
- `godot --headless --path . --script test/e2e/test_surface_investigation.gd`
- `godot --headless --path . --script test/e2e/test_threshold_investigation.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --path . --script test/e2e/test_greenhouse_journey.gd`

## What Is Actually Verified

- Declaration integrity is green.
- Core interaction and route progression suites are green.
- Full-playthrough debug traversal is green.
- Renderer-backed opening and whole-house walkthrough captures regenerate
  successfully on this machine.
- The debug build is sufficiently instrumented to judge player experience from
  screenshots and manifest context rather than from pass/fail text alone.

## What Is Not Yet Good Enough

Passing the debug suites does **not** yet mean the game is visually finished.
The current renderer-backed audit still exposes several real defects.

### Opening Threshold

- The front-gate sign is functional, but it still reads too much like a menu
  prop rather than a credible estate marker with attached notices.
- The valise is now a real embodied object, but the threshold composition still
  under-explains why opening it feels socially necessary rather than merely
  required.
- The drive remains the weakest opening surface. Hedge masses are improved from
  the earlier log-like silhouette, but they still read too synthetic and too
  uniform to convincingly sell clipped estate hedges.

### Front-House Readability

- The forecourt/facade composition still feels flatter and more placeholder-like
  than the canonical plan intends.
- The foyer remains too dark in review frames. It reads hostile, which is
  correct, but it does not yet read clearly enough to support visual judgment of
  the staircase, side-room promise, and handoff into first warmth.

### Service-World Readability

- The storage-basement opening state is still too dark to communicate the fall
  aftermath cleanly in several evidence frames.
- The boiler room is mechanically present but visually under-articulated in the
  current overview and gas-restore captures.

### Late-Route Visual Surfaces

- The crypt remains especially weak as a visual space. Even after a light-lift
  pass, it still reads too void-like and under-authored in the overview frames.
- Adult and Child late-room captures are materially stronger than the current
  Elder/crypt presentation.

## First Correction Pass Landed

This audit included an immediate first local-debug correction pass:

- reworked `clipped_hedge_cluster.gd` away from the most obviously log-like
  cylindrical hedge silhouette
- lifted physically motivated light in the foyer, storage basement, boiler
  room, and crypt enough to improve debug readability without turning them into
  flat daylight sets
- reran declaration validation, opening journey, and full renderer walkthrough

## Current Verdict

The debug build is now **well exercised**, but it is **not yet fully verified as
finished**. The blocking work is no longer route logic or missing traversal.
The blocking work is visual truth and experiential correctness, especially in:

1. front-gate / drive hedge craft
2. forecourt / foyer readability
3. storage-basement / boiler-room readability
4. crypt authorship and legibility

## Priority Rule

Until those local debug defects are resolved, Android/export work should remain
secondary. The game itself still has visible issues that can and should be
judged directly in local debug on this machine.
