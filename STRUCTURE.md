# Ashworth Manor

## Dimension: 3D

## Input Actions

| Action | Keys / Events |
|--------|--------------|
| interact | Left Click / Touch Tap |
| pause | Escape |

## Scenes

### Main
- **File:** res://scenes/main.tscn
- **Root type:** Node3D
- **Children:** WorldEnvironment, PSXLayer, RoomContainer, PlayerController, AudioManager, InteractionManager, UILayer

### Room Scenes (20 total)
Each room is a standalone .tscn instanced by RoomManager at runtime.

- **Root type:** Node3D with room_base.gd
- **Exported vars:** room_id, room_name, audio_loop, ambient_darkness, is_exterior
- **Children structure:**
  ```
  RoomName (Node3D) [room_base.gd]
  ├── Geometry (Node3D)
  │   ├── Floor (CSGBox3D — textured, collision layer 1)
  │   ├── Ceiling (CSGBox3D — textured)
  │   ├── WallNorth/South/East/West (CSGBox3D — textured, collision layer 2)
  ├── Models (Node3D)
  │   ├── [GLB instances — furniture, decor, props]
  ├── Lighting (Node3D)
  │   ├── [OmniLight3D, SpotLight3D nodes]
  ├── Interactables (Node3D)
  │   ├── [Area3D nodes, group "interactables", InteractableData resource]
  ├── Connections (Node3D)
  │   ├── [Area3D nodes, group "connections", RoomConnection resource]
  ```

### Room Scene Files
```
scenes/rooms/ground_floor/foyer.tscn
scenes/rooms/ground_floor/parlor.tscn
scenes/rooms/ground_floor/dining_room.tscn
scenes/rooms/ground_floor/kitchen.tscn
scenes/rooms/upper_floor/hallway.tscn
scenes/rooms/upper_floor/master_bedroom.tscn
scenes/rooms/upper_floor/library.tscn
scenes/rooms/upper_floor/guest_room.tscn
scenes/rooms/basement/storage.tscn
scenes/rooms/basement/boiler_room.tscn
scenes/rooms/deep_basement/wine_cellar.tscn
scenes/rooms/attic/stairwell.tscn
scenes/rooms/attic/storage.tscn
scenes/rooms/attic/hidden_chamber.tscn
scenes/rooms/grounds/front_gate.tscn
scenes/rooms/grounds/garden.tscn
scenes/rooms/grounds/chapel.tscn
scenes/rooms/grounds/greenhouse.tscn
scenes/rooms/grounds/carriage_house.tscn
scenes/rooms/grounds/family_crypt.tscn
```

## Scripts

### GameManager (Autoload — unchanged)
- **File:** res://scripts/game_manager.gd
- **Extends:** Node
- **Responsibilities:** Game state, inventory, flags, save/load, ending checks

### RoomBase (Room scene root script)
- **File:** res://scripts/room_base.gd
- **Extends:** Node3D
- **Exported vars:**
  - room_id: String
  - room_name: String
  - audio_loop: String
  - ambient_darkness: float
  - is_exterior: bool
  - spawn_position: Vector3
  - spawn_rotation_y: float
- **_ready():** Registers interactable/connection children, sets up flickering lights

### RoomManager (Refactored — scene instancing)
- **File:** res://scripts/room_manager.gd
- **Extends:** Node3D
- **Responsibilities:**
  - `transition_to(scene_path: String, conn_type: String)` — fade, free old, instance new
  - `load_room_scene(scene_path: String)` — instance PackedScene, add to RoomContainer
  - Room registry: maps room_id → scene_path
  - Reads room_base exports for audio_loop, spawn position
- **Signals:** room_loaded(room_id), room_transition_started, room_transition_finished

### InteractableData (Custom Resource)
- **File:** res://scripts/interactable_data.gd
- **Extends:** Resource
- **Properties:** object_id, object_type, title, content, locked, key_id, item_found, on_read_flags, extra_data

### RoomConnection (Custom Resource)
- **File:** res://scripts/room_connection.gd
- **Extends:** Resource
- **Properties:** target_scene_path, conn_type, locked, key_id

### PlayerController (Minor refactor)
- **File:** res://scripts/player_controller.gd
- **Extends:** CharacterBody3D
- **Changes:** Reads spawn_position from room_base instead of hardcoded Vector3

### InteractionManager (Minor refactor)
- **File:** res://scripts/interaction_manager.gd
- **Changes:** Reads InteractableData resource from Area3D instead of raw dict metadata

### AudioManager (Unchanged)
- **File:** res://scripts/audio_manager.gd

### UIOverlay (Unchanged)
- **File:** res://scripts/ui_overlay.gd

## Signal Map

