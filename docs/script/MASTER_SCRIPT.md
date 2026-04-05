# Ashworth Manor: Master Script

This is the authoritative document defining the complete player journey from start to finish. All development must align with this script.

---

## Story Synopsis

**December 24th, 1891, 3:33 AM** - The player arrives at Ashworth Manor, drawn by an unexplained compulsion. The house has been abandoned for mere hours, though it feels like centuries. Within these walls lies the truth about Elizabeth Ashworth, the forgotten fourth child who was confined to the attic at age seven and officially "died" at nine. She never left.

The player's journey is one of discovery, moving from surface-level observations of a wealthy Victorian family to the horrifying truth of what they did to their youngest daughter - and what she became.

---

## Act Structure

### ACT I: The Surface (Ground Floor)
**Theme**: Faded grandeur, something is wrong
**Duration**: ~15-20 minutes
**Goal**: Establish unease, plant questions

### ACT II: The Secrets (Upper Floor + Basement)
**Theme**: Private truths, hidden knowledge
**Duration**: ~25-30 minutes
**Goal**: Reveal Elizabeth's existence, find the attic key

### ACT III: The Truth (Attic)
**Theme**: Horror, understanding
**Duration**: ~15-20 minutes
**Goal**: Discover Elizabeth's fate, face the choice

---

## Complete Player Journey

### PROLOGUE: The Approach (EXTERIOR)

```
EXTERIOR — FRONT GATE — DECEMBER 24TH, 1891 — 3:33 AM

Iron gates stand open in the snow. A gravel drive leads
to the dark silhouette of a grand Victorian mansion.

Snow falls gently. One gas lamp gutters by the gate.
The other is dark.

All windows are dark except one — the attic.
A figure appears briefly in the attic window, then vanishes.

Footprints in the snow lead inward. None lead out.

The player walks up the drive. The front door is ajar.
It shouldn't be.
```

**Room ID**: `front_gate`
**Audio**: "Tempest Loop1" — cold wind, isolation
**Interactables**: Gate plaque ("ASHWORTH MANOR — Est. 1847"), footprints observation
**Exit**: Front door → Foyer

### SCENE 0.5: Grounds (Available After Ground Floor)

After the player has entered the mansion and explored the ground floor, the grounds become accessible via the front door. The exterior areas unlock progressively:

| Area | Access | Purpose |
|------|--------|---------|
| Front Gate & Drive | Always (game start) | Prologue |
| Carriage House | After visiting Wine Cellar (cellar key clue) | Contains cellar_key |
| Chapel | After entering Attic (elizabeth_aware flag) | Contains blessed_water |
| Greenhouse | After Chapel visit | Contains gate_key for Crypt |
| Family Crypt | Requires gate_key from Greenhouse | Contains jewelry_key |

---

### SCENE 1: Grand Foyer
**Room ID**: `foyer`
**Entry Point**: Main entrance (south wall)
**First Visit Event**: `event_intro_narration`

#### Environment Setup
- Chandelier illuminated (steady warm glow)
- Wall sconces flickering gently
- Grandfather clock frozen at 3:33 AM
- Moonlight through high window

#### Immediate Observations
1. **Portrait of Lord Ashworth** (north wall)
   - First thing player sees
   - "The patriarch stares down with hollow eyes. His hand rests on a book titled 'Rites of Passage'."
   - **Color Cue**: Deep red wallpaper behind suggests authority and blood

2. **Grandfather Clock** (east corner)
   - All clocks in house show 3:33
   - Establishes the "frozen moment"
   - **Sound Cue**: No ticking (unnerving silence)

3. **Entry Mirror** (west wall)
   - First mirror encounter
   - Reflection is normal... for now
   - **Foreshadowing**: Sets up mirror motif

#### Dialogue/Text Triggers
- **On entering**: Room name fades in: "Grand Foyer"
- **On clock examine**: "The hands point to 3:33. The pendulum hangs motionless."
- **On mirror examine**: "Your reflection stares back. For a moment, you could swear it moved independently."

#### Available Paths
- **North** → Parlor (door)
- **East** → Dining Room (door)
- **West** → Kitchen (door)
- **Up** → Upper Hallway (grand staircase)

#### Player Questions Planted
- Why is the clock stopped?
- Who was Lord Ashworth?
- What is this house hiding?

---

