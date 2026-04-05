# Upper Hallway — Connections

## Exits

### 1. To Foyer (Stairs Down — South)

| Property | Value |
|----------|-------|
| Target | `foyer` |
| Type | `stairs` |
| Position | (0, 1, -8) |
| Locked | No |

### 2. To Master Bedroom (West Door)

| Property | Value |
|----------|-------|
| Target | `master_bedroom` |
| Type | `door` |
| Position | (-2, 1.2, -1) |
| Locked | No |

### 3. To Library (West Door — North)

| Property | Value |
|----------|-------|
| Target | `library` |
| Type | `door` |
| Position | (-2, 1.2, 5) |
| Locked | No |

### 4. To Guest Room (East Door — North)

| Property | Value |
|----------|-------|
| Target | `guest_room` |
| Type | `door` |
| Position | (2, 1.2, 5) |
| Locked | No |

### 5. To Attic Stairwell (North — LOCKED)

| Property | Value |
|----------|-------|
| Target | `attic_stairs` |
| Type | `door` |
| Position | (0, 1.5, 7.5) |
| Locked | **Yes** |
| Key | `attic_key` |

**Note:** This is handled as a `locked_door` interactable (see interactables.md), not a standard connection Area3D. The interaction_manager handles the key check and room transition.

## Current Scene Fix Required
Scene currently only has `to_foyer` connection. Must add: `to_master_bedroom`, `to_library`, `to_guest_room`. Attic door is an interactable, not a connection.

## Entry Points

| Coming From | Spawn Position | Spawn Rotation Y | First View |
|-------------|---------------|-------------------|------------|
| Foyer (stairs) | (0, 0, -6) | 0.0 (facing north) | Long corridor, attic door at far end |
| Master Bedroom | (-1, 0, -1) | 90.0 (facing east) | Mid-corridor |
| Library | (-1, 0, 5) | 90.0 (facing east) | North section |
| Guest Room | (1, 0, 5) | 270.0 (facing west) | North section |
| Attic Stairwell | (0, 0, 6) | 180.0 (facing south) | Looking back down corridor |
