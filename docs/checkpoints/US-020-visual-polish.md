# US-020 — Critical-Path Visual Polish

## Scope

Polish the visually fragile late critical path so renderer-backed review stops
surfacing obviously underlit or placeholder-feeling basement, attic, crypt, and
sealed-room evidence.

## Landed Work

- Improved late-room declaration lighting in:
  - `declarations/rooms/storage_basement.tres`
  - `declarations/rooms/attic_storage.tres`
  - `declarations/rooms/family_crypt.tres`
  - `declarations/rooms/hidden_chamber.tres`
- Rebalanced walkthrough capture behavior in:
  - `test/e2e/test_room_walkthrough.gd`
- Promoted readable milestone captures for:
  - relit basement mattress corner
  - scratched basement portrait
  - attic portrait and attic music box
  - crypt graves and crypt music box
  - sealed-room entry and child music box

## Verification

Executed successfully:

- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`

Renderer-backed evidence regenerated under:

- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/`
- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/walkthrough/`

## Outcome

`US-020` is complete. The critical path now reads as intentionally lit and
reviewable rather than merely traversable. The sealed room remains austere by
design, but it no longer reads like leftover occult placeholder content.
