# Ashworth Manor -- Gap Analysis

Thorough audit of what the design docs promise vs. what the code and scenes actually implement.

Date: 2026-04-05

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 3 |
| HIGH     | 7 |
| MEDIUM   | 6 |
| LOW      | 4 |

The game has 20 room scenes, all scripts, PSX shader, audio, save/load, and UI. The fundamental
blocker is that **every room scene has empty Interactables and Connections containers** -- zero
Area3D children across all 20 rooms. Without these nodes the player cannot interact with anything
or transition between rooms. The game loads the front gate but is a dead end.

---

## CRITICAL Gaps

### C1. No Interactable Area3D Nodes in Any Room Scene

**Files affected:** All 20 `.tscn` files in `scenes/rooms/`

Every room has `Interactables` and `Connections` Node3D containers, but they are **completely empty**.
No Area3D children exist anywhere in any room scene (confirmed by searching all `.tscn` files for
`Area3D` -- zero matches).

The `player_controller.gd` raycasts against collision layers 3 (interactables) and 4 (connections).
With no Area3D nodes on those layers, tapping any object or door does nothing.

**Impact:** The game is unplayable. No puzzles work, no doors work, no room transitions work.

**Fix:** For each room, create Area3D children under `Interactables` and `Connections` with:
- CollisionShape3D (BoxShape3D) sized to the interactable object
- Group membership: `"interactables"` or `"connections"`
- Collision layer: 3 for interactables, 4 for connections
- Metadata keys for interactables: `id`, `type`, `data` (Dictionary matching room_data.gd format)
- Metadata keys for connections: `target_room` (String), plus a `connection` meta holding a RoomConnection resource

The data for all interactables and connections exists in `scripts/room_data.gd` -- it just was
never materialized into actual scene nodes.

### C2. No Connection Area3D Nodes -- Cannot Move Between Rooms

**Files affected:** All 20 `.tscn` files

Same root cause as C1. The `Connections` container in every room is empty. The player spawns in
`front_gate` and cannot transition to any other room.

`interaction_manager.gd` handles `door_tapped` signals from `player_controller.gd`, which only
fire when a raycast hits an Area3D on collision layer 4. With no such nodes, `door_tapped` never
fires.

**Impact:** Player is trapped in the starting room forever.

**Fix:** Create Area3D nodes in `Connections` container for each room's exits. Each needs:
- Collision layer 4, collision mask 0
- CollisionShape3D positioned at the doorway/path location
- Meta `target_room` set to the destination room_id string
- Meta `connection` set to a RoomConnection resource (for lock/key data)
- Group `"connections"`

### C3. "Joined" Ending is Unreachable -- `elizabeth_aware` Flag Never Set

**Files affected:** `scripts/game_manager.gd` (line 126), `scripts/room_data.gd`

`game_manager.gd` checks `has_flag("elizabeth_aware")` for the "joined" ending.
This flag appears nowhere in any `on_read_flags` array in `room_data.gd`.
No interactable sets it. No script sets it.

The design docs (`docs/script/MASTER_SCRIPT.md`, `docs/floors/attic/README.md`) say it should
be set when the player enters the attic or reads certain documents, but this was never implemented.

**Impact:** One of the 3 endings is impossible to reach.

**Fix:** Add `"elizabeth_aware"` to the `on_read_flags` of an appropriate interactable,
such as Elizabeth's letter in attic storage (id `elizabeth_letter`), or set it automatically
when the player first enters `attic_stairs`.

---

## HIGH Gaps

### H1. Five Room Scenes Use `metadata/` Instead of Exported Vars

**Files affected:**
- `scenes/rooms/grounds/chapel.tscn`
- `scenes/rooms/grounds/garden.tscn`
- `scenes/rooms/grounds/family_crypt.tscn`
- `scenes/rooms/grounds/carriage_house.tscn`
- `scenes/rooms/grounds/greenhouse.tscn`

These 5 rooms store `room_id`, `room_name`, `audio_loop`, `ambient_darkness`, `is_exterior`,
`spawn_position`, and `spawn_rotation_y` under `metadata/` prefixes instead of as exported
variable values.

`room_base.gd` declares these as `@export var` properties. Setting them as metadata means the
exported var stays at default (`""`, `0.0`, `Vector3.ZERO`, etc.).

Consequences:
- `room_manager.gd` line 71: `room_instance.room_id` returns `""` for these 5 rooms
- `room_manager.gd` line 150: `_current_room.spawn_position` returns `Vector3(0,0,0)` -- player
  placed at origin instead of intended spawn point
- `room_manager.gd` line 151: `spawn_rotation_y` defaults to 0 -- player faces wrong direction
- `_current_room_id` falls back to the raw room_id parameter in `load_room()` so room tracking
  partially works, but the room's own identity is wrong

