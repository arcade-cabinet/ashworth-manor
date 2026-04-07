# Parlor — Props (Non-Interactable)

## Structural

| Type | GLB | Count | Notes |
|------|-----|-------|-------|
| Wall panels | `wall_4.glb` | ~18 | Arsenic green (variant 4) |
| Doorway | `doorway4.glb` | 1 | South wall, to foyer |
| Door | `door.glb` | 1 | In doorway |
| Floor tiles | `floor1.glb` | ~25 | Wood parquet |
| Ceiling tiles | `cieling1.glb` | ~25 | Plaster with molding |

## Furniture & Decor

| Name | GLB | Position | Notes |
|------|-----|----------|-------|
| Fireplace | `shared/decor/fireplace.glb` | (0, 0, 4.5) | North wall center |
| Settee left | `shared/furniture/sofa.glb` | (-2, 0, -2) | Facing fireplace |
| Settee right | `shared/furniture/sofa.glb` | (2, 0, -2) | Facing fireplace, angled |
| Rug | `shared/decor/rug1.glb` | (0, 0.01, -1) | Persian rug between settees |
| Portrait frame | `shared/decor/picture_blank_001.glb` | (-4.5, 2, 0) | Lady Ashworth |
| Candle holder L | `shared/decor/candle_holder.glb` | (-3, 0.8, 0) | On side table |
| Candle holder R | `shared/decor/candle_holder.glb` | (3, 0.8, 0) | On side table |
| Stool | `ground_floor/parlor/stool_mx_1.glb` | (3, 0, 3) | Near fireplace |
| Dead lamp | `ground_floor/parlor/lamp_mx_4_off.glb` | (4, 0.8, -3) | Unlit lamp on side table |

| Side table L | `shared/furniture/table.glb` | (-2, 0, -3) | Under music box, scale small |
| Side table R | `shared/furniture/table.glb` | (2, 0, -3) | Under diary note, scale small |
| Writing desk | `shared/furniture/study_desk.glb` | (-3.8, 0, -3.4) | Lady's desk, offset left so the diary clue feels placed not floating |

Heavy drapes remain implied rather than modeled, but the rest of the room should now read as furnished enough to sell the social fiction that once lived here.

The central tea tableau is no longer faked with bottle and jar props. It is now
owned by the `parlor_tea` interactable as a scene-authored setpiece so the room
actually reads as afternoon tea gone cold.
