# Memory

## Architecture Decisions

### Current (Scene-Based Architecture)
- Each room is a standalone .tscn scene file in scenes/rooms/{floor}/{room}.tscn
- RoomManager instances PackedScene from a registry dict, adds to RoomContainer, frees previous
- Room root nodes use room_base.gd with exported vars (room_id, room_name, audio_loop, etc.)
- Interactables use Area3D in group "interactables" with InteractableData custom Resource
- Connections use Area3D in group "connections" with RoomConnection custom Resource
- GameManager is autoload singleton for all game state
- PSX shader is a screen-space canvas_item post-process on CanvasLayer (not per-material)
- Touch input handled programmatically (not via input actions) -- tap vs swipe detection
- Audio crossfade between room loops using dual AudioStreamPlayer
- 20 rooms total (14 interior + 6 exterior grounds including Garden)
- Assets organized by named room dirs: assets/{floor}/{room}/, shared pool at assets/shared/

### Previous (Deprecated -- room_data.gd approach)
- Was: single main scene with monolithic room_data.gd generating rooms at runtime
- Was: RoomManager created CSGBox3D geometry and instanced GLBs per room_data dict
- Was: interactables stored as raw dictionaries in room_data, not as Resources
- Was: PSX shader applied as material override on all mesh surfaces
- Redesigned because scene-based approach gives better editor workflow and isolation

## Quirks Discovered

- Godot 4.6.2 on macOS (Apple Silicon)
- Assets organized under assets/ by floor/room matching scene hierarchy
- 376 GLBs + 596 PNGs + 36 OGGs = 1000+ total asset files
- Mansion GLBs have embedded textures -- no separate texture application needed
- Horror doll GLBs (doll1.glb, doll2.glb) are Godot-ready
- OGG audio files have spaces in filenames -- use exact names from ASSETS.md
- room_data.gd still exists in scripts/ but is no longer used by the scene-based architecture

## Asset Notes

- Mansion pack GLBs use "cieling" (typo in original) not "ceiling"
- `candle_ulit1.glb` is a typo for "candle_unlit1" in the original pack
- Picture frames are `picture_blank.glb` through `picture_blank_009.glb`
- Pillars have two families: pillar0 (4 variants, ornate) and pillar1 (8 variants, tall)
- Godot import creates .import files alongside each asset, contributing to the high file count
