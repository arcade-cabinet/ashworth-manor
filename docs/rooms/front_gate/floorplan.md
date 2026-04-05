# Front Gate — Floor Plan

Room dimensions: 20m x 20m (exterior, open area)
Grid: 2m tiles, floor3.glb (dark flagstone)
Spawn: (0, 0, -8), facing north (+Z, toward mansion)

```
                        NORTH (+Z = 10)
                   (toward mansion / foyer)
                          │
              ┌───────────┴───────────┐
              │                       │
              │     CONNECTION        │
              │     → foyer           │
              │     (0, 1.5, 10)      │
              │                       │
    ┌─────────┴───────────────────────┴─────────┐
    │                                           │
    │         ROCKS       TREE4                 │
    │         (-3,0,8)    (7,0,7)               │
    │                                           │
    │                                           │
    │  TREE3                                    │
    │  (-7,0,5)     HEDGE/NATURE                │  CONNECTION
    │               (-8,0,0)                    │─→ garden
    │                                           │  (10, 1.5, 0)
    │                                           │
    │                                           │
    │                                           │
    │  BENCH [i]    TREE2                       │
    │  (5,0,-5)     (8,0,-3)                    │
    │                                           │
    │  TREE1                                    │
    │  (-8,0,-5)                                │
    │                                           │
    │          LUGGAGE [i]                      │
    │          (4,0,-7)                         │
    │                                           │
    │  BUSH1          BUSH2                     │
    │  (-6,0,-9)      (6,0,-9)                  │
    │                                           │
    ├──FENCE────LAMP [L]──GATE [i]──────────────┤
    │  (-7,0,-10) (-4,3,-10)  (0,0,-10)        │
    │  WALL      PILLAR_L    PILLAR_R   CORNER  │
    │  (-9,0,-10) (-4,0,-10) (4,0,-10) (9,-10) │
    │                                           │
    └───────────────────────────────────────────┘
                          │
                     SOUTH (-Z = -10)
                   (where player spawns)
                   Spawn: (0, 0, -8) facing N

LEGEND:
  [i] = Interactable (Layer 3, collision_layer 4)
  [L] = Light source
  →   = Connection (Layer 4, collision_layer 8)
```

## Grid Coverage

Floor tiles (floor3.glb, dark flagstone, 2m each):
- Row Z=-9: 10 tiles from X=-9 to X=9 (full width)
- Row Z=1: 3 tiles at X=-9, X=1, X=9 (sparse mid-area)
- Row Z=9: 3 tiles at X=-9, X=1, X=9 (sparse near mansion)

Most of the area is gravel/dirt ground — floor tiles serve as path stepping stones.

## Collision

- Floor: Single BoxShape3D (20 x 0.2 x 20) at Y=-0.1
- Boundary walls: Created at runtime by room_base.gd (is_exterior=true, boundary_size=20x6x20)
