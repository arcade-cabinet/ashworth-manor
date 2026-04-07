# Puzzle System Documentation

This document catalogs all puzzles in Ashworth Manor, their solutions, and their narrative integration.

---

## Puzzle Design Philosophy

### Core Principles

1. **Diegetic Solutions**
   - All puzzle solutions exist within the game world
   - No abstract logic puzzles
   - Clues are documents, observations, environmental details

2. **Narrative Integration**
   - Every puzzle advances the story
   - Solutions reveal character or plot information
   - Solving should feel like discovery, not obstacle clearing

3. **Myst-Inspired Design**
   - Machines and mechanisms have logical function
   - Observation rewards patience
   - No trial-and-error required if clues are found

4. **Non-Blocking Progression**
   - Multiple exploration paths available
   - Stuck players can explore elsewhere
   - Key puzzles have multiple hint sources

---

## Puzzle Index

| Puzzle ID | Name | Location | Difficulty | Status |
|-----------|------|----------|------------|--------|
| `puzzle_attic_key` | Find the Attic Key | Library Globe | Easy | COMPLETE |
| `puzzle_hidden_key` | Find the Hidden Key | Porcelain Doll (Attic) | Medium | COMPLETE |
| `puzzle_cellar_box` | Wine Cellar Secret | Carriage House → Wine Cellar | Medium | COMPLETE |
| `puzzle_jewelry_box` | Lady's Jewelry Box | Crypt → Master Bedroom | Easy | COMPLETE |
| `puzzle_crypt_gate` | Open the Crypt Gate | Greenhouse → Crypt | Easy | COMPLETE |
| `puzzle_counter_ritual` | Free Elizabeth | Hidden Chamber (6 components) | Hard | COMPLETE |

---

## Puzzle: Find the Attic Key

**ID**: `puzzle_attic_key`
**Type**: Key-Lock with Clue Chain
**Difficulty**: Easy (introductory puzzle)
**Status**: Implemented

### Overview
The attic door is locked. The player must find the key to access Elizabeth's prison and discover the truth.

### Flowchart

```
┌─────────────────────────────────────────────────────────────────┐
│                     ATTIC KEY PUZZLE                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  DISCOVERY: Locked Attic Door                                   │
│  Location: Upper Hallway (north end)                            │
│  Observation: "The door is locked. You need a key."             │
│  Flag Set: knows_attic_locked                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  CLUE 1: Lord Ashworth's Diary                                  │
│  Location: Master Bedroom (nightstand)                          │
│  Text: "The attic key is hidden in the library globe.           │
│         No one must find her."                                  │
│  Flag Set: knows_key_location                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  SOLUTION: The Library Globe                                    │
│  Location: Library (corner)                                     │
│  Action: Interact with globe                                    │
│  Result: "Inside the hollow globe, you find an old brass        │
│          key labeled 'ATTIC'."                                  │
│  Item Added: attic_key                                          │
│  Flag Set: has_attic_key                                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  RESOLUTION: Unlock Attic Door                                  │
│  Location: Upper Hallway                                        │
│  Action: Interact with attic door (with attic_key)              │
│  Result: Door unlocks, access to Attic Stairwell                │
│  Flag Set: attic_unlocked                                       │
└─────────────────────────────────────────────────────────────────┘
```

### Clue Redundancy
If player misses the diary, additional hints exist:

| Source | Hint |
|--------|------|
| Wine Cellar Note | "The key is with the portrait" (less direct) |
| Parlor Diary Page | Mentions attic being locked (primes player) |
| Kitchen Note | "Master forbade the attic" (reinforces importance) |

