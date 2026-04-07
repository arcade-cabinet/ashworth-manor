# Adult Route Clue Topology

> **Canonical authority:** [GAME_BIBLE.md](../GAME_BIBLE.md) defines the shipped
> game. This document records the specific clue chain, room biases, and
> content topology for the Adult route. It supplements GAME_BIBLE
> Section "Route Program > Adult Route."

---

## Route Signature

- Stolen adulthood
- Partial erasure from the family record
- Unfinished biography
- Elizabeth lived into adulthood and was denied a full life

---

## Clue Types

| Type | Description | Example |
|------|-------------|---------|
| Letters | Adult correspondence, unsent letters, mature handwriting | Elizabeth's folio in library |
| Portraits | Evidence of aging, repainted faces, adult self-portraits | Attic self-portrait, hallway repainted child |
| Private effects | Adult clothing, personal items, keepsakes | Wardrobe adult dress, parlor writing desk |
| Denied adulthood | Discrepancies in age, medical records shifted to "woman" | Master bedroom diary, library binding book |

---

## Room-by-Room Clue Map

### Parlor (Dominant — First Emotional Fit)

The parlor is where the Adult route first becomes legible. On the Adult
route, the room reads as a space Elizabeth used as a young woman — not
just Lady Ashworth's drawing room.

| Interactable | Adult Bias |
|-------------|------------|
| Lady portrait (`parlor_painting_1`) | Victoria's mourning dress was painted AFTER Elizabeth's confinement. On the Adult route, the portrait reveals Victoria mourning an adult daughter — the black dress predates any death but postdates Elizabeth's twenty-first birthday. |
| Diary page (`parlor_note`) | The diary page is in Lady Ashworth's hand but the margins carry corrections and responses in a second hand — mature, confident, Elizabeth's adult handwriting bleeding through her mother's grief. |
| Music box (`music_box`) | Not a nursery relic. On the Adult route, the music box is Elizabeth's coming-of-age gift — given when she turned eighteen, never opened in company, kept in the parlor where she was last allowed to sit with the family as an adult. |

### Library (Dominant — Strongest Clue Engine)

The library is the Adult route's primary evidence room. Elizabeth read
everything here. Her intellectual life survived confinement.

| Interactable | Adult Bias |
|-------------|------------|
| Bookshelves (`library_shelves`) | Among the occult texts, novels and poetry volumes annotated in a woman's hand. Elizabeth read the library systematically. Her marginalia are literate, critical, adult. |
| Binding book (`binding_book`) | Edmund's annotations shift from "the girl" to "the woman" in later chapters. He noticed she grew up. The margins of the Awakening chapter are annotated in Elizabeth's adult hand. |
| Family tree (`family_tree`) | Elizabeth's name is scratched out but someone has penciled dates beneath the erasure — birth AND a false death date. The handwriting is adult, precise. The dates don't match the family's official story. |
| Globe (`library_globe`) | Elizabeth's fingerprints are worn into the brass around England. She traced the geography of a world she was denied. The compartment mechanism shows wear from adult hands, not a child's. |
| Elizabeth's folio (`elizabeth_papers`) | **NEW.** A folio of Elizabeth's own writings hidden behind a bookcase panel. Not a child's scrawl — mature prose, household observations, fragments of a novel she was writing. Proves adult intellectual life survived confinement. |

### Upper Hallway (Shared — Adult-Biased)

The family circulation space becomes charged with evidence of Elizabeth's
age on the Adult route.

| Interactable | Adult Bias |
|-------------|------------|
| Children's painting (`children_painting`) | The fifth child is not painted over — she has been REPAINTED. Someone aged her face in the portrait, adding years. An adult woman stares out of a children's group. The brushwork is amateur — Elizabeth painted herself older when no one was looking. |
| Notice (`hallway_poster`) | Amended in mature handwriting beneath the original: "I am not ill. I am not a child. I am twenty-three years old." |

### Master Bedroom (Supporting — Patriarchal Guilt)

