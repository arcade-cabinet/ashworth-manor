# Master Script — Ashworth Manor

The complete narrative experience, start to finish. Every line the player reads, every observation, every conditional variant, every flashback. Indexed by room in play order.

This document is the **spine**. Each room directory (`docs/rooms/{room}/`) contains the full detail. This script tells you what happens when, and where to find it.

---

## Horror Character Models (For Flashbacks & Apparitions)

These GLBs are placed in scenes for flashback visions, mirror reflections, and Elizabeth events:

| Model | Path | Use |
|-------|------|-----|
| `doll1.glb` | `assets/attic/storage/` + `assets/horror/models/` | Elizabeth's porcelain doll — central to binding ritual |
| `doll2.glb` | `assets/attic/hidden_chamber/` + `assets/horror/models/` | Alternate doll — cracked, used in ritual circle |
| `bloodwraith.glb` | `assets/horror/models/` | Elizabeth's spectral form — mirror apparitions, ending visions |
| `plague_doctor.glb` | `assets/horror/models/` | The occultist Lord Ashworth consulted — library flashback |
| `Flesh.glb` | `assets/horror/models/` | Corrupted form — deep basement presence, what Elizabeth almost became |
| `Flesh2.glb` | `assets/horror/models/` | Alternate corruption — walls of hidden chamber, "the house is alive" |
| `ritual_artifact.glb` | `assets/attic/hidden_chamber/` | Occult object in ritual circle |
| `ritual_bones.glb` | `assets/attic/hidden_chamber/` | Bones arranged in binding pattern |
| `loose_bones.glb` | `assets/grounds/chapel/` | Scattered remains near chapel |
| `scattered_bones.glb` | `assets/grounds/family_crypt/` | Crypt floor bones |
| Masks (5 variants) | Various rooms | Ritual masks — one per floor, increasingly disturbing |

### Flashback System

