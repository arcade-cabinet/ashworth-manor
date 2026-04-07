# Front Gate

**Room ID:** `front_gate`
**Floor:** Grounds (exterior)
**Starting Room:** Yes — player begins here on New Game

---

## Narrative Purpose

The front gate is the player's first and last view of Ashworth Manor. It establishes:
- **Scale** — the mansion looms, dwarfing the player
- **Time** — December night, frozen, moonlit
- **Trespass** — you are not supposed to be here
- **Wrongness** — the gate is open from inside. Someone left in a hurry. Or something pushed out.
- **Commitment** — the hanging sign is the diegetic boot flow: `New Game`, `Load Game`, `Settings`, then the hedge-lined approach toward the manor door

This room also serves as the **ending trigger zone** — exiting back through the gate triggers ending checks (escape, joined, or freedom) based on game state.

The important topology rule is that `front_gate` is only the first beat of the
front approach. It is not "the whole grounds."

Shipped target sequence:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`
- `foyer`

Later side routes should branch from the forecourt/front-steps area, not from
the gate itself.

## Atmosphere

| Property | Value |
|----------|-------|
| Ambient Darkness | 0.3 (moonlit exterior) |
| Audio Loop | "Moonlight Loop1" |
| Is Exterior | true |
| Boundary Size | 26 x 6 x 38 |
| Footstep Surface | gravel (path), grass (off-path) |

**Visual:** Bare winter trees and clipped hedge masses frame the drive like a neglected allée. The threshold itself is visually open, with the gate read coming from its pillars, fence runs, and bent threshold volume rather than a shut slab. Three hanging sign boards at the gate act as the diegetic opening menu before the player walks up the gravel-and-flagstone approach toward the manor facade, shallow steps, and front door. Moonlight casts long shadows, and the visible moon is part of the opening composition. One gas lamp still burns on the left pillar while its twin on the right has gone dark. Two upper windows hold a faint warm glow deep in the house.

The front approach should be occluded enough that the player does not casually
see beyond the estate boundary. Hedges, side walls, gate runs, and tree masses
should imply a much larger property than the first room can literally show.

**Audio:** Wind through bare branches. Distant owl. Gate creaking on hinges (intermittent). Gravel crunch underfoot. Dead silence between gusts.

**Tone:** You are small. You are late. Everything important already happened. The house is waiting.
