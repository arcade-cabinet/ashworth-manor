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

**Purpose:** The only warm light in the scene. A beacon. Draws the eye to the gate. The fact that it's still lit after 130+ years is the first wrongness — something is keeping it burning. Its dead twin on the opposite pillar makes the asymmetry feel deliberate and uncanny.

**Flicker pattern:** Slow breathing pulse (room_base.gd default: `sin(t*2.5)*0.04 + sin(t*4.3)*0.02`). Should feel like breathing, not mechanical.

### 3. Mansion Window Glow (Two OmniLight3D fills)

| Property | Value |
|----------|-------|
| Type | OmniLight3D |
| Positions | `(-2.6, 3.1, 13.8)` and `(2.6, 3.1, 13.8)` |
| Color | `(1.0, 0.82, 0.58)` — weak interior amber |
| Energy | `1.4` left, `1.2` right |
| Range | `5.0` |
| Shadows | No |
| Flickering | No |

**Purpose:** Not exterior lighting. These are distant hints that the manor is not fully dead. The windows should read as warmth trapped deep inside the house, not as welcoming beacons.

## Lighting Design Notes

- **Two-light contrast:** Cold moonlight (blue) vs warm gas lamp (amber). The player starts near the warm lamp and walks toward the cold mansion. Warmth → cold. Safety → danger.
- **Asymmetric gate read:** The left pillar still burns; the right pillar has gone black. The gate should feel maintained by a will, not by infrastructure.
- **No ambient fill:** Exterior has no ceiling bounce. Dark areas are genuinely dark.
- **Tree shadows:** Moonlight through bare winter trees creates skeletal shadow patterns on the ground. This is the first visual hook.
- **Mansion facade:** The mansion building (at Z=10+) should read as a shallow silhouette, not a fully explorable exterior build. The moonlight defines the mass; two weak upper-window glows imply interior life without breaking the cold approach. The front door and shallow steps should be readable as a destination even before the player reaches the foyer transition.
- **Foreground anchors:** The statuary should catch enough moonlight to register as human-like forms in peripheral vision without becoming bright focal points. They exist to make the approach feel curated, aristocratic, and faintly accusatory.
