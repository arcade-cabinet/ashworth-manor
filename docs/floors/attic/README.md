# Attic (Floor +2)

**Theme**: Hidden Truth, Elizabeth's Prison
**Ambient Darkness Range**: 0.75 - 0.9
**Access**: Requires `attic_key` from Library Globe

---

## Overview

The Attic is where the Ashworth family hid their darkest secret - their fourth child, Elizabeth. What they called "isolation for her health" was imprisonment. What they recorded as "death by consumption" was transformation. The attic is Elizabeth's prison, her sanctuary, and now her domain.

This floor represents the climax of the player's journey. All the clues gathered below converge here into horrifying clarity.

```
                    ATTIC LAYOUT (Top View)
                    
                           NORTH
                             ↑
    ┌─────────────────────────────────────────┐
    │                                         │
    │           ATTIC STORAGE                 │
    │              (14x12x4)                  │
    │                                         │
    │    [Portrait]              [Doll]       │
    │                                         │
    │              [Trunk/Note]               │
    │                                         │
    ├─────────┬───────────────────────────────┤
    │ HIDDEN  │                               │
    │ CHAMBER │◄───── locked ─────────────────│
    │ (6x6x3) │                               │
    │         │                               │
    │ [Final  │                               │
    │  Note]  │                               │
    │ [Mirror]│                               │
    └─────────┴─────────────────┬─────────────┘
                                │
                           ┌────┴────┐
                           │  ATTIC  │
                           │ STAIRS  │
                           │ (4x6x3) │
                           └────┬────┘
                                │
                             (locked)
                           to Upper
                            Hallway
                              SOUTH
```

---

## Rooms

| Room ID | Name | Dimensions | Y Position | Access |
|---------|------|------------|------------|--------|
| `attic_stairs` | Attic Stairwell | 4x6x3 | 8 | Requires `attic_key` |
| `attic_storage` | Attic Storage | 14x12x4 | 8 | From Stairwell |
| `hidden_chamber` | Hidden Chamber | 6x6x3 | 8 | Requires `hidden_key` |

---

## Atmospheric Progression

```
           BRIGHT                                        DARK
             │                                             │
  Attic      │                                             │
  Stairs ────┼─────────────────────────────────────────│──│
  (0.75)     │                                          │  │
             │                                          │  │
  Attic      │                                          │  │
  Storage ───┼───────────────────────────────────────│──│──│
  (0.8)      │                                        │  │  │
             │                                        │  │  │
  Hidden     │                                        │  │  │
  Chamber ───┼──────────────────────────────────────│──│──│──│
  (0.9)      │                                       │  │  │  │
             │              DARKEST ROOM IN MANSION  │  │  │  │
```

The hidden chamber has the highest ambient darkness in the mansion - 0.9. The player can barely see. This is Elizabeth's space, where light was denied her.

---

## Color Palette

### Attic Stairwell
- **Walls**: Cracked Plaster (off-white, water stains)
- **Floor**: Rough Wood (unpainted)
- **Ceiling**: Exposed Rafters
- **Mood**: Transition, degradation

### Attic Storage
- **Walls**: Bare Wood / Aged Plaster
- **Floor**: Rough Wood (gaps visible)
- **Ceiling**: Exposed Rafters (dust motes visible)
- **Mood**: Forgotten, watchful

### Hidden Chamber
- **Walls**: `plaster_drawings` - Covered in Elizabeth's drawings
- **Floor**: Bare Wood
- **Ceiling**: Low rafters
- **Mood**: Madness, revelation, presence

---

## The Drawings

Elizabeth's drawings cover every inch of the Hidden Chamber walls. They depict:

1. **The Same Figure Repeated**
   - A girl with black eyes
   - Sometimes smiling, sometimes screaming
   - Hundreds of variations

2. **The Doll**
   - Always present in drawings
   - Sometimes larger than Elizabeth
   - Eyes always watching

3. **The Family**
   - Four figures, one crossed out
   - The crossed-out one has black eyes
   - Written: "THEY MADE ME THIS"

4. **The House**
   - Seen from outside and inside
   - Eyes in the windows
   - Mouths in the walls
   - Written: "IT SEES EVERYTHING"

---

## Lighting Summary

| Room | Primary Source | Secondary | Atmosphere |
|------|---------------|-----------|------------|
| Stairs | Window (0.15) | None | Cold, thin light |
| Storage | Window (0.2) | Candle (0.25) | Pale moonlight, single candle |
| Hidden | 2 Candles (0.2 each) | None | Barely visible |

### Special Lighting Notes
- No electric or gas light reaches the attic
- Window light is cold moonlight (blueish)
- Candle in storage is near the doll (intentional)
- Hidden chamber candles feel sacrificial

---

## Narrative Threads Resolved

### Thread 1: Who is the Fourth Child?
**Resolution**: Elizabeth Ashworth, born 1880, "died" 1889
- Her portrait reveals her face
- Her letters reveal her voice
- Her drawings reveal her mind

### Thread 2: What Happened to Her?
**Resolution**: Imprisoned for what she could see
- Not sick, not dangerous
- Had second sight
- Family feared her abilities
- Bound her spirit to the house

