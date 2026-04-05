# Basement (Floor -1)

**Theme**: Service and Secrets, Beneath the Surface
**Ambient Darkness Range**: 0.7 - 0.75
**Access**: Stairs from Kitchen

---

## Overview

The Basement is where servants worked and secrets were stored. Stone walls replace wallpaper, brick replaces plaster, and the veneer of Victorian respectability falls away. Here, the Ashworths stored what they didn't want seen - old furniture, forgotten portraits, and evidence of the daughter they erased.

```
                    BASEMENT LAYOUT (Top View)
                    
                           NORTH
                             ↑
    ┌─────────────────────────────────────────┐
    │                                         │
    │           STORAGE BASEMENT              │
    │              (8x8x3)                    │
    │                                         │
    │    [Scratched Portrait]    [Mirror]     │
    │                                         │
    │         LADDER ────────────────┐        │
    │          (down)                │        │
    │                                │        │
    ├────────────────────────────────┴────────┤
    │              │                          │
    │   STAIRS     │         DOOR             │
    │    (up)      │        (east)            │
    │              │                          │
    └──────────────┼──────────────────────────┘
                   │
                   │
                   │     ┌────────────────────┐
                   │     │                    │
                   └────►│   BOILER ROOM      │
                         │     (6x8x4)        │
                         │                    │
                         │  [Maintenance Log] │
                         │  [Clock]           │
                         │                    │
                         └────────────────────┘
                   
                              │
                              │ ladder (down)
                              ▼
                        To WINE CELLAR
                          (Floor -2)
```

---

## Rooms

| Room ID | Name | Dimensions | Y Position | Connections |
|---------|------|------------|------------|-------------|
| `storage_basement` | Storage Room | 8x8x3 | -3 | Kitchen, Boiler, Wine Cellar |
| `boiler_room` | Boiler Room | 6x8x4 | -3 | Storage |

---

## Narrative Purpose

The Basement serves as the first descent into darkness, both literal and metaphorical:

1. **Class Divide**: From marble to stone, opulence to utility
2. **Physical Evidence**: First scratched-out portrait found here
3. **Staff Awareness**: Maintenance logs show servants knew something was wrong
4. **Vertical Progression**: Connects to deepest basement below

---

## Atmospheric Progression

```
             KITCHEN (Floor 0)
                 │
                 │ stairs down
                 ▼
         ┌───────────────────┐
         │  STORAGE BASEMENT │  ambientDarkness: 0.75
         │  "First darkness" │
         └────────┬──────────┘
                  │
      ┌───────────┴───────────┐
      │                       │
      ▼                       ▼
┌─────────────┐       ┌─────────────┐
│ BOILER ROOM │       │ WINE CELLAR │
│ "Industrial │       │  (Floor -2) │
│  menace"    │       │   Darkest   │
│ dark: 0.7   │       │ dark: 0.85  │
└─────────────┘       └─────────────┘
```

---

## Color Palette

### Storage Basement
- **Walls**: Stone Brick
- **Floor**: Stone Brick
- **Ceiling**: Dark Wood (exposed beams)
- **Mood**: Forgotten, layered history

### Boiler Room
- **Walls**: Old Brick
- **Floor**: Metal Grate
- **Ceiling**: Metal Pipes (exposed)
- **Mood**: Industrial, threatening

---

## Lighting Summary

| Room | Primary Source | Secondary | Atmosphere |
|------|---------------|-----------|------------|
| Storage | Candle (0.4) | None | Dim, intimate |
| Boiler | Fireplace (0.7) | None | Industrial glow |

### Lighting Notes
- Storage has single candle - player brings their own light?
- Boiler room's fire is industrial, not cozy
- Pipes could carry... sounds? Light?

---

## Key Discoveries

### 1. Scratched Family Portrait
**Location**: Storage Basement, on crate
**Type**: Photo
**Content**: "A stern-looking family stands before the mansion. The youngest child's face has been scratched out."

