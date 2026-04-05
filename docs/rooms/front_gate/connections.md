# Front Gate — Connections

## Exits

### 1. To Foyer (North — toward mansion)

| Property | Value |
|----------|-------|
| Target Room | `foyer` |
| Type | `path` |
| Position | `(0, 1.5, 10)` — north edge of area |
| Collision | BoxShape3D(2, 3, 1) |
| Locked | No |
| Key | — |

**Narrative:** Walking up the gravel path toward the mansion's front door. This is the point of no return — entering the house begins the game proper.

**Transition:** Slow path fade (0.5s fade, 0.1s hold, 0.5s fade out). Use `psx_fade` dither.

### 2. To Garden (East — side path)

| Property | Value |
|----------|-------|
| Target Room | `garden` |
| Type | `path` |
| Position | `(10, 1.5, 0)` — east edge |
| Collision | BoxShape3D(2, 3, 1) |
| Locked | No |
| Key | — |

**Narrative:** A side path through the grounds. Players who explore before entering the house find the garden, chapel, greenhouse, carriage house, and crypt.

**Transition:** Path fade (same timing as foyer connection).

## Entry Points (Where Player Arrives FROM Other Rooms)

| Coming From | Spawn Position | Spawn Rotation Y | First View |
|-------------|---------------|-------------------|------------|
| New Game | `(0, 0, -8)` | 180.0 (facing north) | Gate behind, mansion ahead |
| Foyer | `(0, 0, 8)` | 0.0 (facing south) | Mansion behind, gate ahead |
| Garden | `(8, 0, 0)` | 270.0 (facing west) | Garden behind, gate left |

## Ending Trigger Zone

The front gate is where endings trigger. When the player exits toward `front_gate` from any interior room, `interaction_manager.gd` checks:
1. `counter_ritual_complete` → Freedom ending already triggered in hidden chamber
2. `knows_full_truth` && !`counter_ritual_complete` → **Escape ending**
3. `elizabeth_aware` && !`knows_full_truth` → **Joined ending**

The connection Area3D at `(0, 1.5, 10)` (→ foyer) is also the "return to mansion" point. The ending decision happens in `_on_door_tapped()` when `target_room == "front_gate"` from inside.
