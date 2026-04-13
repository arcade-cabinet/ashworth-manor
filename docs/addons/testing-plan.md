# Testing Plan — gdUnit4

## Source
- Addon: `MikeSchulze/gdUnit4`
- Location: `addons/gdUnit4/`
- Runner config: `GdUnitRunner.cfg`
- Current repo-local command: `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`

## Current Repo Usage

gdUnit4 is now re-enabled as a focused repo-local unit lane rather than an
aspirational placeholder. The current suite lives under `test/unit/` and
validates route-program semantics that are awkward to express as pure
declaration tests:

- canonical `Adult -> Elder -> Child` progression
- explicit post-third-run replay mode
- `set_route_context()` compatibility mapping between shipped route ids and the
  legacy `macro_thread` shim

The command must include `--ignoreHeadlessMode`. Without it, gdUnit4 aborts in
this project with "Headless mode is not supported." The suite is intentionally
kept headless-safe: no UI input simulation, no window-dependent assertions.

## Test Categories

### 1. Room Structure Tests (per room)
For each of the 20 rooms, verify:
- Scene loads without errors
- Root node is RoomBase with correct room_id
- Has Geometry, Models, Lighting, Interactables, Connections child nodes
- Floor collision exists (Layer 1)
- Wall collision exists (Layer 2)
- spawn_position is inside room bounds
- audio_loop references an existing OGG file

### 2. Interactable Tests (per room)
For each room's interactables, verify:
- Area3D exists with collision_layer = 4 (Layer 3)
- Has CollisionShape3D child
- Has metadata/id matching documented interactable
- Has metadata/type matching documented type
- Dialogue file has matching title entry

### 3. Connection Tests (per room)
For each room's connections, verify:
- Area3D exists with collision_layer = 8 (Layer 4)
- Has metadata/target_room pointing to valid room_id
- Target room has reciprocal connection back
- Locked connections have valid key_id

### 4. Puzzle Chain Tests
For each of the 6 puzzles, verify:
- All prerequisite flags exist in code
- Key items are placed in correct rooms
- Flag chain completes correctly
- Quest state updates on completion

### 5. Lighting Tests (per room)
For each room, verify:
- At least one light source exists
- Flickering lights have metadata/flickering = true
- Light energy within documented range
- Shadow-casting lights limited (performance)

### 6. Ending Tests
- Freedom ending: verify all 6 components → ritual → freed_elizabeth flag
- Escape ending: verify knows_full_truth + exit → escape
- Joined ending: verify elizabeth_aware + !knows_full_truth + exit → joined

## Implementation Steps

1. Keep `GdUnitRunner.cfg` present at repo root.
2. Add headless-safe suites under `test/unit/`.
3. Prefer route/program/unit semantics that do not require pointer or keyboard
   input in headless mode.
4. Keep declaration/runtime traversal coverage in the existing `test/e2e/`
   lanes; do not duplicate them wholesale in gdUnit4.
5. Run the active suite with:

```bash
godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode
```
