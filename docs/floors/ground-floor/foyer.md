# Grand Foyer

**Room ID**: `foyer`
**Floor**: Ground (0)
**Starting Room**: Yes

---

## Room Overview

The entrance hall rises two stories high, a grand staircase sweeping upward with banisters carved with intricate vines. This is where the Ashworth family made their first impression on guests - a display of wealth, taste, and authority. Now it stands frozen, a museum to a family that vanished in the night.

---

## Specifications

### Dimensions
| Property | Value |
|----------|-------|
| Width | 12 units |
| Depth | 14 units |
| Height | 6 units |
| World Position | (0, 0, 0) |

### Materials
| Surface | Texture ID | Color/Style |
|---------|------------|-------------|
| Floor | `marble_checkered` | Black and white marble |
| Walls | `wallpaper_victorian_red` | William Morris Red (#732F26) |
| Ceiling | `plaster_ornate` | Cream with gilt details |

### Atmosphere
| Property | Value |
|----------|-------|
| Ambient Darkness | 0.4 (brightest on ground floor) |
| Fog Density | 0.005 |
| Fog Color | Warm dust |

---

## Layout Diagram

```
                    NORTH
                      ↑
    ┌─────────────────┬─────────────────┐
    │                 │                 │
    │                 │ to Parlor       │
    │    MIRROR       │    (door)       │
    │    [M]          │                 │
    │                 │                 │
    ├────────┐        │        ┌────────┤
    │ SWITCH │                 │ CLOCK  │
    │ [S]    │                 │ [C]    │
    │        │                 │        │
  W │        │   CHANDELIER    │        │ E
  E │        │      [L]        │        │ A
  S │        │                 │        │ S
  T │    ┌───┴───┐             │        │ T
    │    │ STAIRS│             │        │
    │    │ (up)  │             │        │
    │    └───────┘             │        │
    │                          │        │
    ├────────┐        │        ├────────┤
    │ to     │        │        │ to     │
    │ Kitchen│                 │ Dining │
    │ (door) │   PAINTING      │ (door) │
    │        │   [P]           │        │
    │        │   WINDOW        │        │
    └────────┴────────┬────────┴────────┘
                      │
                   SOUTH
              (Main Entrance)
```

---

## Connections

| Direction | Target Room | Type | Position | Requirements |
|-----------|-------------|------|----------|--------------|
| North | `parlor` | door | (0, 0, 7) | None |
| East | `dining_room` | door | (6, 0, 0) | None |
| West | `kitchen` | door | (-6, 0, 0) | None |
| Up | `upper_hallway` | stairs | (4, 0, -5) | None |

---

## Lighting

### Light Sources

| ID | Type | Position | Color (RGB) | Intensity | Flickering | Shadows |
|----|------|----------|-------------|-----------|------------|---------|
| `foyer_chandelier` | chandelier | (0, 5.5, 0) | (1.0, 0.85, 0.6) | 0.8 | No | Yes |
| `foyer_sconce_west` | sconce | (-5.5, 3, -3) | (1.0, 0.7, 0.4) | 0.5 | Yes | No |
| `foyer_sconce_east` | sconce | (5.5, 3, -3) | (1.0, 0.7, 0.4) | 0.5 | Yes | No |
| `foyer_window` | window | (0, 4, -6.5) | (0.6, 0.7, 0.9) | 0.3 | No | No |

### Lighting Notes
- Chandelier is the dominant source - steady and warm
- Sconces provide accent lighting with gentle flicker
- Window provides cold moonlight contrast
- **Event Potential**: Chandelier can be toggled via `entry_switch`

---

## Interactables

### 1. Portrait of Lord Ashworth
```yaml
id: foyer_painting
type: painting
position: { x: 0, y: 3, z: -6.5 }
rotation: { x: 0, y: 0, z: 0 }
scale: { x: 3, y: 2, z: 0.1 }
content:
  title: "Lord Ashworth"
  text: "The patriarch stares down with hollow eyes. His hand rests on a book titled 'Rites of Passage'."
```

**Narrative Function**: 
- Establishes Lord Ashworth as authority figure
- "Rites of Passage" hints at occult interests
- "Hollow eyes" suggests guilt or loss of soul
- First character introduction

**Visual Design**:
- Ornate gilt frame
- Dark oil painting style
- Subject in formal attire, standing
- Book visible in hand

---

### 2. Entry Mirror
```yaml
id: foyer_mirror
type: mirror
position: { x: -5.5, y: 2.5, z: 3 }
rotation: { x: 0, y: π/2, z: 0 }
scale: { x: 2, y: 3, z: 0.1 }
content:
  text: "Your reflection stares back. For a moment, you could swear it moved independently."
```

**Narrative Function**:
- Introduces mirror motif
- First hint of supernatural
- Player begins questioning perception
- Sets up progressive mirror horror

**Visual Design**:
- Full-length standing mirror
- Ornate dark wood frame
- Slightly tarnished silver

**Current Runtime Direction**:
- The foyer mirror remains an escalating supernatural motif rather than a one-off prop
- Later declaration-driven mirror beats can build on this without changing the room's role as the first perceptual breach
- Keep any stronger apparition work tied to the existing mirror progression logic, not detached cutscene behavior

---

### 3. Grandfather Clock
```yaml
id: foyer_clock
type: clock
position: { x: 5, y: 1.5, z: -4 }
rotation: { x: 0, y: -π/4, z: 0 }
scale: { x: 1, y: 2.5, z: 0.5 }
content:
  text: "The hands point to 3:33. The pendulum hangs motionless. No ticking breaks the silence."
```

**Narrative Function**:
- Establishes the "frozen moment" at 3:33 AM
- Creates uncanny silence (clock should tick)
- Every clock in house shows same time
- December 24th, 1891, 3:33 AM = the event

**Visual Design**:
- Tall mahogany case
- Roman numerals
- Visible pendulum (still)
- Moon phase dial (full moon)

**Sound Design**:
- Conspicuous absence of ticking
- **Event**: When all clocks examined, distant chime

---

### 4. Light Switch
```yaml
id: entry_switch
type: switch
position: { x: -5.5, y: 1.3, z: -5 }
rotation: { x: 0, y: π/2, z: 0 }
scale: { x: 0.1, y: 0.15, z: 0.05 }
data:
  controlsLight: foyer_chandelier
```

**Gameplay Function**:
- Toggles chandelier on/off
- Demonstrates light interaction system
- Creates player agency in environment
- Can be used to see mirror effects better

---

## Events

### On First Entry
```yaml
event_foyer_first_entry:
  id: event_intro_narration
  conditions:
    - type: flag_not_set
      flag: visited_foyer
  actions:
    - type: set_flag
      flag: visited_foyer
    - type: set_flag  
      flag: game_started
    - type: show_room_name
      duration: 3000
```

### On Clock Examination
```yaml
event_examine_clock:
  actions:
    - type: set_flag
      flag: examined_foyer_clock
    - type: show_message
      content: "The hands point to 3:33. The pendulum hangs motionless."
```

### Conditional: All Clocks Examined
```yaml
event_all_clocks:
  conditions:
    - type: flag_set
      flag: examined_foyer_clock
    - type: flag_set
      flag: examined_boiler_clock
    # ... other clocks
  actions:
    - type: play_sound
      soundId: distant_chime
    - type: show_message
      content: "All the clocks in the house chime once. 3:33."
```

---

## Puzzle Connections

### Clues Found Here
| Clue | Points To |
|------|-----------|
| Portrait's "Rites of Passage" | Occult book in Library |
| Clock at 3:33 | The frozen moment mystery |
| Mirror oddness | Elizabeth's presence |

### Items That May Be Used Here
| Item | Effect |
|------|--------|
| (none currently) | - |

---

## Atmosphere Notes

### Visual
- Grandest room in house
- High ceiling creates sense of scale
- Marble floor reflects chandelier light
- Red walls feel like arterial blood

### Audio (Future)
- Ambient: Distant settling sounds
- Footsteps: Hard click on marble
- Absent: Clock ticking (uncanny)
- Event: Chandelier crystal tinkling

### Narrative Tone
The foyer should feel like entering a museum after hours - everything in its place, beautiful and imposing, but wrong. The absence of sound is the first sign. The clock that doesn't tick. The fire that doesn't crackle. The house is holding its breath.

---

## Developer Notes

### Entry Spawn Point
When starting new game, player spawns at:
- Position: (0, 0, -5)
- Facing: North (toward stairs)
- First view: Grand staircase and chandelier

### Transition Points
- North door: Leads to parlor, standard door
- East door: Leads to dining, double doors
- West door: Leads to kitchen, service door (simpler)
- Stairs: Grand staircase, carpeted runner

### Performance Notes
- Chandelier is only shadow-casting light
- Limit shadow resolution to 512x512
- Marble floor reflection is material property, not raytracing
