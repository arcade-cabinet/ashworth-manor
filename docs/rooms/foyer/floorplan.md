# Grand Foyer — Floor Plan

Room: 12m wide (X: -6 to +6) x 10m deep (Z: -5 to +5) x 4.8m tall
Grid: 2m tiles. Walls: wall_0.glb (red Victorian). Floor: floor0.glb (marble checkered). Ceiling: cieling0.glb (ornate plaster).
Spawn: (0, 0, -3), facing north (toward staircase)

```
                        NORTH (Z = +5)
              ┌─────┬─────────────────┬─────┐
              │     │  → parlor       │     │
              │     │  DOORWAY (0,5)  │     │
              │     │                 │     │
              │ MAP │                 │STAND│
              │(-5, │   CHANDELIER    │(5,  │
              │ 0,4)│     [L1]       │ 0,4)│
              │     │   (0, 4.5, 0)  │     │
              │     │                 │     │
        WEST  │ SCN │                 │ SCN │  EAST
              │ [L2]│                 │ [L3]│
   → kitchen  │(-5, │                 │(5,  │  → dining_room
   DOORWAY    │3,-3)│   STAIRS        │3,-3)│  DOORWAY
   (-6,0,0)   │     │   → upper_hall  │     │  (6,0,0)
              │     │   (2,0,-2)     │     │
              │ RUG │                 │     │
              │     │                 │ CLK │
              │     │   PILLAR  PILLAR│ [i] │
              │     │   (-3,0,-4)(3,0,│(5,  │
              │     │          -4)   │1,-4)│
              │DRWR │  PORTRAIT [i]  │     │
              │(-5, │  (0, 2.5, -4.5)│PCKG │
              │0,-4)│  WINDOW  WIN_RAY│(5,  │
              │     │  (0,3,-5)(0,3,-5│0,-4)│
              ├─────┼─────────────────┼─────┤
              │ MIR │  → front_gate   │ SWT │
              │ [i] │  (0,1.5,-5)    │ [i] │
              │(-5, │                 │(5.5,│
              │2,3) │                 │1,-5)│
              └─────┴─────────────────┴─────┘
                        SOUTH (Z = -5)
                   (player enters from front gate)

LEGEND:
  [i]  = Interactable Area3D (Layer 3)
  [L1] = Chandelier light (OmniLight3D)
  [L2] = West sconce (OmniLight3D, flickering)
  [L3] = East sconce (OmniLight3D, flickering)
  →    = Connection Area3D (Layer 4)
  MIR  = Entry mirror
  CLK  = Grandfather clock
  SWT  = Light switch
  SCN  = Wall sconce
  DRWR = Drawers (furniture)
  PCKG = Package (prop)
  MAP  = Wall map (prop)
  RUG  = Floor rug (decor)
```

## Wall Layout

North wall (Z=+5): 6 wall_0 panels, 1 doorway0 (center, to parlor)
South wall (Z=-5): 6 wall_0 panels, 1 window_wall0 (center)
East wall (X=+6): 5 wall_0 panels, 1 doorway0 (center, to dining room)
West wall (X=-6): 5 wall_0 panels, 1 doorway0 (center, to kitchen)
Door models placed in each doorway.

## Staircase

Stairs at (2, 0, -2), ascending toward upper hallway connection.
Uses `stairs0.glb` with `stairbanister.glb`.
