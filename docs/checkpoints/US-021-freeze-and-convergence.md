# US-021 — Repo-Local Freeze And Convergence Proof

## Scope

Run the full repo-local acceptance surface after the route program, doc
migration, renderer rebuild, and late polish work so one frozen repo state can
be defended honestly.

## Freeze Bundle

Executed successfully on `2026-04-07`:

- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_route_progression.gd`
- `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`

## Convergence Surface

The freeze rerun confirms that the current repo agrees across:

- `docs/GAME_BIBLE.md` and the canonical top-level docs
- declaration-authored rooms, world graph, and route state
- route-program and playthrough automation
- renderer-backed opening and walkthrough evidence

The current gdUnit HTML/XML reports were refreshed under:

- `reports/report_6/`

The current renderer-backed evidence remains at:

- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/`
- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/walkthrough/`

## Outcome

`US-021` is complete. Repo-local freeze is now green for the shipped
`Adult -> Elder -> Child` game.
