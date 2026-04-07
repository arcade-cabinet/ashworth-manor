# Front Gate

**Room ID:** `front_gate`
**Floor:** Grounds (exterior)
**Starting Room:** Yes — first embodied room after the solicitor-letter prologue

---

## Narrative Purpose

The front gate is the player's first and last threshold at Ashworth Manor. It establishes:
- **Threshold** — the player stands at the estate boundary, not yet on the ceremonial drive proper
- **Obligation** — the return is legal and familial, not random trespass; that makes the discomfort worse
- **Time** — winter twilight, cold blue sky, long grounds, one warm lamp
- **Wealth** — clipped hedges, masonry, brass, and distance should imply extravagant country-estate scale
- **Commitment** — a freestanding chained sign between timber posts is the diegetic boot flow: `Enter the Grounds`, `Resume the Visit`, `Adjust the House`
- **Wrongness** — nothing supernatural is overt yet, but the estate feels too still and too ready for your arrival

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
| Ambient Darkness | 0.3 (twilight / moonlit exterior) |
| Audio Loop | "Moonlight Loop1" |
| Is Exterior | true |
| Boundary Size | 18 x 6 x 18 |
| Footstep Surface | gravel (path), grass (off-path) |

**Visual:** This beat is now the threshold itself, not the whole front lawn. Gate pillars, fence runs, a freestanding timber-and-brass estate sign, one burning lamp, and the first flagstones of the drive create a compressed prologue tableau. The player should feel the drive continuing beyond the gate, but the mansion proper belongs to later beats: `drive_lower`, `drive_upper`, and `front_steps`.

The front approach should be occluded enough that the player does not casually
see beyond the estate boundary. Hedges, side walls, gate runs, and tree masses
should imply a much larger property than the first room can literally show.

**Audio:** Wind through bare branches. Distant owl. Gate creaking on hinges (intermittent). Gravel crunch underfoot. Dead silence between gusts.

**Tone:** You belong here on paper, but not in your body. The house is not trying to frighten you yet. It is simply standing ready.