### Schema Definition
```yaml
puzzle:
  id: puzzle_attic_key
  name: "Find the Attic Key"
  description: "The attic door is locked. Find the key to discover what the family hid."
  
  steps:
    - id: find_locked_door
      description: "Discover the locked attic door"
      requiredAction:
        type: interact
        targetId: attic_door_upper_hallway
      optional: true  # Player may find key first
      
    - id: read_diary
      description: "Find the clue in Lord Ashworth's diary"
      requiredAction:
        type: examine
        targetId: diary
      hint: "Lord Ashworth kept secrets in his bedroom."
      
    - id: get_key
      description: "Retrieve the key from the library globe"
      requiredAction:
        type: interact
        targetId: library_globe
      onComplete: event_found_attic_key
      
    - id: unlock_door
      description: "Use the key on the attic door"
      requiredAction:
        type: use_item
        itemId: attic_key
        targetId: attic_door_upper_hallway
      onComplete: event_attic_unlocked
      
  sequential: false  # Steps can be done in different order
  
  onComplete: event_attic_accessible
  completionFlags:
    - attic_unlocked
    - puzzle_attic_key_complete
```

---

## Puzzle: Find the Hidden Key (FINALIZED)

**ID**: `puzzle_hidden_key`
**Type**: Doll Interaction Sequence
**Difficulty**: Medium
**Status**: COMPLETE

### Overview
The Hidden Chamber in the attic is locked. The key is inside the porcelain doll — Elizabeth's vessel. To release it, the player must interact with the doll in a specific way that mirrors the binding ritual in reverse.

### Flowchart

```
┌─────────────────────────────────────────────────────────────────┐
│                    HIDDEN KEY PUZZLE                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  DISCOVERY: Locked Hidden Door                                  │
│  Location: Attic Storage (west wall, behind old furniture)      │
│  Observation: "A door, almost invisible behind the trunks.      │
│               The lock is unlike any other in the house —       │
│               shaped like an open hand."                        │
│  Flag Set: knows_hidden_door                                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  CLUE 1: Rituals of Binding (Library)                          │
│  Already found during attic key quest.                         │
│  Key text: "To trap a spirit, one must first give it form.     │
│  The doll shall be the vessel..."                              │
│  IMPLICATION: The doll IS Elizabeth. Reverse the vessel.        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  CLUE 2: Elizabeth's Unsent Letter (Attic Storage)             │
│  "The doll talks to me now. She says I'll be here forever."    │
│  IMPLICATION: The doll communicates. Try talking to it.        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  SOLUTION: Interact with Porcelain Doll (second interaction)   │
│  Location: Attic Storage                                        │
│                                                                 │
│  First tap: Standard observation ("SHE NEVER LEFT")            │
│  Second tap (after reading Elizabeth's letter):                  │
│    "You turn the doll over. Inside the hollow body,            │
│     wrapped in a child's handkerchief, is a tarnished key.     │
│     The doll's cracked face seems to relax."                   │
│                                                                 │
│  Item Added: hidden_key                                         │
│  Flag Set: has_hidden_key                                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  RESOLUTION: Unlock Hidden Chamber                              │
│  Location: Attic Storage (west wall)                            │
│  Action: Use hidden_key on hidden door                          │
│  Result: Door opens to Hidden Chamber                           │
│  Flag Set: hidden_chamber_unlocked                              │
└─────────────────────────────────────────────────────────────────┘
```

### Prerequisites
- Must have read Elizabeth's letter (`read_elizabeth_letter` flag)
- Must have already interacted with doll once (`examined_doll` flag)

### Schema Definition
```yaml
puzzle:
  id: puzzle_hidden_key
  name: "Find the Hidden Key"
  description: "The hidden chamber is locked. The doll holds the answer."

  steps:
    - id: find_hidden_door
      description: "Discover the hidden door in Attic Storage"
      requiredAction:
        type: interact
        targetId: hidden_door_attic

    - id: read_elizabeth_letter
      description: "Read Elizabeth's unsent letter"
      requiredAction:
        type: examine
        targetId: letter_elizabeth

    - id: examine_doll_first
      description: "First examination of the porcelain doll"
      requiredAction:
        type: interact
        targetId: porcelain_doll

    - id: examine_doll_second
      description: "Second examination reveals the key inside"
      requiredAction:
        type: interact
        targetId: porcelain_doll
      prerequisites:
        - read_elizabeth_letter
        - examined_doll
      onComplete: event_found_hidden_key

    - id: unlock_hidden_chamber
      description: "Use the key on the hidden door"
      requiredAction:
        type: use_item
        itemId: hidden_key
        targetId: hidden_door_attic
      onComplete: event_hidden_chamber_unlocked

  sequential: false
  completionFlags:
    - hidden_chamber_unlocked
    - puzzle_hidden_key_complete
```

