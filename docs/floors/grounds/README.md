# Grounds (Exterior)

**Theme**: Frozen Threshold, The World Outside
**Ambient Darkness Range**: 0.3 - 0.7
**Access**: Main entrance (Prologue), windows (visual only), endings

---

## Overview

The Grounds of Ashworth Manor surround the house on all sides — a once-formal Victorian estate now frozen in the December night. Snow covers the gravel drive, ice clings to the iron gates, and moonlight reveals what daylight would mercifully obscure: a property that died with its owners.

The Grounds serve three narrative purposes:
1. **PROLOGUE**: The player's first impression — approaching the mansion, seeing the lit attic window
2. **DISCOVERY**: The Chapel contains blessed water (counter-ritual); the Crypt reveals Elizabeth has NO grave
3. **ENDINGS**: All three endings resolve on the grounds — freedom, escape, or entrapment

```
                    GROUNDS LAYOUT (Top View)

                           NORTH
                             ↑
                    ┌────────────────────┐
                    │   FAMILY CRYPT     │
                    │   (stone, iron)    │
                    └────────┬───────────┘
                             │ path
              ┌──────────────┼──────────────┐
              │              │              │
    ┌─────────┴──────┐  ┌───┴────────┐  ┌──┴──────────┐
    │                │  │            │  │             │
    │   CHAPEL       │  │  MANSION   │  │  GREENHOUSE │
    │  (west wing)   │  │  (main)    │  │ (east wing) │
    │                │  │            │  │             │
    └────────────────┘  └───┬────────┘  └─────────────┘
                            │
                    ┌───────┴────────┐
                    │  CARRIAGE      │
                    │  HOUSE         │
                    │  (southwest)   │
                    └───────┬────────┘
                            │ drive
                    ┌───────┴────────┐
                    │  FRONT GATE    │
                    │  & DRIVE       │
                    │  (iron gates)  │
                    └───────┬────────┘
                            │
                         SOUTH
                    (Player arrives)
```

---

## Areas

| Area ID | Name | Dimensions | Position | Access |
|---------|------|------------|----------|--------|
| `front_gate` | Front Gate & Drive | 20x30 | (0, 0, -40) | Game start |
| `chapel` | Estate Chapel | 6x10x5 | (-20, 0, 10) | From grounds path |
| `greenhouse` | Greenhouse | 8x12x4 | (20, 0, 10) | From grounds path |
| `carriage_house` | Carriage House | 10x8x4 | (-15, 0, -25) | From front drive |
| `family_crypt` | Family Crypt | 6x8x3.5 | (0, 0, 30) | Behind mansion, locked gate |

---

## PROLOGUE: The Approach

### Scene: Front Gate & Drive

**The player's first experience of the game.**

```
EXTERIOR — ASHWORTH MANOR — DECEMBER 24TH, 1891 — 3:33 AM

Snow falls gently. The iron gates stand open — they shouldn't be.
A gravel drive leads through overgrown hedges to the mansion.
Every window is dark except one: the attic. A figure appears
briefly in the attic window, then vanishes.

The front door is ajar.
```

#### Environment
- **Iron Gates**: Wrought iron, partially rusted, left open
- **Gravel Drive**: Snow-covered, single set of footprints leading IN (not out)
- **Hedges**: Overgrown box hedges line the drive, shapes distorted
- **Gas Lamps**: Two flanking the gate, one still lit (guttering), one dark
- **Mansion Facade**: Visible ahead — dark windows, columned entrance
- **Attic Window**: Faint warm light visible (only window lit in entire house)
- **Snow**: Gentle snowfall, accumulation on surfaces

#### Lighting
| ID | Type | Position | Color (RGB) | Intensity | Flickering |
|----|------|----------|-------------|-----------|------------|
| `gate_lamp_left` | gas_lamp | (-4, 3, -40) | (1.0, 0.85, 0.5) | 0.4 | Yes (dying) |
| `moonlight_grounds` | directional | above | (0.65, 0.7, 0.85) | 0.3 | No |
| `attic_glow` | point (distant) | (0, 10, 0) | (1.0, 0.7, 0.3) | 0.2 | Yes (candle) |

