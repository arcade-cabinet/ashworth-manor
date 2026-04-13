# Weave Architecture — Three-Layer Narrative Threading

> Archived design exploration.
> This document describes the superseded `Captive / Mourning / Sovereign`
> weave model. The shipped game is defined by
> [`GAME_BIBLE.md`](./GAME_BIBLE.md) and the `Adult -> Elder -> Child` route
> program instead.

## The Core Insight

The PRNG seed doesn't randomize the game. It selects a PERSPECTIVE. The same house, the same family, the same tragedy — seen through a different emotional lens.

---

## Three Layers

### Layer 1: MACRO — What is the player solving?

The seed selects one of 3 macro threads. This determines the ending the game is pulling toward and the fundamental question the player is answering.

| Thread | Question | Ending | Elizabeth Is... | House Is... |
|--------|----------|--------|----------------|-------------|
| **Captive** | How do I free her? | Freedom (ritual of reversal) | A trapped spirit | A cage |
| **Mourning** | How do I honor her? | Forgiveness (ritual of reconciliation) | A grieving soul | A memorial |
| **Sovereign** | How do I understand her? | Acceptance (ritual of recognition) | A being of power | Her instrument |

Three macro threads × the rest of the system = three fundamentally different games in the same house.

### Layer 2: MESO — What is the house saying in each room?

Each room has an emotional TONE that shifts based on the macro thread. The same room, same furniture, same layout — but the interactive elements, the dialogue text, and the atmospheric emphasis change.

