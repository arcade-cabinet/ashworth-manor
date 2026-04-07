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
More precisely: this is a winter estate that has gone quiet, not a collapsed ruin.

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

**Purpose:** The only warm light in the scene. A beacon. Draws the eye to the gate. The fact that it is still lit despite the estate's supposed emptiness is enough wrongness; the opening should not depend on overt supernatural behavior.

**Flicker pattern:** restrained gas-lamp turbulence. Gentle, credible, and readable through the glass. Not a haunted breathing effect at this stage.

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

- **Two-light contrast:** Cold twilight / moonlight (blue) vs warm gas lamp (amber). The player starts near the warm lamp and walks toward the colder estate mass. Familiarity → uncertainty.
- **Asymmetric gate read:** One lamp is enough. The threshold should feel lightly tended, not theatrically enchanted.
- **No ambient fill:** Exterior has no ceiling bounce. Dark areas are genuinely dark.
- **Tree shadows:** Moonlight through bare winter trees creates skeletal shadow patterns on the ground. This is the first visual hook.
- **Mansion facade:** The mansion building (at Z=10+) should read as a withheld silhouette, not a fully explained destination. The moonlight defines the mass; a small amount of distant warmth implies interior depth without collapsing the sense of long ceremonial grounds.
- **Foreground anchors:** The statuary should catch enough moonlight to register as human-like forms in peripheral vision without becoming bright focal points. They exist to make the approach feel curated, aristocratic, and faintly accusatory.
