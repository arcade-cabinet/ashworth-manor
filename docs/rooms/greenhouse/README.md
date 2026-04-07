# Greenhouse

**Room ID:** `greenhouse`
**Floor:** Grounds (exterior)

---

## Narrative Purpose
Glass and growth. Contains the gate key (to family crypt) hidden in a terra cotta pot beneath one of Elizabeth's white lilies. Broken glass panels imply that something forced its way out of the enclosure rather than merely being abandoned to weather.

## Atmosphere
| Property | Value |
|----------|-------|
| Ambient Darkness | 0.4 |
| Is Exterior | true |
| Footstep Surface | `dirt` |

**Tone:** Sickly preservation. A working room for nurture and pruning that has outlived the household and become half mausoleum, half womb.

## Spatial Read
- South: return path to [`garden`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/declarations/rooms/garden.tres), framed as a threshold view back out of the estate grounds
- Center / north-center: pedestal, lily, and hanging lantern as the room's impossible warm core
- East: potting bench clutter and tools as the lingering sign of Victoria's tending ritual
- West: dead rows and winter intrusion pressing inward against the living focal bloom
- North roofline: burst-glass breach and cold moon read

## Runtime Shell
- The greenhouse is now treated as a glazed exterior room, not a bare exterior slab.
- Its enclosure is carried by an authored shell scene:
  - [`greenhouse_glazed_shell.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_glazed_shell.tscn)
- The shell uses the reusable `Forward+` greenhouse glass material so the room can actually read as panes, breach, roof glazing, and moonlit enclosure instead of empty darkness.
- The focal cluster is now intentionally scene-authored:
  - [`greenhouse_lily_pedestal.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_lily_pedestal.tscn)
  - [`greenhouse_hanging_lantern.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_hanging_lantern.tscn)
  - [`greenhouse_lily_pot_intact.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_lily_pot_intact.tscn)
  - [`greenhouse_lily_pot_disturbed.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_lily_pot_disturbed.tscn)
