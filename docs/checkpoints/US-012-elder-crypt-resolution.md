# US-012 - Elder Crypt Resolution

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This checkpoint records the verified `Elder` late-route implementation
> that now resolves below the house in the crypt rather than in the attic.

---

## Scope Landed

The second canonical completion now plays as a real route:

1. upper-hallway late rupture strips stable house light
2. attic threshold yields the lantern-on-hook phase
3. attic music box redirects instead of resolving the route
4. wine cellar provides the maintained lateral bypass
5. family crypt becomes the final chamber
6. crypt gate is opened with the hook from the burial side
7. the crypt music box resolves `Elder`

---

## Runtime and Content Changes

### State and route progression

- Added elder-route runtime flags:
  - `elder_attic_redirected`
  - `elder_cellar_bypass_opened`
  - `elder_music_box_wound`
  - `elder_route_complete`
- Elder endings now fire from `elder_music_box_wound` through
  `interaction_manager._on_game_state_changed`.

### Attic redirect

- `attic_storage` no longer resolves the music box for the Elder route.
- Interacting with the attic box in Elder now redirects the player downward and
  sets `elder_attic_redirected`.

### Cellar bypass

- `wine_cellar` now contains `cellar_barrel_passage`.
- The passage:
  - blocks early before the attic redirect
  - blocks if the lantern hook is missing
  - opens the burial-side bypass once the player has both the redirect and the
    hook

### Crypt finale

- `family_crypt` now contains:
  - `crypt_gate_latch`
  - `crypt_music_box`
- The latch unlocks the crypt gate from the burial side when the player has the
  hook.
- The crypt music box requires the gate to be opened and the brass winding key
  from the valise.
- Winding the crypt box sets `elder_music_box_wound`, marks
  `elder_route_complete`, and triggers the Elder ending.

### Test/runtime hygiene

- `new_game()` now resets room-event runtime state so once-only rupture logic
  can fire correctly in repeated in-process route tests.

---

## Verification

Commands rerun after the Elder route landed:

```bash
godot --headless --path . --quit-after 1
godot --headless --path . --script test/generated/test_declarations.gd
godot --headless --path . --script test/e2e/test_room_specs.gd
godot --headless --path . --script test/e2e/test_route_progression.gd
godot --headless --path . --script test/e2e/test_declared_interactions.gd
godot --headless --path . --script test/e2e/test_full_playthrough.gd
godot --path . --script test/e2e/test_room_walkthrough.gd
```

Verified results:

- declaration tests: `559 passed, 0 failed`
- room specs: `375 passed, 0 failed`
- route progression: `9 passed, 0 failed`
- declared interactions: `293 passed, 0 failed`
- full playthrough: `123 passed, 0 failed`
- walkthrough: `108 found, 0 missing`, `0 warnings`, `0 failures`

---

## Capture Evidence

Renderer-backed walkthrough captures were regenerated under:

- `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/walkthrough/`

Important review note:

- generic burial-side entry frames are mechanically present but not showcase
  quality yet
- `wine_cellar_entry.png` is too dark to serve as polished evidence
- `family_crypt_entry.png` is readable only as a debug capture, not as final
  visual proof
- this should be revisited during the later renderer/polish tranche rather than
  misrepresented as finished

---

## Next Dependency

`US-013` can now begin.

The next route should build on this Elder completion by turning the attic into a
false answer and clue engine for the hidden-room Child route.
