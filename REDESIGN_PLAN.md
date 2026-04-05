# Room Rebuild Plan — Using Mansion Pack Correctly

## Problem

Every room is built with CSGBox3D flat-colored boxes. The mansion asset pack provides 60+ modular structure pieces designed to build rooms. We're using them as decorative props when they ARE the architecture.

## How the Mansion Pack Works

It's a **modular construction kit**. Each piece is ~2m x ~2m, designed to tile:

### Wall System (matches texture variants 0-8)
| Piece | When to use |
|-------|-------------|
| `wall_X.glb` | Solid wall section (no opening) |
| `doorway_X.glb` | Wall section WITH door opening |
| `window_wallX.glb` | Wall section WITH window opening |

Each X matches a texture: 0=red Victorian, 1=dark damask, 2=blue, 3=paneling, 4=green, 5=burgundy, 6=stone, 7=plaster, 8=rough stone

### Floor System
| Piece | Usage |
|-------|-------|
| `floor0.glb` | Marble checkered (foyer) |
| `floor1.glb` | Wood parquet (most rooms) |
| `floor2.glb` | Rough stone (kitchen, attic) |
| `floor3.glb` | Dark flagstone (basement) |
| `floor4.glb` | Metal grate (boiler) |

### Ceiling System
| Piece | Usage |
|-------|-------|
| `cieling0.glb` | Ornate plaster (grand rooms) |
| `cieling1.glb` | Plaster with molding (standard) |
| `cieling2.glb` | Exposed beams (service, attic) |

### Accessories
- `door.glb`, `door1.glb` — actual door models for doorways
- `window.glb`, `window_clean.glb` — window pane inserts
- `window_ray.glb` — volumetric light beam through window!
- `stairs0-3.glb` — staircase variants
- `pillar0-1` variants — decorative columns
- `banister.glb`, `stairbanister.glb` — railings

## Room Construction Method

For a room like the Foyer (9m wide × 10.5m deep):

### Walls (each wall piece is ~2m wide)
**North wall** (9m = ~5 pieces): 
- `wall_0.glb` | `doorway0.glb` (to parlor) | `wall_0.glb` | `wall_0.glb` | `wall_0.glb`

**South wall** (9m = ~5 pieces):
- `wall_0.glb` | `wall_0.glb` | `doorway0.glb` (entrance) | `wall_0.glb` | `wall_0.glb`

**East wall** (10.5m = ~5 pieces):
- `window_wall0.glb` (with window pane + ray) | `wall_0.glb` | `wall_0.glb` | `doorway0.glb` (to dining) | `wall_0.glb`

**West wall** (10.5m = ~5 pieces):
- `wall_0.glb` | `wall_0.glb` | `doorway0.glb` (to kitchen) | `wall_0.glb` | `wall_0.glb`

### Floor (tiled)
- `floor0.glb` tiled in a grid across the floor area

### Ceiling
- `cieling0.glb` tiled overhead

### Collision (invisible)
- StaticBody3D with BoxShape3D for floor (layer 1) 
- StaticBody3D with BoxShape3D for each wall section (layer 2)

## Room-by-Room Assignments

| Room | Wall variant | Floor | Ceiling | Doorway count |
|------|-------------|-------|---------|---------------|
| Foyer | wall_0 (red) | floor0 (marble) | cieling0 (ornate) | 4 doors + 1 stair |
| Parlor | wall_4 (green) | floor1 (parquet) | cieling1 (molding) | 1 door |
| Dining | wall_5 (burgundy) | floor1 | cieling0 | 1 door |
| Kitchen | wall_7 (plaster) | floor2 (stone) | cieling2 (beams) | 1 door + 1 stairs down |
| Hallway | wall_1 (dark) | floor1 | cieling1 | 4 doors + 1 stairs + 1 locked |
| Master Bed | wall_2 (blue) | floor1 | cieling1 | 1 door + 1 window |
| Library | wall_3 (paneling) | floor1 | cieling2 (coffered) | 1 door |
| Guest Room | wall_1 (simple) | floor1 | cieling1 | 1 door + 1 window |
| Storage | wall_6 (stone) | floor3 (flagstone) | cieling2 | 1 door + 1 door + 1 ladder |
| Boiler | wall_8 (brick) | floor4 (metal) | cieling2 | 1 door |
| Wine Cellar | wall_6 (stone) | floor3 | cieling2 | 1 ladder |
| Attic Stair | wall_7 | floor2 (rough) | - | 1 stairs + 1 door |
| Attic Store | wall_7 | floor2 | cieling2 (rafters) | 1 door + 1 hidden |
| Hidden | wall_7 | floor2 | - | 1 door |

## Environment

### Night Sky (exterior rooms)
```
ProceduralSkyMaterial:
  sky_top_color: Color(0.02, 0.02, 0.08)  — near-black with blue tint
  sky_horizon_color: Color(0.05, 0.04, 0.08)
  ground_bottom_color: Color(0.01, 0.01, 0.02)
  ground_horizon_color: Color(0.03, 0.03, 0.06)
```

### Volumetric Fog (interior rooms)
```
volumetric_fog_enabled: true
volumetric_fog_density: 0.02
volumetric_fog_albedo: Color(0.15, 0.1, 0.08)  — warm dust
volumetric_fog_emission: Color(0, 0, 0)
volumetric_fog_length: 30
```

### SSAO + SSIL for depth
```
ssao_enabled: true
ssao_radius: 1.5
ssao_intensity: 2.5
ssil_enabled: true  — screen-space indirect light bounces
ssil_intensity: 0.8
```

## Implementation Order

1. Build ONE room perfectly (Foyer) — set the standard
2. Verify it looks correct with screenshot + VQA
3. Build remaining rooms following the same pattern
4. Each room gets: modular walls, doorways with doors, windows with rays, tiled floors, proper lighting
5. Export APK, test with Maestro

## Success Criteria

- NO CSGBox3D visible to the player — all geometry is GLB models
- CSGBox3D ONLY for invisible collision volumes
- Every doorway has a visible door model
- Every window has a light ray
- Night sky visible through windows and in exterior rooms  
- Volumetric fog visible in every interior room
- Each room has a distinct color identity from its wall variant
- Objects are placed as composed tableaux, not scattered
