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
| Side table | `assets/shared/furniture/table.glb` | Secondary work surface framing the dead rows |

Authored shell:

| Name | Scene | Notes |
|------|-------|-------|
| Glazed shell | [`greenhouse_glazed_shell.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_glazed_shell.tscn) | PSX-style beam-and-pane enclosure with broken north breach, sill rails, and roof glazing |
| Lily pedestal | [`greenhouse_lily_pedestal.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_lily_pedestal.tscn) | Small central stand so the lily reads as a shrine, not a broad worktable mass |
| Hanging lantern | [`greenhouse_hanging_lantern.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_hanging_lantern.tscn) | Visible warm light source above the lily tableau |

Current declaration layering now uses:
- one scene-authored glazed shell so the room actually reads as an enclosure
- one central pedestal for the living lily focal point
- one hanging lantern so the warmth has a visible physical source
- one side table with extra bottle clutter so the room reads as tended, not merely empty
- dead rows plus winter intrusion to keep the living lily visually singular
