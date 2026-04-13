# US-014 - Child Hidden-Room Resolution

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This checkpoint records the verified `Child` late-route implementation
> that resolves in the sealed room rather than in the attic or crypt.

---

## Scope Landed

The third canonical completion now plays as a real route:

1. upper-hallway late darkness strips the midgame house certainty
2. attic stairs transition the player into the lantern-hook phase
3. attic music box behaves as a false answer and redirects toward the west wall
4. the sealed seam requires the hook and reveals the erased room
5. the hidden chamber is re-authored as a sealed nursery, not an occult cell
6. the child music box resolves `Child`

---

## Runtime and Content Changes

### State and progression

- Added child-route runtime flags:
  - `child_attic_redirected`
  - `child_hidden_room_revealed`
  - `child_music_box_wound`
  - `child_route_complete`
- Child ending now fires from `child_music_box_wound` through
  `interaction_manager._on_game_state_changed`.

### Attic false-answer chain

- `attic_storage` no longer resolves the route for `Child`.
- Interacting with `attic_music_box` in `Child` now:
  - plays only a short phrase
  - sets `child_attic_redirected`
  - explicitly tells the player the real melody is behind the west wall

### Sealed-room reveal

- Added `sealed_seam` to `attic_storage`.
- The seam:
  - reads as architecture first
  - blocks until the attic redirect has happened
  - blocks again until the hook phase is active
  - sets `child_hidden_room_revealed` and `hidden_door_unlocked` when solved

### Hidden chamber rewrite

- `hidden_chamber.tres` is now the sealed nursery room rather than a ritual
  chamber.
- The room now centers:
  - `child_music_box`
  - `nursery_drawings`
  - `child_bed`
  - `height_marks`
  - `nursery_mirror`
- Winding the child music box:
  - sets `child_music_box_wound`
  - sets `child_route_complete`
  - sets `knows_full_truth`
  - triggers the `Child` ending

### Test/capture surface updates

- Declared-interaction coverage now includes:
  - child route bias in upper-house rooms
  - attic false-answer behavior
  - sealed seam reveal logic
  - sealed-room final solve
- Walkthrough data now matches the shipped late-route objects:
  - `sealed_seam`
  - `cellar_barrel_passage`
  - `crypt_gate_latch`
  - `crypt_music_box`
  - sealed-room nursery interactables

---

## Verification

Commands rerun after the Child route landed:

```bash
godot --headless --path . --script test/generated/test_declarations.gd
godot --headless --path . --script test/e2e/test_room_specs.gd
godot --headless --path . --script test/e2e/test_declared_interactions.gd
godot --headless --path . --script test/e2e/test_route_progression.gd
godot --headless --path . --script test/e2e/test_full_playthrough.gd
godot --path . --script test/e2e/test_opening_journey.gd
godot --path . --script test/e2e/test_room_walkthrough.gd
```

Verified results:

- declaration tests: `561 passed, 0 failed`
- room specs: `375 passed, 0 failed`
- declared interactions: `332 passed, 0 failed`
- route progression: `9 passed, 0 failed`
- full playthrough: `59 passed, 0 failed`
- opening journey: `32 passed, 0 failed`
- walkthrough: `112 found, 0 missing`, `0 warnings`, `0 failures`

---

## Capture Evidence

Renderer-backed captures were regenerated under:

- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/`
- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/walkthrough/`

The Child route now has stable screenshot coverage for:

- attic stairs
- attic storage
- sealed room entry
- sealed-room nursery interactables

---

## Next Dependency

`US-015` can now begin.

The next remaining tranche is route-system unification:

- one coherent winding-key/music-box arc across all three routes
- route-first progression hardened beyond the third run
- critical-path migration away from presenting legacy weave semantics as canon
