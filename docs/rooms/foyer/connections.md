# Grand Foyer — Connections

## Exits

### 1. To Parlor (North)

| Property | Value |
|----------|-------|
| Target | `parlor` |
| Type | `door` |
| Position | (0, 1.5, 5) |
| Locked | No |

### 2. To Dining Room (East)

| Property | Value |
|----------|-------|
| Target | `dining_room` |
| Type | `door` |
| Position | (6, 1.5, 0) |
| Locked | No |

### 3. To Kitchen (West)

| Property | Value |
|----------|-------|
| Target | `kitchen` |
| Type | `door` |
| Position | (-6, 1.5, 0) |
| Locked | No |

### 4. To Upper Hallway (Stairs Up)

| Property | Value |
|----------|-------|
| Target | `upper_hallway` |
| Type | `stairs` |
| Position | (2, 1.5, -2) |
| Locked | No |

### 5. To Front Gate (South — Exit)

| Property | Value |
|----------|-------|
| Target | `front_gate` |
| Type | `door` |
| Position | (0, 1.5, -5) |
| Locked | No |
| Note | Ending trigger zone — see interaction_manager.gd |

## Entry Points

| Coming From | Spawn Position | Spawn Rotation Y | First View |
|-------------|---------------|-------------------|------------|
| Front Gate | (0, 0, -3) | 0.0 (facing north) | Staircase + chandelier |
| Parlor | (0, 0, 3) | 180.0 (facing south) | Window + portrait |
| Dining Room | (4, 0, 0) | 270.0 (facing west) | Mirror side |
| Kitchen | (-4, 0, 0) | 90.0 (facing east) | Clock side |
| Upper Hallway | (2, 0, -1) | 180.0 (facing south) | Descending stairs |
