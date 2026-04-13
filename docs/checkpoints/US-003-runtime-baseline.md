# Runtime Baseline Checkpoint — US-003

Date: 2026-04-07

## Purpose

This document records the verified runtime baseline at the start of
shared-spine implementation. It catalogs active test lanes, known gaps,
and the canonical state map that all subsequent work must target.

---

## Engine Boot Baseline

| Check | Command | Status |
|-------|---------|--------|
| Headless boot | `godot --headless --path . --quit-after 1` | PASS |
| Route progression | `godot --headless --path . --script test/e2e/test_route_progression.gd` | PASS |

---

## Active Test Lanes

### Tier 1 — Repo-Local (Headless)

| Lane | Script | Scope | Status |
|------|--------|-------|--------|
| Engine boot | `--quit-after 1` | Process starts, autoloads register, exits clean | PASS |
| Declaration integrity | `test/generated/test_declarations.gd` | Room, interactable, connection, region, compiled-world, puzzle declarations validate | PASS |
| Room specs | `test/e2e/test_room_specs.gd` | Assembled rooms match shipped spec data (dimensions, interactable counts, connection counts) | PASS |
| Declared interactions | `test/e2e/test_declared_interactions.gd` | Every declared interactable produces a runtime response | PASS |
| Full playthrough | `test/e2e/test_full_playthrough.gd` | Freedom route end-to-end, escape ending, joined ending | PASS |
| Route progression | `test/e2e/test_route_progression.gd` | Adult → Elder → Child fixed order, legacy thread compat, post-unlock replay | PASS |

### Tier 1 — Repo-Local (Renderer-Backed)

| Lane | Script | Scope | Status |
|------|--------|-------|--------|
| Opening journey | `test/e2e/test_opening_journey.gd` | Diegetic front-gate start, packet, valise, drive, first warmth, service descent | Requires renderer |
| Room walkthrough | `test/e2e/test_room_walkthrough.gd` | Multi-room traversal with screenshot capture | Requires renderer |

### Tier 2 — Downstream Release

Not yet attempted. Prerequisites recorded in US-024.

---

## Known Gaps

### Shared-Spine State Keys Not Yet Defined

The GAME_BIBLE defines 8 shared-spine stages (Stages 0–7) but the runtime
does not yet have canonical state keys for the mid-to-late spine
transitions. Existing keys cover early game well (packet, threshold, first
warmth, service descent) but the following are missing:

- `basement_relight` — player has relighted after the forced-fall landing
- `bad_air_active` — bad-air pressure is active in the service basement
- `gas_restored` — boiler gas-restoration sequence is complete
- `basement_lights_awake` — basement sconces have responded to gas restore
- `stable_house_light` — estate lighting is restored above ground
- `walking_stick_phase` — walking stick has replaced firebrand as tool phase
- `route_order_progression` — which routes have been completed (exists as
  `completed_routes` array but lacks a single-key spine-stage signal)

These are defined in the companion state map below.

### Legacy Weave Semantics Still Present in Tests

The test surface currently uses legacy `macro_thread` values for test setup:

| Test | Legacy usage |
|------|-------------|
| `test_full_playthrough.gd` | `_reset_game("captive")`, `_reset_game("mourning")`, `_reset_game("sovereign")` |
| `test_route_progression.gd` | Asserts legacy threads as compatibility shims |
| `test_opening_journey.gd` | Route-neutral (no legacy thread dependency) |

**Evolution path:** Tests must migrate from `_reset_game(legacy_thread)` to
`_reset_game_for_route(route_id)` where `route_id` is `"adult"`, `"elder"`,
or `"child"`. The legacy `macro_thread` compatibility in `game_manager.gd`
can remain as a hidden implementation detail but tests should drive from
the authored route surface, not the compatibility surface.

### Declaration Content Still Weave-Era

The three `MacroThread` declarations (`captive.tres`, `mourning.tres`,
`sovereign.tres`) contain weave-era narrative text. These will be migrated
in US-016/US-017 but remain functional for now because `game_manager.gd`
bridges them via `LEGACY_THREAD_FOR_ROUTE`.

### Missing Spine-Stage Coverage in E2E

`test_full_playthrough.gd` covers:
- Opening → front gate → drive → foyer (Stage 1–3)
- Ground-floor cluster (Stage 4) — partial
- Attic and hidden chamber (Stages 7–8) — jumps directly

It does **not** cover:
- Stage 5 (Elizabeth's first seizure / kitchen descent) — only tested in
  `test_opening_journey.gd`
- Stage 6 (service reclamation: basement relight, gas restore) — no test
- Stage 7 (midgame possession: walking-stick transition) — no test

---

## Companion Documents

- [Shared-Spine State Map](shared-spine-state-map.md) — canonical state
  keys for the 8 spine stages
- `docs/GAME_BIBLE.md` — canonical shared spine definition (Stages 0–7)
- `STRUCTURE.md` — runtime architecture and acceptance surface