- PlayerController.interacted → InteractionManager._on_interacted
- RoomManager.room_loaded → AudioManager._on_room_loaded
- RoomManager.room_loaded → PlayerController._on_room_loaded
- RoomManager.room_transition_started → UIOverlay._on_transition_started
- RoomManager.room_transition_finished → UIOverlay._on_transition_finished
- GameManager.item_acquired → UIOverlay._on_item_acquired
- GameManager.ending_triggered → UIOverlay._on_ending_triggered

## Collision Layers

| Layer | Name | Used By |
|-------|------|---------|
| 1 | walkable | Floor CSGBox3D, player mask |
| 2 | walls | Wall/ceiling CSGBox3D |
| 3 | interactables | Area3D interactable nodes |
| 4 | connections | Area3D door/transition nodes |

## Build Order

1. scripts/room_base.gd (stub)
2. scripts/interactable_data.gd (Resource)
3. scripts/room_connection.gd (Resource)
4. scripts/room_manager.gd (refactored)
5. scenes/build_main.gd → scenes/main.tscn
6. Room scenes: build in floor batches (leaf scenes, no cross-dependencies)
   - Batch 1: Ground floor (foyer, parlor, dining, kitchen)
   - Batch 2: Upper floor (hallway, master bedroom, library, guest room)
   - Batch 3: Basement (storage, boiler room, wine cellar)
   - Batch 4: Attic (stairwell, storage, hidden chamber)
   - Batch 5: Grounds (front gate, garden, chapel, greenhouse, carriage house, crypt)

## Art Direction Per Room

### Textures (from assets/shared/textures/)
| Texture | File | Usage |
|---------|------|-------|
| wall0 | wall0_texture.png | Foyer — Victorian red |
| wall1 | wall1_texture.png | Hallway — dark damask |
| wall2 | wall2_texture.png | Bedroom — Prussian blue |
| wall3 | wall3_texture.png | Library — dark paneling |
| wall4 | wall4_texture.png | Parlor — arsenic green |
| wall5 | wall5_texture.png | Dining — deep claret |
| wall6 | wall6_texture.png | Basement — stone |
| wall7 | wall7_texture.png | Kitchen/attic — aged plaster |
| wall8 | wall8_texture.png | Deep basement — rough stone |
| floor0 | floor0_texture.png | Foyer — marble checkered |
| floor1 | floor1_texture.png | Most rooms — wood parquet |
| floor2 | floor2_texture.png | Kitchen/attic — rough stone |
| floor3 | floor3_texture.png | Basement — dark flagstone |
| floor4 | floor4_texture.png | Boiler — metal grate |
| ceiling0 | ceiling0_texture.png | Grand rooms — ornate |
| ceiling1 | ceiling1_texture.png | Standard — plaster molding |
| ceiling2 | ceiling2_texture.png | Service — exposed beams |

### Horror Textures (from assets/horror/textures/)
| Category | Usage |
|----------|-------|
| wall/ | Hidden chamber — Elizabeth's drawings |
| stone/ | Chapel, crypt — rough limestone |
| brick/ | Boiler room accent |
| floor/ | Basement stone overlay |
| stains/ | Attic, basement — water damage |
| metal/ | Boiler room pipes |
| misc/ | Attic — scattered details |

### Room Color Palettes
| Room | Wall Color | Floor Color | Ceiling Color |
|------|-----------|-------------|---------------|
| Foyer | #732F26 (Morris Red) | #D1C7B8 (Marble) | #BFA882 (Gilt) |
| Parlor | #335938 (Arsenic Green) | #6B4824 (Walnut) | #ADA598 (Plaster) |
| Dining | #612630 (Deep Claret) | #4A3520 (Dark Oak) | #ADA598 |
| Kitchen | #8C8078 (Aged Plaster) | #4A4540 (Kitchen Stone) | #5C4428 (Beams) |
| Hallway | #38302C (Charcoal) | #6B4824 (Walnut) | #8C8078 |
| Master Bed | #384A6B (Prussian Blue) | #6B4824 (Walnut) | #9C9488 |
| Library | #4A3520 (Dark Walnut) | #4A3520 | #4A3520 (Coffered) |
| Guest | #5C5450 (Simple Paper) | #6B4824 | #9C9488 |
| Storage | #38302C (Stone Brick) | #2D2A28 (Dark Stone) | #4A3520 |
| Boiler | #40302A (Old Brick) | #38383C (Metal) | #2E2A28 |
| Wine Cellar | #2D2A28 (Rough Stone) | #262422 (Ancient) | #262422 |
| Attic Stairs | #6B6460 (Cracked Plaster) | #4A3520 (Rough) | #4A3520 |
| Attic Storage | #5C4A3C (Bare Wood) | #483A2A | #40352A |
| Hidden Chamber | #6B5E55 (Plaster+Drawings) | #40352A | #383028 |
