# Shader Plan — godot-psx

## Source
- Addon: `AnalogFeelings/godot-psx`
- Location: `.plugged/godot-psx/Shaders/`
- Shaders available: `psx_lit.gdshader`, `psx_unlit.gdshader`, `psx_dither.gdshader`, `psx_fade.gdshader`

## Core Rule

**NO per-material shaders on PSX assets.**

The 116 mansion pack GLBs are pre-made PSX models with:
- Already low-poly geometry (no need for vertex snapping)
- Already baked PSX textures (no need for affine mapping)
- 596 texture PNGs at PSX resolution

Applying `psx_lit` or `psx_unlit` to these models = double-processing with no visual benefit and potential visual degradation.

## What We Use

### 1. `psx_dither.gdshader` — Screen-Space Post-Process
**Purpose:** Renders the entire game through PSX-style dithering, color depth reduction, and resolution downscaling.

**How it works:**
- Applied as ShaderMaterial on a SubViewportContainer
- Game camera renders into a SubViewport
- SubViewportContainer displays the viewport with the dither shader
- Parameters: color depth, resolution scale, dither pattern

**Setup in main.tscn:**
```
Main (Node3D)
├── SubViewportContainer (with psx_dither ShaderMaterial)
│   └── SubViewport (renders the game)
│       ├── WorldEnvironment
│       ├── PlayerController (Camera3D inside)
│       └── RoomManager
├── UILayer (CanvasLayer, rendered ABOVE the viewport — crisp UI)
│   └── UIOverlay
└── Managers (AudioManager, InteractionManager, etc.)
```

**Parameters:**
- `color_depth`: 15.0 (authentic PS1 = ~15-bit color)
- `resolution_scale`: 0.5 (half-res for chunky pixels)
- `dither_strength`: 0.3 (subtle Bayer dithering)

### 2. `psx_fade.gdshader` — Transition Fade
**Purpose:** Dither-based fade for room transitions. More authentic than linear alpha fade.

**Replaces:** The `ColorRect` alpha tween in `room_manager.gd`

**How it works:**
- Applied to a ColorRect overlay
- `alpha` uniform (0-255) controls fade progress
- Tween animates `alpha` from 0→255 (fade out) then 255→0 (fade in)
- Produces dithered dissolve pattern instead of smooth gradient

**Integration with room_manager.gd:**
```gdscript
# Replace _fade_rect ColorRect with psx_fade shader material
# Tween shader_material.set_shader_parameter("alpha", value)
```

## What We Delete

| File | Action | Reason |
|------|--------|--------|
| `shaders/psx.gdshader` | DELETE | Per-material vertex snapping shader. Not used in any scene. Wrong for PSX assets. |
| `shaders/psx.gdshader.uid` | DELETE | UID file for deleted shader |
| `shaders/psx_post.gdshader` | REPLACE | Custom post-process. Replace with upstream `psx_dither.gdshader` |
| `shaders/psx_post.gdshader.uid` | DELETE | UID file for replaced shader |

## What We Do NOT Use

| Shader | Why Not |
|--------|---------|
| `psx_lit.gdshader` | Applies vertex snapping + affine to materials. Our GLBs already have PSX geometry. |
| `psx_unlit.gdshader` | Same as lit but without lighting. Same problem. |

## Texture Protection

The 596 PNGs in `assets/shared/textures/` and `assets/horror/textures/` are pre-made PSX textures. They must:
- Use `filter_nearest` import setting (no bilinear smoothing)
- NOT have any shader material overrides applied
- Render through GLB's embedded materials only
- The dither post-process applies to the final frame, not to individual textures

## Implementation Steps

1. Delete `shaders/psx.gdshader` and its `.uid`
2. Copy `psx_dither.gdshader` from `.plugged/godot-psx/Shaders/` to project
3. Copy `psx_fade.gdshader` from `.plugged/godot-psx/Shaders/` to project
4. Update `main.tscn` to use `psx_dither` instead of `psx_post`
5. Update `room_manager.gd` fade system to use `psx_fade` shader
6. Verify all texture PNGs import with `filter_nearest`
7. Verify NO room .tscn files have material overrides with custom shaders
