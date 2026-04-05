# Front Gate — Lighting

## Light Sources

### 1. Moonlight (DirectionalLight3D)

| Property | Value |
|----------|-------|
| Type | DirectionalLight3D |
| Direction | Angled from upper-right |
| Transform | `Transform3D(0.866, 0.354, -0.354, 0, 0.707, 0.707, 0.5, -0.612, 0.612, 0, 0, 0)` |
| Color | `(0.6, 0.65, 0.85)` — cold moonlight, blue-white |
| Energy | 1.5 |
| Shadows | Enabled |
| Flickering | No |

**Purpose:** Primary illumination. Cold, pale, casts long tree shadows across the ground. Sets the tone: this is night. This is cold. This is abandoned.

### 2. Gate Lamp (OmniLight3D)

| Property | Value |
|----------|-------|
| Type | OmniLight3D |
| Position | `(-4, 3, -10)` — atop gate pillar |
| Color | `(1.0, 0.85, 0.5)` — warm gas lamp |
| Energy | 2.5 |
| Range | 10.0 |
| Shadows | No (performance — moonlight handles shadows) |
| Flickering | **Yes** (`metadata/flickering = true`) |

**Purpose:** The only warm light in the scene. A beacon. Draws the eye to the gate. The fact that it's still lit after 130+ years is the first wrongness — something is keeping it burning.

**Flicker pattern:** Slow breathing pulse (room_base.gd default: `sin(t*2.5)*0.04 + sin(t*4.3)*0.02`). Should feel like breathing, not mechanical.

## Lighting Design Notes

- **Two-light contrast:** Cold moonlight (blue) vs warm gas lamp (amber). The player starts near the warm lamp and walks toward the cold mansion. Warmth → cold. Safety → danger.
- **No ambient fill:** Exterior has no ceiling bounce. Dark areas are genuinely dark.
- **Tree shadows:** Moonlight through bare winter trees creates skeletal shadow patterns on the ground. This is the first visual hook.
- **Mansion facade:** The mansion building (at Z=10+) is lit only by moonlight. It should be a dark silhouette with one or two lit windows (implied by the foyer chandelier inside).
