# US-017 - Declaration Route-Text Migration

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This checkpoint records the declaration migration slice that makes the
> critical-path source-of-truth content speak `Adult / Elder / Child` directly
> while retaining only explicit compatibility shims for the old weave.

---

## Scope Landed

Critical-path declarations now carry route-key aliases and route-facing text
aligned to the shipped route program.

Touched declaration surfaces include:

- `foyer`
- `parlor`
- `kitchen`
- `dining_room`
- `upper_hallway`
- `master_bedroom`
- `library`
- `guest_room`
- `storage_basement`
- `boiler_room`
- `wine_cellar`
- `attic_storage`
- `family_crypt`

---

## What Changed

### Route-key aliases

Critical declaration `thread_responses` now carry explicit route keys:

- `child`
- `adult`
- `elder`

The old `captive / mourning / sovereign` keys remain only as compatibility
aliases where older systems or tests still expect them.

### Route-specific late surfaces

- `attic_storage` now exposes:
  - adult attic resolve
  - elder attic redirect
  - child attic redirect
- `wine_cellar` and `family_crypt` now expose route-keyed elder bias directly
- `foyer` first-entry elder grammar now names route identity in the declaration
  conditions instead of only the old sovereign thread

### Compatibility-only residue

The remaining weave-era declaration surfaces are intentional shims:

- `declarations/threads/*.tres`
- legacy alternate-ending conditions keyed by `macro_thread`
- route-compatibility state in `state_schema.tres`

Those are no longer the canonical route-expression layer for the shipped main
route program.

---

## Verification

Commands rerun after the declaration migration slice:

```bash
godot --headless --path . --script test/generated/test_declarations.gd
godot --headless --path . --script test/e2e/test_declared_interactions.gd
godot --headless --path . --script test/e2e/test_route_progression.gd
godot --headless --path . --script test/e2e/test_full_playthrough.gd
```

Verified results:

- declaration tests: `561 passed, 0 failed`
- declared interactions: `332 passed, 0 failed`
- route progression: `9 passed, 0 failed`
- full playthrough: `59 passed, 0 failed`
