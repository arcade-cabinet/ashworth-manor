# Grand Foyer — Lighting

## Light Sources

### 1. Chandelier (OmniLight3D) — PRIMARY

| Property | Value |
|----------|-------|
| ID | `foyer_chandelier` |
| Type | OmniLight3D |
| Position | (0, 4.5, 0) — center, near ceiling |
| Color | `(1.0, 0.9, 0.7)` — warm golden |
| Energy | 4.0 |
| Range | 12.0 |
| Shadows | Yes |
| Flickering | No (steady — gas chandelier, not candle) |
| Switchable | Yes — controlled by `entry_switch` interactable |

**Purpose:** Dominant light. Warm golden glow that fills the room. The marble floor reflects it, creating the sense of opulence. When switched off, the room drops to sconce-and-moonlight levels, dramatically changing the mood.

### 2. West Sconce (OmniLight3D) — ACCENT

| Property | Value |
|----------|-------|
| Type | OmniLight3D |
| Position | (-5, 3, -3) — west wall |
| Color | `(1.0, 0.7, 0.4)` — warm amber |
| Energy | 1.5 |
| Range | 5.0 |
| Shadows | No |
| Flickering | **Yes** (`metadata/flickering = true`) |

### 3. East Sconce (OmniLight3D) — ACCENT

| Property | Value |
|----------|-------|
| Type | OmniLight3D |
| Position | (5, 3, -3) — east wall |
| Color | `(1.0, 0.7, 0.4)` — warm amber |
| Energy | 1.5 |
| Range | 5.0 |
| Shadows | No |
| Flickering | **Yes** (`metadata/flickering = true`) |

### 4. Window Moonlight (OmniLight3D) — CONTRAST

| Property | Value |
|----------|-------|
| Type | OmniLight3D |
| Position | (0, 3.5, -5) — south wall window |
| Color | `(0.6, 0.7, 0.9)` — cold moonlight |
| Energy | 1.0 |
| Range | 6.0 |
| Shadows | No |
| Flickering | No |

**Purpose:** Cold moonlight through the window creates contrast with the warm interior. The window_ray.glb model provides a visible beam of light. Together they establish the warm-inside/cold-outside duality.

## Lighting Design Notes

- **Chandelier is switchable** — player can toggle it off to see the room in moonlight only, which makes the mirror more prominent and atmospheric
- **Only chandelier casts shadows** — limits to 1 shadow-casting light for performance
- **Sconces flicker gently** — room_base.gd default pattern: `sin(t*2.5)*0.04 + sin(t*4.3)*0.02`
- **Warm vs cold** — 3 warm sources (chandelier, 2 sconces) vs 1 cold (moonlight). Interior is warm amber, exterior peeks in blue.
- **Marble reflection** — floor0.glb's checkered marble naturally has some specular that catches the chandelier. No special material needed.
