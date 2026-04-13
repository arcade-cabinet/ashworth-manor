# US-025 — Debug-Gated Packaged Test Helper

## Landed Work

- Added debug-only helper:
  - `scripts/debug/maestro_helper.gd`
- Helper activation is now gated in `scripts/game_manager.gd` by:
  - debug build
  - non-headless runtime
  - `--maestro-helper` command-line presence
- The Android export preset now carries:
  - `command_line/extra_args="--maestro-helper"`

## Helper Intent

The helper overlays semantic labels for:

- current room
- interactables
- room connections
- document dismissal

This keeps helper affordances out of normal release play while giving packaged
automation a semantic surface in debug builds.

## Verification

Executed successfully after helper landing:

- `godot --headless --path . --quit-after 1`
- `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`

## Outcome

`US-025` is complete. The helper is implemented and safely gated, even though
its device-side OCR pickup still needs stabilization for richer Maestro flows.