**Significance**:
- **FIRST PHYSICAL EVIDENCE** of Elizabeth's erasure
- More violent than scratched-out name
- Someone really didn't want her remembered
- Face scratched, not removed - anger, not discretion

### 2. Maintenance Log
**Location**: Boiler Room, work desk
**Type**: Note
**Content**: "Dec 15, 1891 - Strange sounds from the pipes again. The staff refuse to come down here after dark. Something is wrong with this house."

**Significance**:
- Staff knew something was wrong
- "Strange sounds" - Elizabeth's presence spreading?
- Date is 9 days before the final night
- House itself becoming corrupted

### 3. Industrial Clock
**Location**: Boiler Room
**Type**: Clock
**Content**: Also stopped at 3:33

**Significance**:
- Even here, the frozen moment
- Time stopped everywhere, simultaneously
- The event affected the whole house

---

## Environment Details

### Storage Basement

**Visual Elements**:
- Piled furniture (chairs, tables, frames)
- Covered objects under dust cloths
- Cobwebs connecting everything
- Single candle on a crate

**Suggested Furniture**:
- Broken rocking chair
- Stack of old paintings (facing wall)
- Trunk (could contain item later)
- Old mirror against wall

**Audio Elements**:
- Dripping water (distant)
- Settling sounds
- Footsteps echo on stone
- Silence between sounds is oppressive

### Boiler Room

**Visual Elements**:
- Massive iron boiler (dominant)
- Pipes snaking across ceiling
- Metal grate floor
- Fire glow from boiler furnace

**Suggested Details**:
- Coal pile
- Shovels and tools
- Work bench with log book
- Pressure gauges

**Audio Elements**:
- Boiler rumble (constant low)
- Pipe groans (intermittent)
- Fire crackle (different from parlor - industrial)
- Metal settling/expanding

---

## Events

### Storage Basement Events
```yaml
event_storage_first_entry:
  trigger: First entry
  actions:
    - set_flag: visited_storage_basement
    - play_sound: stone_footsteps
    - ambient_change: basement_drip

event_see_scratched_portrait:
  trigger: Examine old_photo_1
  conditions:
    - flag_not_set: seen_scratched_portrait
  actions:
    - set_flag: seen_scratched_portrait
    - set_flag: knows_fourth_child_erased
    - show_document: scratched_portrait
```

### Boiler Room Events
```yaml
event_boiler_first_entry:
  trigger: First entry
  actions:
    - set_flag: visited_boiler_room
    - play_sound: boiler_rumble
    - play_sound: pipe_groan

event_read_maintenance_log:
  trigger: Examine boiler_note
  actions:
    - set_flag: read_maintenance_log
    - set_flag: knows_staff_afraid
    - show_document: maintenance_log
```

### Conditional Events
```yaml
event_pipes_whisper:
  trigger: 30 seconds in boiler room
  conditions:
    - flag_set: elizabeth_aware
  actions:
    - play_sound: whisper_through_pipes
    - show_observation: "Was that... a voice? In the pipes?"
```

---

## Connection to Narrative Threads

### Thread: The Erased Child
- Scratched portrait provides physical proof
- Not just names scratched - face destroyed
- Violence of the erasure becomes clear

### Thread: The Corrupted House
- Maintenance log shows house was "wrong" before the final night
- Staff feared it
- Elizabeth's influence spreading?

### Thread: The Frozen Moment
- Clock in boiler room confirms: ALL clocks stopped
- Event wasn't localized to family areas
- The whole house was affected

---

## Puzzle Connections

### Current
- None (transitional area)

### Planned
- Hidden room behind storage?
- Something in the boiler?
- Pipe-based puzzle (sound sequences?)

---

## Related Documentation

- [Storage Room](./storage-room.md) - Complete room specification
- [Boiler Room](./boiler-room.md) - Complete room specification
- [Deep Basement](../deep-basement/README.md) - Continues descent
