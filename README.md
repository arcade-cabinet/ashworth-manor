# Ashworth Manor

A first-person Victorian haunted house exploration game built with Babylon.js and React, designed specifically for mobile devices.

```
Est. 1847 — Abandoned 1891
```

## Overview

Ashworth Manor is an atmospheric horror exploration game set in a five-floor Victorian mansion. Players navigate through interconnected rooms using tap-to-walk controls, discovering the dark secrets of the Ashworth family through environmental storytelling.

## Quick Start

```bash
# Install dependencies
pnpm install

# Start development server
pnpm dev

# Type check
pnpm tscgo --noEmit

# Build for production
pnpm build
```

## Game Controls

| Action | Mobile | Desktop |
|--------|--------|---------|
| Move | Tap on floor | Click on floor |
| Look around | Swipe | Right-click + drag |
| Interact | Tap object | Click object |
| Pause | Tap menu icon | Tap menu icon |

## Tech Stack

- **Engine**: Babylon.js 9.x
- **Framework**: React 19 + TypeScript
- **Styling**: Tailwind CSS 4
- **Animation**: Framer Motion
- **Build**: Vite

## Project Structure

```
src/
├── components/
│   ├── Game.tsx          # Main game component
│   └── LandingPage.tsx   # Title screen
├── game/
│   ├── SceneManager.ts   # Babylon.js scene controller
│   ├── TextureGenerator.ts # Procedural textures
│   └── types.ts          # Game type definitions
├── data/
│   └── houseLayout.ts    # Mansion floor plans & room data
└── App.tsx               # Root application
```

## Documentation

Detailed documentation is available in the `/docs` directory:

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Art Direction](docs/ART_DIRECTION.md)
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
