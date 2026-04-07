# Front Gate

**Room ID:** `front_gate`
**Floor:** Grounds (exterior)
**Starting Room:** Yes — player begins here on New Game

---

## Narrative Purpose

The front gate is the player's first and last threshold at Ashworth Manor. It establishes:
- **Threshold** — the player stands at the broken estate boundary, not yet on the ceremonial drive proper
- **Time** — December night, frozen, moonlit
- **Trespass** — you are not supposed to be here
- **Wrongness** — the gate is open from inside. Someone left in a hurry. Or something pushed out.
- **Commitment** — the hanging sign is the diegetic boot flow: `New Game`, `Load Game`, `Settings`, then the walk through the gates and up the drive

This room also serves as the **ending trigger zone**. Reaching the gate again from the house-side approach is where Ashworth Manor resolves whether the player escapes, joins Elizabeth, or walks free after the ritual.

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
| Boundary Size | 18 x 6 x 18 |
| Footstep Surface | gravel (path), grass (off-path) |

**Visual:** This beat is now the threshold itself, not the whole front lawn. Gate pillars, fence runs, bent iron leaves, sign boards, one burning lamp, and the first flagstones of the drive create a compressed prologue tableau. The player should feel the drive continuing beyond the gate, but the mansion proper belongs to later beats: `drive_lower`, `drive_upper`, and `front_steps`.

The front approach should be occluded enough that the player does not casually
see beyond the estate boundary. Hedges, side walls, gate runs, and tree masses
should imply a much larger property than the first room can literally show.

**Audio:** Wind through bare branches. Distant owl. Gate creaking on hinges (intermittent). Gravel crunch underfoot. Dead silence between gusts.

**Tone:** You are small. You are late. Everything important already happened. The house is waiting.