---

## Puzzle: Wine Cellar Secret (FINALIZED)

**ID**: `puzzle_cellar_box`
**Type**: Key-Lock with Cross-Location Clue
**Difficulty**: Medium
**Status**: COMPLETE

### Overview
A locked box in the Wine Cellar contains Lady Ashworth's confession letter — a counter-ritual component. The clue "the key is with the portrait" refers to a duplicate portrait of Lord Ashworth stored in the Carriage House.

### Flowchart

```
┌─────────────────────────────────────────────────────────────────┐
│                    WINE CELLAR SECRET                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  DISCOVERY: Locked Box in Wine Cellar                           │
│  Observation: "A wooden chest, bound with iron. Heavy padlock." │
│  Flag Set: knows_wine_box_locked                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  CLUE: Wine Inventory Note (Wine Cellar)                        │
│  "The key is with the portrait."                                │
│  Player thinks: Which portrait? Foyer? Parlor? Attic?           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  RED HERRING: Foyer Portrait (Lord Ashworth)                    │
│  Examining it again yields: "The portrait is mounted firmly.    │
│  Nothing behind it that you can reach."                         │
│  HINT: There must be ANOTHER portrait of Lord Ashworth.         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  SOLUTION: Carriage House Portrait                              │
│  A duplicate portrait stored in the carriage house.             │
│  "Behind the portrait's backing, taped to the frame, you find  │
│   a small iron key."                                            │
│  Item Added: cellar_key                                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  RESOLUTION: Open Wine Cellar Box                               │
│  Item Added: mothers_confession                                 │
│  Content: Lady Ashworth's letter confessing her role             │
│  in Elizabeth's imprisonment. Counter-ritual component.          │
└─────────────────────────────────────────────────────────────────┘
```

### Wine Cellar Box Contents
```yaml
mothers_confession:
  id: mothers_confession
  name: "Lady Ashworth's Confession"
  category: document
  content:
    title: "Lady Ashworth's Confession"
    text: |
      I am complicit in what was done to our daughter.

      When Elizabeth first spoke of seeing the dead, I
      told myself she was ill. When Edmund brought the
      occultist, I told myself it was medicine. When they
      locked her in the attic with that horrible doll,
      I told myself it was for her safety.

      I lied. To everyone. To myself.

      Elizabeth was never dangerous. She was gifted.
      And we destroyed her for it.

      If anyone finds this, know that we deserve what
      is coming. The house knows. Elizabeth knows.
      And soon, so shall we.

      — Victoria Ashworth, December 23rd, 1891
  significance:
    - Counter-ritual component (written confession)
    - Confirms Lady Ashworth knew and participated
    - Date: one day before the final event
    - "The house knows" — the house is alive
```

---

## Puzzle: Lady's Jewelry Box (FINALIZED)

**ID**: `puzzle_jewelry_box`
**Type**: Key-Lock
**Difficulty**: Easy
**Status**: COMPLETE

### Overview
The jewelry box in the Master Bedroom contains Elizabeth's locket — a miniature portrait of her as an infant, kept by Lady Ashworth. The key is hidden in the Family Crypt beneath a loose flagstone.

### Flowchart

```
DISCOVERY: Locked Jewelry Box (Master Bedroom)
    │
    ▼
CLUE: Lady's Note in Crypt
    "I hid the locket key here because I cannot
     bear to see her face."
    │
    ▼
SOLUTION: Loose Flagstone in Family Crypt
    Item Added: jewelry_key
    │
    ▼
RESOLUTION: Open Jewelry Box (Master Bedroom)
    Item Added: elizabeth_locket
```

