# Deep Basement (Floor -2)

**Theme**: Ancient Depths, Buried Secrets
**Ambient Darkness Range**: 0.85
**Access**: Ladder from Storage Basement

---

## Overview

The Deep Basement is the lowest point in Ashworth Manor - both physically and spiritually. Here, beneath layers of stone, the family buried their darkest secrets. The Wine Cellar is the only current room, but the space feels larger than it appears, as if passages might lead to places best left unexplored.

```
                    DEEP BASEMENT LAYOUT (Top View)
                    
                           NORTH
                             ↑
    ┌─────────────────────────────────────────┐
    │                                         │
    │             WINE CELLAR                 │
    │              (8x10x3)                   │
    │                                         │
    │    [Wine Racks]           [Wine Racks]  │
    │                                         │
    │         [Inventory Note]                │
    │                                         │
    │              [Locked Box]               │
    │                                         │
    │                                         │
    │              LADDER ────────────────────│
    │               (up)                      │
    │                                         │
    └─────────────────────────────────────────┘
                   
                      │
                      │ ladder (up)
                      ▼
               To STORAGE BASEMENT
                    (Floor -1)
```

---

## Rooms

| Room ID | Name | Dimensions | Y Position | Connections |
|---------|------|------------|------------|-------------|
| `wine_cellar` | Wine Cellar | 8x10x3 | -6 | Storage Basement |

---

## Narrative Purpose

The Wine Cellar serves as:

1. **Lowest Physical Point**: Deepest the player can go (until Elizabeth)
2. **Isolation**: Only one way in, one way out
3. **Mystery**: Hints at hidden alcoves, more secrets
4. **Optional Depth**: Rewards exploration but not required for main path

---

## Atmospheric Design

### The Deepest Dark

```
              Surface (Foyer)
                   │
                   │ ─────── Light: Bright
                   ▼
              Upper Floor
                   │
                   │ ─────── Light: Moderate
                   ▼
              Ground Floor
                   │
                   │ ─────── Light: Variable
                   ▼
              Basement (-1)
                   │
                   │ ─────── Light: Dim
                   ▼
           Deep Basement (-2)
                   │
                   │ ─────── Light: MINIMAL
                   ▼
                   
         ambientDarkness: 0.85
         (Second darkest after Hidden Chamber)
```

### Sensory Experience

**Visual**:
- Torch light only (warm but limited)
- Wine racks create vertical shadows
- Stone everywhere - no warmth
- Darkness beyond torch reach

**Audio**:
- Complete silence broken by:
  - Torch crackle
  - Own footsteps (loud)
  - Distant drip
  - Own breathing (implied)

**Feeling**:
- Weight of house above
- Isolation from surface
- Being watched from darkness
- Ancient, undisturbed

---

## Wine Cellar Specification

### Dimensions
| Property | Value |
|----------|-------|
| Width | 8 units |
| Depth | 10 units |
| Height | 3 units (low ceiling) |
| World Position | (0, -6, 0) |

### Materials
| Surface | Texture ID | Color/Style |
|---------|------------|-------------|
| Floor | `stone_dark` | Ancient flagstone |
| Walls | `stone_rough` | Rough-hewn stone |
| Ceiling | `stone_dark` | Low, oppressive |

### Atmosphere
| Property | Value |
|----------|-------|
| Ambient Darkness | 0.85 (very dark) |
| Fog Density | 0.008 |
| Fog Color | Cold grey |

---

## Lighting

| ID | Type | Position | Color (RGB) | Intensity | Flickering |
|----|------|----------|-------------|-----------|------------|
| `cellar_torch_west` | torch | (-3.5, 2.2, 0) | (1.0, 0.6, 0.2) | 0.6 | Yes |
| `cellar_torch_east` | torch | (3.5, 2.2, 0) | (1.0, 0.6, 0.2) | 0.6 | Yes |

### Torch Behavior
```typescript
// Torches have more aggressive flicker than candles
flickerPattern = {
  primaryCycle: 3.0,    // faster
  variation: 0.08,      // more variation
  randomSpike: true,    // occasional bright flare
  spikeChance: 0.02     // 2% per frame
};
```

---

## Interactables

### 1. Wine Inventory Note
```yaml
id: wine_note
type: note
position: { x: -3, y: 1.5, z: -4 }
rotation: { x: 0, y: 0, z: 0 }
scale: { x: 1, y: 1, z: 1 }
content:
  title: "Inventory List - 1887"
  text: "The 1872 Bordeaux has been moved to the hidden alcove. Master insists no one shall find it. The key is with the portrait."
```