**Impact:** Player spawns at wrong position/rotation in 5 rooms. Room names display from
room_data.gd fallback so the user may not notice, but the architecture is broken.

**Fix:** In each of the 5 `.tscn` files, change `metadata/room_id = "..."` to `room_id = "..."`,
and similarly for all other metadata-prefixed properties.

### H2. Duplicate Camera3D in PlayerController

**Files affected:** `scenes/main.tscn` (lines 60-63), `scripts/player_controller.gd` (lines 41-46)

`main.tscn` already has a `Camera3D` child of `PlayerController` at position `(0, 1.7, 0)`.
`player_controller.gd` `_ready()` creates ANOTHER `Camera3D` child named `"PlayerCamera"`.

Result: Two cameras exist. Only one can be `current`. The script-created camera sets `current = true`
and becomes the active camera. The scene-defined camera is orphaned but still in the tree.

**Impact:** Wasted node, potential confusion. Not game-breaking but technically wrong.

**Fix:** Either remove the Camera3D from `main.tscn` or change `player_controller.gd` to find
the existing camera child instead of creating a new one.

### H3. `ui_overlay.gd` and `audio_manager.gd` Depend on Deprecated `room_data.gd`

**Files affected:**
- `scripts/ui_overlay.gd` (lines 541-544)
- `scripts/audio_manager.gd` (lines 57-62)

Both scripts load `"res://scripts/room_data.gd"` at runtime to get room names and audio loop
names. The file header says `DEPRECATED -- rooms are now individual .tscn scenes`.

This creates a hidden coupling: if `room_data.gd` is ever deleted (as PLAN.md step 7 says to do),
room name display and audio both break silently.

**Impact:** Works today but fragile. The room scene already has the data (room_name, audio_loop)
as exported vars (or should, per H1). Scripts should read from the room instance.

**Fix:** Have `room_manager.gd` emit the full room metadata with `room_loaded`, or have
`ui_overlay.gd` and `audio_manager.gd` get the current room instance and read its exports.

### H4. Attic Door Lock Not Enforceable via Connection Nodes

**Files affected:** `scripts/room_data.gd` (line 510), `scripts/interaction_manager.gd`

The attic door in upper_hallway is defined as both an interactable (`locked_door` type, line 502)
and a connection (locked, `key_id: "attic_key"`, line 510). The design intent is that the door
blocks passage until the player has the attic_key.

Since connections are Area3D nodes with RoomConnection resources, the lock check happens in
`interaction_manager.gd` `_on_door_tapped()` (lines 228-233), which reads connection data
from `room_manager.get_current_room_data()`.

But `get_current_room_data()` (line 121-140) reads connection data from Area3D meta `"connection"`
resources. With no connection Area3D nodes, the lock can never be checked. The same applies to
the crypt gate (locked with `gate_key`) and the hidden chamber door (locked with `hidden_key`).

**Impact:** All locked door/gate puzzles are non-functional (blocked by C2 anyway).

**Fix:** When creating connection Area3D nodes, ensure locked connections have a RoomConnection
resource with `locked = true` and the appropriate `key_id`.

### H5. Grounds Room Scenes Lack Wall Collision Layers

**Files affected:**
- `scenes/rooms/grounds/garden.tscn`
- `scenes/rooms/grounds/front_gate.tscn`

`front_gate.tscn` has a single CSGBox3D floor with `use_collision = true` but no explicit
`collision_layer` set (defaults to 1, which is correct for walkable).
`garden.tscn` similarly has one CSGBox3D floor.

Neither has wall geometry. The player can walk off the edge of the floor into the void.
Chapel, greenhouse, carriage_house, and family_crypt DO have wall geometry.

**Impact:** Player can walk off the map in front_gate and garden.

**Fix:** Add boundary collision (invisible walls or CSGBox3D walls on layer 2) to front_gate
and garden scenes.

### H6. PlayerController Does Not Connect to room_loaded Signal

**Files affected:** `scripts/player_controller.gd`, `STRUCTURE.md` (line 124)

STRUCTURE.md declares `RoomManager.room_loaded -> PlayerController._on_room_loaded` in the
signal map. PlayerController has no `_on_room_loaded` method.

Player repositioning happens inside `room_manager.gd` `_perform_room_switch()` (line 148-152)
by directly accessing the player node and setting position. This works but bypasses the signal
pattern documented in STRUCTURE.md.

**Impact:** The documented architecture does not match the implementation. Minor functionally
since repositioning still happens, but the player doesn't get notified of room changes.

**Fix:** Either update STRUCTURE.md to reflect reality, or add a `_on_room_loaded` handler
to PlayerController for future extensibility.

### H7. Room Transition Signals Not Connected to UIOverlay

**Files affected:** `scripts/ui_overlay.gd`, `STRUCTURE.md` (lines 125-126)

