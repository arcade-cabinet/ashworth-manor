# Ashworth Manor — Godot 4.6 PSX Horror Exploration Game

## READ THIS FIRST

**All design decisions live in `docs/`.** Before writing ANY code, read the relevant doc:
- **Master index:** [docs/INDEX.md](docs/INDEX.md) — links to every design doc, addon plan, and room spec
- **Room specs:** `docs/floors/{floor}/{room}.md` — complete spec for each room (interactables, lighting, connections, events)
- **Addon plans:** `docs/addons/{addon}-plan.md` — how each addon integrates, what it does, implementation steps
- **Narrative:** `docs/NARRATIVE.md` — story, characters, document catalog
- **Vision:** `docs/VISION.md` — design philosophy (Myst-inspired, no horror tricks)
- **Art direction:** `docs/ART_DIRECTION.md` — colors, lighting, materials
- **Puzzles:** `docs/puzzles/README.md` — all 6 puzzles with flowcharts
- **Items:** `docs/items/README.md` — complete item catalog

**DO NOT write a room scene without its room doc existing first.** Docs → Tests → Code.

## Critical Rules

1. **NO per-material shaders on PSX assets.** The GLBs and 596 texture PNGs are already PSX-quality. Only screen-space post-process (godot-psx `psx_dither.gdshader`) is used. See `docs/addons/shader-plan.md`.
2. **Every room must feel alive.** No empty Interactables nodes. Every room has: interactable objects with narrative content, flickering lights, audio, connections, environmental storytelling. See room doc template in `docs/INDEX.md`.
3. **Dialogue Manager for ALL text content.** Documents, observations, conditional text live in `.dialogue` files, NOT hardcoded strings. See `docs/addons/dialogue-plan.md`.

## Engine & Architecture

- **Engine**: Godot 4.6.2 (Forward+)
- **Language**: GDScript
- **Architecture**: Scene-based. Each room is a standalone `.tscn` file with `.tres` resources for data.

## Project Structure

```
project.godot
scenes/
  main.tscn                      # Root scene (WorldEnvironment, player, managers)
  rooms/{floor}/{room}.tscn      # 20 room scenes built from modular mansion pieces
scripts/
  game_manager.gd                # Autoload: state, inventory, flags, save/load
  room_manager.gd                # Scene instancing, transitions, fade
  room_base.gd                   # Room root script (exports: room_id, audio_loop, etc)
  player_controller.gd           # First-person, tap-to-walk, swipe-to-look
  interaction_manager.gd         # Interaction dispatch, puzzle logic, endings
  audio_manager.gd               # Per-room ambient + tension layers, crossfade
  ui_overlay.gd                  # Thin coordinator → delegates to ui/ submodules
  ui/ui_landing.gd               # Landing screen (title, new game, continue)
  ui/ui_document.gd              # Document overlay panel
  ui/ui_pause.gd                 # Pause menu with inventory + quests
  ui/ui_ending.gd                # Ending sequence overlay
  ui/ui_room_name.gd             # Room name / notification toast
  game_state_machine.gd          # LimboAI HSM (4 game phases)
  elizabeth_presence.gd          # Elizabeth sub-HSM (4 presence states)
  camera_controller.gd           # Phantom Camera + shake integration
  flashback_manager.gd           # Horror model flashback sequences
  room_events.gd                 # Entry events + ambient timed events
  puzzle_handler.gd              # Box, locked_door, doll, ritual logic
  shake_profiles.gd              # ShakyCamera3D event presets
  quest_handler.gd               # Quest start/complete from flags
  interactable_data.gd           # Resource class for interactable metadata
  room_connection.gd             # Resource class for room transitions
resources/
  interactables/{room_id}/*.tres  # InteractableData resources per room
  connections/{room_id}/*.tres    # RoomConnection resources per room
assets/
  shared/{structure,furniture,decor,items,textures}/ # Mansion pack GLBs
  {floor}/{room}/                 # Room-specific props
  audio/loops/                    # 36 OGG ambient loops (mapped to rooms)
  audio/tension/                  # 10 WAV tension layers (Dark Ambient pack, per floor)
  audio/sfx/horror/               # 50 OGG horror SFX (whispers, doors, drones, screams)
  audio/sfx/stinger/              # 20 WAV stinger music (phase transitions, endings)
  audio/sfx/inventory/            # 36 OGG inventory SFX (pickup, chest, key, error)
  audio/sfx/impact/               # 21 OGG impact SFX (click, heavy, stone, metal, wood)
  audio/sfx/ambient/              # 40 OGG ambient SFX (wind, fire, dungeon, rain)
  audio/sfx/music_box/            # 3 OGG music box melodies (Elizabeth's theme)
  audio/sfx/echoes/               # 11 MP3 horror echoes (breath, ghost, bells, thunder)
  audio/footsteps/{surface}/      # 36 WAV footsteps (9 surfaces x 4 variants)
  audio/footsteps_extra/          # 17 OGG supplemental footsteps
  fonts/                          # 19 TTF (Cinzel 7 weights + Cormorant 12 weights)
  horror/{models,textures}/       # Horror-specific assets
  shared/textures/retro/          # 240 PNG door/window/shutter textures (Retro Textures 2)
shaders/
  psx_dither.gdshader            # Screen-space PSX dither + color reduction (from godot-psx)
  psx_fade.gdshader              # Dither-based room transition fade (from godot-psx)
  # NO per-material shaders — PSX assets are already low-poly with baked textures
dialogue/
  {floor}/{room}.dialogue         # 20 dialogue files with conditional text per room
test/
  e2e/run_e2e.gd                 # Headless E2E test (57 assertions)
```

