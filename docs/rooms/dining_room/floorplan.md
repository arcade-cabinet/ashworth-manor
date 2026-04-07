# Dining Room — Floor Plan

Room: 8m wide (X: -4 to +4) x 10m deep (Z: -5 to +5) x 2.4m tall
Grid: 2m tiles. Walls: wall_5.glb (burgundy). Floor: floor1.glb (wood parquet). Ceiling: cieling0.glb (ornate).
Spawn: (0, 0, -7), facing north (toward table center). Note: spawn is actually (-1, 0, -6) inside doorway area.

```
                        NORTH (Z = +5)
              ┌─────────────────────────────┐
              │  WS0    WS1    WS2    WS3   │
              │                             │
              │                             │
              │                             │
              │ ChL0   TABLE (scaled)  ChR0 │
              │(-1.5,  (0,0,0)        (1.5, │
              │ 0,-2)  1.5x1 x 3x1    0,-2)│
              │                             │
              │ ChL1   CHANDELIER [L1] ChR1 │
              │(-1.5,  (0, 2, 0)      (1.5, │
        WEST  │ 0, 0)                  0, 0)│  EAST
              │                             │
   → foyer    │ ChL2   CANDLE1 CANDLE2 ChPush│
   DOORWAY    │(-1.5,  [L2]    [L3]   (2.2,│
   (-4,0,0)   │ 0, 2) (0,1,-1.5)(0,1,1.5) 0,2)│
              │                             │
              │        PLATES/GLASS/WINE    │
              │        (on table surface)   │
              │                             │
              │                             │
              │  PHOTO [i]    LAMP          │
              │  (3.9,1.6,0)  (-0.6,0.78,2)│
              │                             │
              │  WE0-4 (east wall solid)    │
              │                             │
              │  WN0    WN1    WN2    WN3   │
              └─────────────────────────────┘
                        SOUTH (Z = -5)

LEGEND:
  [i]  = Interactable Area3D
  [L1] = Chandelier light (OmniLight3D, shadow)
  [L2] = Table candle 1 (flickering)
  [L3] = Table candle 2 (flickering)
  →    = Connection (doorway on west wall to foyer)
  Ch   = Chair
  ChPush = Pushed-back chair (angled, someone left quickly)
```

## Current Scene Notes
- Table, chairs, chandelier, candles, wine, plates, glasses, service vessel, lamp, and photo frame are now all represented in the declaration
- The room still intentionally has only one connection: back to the foyer
- The pushed chair and partial place settings should make the interruption read immediately from the doorway
