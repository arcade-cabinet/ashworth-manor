# Dining Room — Lighting

## Light Sources

### 1. Chandelier (OmniLight3D) — PRIMARY

| Property | Value |
|----------|-------|
| Position | (0, 2, 0) — center, above table |
| Color | `(1.0, 0.9, 0.7)` — warm golden |
| Energy | 4.0 |
| Range | 10.0 |
| Shadows | Yes |
| Flickering | No (steady gas chandelier) |

### 2. Table Candle 1 (OmniLight3D) — ACCENT

| Property | Value |
|----------|-------|
| Position | (0, 1, -1.5) — south end of table |
| Color | `(1.0, 0.85, 0.5)` — warm candle |
| Energy | 2.0 |
| Range | 4.0 |
| Shadows | No |
| Flickering | **Yes** (`metadata/flickering = true`) — CURRENTLY MISSING, must add |

### 3. Table Candle 2 (OmniLight3D) — ACCENT

| Property | Value |
|----------|-------|
| Position | (0, 1, 1.5) — north end of table |
| Color | `(1.0, 0.85, 0.5)` — warm candle |
| Energy | 2.0 |
| Range | 4.0 |
| Shadows | No |
| Flickering | **Yes** (`metadata/flickering = true`) — CURRENTLY MISSING, must add |

## Lighting Design Notes

- **Current scene issue:** Candle lights exist but lack `metadata/flickering = true`. Must add.
- **Burgundy walls absorb light** — this room feels darker than its 0.55 ambient_darkness suggests because the deep red walls swallow illumination.
- **Table as altar:** The chandelier directly above the long table creates a pool of light surrounded by darkness. The table is the focal point. Everything else recedes.
- **No window light:** Interior room with no exterior walls. Sealed. The only light comes from within.
