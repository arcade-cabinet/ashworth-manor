# Upper Hallway — Lighting

## Light Sources

### 1. Sconce North (OmniLight3D)

| Property | Value |
|----------|-------|
| ID | `hallway_sconce_north` |
| Position | (-1.5, 2, 5) — near library/guest room doors |
| Color | `(1.0, 0.7, 0.4)` — warm amber |
| Energy | 1.2 |
| Range | 6.0 |
| Shadows | No |
| Flickering | **Yes** |
| Switchable | Yes — controlled by `hallway_switch` |

### 2. Sconce South (OmniLight3D)

| Property | Value |
|----------|-------|
| Position | (1.5, 2, -1) — near master bedroom door |
| Color | `(1.0, 0.7, 0.4)` — warm amber |
| Energy | 1.2 |
| Range | 6.0 |
| Shadows | No |
| Flickering | **Yes** |
| Switchable | No (always on) |

### 3. Window Light (OmniLight3D) — if window present

| Property | Value |
|----------|-------|
| Position | (2, 2.5, 0) — east wall, mid-corridor |
| Color | `(0.6, 0.7, 0.9)` — cold moonlight |
| Energy | 0.6 |
| Range | 4.0 |
| Shadows | No |
| Flickering | No |

## Lighting Design Notes

- **Narrow corridor = long shadows.** Two sconces create pools of light with dark gaps between. The attic door at the far end is in semi-darkness.
- **Switchable north sconce** — turning it off makes the attic door approach much darker, building dread.
- **Carpet absorbs light** — the runner down the center doesn't reflect, creating a dark strip.
- **After `elizabeth_aware`:** Sconces flicker more aggressively near the attic door end.

The live declaration now includes both sconces plus a weak cold window light at mid-corridor so the hall does not read as a flat amber tunnel.
