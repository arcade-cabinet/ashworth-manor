# Front Gate — Connections

## Exits

### 1. To Drive Lower (North — through the opened gate)

| Property | Value |
|----------|-------|
| Target Room | `drive_lower` |
| Type | `path` |
| Position | `(0, 1.5, 8.2)` — north edge of gate beat |
| Collision | BoxShape3D(2, 3, 1) |
| Locked | No conventional lock |
| Key | `required_state: front_gate_threshold_acknowledged` |

**Narrative:** This is the real start of the ceremonial approach. The diegetic estate sign is part of the commitment beat; selecting `Enter the Grounds` acknowledges the threshold. The plaque can still perform the same acknowledgment if the player stops to read it first.

**Transition:** Same-world path traversal. No hard world swap should happen here.

## Entry Points (Where Player Arrives FROM Other Rooms)

| Coming From | Spawn Position | Spawn Rotation Y | First View |
|-------------|---------------|-------------------|------------|
| Solicitor letter / New Game | `(0, 0, -5.4)` | 180.0 (facing north) | Estate sign at the gate, lamp glow, drive beyond |
| `drive_lower` | `(0, 0, 6.8)` | anchor-driven | Broken gate leaves, sign boards, and the estate threshold behind |

## Ending Trigger Zone

The front gate is where endings trigger. When the player exits toward `front_gate` from the outward approach, `interaction_manager.gd` checks:
1. `counter_ritual_complete` → Freedom ending already triggered in hidden chamber
2. `knows_full_truth` && !`counter_ritual_complete` → **Escape ending**
3. `elizabeth_aware` && !`knows_full_truth` → **Joined ending**

The ending decision still happens in `_on_door_tapped()` when `target_room == "front_gate"` from deeper in the estate. The player now reaches that point through `front_steps -> drive_upper -> drive_lower -> front_gate`, which makes the decision feel owned rather than abstract.

## Topology Note

`front_gate` belongs to the ceremonial approach, not the estate discovery network.

Shipped target:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`
- `foyer`

That sequence is now implemented in runtime. `front_gate` is only the threshold
beat, not the whole approach.
