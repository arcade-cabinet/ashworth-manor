# Interactive Doors & Windows Plan

How the Retro Textures 2 pack becomes interactive, animated doors and windows in Ashworth Manor using Godot 4's procedural mesh and animation APIs.

---

## The Problem

Currently, doors are static GLB models (`door.glb`, `door1.glb`) placed in doorway openings. They don't open, close, or animate. Windows are flat panes (`window.glb`, `window_clean.glb`) with no interaction. Trapdoors and basement hatches don't exist.

## The Solution

Build a **DoorFrame** scene that:
1. Procedurally generates a door frame as a box-shaped `MeshInstance3D` using `BoxMesh`
2. Creates a door panel as a separate `MeshInstance3D` with a retro texture applied
3. Animates the door panel with a `Tween` (rotation around hinge point)
4. Responds to player interaction — tap to open/close
5. Can be locked (requires key) via `RoomConnection` resource

Same pattern for windows (open/close shutters) and trapdoors (hinge on one edge, flip open).

---

## Godot API: How to Build a Textured Door Frame

### Step 1: The Frame (BoxMesh for each beam)

A door frame is 3 boxes — two vertical posts and one horizontal header:

```gdscript
# scripts/door_frame.gd
class_name DoorFrame
extends Node3D

@export var frame_width: float = 1.0      # Opening width
@export var frame_height: float = 2.2     # Opening height  
@export var frame_depth: float = 0.15     # Frame thickness
@export var post_width: float = 0.1       # Post/header beam width
@export var door_texture: Texture2D = null # From retro textures pack
@export var frame_texture: Texture2D = null

func _ready() -> void:
    _build_frame()
    _build_door_panel()

func _build_frame() -> void:
    # Left post
    var left := _make_beam(
        Vector3(post_width, frame_height, frame_depth),
        Vector3(-frame_width / 2.0 - post_width / 2.0, frame_height / 2.0, 0)
    )
    add_child(left)
    
    # Right post
    var right := _make_beam(
        Vector3(post_width, frame_height, frame_depth),
        Vector3(frame_width / 2.0 + post_width / 2.0, frame_height / 2.0, 0)
    )
    add_child(right)
    
    # Header
    var header := _make_beam(
        Vector3(frame_width + post_width * 2, post_width, frame_depth),
        Vector3(0, frame_height + post_width / 2.0, 0)
    )
    add_child(header)

func _make_beam(size: Vector3, pos: Vector3) -> MeshInstance3D:
    var mesh_inst := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = size
    mesh_inst.mesh = box
    mesh_inst.position = pos
    # Apply frame texture
    if frame_texture:
        var mat := StandardMaterial3D.new()
        mat.albedo_texture = frame_texture
        mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
        mesh_inst.set_surface_override_material(0, mat)
    return mesh_inst
```

### Step 2: The Door Panel (Textured Quad on a Hinge)

```gdscript
func _build_door_panel() -> void:
    # Hinge pivot — positioned at left edge of door opening
    var hinge := Node3D.new()
    hinge.name = "DoorHinge"
    hinge.position = Vector3(-frame_width / 2.0, 0, 0)
    add_child(hinge)
    
    # Door panel — offset from hinge so rotation swings it open
    var panel := MeshInstance3D.new()
    panel.name = "DoorPanel"
    var quad := QuadMesh.new()
    quad.size = Vector2(frame_width, frame_height)
    panel.mesh = quad
    # Offset so the quad's left edge is at the hinge
    panel.position = Vector3(frame_width / 2.0, frame_height / 2.0, 0)
    
    if door_texture:
        var mat := StandardMaterial3D.new()
        mat.albedo_texture = door_texture
        mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
        mat.cull_mode = BaseMaterial3D.CULL_DISABLED  # Visible from both sides
        panel.set_surface_override_material(0, mat)
    
    hinge.add_child(panel)
```

### Step 3: Open/Close Animation

```gdscript
var _is_open: bool = false
var _tween: Tween = null

func toggle_door() -> void:
    if _tween and _tween.is_valid():
        return  # Already animating
    
    var hinge: Node3D = get_node("DoorHinge")
    var target_y: float = -90.0 if not _is_open else 0.0
    
    _tween = create_tween()
    _tween.tween_property(hinge, "rotation_degrees:y", target_y, 0.8)\
        .set_ease(Tween.EASE_IN_OUT)\
        .set_trans(Tween.TRANS_QUAD)
    
    _is_open = not _is_open
    
    # Play door sound
    var sfx_name: String = "horror_door_01" if _is_open else "pl_impact_heavy_01"
    AudioManager.play_sfx(sfx_name)
```

### Step 4: Interaction (Area3D)

```gdscript
# Add Area3D for player raycast detection
func _build_interaction_zone() -> void:
    var area := Area3D.new()
    area.name = "DoorInteraction"
    area.collision_layer = 8  # Layer 4 — Connection
    area.collision_mask = 0
    area.set_meta("target_room", target_room)
    area.set_meta("type", "door")
    
    var shape := CollisionShape3D.new()
    var box := BoxShape3D.new()
    box.size = Vector3(frame_width, frame_height, 0.5)
    shape.shape = box
    shape.position = Vector3(0, frame_height / 2.0, 0)
    area.add_child(shape)
    add_child(area)
```

---

## Door Types in the Game