Lord Ashworth's private space reveals his awareness that Elizabeth grew
up and his refusal to act on it.

| Interactable | Adult Bias |
|-------------|------------|
| Lord's diary (`diary_lord`) | The diary shifts from "the girl" to "she" to "the woman upstairs" across November-December 1891. His final entry: "She is older than her mother was when I married her. God forgive me." |
| Wardrobe (`bedroom_wardrobe`) | Among Lady Ashworth's mourning clothes, a single dress in different proportions — younger, taller. Someone made an adult dress from available fabric and stored it here. Elizabeth's or Victoria's guilt-offering? |
| Medical book (`bedroom_book`) | Not childhood afflictions — the underlined passages concern "prolonged restraint of persons of sound mind." Edmund was reading about adult patients, not children. |
| Mirror (`bedroom_mirror`) | Your reflection ages in the glass. Not older — but it stops being young. The woman staring back has Elizabeth's dark eyes and twenty years you cannot account for. |

### Guest Room (Supporting — Helena as Witness)

Helena Pierce's notes are the outsider's confirmation that Elizabeth was
an adult.

| Interactable | Adult Bias |
|-------------|------------|
| Guest ledger (`guest_ledger`) | Helena writes: "I was told to expect a child. What I found was a young woman — quiet, composed, entirely lucid." Helena knew. She was the only outsider who saw the truth. |

### Foyer (Shared — Public Face)

The foyer carries subtle Adult-route clues in its formal public objects.

| Interactable | Adult Bias |
|-------------|------------|
| Lord's portrait (`foyer_painting`) | On the Adult route, the hollow eyes are not guilt over a sick child. They are the exhaustion of a man who watched his daughter become a woman and maintained the fiction that she was still seven years old. |
| Unopened mail (`foyer_mail`) | Among the letters: one addressed to "Miss Elizabeth Ashworth" in formal correspondence. Someone outside the household knew she was an adult and wrote to her directly. The letter was intercepted. |

### Attic Storage (Dominant — Final Truth Space)

The attic is where the Adult route resolves. Every object here should
confirm Elizabeth's adult life.

| Interactable | Adult Bias |
|-------------|------------|
| Portrait (`elizabeth_portrait`) | Not a childhood portrait — a self-portrait. Elizabeth painted herself as the woman she became, using paints she acquired over years. The face is twenty-three. The technique is practiced. |
| Letter (`elizabeth_letter`) | Written in a confident Victorian hand: "Dear Mama, I am twenty-three today. No one has remembered, though I doubt anyone has forgotten. I have read every book in the library twice." |
| Trunk (`elizabeth_trunk`) | Childhood clothes on top, but underneath: adult garments hemmed and re-hemmed from her childhood wardrobe. She outgrew everything and remade what she had. The needlework is expert. |

---

## Clue Cascade (Player Experience)

The Adult route should be legible through this approximate discovery order:

1. **Parlor** — First hints: diary page with adult handwriting, music box as adult keepsake
2. **Upper hallway** — Confirmation: repainted portrait, amended notice
3. **Master bedroom** — Lord's awareness: diary language shift, adult medical texts
4. **Library** — Full evidence: Elizabeth's annotations, her folio, family tree dates
5. **Guest room** — External witness: Helena's testimony
6. **Attic** — Resolution: self-portrait, adult letter, remade clothing

By the time the player reaches the attic, the truth that Elizabeth
lived into adulthood should feel inevitable, not surprising.

---

## State Tracking

| Flag | Set By | Meaning |
|------|--------|---------|
| `found_elizabeth_papers` | library:elizabeth_papers | Player found Elizabeth's hidden folio |
| `adult_clue_pressure` | Cumulative | Tracks Adult-route clue density for late-game transition |

---

## Relationship to Late Game (US-010)

The clue topology established here feeds directly into the Adult
late-game transition:

- The attic becomes the final truth space (not rupture point)
- The music box is found in the attic
- The winding key from the valise completes Elizabeth's adult story
- The ending meaning: Elizabeth lived into adulthood and was denied a full life