| Room | Captive Tone | Mourning Tone | Sovereign Tone |
|------|-------------|---------------|----------------|
| Foyer | Iron authority. The lock on the front door. Trapped. | Faded grandeur. The clock that stopped. Time froze. | The chandelier responds to you. The house watches. |
| Parlor | Diary: "I locked the door" | Diary: "I hear her crying" | Diary: "She won't stop looking" |
| Master Bedroom | Bed unmade — he couldn't sleep from guilt | Bed unmade — he couldn't sleep from grief | Bed unmade — he couldn't sleep from fear |
| Library | Globe hides a key (she's trapped, secrets are hidden) | Binding book is front and center (the ritual, the horror of what they did) | Family tree — she scratched out her OWN name (she chose to become something else) |
| Kitchen | Cook's note: "rats that whisper names" (imprisonment) | Cook's note: "the house feels sad" (mourning) | Cook's note: "the kitchen knows when someone's hungry" (sentience) |
| Attic Storage | Doll is a prison (vessel, binding) | Doll is a companion (she talked to it, it listened) | Doll is a tool (she put herself in it deliberately) |
| Hidden Chamber | "Find me. Free me." | "Forgive them. Forgive me." | "I chose this. Understand why." |

### Layer 3: MICRO — How does each interactable express it?

Every interactable has 3 faces — one per macro thread. Only the thread-selected face is active. The models are THE SAME. The text changes. What's interactive vs static changes.

---

## Mathematical Analysis

### How many junctions do we need?

**Macro selection:** 1 junction, 3 options (Captive / Mourning / Sovereign)

**Per-puzzle diamonds:** 6 puzzles × 2 paths each = 6 binary junctions
But now these aren't random A/B — they're THEMATICALLY COHERENT with the macro thread:
- Captive thread → puzzles emphasize finding KEYS and UNLOCKING
- Mourning thread → puzzles emphasize finding LETTERS and UNDERSTANDING
- Sovereign thread → puzzles emphasize finding MECHANISMS and CONTROLLING

So the 6 puzzle diamonds aren't independent binary choices. They're 6 puzzles each with 3 variants = 3 configurations (not 2^6).

**Swap puzzles (self-contained):** 3 rooms × 3 variants each = 3 configurations
Again, not independent — the swap puzzle in the foyer matches the macro thread.

**Total unique configurations:** 3 (macro) × 1 (puzzle set follows macro) × 1 (swaps follow macro) = **3 major variants**

But WAIT — that's only 3 playthroughs. We wanted more.

### The diamond within the diamond

Here's where the depth comes in. Within each macro thread, the 6 puzzle PATHS can still vary. The Captive thread always ends with "Free Elizabeth" — but the specific path through the puzzles can differ:

- Captive/Path-A: Globe → Doll → Portrait → Crypt → Greenhouse → Full Ritual
- Captive/Path-B: Gears → Mask → Hearth → Lily → Chapel → Full Ritual

Same macro thread (Captive), same ending (Freedom), but different puzzle experiences.

So the structure is:

```
Macro Thread (3 options)
  └── Puzzle Path (2 options per macro = 2 sub-variants)
       └── Swap Puzzles (2 options per room, 3 rooms = 8 combinations)
```

**Total: 3 × 2 × 8 = 48 unique playthroughs**

Is 48 the sweet spot? Let's think about what "discovering something new" means.

### Discovery freshness analysis

A player completes the game. Starts again. What do they discover?

**After playthrough 1 (any thread):**
- They know the house layout (20 rooms) — SAME always
- They know Elizabeth's story (the core facts) — SAME always
- They know ONE puzzle path through 6 puzzles — DIFFERENT next time
- They saw ONE emotional framing of every room — DIFFERENT next time
- They solved ONE set of swap puzzles — DIFFERENT next time
- They saw ONE ending — DIFFERENT next time

**After playthrough 2 (different macro thread):**
- The ROOMS feel different (same furniture, different emphasis)
- The DIALOGUE is different (same characters, different emotional weight)
- The PUZZLES are different (same functional outcome, different mechanics)
- The ENDING is different (same girl freed/forgiven/understood)
- But they know the LAYOUT — the house is familiar. Like returning to a real place.

**After playthrough 3 (third macro thread):**
- They've now seen all three emotional perspectives on Elizabeth
- They understand the FULL story — Captive Elizabeth, Mourning Elizabeth, Sovereign Elizabeth are all TRUE SIMULTANEOUSLY
- The three endings aren't contradictory — they're three facets of the same truth
- The game rewards the third playthrough with SYNTHESIS

**After playthroughs 4-6 (same macro threads, different puzzle paths):**
- Familiar emotional framing, but NEW puzzles
- The gears puzzle instead of the globe. The mask instead of the doll.
- Discovery is now mechanical, not emotional

**After playthroughs 7-48:**
- Diminishing novelty on puzzles
- But the swap puzzles in foyer/boiler/garden keep offering fresh micro-challenges
- And the A/B props create subtle environmental differences ("wait, was that teacup always there?")

### The Sweet Spot

**3 playthroughs for the full emotional arc.** This is the primary replay value.
**6 playthroughs for all puzzle variations.** This is the secondary replay value.
**48 playthroughs for completionist exhaustion.** This is the long tail.

Most players will play 1-3 times. The 3-macro system is designed for that.
Dedicated players will play 4-6 times. The puzzle path variation is designed for that.
Completionists can find differences for 48 runs. The swap combinations are designed for that.

---

## Content Inventory Per Macro Thread

### What MUST be unique per macro thread:

| Content | Per Thread | Total (×3) |
|---------|-----------|------------|
| Parlor diary text | 1 variant | 3 |
| Ending ritual sequence | 1 variant | 3 |
| Ending text (5 lines) | 1 variant | 3 |
| Elizabeth's final note text | 1 variant | 3 |
| Hidden chamber drawing descriptions | 1 variant | 3 |
| Elizabeth's letter text | 1 variant | 3 |
| Key interactable text variants (mirrors, clocks, portraits) | ~20 | 60 |
| Room entry observation text | ~10 | 30 |

**Total unique-per-thread text: ~35 entries × 3 = 105 text variants**

### What MUST be unique per puzzle path (within a macro thread):

| Content | Per Path | Total (×2 per thread × 3 threads = ×6) |
|---------|---------|------|
| Puzzle clue text | 6 | 36 |
| Puzzle solution interaction | 6 | 36 |
| Active/static interactable toggle | ~30 | 180 flags |
| Inventory items | 10 | 60 item declarations |

### What is SHARED across all threads:

| Content | Count | Note |
|---------|-------|------|
| Room geometry | 20 rooms | Walls, floors, ceilings — always the same |
| Room layout/floorplan | 20 | Same spatial design |
| Static props | ~200 | Furniture, decor — always present |
| Lighting | ~60 lights | Same lighting rigs |
| Audio loops | 36 | Same ambient per room |
| Connections | 34 | Same room graph |
| Horror models | 6 | Same flashback figures |

**The key number: ~105 unique text entries + 36 puzzle interactions + 60 item declarations = ~200 new content pieces for the full 3-thread system.** Against 376 available GLB models (of which we currently use ~120) and 280 audio files.

We have MORE than enough assets. The work is writing text variants and declaring puzzle logic.

---

## Narrative Coherence Check

The most important thing: does each thread feel like a COMPLETE, COHERENT story?

### Captive Thread: "The House is a Cage"

**Act I (Ground Floor):** Everything is locked, sealed, stopped. The clock is frozen. The door was locked from inside. The diary says "I locked her away." The player feels TRAPPED — the house won't let them leave either.

**Act II (Upper Floor + Basement):** Keys, keys everywhere. Every puzzle is about finding keys to locked things. The binding book describes how to TRAP a spirit. The family tree shows a name SCRATCHED OUT — erased, imprisoned in memory.

**Act III (Attic):** Elizabeth's prison. The doll is her VESSEL — she's trapped inside it. The hidden chamber is another locked room. The ritual is about BREAKING the binding — counter-magic, reversal, liberation.

**Ending:** "Elizabeth Ashworth. Born in light. Free." The cage opens. Light floods in. She leaves.

### Mourning Thread: "The House is a Memorial"

**Act I (Ground Floor):** Everything is preserved, frozen in grief. The clock stopped at the moment they lost her. The diary says "I hear her crying." The fire is dying. The mourning dress. The untouched tea cup.

**Act II (Upper Floor + Basement):** Letters, confessions, unsent words. Every puzzle involves finding WRITTEN TRUTHS. Lady Ashworth's guilt. Lord Ashworth's grief. The cook's sympathy. Helena Pierce's unknowing victimhood.

**Act III (Attic):** Elizabeth's belongings. A child's clothes folded by someone who cared. The letter she wanted to send to her mother. The hidden chamber — not a prison but a shrine she built to process what was done to her.

**Ending:** "They were afraid. She was alone. But she forgives." The documents burn. The drawings fade. Peace.

### Sovereign Thread: "The House is Her Instrument"

**Act I (Ground Floor):** The house is ALIVE. The lamp breathes. The mirror moves independently — not late, but looking WHERE IT WANTS. The clock didn't stop — it was STOPPED. By her.

**Act II (Upper Floor + Basement):** Mechanisms, gears, machines. Elizabeth didn't just have "second sight" — she understood systems. She understood the house as a machine. Every puzzle involves OPERATING mechanisms she designed or repurposed.

**Act III (Attic):** The mask puzzle. Elizabeth put herself into the mask — not because she was forced, but because the mask SEES what she wanted to see. The doll was a decoy. The real vessel was the house itself. She IS the house.

**Ending:** "I chose this. The house has eyes because I gave it eyes. The walls have ears because I gave them ears. I am not trapped. I am HOME." The drawings don't fade — they GLOW. Elizabeth doesn't leave. She WELCOMES you.

---

## Declaration Changes Needed

### WorldDeclaration additions:

```gdscript
# Macro thread — determined by PRNG seed
@export var macro_threads: Array[MacroThread] = []  # 3 threads

# Junctions — where the needle passes through
@export var junctions: Array[JunctionDecl] = []
```

### MacroThread:

```gdscript
class_name MacroThread
extends Resource

@export var thread_id: String = ""           # "captive", "mourning", "sovereign"
@export var display_name: String = ""        # Hidden from player, for dev reference
@export var question: String = ""            # "How do I free her?"
@export var elizabeth_nature: String = ""    # "trapped spirit", "grieving soul", "being of power"
@export var house_nature: String = ""        # "cage", "memorial", "instrument"
@export var ending_id: String = ""           # Which EndingDecl this thread resolves to
@export var puzzle_path: String = ""         # "A" or "B" — default puzzle path for this thread
@export var room_tones: Dictionary = {}      # {room_id: "tone description"} — for documentation/AI reference

# Text overrides — these key texts change per macro thread
@export var diary_page_text: String = ""
@export var elizabeth_letter_text: String = ""
@export var elizabeth_final_note_text: String = ""
@export var ritual_sequence_texts: PackedStringArray = []
```

### JunctionDecl (updated):

```gdscript
class_name JunctionDecl
extends Resource

@export var junction_id: String = ""
@export var junction_type: String = ""       # "diamond" (cross-room) or "swap" (within-room)
@export var functional_slot: String = ""     # What both variants produce (e.g., "attic_access_key")

@export var variant_a: VariantDecl = null
@export var variant_b: VariantDecl = null

# Which macro threads prefer which variant (if empty, PRNG decides independently)
@export var macro_preference: Dictionary = {} # {"captive": "A", "mourning": "B", "sovereign": "A"}
```

The `macro_preference` is the key innovation. It means:
- The macro thread SUGGESTS a puzzle path, maintaining emotional coherence
- But within that suggestion, the PRNG can still flip some junctions for variety
- First playthrough of "Captive" → gets the preferred A-path puzzles
- Second playthrough of "Captive" → PRNG flips some junctions to B-path
- The emotional framing stays Captive, but the puzzles change

### InteractableDecl addition:

```gdscript
# Thread visibility — which thread(s) make this interactable active
# Empty = always active. "captive" = only on captive thread. "captive,mourning" = on both.
@export var thread_active: PackedStringArray = []

# Thread-specific text overrides (keyed by thread_id)
# If present, these REPLACE the default responses when on that thread
@export var thread_text_overrides: Dictionary = {} # {"captive": [ResponseDecl...], "mourning": [...]}
```

### ItemDeclaration addition:

```gdscript
@export var functional_slot: String = ""     # "attic_access_key", "vessel_liquid", etc.
@export var thread_active: PackedStringArray = [] # Which threads this item exists on
```

### EndingDecl (now 3, was 3 but different):

The three current endings (freedom, escape, joined) become thread-dependent:
- Freedom → Captive thread's positive ending
- Forgiveness → Mourning thread's positive ending
- Acceptance → Sovereign thread's positive ending
- Escape and Joined endings remain as failure modes on ALL threads

So total endings: 3 positive (one per thread) + 2 negative (shared) = 5

---

## Final Numbers

| Metric | Value |
|--------|-------|
| Macro threads | 3 |
| Puzzle path variants per thread | 2 |
| Swap puzzle variants per room | 2 (3 rooms) |
| Total unique configurations | 48 |
| Playthroughs for full emotional arc | 3 |
| Playthroughs for all puzzle variations | 6 |
| New text entries needed | ~200 |
| New puzzle interactions needed | ~12 |
| New item declarations needed | ~20 |
| New models needed | 0 |
| New audio needed | Minimal |
| GLB models utilized | ~160 of 376 (up from ~120) |