### Standard Interior Door
- Frame: Dark wood (`T_Door_Wood_005.png` or similar)
- Panel: Victorian wood door texture
- Animation: Swing open 90 degrees on Y axis
- Sound: `horror_door_01.ogg` (creak) + `pl_impact_wood_01.ogg` (thud)
- Used in: Foyer→Parlor, Foyer→Dining, Foyer→Kitchen, all upper floor doors

### Heavy Attic Door (Iron-Banded)
- Frame: Dark iron-bound wood
- Panel: `T_Door_Rusty_03.png` (rusted metal reinforced)
- Animation: Slow swing (1.5s instead of 0.8s), with resistance feel
- Sound: `horror_metal_01.ogg` (groan) + `pl_impact_heavy_02.ogg` (slam)
- Lock: Requires `attic_key`
- Used in: Upper Hallway→Attic Stairwell

### Trapdoor (Basement Hatch)
- Frame: Floor-level square frame
- Panel: `T_Door_Wood_012.png`, horizontal orientation
- Animation: Flip open on one edge (rotation on X axis, not Y)
- Sound: `pl_impact_wood_03.ogg` (heavy wood) + `horror_hit_02.ogg`
- Used in: Kitchen→Storage Basement

### Hidden Door (Behind Furniture)
- Frame: Invisible (flush with wall)
- Panel: Same wall texture as surrounding area (camouflaged)
- Animation: Push inward (translate on Z axis, then swing)
- Sound: `horror_door_03.ogg` (secret passage creak)
- Lock: Requires `hidden_key`, hand-shaped lock
- Used in: Attic Storage→Hidden Chamber

### Iron Gate (Exterior)
- Frame: Stone pillars (existing `pillar0.glb`)
- Panel: `T_Door_Metal_02.png` (iron bars)
- Animation: Swing open outward (positive Y rotation)
- Sound: `horror_metal_03.ogg` (iron screech) + `pl_impact_metal_01.ogg`
- Lock: Gate at crypt requires `gate_key`
- Used in: Front Gate, Family Crypt

### Double Doors (Formal Rooms)
- Frame: Wide frame, ornate header
- Panel: Two `T_DoubleDoor_Wood_Painted_02.png` panels
- Animation: Both panels swing outward simultaneously
- Sound: `horror_door_02.ogg` (grand creak)
- Used in: Foyer→Dining Room (upgrade from single door)

---

## Window Types

### Standard Window
- Frame: 4 beams (top, bottom, left, right) + center cross
- Pane: Semi-transparent material with `window_clean.glb` texture or `T_Window_Wood_001.png`
- No animation (sealed windows — the house is locked)
- Visual: `window_ray.glb` provides volumetric light beam through glass

### Boarded Window
- Frame: Same as standard
- Boards: 2-3 `QuadMesh` planks at angles over the window
- Texture: `T_Window_Wood_Painted_005.png` (painted over)
- Used in: Basement, Carriage House

### Broken Window (Chapel)
- Frame: Remaining fragments
- Pane: Partial — shattered edges using irregular quads
- No glass in center — open to air
- Sound: Wind whistles through (`pl_ambient_wind_01.ogg` positional)

### Shuttered Window
- Frame: Standard
- Shutters: Two `QuadMesh` panels with `T_Shutter_Wood_003.png`
- Can be animated (swing open/close) but not interactive in current scope

---

## Texture Assignments

### Doors (from Retro Textures 2/Doors/)

| Room | Texture | Character |
|------|---------|-----------|
| Foyer doors | `T_Door_Wood_Painted_008.png` | Formal, painted Victorian |
| Parlor door | `T_Door_Wood_Painted_012.png` | Green-tinted to match walls |
| Dining room | `T_DoubleDoor_Wood_Painted_02.png` | Double doors, formal |
| Kitchen door | `T_Door_Wood_005.png` | Plain wood, servant's door |
| Upper hallway doors | `T_Door_Wood_Painted_015.png` | Dark, private |
| Attic door | `T_Door_Rusty_03.png` | Iron-banded, forbidding |
| Hidden chamber | `T_Door_Wood_000.png` | Plain, camouflaged |
| Basement doors | `T_Door_Wood_010.png` | Rough, utilitarian |
| Front gate | `T_Door_Metal_02.png` | Iron bars |
| Crypt gate | `T_Door_Metal_06.png` | Ornate iron |
| Carriage house | `T_GarageDoor_Wood_00.png` | Barn-style |

### Windows

| Location | Texture | Notes |
|----------|---------|-------|
| Ground floor | `T_Window_Wood_Painted_004_a.png` | Formal, painted frames |
| Upper floor | `T_Window_Wood_Painted_011_a.png` | Private rooms |
| Basement | `T_Window_Wood_003_a.png` (boarded) | Sealed |
| Attic | `T_Window_Wood_000_a.png` | Simple, dirty |
| Chapel | `T_Window_Metal_001.png` | Gothic metal frame (broken) |

---

## Implementation Steps

1. Create `scripts/door_frame.gd` — procedural frame + panel + hinge + animation
2. Create `scripts/window_frame.gd` — procedural frame + pane + optional boards
3. Create `scripts/trapdoor.gd` — floor-level hinge door
4. Replace static `door.glb` instances in all 20 room scenes with `DoorFrame` nodes
5. Replace static `window.glb` instances with `WindowFrame` nodes where appropriate
6. Wire door animations to `interaction_manager.gd` — open on approach, close behind
7. Add door/window sounds from impact and horror SFX packs
8. Test: every door opens, every connection works, no collision issues
