# Parlor — Floor Plan

Room: 10m wide (X: -5 to +5) x 10m deep (Z: -5 to +5) x 2.4m tall
Grid: 2m tiles. Walls: wall_4.glb (arsenic green). Floor: floor1.glb (wood parquet). Ceiling: cieling1.glb (molding).
Spawn: (0, 0, -4), facing north (toward fireplace)

```
                        NORTH (Z = +5)
              ┌─────────────────────────────┐
              │                             │
              │        FIREPLACE [L1]       │
              │         (0, 0, 4.5)         │
              │     fireplace.glb + light   │
              │                             │
              │                             │
              │ PORTRAIT                    │
              │ Lady A.                     │
        WEST  │ [i]                    STOOL│  EAST
              │(-4.5,                  (3,  │
              │ 2, 0)                  0,3) │
              │                             │
              │              CANDLE1  CND2  │
              │              [L2]     [L3]  │
              │              (-3,1,0) (3,1,0│
              │                             │
              │   DESK  SETTEE    SETTEE    │
              │ (-4,-3) (-2,0,-2) (2,0,-2)  │
              │                             │
              │ TBL MUSIC BOX  NOTE TBL LMP │
              │ (-2,-3)      (2,-3)  (4,-3) │
              │                             │
              │         BOTTLES   JAR       │
              │         (1,0.8,-1)(0,0.8,1) │
              │                             │
              │         RUG                 │
              │         (0, 0.01, -1)       │
              │                             │
              ├─────────┬─────────┬─────────┤
              │         │ → foyer │         │
              │         │(0,1.5,-5│         │
              │         │ DOORWAY │         │
              └─────────┴─────────┴─────────┘
                        SOUTH (Z = -5)
                   (entrance from foyer)

LEGEND:
  [i]  = Interactable Area3D
  [L1] = Fireplace light (flickering, slow breathing)
  [L2] = Candle left (flickering)
  [L3] = Candle right (flickering)
  →    = Connection
```

## Wall Layout

North wall (Z=+5): 5 wall_4 panels. Fireplace model centered.
South wall (Z=-5): 4 wall_4 panels + 1 doorway4 (center, to foyer). Door model.
East wall (X=+5): 5 wall_4 panels (solid — no exit).
West wall (X=-5): 5 wall_4 panels (solid — Lady's portrait on this wall).

The furniture should create a real receiving-room composition:
- fireplace as the visual anchor
- two settees forming the conversation area
- music box and diary on small tables where the player naturally notices them
- Lady Ashworth's desk offset left so the room feels hers, not anonymous
