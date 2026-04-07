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
    │ TREE5 ROCKS STONE STEP/DOOR READ STONE T6 │
    │ (-6,9)(-3,8)(-2,8) (0,11)      (2,8)(5,10)│
    │                                           │
    │ TREE3   STATUE L          STATUE R HEDGE  │
    │ (-7,5)  (-6,4)            (6,4)    R2     │
    │                                           │
    │ BUSH5     STONE   BUSH6       TREE4       │
    │           (0,6)                           │
    │                                           │
    │  BENCH [i]    STONE      TREE2            │
    │  (5,0,-5)     (0,2)      (8,0,-3)         │
    │                                           │
    │  TREE1        STONE       BUSH4           │
    │  (-8,0,-5)    (0,-2)     (4,0,3)          │
    │                                           │
    │   HEDGE L1   BUSH3      HEDGE R1          │
    │   (-8,0,-1)  (-3,0,-2)  (8,0,-0)          │
    │          LUGGAGE [i]   STONE              │
    │          (4,0,-7)      (0,-6)             │
    │                                           │
    │  BUSH1          BUSH2                     │
    │  (-6,0,-9)      (6,0,-9)                  │
    │                                           │
    ├──FENCE────LAMP [L]──GATE [i]──────────────┤
    │  (-7,0,-10) (-4,3,-10)  (0,0,-10)        │
    │  WALL      PILLAR_L   PILLAR_R/OFF LAMP   │
    │  (-9,0,-10) (-4,0,-10) (4,0,-10)         │
    │                    POLE/FENCE R (6..7)   │
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

Drive stones (floor3.glb, dark flagstone) form a broken ceremonial path:
- Centerline stones at Z=-6, -2, 2, 6
- Widening pair near the house at X=-2.5 and X=2.5, Z=8.5

Most of the area remains gravel/dirt ground. The stones only articulate the approach and keep the allée from feeling flat.
Near the house, three shallower stones suggest the first step up to a visible front threshold rather than letting the path die into empty darkness.

## Collision

- Floor: Single BoxShape3D (20 x 0.2 x 20) at Y=-0.1
- Boundary walls: Created at runtime by room_base.gd (is_exterior=true, boundary_size=20x6x20)
