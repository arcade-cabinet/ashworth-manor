# Shared-Spine State Map

Date: 2026-04-07
Authority: `docs/GAME_BIBLE.md` (Shared Spine, Stages 0–7)

## Purpose

This document defines the canonical state keys that track shared-spine
progression through the game. All three routes (Adult, Elder, Child) share
these states through midgame (Stages 0–7). Route-specific late-game state
diverges at Stage 8.

These keys live in `GameManager.flags` via `set_state()` / `get_state()`.

---

## Canonical State Keys

### Opening (Stages 0–2)

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `front_gate_packet_presented` | bool | interaction_manager | Stage 0 | Solicitor's packet has been shown |
| `front_gate_menu_committed` | bool | interaction_manager | Stage 1 | Player committed to new game or load |
| `front_gate_valise_opened` | bool | interaction_manager | Stage 1 | Valise opened, inventory established |
| `front_gate_threshold_acknowledged` | bool | interaction_manager | Stage 1 | Approach threshold cleared |

These keys already exist in the runtime and are tested by
`test_opening_journey.gd`.

### First Occupation (Stage 3)

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `foyer_threshold_crossed` | bool | room_events | Stage 3 | Player has entered the dark house |
| `foyer_chandelier_awakened` | bool | room_events | Stage 3 | Foyer chandelier responds (route-flavored) |

These keys already exist in the state schema.

### Early Ground Floor (Stage 4)

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `parlor_fire_lit` | bool | interaction_manager | Stage 4 | Hearth lit, first warmth reclaimed |
| `current_light_tool` | string | interaction_manager | Stage 4 | Set to `"firebrand"` after hearth |

These keys already exist in the runtime.

### Elizabeth's First Seizure (Stage 5)

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `kitchen_service_descent_triggered` | bool | interaction_manager | Stage 5 | Elizabeth forces player through service hatch |
| `storage_basement_fall_landing_pending` | bool | interaction_manager | Stage 5 | Next basement entry plays forced-fall beat |
| `elizabeth_aware` | bool | interaction_manager | Stage 5 | Elizabeth has become aware of the player |
| `connection_opened_kitchen_to_storage_basement` | bool | interaction_manager | Stage 5 | Service route is now open |

These keys already exist in the runtime and are tested by
`test_opening_journey.gd`.

### Service Reclamation (Stage 6) — NEW

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `basement_relight` | bool | *to be implemented* | Stage 6 | Player has relighted after the forced-fall landing in the storage basement |
| `bad_air_active` | bool | *to be implemented* | Stage 6 | Bad-air pressure is active, creating survival urgency in the service basement |
| `gas_restored` | bool | *to be implemented* | Stage 6 | Boiler gas-restoration sequence is complete |
| `basement_lights_awake` | bool | *to be implemented* | Stage 6 | Basement sconces have responded to gas restoration |

Implementation notes:
- `basement_relight` should be set after the player successfully relights
  from improvised materials in `storage_basement`
- `bad_air_active` should be set on forced-fall landing and cleared on
  `gas_restored` or on leaving the service basement
- `gas_restored` should be set by a concise interaction sequence in
  `boiler_room`
- `basement_lights_awake` should be set as an immediate consequence of
  `gas_restored`, propagated to basement sconce lighting state

### Midgame Possession (Stage 7) — NEW

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `stable_house_light` | bool | *to be implemented* | Stage 7 | Estate lighting restored above ground after gas restore |
| `walking_stick_phase` | bool | *to be implemented* | Stage 7 | Walking stick has replaced firebrand as the active tool phase |

Implementation notes:
- `stable_house_light` should be set when the player re-emerges from the
  service basement with `gas_restored == true`. This key affects room
  ambient lighting for all subsequent ground-floor and upper-floor loads.
- `walking_stick_phase` should be set when the player acquires the walking
  stick. The `current_light_tool` value should change from `"firebrand"` to
  `"walking_stick"` at this point.
- The walking stick must get an immediate first meaningful use (per
  GAME_BIBLE Stage 7).

### Late-Game Transition (Stage 8) — Route-Specific

| Key | Type | Set by | GAME_BIBLE Stage | Meaning |
|-----|------|--------|-----------------|---------|
| `elizabeth_route` | string | game_manager | Stage 8+ | Active route: `"adult"`, `"elder"`, or `"child"` |
| `macro_thread` | string | game_manager | compat | Legacy thread: `"mourning"`, `"sovereign"`, `"captive"` |

These exist. Route-specific late-game keys will be defined per-route in
US-009 (Adult), US-011 (Elder), and US-013 (Child).

### Route-Order Progression

| Key | Type | Set by | Meaning |
|-----|------|--------|---------|
| `completed_routes` | Array[String] | game_manager | Which routes have been completed, in order |

This exists as `GameManager.completed_routes` and is persisted via
SaveMadeEasy. The route-order invariant is:
- First completion is always `"adult"`
- Second completion is always `"elder"`
- Third completion is always `"child"`
- Post-third is random among unlocked routes

Tested by `test_route_progression.gd`.

---

## State Key Lifecycle

```
Stage 0–2 (Opening)
  front_gate_packet_presented → front_gate_valise_opened → front_gate_threshold_acknowledged

Stage 3 (First Occupation)
  foyer_threshold_crossed → foyer_chandelier_awakened (route-flavored)

Stage 4 (Early Ground Floor)
  parlor_fire_lit → current_light_tool = "firebrand"

Stage 5 (Elizabeth's First Seizure)
  kitchen_service_descent_triggered → storage_basement_fall_landing_pending
  elizabeth_aware = true
  current_light_tool = "" (firebrand lost)

Stage 6 (Service Reclamation)          ← NEW
  basement_relight → bad_air_active
  gas_restored → basement_lights_awake

Stage 7 (Midgame Possession)           ← NEW
  stable_house_light
  walking_stick_phase → current_light_tool = "walking_stick"

Stage 8 (Late-Game Transition)
  route-specific keys (per US-009/011/013)
```

---

## Test Evolution: Legacy Weave → Authored Routes

### Current State

Tests use `macro_thread` values (`captive`, `mourning`, `sovereign`) for
game setup because the full-playthrough and ending tests were written
against the weave-era API.

### Target State

Tests should setup via `elizabeth_route` values (`adult`, `elder`, `child`).
The `macro_thread` compatibility bridge in `game_manager.gd` handles the
translation transparently, but test code should express intent through the
canonical route surface.

### Migration Steps

1. `test_route_progression.gd` — already tests the `adult`/`elder`/`child`
   route surface with legacy compatibility assertions as secondary checks.
   **No migration needed.**

2. `test_full_playthrough.gd` — uses `_reset_game("captive")` etc. Should
   evolve to `_reset_game_for_route("child")` etc., deriving the legacy
   thread internally. **Migrate in US-018.**

3. `test_opening_journey.gd` — route-neutral, no legacy thread references.
   **No migration needed.**

4. `test_declared_interactions.gd` — room-by-room interaction validation.
   Should gain Stage 6–7 spine-stage coverage when those states are
   implemented. **Extend in US-006/US-007.**

5. `test_room_specs.gd` — structural validation, not state-dependent.
   **No migration needed.**

6. `test/generated/test_declarations.gd` — declaration integrity only.
   Route content migration tracked in US-017. **No test-code migration
   needed.**

---

## Companion Documents

- [Runtime Baseline](US-003-runtime-baseline.md) — engine boot, test lane
  status, and known gaps
- `docs/GAME_BIBLE.md` — canonical shared spine (Stages 0–7)
- `declarations/state_schema.tres` — formal state variable declarations
