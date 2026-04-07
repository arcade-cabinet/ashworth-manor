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
# Or run a boot smoke test:
godot --headless --path . --quit-after 1
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
- **Runtime**: Declaration-driven room/world assembly
- **Assets**: 1000+ files (376 GLBs, 596 PNGs, 36 OGG loops)
- **Asset Source**: Retro PSX Style Mansion v2.0, SBS Horror Textures, Lonely Nightmare audio

## Project Structure

```
project.godot              # Godot config: viewport, input maps, autoloads
declarations/              # Canonical room/world/item/puzzle/thread data
engine/                    # Declaration runtime, builders, validators
scenes/
├── main.tscn              # Runtime shell and managers
└── rooms/                 # Legacy/reference room scenes only
scripts/
├── game_manager.gd        # Autoload: game state, inventory, flags, save/load
├── room_manager.gd        # Declaration-first room lifecycle and transitions
├── room_base.gd           # Runtime room API (spawn, lights, interactables)
├── player_controller.gd   # CharacterBody3D, tap-to-walk, swipe-to-look
├── interaction_manager.gd # Runtime interaction dispatch and endings
├── room_events.gd         # Declaration triggers, ambient and conditional events
├── audio_manager.gd       # Room-based audio loops with crossfade
└── ui_overlay.gd          # Diegetic overlays (documents, room names, endings)
assets/
├── {floor}/{room}/        # Per-room GLBs, textures, and Godot imports
├── shared/                # Shared models: structure, furniture, decor, items
├── horror/                # Horror pack: dolls, flesh, textures
└── audio/loops/           # 36 OGG ambient loops
```

## Documentation

Detailed documentation is available in the `/docs` directory:

- [Documentation Index](docs/INDEX.md)
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

## Validation

```bash
godot --headless --path . --quit-after 1
godot --headless --path . --script test/generated/test_declarations.gd
godot --headless --path . --script test/e2e/test_declared_interactions.gd
godot --headless --path . --script test/e2e/test_room_specs.gd
godot --headless --path . --script test/e2e/test_full_playthrough.gd
godot --headless --path . --script test/e2e/test_room_walkthrough.gd
```

## License

Private project. All rights reserved.
