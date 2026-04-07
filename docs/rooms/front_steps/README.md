# Front Steps

**Room ID:** `front_steps`  
**Floor:** Grounds (threshold exterior)

---

## Narrative Purpose

`front_steps` is the final exterior commitment beat before the foyer.

It should communicate:
- the mansion facade now surrounds the player
- the front door is a real threshold, not a cutscene seam
- the house is shut and must be opened by the player personally
- the estate is larger than the ceremonial route suggested
- the side world exists, but remains gated on first arrival

## Tableau Thesis

The player climbs out of the hedge-lined drive into a shallow forecourt with statuary, lamps, and the front threshold ahead. Side gates should register in peripheral vision to left and right, hinting at service and garden routes that remain closed on the first arrival.

What the frame should do:
- pull the eye to the front threshold first
- use statuary and lamps as flanking emphasis
- let the player feel the step-up in class and danger
- keep the left/right gates secondary; they are promises, not equal choices yet

## Runtime Role

- compiled world: `entrance_path_world`
- neighbors: `drive_upper`, `foyer`
- movement type:
  - `drive_upper -> front_steps`: seamless same-world path traversal
  - `front_steps -> foyer`: keyed inter-world doorway threshold into `manor_interior_world`

## Current Interactions

- `front_steps_door`
- `front_steps_lamp`
- `front_steps_service_gate`
- `front_steps_garden_gate`

## Estate Reveal Rule

This is the first place where the grounds should reveal their wider topology:

- center: grand stair and front door
- west: service-side gate (locked at first)
- east: garden-side gate (locked at first)

The player should learn this through peripheral vision while naturally walking toward the door, not through a symmetrical choice tableau.
