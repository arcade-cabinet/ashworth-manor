# Parlor — Lighting

## Light Sources

### 1. Fireplace (OmniLight3D) — PRIMARY

| Property | Value |
|----------|-------|
| ID | `parlor_fireplace` |
| Position | (0, 1, 4.5) — north wall, fireplace |
| Color | `(1.0, 0.5, 0.2)` — deep orange ember glow |
| Energy | 1.5 |
| Range | 8.0 |
| Shadows | Yes |
| Flickering | **Yes** — slow deep breathing pattern |

**Flicker pattern:** Deep, slow breathing. 5+ second cycle, ±6% variation. This is a dying fire — the pulse should feel like final breaths.

```
sin(t * 1.2) * 0.06 + sin(t * 2.7) * 0.03
```

### 2. Candle Left (OmniLight3D) — ACCENT

| Property | Value |
|----------|-------|
| Position | (-3, 1.2, 0) — on table/shelf, west side |
| Color | `(1.0, 0.8, 0.4)` — warm candle |
| Energy | 0.8 |
| Range | 4.0 |
| Shadows | No |
| Flickering | **Yes** — gentle breathing |

### 3. Candle Right (OmniLight3D) — ACCENT

| Property | Value |
|----------|-------|
| Position | (3, 1.2, 0) — on table/shelf, east side |
| Color | `(1.0, 0.8, 0.4)` — warm candle |
| Energy | 0.8 |
| Range | 4.0 |
| Shadows | No |
| Flickering | **Yes** — gentle breathing |

## Lighting Design Notes

- **Fireplace dominant:** Everything lit by dying embers. Orange glow against arsenic green walls = life vs poison.
- **ALL lights flicker:** This is the most alive-feeling room. Every light source breathes.
- **No window light:** Heavy velvet drapes block exterior. This room is sealed from outside. Lady Ashworth's private world.
- **Music box event dims fireplace** to 0.5 energy, then restores — a supernatural drain.
- **After `elizabeth_aware`:** Fireplace pulse syncs with an almost-audible heartbeat.
