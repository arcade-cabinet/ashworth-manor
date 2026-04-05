# Footsteps Plan — godot-material-footsteps

## Source
- Addon: `COOKIE-POLICE/godot-material-footsteps`
- GitHub: https://github.com/COOKIE-POLICE/godot-material-footsteps
- Status: **TO INSTALL**

## Purpose

Surface-based footstep sounds via raycast material detection. VISION.md requires "Footsteps changed with surface."

## Surface → Sound Mapping

| Surface | Rooms | Sound Character | Files Needed |
|---------|-------|----------------|-------------|
| marble | Foyer | Hard click, echo | 4 variations |
| wood_parquet | Parlor, Bedrooms, Library | Soft thud | 4 variations |
| stone | Basement storage, Wine cellar | Echo, cold | 4 variations |
| metal_grate | Boiler room | Metallic clang | 4 variations |
| rough_wood | Attic rooms | Creaky | 4 variations |
| carpet | Upper hallway (runner) | Muffled | 4 variations |
| dirt | Grounds exterior | Soft crunch | 4 variations |
| grass | Garden | Rustling | 4 variations |
| gravel | Front gate path | Crunching | 4 variations |

Total: 9 surfaces x 4 variations = 36 footstep audio files needed.

## Detection Method

Use **metadata-based detection** on floor MeshInstance3D nodes:
- Tag each room's floor tiles with `footstep_surface` metadata
- Value matches surface name in mapping table

## Setup in PlayerController

```
PlayerController (CharacterBody3D)
├── Camera3D
└── MaterialFootstepPlayer3D
    ├── target_character: PlayerController
    ├── material_footstep_sound_map: { surface → AudioStream[] }
    └── step_interval: based on MOVE_SPEED
```

## Implementation Steps

1. Add to `plug.gd`: `plug("COOKIE-POLICE/godot-material-footsteps")`
2. Run gd-plug install
3. Source/create 36 footstep audio files (4 per surface)
4. Add `MaterialFootstepPlayer3D` node to PlayerController
5. Configure surface → sound mappings
6. Tag floor meshes in all 20 room scenes with `footstep_surface` metadata
7. Test: walk across every surface type, verify correct sound plays
