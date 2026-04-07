# Maestro E2E Automation Plan

How to automatically build an APK, launch an emulator, and run Maestro flows that play through every room of Ashworth Manor as a real player would.

---

## The Pipeline

```
1. godot --headless --export-release "Android" build/ashworth-manor.apk
2. emulator -avd Pixel_8a -no-window -no-audio &
3. adb wait-for-device && adb install build/ashworth-manor.apk
4. maestro test test/maestro/
5. Screenshots + pass/fail report
```

### Step 1: Build APK

```bash
export ANDROID_HOME=~/Library/Android/sdk
godot --headless --path . --export-release "Android" build/ashworth-manor.apk
```

**Prerequisites:**
- `export_presets.cfg` with Android target (EXISTS)
- Android build template installed in `android/build/` (EXISTS)
- Debug keystore configured (Godot uses `~/.android/debug.keystore` by default)
- Java 17+ for Gradle

### Step 2: Start Emulator

```bash
# Fix missing system images first (one-time setup)
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
  "system-images;android-35;google_apis_playstore;arm64-v8a"

# Recreate AVD with correct image
$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd \
  --force --name ashworth_test \
  --device "pixel_6a" \
  --package "system-images;android-35;google_apis_playstore;arm64-v8a"

# Start headless emulator
$ANDROID_HOME/emulator/emulator -avd ashworth_test \
  -no-window -no-audio -no-boot-anim -gpu swiftshader_indirect &

# Wait for boot
adb wait-for-device
adb shell getprop sys.boot_completed | grep -q 1 || sleep 10
```

### Step 3: Install APK

```bash
adb install -r build/ashworth-manor.apk
```

### Step 4: Run Maestro Flows

```bash
maestro test test/maestro/
# Or specific flow:
maestro test test/maestro/full_walkthrough.yaml
```

---

## The Coordinate Problem (and Solution)

### The Problem

Maestro can tap at screen coordinates (`point: "50%,50%"`), but in a 3D game:
- Interactable positions depend on camera angle and player position
- The same object appears at different screen coordinates as the player moves
- There are no accessibility labels on 3D geometry

### Solution: Test Helper Script

Create a GDScript that runs in the APK specifically for Maestro testing. When enabled, it:

1. **Projects world-space interactable positions to screen-space** using `Camera3D.unproject_position()`
2. **Writes a JSON file** mapping interactable IDs to current screen coordinates
3. **Overlays invisible accessibility labels** at those positions (Godot `Label` nodes positioned at screen-space coords)
4. Maestro can then use `tapOn: "foyer_painting"` instead of guessing coordinates

```gdscript
# scripts/debug/maestro_helper.gd — ONLY included in debug builds
extends Node

var _labels: Dictionary = {}  # id → Label

func _process(_delta: float) -> void:
    var cam: Camera3D = get_viewport().get_camera_3d()
    if cam == null:
        return
    var rm = _find_node("RoomManager")
    if rm == null or not rm.has_method("get_current_room"):
        return
    var room = rm.get_current_room()
    if room == null:
        return
    
    # Clear old labels
    for label in _labels.values():
        label.queue_free()
    _labels.clear()
    
    # Project each interactable to screen space
    for area in room.get_interactables():
        if not area.has_meta("id"):
            continue
        var obj_id: String = area.get_meta("id")
        var world_pos: Vector3 = area.global_position
        
        # Skip if behind camera
        if not cam.is_position_behind(world_pos):
            var screen_pos: Vector2 = cam.unproject_position(world_pos)
            
            # Create invisible label at screen position for Maestro
            var label := Label.new()
            label.text = obj_id
            label.position = screen_pos - Vector2(50, 10)
            label.modulate.a = 0.01  # Nearly invisible but Maestro can find it
            label.add_theme_font_size_override("font_size", 1)
            get_tree().root.add_child(label)
            _labels[obj_id] = label
    
    # Also project connections
    for area in room.get_connections():
        if not area.has_meta("target_room"):
            continue
        var target: String = "go_" + area.get_meta("target_room")
        var world_pos: Vector3 = area.global_position
        if not cam.is_position_behind(world_pos):
            var screen_pos: Vector2 = cam.unproject_position(world_pos)
            var label := Label.new()
            label.text = target
            label.position = screen_pos - Vector2(50, 10)
            label.modulate.a = 0.01
            label.add_theme_font_size_override("font_size", 1)
            get_tree().root.add_child(label)
            _labels[target] = label
```

**With this helper active, Maestro flows become semantic:**

