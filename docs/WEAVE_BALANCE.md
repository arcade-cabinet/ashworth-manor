# Weave Balance Analysis

> Archived design exploration.
> This analysis belongs to the retired weave-era route model and is retained
> only for historical context. Do not treat it as current implementation or
> narrative truth.

How much content per thread, per room, per junction — and what needs to be written/built.

---

## Asset Inventory (Post New Packs)

| Category | Count | Source |
|----------|-------|--------|
| GLB models | 571 | Shared (131) + Per-room (229) + Horror (6) + Medieval (175) + Mansion PSX (20) |
| Audio files | 280 | Loops (36) + Tension (10) + SFX (193) + Footsteps (53) |
| Textures (standalone) | 531 | Mansion pack (65) + SBS Horror 256 (100) + SBS Horror 128 (100) + Retro doors/windows (240) + Mansion PSX (5) + Medieval (191) |
| Fonts | 19 | Cinzel (7) + Cormorant (12) |

---

## Per-Room Content Budget

Each room needs content across all 3 macro threads. Here's the budget per room:

### Static (shared across all threads — build once)
- Geometry: walls, floor, ceiling from declarations (Mansion PSX kit)
- Lighting: lights from declarations
- Static props: furniture, decor that's ALWAYS present
- Audio: ambient loop, reverb zone, footstep surface
- Connections: doors/stairs/ladders between rooms

### Thread-Variant (3 versions needed)
- ~2-5 interactables per room change behavior between threads
- Text variants: each thread-active interactable needs 1-3 response texts
- Thread-specific entry observation text
- Thread-specific conditional response text on key items

### Junction-Variant (2 paths per junction, 9 junctions)
- Active/static toggling on puzzle-related interactables
- Clue text pointing to correct location for that path
- Item placement (which room/interactable gives the key)

---

## Room-by-Room Thread Content Map

### Front Gate (Thread-Neutral)
All threads see the same front gate. Entry point, no puzzles, no thread divergence.
- Static props: gate, bench, luggage, trees, bushes, rocks, lamp
- Thread-variant interactables: 0
- New content needed: 0

### Foyer (Light Thread Variance)
- **Static always:** Chandelier, rug, stairs, drawers, coat stand, window
- **Thread-variant interactables (3):**
  - `foyer_painting`: Captive = "authority, control" / Mourning = "faded authority, guilt" / Sovereign = "eyes that watch"
  - `foyer_mirror`: Captive = "trapped reflection" / Mourning = "grief-aged reflection" / Sovereign = "reflection moves BEFORE you"
  - `entry_switch`: Same behavior all threads
- **Junction swap (Foyer):** Clock puzzle (A) vs Mirror puzzle (B) — self-contained
- **New content:** 6 text variants (2 interactables × 3 threads) + 2 swap puzzle designs
- **Medieval models to add:** Candelabra_1 (replace candle_holder), Painting_1 (Lord Ashworth frame), Long_Carpet (staircase)

### Parlor (Critical — Phase Transition Point)
- **Static always:** Fireplace, settees, rug, bottles, stool
- **Thread-variant interactables (3):**
  - `parlor_note` (diary): **3 completely different texts** — this is the first clue, sets the emotional tone
  - `parlor_painting_1` (Lady Ashworth): 3 framings of her character
  - `music_box`: Captive = "jammed" / Mourning = "broken, like her heart" / Sovereign = "waiting for the right moment"
- **New content:** 9 text variants (3 interactables × 3 threads)
- **Medieval models to add:** Candelabra_2 (table candelabra), Curtain_1/2 (heavy drapes)

### Dining Room (Moderate Thread Variance)
- **Thread-variant interactables (2):**
  - `dinner_photo`: 3 framings of the last dinner
  - `dining_wine_glass`: Captive = "poisoned?" / Mourning = "untouched, saved for someone who never came" / Sovereign = "she chose what went in the glass"
- **New content:** 6 text variants
- **Medieval models to add:** Glass_1/2, Wine_Box, Candelabra_3 (table centerpiece)

### Kitchen (Junction Point — Diamond #3 B-path)
- **Thread-variant interactables (2):**
  - `kitchen_note`: 3 cook's note variants
  - `kitchen_hearth`: On Mourning/B-path, the hearth hides the cellar key
