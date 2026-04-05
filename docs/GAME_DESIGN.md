# Game Design Document

This document outlines the gameplay systems, mechanics, and design philosophy for Ashworth Manor.

## Design Philosophy

### Core Pillars

1. **Diegetic Immersion**
   - No floating UI elements during exploration
   - All feedback occurs within the game world
   - Player reads actual notes, not UI text boxes
   - Light switches affect actual lights

2. **Environmental Storytelling**
   - The house itself tells the story
   - Players discover narrative through exploration
   - No cutscenes or exposition dumps
   - Objects and their placement carry meaning

3. **Mobile-Native Design**
   - Designed for touch from the ground up
   - No virtual joysticks or button overlays
   - Tap and swipe as primary interactions
   - Portrait and landscape support

4. **Atmospheric Horror**
   - Dread over jump scares
   - Psychological unease
   - The unknown is scarier than the seen
   - Sound and shadow as primary tools

## Player Experience

### Moment-to-Moment Gameplay
1. Player enters a room
2. Room name fades in, establishing location
3. Player observes environment, notes light sources
4. Taps floor to move, swipes to look around
5. Discovers interactable object (subtle glow on hover)
6. Taps object to interact
7. Reads note/examines item on aged paper overlay
8. Closes overlay by tapping
9. Continues exploration

### Session Flow
```
Landing Screen
    │
    ▼
New Game / Continue
    │
    ▼
PROLOGUE: Front Gate & Drive (Exterior)
    │
    ▼
Foyer (Ground Floor)
    │
    ├──► Explore Ground Floor
    │    (Foyer, Parlor, Dining, Kitchen)
    │
    ├──► Descend to Basement
    │    (Storage, Boiler Room)
    │
    ├──► Descend to Deep Basement
    │    (Wine Cellar)
    │
    ├──► Ascend to Upper Floor
    │    (Hallway, Bedrooms, Library)
    │
    ├──► Explore Grounds (after ground floor)
    │    (Carriage House, Chapel, Greenhouse, Crypt)
    │
    └──► Find Attic Key → Unlock Attic
         (Stairwell, Storage, Hidden Chamber)
              │
              └──► Counter-Ritual → Ending
                   (Collect 6 components → Hidden Chamber)
```

## Controls

### Mobile (Primary)
| Gesture | Action |
|---------|--------|
| Single tap (floor) | Move to location |
| Single tap (object) | Interact |
| Single tap (door) | Transition to room |
| Swipe | Look around |
| Tap menu icon | Pause game |

### Desktop (Secondary)
| Input | Action |
|-------|--------|
| Left click (floor) | Move to location |
| Left click (object) | Interact |
| Right click + drag | Look around |
| Escape | Pause game |

## Movement System

### Tap-to-Walk
- Player taps destination on floor
- Visual indicator appears at tap location
- Character smoothly moves toward point
- Camera rotates to face movement direction
- Movement speed: 3 units/second

### Look System
- Swipe gesture rotates camera view
- Horizontal: Full 360° rotation
- Vertical: Limited to ±45° (prevents disorientation)
- Sensitivity: 0.003 radians per pixel

### Room Transitions
- Player taps door/stairs/ladder
- Screen fades to black (0.5s)
- New room loads
- Screen fades from black
- Room name appears

## Interaction System

### Interactable Types

| Type | Visual | Behavior |
|------|--------|----------|
| Painting | Flat rectangle on wall | Shows title + description |
| Note | Small rectangle | Shows handwritten content |
| Photo | Small rectangle | Shows description |
| Mirror | Reflective rectangle | Eerie message |
| Clock | 3D box | Fixed time observation |
| Switch | Small box on wall | Toggles room light |
| Box | 3D box | May contain items or be locked |
| Ladder | Vertical bars | Room transition (up/down) |
| Stairs | Floor indicator | Room transition (up/down) |

### Interaction Feedback
1. **Hover**: Subtle emissive glow increase
2. **Tap**: Brief bright flash
3. **Result**: Overlay appears with content