### SCENE 2: Parlor
**Room ID**: `parlor`
**Entry**: From Foyer (south)

#### Environment Setup
- Cold fireplace (embers dying)
- Velvet furniture, heavy drapes
- Arsenic green wallpaper (authentic Victorian)
- Multiple candles (some extinguished, some lit)

#### Key Discoveries
1. **Portrait of Lady Ashworth** (west wall)
   - "She wears a black mourning dress despite this being painted before any family deaths. Prescient or cursed?"
   - **Color Cue**: Black dress against green = death in nature

2. **Torn Diary Page** (on side table)
   - CRITICAL CLUE
   - "The children have been hearing whispers from the attic again. I've locked the door but they say she still calls to them at night..."
   - **First mention of "she" in the attic**

3. **Music Box** (decorative table)
   - Interactable but currently non-functional
   - Will play Elizabeth's melody later (event-triggered)
   - **Future Development**: Plays when ghost events active

#### Atmosphere Progression
- Darker than Foyer (ambientDarkness: 0.5 vs 0.4)
- Dying fire suggests recent abandonment
- Intimate space - feels watched

#### Dialogue/Text Triggers
- **On fireplace examine**: "The embers are still warm. Someone was here recently."
- **On Lady Ashworth portrait**: Text as above
- **On diary page**: First major narrative reveal

---

### SCENE 3: Dining Room
**Room ID**: `dining_room`
**Entry**: From Foyer (west)

#### Environment Setup
- Long mahogany table set for 8
- Dusty fine china
- Burgundy wallpaper (blood color)
- Chandelier and table candles

#### Key Discoveries
1. **Dinner Party Photograph** (east wall)
   - "The final dinner party. Three of these guests would be dead within the week."
   - **Visual Detail**: One chair is pushed back - someone left quickly
   - **Color Cue**: Burgundy walls = dining with death

2. **Table Setting**
   - Places set but food never served
   - Glasses have residue (wine never drunk)
   - One setting has been cleared entirely

#### Atmosphere Notes
- Formal, cold despite candlelight
- Sense of interrupted celebration
- Death hangs over the room

---

### SCENE 4: Kitchen
**Room ID**: `kitchen`
**Entry**: From Foyer (east)
**Exit**: Down to Basement

#### Environment Setup
- Cast iron cookware
- Cold hearth (larger than parlor)
- Stone floor, wooden beams
- Servants' domain - simpler materials

#### Key Discoveries
1. **Cook's Note** (work table)
   - "The master has forbidden anyone from the attic. Says the rats have grown too bold. But I've heard no rats that whisper names..."
   - **Second reference to attic whispers**
   - Servant knew something was wrong

2. **Basement Stairs**
   - Descends to Storage Basement
   - First downward path
   - **Visual**: Darkness visible below

#### Atmosphere Notes
- Class divide evident (plainer materials)
- Service area - truth lives here
- Scratching sounds from walls (ambient)

---

### SCENE 5: Storage Basement
**Room ID**: `storage_basement`
**Entry**: Down from Kitchen
**First Underground Location**

#### Environment Setup
- Cobwebs, forgotten belongings
- Stone and brick walls
- Single candle (very dim)
- Piled furniture and crates

#### Key Discoveries
1. **Scratched Family Portrait** (on crate)
   - "A stern-looking family stands before the mansion. The youngest child's face has been scratched out."
   - **CRITICAL**: First physical evidence of the hidden child
   - **Color Cue**: Scratches are violent, desperate

2. **Dusty Mirror** (against wall)
   - Covered in grime
   - **Future Development**: Reveals figure when cleaned

#### Atmosphere Notes
- First truly dark space
- Feeling of descent (literal and narrative)
- Things hidden below the surface

#### Available Paths
- **Up** → Kitchen (stairs)
- **East** → Boiler Room (door)
- **Down** → Wine Cellar (ladder)

---

### SCENE 6: Boiler Room
**Room ID**: `boiler_room`
**Entry**: From Storage Basement (west)

#### Environment Setup
- Massive iron boiler
- Pipes everywhere
- Metal grate floor
- Fireplace glow (industrial)

#### Key Discoveries
1. **Maintenance Log** (work desk)
   - "Dec 15, 1891 - Strange sounds from the pipes again. The staff refuse to come down here after dark. Something is wrong with this house."
   - **Staff knew. Staff were afraid.**