- **Junction:** Diamond #3 B-path lives here (hearth flagstone → cellar key)
- **New content:** 6 text variants + 1 new puzzle interaction (hearth flagstone)
- **Medieval models to add:** Barrel_1, Cheese, Furnace (replace/supplement hearth)

### Upper Hallway (Junction Hub)
- **Thread-variant interactables (2):**
  - `children_painting`: 3 framings of the missing fourth child
  - `hallway_poster`: 3 phrasings of the "closed for repairs" notice
- **New content:** 6 text variants
- **Medieval models to add:** Torch_1/2 (wall torches), Banner_1 (hallway wall)

### Master Bedroom (Critical — Diary Room)
- **Thread-variant interactables (3):**
  - `diary_lord`: **3 completely different diary entries** — the second most important text divergence
  - `bedroom_mirror`: 3 mirror behaviors
  - `jewelry_box`: Same puzzle mechanics, different context text
- **Junction:** Diamond #4 variant might affect jewelry box access
- **New content:** 9 text variants + diary is heavy writing work
- **Medieval models to add:** Bed_Double_1 (replace master_bed), Curtain_2 (bed curtains), Candle_1/2

### Library (Major Junction Point — Puzzle A vs B)
- **Thread-variant interactables (4):**
  - `library_globe`: Active on A-path, static on B-path
  - `library_gears`: Static on A-path, active on B-path (interactive puzzle)
  - `binding_book`: 3 framings of the ritual text
  - `family_tree`: 3 framings of the scratched-out name
- **Junction:** Diamond #1 (attic key) — globe (A) vs gears (B)
- **New content:** 12 text variants + gear puzzle implementation
- **Medieval models to add:** Bookshelf (supplement), Scroll_1/2/3, Ink, Quill, Lectern

### Guest Room (Light Thread Variance)
- **Thread-variant interactables (1):**
  - `guest_ledger`: 3 framings of Helena Pierce's story
- **New content:** 3 text variants
- **Medieval models to add:** Bed_1, Curtain_1

### Storage Basement (Light Thread Variance)
- **Thread-variant interactables (1):**
  - `scratched_portrait`: 3 framings of the erasure
- **New content:** 3 text variants
- **Medieval models to add:** Cage_1/2 (replace basic cage), Chains_1/2, Barrel_2/3

### Boiler Room (Junction — Swap Puzzle)
- **Junction swap:** Pipe valve puzzle (A) vs Electrical fuse puzzle (B)
- **Thread-variant interactables (2):**
  - `maintenance_log`: 3 framings
  - `boiler_observation`: 3 interpretations of the warm boiler
- **New content:** 6 text variants + 2 swap puzzle implementations
- **Medieval models to add:** Furnace, Chain_Curled_1/2/3, Iron_Bars

### Wine Cellar (Junction — Diamond #3 A-path)
- **Junction:** Wine note → portrait key → box → confession
- **Thread-variant interactables (1):**
  - `wine_box` contents: 3 framings of Lady Ashworth's confession
- **New content:** 3 text variants (confession letter × 3 threads)
- **Medieval models to add:** Barrel_Shelf, Wine_Box, Bottle

### Attic Stairwell (Phase Transition — Thread Neutral)
- All threads: same transition into Horror phase
- **New content:** 0 (entry event is mechanical, not textual)

### Attic Storage (Major Junction — Puzzle A vs B)
- **Junction:** Diamond #2 (hidden key) — doll (A) vs mask (B)
- **Thread-variant interactables (4):**
  - `elizabeth_portrait`: 3 framings of Elizabeth
  - `porcelain_doll`: Active A-path, static B-path
  - `elizabeth_letter`: **3 completely different letters**
  - Mask: Static A-path, active B-path
- **New content:** 12 text variants + mask puzzle implementation
- **Medieval models to add:** Doll_1/2 (supplement horror dolls), Cage_3/4, Chains

### Hidden Chamber (Endgame — Thread Defines Ending)
- **Thread-variant interactables (3):**
  - `elizabeth_final_note`: **3 completely different final revelations**
  - `ritual_circle`: 3 different ritual sequences (freedom/forgiveness/acceptance)
  - `chamber_drawings`: 3 interpretations of Elizabeth's drawings
- **New content:** 9 text variants + 2 new ritual sequence implementations
- **Medieval models to add:** Sacrifical-Ground_1, Ouija (Sovereign thread), Holy_Vase, Orb