```yaml
# Instead of guessing coordinates:
- tapOn:
    point: "50%,35%"

# We can write:
- tapOn: "foyer_painting"
- tapOn: "go_parlor"
```

### Enabling the Helper

Add it as a conditional autoload that only activates in debug builds:

```gdscript
# In game_manager.gd or a separate autoload
func _ready() -> void:
    if OS.is_debug_build():
        var helper = load("res://scripts/debug/maestro_helper.gd").new()
        helper.name = "MaestroHelper"
        get_tree().root.call_deferred("add_child", helper)
```

---

## Flow Architecture

### Flow Hierarchy

```
test/maestro/
├── config.yaml                  # App ID, shared settings
├── smoke_test.yaml              # Basic: launch, render, don't crash
├── room_flows/
│   ├── _navigate_to_room.yaml   # Reusable sub-flow for room navigation
│   ├── front_gate.yaml          # Front gate interactables
│   ├── foyer.yaml               # Foyer interactables
│   ├── parlor.yaml              # Parlor + first clue
│   ├── dining_room.yaml
│   ├── kitchen.yaml
│   ├── upper_hallway.yaml
│   ├── master_bedroom.yaml      # Diary + jewelry box
│   ├── library.yaml             # Globe + binding book + family tree
│   ├── guest_room.yaml
│   ├── storage_basement.yaml
│   ├── boiler_room.yaml
│   ├── wine_cellar.yaml
│   ├── garden.yaml
│   ├── chapel.yaml              # Blessed water
│   ├── greenhouse.yaml          # Gate key
│   ├── carriage_house.yaml      # Cellar key
│   ├── family_crypt.yaml        # Jewelry key
│   ├── attic_stairwell.yaml     # Phase transition
│   ├── attic_storage.yaml       # Doll puzzle + hidden key
│   └── hidden_chamber.yaml      # Final note + ritual
├── puzzle_flows/
│   ├── puzzle_attic_key.yaml    # Diary → globe → key → door
│   ├── puzzle_hidden_key.yaml   # Letter → doll → key → chamber
│   ├── puzzle_cellar_box.yaml   # Portrait → key → box → confession
│   ├── puzzle_jewelry_box.yaml  # Crypt → key → box → locket
│   ├── puzzle_crypt_gate.yaml   # Greenhouse → key → crypt
│   └── puzzle_counter_ritual.yaml  # All components → 3 steps → freedom
├── ending_flows/
│   ├── ending_freedom.yaml      # Full ritual → freedom ending
│   ├── ending_escape.yaml       # Know truth + exit → escape
│   └── ending_joined.yaml       # Aware + exit → joined
└── full_playthrough.yaml        # Chains all flows: complete freedom ending
```

### Room Flow Pattern

Each room flow follows the same pattern:

```yaml
appId: com.arcadecabinet.ashworthmanor
name: "Room: Foyer — All Interactables"
tags:
  - room
  - foyer
---
# Navigate to foyer (uses sub-flow or assumes already there)
- runFlow: room_flows/_navigate_to_room.yaml
  env:
    TARGET_ROOM: foyer

# Screenshot room overview
- takeScreenshot: screenshots/maestro/rooms/foyer_01_overview

# Interact with each documented interactable
- tapOn: "foyer_painting"
- sleep: 1500
- takeScreenshot: screenshots/maestro/rooms/foyer_02_painting
- tapOn:
    point: "50%,50%"   # Dismiss document
- sleep: 500

- tapOn: "foyer_mirror"
- sleep: 1500
- takeScreenshot: screenshots/maestro/rooms/foyer_03_mirror
- tapOn:
    point: "50%,50%"
- sleep: 500

- tapOn: "grandfather_clock"
- sleep: 1500
- takeScreenshot: screenshots/maestro/rooms/foyer_04_clock
- tapOn:
    point: "50%,50%"
- sleep: 500

- tapOn: "entry_switch"
- sleep: 1000
- takeScreenshot: screenshots/maestro/rooms/foyer_05_switch_toggled

- tapOn: "foyer_mail"
- sleep: 1500
- takeScreenshot: screenshots/maestro/rooms/foyer_06_mail
- tapOn:
    point: "50%,50%"
- sleep: 500

- tapOn: "foyer_stairs"
- sleep: 1500
- takeScreenshot: screenshots/maestro/rooms/foyer_07_stairs
- tapOn:
    point: "50%,50%"
- sleep: 500

# Verify we interacted with everything
- takeScreenshot: screenshots/maestro/rooms/foyer_08_complete
```

