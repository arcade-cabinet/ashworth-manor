# Weave System Paper Playtest

> Archived design exploration.
> This playtest targets the old weave/PRNG framing, not the shipped
> `Adult -> Elder -> Child` route program.

Testing the A/B needle-threading system with actual game content. Three playthroughs: A-thread, B-thread, and balance analysis.

---

## Available Set Pieces (376 GLBs)

We have WAY more models than the current 95 interactables use. The surplus becomes the A/B variant pool:

**Furniture that can be interactive OR static (18):** bed, bookcase, chair, drawers, harp, master_bed, Piano, sofa, double_sofa, study_desk, table, wardrobe, bath, sink, toilet x3

**Small items that can be inventory objects (21):** books x3, candles x6, mug, openbooks x3, pages x6, papers, plate

**Kitchen items (20):** bowls x2, bucket, knives x3, knife_block, pan, plates x2, glasses x2, fork, spoon, butter_knife, rolling_pin, sickle, soap, wooden_board, jars x2

**Boiler/Basement (45):** gears x6, machinery x4, pipes x6, barrels x2, valves, wrenches x2, hammer, toolbox, crates x5, cage, shelves x2, ladder, debris, mattress

**Garden/Grounds (104):** benches x2, columns x3, fountain, gazebo, stone walls x4, vases x2, tower, fences, gates, trees x4, bushes x4, rocks, nature packs

**Horror (6):** doll1, doll2, bloodwraith, plague_doctor, Flesh, Flesh2

---

## Junction Map: Every Puzzle as a Diamond

### Junction 1: ATTIC ACCESS (Diamond + Swap)

**Functional slot:** `attic_access_key` — something that opens the attic door

**A-Thread (Observational Puzzle):**
- CAUSE: Lord Ashworth's diary on nightstand (master_bedroom) says "key in library globe"
- SOLUTION: Tap library globe → key inside
- Props ACTIVE: diary (openbook0.glb on table), globe (use existing globe concept)
- Props STATIC: gear display in library is just decorative

**B-Thread (Mechanical Puzzle):**
- CAUSE: A note on the study desk (library) references "the clock mechanism holds secrets"
- SOLUTION: Arrange 3 gears on a mechanism (gear_mx_4/5/6.glb) in the correct order (clue from a different note in hallway)
- Props ACTIVE: gears on desk are interactive, clock mechanism on wall
- Props STATIC: globe is just a decorative globe, diary in bedroom is personal but doesn't mention key location

**What stays the same:** The attic door is locked. You need a key. The attic contains Elizabeth's stuff. The KEY is the same item. HOW you get it changes completely.

**Models used:**
- A: openbook0.glb (diary), picture_blank.glb (globe concept)  
- B: gear_mx_4/5/6.glb (puzzle pieces), Machinery_1.glb (mechanism)

### Junction 2: HIDDEN CHAMBER ACCESS (Diamond)

**Functional slot:** `hidden_chamber_key`

**A-Thread (Doll Puzzle — emotional):**
- CAUSE: Elizabeth's letter in trunk mentions the doll talks to her
- SOLUTION: Read letter → interact with doll twice → key extracted from doll
- Props ACTIVE: doll1.glb, pages (letter), trunk
- Props STATIC: mask on wall is just creepy decor

**B-Thread (Mask Puzzle — ritual):**
- CAUSE: Binding book mentions "the vessel watches through the mask's eyes"
- SOLUTION: Take the ritual mask (mask_mx_3.glb) from the wall → place it on the hidden door's hand-shaped lock (mask fits the hand shape)
- Props ACTIVE: mask_mx_3.glb is interactive/pickable, hidden door reacts to mask
- Props STATIC: doll is just sitting there being creepy, letter exists but doesn't mention the key

**What stays the same:** Hidden chamber exists. It's locked with a hand-shaped lock. Elizabeth's final words are inside.

### Junction 3: WINE CELLAR BOX (Diamond)

**Functional slot:** `cellar_box_key` — opens the wine cellar box containing Lady Ashworth's confession

**A-Thread (Portrait Trail):**
- CAUSE: Wine note says "key is with the portrait"
- SOLUTION: Find duplicate portrait in carriage house → key behind frame
- Props ACTIVE: carriage_portrait (picture_blank_006.glb), wine note (page)
- Props STATIC: carriage house mattress is just a mattress

