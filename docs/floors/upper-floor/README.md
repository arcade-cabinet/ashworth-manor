# Upper Floor (Floor +1)

**Theme**: Private Secrets, Family Truths
**Ambient Darkness Range**: 0.5 - 0.6
**Access**: Grand staircase from Foyer

---

## Overview

The Upper Floor houses the family's private spaces - bedrooms, the library, and the hallway that connects them all. This is where the Ashworths lived their real lives, away from the public eye. Here, the facade cracks. Diaries confess crimes. Family trees show erasures. And a locked door leads to something terrible.

```
                    UPPER FLOOR LAYOUT (Top View)
                    
                           NORTH
                             ↑
                             │
              ┌──────────────┴──────────────┐
              │        ATTIC DOOR           │
              │          (locked)           │
              │                             │
    ┌─────────┴─────────┐         ┌─────────┴─────────┐
    │                   │         │                   │
    │     LIBRARY       │         │    GUEST ROOM     │
    │     (8x10x4)      │◄───────►│     (8x8x3.5)     │
    │                   │  hall   │                   │
    │  [Globe-KEY]      │         │  [Photo/Ledger]   │
    │  [Ritual Book]    │         │                   │
    │  [Family Tree]    │         │                   │
    └─────────┬─────────┘         └─────────┬─────────┘
              │                             │
              │         UPPER HALLWAY       │
              │           (4x16x3.5)        │
              │                             │
    ┌─────────┴─────────┐         ┌─────────┴─────────┐
    │                   │         │                   │
    │ MASTER BEDROOM    │◄───────►│                   │
    │    (10x10x4)      │  hall   │                   │
    │                   │         │                   │
    │  [Diary-CLUE]     │         │                   │
    │  [Mirror]         │         │                   │
    │  [Jewelry Box]    │         │                   │
    └───────────────────┘         └───────────────────┘
                                          │
                                       STAIRS
                                          │
                                          ▼
                                     To FOYER
                                       SOUTH
```

---

## Rooms

| Room ID | Name | Dimensions | Y Position | Connections |
|---------|------|------------|------------|-------------|
| `upper_hallway` | Upper Hallway | 4x16x3.5 | 4 | Foyer, Master, Library, Guest, Attic |
| `master_bedroom` | Master Bedroom | 10x10x4 | 4 | Upper Hallway |
| `library` | Library | 8x10x4 | 4 | Upper Hallway |
| `guest_room` | Guest Room | 8x8x3.5 | 4 | Upper Hallway |

---

## Narrative Purpose

The Upper Floor serves as **Act II** of the story. Here the player:

1. **Discovers the locked attic door** (goal established)
2. **Reads Lord Ashworth's diary** (learns key location)
3. **Finds the attic key** (puzzle solved)
4. **Gains context** (binding ritual, erased family member)

This floor transforms the player from curious explorer to active investigator.

---

## Critical Path Items

### The Attic Key Puzzle Chain

```
UPPER HALLWAY                    MASTER BEDROOM
┌──────────────┐                ┌──────────────┐
│ Locked Attic │   ──────────►  │ Lord's Diary │
│    Door      │   "Must find   │    Found     │
│              │    a key"      │              │
└──────────────┘                └──────────────┘
                                       │
                                       │ "Key in library globe"
                                       ▼
                                ┌──────────────┐
                                │   LIBRARY    │
                                │  Open Globe  │
                                │  GET KEY     │
                                └──────────────┘
                                       │
                                       │ Return to hallway
                                       ▼
                                ┌──────────────┐
                                │ UNLOCK ATTIC │
                                │   PROCEED    │
                                └──────────────┘
```

---

## Color Palette

