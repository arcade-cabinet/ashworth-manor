# Child Route Clue Topology

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This document records the specific clue chain, room biases, and
> blocked-architecture logic for the `Child` route. It supplements
> `GAME_BIBLE.md` Section "Route Program > Child Route."

---

## Route Signature

- sealed childhood horror
- blocked architecture
- recovered family shame
- a child erased by physically hiding her room inside the estate

---

## Clue Types

| Type | Description | Example |
|------|-------------|---------|
| Nursery traces | Childhood objects that survived suppression | doll wear, child bed, height marks |
| Concealed architecture | Plaster, seams, measurements, altered circulation | attic west wall seam, wall measurements in trunk |
| Household concealment | Records describing the child as a maintenance problem instead of a family member | library binding book, hallway notice |
| Childhood memory intrusion | The player's return sharpened by partial remembered access | upper hallway unease, attic false-answer beat |

---

## Room-by-Room Clue Map

### Upper Hallway (Dominant — First Architectural Pressure)

The upper hall is where the Child route first stops reading as biography and
starts reading as concealment in timber and plaster.

| Interactable | Child Bias |
|-------------|------------|
| Children's painting (`children_painting`) | The family portrait no longer reads as an absent sibling. It reads as someone painted over and then architecturally erased. The text now names an erased child, not a missing woman. |
| Hallway notice (`hallway_poster`) | The notice feels like cover language for house work around a sealed space rather than household caution around a living invalid. |

### Master Bedroom (Supporting — Parents Paid to Hide It)

| Interactable | Child Bias |
|-------------|------------|
| Lord's diary (`diary_lord`) | The diary now surfaces plaster invoices and practical concealment instead of abstract guilt. |
| Mirror (`bedroom_mirror`) | The mirror bias emphasizes a child-scale reflection and the wrong proportions in the room's memory. |

### Library (Dominant — Concealment as Record)

| Interactable | Child Bias |
|-------------|------------|
| Binding book (`binding_book`) | The language turns toward erasing the fact that the child needed a room at all. |
| Globe (`library_globe`) | Physical measures and route marks imply someone was mapping walls from inside and outside, not dreaming of distant escape alone. |
| Family tree (`family_tree`) | The erasure lands as intentional household revision, not just genealogical omission. |

### Guest Room (Supporting — Helena as Outside Witness)

| Interactable | Child Bias |
|-------------|------------|
| Guest ledger (`guest_ledger`) | Helena becomes the outsider who noticed the proportions of the house did not add up and heard a child behind the sealed wall. |

### Attic Storage (Dominant — False Answer / Clue Engine)

The attic should initially tempt the player into believing they have arrived at
the final truth. On the Child route, the attic is where that confidence breaks.

| Interactable | Child Bias |
|-------------|------------|
| Elizabeth portrait (`elizabeth_portrait`) | Hidden rather than destroyed, tied to the room that was sealed beside it. |
| Porcelain doll (`porcelain_doll`) | Comfort object and hiding place, not occult vessel. |
| Elizabeth letter (`elizabeth_letter`) | The letter explicitly references hearing work on the wall from the inside. |
| Trunk (`elizabeth_trunk`) | The trunk keeps childhood layers on top and measurement evidence beneath. |
| Attic music box (`attic_music_box`) | False answer. The melody only echoes; it redirects the player to the west wall. |
| Sealed seam (`sealed_seam`) | The physical reveal object. The attic stops being a chamber of truth and becomes the access puzzle to the real room. |

### Hidden Chamber / Sealed Room (Final Truth Space)

This room is no longer occult residue. It is erased domestic reality.

| Interactable | Child Bias |
|-------------|------------|
| Child music box (`child_music_box`) | Final solve object, wound with the brass key carried from the gate. |
| Nursery drawings (`nursery_drawings`) | Not monster sketches; attempts to draw exits and being remembered. |
| Child bed (`child_bed`) | Confirms the room remained a child's room, not an attic ritual chamber. |
| Height marks (`height_marks`) | The child was measured, watched, and stopped. |
| Nursery mirror (`nursery_mirror`) | The room remembers a child presence, not an adult self-making archive. |

---

## Clue Cascade (Player Experience)

The Child route should become legible in this approximate order:

1. **Upper hallway** — the architecture feels wrong before it feels haunted
2. **Master bedroom** — the parents paid for concealment, not only confinement
3. **Library** — household records describe erasure as administrative necessity
4. **Guest room** — Helena confirms the house dimensions and sounds did not add up
5. **Attic** — the player reaches a false answer and is redirected to the wall
6. **Sealed Room** — the actual childhood truth is reached physically, not symbolically

By the time the player opens the sealed room, the hidden chamber should feel
inevitable.

---

## State Tracking

| Flag / State | Meaning |
|-------------|---------|
| `elizabeth_route = child` | Active third-route identity |
| `child_attic_redirected` | The attic music box has revealed that the attic is only an echo |
| `child_hidden_room_revealed` | The sealed seam has been opened with the hook |
| `hidden_door_unlocked` | The concealed connection is now traversable |

---

## Relationship to US-014

This topology feeds directly into the implemented Child finale:

- the attic initially appears to hold the answer
- the attic music box only echoes and redirects the player
- the sealed seam becomes the architectural reveal
- the hidden room becomes the true final chamber
- the child music box resolves the route there
