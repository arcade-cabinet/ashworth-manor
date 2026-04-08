# Elder Route Clue Topology

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This document records the specific clue chain, room biases, and
> blackout/rupture grammar for the Elder route. It supplements GAME_BIBLE
> Section "Route Program > Elder Route."

---

## Route Signature

- Continuity that should have ended
- Burial turned into household routine
- Caretaking residue and altered family memory
- Elizabeth lived into old age and still was never released

---

## Clue Types

| Type | Description | Example |
|------|-------------|---------|
| Burial records | Evidence that the family kept trying to settle Elizabeth into death and failed | crypt graves, parish notes, recut dates |
| Caretaker residue | Signs the house was maintained around an ongoing private obligation | foyer mail, attic service notes, polished brass in cellar |
| Altered memory | Portraits, mirrors, and notices that preserve the wrong age | foyer mirror, upper hallway portrait |
| Preserved objects | Things kept serviceable beyond reason | wine box, lantern hook, memorial candles |

---

## Room-by-Room Clue Map

### Foyer / Great Hall (Dominant — First Elder Signal)

The Elder route begins by reframing the house as a maintained memorial rather
than a family residence.

| Interactable | Elder Bias |
|-------------|------------|
| Lord's portrait (`foyer_painting`) | Edmund no longer reads as patriarch or occultist. He reads as the first keeper of a household that became a mausoleum, with smoke-darkened varnish and years of ritual maintenance baked into the hall. |
| Mirror (`foyer_mirror`) | The mirror keeps the wrong age. It reflects a version of the player already worn down by repetition, signaling that the house preserves not just faces but the last years laid over them. |
| Unopened mail (`foyer_mail`) | The correspondence shifts from society and debt into lamp oil, masonry, parish memorials, and upkeep. The house stopped being a family seat and became an institution of private maintenance. |
| First-entry chandelier response | The hall's answering light is not a welcome. It is a memorial lamp. The foyer should feel ceremonially reactivated, not hospitable. |

### Upper Hallway (Dominant — Altered Memory)

The upper hallway should tell the player that Elizabeth did not remain a hidden
child or only a denied adult. The house kept aging her in place.

| Interactable | Elder Bias |
|-------------|------------|
| Children's portrait (`children_painting`) | The missing fifth child has been repainted repeatedly until the face no longer belongs in a children's portrait at all. The painting has become a record of years passing overhead. |
| Hallway notice (`hallway_poster`) | The attic notice accumulates service annotations and caretaker instructions across multiple years. The route shifts from prohibition to recurring household duty. |
| Theatrical mask (`hallway_mask`) | Secondary support only. In Elder, the mask should feel less playful or invasive and more like an object that has stayed on the wall long enough to absorb the same vigils as the hall. |

### Guest Room (Supporting — Outside Witness)

The guest room is where outside social reality confirms that the house had
already become a place of preservation and stalled departure.

| Interactable | Elder Bias |
|-------------|------------|
| Helena surfaces (`guest_ledger`, `helena_photo`, `guest_bed`) | Helena reads as a witness to a household still performing readiness and service long after ordinary domestic life ended. Her room is "kept," not lived in. |

### Attic Stairs / Attic Threshold (Rupture Point, Not Final Answer)

In the Elder route, the attic is important because it breaks midgame certainty,
not because it resolves the truth directly.

| Surface | Elder Bias |
|--------|------------|
| Stairwell wall and debris | Maintenance and damage are cumulative, not singular. The attic threshold should feel like a place serviced, watched, and feared over years. |
| Lantern hook bracket | The hook belongs to caretaker labor and late-house routine. It should read as a service object preserved because the household needed it long after any respectable explanation remained. |
| Route meaning | The attic is where the player loses stable house-light certainty and is redirected downward. It is the rupture point. |

### Wine Cellar (Dominant — Lateral Preservation Layer)

The wine cellar is no longer only a secret-keeping room. In Elder it becomes a
room of repeated care and preservation.

| Interactable | Elder Bias |
|-------------|------------|
| Wine box (`wine_box`) | The brass and shelf wear show repeated opening, closing, and wiping. The cellar kept routine for a truth that had aged in the dark. |
| Footprints (`wine_footprints`) | The route toward the wall should read as repeated passage and incomplete return, hinting that the cellar served as a maintained bypass toward burial truth. |
| Racks (`wine_racks`) | Empty clean slots and orderly disturbance should read as long-term management, not a one-time search. |

### Family Crypt (Dominant — Final Truth Space)

The crypt is the Elder route's true chamber. It must read as a place the family
kept trying to finish and never could.

| Interactable | Elder Bias |
|-------------|------------|
| Ashworth graves (`crypt_graves`) | The fifth place has been altered and re-inscribed repeatedly. The family kept trying to make a grave for Elizabeth as she kept outliving every version of it. |
| Loose flagstone (`crypt_flagstone`) | Burial care and concealment meet here. Victoria's private mercy and the family's impossible memorial logic overlap. |
| Bones (`crypt_bones`) | Disturbance in the crypt should read as intentional and repeated, not random desecration. |

---

## Clue Cascade (Player Experience)

The Elder route should become legible in this approximate order:

1. **Foyer** — the manor reads as memorial infrastructure, not simple haunting
2. **Upper hallway** — memory has been repainted and annotated across years
3. **Guest room** — outside witness confirms the house stayed "ready" too long
4. **Attic threshold** — the player realizes the attic is the rupture point, not the answer
5. **Wine cellar** — preservation becomes practical and repeated
6. **Family crypt** — burial truth lands as continuity that never concluded

By the time the player reaches the crypt, the idea that Elizabeth lived into
old age should feel inevitable, not like a twist.

---

## Late Transition Grammar

The Elder route must diverge from Adult in how it uses darkness and the attic:

- **Adult**
  - late darkness is the last threshold before attic truth
  - the lantern hook is acquired to complete attic resolution
  - the attic remains the answer

- **Elder**
  - late darkness is a stripping-away of midgame certainty
  - the attic functions as rupture and redirection
  - lantern-on-hook grammar belongs to descent, maintenance, and burial-side
    navigation
  - the final answer lies below, not above

The blackout should therefore feel less like revelation-through-illumination and
more like the house forcing the player into the same maintained burial path the
caretakers used.

---

## State Tracking

| Flag / State | Meaning |
|-------------|---------|
| `elizabeth_route = elder` | Active second-route identity |
| `late_darkness_active` | Midgame stable-light collapse is underway |
| `lantern_hook_phase` | Walking-stick certainty has been replaced by late-route descent grammar |
| `elder_clue_pressure` | Optional aggregate pressure state for elder-biased clue density if needed |

---

## Relationship to US-012

This topology feeds directly into the next implementation story:

- the attic becomes rupture, not resolution
- blackout sends the player into burial-side descent
- wine cellar becomes the maintained lateral layer
- family crypt becomes the final chamber
- the music box is found with Elder Elizabeth in the crypt