2. **Industrial Clock**
   - Also frozen at 3:33
   - Reinforces the frozen moment

#### Atmosphere Notes
- Industrial menace
- Pipes could carry sounds... or voices
- Heat contrasts with cold house above

---

### SCENE 7: Wine Cellar
**Room ID**: `wine_cellar`
**Entry**: Down ladder from Storage Basement
**Deepest point in mansion**

#### Environment Setup
- Wine racks lining walls
- Torch light only
- Cold stone everywhere
- Very dark (ambientDarkness: 0.85)

#### Key Discoveries
1. **Wine Inventory Note**
   - "The 1872 Bordeaux has been moved to the hidden alcove. Master insists no one shall find it. The key is with the portrait."
   - **Hint at secret spaces**
   - **Key connection**: Which portrait?

2. **Locked Box**
   - Requires `cellar_key`
   - **Contents**: TBD (future reward item)

#### Atmosphere Notes
- Oppressive darkness
- Ancient, forgotten
- Secrets buried deep

---

### SCENE 7.5: Grounds (Accessible After Ground Floor)

The exterior grounds become available once the player has explored the ground floor. These areas are accessed by exiting through the front door. They contain critical puzzle components for the counter-ritual ending.

#### Carriage House
**Room ID**: `carriage_house`
**Available**: After visiting Wine Cellar (player has cellar key clue)
**Audio**: "Echoes at Dusk Loop1"

**Key Discovery**: Lord Ashworth's duplicate portrait with CELLAR KEY behind frame
**Secondary**: Elizabeth's packed trunk (clothes "to be burned"), claw marks in carriage

#### Chapel  
**Room ID**: `chapel`
**Available**: After entering Attic (`elizabeth_aware` flag)
**Audio**: "Silent Voices Loop1"

**Key Discovery**: BLESSED WATER from baptismal font
**Secondary**: Inverted cross, prayer book note about Elizabeth never being baptized

#### Greenhouse
**Room ID**: `greenhouse`
**Available**: After visiting Chapel
**Audio**: "Subtle Changes Loop1"

**Key Discovery**: GATE KEY (in pot near white lily)
**Secondary**: White lily (impossibly alive), Lady Ashworth's garden journal expressing guilt

#### Family Crypt
**Room ID**: `family_crypt`
**Available**: Requires gate_key from Greenhouse
**Audio**: "Empty Hope Loop1"

**Key Discovery**: JEWELRY KEY (under loose flagstone) + Lady's guilt note
**Secondary**: Empty sarcophagi (Lord & Lady vanished), MISSING fourth plaque (Elizabeth erased from death)

---

### SCENE 8: Upper Hallway (Return to Ground, Ascend)
**Room ID**: `upper_hallway`
**Entry**: Up from Foyer (grand staircase)

#### Environment Setup
- Long corridor with multiple doors
- Wall sconces (flickering)
- Window at end (moonlight)
- Dark wallpaper, wood runner

#### Key Discoveries
1. **Painting: "The Children"** (east wall)
   - "Three children in white. The youngest holds a doll that looks remarkably like the figure seen in the attic window."
   - **Wait - only THREE children shown**
   - **Doll foreshadowing**

2. **Locked Attic Door** (north end)
   - "The door is locked. You need a key."
   - **Primary puzzle goal established**
   - **Visual**: Scratches around lock (from inside?)

#### Critical Path Note
Player must now explore upper floor to find the attic key.

---

### SCENE 9: Master Bedroom
**Room ID**: `master_bedroom`
**Entry**: From Upper Hallway (west)

#### Environment Setup
- Four-poster bed (unmade on one side)
- Persian carpet
- Blue wallpaper (melancholy)
- Candles on nightstands

#### Key Discoveries
1. **Lord Ashworth's Diary** (nightstand) - CRITICAL
   - "She won't stop crying. Even after we locked her away, I hear her sobbing through the walls. My wife says I'm mad, but I know what I hear. The attic key is hidden in the library globe. No one must find her."
   - **REVEALS**: 
     - Elizabeth was locked in attic
     - Key location: library globe
     - Father's guilt/madness

2. **Large Mirror** (west wall)
   - Increasingly disturbing on repeat visits
   - **Development**: Reflection delays

