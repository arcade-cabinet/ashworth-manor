# Game Plan: Ashworth Manor

## Game Description

Mobile-first PSX-style Victorian haunted house exploration game. First-person, tap-to-walk, swipe-to-look. 19 rooms across 5 interior floors + 5 exterior grounds areas. The player discovers the truth about Elizabeth Ashworth, a child imprisoned in the attic by her family and bound to the house through an occult ritual. Complete puzzle chain (6 puzzles), inventory system, 3 endings (Freedom/Escape/Joined), 36 audio loops, 125 GLB models, PSX retro shader. All assets pre-made — no AI content generation.

## Risk Tasks

### 1. PSX Retro Shader
- **Why isolated:** Custom shader combining vertex snapping, affine texture warping, color depth reduction, and low-resolution rendering. Shaders fail silently — wrong syntax produces default materials. The PS1 look is the entire visual identity.
- **Verify:** Visible vertex jitter on model edges, texture warping on large surfaces, reduced color banding effect, render at lower internal resolution then upscale. No magenta/default materials.

### 2. Touch-to-Walk + Swipe-to-Look System
- **Why isolated:** Custom input handling must distinguish taps from swipes, handle raycast floor picking for pathfinding, smooth camera rotation with inertia, and work with Godot's 3D picking system. Touch/mouse hybrid is tricky — tap threshold vs swipe threshold.
- **Verify:** Single tap on floor → character walks to that point smoothly. Swipe → camera rotates horizontally (full 360°) and vertically (limited ±45°). Tap on interactable → raycast hits correctly. No jitter, no stuck states. Works with both touch and mouse.

## Main Build

Build the complete exploration game:

**Core Systems:**
- Room manager (load/unload 19 rooms by ID, fade transitions)
- First-person camera with PSX FOV
- Interaction system (raycast → object metadata → overlay)
- Inventory system (items, keys, flags)
- Game state manager (visited rooms, interacted objects, flags, inventory)
- Save/load to JSON (auto-save on room transition)
- Audio manager (per-room ambient loops, crossfade on transition)
- Document overlay (diegetic aged-paper style, tap to dismiss)
- Room name display (fade in/out on entry)
- Pause menu (resume, inventory, save, quit)

**All 19 Rooms (GLB models placed per ASSETS.md):**
- Ground Floor: Foyer, Parlor, Dining Room, Kitchen
- Upper Floor: Hallway, Master Bedroom, Library, Guest Room
- Basement: Storage, Boiler Room
- Deep Basement: Wine Cellar
- Attic: Stairwell, Storage, Hidden Chamber
- Grounds: Front Gate, Chapel, Greenhouse, Carriage House, Family Crypt

**All 6 Puzzles:**
- Attic Key (diary → globe → key → door)
- Hidden Key (doll interaction sequence → key → hidden chamber)
- Cellar Key (carriage house portrait → key → wine cellar box)
- Jewelry Key (crypt flagstone → key → jewelry box → locket)
- Gate Key (greenhouse pot → key → crypt gate)
- Counter-Ritual (6 components → 3 steps in Hidden Chamber)

**3 Endings:**
- Freedom (counter-ritual complete → dawn sequence)
- Escape (leave with knowledge → every window lit)
- Joined (can't leave → Elizabeth in mirrors → "Welcome home")

**Landing Screen:**
- Atmospheric title with particle dust
- New Game / Continue buttons
- Victorian serif typography

- **Verify:**
  - Tap on floor → character walks smoothly to destination
  - Swipe rotates camera correctly (H: 360°, V: ±45°)
  - Tap on interactable → correct overlay appears
  - Room transitions fade to black, load new room, fade in
  - Room name displays on entry
  - Inventory items persist across rooms
  - Keys unlock correct doors/boxes
  - All puzzle chains completable in sequence
  - All 3 endings triggerable with correct conditions
  - Audio loops play per-room, crossfade on transition
  - PSX shader active on all surfaces
  - All GLB models visible, correctly placed, no magenta
  - Save/load preserves full game state
  - Document overlay readable, tap to dismiss
  - No clipping, no missing geometry, no stuck states
  - Gameplay flow matches MASTER_SCRIPT.md
  - **Presentation video:** ~30s cinematic MP4 showcasing gameplay
    - Write test/presentation.gd (SceneTree script), ~900 frames at 30 FPS
    - **3D:** smooth camera work through multiple rooms, good PSX lighting
    - Output: screenshots/presentation/gameplay.mp4

## Status

- [ ] Risk 1: PSX Retro Shader
- [ ] Risk 2: Touch-to-Walk + Swipe-to-Look
- [ ] Main Build
- [ ] Presentation Video
