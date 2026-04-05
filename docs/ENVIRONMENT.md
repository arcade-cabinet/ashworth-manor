# Environment Design

This document details the mansion layout, room specifications, and environmental storytelling elements.

## Mansion Overview

```
                    FULL ESTATE LAYOUT (Side View)

    ┌─────────────────────────────────────────┐
    │              ATTIC (+2)                 │  y = 8
    │   Stairwell ─── Storage ─── Hidden      │
    └─────────────────────────────────────────┘
    ┌─────────────────────────────────────────┐
    │           UPPER FLOOR (+1)              │  y = 4
    │ Library ─ Hallway ─ Guest Room          │
    │ Master Bedroom ──┘                      │
    └─────────────────────────────────────────┘
    ┌─────────────────────────────────────────┐
    │           GROUND FLOOR (0)              │  y = 0
    │ Kitchen ─ Foyer ─ Dining Room           │
    │            └─ Parlor                    │
    └─────────────────────────────────────────┘
    ┌─────────────────────────────────────────┐
    │            BASEMENT (-1)                │  y = -3
    │         Storage ─ Boiler Room           │
    └─────────────────────────────────────────┘
    ┌─────────────────────────────────────────┐
    │         DEEP BASEMENT (-2)              │  y = -6
    │              Wine Cellar                │
    └─────────────────────────────────────────┘

                    GROUNDS (Exterior, y = 0)

    ┌─────────────────────────────────────────────────────┐
    │                                                     │
    │    CRYPT (N)     MANSION      GREENHOUSE (E)        │
    │                                                     │
    │    CHAPEL (W)                 CARRIAGE HOUSE (SW)   │
    │                                                     │
    │              FRONT GATE & DRIVE (S)                  │
    │                                                     │
    └─────────────────────────────────────────────────────┘
```

### Total Room Count: 20
- **Interior**: 14 rooms across 5 floors
- **Exterior**: 6 areas (Front Gate, Garden, Chapel, Greenhouse, Carriage House, Family Crypt)

Each room is a standalone `.tscn` scene file in `scenes/rooms/{floor}/{room}.tscn`.

## Floor Specifications

### Deep Basement (Floor -2)
**Theme**: Ancient, forgotten, dread

| Room | Dimensions (WxDxH) | Position | Character |
|------|-------------------|----------|-----------|
| Wine Cellar | 8x10x3 | (0, -6, 0) | Dusty wine racks, cold stone |

**Lighting**: Torches only (flickering, warm)
**Materials**: Dark stone floors, rough stone walls
**Atmosphere**: Oppressive, claustrophobic

---

### Basement (Floor -1)
**Theme**: Service areas, industrial menace

| Room | Dimensions | Position | Character |
|------|------------|----------|-----------|
| Storage Room | 8x8x3 | (0, -3, 0) | Forgotten belongings, cobwebs |
| Boiler Room | 6x8x4 | (10, -3, 0) | Iron machinery, pipes |

**Connections**:
- Storage ↔ Boiler Room (door, east-west)
- Storage ↔ Wine Cellar (ladder, down)
- Storage ↔ Kitchen (stairs, up)

**Lighting**: Single candle (storage), fireplace glow (boiler)
**Materials**: Brick, metal grates, exposed pipes

---

### Ground Floor (Floor 0)
**Theme**: Faded grandeur, public face of the family

| Room | Dimensions | Position | Character |
|------|------------|----------|-----------|
| Grand Foyer | 12x14x6 | (0, 0, 0) | Entrance, grand staircase |
| Parlor | 10x10x4 | (0, 0, 16) | Velvet, portraits, cold fireplace |
| Dining Room | 8x12x4 | (14, 0, 0) | Long table, dusty china |
| Kitchen | 8x10x3.5 | (-14, 0, 0) | Cast iron, hearth |

**Connections**:
- Foyer ↔ Parlor (north)
- Foyer ↔ Dining Room (east)
- Foyer ↔ Kitchen (west)
- Foyer ↔ Upper Hallway (stairs, up)
- Kitchen ↔ Storage Basement (stairs, down)

**Lighting**: Chandelier (foyer), sconces, candles, fireplaces, windows
**Materials**: Marble floors, Victorian wallpaper, ornate plaster ceilings

---

### Upper Floor (Floor +1)
**Theme**: Private spaces, family secrets

| Room | Dimensions | Position | Character |
|------|------------|----------|-----------|
| Upper Hallway | 4x16x3.5 | (4, 4, 0) | Long corridor, many doors |
| Master Bedroom | 10x10x4 | (-8, 4, -3) | Four-poster bed, mirror |
| Library | 8x10x4 | (-8, 4, 10) | Books, globe (hides key) |
| Guest Room | 8x8x3.5 | (14, 4, 0) | Modest, scratched door |

