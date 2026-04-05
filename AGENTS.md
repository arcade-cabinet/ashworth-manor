# AGENTS.md - AI Development Guide for Ashworth Manor

This document provides guidance for AI agents working on the Ashworth Manor codebase.

## Project Context

Ashworth Manor is a **mobile-first, first-person Victorian haunted house exploration game** built with Babylon.js and React. The game prioritizes atmosphere, immersion, and diegetic design over traditional game UI patterns.

## Critical Design Constraints

### DO NOT

- Add neon colors, cyberpunk aesthetics, or futuristic elements
- Create floating UI elements or HUD overlays during gameplay
- Add joystick controls or virtual buttons
- Use sans-serif fonts for in-game text
- Create ambient light without a physical source
- Add enemies or combat mechanics (environment-first development)
- Break the Victorian time period (1847-1891)

### ALWAYS

- Ensure lighting has a visible physical source (candle, sconce, window, fireplace)
- Maintain the color palette: dark reds, deep browns, aged golds, blacks
- Keep interactions diegetic (in-world responses, not UI popups)
- Test on mobile viewport sizes
- Preserve tap-to-walk and swipe-to-look controls
- Use serif fonts (Cinzel, Cormorant Garamond) for all text

## Architecture Overview

```
src/
├── components/          # React UI components
│   ├── Game.tsx        # Main game wrapper, handles overlays
│   └── LandingPage.tsx # Title screen with particle effects
├── game/               # Babylon.js game engine
│   ├── SceneManager.ts # Core scene management (800+ lines)
│   ├── TextureGenerator.ts # Procedural Victorian textures
│   └── types.ts        # TypeScript interfaces
├── data/
│   └── houseLayout.ts  # Room definitions (700+ lines)
└── App.tsx             # Screen state management
```

## Key Files

### SceneManager.ts
The heart of the game engine. Handles:
- Babylon.js scene setup and rendering
- Camera and movement system
- Room geometry generation
- Lighting with flickering effects
- Interactable object management
- Touch/mouse input processing

**When modifying**: Be careful with the render loop and shadow generators. Performance on mobile is critical.

### houseLayout.ts
Contains all room data for the 5-floor mansion:
- Room dimensions and positions
- Light source placements
- Interactable objects with metadata
- Connection/transition definitions
- Texture assignments

**When modifying**: Maintain the connection graph consistency. Every `targetRoom` must exist.

### Game.tsx
React component bridging UI and Babylon.js:
- Initializes SceneManager
- Handles interaction callbacks
- Manages game state
- Renders diegetic overlays (notes, pause menu)

## Code Patterns

### Adding a New Room

```typescript
// In houseLayout.ts
{
  id: 'new_room',
  floor: 0,
  name: 'Room Name',
  description: 'Atmospheric description...',
  dimensions: { width: 8, depth: 10, height: 4 },
  position: { x: 0, y: 0, z: 20 }, // World position
  connections: [
    { direction: 'south', targetRoom: 'existing_room', type: 'door', position: { x: 0, y: 0, z: -5 } }
  ],
  interactables: [...],
  lights: [...],
  floorTexture: 'wood_dark',
  wallTexture: 'wallpaper_victorian_red',
  ceilingTexture: 'plaster_ornate',
  ambientDarkness: 0.5
}
```

### Adding a New Interactable Type

1. Add type to `Interactable['type']` union in `houseLayout.ts`
2. Handle geometry creation in `SceneManager.createInteractables()`
3. Handle interaction logic in `Game.tsx handleInteraction()`
4. Add color mapping in `SceneManager.getInteractableColor()`

### Adding a New Light Type

1. Add type to `LightSource['type']` union
2. Handle in `SceneManager.createRoomLights()` for Babylon light
3. Handle in `SceneManager.createLightSourceMesh()` for visual mesh

## Testing Checklist

Before submitting changes:

- [ ] `pnpm tscgo --noEmit` passes
- [ ] Game loads on mobile viewport (375x667)
- [ ] Tap-to-walk functions correctly
- [ ] Swipe-to-look functions correctly
- [ ] New rooms are accessible via connections
- [ ] Lighting appears natural with visible sources
- [ ] Text uses serif fonts
- [ ] No neon or modern colors introduced

## Performance Considerations

- Shadow generators are expensive; limit to key lights (chandeliers, fireplaces)
- Dispose meshes properly when changing rooms
- Use `StandardMaterial` over PBR for mobile performance
- Keep polygon counts low; rooms use simple box/plane geometry
- Texture cache in TextureGenerator prevents redundant generation

## Narrative Guidelines

The story follows the Ashworth family tragedy:
- Lord and Lady Ashworth had four children, not three
- Elizabeth (the fourth) was hidden away due to her "abilities"
- She was confined to the attic and eventually "became part of the house"
- Notes and photographs reveal this gradually
- The tone is melancholic horror, not jump-scare horror

When writing in-game text:
- Use formal Victorian language
- Date entries between 1880-1891
- Reference the family: Lord Ashworth, Lady Ashworth, "the children"
- Hint at supernatural elements subtly

## Common Tasks

### Adjusting atmosphere/mood
Modify in `SceneManager.constructor()`:
- `scene.fogDensity` - increase for more oppressive feel
- `scene.ambientColor` - overall tint
- Post-processing in `setupPostProcessing()`

### Changing movement speed
In `SceneManager`:
- `moveSpeed` property (default: 3)
- Camera rotation sensitivity in `setupInputHandling()`

### Adding new texture types
1. Add color mapping in `SceneManager.createMaterial()`
2. Optionally create procedural texture in `TextureGenerator`

## Contact

For architectural decisions or major changes, document reasoning in commit messages and update relevant docs.