#### Interactables
```yaml
gate_plaque:
  id: gate_plaque
  type: note
  position: { x: -2, y: 1.5, z: -40 }
  content:
    title: "Gate Plaque"
    text: "ASHWORTH MANOR — Est. 1847"

gate_footprints:
  id: gate_footprints
  type: observation
  position: { x: 0, y: 0, z: -35 }
  content:
    text: "Footprints in the fresh snow. One set, leading in. None leading out."
```

#### Player Path
1. Player spawns at the gate, facing north toward the mansion
2. Tap to walk up the drive
3. Can observe: gate plaque, footprints, gas lamp, attic window
4. Front door is the only way forward
5. Entering the door triggers transition to Foyer

#### Atmosphere
- **Audio**: "Tempest Loop1" — wind, distant, cold
- **Feeling**: Isolation, trespass, being drawn in
- **Temperature**: Cold is palpable (breath visible?)
- **Key Detail**: The footprints go IN but not OUT. Whose are they?

---

## AREA: Estate Chapel

**Room ID**: `chapel`
**Access**: Through west grounds path (from front drive)
**Purpose**: Contains BLESSED WATER (counter-ritual component)

### Overview
A small stone chapel built for the Ashworth family's private worship. The Ashworths presented themselves as devout Anglicans to society, but Lord Ashworth's occult interests corrupted even this sacred space. The font still holds water — whether it remains blessed is uncertain.

### Environment
- **Stone walls**: Rough-cut limestone, no wallpaper
- **Peaked roof**: Exposed beams, small rose window (moonlight through stained glass)
- **Pews**: Four rows, simple wood, dusty
- **Altar**: Stone slab with cross (cross is inverted — subtle, player may miss)
- **Baptismal Font**: Stone basin, still contains water
- **Candles**: Two tall candles flanking altar (unlit)

### Dimensions
| Property | Value |
|----------|-------|
| Width | 6 units |
| Depth | 10 units |
| Height | 5 units |
| World Position | (-20, 0, 10) |

### Materials
| Surface | Texture | Style |
|---------|---------|-------|
| Floor | `stone_dark` | Flagstone, worn |
| Walls | `stone_rough` | Limestone blocks |
| Ceiling | `wood_rough` | Exposed beams |

### Lighting
| ID | Type | Position | Color | Intensity | Flickering |
|----|------|----------|-------|-----------|------------|
| `chapel_moonlight` | window | (0, 4, 8) | (0.5, 0.55, 0.75) | 0.25 | No |

### Interactables
```yaml
baptismal_font:
  id: baptismal_font
  type: box
  position: { x: 0, y: 0.8, z: 6 }
  data:
    locked: false
    itemFound: blessed_water
    content: "The stone font still holds water. Ice crystals have formed on the surface, but beneath, the water is clear and still. You collect some in a small vial."

chapel_cross:
  id: chapel_cross
  type: painting
  position: { x: 0, y: 3, z: 9.5 }
  content:
    title: "The Cross"
    text: "A wooden cross hangs above the altar. Looking closely, you realize it has been mounted upside down. The screws are old — this was done long ago."

chapel_prayer_book:
  id: chapel_prayer_book
  type: note
  position: { x: -2, y: 0.8, z: 4 }
  content:
    title: "Open Prayer Book"
    text: "The Book of Common Prayer lies open to a page about baptism. In the margin, in Lord Ashworth's hand: 'She was never baptized. Perhaps that is why she sees.'"
```

### Narrative Function
- **Blessed water** for counter-ritual
- **Inverted cross** reveals Lord Ashworth's occult corruption of sacred space
- **Prayer book note** connects Elizabeth's "sight" to her unbaptized state
- **Atmosphere**: Sacred space defiled — even God's house couldn't protect this family

### Events
```yaml
event_chapel_first_entry:
  trigger: First entry
  actions:
    - set_flag: visited_chapel
    - show_room_name: "Estate Chapel"
    - ambient_change: chapel_silence

event_collect_blessed_water:
  trigger: Interact with baptismal_font
  conditions:
    - flag_not_set: has_blessed_water
  actions:
    - give_item: blessed_water
    - set_flag: has_blessed_water
    - show_message: "You collect water from the font. It feels impossibly cold."
```

---

## AREA: Greenhouse

**Room ID**: `greenhouse`
**Access**: Through east grounds path
**Purpose**: Environmental storytelling, optional discovery

