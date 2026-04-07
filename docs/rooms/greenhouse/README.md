# Greenhouse

**Room ID:** `greenhouse`
**Floor:** Grounds (exterior)

---

## Narrative Purpose
Glass and growth. Contains the gate key (to family crypt) hidden in a terra cotta pot next to another of Elizabeth's white lilies. Broken glass panels — something pushed out from inside.

## Atmosphere
| Property | Value |
|----------|-------|
| Ambient Darkness | 0.4 |
| Is Exterior | true |
| Footstep Surface | `dirt` |

**Tone:** Sickly preservation. A working room for nurture and pruning that has outlived the household and become half mausoleum, half womb.

## Spatial Read
- South: return path to `garden`
- Center: table and lily pot as the room's impossible warm core
- East: potting bench clutter and tools
- North and west: dead growth rows and winter intrusion
- South wall / roofline: burst glass read facing back out toward the garden

## Runtime Shell
- The greenhouse is now treated as a glazed exterior room, not a bare exterior slab.
- Its enclosure is carried by an authored shell scene:
  - `res://scenes/shared/greenhouse/greenhouse_glazed_shell.tscn`
- That shell uses the reusable `Forward+` glass material so the room can actually read as panes, breach, roof glazing, and moonlit enclosure instead of empty darkness.
