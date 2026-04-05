# Technical Guide

This document covers the technical implementation details, Godot engine usage, and performance considerations.

## Technology Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Engine | Godot | 4.6 |
| Language | GDScript | 4.x |
| Renderer | Forward+ | — |
| Shaders | GLSL (gdshader) | — |
| Assets | GLB (embedded textures) | glTF 2.0 |
| Audio | OGG Vorbis | — |

## Godot Implementation

### Project Configuration

```ini
# project.godot key settings
config/name="Ashworth Manor"
run/main_scene="res://scenes/main.tscn"
config/features=PackedStringArray("4.6", "Forward Plus")

[display]
window/size/viewport_width=1280
window/size/viewport_height=720
window/stretch/mode="canvas_items"
window/stretch/aspect="expand"

[autoload]
GameManager="*res://scripts/game_manager.gd"
```

### Scene Setup

The main scene (`scenes/main.tscn`) contains:
- **WorldEnvironment**: Sky, ambient light, fog, tonemap
- **PSXLayer** (CanvasLayer): Screen-space post-process shader
- **RoomContainer** (Node3D): Created by RoomManager, holds current room instance
- **PlayerController** (CharacterBody3D): First-person camera and movement
- **AudioManager**: Dual AudioStreamPlayer for crossfade
- **InteractionManager**: Signal-driven puzzle logic
- **UILayer** (CanvasLayer): Document overlays, room names, endings

### Camera System

```gdscript
# PlayerController uses CharacterBody3D with child Camera3D
# First-person perspective at ~1.7m height
# FOV slightly wide for mobile
# Input cleared — custom tap/swipe handling
```

**Why CharacterBody3D**:
- Built-in collision with floor and walls
- Gravity and slope handling
- Better than KinematicBody for first-person movement
- Easy to reposition via global_position on room transitions

---

## Lighting System

### Light Types Used

| Godot Type | Game Usage | Shadows |
|------------|------------|---------|
| DirectionalLight3D | Moonlight through windows | No |
| OmniLight3D | Candles, sconces, chandeliers | Selective |
| SpotLight3D | Focused beams, fireplace | No |

### Flickering Implementation

```gdscript
# In room_base.gd _process()
func _process(delta: float) -> void:
    _elapsed_time += delta
    for entry in _flickering_lights:
        var light: Light3D = entry["light"]
        var base_energy: float = entry["base_energy"]
        if is_instance_valid(light):
            var flicker: float = sin(_elapsed_time * 2.5) * 0.04 + sin(_elapsed_time * 4.3) * 0.02
            light.light_energy = base_energy * (0.85 + flicker)
```

Lights with `flickering` meta set to `true` are auto-discovered by room_base.gd on `_ready()`. Uses dual sine waves for organic candlelight feel.

### Ambient Configuration

```gdscript
# WorldEnvironment settings
environment.ambient_light_color = Color(0.08, 0.03, 0.03)
environment.fog_enabled = true
environment.fog_density = 0.015
rendering/environment/defaults/default_clear_color = Color(0.02, 0.01, 0.02)
```

---

## PSX Post-Processing Pipeline

The retro PSX look uses a two-shader approach:

### Per-Material Shader (psx.gdshader)
Applied to mesh materials for vertex snapping and affine texture mapping.

### Screen-Space Post-Process (psx_post.gdshader)
A `canvas_item` shader on a CanvasLayer that reads the entire screen and applies:

```glsl
shader_type canvas_item;

uniform float color_depth : hint_range(4.0, 64.0) = 15.0;
uniform float resolution_scale : hint_range(0.1, 1.0) = 0.5;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
```

**Effects**:
- Resolution downscaling (0.5x) with nearest-neighbor filtering
- Color depth reduction to 15 levels per channel
- 4x4 Bayer dithering matrix
- Combined to recreate PS1-era rendering artifacts

---

## Room Geometry

### CSGBox3D Construction

Rooms use CSGBox3D nodes for walls, floors, and ceilings:

