# US-010: Adult Attic Resolution

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This checkpoint records the implementation details for the Adult
> route's late-game transition, attic resolution, and ending trigger.

---

## What Was Implemented

### Late-Game Transition (Stage 8)

The upper hallway triggers a route-specific rupture when the player
returns after visiting the attic with the walking stick:

- **Condition:** `entered_attic AND walking_stick_phase AND NOT late_darkness_active`
- **Effect:** Sets `late_darkness_active: true`, clears `stable_house_light`,
  dims hallway sconces to 0, camera shake, and narrative text
- **ConditionalEventDecl** keeps sconces dark on re-entry

### Lantern Hook Acquisition

The attic stairs provide the late-game tool:

- **Interactable:** `lantern_hook` (type: switch) on the west wall bracket
- **3-tier cascade:** already-taken → blocked-before-darkness → default-pickup
- **State mutations:** `lantern_hook_phase: true`, `current_light_tool: "lantern_hook"`
- **Item:** `lantern_hook` registered in `item_prototypes.json`

### Attic Music Box (Adult Resolution)

The attic storage gains the route's solve object:

- **Interactable:** `attic_music_box` (type: observation) on writing desk
- **4-tier cascade:** already-wound → no-key → no-lantern → default-solve
- **State mutations:** `attic_music_box_wound: true`, `adult_route_complete: true`
- **Ending:** `interaction_manager._on_game_state_changed` watches for
  `attic_music_box_wound` and fires `trigger_ending("adult")` after 6s delay

### Route Completion

`game_manager.trigger_ending("adult")` calls `mark_route_completed()`:
- "adult" is in `POSITIVE_ROUTE_ENDINGS`, so completion is recorded
- `completed_routes` is persisted via SaveMadeEasy
- Next `new_game()` selects "elder" as the next route

---

## State Variables Added

| Variable | Description |
|----------|-------------|
| `late_darkness_active` | Late-game darkness descended, house lights out |
| `lantern_hook_phase` | Lantern hook replaces walking stick |
| `attic_music_box_wound` | Music box wound, Adult route resolved |
| `adult_route_complete` | Adult route completed |

---

## Files Changed

| File | Change |
|------|--------|
| `declarations/state_schema.tres` | 4 new state variables |
| `declarations/rooms/upper_hallway.tres` | Late rupture trigger + conditional event |
| `declarations/rooms/attic_stairs.tres` | Lantern hook interactable + prop |
| `declarations/rooms/attic_storage.tres` | Attic music box interactable + prop |
| `resources/item_prototypes.json` | `lantern_hook` prototype |
| `scripts/interaction_manager.gd` | Adult ending trigger on state change |
| `dialogue/attic/attic_stairs.dialogue` | Lantern hook node + synced texts |
| `dialogue/attic/attic_storage.dialogue` | Music box node |
| `test/e2e/test_declared_interactions.gd` | 2 new test functions |
| `test/e2e/test_full_playthrough.gd` | Adult route test path |
| `test/e2e/room_spec_data.gd` | Updated interactable lists |
| `test/e2e/walkthrough_data.gd` | Updated visit sequences |
| `docs/GAME_BIBLE.md` | Adult late game details |

---

## Design Decisions

1. **Ending via state_changed, not ActionDecl:** `ActionDecl` has no
   `trigger_ending` field. The Adult ending fires through
   `interaction_manager._on_game_state_changed` watching for the
   `attic_music_box_wound` flag — same pattern as the freedom ending
   using a timer in `puzzle_handler.gd`.

2. **Music box type is "observation":** The `interaction_manager` match
   statement only tries `_handle_declared_interaction` for known types
   (note, painting, observation, etc.). The "puzzle" type falls to the
   default case which skips declaration handling. Using "observation"
   ensures the response cascade runs through the declaration engine.

3. **Late rupture condition:** `entered_attic AND walking_stick_phase`
   rather than route-specific gating. This lets the rupture fire on any
   route (Elder and Child will reuse it), with route-specific consequences
   handled downstream (where the music box is found, what the ending means).