STRUCTURE.md declares:
- `RoomManager.room_transition_started -> UIOverlay._on_transition_started`
- `RoomManager.room_transition_finished -> UIOverlay._on_transition_finished`

UIOverlay has no such handlers and does not connect to these signals. The fade transition
is handled entirely by RoomManager's internal tween. UIOverlay could use these signals to
disable input during transitions.

**Impact:** During room transitions, the player can still tap and trigger interactions while
the screen is fading. Not game-breaking but breaks immersion.

**Fix:** Add handlers in UIOverlay that block input during transitions, or accept the current
behavior and update STRUCTURE.md.

---

## MEDIUM Gaps

### M1. No Interactable Hover/Glow Feedback

**Files affected:** `scripts/player_controller.gd`, `docs/GAME_DESIGN.md` (line 42)

GAME_DESIGN.md says "Discovers interactable object (subtle glow on hover)". No such feedback
exists. When the player looks at an interactable, nothing highlights. The player must blindly
tap objects to discover which are interactive.

**Impact:** Discoverability is poor. Players may miss critical puzzle items.

**Fix:** Add a continuous raycast in `_physics_process` that checks layer 3 and applies an
outline shader or emission boost to the hit object.

### M2. `room_data.gd` Marked Deprecated but Still Critical

**Files affected:** `scripts/room_data.gd`

The file header says "DEPRECATED" but it is actively loaded by `ui_overlay.gd` and
`audio_manager.gd` every time a room loads. It also contains the only authoritative source
of interactable definitions and connection data that should be in the room scenes.

**Impact:** Confusing for developers. Cannot be safely deleted despite being marked for removal.

**Fix:** Either remove the DEPRECATED label or complete the migration by:
1. Populating room scene Area3D nodes with the data
2. Updating ui_overlay and audio_manager to read from room instances
3. Then safely deleting room_data.gd

### M3. No Touch Controls for Pause Menu

**Files affected:** `scripts/ui_overlay.gd`, `project.godot`

The pause action is mapped only to the Escape key (physical_keycode 4194305). On mobile
devices, there is no way to pause the game. GAME_DESIGN.md says "Tap menu icon -> Pause game"
but no menu icon exists in the UI.

**Impact:** Mobile players cannot pause, save, or view inventory.

**Fix:** Add a persistent pause icon (hamburger menu or gear icon) in a corner of the screen
that triggers `_toggle_pause()`.

### M4. Walk Marker Added to Parent Instead of Scene

**Files affected:** `scripts/player_controller.gd` (line 64)

The walk marker MeshInstance3D is added via `get_parent().call_deferred("add_child", _walk_marker)`.
When the room changes, the walk marker persists because it is a child of the Main scene,
not the room. The marker from a previous room may appear at an incorrect position.

**Impact:** Visual artifact -- walk marker may appear at stale position after room transition.

**Fix:** Either hide the walk marker on room transition, or add it as a child of the current
room's container.

### M5. Save/Load Does Not Restore Player Position Within Room

**Files affected:** `scripts/game_manager.gd`

`save_game()` saves `current_room` but not the player's position or rotation within that room.
On load, the player is placed at the room's `spawn_position`, which is the entry point.

**Impact:** If the player saves while deep in a large room, they restart at the entrance.

**Fix:** Add `player_position` and `player_rotation` to the save data. Or accept this as
intentional design (many classic games do this).

### M6. Floor CSGBox3D Collision Layer Inconsistency Across Rooms

**Files affected:** Various room `.tscn` files

Most rooms have CSGBox3D floors with `use_collision = true` and no explicit `collision_layer`
(defaults to layer 1, which is correct). However, some rooms set `collision_mask = 0`
explicitly on floors while others don't. This is functionally fine since floors don't need
to detect collisions, but the inconsistency suggests the scenes were built by different
processes.

**Impact:** No functional issue, just code quality.

**Fix:** Standardize all CSGBox3D collision settings across rooms.

---

## LOW Gaps

### L1. PLAN.md Shows "Main Build" as Complete but Interactables Missing

**Files affected:** `PLAN.md`

PLAN.md marks `[x] Main Build: 20 room scenes` as complete, but the scenes lack the most
important content (interactables and connections). The verification criteria in PLAN.md
explicitly require "Interactables fire correct signals with correct data" and "All 6 puzzle
items in correct rooms".

**Impact:** Misleading status tracking.

**Fix:** Uncheck the main build checkbox or add a sub-item for interactable/connection
population.

### L2. STRUCTURE.md Documents `connections: Array[Dictionary]` as Exported Var

**Files affected:** `STRUCTURE.md` (line 23)

STRUCTURE.md says `room_base.gd` should have `@export var connections: Array[Dictionary]`.
The actual script does not have this export. Connections are discovered via the `"connections"`
group search.

