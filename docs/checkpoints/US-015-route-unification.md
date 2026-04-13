# US-015 - Route Unification and Route-Order Hardening

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This checkpoint records the verified route-system unification slice that
> makes the `Adult -> Elder -> Child` program explicit in runtime helpers,
> progression tests, and the main playthrough harness.

---

## Scope Landed

The route program now has a stable runtime surface instead of being inferred
only from scattered state mutations:

1. `GameManager` exposes a route-context API
2. post-third-run behavior is named explicitly as replay mode
3. route-progression and full-playthrough tests now drive `adult/elder/child`
   directly instead of manually poking legacy thread names
4. the brass winding key / music-box solve remains the invariant final-object
   arc across all three route completions

---

## Runtime and Test Changes

### GameManager route API

- Added `set_route_context(route_id)` to centralize:
  - `elizabeth_route`
  - derived legacy compatibility thread
- Added `get_route_mode()`:
  - `canonical_progression`
  - `post_canonical_replay`

This means the repo now has one stable place to ask "which authored route are
we on?" and "are we past the first three canonical completions?"

### Route-order hardening

- `test_route_progression.gd` now validates:
  - first run -> `adult`
  - second run -> `elder`
  - third run -> `child`
  - post-third-run replay remains inside the authored route set
  - post-third-run replay mode is explicit

### Full-playthrough route harness

- `test_full_playthrough.gd` now resets by `adult`, `elder`, and `child`
  directly.
- The harness no longer stages the three main completions by passing raw legacy
  thread ids around.

---

## Canonical Meaning

This checkpoint does **not** remove legacy `macro_thread` compatibility from the
repo yet. It does make that compatibility secondary:

- canonical route identity is `adult / elder / child`
- legacy thread ids remain only as compatibility shims where older declaration
  content still needs them
- the shipped route order is no longer only implied by docs

---

## Verification

Commands rerun after the route-unification slice landed:

```bash
godot --headless --path . --script test/e2e/test_route_progression.gd
godot --headless --path . --script test/e2e/test_full_playthrough.gd
godot --headless --path . --script test/generated/test_declarations.gd
godot --headless --path . --script test/e2e/test_declared_interactions.gd
```

Verified results:

- route progression: `9 passed, 0 failed`
- full playthrough: `59 passed, 0 failed`
- declaration tests: `561 passed, 0 failed`
- declared interactions: `332 passed, 0 failed`

---

## Next Dependency

`US-016` and `US-017` remain the active migration tranche:

- critical-path room docs must stop speaking weave-era canon
- critical-path declarations must keep moving from legacy thread framing to
  explicit route framing, with compatibility shims left only where necessary