### Jewelry Box Contents
```yaml
elizabeth_locket:
  id: elizabeth_locket
  name: "Elizabeth's Locket"
  category: artifact
  description: |
    A tarnished silver locket on a fine chain. Inside:
    a miniature portrait of an infant with pale eyes.
    The inscription reads: "Our Elizabeth, born in light."
  properties:
    - ritual_component: true (lock of hair is inside)
    - When opened: "Behind the portrait, wrapped in tissue,
      is a tiny lock of golden hair tied with white ribbon."
  items_inside:
    - lock_of_hair
  significance:
    - Contains lock of Elizabeth's hair (counter-ritual component)
    - "Born in light" suggests her abilities were present from birth
    - Lady Ashworth kept this close — evidence of guilty love
```

---

## Puzzle: Counter-Ritual — Free Elizabeth (FINALIZED)

**ID**: `puzzle_counter_ritual`
**Type**: Multi-Component Collection + Sequence
**Difficulty**: Hard
**Status**: COMPLETE

### Overview
To free Elizabeth, the player must reverse the binding ritual described in "Rituals of Binding." This requires collecting six components from across the entire mansion and grounds, then performing three actions in the Hidden Chamber.

### Required Components

| # | Component | Location | Puzzle Required | Flag |
|---|-----------|----------|-----------------|------|
| 1 | Porcelain Doll | Attic Storage | puzzle_hidden_key (doll is pickable after key extracted) | `has_doll` |
| 2 | Rituals of Binding | Library | None (pick up after reading) | `has_binding_book` |
| 3 | Lock of Hair | Jewelry Box → Locket | puzzle_jewelry_box | `has_lock_of_hair` |
| 4 | Blessed Water | Chapel Font | None (pick up on interact) | `has_blessed_water` |
| 5 | Mother's Confession | Wine Cellar Box | puzzle_cellar_box | `has_mothers_confession` |
| 6 | Elizabeth's Final Note | Hidden Chamber | puzzle_hidden_key | `read_final_note` |

### Ritual Sequence (in Hidden Chamber)

The counter-ritual is performed at the center of the Hidden Chamber, where Elizabeth's drawings converge on a single point — a circle drawn on the floor.

```
Step 1: PLACE the Porcelain Doll in the circle
    → "The doll sits in the center of Elizabeth's drawings.
       The candles in the room flicker."
    → Flag: ritual_step_1

Step 2: POUR Blessed Water on the doll
    → "Water flows over the doll's cracked face.
       The drawings on the walls seem to shift."
    → Flag: ritual_step_2

Step 3: READ from the Binding Book (interact while holding it)
    → The player reads the counter-passage:
       "To free a spirit, one must return its name.
        Speak it true, speak it whole, speak it with love."
    → Flag: ritual_step_3

    → AUTOMATIC: The game speaks Elizabeth's name:
       "Elizabeth Ashworth. Born in light. Free."

    → The doll CRACKS OPEN. Light pours from inside.
    → The drawings on the walls FADE.
    → The candles BLAZE bright, then go out.
    → SILENCE.

    → Elizabeth's voice (text): "Thank you."

    → Flag: counter_ritual_complete
    → Flag: freed_elizabeth
    → Trigger: ending_freedom
```

### Why These Steps
The binding ritual used: **form** (doll), **blood** (seal), **confinement** (attic).
The counter-ritual reverses: **purification** (blessed water), **truth** (confession, book), **naming** (speaking her name with love).

The lock of hair and confession letter are prerequisites — they must be in inventory but aren't physically used in the ritual. They represent the player having understood Elizabeth's full story.