```
Geometry (Node3D)
├── Floor (CSGBox3D)     — collision layer 1 (walkable)
├── Ceiling (CSGBox3D)   — collision layer 2
├── WallNorth (CSGBox3D) — collision layer 2
├── WallSouth (CSGBox3D) — collision layer 2
├── WallEast (CSGBox3D)  — collision layer 2
└── WallWest (CSGBox3D)  — collision layer 2
```

**Why CSGBox3D**:
- Built-in collision shape generation
- Easy to texture with StandardMaterial3D
- Simple to create in scene builders
- Collision layers separate walkable surfaces from walls

### Material System

Rooms use StandardMaterial3D (not ShaderMaterial for geometry) with:
- Albedo texture from assets/shared/textures/ or room-specific PNGs
- Albedo color tint per room palette (see STRUCTURE.md color tables)
- No PBR — roughness/metallic left at defaults for performance

---

## Input Handling

### Tap-to-Walk

```gdscript
# PlayerController detects tap vs swipe
# Tap: raycast from camera, check collision layer
#   Layer 1 (walkable) → move to point
#   Layer 3 (interactable) → emit interacted signal
#   Layer 4 (connection) → emit door_tapped signal
# Swipe: rotate camera (horizontal full 360, vertical limited)
```

### Input Actions (project.godot)

| Action | Event |
|--------|-------|
| interact | Left mouse button / touch tap |
| pause | Escape key |

---

## Room Scene Lifecycle

### Loading

```gdscript
# RoomManager.load_room()
var scene: PackedScene = load(scene_path)
var room_instance = scene.instantiate()
_room_container.add_child(room_instance)
```

### Transition

```gdscript
# RoomManager.transition_to()
# 1. Tween fade rect alpha 0→1 (variable timing by conn_type)
# 2. _perform_room_switch: free old, instance new, reposition player
# 3. Hold interval
# 4. Tween fade rect alpha 1→0
# 5. Emit room_transition_finished
```

Connection type timing:
| Type | Fade In | Hold | Fade Out |
|------|---------|------|----------|
| door | 0.6s | 0.15s | 0.6s |
| stairs | 0.8s | 0.3s | 0.8s |
| ladder | 1.0s | 0.4s | 1.0s |
| path | 0.5s | 0.1s | 0.5s |

### Cleanup

```gdscript
# _clear_current_room()
for child in _room_container.get_children():
    _room_container.remove_child(child)
    child.queue_free()
```

All room children (geometry, models, lights, areas) are freed with the room scene instance.

---

## Save System

GameManager handles save/load using Godot's `user://` path:

```gdscript
# Save: serialize state to JSON, write to user://save.json
# Load: read JSON, restore inventory, flags, current_room, visited_rooms
# Auto-save on room transitions
```

---

## Performance Considerations

### Current Optimizations

1. **Single Room Rendering**: Only active room scene exists in tree
2. **Screen-Space PSX**: One post-process pass, not per-material
3. **Embedded Textures**: GLBs carry textures, no separate loading
4. **CSGBox3D Geometry**: Simple primitives with built-in collision
5. **Sine-Wave Flickering**: Cheap math for light animation
6. **Forward+ Renderer**: Efficient for scenes with few lights

### Performance Targets

| Metric | Target |
|--------|--------|
| Frame Rate | 60 fps |
| Active Lights | <10 per room |
| GLB Instances | <30 per room |
| Memory | <200MB |

---

## Build & Run

### Editor
Open `project.godot` in Godot 4.6 editor, press F5 (Play).

### Headless Build
```bash
godot --headless --script scenes/build_main.gd
```

### Export
Configure export presets in Godot editor for target platforms (Web, Android, iOS).

---

## Debugging

### Godot Output Console
All `push_warning()` and `push_error()` calls from scripts appear in the Output panel.

### Room Registry Validation
```gdscript
# In room_manager.gd, check all registry entries resolve:
for rid in _room_registry:
    if not ResourceLoader.exists(_room_registry[rid]):
        push_error("Missing scene: %s → %s" % [rid, _room_registry[rid]])
```

### Shader Inspection
Disable PSXLayer visibility in the editor to see the raw 3D render without post-processing.