## How Rooms Are Built

Rooms are built from the **Retro PSX Mansion Pack** modular pieces. These are GLB models that tile together:

### Wall System (2m wide × 2.4m tall each)
- `wall_X.glb` — solid wall panel (X = texture variant 0-8)
- `doorway_X.glb` — wall with door opening
- `window_wallX.glb` — wall with window opening
- Variant mapping: 0=red Victorian, 1=dark damask, 2=blue, 3=paneling, 4=green, 5=burgundy, 6=stone, 7=plaster, 8=rough stone

### Floor Tiles (2m × 2m each)
- `floor0.glb` = marble checkered, `floor1.glb` = wood parquet, `floor2.glb` = rough stone, `floor3.glb` = dark flagstone, `floor4.glb` = metal grate

### Ceiling Tiles (2m × 2m, origin at Y=-2.4)
- `cieling0.glb` = ornate, `cieling1.glb` = molding, `cieling2.glb` = beams

### Accessories
- `door.glb` / `door1.glb` — door models for doorway openings
- `window.glb` / `window_clean.glb` — window pane inserts
- `window_ray.glb` — volumetric light beam through window

## Writing Room Scenes (.tscn)

Write `.tscn` files DIRECTLY as text. Do NOT use scene builders or MCP.

### .tscn Format

```
[gd_scene format=3]

[ext_resource type="Script" path="res://scripts/room_base.gd" id="1"]
[ext_resource type="PackedScene" path="res://assets/shared/structure/wall_0.glb" id="2"]
[ext_resource type="PackedScene" path="res://assets/shared/structure/floor0.glb" id="3"]
[ext_resource type="Resource" path="res://resources/interactables/foyer/foyer_painting.tres" id="10"]

[sub_resource type="BoxShape3D" id="BoxShape3D_1"]
size = Vector3(8, 0.2, 8)

[node name="RoomName" type="Node3D"]
script = ExtResource("1")
room_id = "room_id"
room_name = "Display Name"
audio_loop = "Loop Name"
ambient_darkness = 0.5
spawn_position = Vector3(0, 0, -3)
spawn_rotation_y = 180.0

[node name="Geometry" type="Node3D" parent="."]

[node name="Wall_N_0" type="Node3D" parent="Geometry" instance=ExtResource("2")]
transform = Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, -1, -3, 0, 4)

[node name="Floor_0_0" type="Node3D" parent="Geometry" instance=ExtResource("3")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -3, 0, -3)

[node name="FloorCollision" type="StaticBody3D" parent="Geometry"]
collision_layer = 1
[node name="Shape" type="CollisionShape3D" parent="Geometry/FloorCollision"]
shape = SubResource("BoxShape3D_1")
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.1, 0)

[node name="Models" type="Node3D" parent="."]
[node name="Lighting" type="Node3D" parent="."]
[node name="Interactables" type="Node3D" parent="."]
[node name="Connections" type="Node3D" parent="."]
```

