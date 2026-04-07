# Front Steps

**Room ID:** `front_steps`  
**Floor:** Grounds (threshold exterior)

---

## Narrative Purpose

`front_steps` is the final exterior commitment beat before the foyer.

It should communicate:
- the mansion facade now surrounds the player
- the front door is a real threshold, not a cutscene seam
- the house is actively letting the player closer

## Tableau Thesis

The player climbs out of the hedge-lined drive into a shallow forecourt with statuary, lamps, and the open front door ahead. This is where exterior ceremony turns into interior trespass.

What the frame should do:
- pull the eye to the warm front doorway
- use statuary and lamps as flanking emphasis
- let the player feel the step-up in class and danger

## Runtime Role

- compiled world: `entrance_path_world`
- neighbors: `drive_upper`, `foyer`
- movement type:
  - `drive_upper -> front_steps`: seamless same-world path traversal
  - `front_steps -> foyer`: inter-world doorway threshold into `manor_interior_world`

## Current Interactions

- `front_steps_door`
- `front_steps_lamp`
