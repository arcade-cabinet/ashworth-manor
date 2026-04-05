# Parlor

**Room ID**: `parlor`
**Floor**: Ground (0)

---

## Room Overview

The parlor was Lady Ashworth's domain - a space for receiving guests, afternoon tea, and maintaining social appearances. Velvet settees face a cold fireplace where family portraits line walls painted in fashionable arsenic green. The room speaks of carefully curated comfort that now feels suffocating.

---

## Specifications

### Dimensions
| Property | Value |
|----------|-------|
| Width | 10 units |
| Depth | 10 units |
| Height | 4 units |
| World Position | (0, 0, 16) |

### Materials
| Surface | Texture ID | Color/Style |
|---------|------------|-------------|
| Floor | `wood_parquet` | Warm walnut pattern |
| Walls | `wallpaper_victorian_green` | Arsenic Green (#335938) |
| Ceiling | `plaster_molding` | Cream with decorative molding |

### Atmosphere
| Property | Value |
|----------|-------|
| Ambient Darkness | 0.5 (slightly darker than foyer) |
| Fog Density | 0.006 |
| Fog Color | Warm dust |

---

## Layout Diagram

```
                    NORTH
                      ↑
    ┌─────────────────────────────────┐
    │                                 │
    │           FIREPLACE             │
    │              [F]                │
    │                                 │
    │                                 │
    │   PAINTING                      │
    │   Lady Ashworth                 │
  W │   [P1]                          │ E
  E │                                 │ A
  S │                                 │ S
  T │              [C1]      [C2]     │ T
    │             candle    candle    │
    │                                 │
    │        MUSIC BOX    NOTE        │
    │           [MB]       [N]        │
    │                                 │
    │                                 │
    └────────────────┬────────────────┘
                     │
                  (door)
                to Foyer
                   SOUTH
```

---

## Connections

| Direction | Target Room | Type | Position | Requirements |
|-----------|-------------|------|----------|--------------|
| South | `foyer` | door | (0, 0, -5) | None |

---

## Lighting

### Light Sources

| ID | Type | Position | Color (RGB) | Intensity | Flickering | Shadows |
|----|------|----------|-------------|-----------|------------|---------|
| `parlor_fireplace` | fireplace | (0, 1, 4.5) | (1.0, 0.5, 0.2) | 0.6 | Yes (slow) | Yes |
| `parlor_candle_left` | candle | (-3, 1.2, -2) | (1.0, 0.8, 0.4) | 0.3 | Yes | No |
| `parlor_candle_right` | candle | (3, 1.2, -2) | (1.0, 0.8, 0.4) | 0.3 | Yes | No |

### Lighting Notes
- Fireplace is primary source but embers are dying
- Intimate, low lighting creates sense of secrets
- **Visual**: Embers visible but weak glow
- **Event Potential**: Fire can rekindle briefly during Elizabeth events

### Fireplace Flicker Pattern
```typescript
// Slow, deep breathing pattern for dying embers
flickerPattern = {
  primaryCycle: 5.0,    // seconds
  variation: 0.06,      // ±6%
  breathingFeel: true
};
```

---

## Interactables

### 1. Portrait of Lady Ashworth
```yaml
id: parlor_painting_1
type: painting
position: { x: -4.5, y: 2, z: 0 }
rotation: { x: 0, y: π/2, z: 0 }
scale: { x: 1.5, y: 2, z: 0.1 }
content:
  title: "Lady Ashworth"
  text: "She wears a black mourning dress despite this being painted before any family deaths. Prescient or cursed?"
```

**Narrative Function**:
- Introduces Lady Ashworth's character
- Foreshadowing: Mourning dress before deaths
- Suggests she knew what was coming
- Complicit in Elizabeth's fate?

**Visual Design**:
- Formal portrait, seated pose
- Black dress stark against green wall
- Expression: Distant, resigned
- Hands folded (hiding something?)

**Color Symbolism**:
- Black mourning against arsenic green
- Death in a poison garden
- Beauty concealing danger

---

### 2. Torn Diary Page (CRITICAL CLUE)
```yaml
id: parlor_note
type: note
position: { x: 2, y: 0.8, z: 2 }
rotation: { x: -0.2, y: 0.5, z: 0 }
scale: { x: 1, y: 1, z: 1 }
content:
  title: "Torn Diary Page"
  text: "The children have been hearing whispers from the attic again. I've locked the door but they say she still calls to them at night..."
```

**Narrative Function**:
- **FIRST MAJOR CLUE** about Elizabeth
- Establishes "she" in the attic
- Shows family was actively hiding her
- Children heard her - she tried to reach them

**Visual Design**:
- Yellowed paper, torn edge
- Handwritten in Lady Ashworth's script
- Ink slightly faded
- Found on side table, as if dropped

**Story Implications**:
- "Whispers" - Elizabeth trying to communicate
- "Locked the door" - active imprisonment
- "Calls to them at night" - supernatural element beginning
- Children were aware (will they appear in future?)

---

### 3. Music Box
```yaml
id: music_box
type: box
position: { x: 3, y: 1, z: -2 }
rotation: { x: 0, y: 0.2, z: 0 }
scale: { x: 0.4, y: 0.3, z: 0.3 }
data:
  locked: false
  content: "A delicate music box with a dancing ballerina. It doesn't play when opened - the mechanism is jammed."
```

**Narrative Function**:
- Belonged to Elizabeth (implied)
- Currently broken/silent
- Will play during Elizabeth events
- Elizabeth's melody motif

**Visual Design**:
- Ornate wooden box with inlay
- Tiny ballerina figure inside
- Mechanism visible but stuck
- Slight dust on surface

**Future Development**:
```yaml
event_music_box_plays:
  conditions:
    - type: flag_set
      flag: elizabeth_aware
    - type: room_visited
      roomId: attic_storage
  actions:
    - type: play_sound
      soundId: elizabeth_melody
    - type: show_message
      content: "The music box begins to play on its own. A lullaby you've never heard before."
```

---

## Events

### On First Entry
```yaml
event_parlor_first_entry:
  conditions:
    - type: flag_not_set
      flag: visited_parlor
  actions:
    - type: set_flag
      flag: visited_parlor
    - type: play_sound
      soundId: fire_crackle_low
```

### On Reading Diary Page
```yaml
event_read_diary_page:
  conditions:
    - type: flag_not_set
      flag: found_first_clue
  actions:
    - type: set_flag
      flag: found_first_clue
    - type: set_flag
      flag: knows_attic_girl
    - type: show_message
      content: "Someone was locked in the attic. Someone who called out to the children..."
```

### Conditional: Music Box Plays
```yaml
event_music_box_plays:
  conditions:
    - type: flag_set
      flag: elizabeth_aware
  actions:
    - type: play_sound
      soundId: music_box_melody
    - type: change_light
      targetId: parlor_fireplace
      intensity: 0.2
    - type: delay
      delayMs: 3000
    - type: change_light
      targetId: parlor_fireplace  
      intensity: 0.6
```

---

## Puzzle Connections

### Clues Found Here
| Clue | Points To |
|------|-----------|
| Diary page: "whispers from attic" | Someone locked above |
| Diary page: "she still calls" | Supernatural presence |
| Lady's mourning dress | Knew about coming deaths |
| Music box | Elizabeth's personal item |

### Clues Needed For Here
| Clue | Source |
|------|--------|
| (none - entry level room) | - |

---

## Atmosphere Notes

### Visual
- Intimate compared to foyer
- Furniture arranged for conversation
- Heavy velvet drapes block windows
- Green walls feel like being inside a leaf

### Audio (Future)
- Ambient: Fire crackling (low, dying)
- Footsteps: Soft on parquet
- Event: Music box melody
- Whispers at edge of hearing (after certain flags)

### Narrative Tone
The parlor is Lady Ashworth's prison of propriety - a space designed for performance. The diary page, found carelessly, is the first crack in the facade. Here, the player begins to understand that the family was hiding something terrible, and that Lady Ashworth knew.

The dying fire is a metaphor: warmth leaving the house, comfort becoming cold, the facade failing.

---

## Color Language

### Arsenic Green Wallpaper
Victorian "arsenic green" (Scheele's Green) was a popular color that literally killed people - the arsenic in the dye released toxic fumes. The parlor's green walls are:
- Historically accurate
- Symbolically potent: beauty that poisons
- Lady Ashworth's space: she chose this color
- The family's nature: attractive on surface, deadly beneath

### Fireplace Orange vs. Green
- Warm orange light against poison green
- Life fighting against death
- Comfort versus danger
- Both present, neither winning

---

## Developer Notes

### Entry Point
When entering from foyer:
- Position: (0, 0, -4)
- Facing: North (toward fireplace)
- First view: Dying fire, Lady's portrait visible on left

### Furniture Layout (Future)
```
Planned furniture:
- Two velvet settees facing fireplace
- Side tables with candelabras
- Small writing desk (Lady's)
- Persian rug (6x4 area)
- Occasional chairs
- Tea service on table
```

### Sound Design Priority
- Fire crackling is essential atmospheric element
- Music box melody is key narrative audio
- Footsteps should be softer than marble foyer
- Clock should NOT tick here either
