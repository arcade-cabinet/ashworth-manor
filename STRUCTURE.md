# Ashworth Manor

## Dimension: 3D

## Input Actions

| Action | Keys / Events |
|--------|--------------|
| interact | Left Click / Touch Tap |
| pause | Escape |

Touch input (tap vs swipe) is handled programmatically in PlayerController — not through Godot input actions. Only interaction tap and pause use the action map.

## Scenes

### Main
- **File:** res://scenes/main.tscn
- **Root type:** Node3D
- **Children:** WorldEnvironment, GameManager (autoload), RoomManager, PlayerController, UILayer

### Room (template — 19 instances generated at runtime)
- **Not a scene file** — rooms are loaded/built dynamically by RoomManager
- Each room is a Node3D with GLB model instances, lights, interactable areas

## Scripts

### GameManager (Autoload Singleton)
- **File:** res://scripts/game_manager.gd
- **Extends:** Node
- **Autoload name:** GameManager
- **Responsibilities:**
  - Game state (current_room, inventory, visited_rooms, interacted_objects, flags)
  - Save/load to user://save.json
  - Screen state (landing, game, paused)
  - Flag checking for puzzles and endings
- **Signals emitted:** state_changed, item_acquired, flag_set, ending_triggered

### RoomManager
- **File:** res://scripts/room_manager.gd
- **Extends:** Node3D
- **Attaches to:** Main:RoomManager
- **Responsibilities:**
  - Load/unload rooms by ID
  - Place GLB models per room definition
  - Create lights (OmniLight3D for candles/torches, SpotLight3D for windows)
  - Create interactable Area3D nodes with metadata
  - Fade transitions (tween CanvasLayer overlay)
  - Audio crossfade (switch AudioStreamPlayer per room)
- **Signals emitted:** room_loaded, room_transition_started, room_transition_finished
- **Signals received:** GameManager.state_changed

### PlayerController
- **File:** res://scripts/player_controller.gd
- **Extends:** CharacterBody3D
- **Attaches to:** Main:PlayerController
- **Responsibilities:**
  - First-person camera (Camera3D child)
  - Touch input: tap detection vs swipe detection
  - Tap on floor → NavigationAgent3D pathfinding or direct walk-to
  - Swipe → camera rotation (yaw 360°, pitch ±45°)
  - Raycast for interaction detection
  - Movement interpolation (smooth walk to target)
- **Signals emitted:** interacted(object_id, object_type, object_data), moved_to(position)
- **Children:** Camera3D, RayCast3D

### InteractionManager
- **File:** res://scripts/interaction_manager.gd
- **Extends:** Node
- **Attaches to:** Main:UILayer (child)
- **Responsibilities:**
  - Handle interaction callbacks from PlayerController
  - Determine interaction result (show document, toggle light, unlock, give item, transition)
  - Manage document overlay display
  - Manage room name display
  - Check puzzle prerequisites
  - Trigger endings
- **Signals received:** PlayerController.interacted
- **Signals emitted:** overlay_shown, overlay_hidden

### AudioManager
- **File:** res://scripts/audio_manager.gd
- **Extends:** Node
- **Attaches to:** Main (autoload or child)
- **Responsibilities:**
  - Per-room ambient loop playback
  - Crossfade between room loops
  - Event sound triggers (key found, door unlock, etc.)
- **Children:** AudioStreamPlayer (ambient), AudioStreamPlayer (sfx)

### PSXShader
- **File:** res://shaders/psx.gdshader
- **Type:** Spatial shader
- **Applied to:** All StandardMaterial3D overrides via RoomManager
- **Effects:** Vertex snapping, affine texture warping, color banding

### RoomData
- **File:** res://scripts/room_data.gd
- **Extends:** Resource (or static class)
- **Responsibilities:**
  - Define all 19 rooms as data (dimensions, position, connections, lights, interactables, audio, models)
  - Provide room lookup by ID
  - Define connection graph

### UIOverlay
- **File:** res://scripts/ui_overlay.gd
- **Extends:** Control
- **Attaches to:** Main:UILayer:UIOverlay
- **Responsibilities:**
  - Document overlay (aged paper texture, title, content)
  - Room name display (fade in/out)
  - Pause menu
  - Landing screen
  - Inventory display
  - Ending sequences
- **Children:** Various Control nodes (panels, labels, buttons)

## Signal Map

- PlayerController.interacted → InteractionManager._on_interacted
- RoomManager.room_loaded → AudioManager._on_room_loaded
- RoomManager.room_loaded → PlayerController._on_room_loaded
- RoomManager.room_transition_started → UIOverlay._on_transition_started
- RoomManager.room_transition_finished → UIOverlay._on_transition_finished
- GameManager.item_acquired → UIOverlay._on_item_acquired
- GameManager.flag_set → InteractionManager._on_flag_set
- GameManager.ending_triggered → UIOverlay._on_ending_triggered

## Build Order

1. scenes/build_main.gd → scenes/main.tscn (single scene — all gameplay is dynamic)

## Asset Hints

All assets are pre-made — 125 GLBs in assets/models/, 167 textures in assets/textures/, 36 audio loops in assets/audio/loops/. See ASSETS.md for complete manifest. No generation needed.
