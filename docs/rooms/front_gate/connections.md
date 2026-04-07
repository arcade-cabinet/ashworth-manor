# Front Gate — Connections

## Exits

### 1. Interim Runtime Exit: To Foyer (North — toward mansion)

| Property | Value |
|----------|-------|
| Target Room | `foyer` |
| Type | `path` |
| Position | `(0, 1.5, 10)` — north edge of area |
| Collision | BoxShape3D(2, 3, 1) |
| Locked | No conventional lock |
| Key | `required_state: front_gate_threshold_acknowledged` |

**Narrative:** In the current interim runtime, this is the direct path toward the mansion's front door. The diegetic gate signs are part of that opening commitment; selecting `New Game` also acknowledges the threshold. The plaque can still perform the same acknowledgment beat if the player chooses to examine it first.

**Transition:** Slow path fade (0.5s fade, 0.1s hold, 0.5s fade out). Use `psx_fade` dither.

## Entry Points (Where Player Arrives FROM Other Rooms)

| Coming From | Spawn Position | Spawn Rotation Y | First View |
|-------------|---------------|-------------------|------------|
| New Game | `(0, 0, -15.4)` | 180.0 (facing north) | Hanging sign at the gate, moon overhead, manor ahead down the hedge-lined path |
| Foyer | `(0, 0, 8.6)` | anchor-driven | Front door behind, drive and gate sign ahead |

## Ending Trigger Zone

The front gate is where endings trigger. When the player exits toward `front_gate` from any interior room, `interaction_manager.gd` checks:
1. `counter_ritual_complete` → Freedom ending already triggered in hidden chamber
2. `knows_full_truth` && !`counter_ritual_complete` → **Escape ending**
3. `elizabeth_aware` && !`knows_full_truth` → **Joined ending**

The connection Area3D at `(0, 1.5, 10)` (→ foyer) is also the "return to mansion" point. The ending decision happens in `_on_door_tapped()` when `target_room == "front_gate"` from inside.

## Topology Note

`front_gate` belongs to the ceremonial approach, not the estate discovery network.

Shipped target:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`
- `foyer`

So this doc's direct `front_gate -> foyer` route should be treated as an interim
runtime seam, not the final grounds topology.
