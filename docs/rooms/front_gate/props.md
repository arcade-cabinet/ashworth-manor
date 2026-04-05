# Front Gate — Props (Non-Interactable)

## Structural Elements

| Name | GLB Path | Position | Transform | Notes |
|------|----------|----------|-----------|-------|
| Iron Gate | `grounds/front_gate/iron_gate.glb` | (0, 0, -10) | Scale 1.5 | Central gate, rusted open |
| Gate Pillar L | `shared/structure/pillar0.glb` | (-4, 0, -10) | Default | Left gate pillar |
| Gate Pillar R | `shared/structure/pillar0_001.glb` | (4, 0, -10) | Default | Right gate pillar |
| Boundary Wall | `grounds/front_gate/brick_wall.glb` | (-9, 0, -10) | Default | Wall extending left |
| Boundary Corner | `grounds/front_gate/brick_Wall_corner.glb` | (9, 0, -10) | Default | Wall corner right |
| Fence Section | `grounds/front_gate/metalfence_both_sides_topbar.glb` | (-7, 0, -10) | Default | Iron fence left of gate |

## Vegetation

| Name | GLB Path | Position | Transform | Notes |
|------|----------|----------|-----------|-------|
| Tree 1 | `grounds/front_gate/tree01_winter.glb` | (-8, 0, -5) | Default | Bare winter tree, left |
| Tree 2 | `grounds/front_gate/tree02_winter.glb` | (8, 0, -3) | Rot 30° Y | Bare tree, right |
| Tree 3 | `grounds/front_gate/tree03_winter.glb` | (-7, 0, 5) | Rot -45° Y | Bare tree, far left |
| Tree 4 | `grounds/front_gate/tree04_winter.glb` | (7, 0, 7) | Rot 60° Y | Bare tree, far right |
| Bush 1 | `grounds/front_gate/bush01_winter.glb` | (-6, 0, -9) | Default | Dead bush, left of path |
| Bush 2 | `grounds/front_gate/bush02_winter.glb` | (6, 0, -9) | Default | Dead bush, right of path |
| Drive Hedge | `grounds/front_gate/nature.glb` | (-8, 0, 0) | Scale 0.8 | Overgrown hedge mass |

## Ground Detail

| Name | GLB Path | Position | Notes |
|------|----------|----------|-------|
| Rocks | `grounds/front_gate/rocks.glb` | (-3, 0, 8) | Rock cluster near mansion |

## Props TO ADD (Currently Missing)

| Name | GLB Path | Position | Notes |
|------|----------|----------|-------|
| Gate Lamp Model | `grounds/front_gate/lamp_mx_1_b_on.glb` | (-4, 0, -10) | Physical lamp on pillar (light source exists but no model) |
| Bush 3 | `grounds/front_gate/bush03_winter.glb` | (-3, 0, -3) | Fill mid-area |
| Bush 4 | `grounds/front_gate/bush04_winter.glb` | (3, 0, 3) | Fill mid-area |
| Brick Wall Pole | `grounds/front_gate/brick_wall_pole.glb` | (6, 0, -10) | Fence post right side |
| Off Lamp | `grounds/front_gate/lamp_mx_1_a_off.glb` | (4, 0, -10) | Dead lamp on right pillar (contrast with lit left) |

## Floor Tiles

Using `floor3.glb` (dark flagstone) as stepping-stone path:
- Full row at Z=-9 (10 tiles, gate entrance area)
- Sparse at Z=1 and Z=9 (3 tiles each, path stones toward mansion)

The gaps between tiles represent gravel/dirt ground. Footstep material metadata:
- On floor3 tiles: `footstep_surface = "gravel"`
- Off tiles (ground collision): `footstep_surface = "dirt"`
