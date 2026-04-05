# Upper Hallway — Floor Plan

Room: 4m wide (X: -2 to +2) x 16m deep (Z: -8 to +8) x 2.4m tall (narrow corridor)
Grid: 2m tiles. Walls: wall_1.glb (dark damask). Floor: floor1.glb (wood parquet). Ceiling: cieling1.glb (molding).
Spawn: (0, 0, -6), facing north (up the hallway toward attic door)

```
                        NORTH (Z = +8)
              ┌───────────────────────┐
              │                       │
              │   ATTIC DOOR [i]      │
              │   (0, 1.5, 7.5)       │
              │   LOCKED (attic_key)  │
              │                       │
              ├───┬───────────┬───────┤
    → library │ D │           │ D │ → guest_room
    (-2,0,5)  │   │ SCONCE[L1]│   │ (2,0,5)
              ├───┘ (-1.5,2,5)└───┤
              │                       │
              │   CHILDREN'S          │
              │   PAINTING [i]        │
              │   (1.5, 1.6, 3)       │
              │                       │
              │   MASK [i]            │
              │   (-1.5, 1.8, 1)      │
              │                       │
              ├───┬───────────┬───────┤
    → master  │ D │           │ D │ (unused)
    (-2,0,-1) │   │ SCONCE[L2]│   │
              ├───┘ (1.5,2,-1)└───┤
              │                       │
              │   RUG (runner)        │
              │   (0, 0.01, 0)        │
              │                       │
              │   STAND / LAMP        │
              │   (1.5, 0, -4)        │
              │                       │
              │   POSTER [i]          │
              │   (-1.5, 1.6, -5)     │
              │                       │
              │   SWITCH [i]          │
              │   (1.8, 1.3, -6)      │
              │                       │
              ├───────────────────────┤
              │   STAIRS → foyer      │
              │   (0, 0, -8)          │
              └───────────────────────┘
                        SOUTH (Z = -8)
                   (stairs down to foyer)

LEGEND:
  [i]  = Interactable Area3D
  [L1] = Wall sconce north (flickering)
  [L2] = Wall sconce south (flickering)
  D    = Doorway to side room
  →    = Connection
```

## Current Scene Issues
- Only 1 connection (to foyer). Missing: master_bedroom, library, guest_room, attic_stairs
- ZERO interactables. Needs: attic door, children's painting, mask, poster, switch
