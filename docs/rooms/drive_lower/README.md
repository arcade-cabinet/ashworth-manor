# Lower Drive

**Room ID:** `drive_lower`  
**Floor:** Grounds (exterior)

---

## Narrative Purpose

`drive_lower` is the first real commitment beat after the gate.

It should communicate:
- the drive is controlled, not open lawn
- the hedges are hiding the true extent of the estate
- the player is being funneled, not simply wandering

This is where the front approach stops being menu/threshold and becomes a walk.

## Tableau Thesis

The player stands inside a clipped hedge corridor with gravel and stone underfoot, moonlight above, and only a narrowed glimpse of the upper approach ahead.

What the frame should do:
- keep the eye on the route forward
- avoid exposing the estate edge
- make the player feel enclosed by wealth and discipline

## Runtime Role

- compiled world: `entrance_path_world`
- neighbors: `front_gate`, `drive_upper`
- movement type: seamless same-world path traversal

## Current Interactions

- `drive_lower_path`
- `drive_lower_hedge`
