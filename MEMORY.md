# Memory

## Architecture Decisions

- Single main scene with dynamic room loading (no pre-built room .tscn files)
- RoomManager creates room geometry using CSGBox3D for walls/floors (with collision)
- GLB models are instantiated from PackedScene at runtime per room data
- Interactables use Area3D with metadata for raycast identification
- GameManager is autoload singleton for all game state
- PSX shader applied as material override on all mesh surfaces
- Touch input handled programmatically (not via input actions) — tap vs swipe detection
- Audio crossfade between room loops using dual AudioStreamPlayer

## Quirks Discovered

- Godot 4.6.2 on macOS (Apple Silicon)
- Assets in assets/ directory (not imported yet — need `godot --headless --import` before scene builders)
- 116 mansion GLBs have embedded textures — no separate texture application needed
- Horror doll GLBs (doll1.glb, doll2.glb) are Godot-ready (filename includes "godot")
- OGG audio files have spaces in filenames — use exact names from ASSETS.md

## Asset Notes

- Mansion pack GLBs use "cieling" (typo in original) not "ceiling"
- `candle_ulit1.glb` is a typo for "candle_unlit1" in the original pack
- Picture frames are `picture_blank.glb` through `picture_blank_009.glb`
- Pillars have two families: pillar0 (4 variants, ornate) and pillar1 (8 variants, tall)
