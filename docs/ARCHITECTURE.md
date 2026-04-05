# Architecture Overview

This document describes the technical architecture of Ashworth Manor.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        React Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   App.tsx   │  │ LandingPage │  │      Game.tsx       │ │
│  │ (Router)    │  │ (Menu)      │  │ (Game Container)    │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Babylon.js Layer                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  SceneManager                        │   │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────────────┐  │   │
│  │  │  Engine   │ │   Scene   │ │ UniversalCamera   │  │   │
│  │  └───────────┘ └───────────┘ └───────────────────┘  │   │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────────────┐  │   │
│  │  │  Lights   │ │  Meshes   │ │ ShadowGenerators  │  │   │
│  │  └───────────┘ └───────────┘ └───────────────────┘  │   │
│  │  ┌───────────────────────────────────────────────┐  │   │
│  │  │           PostProcessing Pipeline             │  │   │
│  │  └───────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                            │
│  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │  houseLayout.ts │  │      TextureGenerator.ts        │  │
│  │  (Room Data)    │  │  (Procedural Textures)          │  │
│  └─────────────────┘  └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Component Responsibilities

### App.tsx
- **Purpose**: Root component managing screen state
- **State**: Current screen (`landing` | `game`), save data detection
- **Responsibilities**:
  - Route between landing page and game
  - Handle new game / continue logic
  - Manage localStorage for save data

### LandingPage.tsx
- **Purpose**: Atmospheric title screen
- **Features**:
  - Canvas-based particle system (dust/fog effect)
  - Animated title with flickering effect
  - Victorian-styled menu buttons
  - Radial vignette overlay

### Game.tsx
- **Purpose**: Main game container bridging React and Babylon.js
- **State**: Game state, active interactions, room transitions, pause state
- **Responsibilities**:
  - Initialize and dispose SceneManager
  - Handle interaction callbacks from engine
  - Render diegetic overlays (notes, room names)
  - Manage pause menu

### SceneManager.ts
- **Purpose**: Core Babylon.js game engine
- **Responsibilities**:
  - Engine and scene initialization
  - Camera setup and movement
  - Room geometry generation
  - Lighting system with flickering
  - Interactable object creation
  - Input handling (tap/swipe)
  - Room transitions
  - Shadow generation
  - Post-processing effects

### houseLayout.ts
- **Purpose**: Static data defining the mansion
- **Contains**:
  - Room definitions for all 5 floors (14 rooms total)
  - Connection graph between rooms
  - Light source placements
  - Interactable object definitions
  - Texture assignments
  - Helper functions for room lookup

### TextureGenerator.ts
- **Purpose**: Procedural texture generation
- **Capabilities**:
  - Victorian wallpaper patterns (damask)
  - Wood grain textures
  - Stone/brick textures
  - Marble checkered floors
  - Noise/aging effects

## Data Flow

### Initialization Flow
```
App mounts
    │
    ▼
LandingPage renders
    │
    ▼ (User clicks "New Game")
    │
Game component mounts
    │
    ▼
SceneManager instantiated
    │
    ├─► Engine created
    ├─► Scene created
    ├─► Camera positioned
    ├─► Post-processing setup
    ├─► Initial room built
    └─► Render loop started
```

### Interaction Flow
```
User taps screen
    │
    ▼
SceneManager.setupInputHandling()
    │
    ├─► scene.pick() ray cast
    │
    ▼
Mesh metadata checked
    │
    ├─► walkable: true  ──► walkTo(position)
    ├─► interactable: true ──► handleInteraction()
    └─► transition: true ──► handleTransition()
    │
    ▼
Callback to Game.tsx
    │
    ▼
React state updated
    │
    ▼
Overlay rendered (if applicable)
```

### Room Transition Flow
```
User taps door/stairs
    │
    ▼
handleTransition(targetRoom)
    │
    ▼
fadeTransition() - DOM overlay
    │
    ▼
clearCurrentRoom()
    ├─► Dispose room meshes
    ├─► Dispose interactables
    ├─► Dispose lights
    └─► Clear shadow generators
    │
    ▼
buildRoom(newRoomId)
    ├─► Create room geometry
    ├─► Add architectural details
    ├─► Create lights
    ├─► Create interactables
    └─► Position camera
    │
    ▼
onRoomChange callback to Game.tsx
    │
    ▼
Room name overlay displayed
```

## State Management

### Game State (Game.tsx)
```typescript
interface GameState {
  screen: 'landing' | 'game' | 'paused';
  currentRoom: string;
  currentFloor: number;
  inventory: string[];
  visitedRooms: string[];
  interactedObjects: string[];
  lightsToggled: Record<string, boolean>;
}
```

### Scene State (SceneManager)
- `currentRoom`: Active room ID
- `isMoving`: Player movement in progress
- `targetPosition`: Destination for movement
- `roomMeshes`: Map of room ID to mesh arrays
- `interactableMeshes`: Map of interactable ID to mesh
- `lightSources`: Map of light ID to Babylon light
- `shadowGenerators`: Array of active shadow generators

## Memory Management

### Mesh Lifecycle
1. Meshes created in `buildRoom()`
2. Stored in `roomMeshes` / `interactableMeshes` maps
3. Disposed in `clearCurrentRoom()` before room change
4. Full cleanup in `dispose()` when Game unmounts

### Texture Caching
- `TextureGenerator` maintains a cache map
- Textures keyed by name/type
- Reused across room rebuilds
- Disposed when generator is disposed

## Performance Optimizations

1. **Single room rendering**: Only current room meshes exist
2. **Shadow generator limits**: Only key lights cast shadows
3. **LOD-free geometry**: Simple boxes/planes for mobile
4. **Texture caching**: Procedural textures generated once
5. **Event delegation**: Single touch handler for all interactions
6. **Render loop efficiency**: Minimal per-frame calculations