### Common Transforms

```
Position only:          Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, X, Y, Z)
Y-rotation 90° (+X):   Transform3D(0, 0, 1, 0, 1, 0, -1, 0, 0, X, Y, Z)
Y-rotation -90° (-X):  Transform3D(0, 0, -1, 0, 1, 0, 1, 0, 0, X, Y, Z)
Y-rotation 180° (-Z):  Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, -1, X, Y, Z)
Scale S:                Transform3D(S, 0, 0, 0, S, 0, 0, 0, S, X, Y, Z)
```

### Interactable Area3D Pattern

```
[node name="FoyerPainting" type="Area3D" parent="Interactables"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 3, 5)
collision_layer = 4
collision_mask = 0
metadata/id = "foyer_painting"
metadata/type = "painting"
metadata/data = { "title": "Lord Ashworth", "content": "The patriarch stares down..." }

[node name="Shape" type="CollisionShape3D" parent="Interactables/FoyerPainting"]
shape = SubResource("BoxShape3D_interactable")
```

### Connection Area3D Pattern

```
[node name="ToParlor" type="Area3D" parent="Connections"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.5, 5)
collision_layer = 8
collision_mask = 0
metadata/target_room = "parlor"

[node name="Shape" type="CollisionShape3D" parent="Connections/ToParlor"]
shape = SubResource("BoxShape3D_connection")
```

## Writing Resources (.tres)

```
[gd_resource type="Resource" script_class="InteractableData" format=3]

[ext_resource type="Script" path="res://scripts/interactable_data.gd" id="1"]

[resource]
script = ExtResource("1")
object_id = "foyer_painting"
object_type = "painting"
title = "Lord Ashworth"
content = "The patriarch stares down with hollow eyes."
on_read_flags = PackedStringArray()
```

## Collision Layers

| Layer | Bitmask | Usage |
|-------|---------|-------|
| 1     | 1       | Walkable floor |
| 2     | 2       | Walls/ceiling |
| 3     | 4       | Interactable Area3D |
| 4     | 8       | Connection Area3D |

## Code Standards

- Max 200 LOC per script
- No monolithic data files
- `.tres` resources for data, not Dictionary metadata
- Each room is a self-contained `.tscn`
- No `load()` of scripts for static data — use Resources or autoloads

## Testing

- E2E: `godot --headless --script test/e2e/run_e2e.gd` (57 assertions, exit 0=pass)
- Maestro: Build APK, run flows on Android emulator
- Visual QA: `/visual-qa` skill

## Addons (via gd-plug)

All addons managed in `plug.gd`. Each has a plan doc at `docs/addons/{name}-plan.md`.

| Addon | Purpose | Plan |
|-------|---------|------|
| godot-psx | Screen-space dither + fade ONLY | [shader-plan.md](docs/addons/shader-plan.md) |
| godot_dialogue_manager | Document/observation text system | [dialogue-plan.md](docs/addons/dialogue-plan.md) |
| gloot | Resource-based inventory | [inventory-plan.md](docs/addons/inventory-plan.md) |
| AdaptiSound | Layered adaptive audio | [audio-plan.md](docs/addons/audio-plan.md) |
| shaky-camera-3d | Camera shake (horror moments only) | [camera-fx-plan.md](docs/addons/camera-fx-plan.md) |
| quest-system | Puzzle progress tracking | [quest-plan.md](docs/addons/quest-plan.md) |
| SaveMadeEasy | Encrypted save/load | [save-plan.md](docs/addons/save-plan.md) |
| gdUnit4 | Testing framework | [testing-plan.md](docs/addons/testing-plan.md) |
| godot-material-footsteps | Surface footstep sounds | [footsteps-plan.md](docs/addons/footsteps-plan.md) |
| phantom-camera | Object inspection + cinematics | [phantom-camera-plan.md](docs/addons/phantom-camera-plan.md) |
| limboai | HSM for game phases + Elizabeth | [state-machine-plan.md](docs/addons/state-machine-plan.md) |

## Room-by-Room Asset Mapping

See ASSETS.md for complete manifest. See REDESIGN_PLAN.md for modular construction method.
