# US-016 - Critical-Path Room Doc Migration

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This checkpoint records the room-doc migration slice that moves the
> critical path away from weave-era framing and toward the shipped
> `Adult / Elder / Child` route program.

---

## Scope Landed

The critical-path room docs no longer describe the shipped game through
`Captive / Mourning / Sovereign` labels.

Key migrated surfaces now include:

- `front_gate`
- `storage_basement`
- `wine_cellar`
- `family_crypt`
- `attic_stairwell`
- `attic_storage`
- `hidden_chamber`
- route-bias support docs in `hallway`, `library`, `guest_room`, and
  `dining_room`

---

## What Changed

### Route naming

- room-doc variant labels were converted from weave names to:
  - `Child`
  - `Adult`
  - `Elder`

### Shared-spine docs

- basement docs now describe:
  - improvised relight
  - bad-air pressure
  - service-world logic
- cellar/crypt docs now describe:
  - burial-side bypass
  - crypt latch
  - crypt music-box finale

### Late-route docs

- attic storage now documents:
  - adult attic resolution
  - elder attic redirect
  - child false-answer logic
  - sealed seam reveal
- hidden chamber docs now document the shipped sealed nursery rather than the
  old ritual room
- attic stairwell now documents the lantern-hook transition and late-route
  threshold role

---

## Remaining Historical Material

Some older floor-level overview docs and non-critical support prose still use
historical assumptions or Victorian mourning language. Those are not currently
presenting the weave as active route canon and can be handled later under the
archive/handoff tranche.

---

## Verification

The migration was checked against the active acceptance surfaces:

```bash
godot --headless --path . --script test/e2e/test_room_specs.gd
godot --path . --script test/e2e/test_opening_journey.gd
godot --path . --script test/e2e/test_room_walkthrough.gd
```

Verified results:

- room specs: `375 passed, 0 failed`
- opening journey: `32 passed, 0 failed`
- walkthrough: `112 found, 0 missing`, `0 warnings`, `0 failures`