### Events
```yaml
event_ritual_begin:
  trigger: Place doll in Hidden Chamber circle
  conditions:
    - has_item: porcelain_doll
    - flag_set: hidden_chamber_unlocked
  actions:
    - set_flag: ritual_step_1
    - play_sound: candle_flicker
    - show_message: "The doll sits in the center of Elizabeth's drawings. The candles flicker."

event_ritual_water:
  trigger: Use blessed_water on doll (after step 1)
  conditions:
    - has_item: blessed_water
    - flag_set: ritual_step_1
  actions:
    - set_flag: ritual_step_2
    - consume_item: blessed_water
    - play_sound: water_pour
    - show_message: "Water flows over the doll's cracked face. The drawings on the walls seem to shift."

event_ritual_complete:
  trigger: Use binding_book on doll (after step 2)
  conditions:
    - has_item: binding_book
    - flag_set: ritual_step_2
    - has_item: lock_of_hair
    - has_item: mothers_confession
  actions:
    - set_flag: ritual_step_3
    - set_flag: counter_ritual_complete
    - set_flag: freed_elizabeth
    - play_sound: ritual_complete
    - flicker_lights: { duration: 3000, then: extinguish }
    - delay: 2000
    - show_message: "Elizabeth Ashworth. Born in light. Free."
    - delay: 3000
    - show_message: "Thank you."
    - delay: 2000
    - trigger_ending: ending_freedom

event_ritual_incomplete:
  trigger: Attempt ritual without all components
  actions:
    - show_message: "Something is missing. You haven't found the whole truth yet."
```

### Complete Puzzle Dependency Graph

```
                    ┌─── Chapel Font ─── Blessed Water
                    │
                    ├─── Library Globe ─── Attic Key ─── Attic ─── Doll (hidden_key inside)
                    │                                         │
                    │                                         └─── Hidden Chamber ─── Final Note
                    │
COUNTER-RITUAL ─────┤
                    │
                    ├─── Crypt Flagstone ─── Jewelry Key ─── Jewelry Box ─── Locket ─── Lock of Hair
                    │
                    ├─── Library ─── Binding Book
                    │
                    └─── Carriage Portrait ─── Cellar Key ─── Wine Box ─── Mother's Confession
```

---

## Puzzle Design Template

For future puzzle additions, use this template:

```yaml
puzzle:
  id: puzzle_[unique_id]
  name: "[Display Name]"
  description: "[What the player is trying to do]"
  difficulty: [easy|medium|hard]
  
  # Where does this puzzle start?
  discoveryLocation: [room_id]
  discoveryInteractable: [interactable_id]
  
  # What clues lead to the solution?
  clues:
    - location: [room_id]
      interactable: [interactable_id]
      text: "[Clue text]"
      requiredFlags: []  # Optional conditions
      
  # What is the solution?
  solution:
    location: [room_id]
    action: [interact|use_item|examine|combine]
    target: [interactable_id]
    item: [item_id]  # If action is use_item
    
  # What happens on completion?
  rewards:
    items: []
    flags: []
    unlocks: []
    events: []
    
  # Hints for stuck players
  hints:
    - condition: "[When to show hint]"
      text: "[Hint text]"
      
  # Narrative integration
  storyReveals:
    - "[What the player learns about the story]"
```

---

## Puzzle Difficulty Guidelines

### Easy
- Single clue pointing to single solution
- Clue and solution in adjacent/nearby rooms
- Obvious connection between clue and solution
- Example: Attic Key (diary explicitly states location)

### Medium
- Multiple clues needed
- Clues spread across different floors
- Some interpretation required
- Example: Hidden Key (multiple paths, less explicit)

### Hard
- Multiple components from many locations
- Sequence-dependent steps
- Subtle clues requiring close observation
- Example: Counter-Ritual (full mansion exploration)

---

## Integration with Schema

All puzzles should be defined in the mansion schema:

```typescript
// In mansion.schema.ts
export const PuzzleSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string().optional(),
  steps: z.array(PuzzleStepSchema),
  sequential: z.boolean().default(true),
  onStart: z.string().optional(),
  onComplete: z.string().optional(),
  onFail: z.string().optional(),
  completionFlags: z.array(z.string()).optional(),
  rewardItems: z.array(z.string()).optional(),
  timeLimitSeconds: z.number().optional(),
  hints: z.array(PuzzleHintSchema).optional(),
});
```

Ensure all new puzzles validate against this schema before implementation.