**B-Thread (Servant's Secret):**
- CAUSE: Cook's note in kitchen has an additional line: "I hid the spare key under the loose stone by the hearth"
- SOLUTION: Examine kitchen hearth more carefully → loose stone → key
- Props ACTIVE: hearth is interactive at a different spot, kitchen has a flagstone
- Props STATIC: carriage house portrait is just a painting, no key behind it

### Junction 4: JEWELRY BOX (Diamond)

**Functional slot:** `jewelry_box_key`

**A-Thread (Crypt Path):**
- CAUSE: Lady's note in crypt: "I hid the locket key here"
- SOLUTION: Loose flagstone in crypt → key
- Current default path

**B-Thread (Garden Path):**
- CAUSE: The white lily in the garden — examine it more carefully on B-thread → "buried in the warm soil, a tiny brass key"
- SOLUTION: Dig at the lily → key was buried with the flower
- Props ACTIVE: garden lily is interactive and yields key
- Props STATIC: crypt flagstone is just a stone

**Narrative resonance:** A = Lady Ashworth hid it with the dead. B = Elizabeth hid it with the living. Both are emotionally coherent.

### Junction 5: CRYPT GATE (Diamond)

**Functional slot:** `crypt_gate_key`

**A-Thread (Greenhouse):**
- Terra cotta pot next to lily → key in soil (current default)

**B-Thread (Chapel):**
- Baptismal font — reach into the unfrozen water → key at the bottom
- The water that won't freeze also holds a key that won't rust

**Note:** On B-thread, the font ALSO gives blessed water (the ritual component). Two items from one interaction. On A-thread, the font only gives water.

### Junction 6: COUNTER-RITUAL (Swap — entirely different final puzzle)

**Functional slot:** `free_elizabeth`

**A-Thread (Ritual of Reversal):**
- Collect 6 components (doll, book, water, hair, confession, final note)
- 3-step sequence at ritual circle: place doll, pour water, read book
- "Elizabeth Ashworth. Born in light. Free."
- Current default

**B-Thread (Ritual of Forgiveness):**
- Collect 4 different components: Lady's confession, Lord's diary, Elizabeth's letter, the porcelain doll
- 3-step sequence: place the three written documents around the doll
- Read each one aloud (tap each in sequence)
- "They were afraid. She was alone. But she forgives."
- Different emotional arc — forgiveness vs liberation

**What stays the same:** You perform a ritual in the hidden chamber. Elizabeth is freed. The ending plays.

---

## Self-Contained A/B Swap Puzzles (Within-Room)

These are puzzles that exist entirely within one room. The needle determines WHICH puzzle that room contains.

### Swap 1: Foyer — Clock vs Mirror

**A-Puzzle: The Clock Puzzle**
- The grandfather clock is interactive in a DEEPER way
- Tap the clock face → clock hands can be moved
- Setting the clock to a specific time (clue from elsewhere) triggers a hidden compartment
- Compartment contains: a small clue item (doesn't affect main puzzles)
- Models: clock concept (existing), openbook with clue

**B-Puzzle: The Mirror Puzzle**
- The mirror is interactive in a DEEPER way
- At a specific game state, tapping the mirror shows Elizabeth reflected
- You must tap specific spots on the mirror in sequence (where Elizabeth points)
- Completing the sequence: mirror swings open, reveals a hidden letter
- Models: mirror concept (existing), page (letter)

**Neither affects the main puzzle chain.** Both reward with flavor narrative that enriches the story but isn't required. This is the "optional depth" layer.

### Swap 2: Boiler Room — Pipes vs Electrical

**A-Puzzle: Pipe Valve Sequence**
- 3 valves (Valve.glb) on pipes must be turned in sequence
- Correct sequence: listen for the right sound (pitch changes)
- Reward: pipes carry Elizabeth's voice more clearly → bonus dialogue
- Models: Valve.glb, Pipe_V1/V2 (already present)

**B-Puzzle: Electrical Panel**
- The electrical equipment (electrical_equipment_1/2.glb) is a fuse box
- Rearrange fuses to restore power to the house
- Reward: lights in certain rooms get brighter, revealing previously hidden details
- Models: electrical_equipment_1/2.glb, machinery

### Swap 3: Garden — Fountain vs Gazebo

**A-Puzzle: Frozen Fountain**
- The fountain (fountain01_round.glb) has inscriptions under the ice
- Thaw the ice (use a warm item — candle? grease canister?) → read inscription
- Inscription is a clue for another puzzle

**B-Puzzle: Gazebo Lattice**
- The dead vines on the gazebo (gazebo.glb) form a pattern when viewed from the right angle
- Stand at a specific spot → the vine pattern reveals a symbol
- Symbol is the same clue delivered differently

---

## Balance Analysis

### Content Per Thread

| Category | A-Thread | B-Thread | Shared (always) |
|----------|----------|----------|-----------------|
| Interactive set pieces | ~50 | ~50 | ~30 (always interactive) |
| Static props | ~50 | ~50 | ~200+ (always static) |
| Inventory items | 10-12 | 10-12 | 0 (all items are A or B) |
| Puzzles (diamond) | 6 paths | 6 paths | 0 (all puzzles have A/B) |
| Puzzles (swap) | 3 | 3 | 0 |
| Documents/notes | ~15 | ~15 | ~10 (flavor text, always present) |
| Dialogue variants | ~50 | ~50 | ~40 (unchanged observations) |

### Content We Need to CREATE for B-Thread

The A-thread is essentially our current game. B-thread needs:

**New interactable behaviors (code):**
1. Gear arrangement puzzle in library (B-thread attic key)
2. Mask-on-door puzzle in attic storage (B-thread hidden key)
3. Kitchen hearth flagstone interaction (B-thread cellar key)
4. Lily digging interaction (B-thread jewelry key)
5. Font deeper interaction yielding key + water (B-thread crypt gate)
6. Forgiveness ritual sequence (B-thread counter-ritual)
7. Clock hand manipulation (swap puzzle foyer)
8. Mirror tap sequence (swap puzzle foyer)
9. Pipe valve sequence (swap puzzle boiler)
10. Electrical fuse puzzle (swap puzzle boiler)
11. Fountain thaw interaction (swap puzzle garden)
12. Gazebo perspective puzzle (swap puzzle garden)

**New dialogue text (writing):**
- B-thread variants for ~50 interactables (alternate descriptions that reference B-thread items)
- B-thread clue texts (diary doesn't mention globe, instead study desk note mentions gears)
- B-thread puzzle hint chains
- B-thread response conditionals

**New models needed: ZERO.** Every B-thread puzzle uses models we already have:
- Gears: gear_mx_4/5/6.glb ✓
- Mask: mask_mx_3.glb ✓
- Valves: Valve.glb ✓
- Electrical: electrical_equipment_1/2.glb ✓
- Fountain: fountain01_round.glb ✓
- Gazebo: gazebo.glb ✓
- All inventory items are existing GLBs (mug, candle, plate, page, book, etc.)

**New audio needed: MINIMAL.**
- Gear clicking SFX (can use impact/click from existing packs)
- Valve turning SFX (can use impact/metal)
- Electrical buzz (can use horror/glitch)
- Water splash (can use ambient sounds)

### What's the TOTAL content?

| | Current Game (no weaving) | With A/B Weaving |
|--|--------------------------|------------------|
| Interactable declarations | ~95 | ~160 (65 new B-thread) |
| Dialogue text entries | ~95 | ~190 (95 new B-variants) |
| Puzzle definitions | 6 | 6 diamonds + 3 swaps = 15 variant paths |
| Junction declarations | 0 | 9 |
| Inventory items | 10 | ~20 (10 A-exclusive + 10 B-exclusive, filling same functional slots) |
| Unique playthroughs | 1 | 2^9 = 512 (9 junctions) |
| GLB models used | ~50 of 376 | ~120 of 376 (still 256 unused!) |
| Room scenes | 20 | 20 (same rooms, different active interactables) |

---

## Playthrough: A-Thread Fiona (Seed: 0xA)

Same as current game. Globe puzzle, doll puzzle, portrait key, crypt flagstone, greenhouse pot, ritual of reversal. Everything we already designed.

## Playthrough: B-Thread Sam (Seed: 0xB)

**Front Gate:** Same. Gate, bench, luggage. No junction here — it's the entry.

**Foyer:** Mirror puzzle is ACTIVE (swap). Clock is just a clock (still says 3:33, but no deeper puzzle). Sam taps the mirror, notices Elizabeth's reflection pointing at spots. Files that away for later.

**Parlor:** Torn diary page is DIFFERENT on B-thread. Instead of "whispers from the attic... she calls to them at night" it reads: "The mask watches. Edmund brought it from the occultist. It has her eyes now." Same flag set: `found_first_clue`. Same phase transition. Different narrative flavor pointing toward the MASK not the DOLL.

GAP FOUND: The diary page is the FIRST MAJOR CLUE. If A-thread and B-thread diary text is different, the EMOTIONAL SETUP for the entire game diverges here. A-thread: Elizabeth is a crying child calling out. B-thread: Elizabeth is bound into a ritual mask. Both are true (she's in the doll AND the mask), but the emphasis shifts.

This is actually GOOD — it means repeat playthroughs feel genuinely different emotionally, not just mechanically.

**Kitchen:** On B-thread, the cook's note has an extra line about the hearth. Sam examines the hearth more carefully — finds a loose stone — finds the cellar key. He doesn't need the carriage house portrait at all.

**Library:** The globe is just a globe. But the gears on the desk are arranged wrong. A note on the study desk says "the key turns only when the teeth align — smallest to largest, left to right." Sam arranges the gears. Click. A drawer opens. Attic key.

The PUZZLE FEEL is completely different — A-thread was "follow the clue to the hiding spot" (Myst observational). B-thread is "understand the mechanism and solve it" (Myst mechanical). Same room, same reward, radically different gameplay.

**Upper Hallway:** Attic door still locked. Same. Sam uses the key from the gear puzzle. Works — same functional slot.

**Attic Storage:** The doll is there. Creepy. Static. But the MASK on the wall — on B-thread, it's interactive. Elizabeth's letter (still present) says: "The mask sees what I see. It has my eyes." Sam picks up the mask. Brings it to the hidden door's hand-shaped lock. The mask fits the hand shape (the occultist's binding tool fits the occultist's lock). Door opens.

**Hidden Chamber:** Same. Elizabeth's final note. Same truth. Same emotional climax. But on B-thread, the RITUAL is different — forgiveness instead of reversal. Sam places the three written confessions around the doll. Reads each. "They were afraid. She was alone. But she forgives."

DIFFERENT EMOTIONAL RESOLUTION. A-thread is cathartic (she's FREED through counter-magic). B-thread is reconciliatory (she FORGIVES through truth-telling). Same game. Same house. Profoundly different experience.

---

## Gaps Found in Weave Playtest

### Critical

| # | Gap | Fix |
|---|-----|-----|
| W1 | InteractableDecl needs `thread_variant` field | Add `@export var thread_variant: String = ""` — empty = always active, "A"/"B" = conditional |
| W2 | Items need `functional_slot` for cross-variant matching | Add `@export var functional_slot: String = ""` to ItemDeclaration |
| W3 | Lock checks need to match on functional_slot, not just item_id | interaction_engine checks: `has_item_with_slot(functional_slot)` OR `has_item(key_id)` |
| W4 | JunctionDecl and VariantDecl resources needed | New resource types in WorldDeclaration |
| W5 | PRNG engine resolves junctions, patches room declarations | prng_engine takes seed → resolves 9 junctions → sets `thread_variant` active/static per interactable |
| W6 | Dialogue text needs per-thread variants | ResponseDecl already has conditions — thread state is just another condition: `"thread == A"` |

### Important

| # | Gap | Fix |
|---|-----|-----|
| W7 | Swap puzzles need NEW puzzle logic (gear arrangement, valve sequence, etc.) | New PuzzleStepDecl types: "arrange", "sequence", "perspective" |
| W8 | B-thread clue texts need writing (~95 new text entries) | Content work, not architecture |
| W9 | Balance verification — each thread must be solvable independently | Test generator validates: for each junction resolution, all puzzles remain solvable |

### Not a Gap (works already)

- Thread state is just a state variable: `thread = "A"` or `thread = "B"` per junction
- ResponseDecl conditions already support: `"thread_j1 == A AND knows_full_truth"`
- Room geometry is identical on both threads (same walls, same floor)
- Props marked `thread_variant = ""` are always present
- Phase transitions work the same (just different flags leading to them)