**Impact:** Documentation mismatch.

**Fix:** Update STRUCTURE.md to reflect the actual group-based design.

### L3. `room_data.gd` Has Interactable Data That Doesn't Match `InteractableData` Resource

**Files affected:** `scripts/interactable_data.gd`, `scripts/room_data.gd`

`interactable_data.gd` defines a proper Resource class with all puzzle fields. But the data in
`room_data.gd` uses raw Dictionary format with different key structures (e.g., nested `data` dict
vs flat properties). When Area3D nodes are eventually created, the data format needs to be
translated.

The `player_controller.gd` reads meta as `area.get_meta("data")` (Dictionary), not as an
InteractableData resource. So the InteractableData resource class exists but is unused.

**Impact:** The Resource class exists but serves no purpose in the current architecture.

**Fix:** Either use InteractableData resources on the Area3D meta, or simplify by sticking
with the raw Dictionary approach that player_controller.gd already expects.

### L4. Presentation Video Not Yet Created

**Files affected:** `PLAN.md`

PLAN.md has `[ ] Presentation video` unchecked. The verification criteria call for a
"30s cinematic tour."

**Impact:** Deliverable incomplete but non-blocking for gameplay.

**Fix:** Create `test/presentation.gd` cinematic script after gameplay is functional.

---

## Puzzle Chain Verification

Assuming interactable Area3D nodes are created with the data from `room_data.gd`:

### Attic Key Puzzle
1. Read `diary_lord` in master_bedroom -> sets `read_ashworth_diary`, `knows_key_location` -- OK
2. Interact `library_globe` in library -> gives `attic_key` -- OK
3. Use `attic_key` on locked connection to `attic_stairs` in upper_hallway -- OK (if connection Area3D has lock data)

### Hidden Key Puzzle
1. Read `elizabeth_letter` in attic_storage -> sets `read_elizabeth_letter` -- OK
2. Interact `porcelain_doll` in attic_storage (first time) -> sets `examined_doll` -- OK
3. Interact `porcelain_doll` (with `read_elizabeth_letter` flag) -> gives `hidden_key`, also gives `porcelain_doll` item -- OK
4. Use `hidden_key` on locked connection to `hidden_chamber` -- OK (if connection exists)

### Cellar Key Puzzle
1. Interact `carriage_painting` in carriage_house -> gives `cellar_key` -- OK
2. Use `cellar_key` on `wine_cellar_box` in wine_cellar -> gives `mothers_confession` -- OK

### Jewelry Key Puzzle
1. Interact `loose_flagstone` in family_crypt -> gives `jewelry_key` -- OK
2. Use `jewelry_key` on `jewelry_box` in master_bedroom -> gives `elizabeth_locket` + `lock_of_hair` -- OK

### Gate Key Puzzle
1. Interact `greenhouse_gate_key` in greenhouse -> gives `gate_key` -- OK
2. Use `gate_key` on locked connection from garden to family_crypt -- OK (if connection exists)

### Counter-Ritual
Required: `porcelain_doll`, `binding_book`, `lock_of_hair`, `blessed_water`, `mothers_confession`, `read_final_note` flag
1. `porcelain_doll` -- from hidden key puzzle -- OK
2. `binding_book` -- from library (pickable note) -- OK
3. `lock_of_hair` -- from jewelry key puzzle -- OK
4. `blessed_water` -- from chapel `holy_water_font` -- OK
5. `mothers_confession` -- from cellar key puzzle -- OK
6. `read_final_note` -- from reading `final_note` in hidden_chamber -- OK
7. Steps: place doll -> pour water -> read book -> sets `counter_ritual_complete`, `freed_elizabeth` -- OK

### Ending Triggers
- **Freedom**: `counter_ritual_complete` flag set -> player leaves -> `transition_to("front_gate")` proceeds normally -- OK
- **Escape**: `knows_full_truth` and not `counter_ritual_complete` -> triggers when trying to go to front_gate -- OK
- **Joined**: `elizabeth_aware` and not `knows_full_truth` -- **BROKEN** (`elizabeth_aware` never set)

---

## Priority Fix Order

1. **C1 + C2**: Populate all 20 room scenes with interactable and connection Area3D nodes
   (using data from room_data.gd). This is the single largest task and blocks all gameplay.
2. **C3**: Add `elizabeth_aware` flag to at least one interactable's `on_read_flags`
3. **H1**: Fix 5 ground room scenes to use exported vars instead of metadata prefix
4. **H2**: Remove duplicate Camera3D
5. **H3**: Migrate ui_overlay and audio_manager off room_data.gd dependency
6. **H4**: Ensure locked connections have proper RoomConnection resources
7. **H5**: Add boundary collision to front_gate and garden
8. **M3**: Add mobile pause button
9. Remaining items as time permits
