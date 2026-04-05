# Testing Plan — gdUnit4

## Source
- Addon: `MikeSchulze/gdUnit4`
- Location: `addons/gdUnit4/`
- Run: `godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd`

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

1. Create `test/unit/` directory for gdUnit4 test suites
2. Write `test_room_structure.gd` — loads each room, checks node hierarchy
3. Write `test_interactables.gd` — checks every interactable per room
4. Write `test_connections.gd` — checks every connection and reciprocity
5. Write `test_puzzles.gd` — simulates each puzzle chain
6. Write `test_lighting.gd` — checks light configuration per room
7. Write `test_endings.gd` — simulates all three ending conditions
8. Run full suite: `godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd`
