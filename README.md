# Ashworth Manor

A first-person PSX-style Victorian haunted house exploration game built with Godot 4.6.

```
Est. 1847 — Abandoned 1891
```

## Overview

Ashworth Manor is an atmospheric horror exploration game set in a five-floor Victorian mansion with exterior grounds. Players navigate through 20 interconnected rooms using tap-to-walk controls, discovering the dark secrets of the Ashworth family through environmental storytelling. The game features a PSX/PS1-era visual style with low-poly models, vertex lighting, and screen-space post-processing.

## Quick Start

```bash
# Open in Godot editor and press Play (F5)
# Or run headless build:
godot --headless --script scenes/build_main.gd
```

## Game Controls

| Action | Mobile | Desktop |
|--------|--------|---------|
| Move | Tap on floor | Click on floor |
| Look around | Swipe | Right-click + drag |
| Interact | Tap object | Click object |
| Pause | Tap menu icon | Escape |

## Tech Stack

- **Engine**: Godot 4.6 (Forward+)
- **Language**: GDScript
- **Rendering**: PSX screen-space post-process shader on CanvasLayer
- **Assets**: 1000+ files (376 GLBs, 596 PNGs, 36 OGG loops)
- **Asset Source**: Retro PSX Style Mansion v2.0, SBS Horror Textures, Lonely Nightmare audio

## Project Structure

```
project.godot              # Godot config: viewport, input maps, autoloads
scenes/
├── main.tscn              # Main scene (WorldEnvironment, PSXLayer, Player, etc.)
├── build_main.gd          # Headless scene builder
└── rooms/                 # 20 room .tscn files
    ├── ground_floor/      # foyer, parlor, dining_room, kitchen
    ├── upper_floor/       # hallway, master_bedroom, library, guest_room
    ├── basement/          # storage, boiler_room
    ├── deep_basement/     # wine_cellar
    ├── attic/             # stairwell, storage, hidden_chamber
    └── grounds/           # front_gate, garden, chapel, greenhouse,
                           # carriage_house, family_crypt
scripts/
├── game_manager.gd        # Autoload: game state, inventory, flags, save/load
├── room_manager.gd        # Scene instancing, fade transitions, room registry
├── room_base.gd           # Room root script (exported vars, flickering lights)
├── interactable_data.gd   # Custom Resource for interactable metadata
├── room_connection.gd     # Custom Resource for door/stairs connections
├── player_controller.gd   # CharacterBody3D, tap-to-walk, swipe-to-look
├── interaction_manager.gd # Puzzle logic, endings, document display
├── audio_manager.gd       # Room-based audio loops with crossfade
└── ui_overlay.gd          # Diegetic overlays (documents, room names, endings)
shaders/
├── psx.gdshader           # Per-material PSX vertex shader
└── psx_post.gdshader      # Screen-space post-process (color depth, dithering)
assets/
├── {floor}/{room}/        # Per-room GLBs, textures, and Godot imports
├── shared/                # Shared models: structure, furniture, decor, items
├── horror/                # Horror pack: dolls, flesh, textures
└── audio/loops/           # 36 OGG ambient loops
```

## Documentation

Detailed documentation is available in the `/docs` directory:

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Game Design](docs/GAME_DESIGN.md)
- [Environment Design](docs/ENVIRONMENT.md)
- [Technical Guide](docs/TECHNICAL.md)
- [Interaction System](docs/INTERACTIONS.md)

## The Story

The Ashworth family built this grand mansion in 1847, a testament to Victorian wealth and ambition. But behind the ornate woodwork and velvet drapery lies a darker history.

In 1889, the youngest daughter Elizabeth vanished. The family claimed illness, then silence. By 1891, the mansion stood empty—abandoned without explanation.

Players must explore all five floors, from the deep wine cellar to the hidden attic chamber, piecing together the truth through notes, photographs, and the house itself.

## Design Philosophy

- **Fully Diegetic**: No HUD elements that break immersion
- **Environment First**: Architecture and lighting tell the story
- **Mobile Native**: Designed for touch, not adapted from desktop
- **Period Authentic**: Victorian aesthetic with no modern intrusions

## License

Private project. All rights reserved.
