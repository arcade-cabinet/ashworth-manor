# Greenhouse — Props

From `assets/grounds/greenhouse/`:

| Name | GLB | Notes |
|------|-----|-------|
| Buckets | `bucket_mx_2.glb`, `bucket_mx_3.glb` | Gardening |
| Bottle | `glass_bottle_mx_2.glb` | Fertilizer? |
| Wooden planks | `wooden_plank_1.glb`, `wooden_plank_2.glb` | Shelving |
| Nature/bushes | `nature.glb`, `bush05_winter.glb`, `bush06_winter.glb` | Living intrusion around the lily |
| Dead hedge forms | `bush_long_dead.glb`, `bush_end_dead.glb`, `bush_tall_dead.glb` | Rows of dead greenhouse stock |

From shared assets:

| Name | GLB | Notes |
|------|-----|-------|
| Table | `assets/shared/furniture/table.glb` | Central potting/work table |
| Side table | `assets/shared/furniture/table.glb` | Secondary work surface framing the dead rows |
| Window ray | `assets/shared/structure/window_ray.glb` | Broken-glass moon shaft near the rear opening |

Authored shell:

| Name | Scene | Notes |
|------|-------|-------|
| Glazed shell | `scenes/shared/greenhouse/greenhouse_glazed_shell.tscn` | PSX-style beam-and-pane enclosure with broken north breach and roof glazing |

Current declaration layering now uses:
- one scene-authored glazed shell so the room actually reads as an enclosure
- one central work table for the living lily focal point
- one side table with extra bottle clutter so the room reads as tended, not merely empty
- a broken-glass moon shaft to pull the eye toward the rear breach
- dead rows plus winter intrusion to keep the living lily visually singular