### Upper Hallway
- **Walls**: Dark Victorian Wallpaper (#38302C)
- **Floor**: Wood with carpet runner
- **Ceiling**: Aged Plaster
- **Mood**: Transitional, tense

### Master Bedroom
- **Walls**: Prussian Blue (#384A6B)
- **Floor**: Persian Carpet over wood
- **Ceiling**: Plaster with molding
- **Mood**: Intimacy violated, guilt

### Library
- **Walls**: Dark Wood Paneling
- **Floor**: Dark Wood
- **Ceiling**: Coffered wood
- **Mood**: Knowledge hidden, secrets kept

### Guest Room
- **Walls**: Simple Wallpaper
- **Floor**: Simple Wood
- **Ceiling**: Simple Plaster
- **Mood**: Sparse, trapped

---

## Lighting Summary

| Room | Primary Source | Secondary | Atmosphere |
|------|---------------|-----------|------------|
| Hallway | 2 Sconces (0.4) | Window (0.25) | Dim corridor |
| Master | 2 Candles (0.35) | Window (0.3) | Intimate gloom |
| Library | 2 Sconces (0.45) | Candle (0.3) | Scholarly shadow |
| Guest | Candle (0.3) | Window (0.25) | Sparse, isolated |

---

## Narrative Threads Advanced

### Thread: The Hidden Child
**Before**: "She" in the attic, whispers heard
**After**: Fourth name scratched from family tree (E_iza_eth)

### Thread: The Binding
**Before**: Unknown
**After**: "Rituals of Binding" - the doll, the blood, the attic prison

### Thread: Father's Guilt
**Before**: Stern patriarch
**After**: Diary confession - he knows what he did, can't escape it

### Thread: The Guest Who Never Left
**Before**: Unknown
**After**: Helena Pierce's departure date blank

---

## Events

### Hallway Events
```yaml
event_hallway_first_entry:
  trigger: First entry
  actions:
    - set_flag: visited_upper_hallway
    - play_sound: floorboard_creak
    - show_observation: "The hallway stretches into shadow. Doors line both sides."

event_attic_door_locked:
  trigger: Interact with attic door (no key)
  conditions:
    - lacks_item: attic_key
  actions:
    - set_flag: knows_attic_locked
    - show_message: "The door is locked. You need a key."
    - play_sound: door_rattle

event_attic_door_unlock:
  trigger: Interact with attic door (has key)
  conditions:
    - has_item: attic_key
  actions:
    - set_flag: attic_unlocked
    - unlock: attic_door
    - show_message: "The old lock clicks open."
    - play_sound: lock_opening
```

### Master Bedroom Events
```yaml
event_read_diary:
  trigger: Examine diary
  actions:
    - set_flag: read_ashworth_diary
    - set_flag: knows_key_location
    - show_document: diary_lord_ashworth
```

### Library Events
```yaml
event_open_globe:
  trigger: Interact with globe
  actions:
    - give_item: attic_key
    - set_flag: has_attic_key
    - show_message: "Inside the hollow globe, you find an old brass key labeled 'ATTIC'."
    - play_sound: item_found
```

---

## Room Quick Reference

### Upper Hallway
- **Purpose**: Hub connecting all upper floor rooms
- **Key Feature**: Locked attic door at north end
- **Interactables**: Children's painting, light switch
- **Atmosphere**: Transitional, anticipatory

### Master Bedroom
- **Purpose**: Contains diary (CRITICAL CLUE)
- **Key Feature**: Lord Ashworth's diary on nightstand
- **Interactables**: Diary, mirror, jewelry box (locked)
- **Atmosphere**: Violated intimacy, guilt

### Library
- **Purpose**: Contains attic key (PUZZLE SOLUTION)
- **Key Feature**: Globe with hidden key
- **Interactables**: Globe, Binding book, family tree
- **Atmosphere**: Knowledge corrupted, secrets

### Guest Room
- **Purpose**: Additional narrative (Helena Pierce)
- **Key Feature**: Guest ledger with blank departure
- **Interactables**: Photo, guest note
- **Atmosphere**: Isolation, another victim

---

## Related Documentation

- [Upper Hallway](./upper-hallway.md) - Complete room specification
- [Master Bedroom](./master-bedroom.md) - Complete room specification
- [Library](./library.md) - Complete room specification
- [Guest Room](./guest-room.md) - Complete room specification
- [Attic Key Puzzle](../puzzles/README.md#puzzle-find-the-attic-key)