**Narrative Function**:
- References "hidden alcove" (future content?)
- "The key is with the portrait" - which portrait?
- Lord Ashworth hiding things even from servants
- Date: 1887 (before Elizabeth's official death)

**Puzzle Connection**:
- May hint at cellar_key location
- "The portrait" could be:
  - Lord Ashworth (Foyer)
  - Elizabeth (Attic - circular)
  - Another hidden portrait

### 2. Locked Box
```yaml
id: wine_box
type: box
position: { x: 2, y: 0.5, z: -3 }
rotation: { x: 0, y: 0.3, z: 0 }
scale: { x: 1, y: 1, z: 1 }
data:
  locked: true
  keyId: cellar_key
```

**Contents (Planned)**:
- Lady Ashworth's confession letter?
- Counter-ritual component?
- Elizabeth's christening record?

**Visual Design**:
- Wooden chest, iron bands
- Heavy padlock
- Dust undisturbed

---

## Events

### Entry Events
```yaml
event_wine_cellar_first_entry:
  trigger: First entry
  conditions:
    - flag_not_set: visited_wine_cellar
  actions:
    - set_flag: visited_wine_cellar
    - set_flag: reached_deepest
    - play_sound: descent_complete
    - ambient_change: deep_silence
    - show_observation: "The weight of the house presses down. You are far from daylight."
```

### Conditional Events
```yaml
event_cellar_presence:
  trigger: 60 seconds in wine cellar
  conditions:
    - flag_set: elizabeth_aware
    - flag_not_set: cellar_presence_triggered
  actions:
    - set_flag: cellar_presence_triggered
    - change_light:
        targetId: cellar_torch_west
        intensity: 0.2
    - delay: 1000
    - change_light:
        targetId: cellar_torch_west
        intensity: 0.6
    - show_observation: "The torch guttered. As if something passed between you and the flame."
```

### Locked Box Events
```yaml
event_try_wine_box_locked:
  trigger: Interact with wine_box (no key)
  conditions:
    - lacks_item: cellar_key
  actions:
    - show_message: "The box is locked with a heavy padlock."
    - play_sound: lock_rattle

event_open_wine_box:
  trigger: Interact with wine_box (has key)
  conditions:
    - has_item: cellar_key
  actions:
    - unlock: wine_box
    - give_item: [contents TBD]
    - set_flag: opened_wine_box
    - show_message: "The lock opens with a reluctant click. Inside you find..."
    - play_sound: chest_open
```

---

## Environmental Storytelling

### Wine Rack Details
- Most bottles covered in dust (undisturbed)
- A few bottles removed (recently? No dust in gaps)
- Labels visible: French wines, 1860s-1880s
- One section collapsed (age or... something else?)

### Floor Details
- Flagstones uneven (ancient)
- One stone slightly raised (hidden passage hint?)
- Footprints in dust lead to... wall?

### Wall Details
- Rough-hewn stone (predates house?)
- One section smoother (newer repair?)
- Water stains suggesting this floods?

---

## Future Development Ideas

### Hidden Alcove
The inventory note mentions a "hidden alcove." This could be:
- Behind false wine rack section
- Under the raised flagstone
- Through the suspiciously smooth wall section

**Access Method**: Find hidden lever? Move specific bottles?

### What's In The Alcove?
- The 1872 Bordeaux (MacGuffin?)
- Hidden passage to...?
- Counter-ritual component
- Lord Ashworth's occult workspace

### Connection to Sub-Basements?
Victorian manors sometimes had multiple basement levels:
- Coal storage
- Ice house
- Root cellar
- And darker things...

---

## Sound Design Priority

### Essential Sounds
1. Torch crackle (constant, subdued)
2. Footsteps on stone (echo)
3. Silence (oppressive, broken only by above)
4. Distant drip (irregular)

### Event Sounds
1. Torch gutter (when presence passes)
2. Lock mechanisms (box, potential hidden doors)
3. Bottle clink (if player disturbs rack)
4. Stone grinding (if secret door implemented)

### Absence of Sound
The wine cellar should feel acoustically dead. Sound doesn't carry well in stone basements. The player's own sounds should feel absorbed by the darkness.

---

## Color Language

### Cold Stone
- No color - just greys and dark browns
- Torch light provides only warmth
- Represents: Buried truth, foundation, what lies beneath

### Wine as Blood
- Red wine visible in bottles
- Same color as foyer walls (blood/authority)
- Lord Ashworth's secrets aged like wine
- Something preserved below

---

## Related Documentation

- [Wine Cellar](./wine-cellar.md) - Complete room specification
- [Cellar Key Puzzle](../puzzles/README.md#puzzle-wine-cellar-secret-planned) - Planned puzzle
- [Basement Floor](../basement/README.md) - Connected floor above
