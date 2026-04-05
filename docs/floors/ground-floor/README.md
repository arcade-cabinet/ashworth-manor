# Ground Floor (Floor 0)

**Theme**: Faded Grandeur, The Public Face
**Ambient Darkness Range**: 0.4 - 0.6
**Player Entry Point**: Grand Foyer

---

## Overview

The Ground Floor represents the Ashworth family's public facade - the face they showed to society. Grand spaces designed for entertaining, displaying wealth, and projecting respectability. Yet even here, cracks in the veneer are visible to those who look carefully.

```
                    GROUND FLOOR LAYOUT (Top View)
                    
                           NORTH
                             ↑
                    ┌─────────────────┐
                    │                 │
                    │     PARLOR      │
                    │   (10x10x4)     │
                    │                 │
                    └────────┬────────┘
                             │ door
        ┌──────────┐    ┌────┴────────────┐    ┌────────────┐
        │          │    │                 │    │            │
        │ KITCHEN  │────│   GRAND FOYER   │────│   DINING   │
        │ (8x10x3.5)door│   (12x14x6)     │door│    ROOM    │
        │          │    │                 │    │  (8x12x4)  │
        └──────────┘    └────────┬────────┘    └────────────┘
              │                  │ stairs
              │ stairs           │
              ↓                  ↓
         To Basement      To Upper Floor
```

---

## Rooms

| Room ID | Name | Dimensions | Y Position | Connections |
|---------|------|------------|------------|-------------|
| `foyer` | Grand Foyer | 12x14x6 | 0 | Parlor, Dining, Kitchen, Upper Hall |
| `parlor` | Parlor | 10x10x4 | 0 | Foyer |
| `dining_room` | Dining Room | 8x12x4 | 0 | Foyer |
| `kitchen` | Kitchen | 8x10x3.5 | 0 | Foyer, Storage Basement |

---

## Atmospheric Progression

```
           BRIGHT                                    DARK
             │                                         │
    Foyer ───┼──────────────────────────────────────│
   (0.4)     │                                       │
             │                                       │
   Parlor ───┼───────────────────────────────────│──│
   (0.5)     │                                    │  │
             │                                    │  │
   Dining ───┼────────────────────────────────│──│──│
   (0.55)    │                                 │  │  │
             │                                 │  │  │
  Kitchen ───┼──────────────────────────────│──│──│──│
   (0.6)     │                              │  │  │  │
```

The darkness increases as you move away from the formal entrance, suggesting the deeper you go into the family's private world, the darker things become.

---

## Color Palette

### Foyer
- **Walls**: William Morris Red (`#732F26`)
- **Floor**: Carrara Marble Checkered
- **Ceiling**: Ornate Plaster (cream with gilt accents)
- **Mood**: Imposing authority

### Parlor  
- **Walls**: Arsenic Green (`#335938`)
- **Floor**: Wood Parquet
- **Ceiling**: Plaster with Molding
- **Mood**: False calm, poison beneath beauty

### Dining Room
- **Walls**: Deep Burgundy (`#612630`)
- **Floor**: Dark Wood
- **Ceiling**: Ornate Plaster
- **Mood**: Dining with death

### Kitchen
- **Walls**: Aged Plaster
- **Floor**: Kitchen Stone
- **Ceiling**: Exposed Wood Beams
- **Mood**: Servant's truth

---

## Lighting Summary

| Room | Primary Source | Secondary | Atmosphere |
|------|---------------|-----------|------------|
| Foyer | Chandelier (0.8) | 2 Sconces, Window | Bright but cold |
| Parlor | Fireplace (0.6) | 2 Candles | Intimate, dying |
| Dining | Chandelier (0.7) | Table Candles | Formal, staged |
| Kitchen | Hearth (0.5) | Window | Utilitarian |

---

## Narrative Threads Introduced

### Thread 1: The Frozen Moment
- Grandfather clock stopped at 3:33
- Dinner never served
- Fire dying but warm
- **Question**: What happened at 3:33 AM?

### Thread 2: The Hidden Child
- Diary mentions "she" in the attic
- Whispers heard by children
- Cook heard "rats that whisper names"
- **Question**: Who is locked in the attic?

### Thread 3: Death at Dinner
- Three guests died within the week
- Guest ledger entries blank
- **Question**: What killed them?

### Thread 4: The Watching House
- Mirrors feel wrong
- Portraits' eyes follow
- **Question**: Is someone still here?

---

## Floor-Specific Events

### Entry Events
```yaml
event_intro_narration:
  trigger: First entry to foyer
  actions:
    - set_flag: game_started
    - room_name_display: "Grand Foyer"
    - ambient_sound: distant_settling

event_parlor_fire:
  trigger: Enter parlor first time
  actions:
    - play_sound: fire_crackle_low
    - observation: "The embers still hold warmth"
```

### Conditional Events
```yaml
event_clock_chime:
  conditions:
    - flag_set: all_clocks_examined
  actions:
    - play_sound: distant_chime
    - show_message: "All the clocks chime 3:33. Impossible."
```

---

## Related Documentation

- [Grand Foyer](./foyer.md) - Complete room specification
- [Parlor](./parlor.md) - Complete room specification  
- [Dining Room](./dining-room.md) - Complete room specification
- [Kitchen](./kitchen.md) - Complete room specification