Flashbacks are triggered by specific flag combinations. When triggered:
1. Screen dithers to near-white (psx_fade shader)
2. A horror model fades in at a specific position in the room
3. Dialogue text appears (Elizabeth's voice, past events)
4. Model fades out, screen returns to normal
5. Camera shake (shaky-camera-3d, low trauma)

Flashbacks are **one-time events** — flag prevents re-trigger.

---

## Game Phases (LimboAI HSM states)

| Phase | Trigger | Tone | Audio Layer | Elizabeth |
|-------|---------|------|-------------|-----------|
| **Exploration** | Game start | Curiosity | Base ambient only | Absent |
| **Discovery** | `found_first_clue` (parlor diary) | Unease | Base + subtle tension | Dormant (mirrors slightly off) |
| **Horror** | `entered_attic` | Dread | Tension prominent | Active (appears in mirrors, whispers) |
| **Resolution** | `knows_full_truth` (read final note) | Understanding | Somber, quiet | Waiting (wants to be freed) |

---

## Act I: Arrival (Exploration Phase)

### Room 1: Front Gate → [docs/rooms/front_gate/](./rooms/front_gate/)

Player starts here. December night. The mansion looms.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| First view | Observation | "The iron gate hangs open. Beyond it, Ashworth Manor rises against a moonless sky." |
| Gate examination | Interactable | Rusted hinges, lock broken from inside. "Someone left in a hurry." |
| Path to mansion | Connection | Walk toward front door → Foyer |
| Garden path | Connection | Side path → Garden |
| Luggage | Interactable | Abandoned suitcase. "Packed but never carried beyond the gate." |
| Bench | Interactable | Cold stone bench. "Snow has settled in the seat. No one has sat here in decades." |

**Flashback:** None (too early)
**Items:** None
**Atmosphere:** Wind, distant owl, creaking gate

---

### Room 2: Foyer → [docs/rooms/foyer/](./rooms/foyer/)

The grand entrance. First impression of wealth and wrongness.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Entry observation | Event | Room name display. The silence hits. No clock ticking. |
| Lord Ashworth portrait | Interactable | "Hollow eyes... hand on 'Rites of Passage'" — introduces patriarch |
| Entry mirror | Interactable | "Your reflection moved independently" — first supernatural hint |
| Grandfather clock | Interactable | "3:33. Pendulum motionless." — establishes frozen moment |
| Light switch | Interactable | Toggles chandelier — player agency |
| → Parlor | Connection | North door |
| → Dining Room | Connection | East door |
| → Kitchen | Connection | West door |
| → Upper Hallway | Connection | Grand staircase up |

**Conditional text (foyer_mirror):**
- Default: "Your reflection stares back. For a moment, you could swear it moved independently."
- After `elizabeth_aware`: "Your reflection stares back. It moved independently. You're sure of it this time."
- After `found_hidden_chamber`: "Behind your reflection — a girl in white. When you blink, she's gone."

**Flashback:** None yet
**Items:** None
**Atmosphere:** Chandelier warm glow, cold moonlight through window, marble echo

---

### Room 3: Parlor → [docs/rooms/parlor/](./rooms/parlor/)

Lady Ashworth's domain. First major clue.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Entry | Event | Fire crackling low. Embers dying. |
| Lady Ashworth portrait | Interactable | "Mourning dress before any deaths. Prescient or cursed?" |
| **Torn diary page** | Interactable | **FIRST MAJOR CLUE.** "Whispers from the attic... she still calls to them at night." Sets `found_first_clue`, `knows_attic_girl` |
| Music box | Interactable | "Mechanism is jammed." (Later plays on its own after `elizabeth_aware`) |
| → Foyer | Connection | South door |

**Conditional text (music_box):**
- Default: "A delicate music box with a dancing ballerina. It doesn't play when opened — the mechanism is jammed."
- After `elizabeth_aware` + visited `attic_storage`: "The music box begins to play on its own. A lullaby you've never heard before."

**Phase transition:** Reading diary page → `found_first_clue` → **Exploration → Discovery**
**Flashback:** After `elizabeth_aware`, re-entering parlor: brief vision of a child sitting by the fire (bloodwraith model, semi-transparent, seated position). Text: "She used to sit here. Before they took her upstairs."
**Items:** None
**Atmosphere:** Dying fireplace, arsenic green walls, intimate

---

### Room 4: Dining Room → [docs/rooms/dining_room/](./rooms/dining_room/)

The last supper. Three guests died within the week.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Dinner party photo | Interactable | "Three of these guests would be dead within the week." |
| Pushed chair | Observation | "One chair pushed back. Someone left quickly — or was pulled." |
| Wine glass | Interactable | "Dried residue. Not wine. Too dark." |
| Place settings | Observation | "Set for eight. Only five chairs have been sat in." |
| Table candles | Interactable | "Wax pooled and hardened mid-drip. Time stopped here too." |
| → Foyer | Connection | West door |

**Conditional text (dinner_photo):**
- Default: "A formal dinner photograph. Stiff poses, forced smiles. Three of these guests would be dead within the week."
- After `read_maintenance_log`: "You recognize the dining room in the photo. The table is set identically. As if waiting for the guests to return."

**Flashback:** After `knows_full_truth`: Vision of seated figures at the table, frozen mid-meal. All faces scratched out. Text: "December 24th, 1891. The last supper. No one finished their wine."
**Items:** None
**Atmosphere:** Chandelier overhead, candles guttered, formal death

---

### Room 5: Kitchen → [docs/rooms/kitchen/](./rooms/kitchen/)

The servant's truth. The cook knew.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Cook's note | Interactable | "Master has forbidden anyone from the attic. Says the rats have grown too bold. But I've heard no rats that whisper names..." |
| Pot on stove | Observation | "Empty. The bottom is burned black. Someone walked away mid-cooking." |
| Knife on cutting board | Observation | "Vegetables half-chopped. Desiccated. December 1891 produce." |
| Hearth | Interactable | "Cold ashes. The last fire died over a century ago." |
| → Foyer | Connection | East door |
| → Storage Basement | Connection | Stairs down |

**Flashback:** None (servant spaces are grounded, real, no supernatural overlay)
**Items:** None
**Atmosphere:** Utilitarian, cold, stone floor echo

---

## Act II: Investigation (Discovery Phase)

### Room 6: Upper Hallway → [docs/rooms/hallway/](./rooms/hallway/)

The spine of the upper floor. The locked attic door.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Entry | Event | Floorboard creak. "The hallway stretches into shadow." |
| Children's painting | Interactable | "Three children in white. But the household had four." |
| **Locked attic door** | Interactable | "The door is locked. Heavy iron lock, cold to the touch." Sets `knows_attic_locked` |
| Light switch | Interactable | Toggles hallway sconces |
| → Foyer | Connection | Stairs down |
| → Master Bedroom | Connection | Door |
| → Library | Connection | Door |
| → Guest Room | Connection | Door |
| → Attic | Connection | Locked door (requires `attic_key`) |

**Conditional text (attic_door):**
- No key: "The door is locked. You need a key."
- After `knows_key_location`: "The attic door. The diary said the key is in the library globe."
- Has `attic_key`: Door unlocks. "The old lock clicks open. Stale air rushes past you."

**Flashback:** After `elizabeth_aware`: Sound of a child crying, distant, behind the attic door. No visual. Text: "Sobbing. Through the walls. Just like the diary described."
**Items:** None
**Atmosphere:** Dark carpet runner, dim sconces, anticipation

---

### Room 7: Master Bedroom → [docs/rooms/master_bedroom/](./rooms/master_bedroom/)

Lord Ashworth's guilt. The diary that unlocks everything.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Lord's diary** | Interactable | **CRITICAL CLUE.** "She won't stop crying... attic key hidden in library globe... No one must find her." Sets `read_ashworth_diary`, `knows_key_location` |
| Mirror | Interactable | Slightly tarnished. "Your reflection is a fraction of a second late." |
| **Jewelry box** | Interactable | Locked. Requires `jewelry_key` from crypt. Contains Elizabeth's locket. |
| Unmade bed | Observation | "Unmade on one side only. Lady Ashworth's side is pristine." |
| Book on nightstand | Observation | "Open to a page about 'childhood afflictions of the mind.' Underlined: 'confinement is the only cure.'" |
| Wardrobe | Interactable | "Ajar. Men's clothing on the left, women's on the right. The women's side has a mourning dress hanging at the front." |
| → Upper Hallway | Connection | Door |

**Conditional text (mirror):**
- Default: "Your reflection stares back from tarnished glass. Was it always a fraction of a second late?"
- After `entered_attic`: "In the mirror — movement behind you. You spin. Nothing. But the mirror shows an empty room for one beat too long before matching reality."

**Flashback:** After `read_elizabeth_letter`: Vision of Lord Ashworth sitting on the bed, head in hands. plague_doctor model standing behind him. Text: "The occultist promised it would stop. That the binding would make her quiet. It didn't."
**Items:** Elizabeth's locket (from jewelry box, after `jewelry_key`)
**Atmosphere:** Prussian blue walls, intimate gloom, guilt-heavy

---

### Room 8: Library → [docs/rooms/library/](./rooms/library/)

Knowledge corrupted. The key. The binding ritual.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Globe** | Interactable | "Inside the hollow globe, you find an old brass key labeled 'ATTIC'." Gives `attic_key` |
| **Rituals of Binding** | Interactable | "To trap a spirit, one must first give it form. The doll shall be the vessel, the blood the seal, and the attic the prison eternal..." Pickable item: `binding_book` |
| **Family tree** | Interactable | "Four children listed. The fourth name scratched out: E_iza_eth." |
| Bookshelves | Observation | "Occult texts mixed with legitimate scholarship. Someone was desperate for answers." |
| Ancient artifact | Interactable | "A stone tablet covered in symbols you don't recognize. It hums faintly when touched." |
| → Upper Hallway | Connection | Door |

**Conditional text (family_tree):**
- Default: "The family tree shows four children, but the household records only mention three. The fourth name has been scratched out: 'E_iza_eth'."
- After `knows_full_truth`: "Elizabeth Ashworth. You can read her name now, even through the scratches. She existed. They tried to erase her."

**Flashback:** After `has_binding_book`: Vision of plague_doctor figure performing ritual over a doll. Candles flare. Text: "The occultist read the words. The doll's eyes opened. Elizabeth screamed and screamed until she couldn't anymore."
**Items:** `attic_key` (from globe), `binding_book` (pickable after reading)
**Atmosphere:** Dark wood paneling, scholarly shadows, forbidden knowledge

---

### Room 9: Guest Room → [docs/rooms/guest_room/](./rooms/guest_room/)

Helena Pierce. The guest who never left.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Guest ledger | Interactable | "Mrs. Helena Pierce, arriving Nov 3rd 1891. DEPARTED: [blank]." |
| Photo | Interactable | "A woman in traveling clothes, smiling. She has no idea." |
| Luggage | Observation | "Packed and ready to go. The clasps were never opened again." |
| Bed | Observation | "Perfectly made. As if by a maid. But the maids left weeks before Helena." |
| → Upper Hallway | Connection | Door |

**Flashback:** After `elizabeth_aware`: Brief vision of a woman sitting on the bed, looking at the door. Door doesn't open. Text: "Helena called for help every night. No one came. By the third night, she stopped calling."
**Items:** None
**Atmosphere:** Sparse, simple wallpaper, isolation, another victim

---

## Act II-B: Below (Discovery Phase, optional depth)

### Room 10: Storage Basement → [docs/rooms/storage_basement/](./rooms/storage_basement/)

First descent into darkness. Physical evidence of erasure.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Scratched portrait** | Interactable | "A family portrait. The youngest child's face has been scratched out." Sets `knows_fourth_child_erased` |
| Old mirror | Interactable | "Cracked. Your reflection is fractured into pieces. Each piece shows you at a slightly different angle." |
| Covered furniture | Observation | "Dust cloths over shapes. These things were hidden, not stored." |
| Trunk | Interactable | "Locked. No visible keyhole — sealed with something else." |
| → Kitchen | Connection | Stairs up |
| → Boiler Room | Connection | Door east |
| → Wine Cellar | Connection | Ladder down |

**Flashback:** None (but the scratched portrait is violent enough without supernatural overlay)
**Items:** None
**Atmosphere:** First real darkness, single candle, stone echo, dripping

---

### Room 11: Boiler Room → [docs/rooms/boiler_room/](./rooms/boiler_room/)

Industrial menace. The house itself is wrong.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Maintenance log** | Interactable | "Dec 15, 1891 — Strange sounds from the pipes. Staff refuse to come down after dark. Something is wrong with this house." |
| Industrial clock | Interactable | "3:33. Even here." Sets `examined_boiler_clock` |
| Boiler | Observation | "Massive iron boiler. Still warm? Impossible. Unless someone fed it recently." |
| Pipes | Observation | "They run everywhere. Up through the walls. To every room. Carrying... what?" |
| Mask on wall | Interactable | "A metallic mask hanging on a nail. The expression is frozen in a scream." |
| → Storage Basement | Connection | Door west |

**Conditional text (pipes):**
- Default: "Pipes snake across the ceiling and into the walls. They carry heat — or carried it, once."
- After `elizabeth_aware`: "The pipes groan. For a moment, you hear words in the groaning. Your name? No. Hers."

**Flashback (timed event):** After 30 seconds + `elizabeth_aware`: Whisper through pipes. No visual. Text: "Was that... a voice? In the pipes?"
**Items:** None
**Atmosphere:** Industrial glow, metal grate floor, pipe groans, oppressive

---

### Room 12: Wine Cellar → [docs/rooms/wine_cellar/](./rooms/wine_cellar/)

The deepest darkness (until the attic). Isolation.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Wine inventory note | Interactable | "The 1872 Bordeaux moved to the hidden alcove. The key is with the portrait." |
| **Locked box** | Interactable | Requires `cellar_key` (from carriage_house portrait). Contains `mothers_confession` |
| Wine racks | Observation | "Most bottles covered in dust. A few gaps where bottles were recently removed. Recently?" |
| Footprints | Observation | "Footprints in the dust lead to the wall. And stop." |
| → Storage Basement | Connection | Ladder up |

**Conditional text (wine_box, locked):**
- No key: "A wooden chest, bound with iron. Heavy padlock. The inventory note mentioned 'the key is with the portrait' — but which portrait?"
- After examining foyer portrait: "You tried the foyer portrait. Nothing behind it. There must be another portrait somewhere."

**Flashback (timed, 60s):** After `elizabeth_aware`: Torch gutters. Something passed between you and the flame. Text: "The torch guttered. As if something passed between you and the flame."
**Items:** `mothers_confession` (Lady Ashworth's letter, from locked box)
**Atmosphere:** Near silence, torch flicker, cold stone, weight of house above

---

## Act II-C: Grounds (Discovery Phase, exploration)

### Room 13: Garden → [docs/rooms/garden/](./rooms/garden/)

The grounds. Dead winter garden. Elizabeth's life force.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Fountain | Observation | "Frozen solid. The stone angel weeping icicles." |
| Dead flower beds | Observation | "Everything died decades ago. Except—" |
| **One living white lily** | Interactable | "A single white lily, impossibly alive in December frost. The soil around it is warm." |
| Gazebo | Observation | "Bare lattice. In summer this would be beautiful. Now it's a cage of dead vines." |
| → Front Gate | Connection | Path |
| → Chapel | Connection | Path |
| → Greenhouse | Connection | Path |

**Conditional text (white_lily):**
- Default: "A single white lily. Alive. In December. The soil around it is warm to the touch."
- After `knows_attic_girl`: "Elizabeth's flower. She tended it from the attic window. It kept growing even after she couldn't."

**Flashback:** None (exterior spaces stay grounded)
**Items:** None
**Atmosphere:** Wind, dead winter, cold moonlight, that one living flower

---

### Room 14: Chapel → [docs/rooms/chapel/](./rooms/chapel/)

Sacred ground. The purification component.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Baptismal font** | Interactable | "Water that hasn't frozen despite the December cold." Gives `blessed_water` |
| Altar | Observation | "Bare. Stripped of any religious ornament. Someone removed everything." |
| Pews | Observation | "Overturned. Not by time — by force." |
| Loose bones | Observation | "Scattered near the entrance. Animal? You hope." |
| Stained glass | Interactable | "Fragments of a saint's face. Deliberately smashed from inside." |
| → Garden | Connection | Path |

**Conditional text (baptismal_font):**
- Default: "A stone baptismal font. The water inside hasn't frozen, despite everything. It feels impossibly cold in your hands."
- After `knows_binding_ritual`: "Purification water. The opposite of what they used on Elizabeth. She was never baptized — her father believed that's what gave her the sight."

**Flashback:** None
**Items:** `blessed_water`
**Atmosphere:** Desecrated, cold, broken holy ground

---

### Room 15: Greenhouse → [docs/rooms/greenhouse/](./rooms/greenhouse/)

Glass and growth. The gate key.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Terra cotta pot** | Interactable | Next to another white lily. "Behind the pot, pushed into the soil — an iron key." Gives `gate_key` |
| Dead plants | Observation | "Everything dead except the lilies. Elizabeth's touch." |
| Broken glass panes | Observation | "Several panels shattered. From inside — something pushed out." |
| → Garden | Connection | Path |

**Conditional text (terra_cotta_pot):**
- Default: "A terra cotta pot with a white lily. Identical to the one in the garden. Behind the pot, pushed into the soil, you find an iron key. It's warm."
- After `knows_attic_girl`: "Another of Elizabeth's lilies. She kept growing them even after death. The key was hers — she wanted it found."

**Items:** `gate_key` (opens crypt)
**Atmosphere:** Glass and frost, dead growth, Elizabeth's warmth in the lilies

---

### Room 16: Carriage House → [docs/rooms/carriage_house/](./rooms/carriage_house/)

Storage shed. The duplicate portrait. The cellar key.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Duplicate Lord Ashworth portrait** | Interactable | "A second portrait of Lord Ashworth, stored here. Behind the backing, taped to the frame — a small iron key." Gives `cellar_key` |
| Old mattress | Observation | "Someone slept here. Not in the house — here. A servant who refused to sleep inside?" |
| Wooden boards | Observation | "Boards with nails. Used to seal something. Windows? Doors?" |
| → Front Gate | Connection | Path |

**Conditional text (carriage_portrait):**
- Default: "Another portrait of Lord Ashworth. Why store a duplicate out here? Behind the backing, taped to the frame, you find a small iron key."
- After reading wine inventory note: "'The key is with the portrait.' This is what they meant — not the one in the foyer."

**Items:** `cellar_key` (opens wine cellar box)
**Atmosphere:** Drafty, utilitarian, servant's quarters

---

### Room 17: Family Crypt → [docs/rooms/family_crypt/](./rooms/family_crypt/)

The dead Ashworths. The jewelry key.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Crypt gate | Interactable | Locked. Requires `gate_key`. |
| Graves | Observation | "Edmund Ashworth. Victoria Ashworth. No dates of death. No grave for Elizabeth." |
| **Lady's note** | Interactable | "I hid the locket key here because I cannot bear to see her face." |
| **Loose flagstone** | Interactable | "Beneath the flagstone — a tiny brass key with a heart-shaped bow." Gives `jewelry_key` |
| Scattered bones | Observation | "Not in the graves. Outside them. Disturbed." |
| → Garden | Connection | Path (requires `gate_key`) |

**Conditional text (graves):**
- Default: "Three headstones. Edmund. Victoria. And one blank, weathered stone. No grave for a fourth child."
- After `knows_full_truth`: "Edmund. Victoria. They buried themselves here but left no room for Elizabeth. There was never going to be a grave for her."

**Flashback:** After `knows_full_truth`: Vision of Lady Ashworth kneeling at the blank stone, placing flowers. Text: "Victoria came here every night. She mourned a daughter she helped imprison. The flowers never lasted."
**Items:** `jewelry_key` (opens master bedroom jewelry box)
**Atmosphere:** Open sky, cold stone, drystone walls, death

---

## Act III: Horror (Horror Phase)

### Room 18: Attic Stairwell → [docs/rooms/attic_stairwell/](./rooms/attic_stairwell/)

Crossing the threshold. Phase transition.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Entry | Event | Sets `entered_attic`, `elizabeth_aware`. **Phase: Discovery → Horror.** |
| Stairs creak | Event | Individual creak sounds on each step |
| Distant whisper | Event | One-time. "...find me..." |
| Gravel/debris | Observation | "The stairs haven't been used in decades. Your footsteps are the first." |
| → Upper Hallway | Connection | Stairs down |
| → Attic Storage | Connection | Door forward |

**This room IS a flashback.** The entire ascent is loaded with sensory dread. No jump scares — just the weight of climbing toward something that's been waiting.
**Items:** None
**Atmosphere:** Cold draft, thin moonlight, each step louder

---

### Room 19: Attic Storage → [docs/rooms/attic_storage/](./rooms/attic_storage/)

Elizabeth's prison. The truth begins.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| **Elizabeth's portrait** | Interactable | "A young girl in white. Eyes painted over in black. Plaque: 'Elizabeth Ashworth, 1880-1889. Beloved daughter. Forgotten by none.'" |
| **Porcelain doll** | Interactable | Multi-step: First tap = "SHE NEVER LEFT". Second tap (after reading letter) = hidden key extracted. Gives `hidden_key`. Then doll becomes pickable (`porcelain_doll`). |
| **Elizabeth's unsent letter** | Interactable | "Dearest Mother... They say I'm sick but I feel fine... The doll talks to me now..." Sets `read_elizabeth_letter` |
| **Hidden door** | Interactable | Behind old furniture. "A door, almost invisible. The lock is shaped like an open hand." Requires `hidden_key`. |
| Trunk | Observation | "Elizabeth's belongings. Clothes for a 9-year-old, folded neatly by someone who cared." |
| Window | Observation | "The window faces the garden. You can see the lily from here." |
| → Attic Stairwell | Connection | Door back |
| → Hidden Chamber | Connection | Hidden door (requires `hidden_key`) |

**Flashback:** On examining Elizabeth's portrait: Brief vision of Elizabeth (bloodwraith, child-sized) standing where the portrait hangs, looking at the player. Text: "She painted this herself. The eyes were the last thing she added. She said she couldn't see anymore."

**Items:** `hidden_key` (from doll), `porcelain_doll` (pickable after key extracted)
**Atmosphere:** Moonlight through dirty window, dust motes, wind through rafters, scratching sounds

---

### Room 20: Hidden Chamber → [docs/rooms/hidden_chamber/](./rooms/hidden_chamber/)

The darkest room. Elizabeth's inner sanctum. The ending.

| Moment | Type | Content Summary |
|--------|------|-----------------|
| Entry | Event | "You found me." Sets `found_hidden_chamber`, `knows_full_truth`. **Phase: Horror → Resolution.** |
| **Elizabeth's final words** | Interactable | "I was never sick — they were afraid of what I could see. The house has eyes. The walls have ears. And now I am part of it forever. Find me. Free me. Or join me." Sets `read_final_note` |
| Drawings on walls | Observation | "Hundreds of drawings. The same girl, over and over. Black eyes. The doll. The house. 'THEY MADE ME THIS.' 'IT SEES EVERYTHING.'" |
| Mirror | Interactable | "In the mirror, behind you, stands a girl in white. When you turn, nothing is there." |
| **Ritual circle** | Interactable | Center of room. Where the counter-ritual is performed (type: `ritual`). |
| Candles | Observation | "Two candles. Lit? Impossible. But burning." |
| → Attic Storage | Connection | Door back |

**Counter-Ritual Sequence (at ritual circle):**
1. Place porcelain doll → "The candles flicker."
2. Pour blessed water → "The drawings on the walls seem to shift."
3. Read binding book → "Elizabeth Ashworth. Born in light. Free."
   - Doll cracks open. Light pours out.
   - Drawings fade.
   - Candles blaze then extinguish.
   - Silence.
   - "Thank you."
   - → **Freedom Ending**

**Items:** None (but ritual components are USED here)
**Atmosphere:** Darkest room (0.9), near-blindness, two candles, drawings everywhere, presence

---

## Endings

### Freedom Ending
Trigger: `freed_elizabeth` (counter-ritual complete)
```
The doll cracks open. Light pours from inside.
The drawings on the walls fade.
Elizabeth's voice: "Thank you."
For the first time, dawn light touches Ashworth Manor.
December 25th, 1891. Christmas Morning.
```

### Escape Ending
Trigger: Exit to front gate with `knows_full_truth` but NOT `freed_elizabeth`
```
You push through the front door into the cold night.
Every window in the mansion is now lit.
A silhouette in every frame. Elizabeth.
The compulsion to return is already building.
You came back.
```

### Joined Ending
Trigger: Exit to front gate with `elizabeth_aware` but NOT `knows_full_truth`
```
The front door won't open. Every door — sealed.
The clock ticks to 3:34 AM.
In every mirror: Elizabeth. Smiling.
"Welcome home."
Two silhouettes in the attic window now.
```

---

## Room Directory Template

Each `docs/rooms/{room}/` contains:

| File | Content |
|------|---------|
| `README.md` | Overview, narrative purpose, atmosphere summary |
| `floorplan.md` | ASCII layout with exact grid positions of walls, floors, ceilings, furniture, interactables |
| `interactables.md` | Every object: ID, type, position, all conditional text variants, flags set, items given |
| `dialogue.md` | Complete `.dialogue` file content for this room — every line, every condition |
| `lighting.md` | Every light: type, position, color, energy, range, flickering config, shadow |
| `connections.md` | Every exit: direction, target room, type, position, lock state, key_id |
| `triggers.md` | Entry events, timed events, conditional events, flashbacks, phase transitions |
| `props.md` | Non-interactable furniture and decor: GLB paths, positions, scales |