### Locked Objects
- Some boxes require keys
- Keys found in other locations
- Attempting locked object shows "locked" message
- No arbitrary puzzles—keys are discoverable

## Progression System

### Exploration Tracking
- Visited rooms tracked in state
- Interacted objects tracked
- Progress shown in pause menu
- No achievements or scores (immersion)

### Key Items
| Item | Location | Unlocks |
|------|----------|---------|
| Attic Key | Library Globe | Attic Door |
| Cellar Key | Carriage House (behind portrait) | Wine Cellar Box |
| Hidden Key | Inside Porcelain Doll (Attic) | Hidden Chamber |
| Jewelry Key | Family Crypt (loose flagstone) | Jewelry Box |
| Gate Key | Greenhouse (pot near lily) | Crypt Iron Gate |
| Blessed Water | Chapel Baptismal Font | Counter-Ritual component |
| Elizabeth's Locket | Jewelry Box (contains lock of hair) | Counter-Ritual component |
| Mother's Confession | Wine Cellar Box | Counter-Ritual component |
| Binding Book | Library | Counter-Ritual component |
| Porcelain Doll | Attic Storage (after extracting key) | Counter-Ritual component |

### Narrative Progression
Story unfolds through discovered documents:

1. **Surface Layer** (Ground Floor)
   - Family portraits
   - Guest ledgers
   - Household notes

2. **Middle Layer** (Upper Floor, Basement)
   - Personal diaries
   - Torn pages
   - Hidden photographs

3. **Deep Layer** (Attic, Deep Basement)
   - Elizabeth's writings
   - Occult references
   - Final revelations

## Room Design Principles

### Every Room Should Have:
1. At least one light source
2. At least one interactable object
3. Clear navigation paths
4. Logical connections to adjacent spaces
5. Environmental details suggesting history

### Room Pacing
- Larger rooms: More exploration, slower pace
- Smaller rooms: Focused, intense atmosphere
- Transition spaces: Brief, build anticipation

## Audio Design (Implemented)

### Room Ambient Loops
Each of the 20 rooms has an assigned OGG ambient loop from the Lonely Nightmare pack. AudioManager crossfades between loops on room transitions using dual AudioStreamPlayer nodes.

### Event-Triggered Audio
Special audio triggers override room loops for key events:
- Document reading, mirror interactions, sealed doors
- Elizabeth awareness (global tension increase)
- Music box event in Parlor
- Counter-ritual progression (3-step sequence)
- Freedom ending (dawn/release)

## Difficulty & Accessibility

### No Failure State
- Players cannot die
- No time limits
- No wrong choices
- Exploration is the goal

### Navigation Aids
- Room names on entry
- Visited rooms remembered
- Clear door/exit indicators
- Consistent interaction language

### Visual Accessibility
- High contrast interactables
- Legible fonts at mobile sizes
- No reliance on color alone
- Text on readable backgrounds

## Implemented Features

### Expanded Mansion (20 Rooms)
The full estate includes 14 interior rooms across 5 floors plus 6 exterior grounds:
- **Ground Floor**: Foyer, Parlor, Dining Room, Kitchen
- **Upper Floor**: Hallway, Master Bedroom, Library, Guest Room
- **Basement**: Storage, Boiler Room
- **Deep Basement**: Wine Cellar
- **Attic**: Stairwell, Storage, Hidden Chamber
- **Grounds**: Front Gate, Garden, Chapel, Greenhouse, Carriage House, Family Crypt

### Multiple Endings (3 Endings)
Three endings based on player progress:
- **Freedom**: Complete counter-ritual (6 components), free Elizabeth
- **Escape**: Leave with full knowledge but without freeing her
- **Joined**: Attempt to leave without understanding, or linger too long

## Future Considerations

### Enemy System (Not Yet Implemented)
The environment-first approach means enemies come later:
- Presence should be felt before seen
- Movement patterns tied to player actions
- Safe rooms as relief points
- No combat -- avoidance only