3. **Locked Jewelry Box**
   - Requires `jewelry_key`
   - **Contents**: TBD (locket with Elizabeth's portrait?)

#### Atmosphere Notes
- Intimacy violated by searching
- Bed suggests hasty departure
- Father's guilt permeates

---

### SCENE 10: Library
**Room ID**: `library`
**Entry**: From Upper Hallway (west)
**PUZZLE SOLUTION LOCATION**

#### Environment Setup
- Floor-to-ceiling books
- Wood paneling
- Scholarly atmosphere
- Globe in corner

#### Key Discoveries
1. **The Globe** - PUZZLE SOLUTION
   - "Inside the hollow globe, you find an old brass key labeled 'ATTIC'."
   - **Event**: `event_found_attic_key`
   - **Flag Set**: `has_attic_key`
   - **Inventory Add**: `attic_key`

2. **"Rituals of Binding"** (book)
   - "To trap a spirit, one must first give it form. The doll shall be the vessel, the blood the seal, and the attic the prison eternal..."
   - **Reveals the occult truth**
   - Elizabeth wasn't just locked up - she was bound

3. **Family Tree** (wall display)
   - "The tree shows four children, but the household records only mention three. The fourth name has been scratched out: 'E_iza_eth'."
   - **Physical proof of erasure**

#### Critical Path
Player now has the attic key. Return to upper hallway.

---

### SCENE 11: Guest Room
**Room ID**: `guest_room`
**Entry**: From Upper Hallway (east)
**Optional but enriching**

#### Environment Setup
- Modest compared to master
- Neatly made bed
- Scratches on inside of door

#### Key Discoveries
1. **Guest Photo** (bedside)
   - "A woman in white stands at the attic window. On the back: 'She sees you too - 1889'"
   - **Elizabeth photographed (as ghost?)**
   - **1889 = year of her "death"**

2. **Guest Ledger Entry** (desk)
   - "Mrs. Helena Pierce, arriving Nov 3rd 1891. DEPARTED: [The entry is blank]"
   - **Guest who never left**
   - **Sets up future character expansion**

#### Atmosphere Notes
- Scratches from INSIDE
- Another victim?
- The house takes people

---

### SCENE 12: Attic Stairwell
**Room ID**: `attic_stairs`
**Entry**: From Upper Hallway (north, unlocked with attic_key)
**First-time event**: `event_attic_unlocked`

#### Environment Setup
- Narrow, creaking stairs
- Dust motes in thin light
- Rough wood, cracked plaster
- Cold despite no windows

#### Atmosphere Notes
- Transition space
- Dread building
- Point of no return feeling

---

### SCENE 13: Attic Storage
**Room ID**: `attic_storage`
**Entry**: From Attic Stairwell (south)

#### Environment Setup
- Old trunks, furniture
- Dormer window (moonlight)
- Exposed rafters
- Very dark (ambientDarkness: 0.8)

#### Key Discoveries
1. **Elizabeth's Portrait** - CLIMACTIC REVEAL
   - "A young girl in a white dress clutches a porcelain doll. Her eyes have been painted over in black. A plaque reads: 'Elizabeth Ashworth, 1880-1889. Beloved daughter. Forgotten by none.'"
   - **The forgotten child finally seen**
   - **Eyes blacked out = what she could see**
   - **"Forgotten by none" = bitter irony**

2. **The Porcelain Doll**
   - "A porcelain doll with cracked features. Its eyes seem to follow you. Behind it, scratched into the wood: 'SHE NEVER LEFT'"
   - **The vessel mentioned in the ritual book**
   - **Confirmation: Elizabeth is still here**

3. **Unsent Letter** (in trunk)
   - "Dearest Mother, They say I'm sick but I feel fine. Father won't let me leave my room anymore. The doll talks to me now. She says I'll be here forever. I'm scared. - Your Elizabeth"
   - **Elizabeth's own words**
   - **Doll communicating with her**
   - **Child's terror**

#### Hidden Path
- **West** → Hidden Chamber (locked with `hidden_key`)
- **Future Development**: Find hidden_key elsewhere

---

### SCENE 14: Hidden Chamber
**Room ID**: `hidden_room`
**Entry**: From Attic Storage (west, requires hidden_key)
**FINAL REVELATION**

#### Environment Setup
- Tiny room behind walls
- Children's drawings covering EVERY surface
- Same figure repeated: girl with black eyes
- Two candles (barely any light)

#### Key Discoveries
1. **Elizabeth's Final Note** - NARRATIVE CLIMAX
   - "I understand now. The doll showed me. I was never sick - they were afraid of what I could see. The house has eyes. The walls have ears. And now I am part of it forever. Find me. Free me. Or join me."
   - **The complete truth**
   - **Elizabeth's transformation**
   - **Player's choice implied**

2. **The Final Mirror**
   - What does the player see?
   - **Development**: Elizabeth appears behind them
   - **Player must turn around**

#### Ending Setup
Player now has complete knowledge:
- Elizabeth could see things others couldn't
- Her family imprisoned her out of fear
- They bound her spirit to the house
- She became what they feared
- The player must choose: help her, escape, or stay

---

## Puzzle Flowchart

```
START (Foyer)
    │
    ├─► Explore Ground Floor
    │   └─► Find clues about attic whispers (Parlor, Kitchen)
    │
    ├─► Explore Basement
    │   └─► Find scratched portrait (first evidence of 4th child)
    │
    └─► Go Upstairs
        │
        ├─► Find Locked Attic Door
        │   └─► Need: attic_key
        │
        ├─► Explore Master Bedroom
        │   └─► FIND DIARY → "Key in library globe"
        │
        └─► Explore Library
            └─► FIND ATTIC KEY (in globe)
                │
                └─► UNLOCK ATTIC
                    │
                    ├─► Attic Storage
                    │   └─► Major reveals (portrait, doll, letter)
                    │
                    └─► Hidden Chamber (requires hidden_key)
                        └─► FINAL REVELATION
```

---

## Color Language

| Color | Meaning | Locations |
|-------|---------|-----------|
| **Deep Red** | Authority, blood, power | Foyer walls, Lord's domain |
| **Arsenic Green** | Nature corrupted, poison | Parlor, Lady's space |
| **Prussian Blue** | Melancholy, secrets | Master Bedroom |
| **Burgundy** | Death, endings | Dining Room |
| **Dark Walnut** | Knowledge, hidden truth | Library |
| **Cold Grey** | Servant class, foundation | Basement, Kitchen |
| **Raw Wood** | Decay, exposure | Attic |
| **Black** | Elizabeth's vision, void | Her painted-over eyes |

---

## Sound Design Notes

### Ground Floor
- Clock ticking (absent - uncanny)
- Fire crackling (parlor, kitchen)
- Distant settling sounds
- Footsteps change with surface

### Upper Floor
- Floorboard creaks
- Whispers at edge of hearing
- Wind through gaps
- Scratching behind walls

### Basement
- Dripping water
- Pipe groans
- Complete silence in wine cellar
- Own heartbeat audible

### Attic
- Wind through rafters
- Music box melody (distant)
- Child's crying (barely perceptible)
- "Elizabeth" whispered

---

## Event Triggers

### On Entry Events
| Room | Event ID | Actions |
|------|----------|---------|
| Foyer (first) | `event_intro_narration` | Set `game_started` flag |
| Attic Stairs (first) | `event_attic_entered` | Play sound, increase tension |
| Hidden Chamber (first) | `event_final_room` | Trigger climax sequence |

### On Discovery Events
| Trigger | Event ID | Actions |
|---------|----------|---------|
| Find attic key | `event_found_attic_key` | Add to inventory, show message |
| Read diary | `event_read_diary` | Set `knows_key_location` flag |
| See Elizabeth portrait | `event_seen_elizabeth` | Set `knows_elizabeth` flag |

### Conditional Events
| Conditions | Event ID | Actions |
|------------|----------|---------|
| All mirrors examined | `event_mirror_warning` | Reflections delay |
| 10+ rooms visited | `event_being_watched` | Ambient sounds change |
| Attic unlocked | `event_elizabeth_aware` | Footsteps heard above |

---

## Ending Conditions (FINALIZED)

### True Ending: "Freedom"

**Trigger**: `counter_ritual_complete` flag set in Hidden Chamber

**Required Flags**:
- `has_doll`, `has_binding_book`, `has_lock_of_hair`
- `has_blessed_water`, `has_mothers_confession`, `read_final_note`
- All three ritual steps completed in Hidden Chamber

**Sequence**:
```
INTERIOR — HIDDEN CHAMBER

The doll cracks open. Light pours from inside — warm,
golden light that hasn't existed in this house for decades.

The drawings on the walls fade. Not erased — released.
The figures in the drawings step off the walls and dissolve
like morning mist.

The candles blaze bright, then go out.
Silence.

Elizabeth's voice: "Thank you."

TRANSITION — FOYER

The player walks through the house. It feels different.
Warmer. The clocks begin to tick — all showing different
times. The frozen moment has thawed.

EXTERIOR — FRONT DRIVE — DAWN

For the first time, dawn light touches the mansion.
Snow stops falling. The gas lamps are both lit.

In the attic window, briefly: Elizabeth's face. Smiling.
Not the smile of a ghost — the smile of a child at peace.
Then she is gone.

The front gates stand wide open.
The footprints in the snow are gone.

Room name fades in: "December 25th, 1891. Christmas Morning."

FADE TO BLACK.
```

### Neutral Ending: "Escape"

**Trigger**: Player interacts with front door to exit AFTER `knows_full_truth` but WITHOUT `counter_ritual_complete`

**Required Flags**:
- `knows_full_truth` (read Elizabeth's final note)
- NOT `counter_ritual_complete`

**Sequence**:
```
EXTERIOR — FRONT DRIVE — STILL NIGHT

The player pushes through the front door. The air is cold
but it feels like freedom.

The attic window is still lit. A figure watches.

The iron gates are closed — but not locked. The player
pushes through them. They groan in protest.

Looking back: every window in the mansion is now lit.
Warm candlelight in each one. A silhouette in every frame.
The same silhouette. Elizabeth.

The player walks away into the snow.

TEXT: "You know the truth now. She knows you know.
       The compulsion to return is already building."

EXTERIOR — FRONT GATE — WEEKS LATER (EPILOGUE)

The same gate. The same drive. Fresh footprints in new snow.
Leading in.

Room name fades in: "You came back."

FADE TO BLACK.
```

### Dark Ending: "Joined"

**Trigger**: Player attempts to leave AFTER `elizabeth_aware` but BEFORE `knows_full_truth` — OR player stays in the Hidden Chamber for 60+ seconds without performing the counter-ritual

**Required Flags**:
- `elizabeth_aware` (entered attic)
- Either: attempt to leave without full knowledge, OR linger in Hidden Chamber

**Sequence**:
```
INTERIOR — FOYER (if trying to leave)

The player reaches the front door. It won't open.
They try every door. Every window. Sealed.

The grandfather clock begins to tick. For the first time.
It reads 3:34 AM. Time has moved.

In the foyer mirror, beside the player's reflection:
Elizabeth. Smiling. Not threatening — welcoming.

EVERY mirror in the house now shows Elizabeth beside
the player. She takes their hand in the reflection.

TEXT: "Welcome home."

FADE TO BLACK.

EXTERIOR — FRONT GATE — MONTHS LATER (EPILOGUE)

A new figure approaches the mansion gates.
Through the attic window: two silhouettes now.
The gate is open. Footprints lead in.
None lead out.

FADE TO BLACK.
```

---

## Development Priority

### Phase 1: Complete Design (DONE)
- [x] All 20 rooms/areas fully specified
- [x] All 6 puzzles fully designed with solutions
- [x] All 10+ items fully specified with locations
- [x] All 3 endings fully scripted
- [x] Complete puzzle dependency graph
- [x] Grounds exterior with 6 areas (including Garden)
- [x] Audio loop assignments for every room
- [x] Counter-ritual 3-step sequence designed

### Phase 2: Godot Implementation (DONE)
- [x] Scene-based architecture (20 .tscn room scenes)
- [x] All 20 rooms with GLB models placed
- [x] Touch controls (tap-to-walk, swipe-to-look)
- [x] Room transitions with fade (timing per connection type)
- [x] Interaction system (InteractableData resources on Area3D)
- [x] Inventory system (GameManager autoload)
- [x] Save/load system
- [x] All puzzle logic (interaction_manager.gd)
- [x] All audio loops integrated (audio_manager.gd with crossfade)
- [x] All three ending sequences
- [x] PSX shader/post-processing (screen-space on CanvasLayer)

### Phase 3: Visual QA
- [ ] Screenshot every room
- [ ] Verify asset placement
- [ ] Test all puzzle chains
- [ ] Test all three endings
- [ ] Mobile touch testing

---

*This document is the source of truth. All room designs, puzzle implementations, and narrative content must reference this script.*
