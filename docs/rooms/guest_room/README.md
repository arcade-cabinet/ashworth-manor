# Guest Room

**Room ID:** `guest_room`
**Floor:** Upper (+1)

---

## Narrative Purpose

Helena Pierce's room — the guest who never left. Arrived November 3rd, 1891. Departure date left blank. Her suitcase is still at the front gate.

This is a secondary narrative thread — not required for puzzles but enriches the horror by showing the Ashworths' destruction touched more than just their family.
The first-entry beat should land as another version of the house's habit of preserving people past the point where leaving was still possible.

## Atmosphere

| Property | Value |
|----------|-------|
| Dimensions | 8m x 8m x 2.4m |
| Ambient Darkness | 0.6 |
| Audio Loop | Room-specific (wind, emptiness) |
| Footstep Surface | `wood_parquet` |

**Visual:** Simple wallpaper (wall_3 or wall_1). Simple wood floor (floor1). Simple ceiling (cieling1). Sparse — a guest room, not a family room. Single bed, washstand, luggage, writing desk. Less ornate than the master bedroom. The simplicity makes it feel lonelier.

**Tone:** Isolation. Another victim. Helena came for a weekend and never left. The room is a cage she didn't know she'd entered.

## Spatial Read
- West wall: Helena's desk, ledger, and photograph
- East/north-east: the made bed and half-packed luggage
- South-east: dead lamp and wash items
- North wall: cold window read keeping the room livable and lonely

## Runtime Notes

- First entry sets `visited_guest_room`, shows `Guest Room`, and delivers: "Someone tried to keep this room ready for departure long after departure stopped being possible."
- `guest_ledger` is thread-variant and always sets `read_guest_ledger`.
- `helena_photo` upgrades once `knows_full_truth` is set.
