# Dining Room — Props (Non-Interactable)

## Structural

| Type | GLB | Count | Notes |
|------|-----|-------|-------|
| Wall panels | `wall_5.glb` | ~16 | Burgundy (variant 5) |
| Doorway | `doorway5.glb` | 1 | West wall, to foyer |
| Door | `door.glb` | 1 | In doorway |
| Floor tiles | `floor1.glb` | 20 | Wood parquet (4x5 grid) |
| Ceiling tiles | `cieling0.glb` | 20 | Ornate plaster |

## Furniture (Already In Scene)

| Name | GLB | Position | Transform | Notes |
|------|-----|----------|-----------|-------|
| Dining table | `shared/furniture/table.glb` | (0, 0, 0) | Scale(1.5, 1, 3) | Long formal table |
| Chandelier | `shared/decor/chandelier.glb` | (0, 2.2, 0) | Scale 0.7 | Above table center |
| Chair L0 | `shared/furniture/chair.glb` | (-1.5, 0, -2) | Rot 90° Y | Left side |
| Chair L1 | `shared/furniture/chair.glb` | (-1.5, 0, 0) | Rot 90° Y | Left side |
| Chair L2 | `shared/furniture/chair.glb` | (-1.5, 0, 2) | Rot 90° Y | Left side |
| Chair R0 | `shared/furniture/chair.glb` | (1.5, 0, -2) | Rot -90° Y | Right side |
| Chair R1 | `shared/furniture/chair.glb` | (1.5, 0, 0) | Rot -90° Y | Right side |
| **Chair Pushed** | `shared/furniture/chair.glb` | (2.2, 0, 2) | Rot ~110° Y | **THE pushed chair — angled away** |

## Table Setting Props (Already In Scene)

| Name | GLB | Position | Notes |
|------|-----|----------|-------|
| Wine bottle 1 | `dining_room/glass_bottle_mx_1.glb` | (0.3, 0.78, -1) | On table |
| Wine bottle 2 | `dining_room/glass_bottle_mx_2.glb` | (-0.2, 0.78, 0.5) | On table |
| Wine bottle 3 | `dining_room/glass_bottle_mx_3.glb` | (0.1, 0.78, 1.5) | On table |
| Serving vessel | `dining_room/serving_vessel.glb` | (-0.4, 0.78, -0.5) | On table |
| Candle 1 | `shared/items/candle2.glb` | (0, 0.78, -1.5) | South end table |
| Candle 2 | `shared/items/candle2.glb` | (0, 0.78, 1.5) | North end table |
| Plate 1-4 | `dining_room/dining_plate.glb` | Various | Place settings |
| Wine glasses | built from `wine_glass` interactable scene plus supporting glass props | Various | Hero full glass now owned by the interactable; other settings remain prop dressing |
| Lamp | `dining_room/lamp_mx_1_b_on.glb` | (-0.6, 0.78, 2) | Table lamp |
| Photo frame | `shared/decor/picture_blank_002.glb` | (3.9, 1.6, 0) | Dinner photo on east wall |

| Fork/knife/spoon | `dining_room/dining_fork.glb`, `dining_knife.glb`, `dining_spoon.glb` | Table positions | Added as table-read dressing so the meal feels interrupted, not symbolic |
| Water glasses | `dining_room/water_glass.glb` | Table positions | Added at selective settings to break uniformity |

Napkins remain implied by text rather than modeled, but the room should now read as fully staged without needing imaginary furniture.