### Thread 3: Is She Still Here?
**Resolution**: "SHE NEVER LEFT"
- Scratched into the wood
- Her presence felt throughout
- Confirmed in hidden chamber: "I am part of it forever"

### Thread 4: What Does She Want?
**Resolution**: "Find me. Free me. Or join me."
- Wants to be found (validation)
- Wants freedom (release)
- Will accept company (threat/invitation)

---

## Key Items

### The Porcelain Doll
```yaml
location: attic_storage
type: box (interactable container)
content:
  text: "A porcelain doll with cracked features. Its eyes seem to follow you. Behind it, scratched into the wood: 'SHE NEVER LEFT'"
significance:
  - The vessel from "Rituals of Binding"
  - Contains Elizabeth's bound spirit
  - Part of the counter-ritual to free her
```

### Elizabeth's Portrait
```yaml
location: attic_storage (wall)
type: painting
content:
  title: "The Fourth Child"
  text: "A young girl in a white dress clutches a porcelain doll. Her eyes have been painted over in black."
  plaque: "Elizabeth Ashworth, 1880-1889. Beloved daughter. Forgotten by none."
significance:
  - First time player sees Elizabeth
  - Eyes painted over = what she could see
  - "Forgotten by none" = bitter irony or curse
```

### Elizabeth's Unsent Letter
```yaml
location: attic_storage (trunk)
type: note
content:
  title: "Unsent Letter"
  text: "Dearest Mother, They say I'm sick but I feel fine. Father won't let me leave my room anymore. The doll talks to me now. She says I'll be here forever. I'm scared. - Your Elizabeth"
significance:
  - Elizabeth's own words
  - Proves she wasn't sick
  - Doll already communicating
  - Child's terror preserved
```

### Elizabeth's Final Words
```yaml
location: hidden_chamber
type: note
content:
  title: "Elizabeth's Last Words"
  text: "I understand now. The doll showed me. I was never sick - they were afraid of what I could see. The house has eyes. The walls have ears. And now I am part of it forever. Find me. Free me. Or join me."
significance:
  - Complete truth revealed
  - Her transformation explained
  - Player's choice presented
  - Sets up endings
```

---

## Events

### Entry Events
```yaml
event_attic_first_entry:
  trigger: First entry to attic_stairs
  conditions:
    - type: flag_not_set
      flag: entered_attic
  actions:
    - type: set_flag
      flag: entered_attic
    - type: set_flag
      flag: elizabeth_aware
    - type: play_sound
      soundId: stairs_creak_long
    - type: ambient_change
      target: whispers_distant
```

```yaml
event_storage_first_entry:
  trigger: First entry to attic_storage
  actions:
    - type: set_flag
      flag: reached_attic_storage
    - type: play_sound
      soundId: wind_through_rafters
    - type: show_observation
      text: "Something moved in the shadows beyond the window."
```

```yaml
event_hidden_chamber_entry:
  trigger: First entry to hidden_chamber
  actions:
    - type: set_flag
      flag: found_hidden_chamber
    - type: set_flag
      flag: knows_full_truth
    - type: play_sound
      soundId: childs_whisper
    - type: ambient_change
      target: elizabeth_presence
```

### Conditional Events
```yaml
event_elizabeth_appears:
  conditions:
    - type: flag_set
      flag: found_hidden_chamber
    - type: interacted
      targetId: hidden_mirror
  actions:
    - type: play_sound
      soundId: childs_laugh
    - type: flicker_lights
      duration: 2000
    - type: show_message
      content: "In the mirror, behind you, stands a girl in white. When you turn, nothing is there."
```

---

## Puzzle Flow

```
ATTIC ACCESS PUZZLE
==================

Prerequisites:
└── Find diary in Master Bedroom
    └── Learn key is in Library Globe
        └── Get attic_key from Library
            └── Unlock attic door in Upper Hallway

HIDDEN CHAMBER PATH
===================

Current declaration path:
└── Find hidden_key in Attic Storage through the doll/letter route
    └── Unlock Hidden Chamber
        └── Read Final Note
            └── Unlock ending paths
```

---

## Sound Design

### Attic Stairwell
- Stairs creak with each step (individual sounds)
- Wind audible through gaps
- Distant whisper on entry (one time)
- Own footsteps echo

### Attic Storage
- Wind through rafters (constant)
- Scratching sounds (intermittent)
- Doll area: faint music box melody
- Floorboards groan when walked on

### Hidden Chamber
- Almost complete silence
- Own breathing audible
- Elizabeth's whisper: "You found me"
- Heartbeat sound builds slowly

---

## Visual Effects

### Dust Motes
- Visible in window light beams
- Float slowly
- React to player movement (disturbed)

### Shadow Movement
- Peripheral vision shadows
- Move when not looking directly
- Suggest presence

### Mirror Effects (Hidden Chamber)
- Slight delay in reflection
- Elizabeth appears briefly
- Player's reflection has wrong expression

---

## Related Documentation

- [Attic Stairwell](./attic-stairs.md) - Complete room specification
- [Attic Storage](./attic-storage.md) - Complete room specification
- [Hidden Chamber](./hidden-chamber.md) - Complete room specification
- [Elizabeth's Story](../narrative/elizabeth.md) - Full character documentation
- [Endings](../narrative/endings.md) - Ending conditions and sequences