### Navigation Sub-Flow

```yaml
# room_flows/_navigate_to_room.yaml
# Uses connection labels to navigate room-by-room
# TARGET_ROOM env var specifies destination

appId: com.arcadecabinet.ashworthmanor
name: "Navigate to ${TARGET_ROOM}"
---
# The MaestroHelper creates labels like "go_foyer", "go_parlor"
# Tap the connection label for the target room
- tapOn: "go_${TARGET_ROOM}"
- sleep: 3000  # Wait for transition + room load
- waitForAnimationToEnd
```

---

## What Each Flow Validates

### Room Flows (20 flows)
- Every documented interactable is tappable (Maestro finds the label)
- Document overlay appears and is dismissable
- Lights are visible (screenshot comparison)
- Room geometry renders (no black screen)

### Puzzle Flows (6 flows)
- Item acquisition works (tap container → item appears in inventory)
- Locked containers reject without key
- Key items unlock correct targets
- Flag chains propagate correctly

### Ending Flows (3 flows)
- Freedom: ritual sequence completes, ending text displays
- Escape: exit with truth → escape text
- Joined: exit without truth → joined text

---

## Automation Script

```bash
#!/bin/bash
# scripts/run_maestro_e2e.sh — Full automated pipeline
set -e

export ANDROID_HOME=~/Library/Android/sdk
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APK_PATH="$PROJECT_DIR/build/ashworth-manor.apk"
AVD_NAME="ashworth_test"

echo "=== Step 1: Build APK ==="
cd "$PROJECT_DIR"
godot --headless --path . --export-release "Android" "$APK_PATH"
echo "APK built: $APK_PATH"

echo "=== Step 2: Start Emulator ==="
$ANDROID_HOME/emulator/emulator -avd "$AVD_NAME" \
  -no-window -no-audio -no-boot-anim -gpu swiftshader_indirect &
EMU_PID=$!
adb wait-for-device
echo "Waiting for boot..."
while [ "$(adb shell getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
  sleep 2
done
echo "Emulator booted"

echo "=== Step 3: Install APK ==="
adb install -r "$APK_PATH"
echo "APK installed"

echo "=== Step 4: Run Maestro Flows ==="
mkdir -p "$PROJECT_DIR/screenshots/maestro"
maestro test "$PROJECT_DIR/test/maestro/" \
  --format junit \
  --output "$PROJECT_DIR/build/maestro-results.xml"
EXIT_CODE=$?

echo "=== Step 5: Cleanup ==="
kill $EMU_PID 2>/dev/null || true

echo ""
if [ $EXIT_CODE -eq 0 ]; then
  echo "✓ All Maestro E2E flows passed"
else
  echo "✗ Some flows failed — check build/maestro-results.xml"
fi
echo "Screenshots: $PROJECT_DIR/screenshots/maestro/"
exit $EXIT_CODE
```

---

## Setup Required (One-Time)

1. **Fix AVD system images:**
   ```bash
   export ANDROID_HOME=~/Library/Android/sdk
   $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
     "system-images;android-35;google_apis_playstore;arm64-v8a"
   $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd \
     --force --name ashworth_test --device "pixel_6a" \
     --package "system-images;android-35;google_apis_playstore;arm64-v8a"
   ```

2. **Set ANDROID_HOME in shell profile:**
   ```bash
   echo 'export ANDROID_HOME=~/Library/Android/sdk' >> ~/.zshrc
   echo 'export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH' >> ~/.zshrc
   ```

3. **Create the MaestroHelper script** at `scripts/debug/maestro_helper.gd`

4. **Write all 29 Maestro flow files** (20 rooms + 6 puzzles + 3 endings)

5. **Create footstep audio files** (36 OGGs needed — 9 surfaces x 4 variations)

---

## Key Insight: Why This Works for a 3D Game

Most Maestro tutorials show tapping on UI buttons with text labels. A 3D game has no such labels — objects exist in world-space, not screen-space.

The `MaestroHelper` bridge solves this by:
1. Each frame, projecting every visible interactable from world-space to screen-space
2. Creating nearly-invisible `Label` nodes at those screen positions
3. Maestro's `tapOn: "foyer_painting"` finds the label by text content
4. The tap lands at the correct screen position for the current camera angle

This means:
- Flows are **semantic** (tap by name, not coordinates)
- Flows are **resolution-independent** (labels move with the projection)
- Flows are **camera-angle-tolerant** (labels update every frame)
- Flows are **maintainable** (add a new interactable → it automatically gets a label)