### Overview
A Victorian glasshouse where Lady Ashworth tended her garden — or so she told society. The glass panels are cracked, snow drifts through gaps, and the plants within have long since died. Among the dead ferns and shriveled roses, one thing survives: a single white lily, impossibly alive in the frozen ruin.

### Environment
- **Glass and iron frame**: Arched structure, many panes broken
- **Plant tables**: Wrought iron, terra cotta pots (plants dead)
- **Central path**: Flagstone, snow-dusted
- **The White Lily**: One living plant in an otherwise dead space
- **Potting bench**: Lady Ashworth's tools, her gardening journal

### Dimensions
| Property | Value |
|----------|-------|
| Width | 8 units |
| Depth | 12 units |
| Height | 4 units |
| World Position | (20, 0, 10) |

### Lighting
| ID | Type | Position | Color | Intensity | Flickering |
|----|------|----------|-------|-----------|------------|
| `greenhouse_moonlight` | directional | above | (0.7, 0.75, 0.85) | 0.35 | No |

### Interactables
```yaml
white_lily:
  id: white_lily
  type: painting
  position: { x: 0, y: 1, z: 6 }
  content:
    title: "The White Lily"
    text: "Among the dead and frozen plants, a single white lily blooms. Its petals are perfect. It should not be alive. The soil around it is warm to the touch."

gardening_journal:
  id: gardening_journal
  type: note
  position: { x: 3, y: 1, z: 2 }
  content:
    title: "Lady Ashworth's Garden Journal"
    text: "June 14th, 1887. Elizabeth asked to plant something today. I gave her a lily bulb for her room. She was so happy. I wonder if I will ever see her happy again. I wonder if I deserve to."
```

### Narrative Function
- **The lily** is Elizabeth's — planted by her, it lives because she does
- **Lady Ashworth's journal** reveals guilt and love mixed together
- **Dead greenhouse** mirrors the family: once alive, now frozen
- **Optional area** — rewards exploration with emotional depth

---

## AREA: Carriage House