### Garden (Junction — Swap Puzzle + Diamond #4 B-path)
- **Junction swap:** Fountain puzzle (A) vs Gazebo puzzle (B)
- **Junction diamond:** Lily yields jewelry key on B-path
- **New content:** 2 swap puzzle implementations + 1 junction interaction
- **Medieval models to add:** Fountain_1/2, Gravestone_1/2/3 (visible from garden)

### Chapel (Junction — Diamond #5 B-path)
- **Junction:** Font yields gate key (B-path) in addition to blessed water
- **Thread-variant interactables (1):**
  - `baptismal_font`: 3 framings of the holy water
- **New content:** 3 text variants + 1 junction interaction (key in font)
- **Medieval models to add:** Cross, Cross_Post, Holy_Water (visual), Column_1/2

### Greenhouse (Junction — Diamond #5 A-path)
- **Junction:** Pot yields gate key (A-path)
- **New content:** 0 (default path, already designed)

### Carriage House (Junction — Diamond #3 A-path)
- **Junction:** Portrait yields cellar key (A-path)
- **New content:** 0 (default path, already designed)

### Family Crypt (Junction — Diamond #4 A-path)
- **Junction:** Flagstone yields jewelry key (A-path)
- **Thread-variant interactables (1):**
  - `crypt_graves`: 3 framings of the missing grave
- **New content:** 3 text variants
- **Medieval models to add:** Gravestone_1/2/3 (proper headstones!), Coffin/Coffin-Closed, Cross

---

## Total Content Budget

| Content Type | Count | Effort |
|-------------|-------|--------|
| **Thread-variant text entries** | ~90 (30 interactables × 3 threads) | Writing (heavy) |
| **Key narrative texts (diary, letter, final note)** | 9 (3 texts × 3 threads) | Writing (critical — defines each thread) |
| **Ending texts** | 6 (3 positive × 5 lines + 2 negative shared) | Writing |
| **Junction puzzle implementations** | 12 (6 diamonds × 2 paths) | Code |
| **Swap puzzle implementations** | 6 (3 rooms × 2 variants) | Code |
| **Resource class scripts** | ~20 | Code (engine foundation) |
| **Builder scripts** | ~8 (wall, floor, ceiling, door, window, stairs, trapdoor, ladder) | Code |
| **Engine scripts** | ~8 (assembler, interaction, puzzle, audio, trigger, state, prng, test_gen) | Code |
| **Room declarations** | 20 .tres files | Data entry from existing docs |
| **Item declarations** | ~30 (10 base + ~20 thread variants) | Data entry |
| **Puzzle declarations** | 6 + 3 swap = 9 | Data entry |
| **Junction declarations** | 9 | Data entry |
| **Macro thread declarations** | 3 | Data entry |
| **Medieval model placement** | ~60 models across 20 rooms | Scene assembly |
| **Mansion PSX door/window integration** | 20 rooms | Scene assembly |
| **PSX sky shader** | 1 | Code (shader) |
| **Environment declarations** | 6 (per-area presets) | Data entry |

---

## Creative Work Breakdown (for Agent Team)

### Agent 1: Narrative Writer
- 90 thread-variant text entries
- 9 key narrative texts (3 diaries, 3 letters, 3 final notes)
- 6 ending text sequences
- Estimated: ~15,000 words

### Agent 2: Engine Coder
- 20 Resource class scripts (declarations)
- 8 builder scripts (geometry generation)
- 8 engine scripts (runtime interpretation)
- 1 PSX sky shader
- Estimated: ~3,000 LOC

### Agent 3: Puzzle Designer + Coder
- 12 junction puzzle variant implementations
- 6 swap puzzle implementations
- Puzzle balance verification (all paths solvable)
- PRNG constraint validation
- Estimated: ~1,500 LOC + puzzle design docs

### Agent 4: Room Assembler (Data Entry + Model Placement)
- 20 room declaration .tres files (from existing docs)
- 30 item declarations
- 9 junction declarations
- 60 Medieval model placements across rooms
- 20 Mansion PSX door/window integrations
- 6 environment declarations

### Agent 5: Test Generator + QA
- Generate test expectations from declarations
- Validate bidirectional connections
- Validate puzzle dependency graphs per thread
- Run all 48 configurations, verify solvability
- Screenshot capture for visual QA
