# Hidden Chamber

**Room ID:** `hidden_chamber`
**Floor:** Attic (+2)

---

## Narrative Purpose
The darkest room in Ashworth Manor (ambient 0.9). Elizabeth's inner sanctum. Walls covered in her drawings. The final note. The ritual circle. The counter-ritual. The ending.

This room is the DESTINATION of the entire game. Every clue, every key, every document leads here.
The first-entry beat should feel like the house finally admitting the player into a place it was built to conceal.

## Atmosphere
| Property | Value |
|----------|-------|
| Dimensions | 6m x 6m x 3m (small, claustrophobic) |
| Ambient Darkness | 0.9 (DARKEST room) |
| Footstep Surface | `rough_wood` |

**Tone:** Near-blindness. Two candles that shouldn't be lit. Walls covered in a child's desperate drawings. The air is warm. Elizabeth is HERE.

## Spatial Read
- Center: ritual circle and final note
- West wall: dense drawing field and ritual residue
- East wall: mirror threshold and one of the worst masks in the house
- North half: the impossible candle pair
- South side: artifact, bottle, doll, and loose pages from years of isolation

## Runtime Notes

- First entry sets `found_hidden_chamber` and `visited_hidden_chamber`, shows `Hidden Chamber`, delivers the admission text, and plays the reveal stinger.
- `elizabeth_final_note` is thread-variant and always sets both `read_final_note` and `knows_full_truth`.
- `ritual_circle` upgrades to the ready state only when `knows_full_truth`, `binding_book`, and `blessed_water` are all present.