**Room ID**: `carriage_house`
**Access**: Southwest of front drive
**Purpose**: Contains CELLAR KEY (behind Lord Ashworth's portrait)

### Overview
The carriage house stored the family's coaches and horses. Now empty of animals, it holds forgotten possessions: old trunks, a carriage with one broken wheel, and — hidden behind a framed portrait of Lord Ashworth stored here — the cellar key.

### Environment
- **Double doors**: Wooden, one hanging open
- **Carriage**: Victorian coach, one wheel broken, covered in dust
- **Tack wall**: Empty horse harnesses, bridles
- **Storage area**: Trunks, crates, old furniture
- **Portrait**: Lord Ashworth's portrait (duplicate, stored here — the "portrait" referenced in wine cellar note)

### Dimensions
| Property | Value |
|----------|-------|
| Width | 10 units |
| Depth | 8 units |
| Height | 4 units |
| World Position | (-15, 0, -25) |

### Lighting
| ID | Type | Position | Color | Intensity | Flickering |
|----|------|----------|-------|-----------|------------|
| `carriage_lantern` | lantern | (-3, 2.5, -2) | (1.0, 0.75, 0.4) | 0.35 | Yes |

### Interactables
```yaml
carriage_portrait:
  id: carriage_portrait
  type: box
  position: { x: 4, y: 1.5, z: 3 }
  data:
    locked: false
    itemFound: cellar_key
    content: "Behind the portrait's backing, taped to the frame, you find a small iron key. This must be the key 'with the portrait' mentioned in the wine cellar inventory."

carriage_trunk:
  id: carriage_trunk
  type: note
  position: { x: -3, y: 0.5, z: 2 }
  content:
    title: "Packed Trunk"
    text: "A trunk packed with children's clothes. Tiny dresses, bonnets, shoes. A tag reads: 'Elizabeth's belongings — to be burned per Lord Ashworth's instruction.' The trunk was never burned."

broken_carriage:
  id: broken_carriage
  type: painting
  position: { x: 0, y: 1.5, z: 0 }
  content:
    title: "The Carriage"
    text: "A fine carriage with one wheel shattered. The Ashworth crest is painted on the door. Inside, the upholstery is torn. Claw marks? No — too small. A child's fingernails, desperate to get out."
```

### Narrative Function
- **CELLAR KEY** found here — solves "key is with the portrait" puzzle
- **Elizabeth's trunk** shows the family tried to erase all evidence
- **Claw marks in carriage** implies Elizabeth was transported to the attic by force
- **Puzzle completion**: Wine cellar note → "key is with the portrait" → search portraits → find behind THIS one

### Events
```yaml
event_find_cellar_key:
  trigger: Interact with carriage_portrait
  conditions:
    - flag_not_set: has_cellar_key
  actions:
    - give_item: cellar_key
    - set_flag: has_cellar_key
    - show_message: "Behind the portrait frame, you find an iron key."
    - play_sound: key_found
```

---

## AREA: Family Crypt

**Room ID**: `family_crypt`
**Access**: Behind mansion, through locked iron gate (gate_key found in greenhouse)
**Purpose**: Reveals Elizabeth's ABSENT grave, contains JEWELRY KEY

### Overview
A small stone mausoleum in the Victorian Gothic style. Iron railings surround it, gate locked. Inside: stone sarcophagi for Lord and Lady Ashworth (empty — they vanished), memorial plaques for the three acknowledged children (who fled), and — conspicuously — NO marker for Elizabeth. She was erased even from death.

### Environment
- **Iron gate**: Locked, ornate, rusted
- **Stone structure**: Gothic arched entrance, carved angels (faces weathered away)
- **Sarcophagi**: Two stone coffins (Lord & Lady) — both empty, lids ajar
- **Wall plaques**: Charles, Margaret, William (memorial only — they survived)
- **Bare wall**: Where a fourth plaque should be — rough stone, never carved
- **Floor**: One flagstone is loose — beneath it, the jewelry key and a note

### Dimensions
| Property | Value |
|----------|-------|
| Width | 6 units |
| Depth | 8 units |
| Height | 3.5 units |
| World Position | (0, 0, 30) |

### Lighting
| ID | Type | Position | Color | Intensity | Flickering |
|----|------|----------|-------|-----------|------------|
| `crypt_moonlight` | window | (0, 3, 5) | (0.5, 0.55, 0.7) | 0.2 | No |

### Interactables
```yaml
empty_sarcophagus_lord:
  id: empty_sarcophagus_lord
  type: painting
  position: { x: -2, y: 0.8, z: 4 }
  content:
    title: "Lord Ashworth's Sarcophagus"
    text: "The stone lid is pushed aside. Empty. 'Edmund Ashworth, 1820-1891' is carved into the rim. Where is the body? He vanished the night everything ended."

empty_sarcophagus_lady:
  id: empty_sarcophagus_lady
  type: painting
  position: { x: 2, y: 0.8, z: 4 }
  content:
    title: "Lady Ashworth's Sarcophagus"
    text: "Also empty. 'Victoria Ashworth, 1825-1891'. Two people who simply ceased to exist. The house took them."

missing_plaque:
  id: missing_plaque
  type: painting
  position: { x: 0, y: 1.8, z: 7 }
  content:
    title: "The Blank Wall"
    text: "Three memorial plaques line the wall: Charles, Margaret, William. But the wall has space for four. The fourth section is bare stone — no plaque was ever carved. Elizabeth was erased even from death."

loose_flagstone:
  id: loose_flagstone
  type: box
  position: { x: 1, y: 0.1, z: 2 }
  data:
    locked: false
    itemFound: jewelry_key
    content: "Beneath the loose flagstone, wrapped in oilcloth, you find a tiny brass key with a heart-shaped bow. A note in Lady Ashworth's hand reads: 'I could not wear it any longer. Forgive me, Elizabeth.'"

crypt_note:
  id: crypt_note
  type: note
  position: { x: 1, y: 0.1, z: 2 }
  content:
    title: "Lady Ashworth's Note"
    text: "I hid the locket key here because I cannot bear to see her face. Every time I open the jewelry box, she looks at me with those knowing eyes. She knows what we did. She always knew."
```

### Narrative Function
- **JEWELRY KEY** found here — opens Lady's jewelry box in Master Bedroom
- **Empty sarcophagi** confirm Lord & Lady vanished (the house consumed them)
- **Missing fourth plaque** is the most powerful single image: Elizabeth erased from death itself
- **Lady's note** reveals guilt — she loved Elizabeth but helped imprison her

### Puzzle Chain
```
Wine Cellar Note: "key is with the portrait"
    → Which portrait? Search all portraits
    → Carriage House: Key behind Lord Ashworth portrait
    → Return to Wine Cellar → Open locked box

Crypt: Loose flagstone
    → Find jewelry key + Lady's note
    → Return to Master Bedroom → Open jewelry box → Find Elizabeth's locket
```

### Access Puzzle
The crypt gate is locked. The GATE KEY is found:
```yaml
gate_key:
  id: gate_key
  location: greenhouse
  hidden_in: "Inside the terra cotta pot next to the white lily"
  hint: "Lady Ashworth tended this garden. She also tended the dead."
```

```yaml
greenhouse_gate_key:
  id: greenhouse_gate_key
  type: box
  position: { x: 1, y: 0.5, z: 6 }
  data:
    locked: false
    itemFound: gate_key
    content: "Inside the pot next to the living lily, buried in dry soil, you find an iron gate key. It is warm, like the soil around the lily."
```

---

## Audio Assignment (Grounds)

| Area | Loop | Character |
|------|------|-----------|
| Front Gate & Drive | "Tempest Loop1" | Cold wind, isolation |
| Chapel | "Silent Voices Loop1" | Hollow sacred silence |
| Greenhouse | "Subtle Changes Loop1" | Organic unease |
| Carriage House | "Echoes at Dusk Loop1" | Abandoned space |
| Family Crypt | "Empty Hope Loop1" | Grief, finality |

---

## Connection to Endings

### True Ending: "Freedom" (requires all counter-ritual components)

```
EXTERIOR — FRONT DRIVE — DAWN APPROACHING

The player walks out through the front door. Behind them,
the mansion shudders. Windows crack. The attic light goes out.

For the first time, the grounds are touched by dawn light.
Snow stops falling. The iron gates stand open — now they
feel welcoming, not threatening.

In the attic window, briefly: Elizabeth's face. Smiling.
Then she is gone.

The house settles. Silent. At peace.
```

### Neutral Ending: "Escape"

```
EXTERIOR — FRONT DRIVE — STILL NIGHT

The player runs through the front door. The attic window
is still lit. A figure watches.

The iron gates are now closed — but not locked.
The player pushes through.

Looking back: every window in the mansion is now lit.
A child's silhouette in every one.

The player walks away. The compulsion to return is already
building.
```

### Dark Ending: "Joined"

```
INTERIOR — FOYER — TIMELESS

The player tries to leave. The front door won't open.
Every door, every window — sealed.

The clock begins to tick. It reads 3:34 AM.
Time has moved. For the first time.

In every mirror, beside the player's reflection:
Elizabeth. Smiling.

"Welcome home."

FADE TO BLACK.

EXTERIOR — FRONT GATE — MONTHS LATER

A new figure approaches the mansion.
Through the attic window: two silhouettes now.
```

---

## Environmental Storytelling (Grounds)

### The Footprints
- One set of footprints goes IN through the gate
- No footprints come OUT
- As the game progresses, if the player returns to the front gate (escape attempt), the footprints have been covered by fresh snow — as if they were never there

### The Gate
- Open when you arrive
- Behavior changes based on flags:
  - Before `elizabeth_aware`: Open, inviting
  - After `elizabeth_aware`: Closed but not locked
  - After `knows_full_truth`: Locked (Dark Ending trigger if player can't open)
  - After `counter_ritual_complete`: Open, bathed in dawn light

### The Attic Window
- Visible from the front drive
- Faint candle glow
- Brief figure visible on first approach (Elizabeth)
- Behavior changes: after attic is entered, light goes out when viewed from outside

### Snow
- Gentle snowfall throughout outdoor areas
- Accumulates on surfaces
- Covers tracks (narrative: the house erases evidence)
- Stops in True Ending (dawn breaks the spell)

---

## Related Documentation

- [Front Gate Scene](./front-gate.md) — Complete prologue specification
- [Chapel](./chapel.md) — Complete room specification
- [Greenhouse](./greenhouse.md) — Complete room specification
- [Carriage House](./carriage-house.md) — Complete room specification
- [Family Crypt](./crypt.md) — Complete room specification
- [Endings](../../narrative/endings.md) — Complete ending sequences