**Connections**:
- Hallway ↔ Master Bedroom (west)
- Hallway ↔ Library (west)
- Hallway ↔ Guest Room (east)
- Hallway ↔ Foyer (stairs, down)
- Hallway ↔ Attic Stairs (door, up) **LOCKED**

**Lighting**: Sconces, candles, window moonlight
**Materials**: Wood floors with runners, dark wallpaper

---

### Attic (Floor +2)
**Theme**: Hidden truth, Elizabeth's prison

| Room | Dimensions | Position | Character |
|------|------------|----------|-----------|
| Attic Stairwell | 4x6x3 | (4, 8, 10) | Creaking stairs, dust |
| Attic Storage | 14x12x4 | (0, 8, 22) | Trunks, doll, painting |
| Hidden Chamber | 6x6x3 | (-12, 8, 22) | Drawings on walls |

**Connections**:
- Stairwell ↔ Upper Hallway (down)
- Stairwell ↔ Storage (north)
- Storage ↔ Hidden Chamber (west) **LOCKED**

**Lighting**: Window light, single candles
**Materials**: Rough wood, exposed rafters, cracked plaster

---

## Room Connection Graph

```
                         Hidden Chamber
                              │
                              │ (locked)
                              ▼
Wine Cellar ◄──────── Storage ◄────────► Attic Storage
     │                Basement              │
     │ (ladder)          │                  │
     ▼                   │ (stairs)         │
  Boiler ◄───────────────┤                  │
   Room                  │                  │
                         ▼                  ▼
                      Kitchen ◄────► Foyer ────► Dining
                                       │          Room
                                       │
                                       │ (stairs)
                                       ▼
    Guest ◄────────────► Upper ◄────────► Library
    Room                Hallway              │
                          │                  │
                          │ (locked)    Globe (key)
                          ▼
                    Attic Stairwell ◄────► Master
                          │               Bedroom
                          │                  │
                    Attic Storage       Diary (key clue)
```

## Environmental Storytelling Elements

### Ground Floor - The Public Facade

**Foyer**
- Lord Ashworth's portrait: Stern patriarch, hand on occult book
- Grandfather clock: Stopped at 3:33 AM
- Mirror: First hint that reflections are "wrong"

**Parlor**
- Lady Ashworth's portrait: Wearing mourning dress before any deaths
- Torn diary page: "Children hearing whispers from the attic"
- Music box: Plays melody associated with Elizabeth

**Dining Room**
- Table set for dinner never served
- Photograph of final dinner party (guests died within a week)
- Chandelier switch (functional)

**Kitchen**
- Cook's note about "rats that whisper names"
- Stairs to basement (servant access)
- Cold hearth despite signs of recent use

---

### Upper Floor - Private Truths

**Hallway**
- Painting of "three children" but there were four
- Locked attic door (requires key)
- Scratches on inside of Guest Room door

**Master Bedroom**
- Lord Ashworth's diary: Confession about locking Elizabeth away
- Clue: "attic key hidden in library globe"
- Large mirror (increasingly disturbing reflections)

**Library**
- Globe that opens (contains ATTIC KEY)
- "Rituals of Binding" - occult book about trapping spirits
- Family tree with fourth name scratched out: "E_iza_eth"

**Guest Room**
- Guest ledger with blank departure date
- Photograph of woman at attic window
- Note: "She sees you too"

---

### Basement - Beneath the Surface

**Storage Room**
- Old family photograph (youngest face scratched)
- Mirror covered in dust
- Access to both wine cellar and boiler room

**Boiler Room**
- Maintenance log: "Strange sounds from pipes"
- Staff refused to come here after dark
- Industrial feel contrasts domestic upper floors

---

### Deep Basement - Buried Secrets

**Wine Cellar**
- Inventory note: "1872 Bordeaux in hidden alcove"
- Reference to "the key is with the portrait"
- Feeling of being watched

---

### Attic - Elizabeth's Prison

**Attic Stairwell**
- Transition space building dread
- Dust shows single set of footprints
- Cold despite no windows

**Attic Storage**
- Painting of Elizabeth: Eyes painted over in black
- Porcelain doll with cracked face
- "SHE NEVER LEFT" scratched into wood
- Unsent letter from Elizabeth to her mother

**Hidden Chamber**
- Children's drawings covering walls (same figure repeated)
- Elizabeth's final note explaining the truth
- Mirror showing... what?

---

## Atmosphere Progression

| Area | Fear Type | Lighting | Player Feeling |
|------|-----------|----------|----------------|
| Ground Floor | Unease | Moderate | Something's not right |
| Upper Floor | Tension | Dim | Being watched |
| Basement | Dread | Very dim | Shouldn't be here |
| Deep Basement | Isolation | Minimal | Can't escape |
| Attic | Revelation | Variable | Understanding horror |

## Audio Design (Implemented)

Each room has an assigned OGG ambient loop. See ASSETS.md for the full audio loop assignment table. AudioManager crossfades between loops on room transitions.
