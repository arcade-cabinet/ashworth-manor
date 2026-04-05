# PRD: Ashworth Manor — Production Build

## Overview

Take Ashworth Manor from documented-but-lifeless to a polished, fully tested PSX horror exploration game. All 20 rooms must be alive with interactables, conditional dialogue, adaptive audio, flickering lights, surface-based footsteps, camera inspection, and a hierarchical state machine driving the horror progression. Three endings, six puzzles, and a complete narrative from front gate to freedom/escape/joined ending.

**Business Value:** Ship a complete, playable game that delivers the "elevated Silent Hill meets Myst with PSX uplifted" experience documented in VISION.md.

**Current State:** Documentation complete (160 room docs, 11 addon plans, master narrative script). 129 .tres resources created. Tests written but failing (rooms lack interactables). Scenes exist as empty shells. Zero addon integration.

**Target State:** All tests pass. Every room is alive. Full playthrough works. Screenshots confirm visual quality. APK exports for Android.

---

## Goals

1. All 20 room scenes pass `test_room_specs.gd` (interactables, connections, lights, flickering)
2. Full click-through walkthrough passes `test_room_walkthrough.gd` with screenshot capture of all 97 interactables
3. All 3 endings completable via `run_e2e.gd` (freedom, escape, joined)
4. All 11 addons integrated and functional
5. Save/load preserves complete game state across sessions
6. PSX post-process renders correctly (dithering, color depth, resolution scale)
7. Android APK exports and runs on emulator

---

## Out of Scope

- Multiplayer or online features
- Voice acting or recorded audio narration
- Procedural level generation
- NPC AI pathfinding (Elizabeth is event-driven, not AI)
- Localization/translations
- Monetization or store integration
- VR/AR support

---

## Technical Requirements

- **Engine:** Godot 4.6.2 (Forward+)
- **Language:** GDScript only (no C#)
- **Max LOC per script:** 200 (per STANDARDS.md)
- **Rendering:** Screen-space PSX post-process only (godot-psx `psx_dither` + `psx_fade`). NO per-material shaders on PSX assets.
- **Textures:** 596 PNGs with `filter_nearest` import. NO shader overrides.
- **Audio:** 36 OGG ambient loops, layered via AdaptiSound. 36 footstep files (9 surfaces x 4 variants). SFX for events.
- **Testing:** Headless E2E via `godot --headless --script`. Integration with screenshot capture. gdUnit4 for unit tests.

---

## User Stories

### Phase 1: Foundation (Shader + Addons + Scene Rebuild)

---

#### US-1.1: Delete custom shaders and configure godot-psx screen-space rendering

As a developer,
I want the PSX post-process to use the upstream godot-psx shaders,
So that rendering is correct and maintainable.

Acceptance Criteria:
- [ ] `shaders/psx.gdshader` and its `.uid` deleted
- [ ] `shaders/psx_post.gdshader` replaced with godot-psx `psx_dither.gdshader`
- [ ] `psx_fade.gdshader` copied from godot-psx for room transitions
- [ ] `main.tscn` updated to reference `psx_dither.gdshader`
- [ ] `room_manager.gd` fade system uses `psx_fade` shader instead of ColorRect alpha tween
- [ ] All texture PNGs confirmed importing with `filter_nearest`
- [ ] No room .tscn has any material override with custom shaders
- [ ] Game renders with visible dithering and color depth reduction

**Ref:** `docs/addons/shader-plan.md`

---

#### US-1.2: Install 3 new addons via gd-plug

As a developer,
I want godot-material-footsteps, phantom-camera, and limboai installed,
So that footstep sounds, camera inspection, and state machine features are available.

Acceptance Criteria:
- [ ] `plug.gd` updated with 3 new `plug()` calls
- [ ] `godot --headless --script addons/gd-plug/plug.gd install` runs successfully
- [ ] `addons/` contains material_footsteps, phantom_camera, limboai directories
- [ ] All 3 addons enabled in `project.godot` plugin section
- [ ] No import errors in Godot editor

**Ref:** `docs/addons/footsteps-plan.md`, `phantom-camera-plan.md`, `state-machine-plan.md`

---

#### US-1.3: Rebuild front_gate scene with all documented interactables and connections

As a player,
I want the front gate to have 5 interactable objects and 2 exits,
So that my first moments in the game establish atmosphere and narrative.

Acceptance Criteria:
- [ ] `gate_plaque` Area3D with correct metadata/id, type, collision layer 4
- [ ] `gate_luggage` Area3D on luggage model position
- [ ] `gate_bench` Area3D on bench model position
- [ ] `iron_gate` Area3D on gate model position
- [ ] `gate_lamp` Area3D + lamp model (`lamp_mx_1_b_on.glb`) added to scene
- [ ] `to_foyer` connection Area3D at (0, 1.5, 10) with collision layer 8
- [ ] `to_garden` connection Area3D at (10, 1.5, 0) with collision layer 8
- [ ] Gate lamp OmniLight3D has `metadata/flickering = true`
- [ ] Moonlight DirectionalLight3D has shadow enabled
- [ ] `test_room_specs.gd` passes for `front_gate`

**Ref:** `docs/rooms/front_gate/`

---

#### US-1.4: Rebuild foyer scene with all 6 interactables and 5 connections

As a player,
I want the foyer to introduce the frozen moment, the patriarch, and the supernatural mirror,
So that the game's core mysteries are established in the first interior room.

Acceptance Criteria:
- [ ] Existing 4 interactables updated with enriched metadata/data content
- [ ] `foyer_mail` Area3D added at (-5, 0.9, -4) on drawers
- [ ] `foyer_stairs` Area3D added at (2, 1, -2) near staircase
- [ ] All 5 connections present: parlor, dining_room, kitchen, upper_hallway, front_gate
- [ ] Chandelier light switchable via `entry_switch`
- [ ] Both sconces have `metadata/flickering = true`
- [ ] Window light provides cold moonlight contrast
- [ ] `test_room_specs.gd` passes for `foyer`

**Ref:** `docs/rooms/foyer/`

---

#### US-1.5: Rebuild parlor scene with 5 interactables

As a player,
I want the parlor to contain the first major clue (diary page) and Lady Ashworth's portrait,
So that the Discovery phase can be triggered.

Acceptance Criteria:
- [ ] `parlor_painting_1`, `parlor_note`, `music_box` updated with enriched content
- [ ] `parlor_fireplace` Area3D added at (0, 1, 4.5)
- [ ] `parlor_tea` Area3D added at (0, 0.8, -1)
- [ ] Fireplace light has `metadata/flickering = true` with slow breathing pattern
- [ ] Both candle lights have `metadata/flickering = true`
- [ ] Connection to foyer present
- [ ] `parlor_note` interaction sets `found_first_clue` and `knows_attic_girl` flags
- [ ] `test_room_specs.gd` passes for `parlor`

**Ref:** `docs/rooms/parlor/`

---

#### US-1.6: Rebuild dining_room scene — currently ZERO interactables

As a player,
I want the dining room to tell the story of the last supper,
So that the frozen dinner party and its horror are tangible.

Acceptance Criteria:
- [ ] 6 new Area3D interactables added: `dinner_photo`, `dining_pushed_chair`, `dining_wine_glass`, `dining_place_settings`, `dining_candles`, `dining_vessel`
- [ ] Each has correct metadata/id, metadata/type, metadata/data
- [ ] Both table candle lights have `metadata/flickering = true`
- [ ] Connection to foyer present and correctly positioned at doorway
- [ ] `test_room_specs.gd` passes for `dining_room`

**Ref:** `docs/rooms/dining_room/`

---

#### US-1.7: Rebuild kitchen scene — currently ZERO interactables

As a player,
I want the kitchen to contain the cook's note and environmental storytelling,
So that the servant perspective adds to the mystery.

Acceptance Criteria:
- [ ] 5 new Area3D interactables: `kitchen_note`, `kitchen_cutting_board`, `kitchen_hearth`, `kitchen_knives`, `kitchen_bucket`
- [ ] Connections to foyer AND storage_basement (stairs) both present
- [ ] Hearth light with `metadata/flickering = true`
- [ ] `test_room_specs.gd` passes for `kitchen`

**Ref:** `docs/rooms/kitchen/`

---

#### US-1.8: Rebuild upper_hallway — currently 0 interactables, 1 connection

As a player,
I want the upper hallway to be a hub with the locked attic door driving me to find the key,
So that Act II puzzle motivation is established.

Acceptance Criteria:
- [ ] 5 interactables: `attic_door` (locked_door type), `children_painting`, `hallway_mask`, `hallway_poster`, `hallway_switch`
- [ ] `attic_door` has locked=true, key_id=attic_key, target_room=attic_stairs
- [ ] 4 connections: foyer (stairs), master_bedroom, library, guest_room
- [ ] 2 sconces with `metadata/flickering = true`
- [ ] `test_room_specs.gd` passes for `upper_hallway`

**Ref:** `docs/rooms/hallway/`

---

#### US-1.9: Rebuild master_bedroom with 4 new interactables

As a player,
I want the master bedroom to reveal Lord Ashworth's guilt and contain the locked jewelry box,
So that the diary clue and locket puzzle function.

Acceptance Criteria:
- [ ] Existing 3 interactables (diary, mirror, jewelry_box) metadata enriched
- [ ] 4 new Area3Ds: `bedroom_bed`, `bedroom_book`, `bedroom_wardrobe`, `bedroom_broken_bottle`
- [ ] `jewelry_box` wired: locked=true, key_id=jewelry_key, item_found=elizabeths_locket, gives_also=lock_of_hair
- [ ] Both candle lights flickering
- [ ] `test_room_specs.gd` passes for `master_bedroom`

**Ref:** `docs/rooms/master_bedroom/`

---

#### US-1.10: Rebuild library with 3 new interactables

As a player,
I want the library to contain the attic key (globe), binding book, and family tree,
So that I can unlock the attic and understand the binding ritual.

Acceptance Criteria:
- [ ] Existing 3 interactables enriched
- [ ] 3 new Area3Ds: `library_artifact`, `library_shelves`, `library_gears`
- [ ] `library_globe` gives `attic_key` on interaction
- [ ] `binding_book` is pickable (pickable=true, item_id=binding_book)
- [ ] 3 lights with flickering
- [ ] `test_room_specs.gd` passes for `library`

**Ref:** `docs/rooms/library/`

---

#### US-1.11: Rebuild guest_room — currently ZERO interactables

As a player,
I want Helena Pierce's story told through 5 objects,
So that the Ashworths' destruction of innocent guests is documented.

Acceptance Criteria:
- [ ] 5 new Area3Ds: `guest_ledger`, `helena_photo`, `guest_luggage`, `guest_bed`, `guest_lamp`
- [ ] Connection to upper_hallway
- [ ] Candle flickering, window moonlight
- [ ] `test_room_specs.gd` passes for `guest_room`

**Ref:** `docs/rooms/guest_room/`

---

#### US-1.12: Rebuild storage_basement with 3 new interactables

As a player,
I want the storage basement to reveal the scratched portrait and Elizabeth's hidden belongings,
So that the physical evidence of erasure is discovered.

Acceptance Criteria:
- [ ] Existing `scratched_portrait` enriched
- [ ] 3 new Area3Ds: `storage_mirror`, `storage_covered`, `storage_trunk`
- [ ] 3 connections: kitchen (stairs), boiler_room, wine_cellar (ladder)
- [ ] Single candle flickering
- [ ] `test_room_specs.gd` passes for `storage_basement`

**Ref:** `docs/rooms/storage_basement/`

---

#### US-1.13: Rebuild boiler_room with 4 new interactables

As a player,
I want the boiler room to feel industrially menacing with the maintenance log confirming staff fear,
So that the house-as-machine metaphor is established.

Acceptance Criteria:
- [ ] Existing `maintenance_log` enriched
- [ ] 4 new Area3Ds: `boiler_clock`, `boiler_observation`, `boiler_pipes`, `boiler_mask`
- [ ] Boiler glow light with aggressive flicker
- [ ] Connection to storage_basement
- [ ] `test_room_specs.gd` passes for `boiler_room`

**Ref:** `docs/rooms/boiler_room/`

---

#### US-1.14: Rebuild wine_cellar with 2 new interactables

As a player,
I want the wine cellar to feel isolated and contain the locked box with Lady Ashworth's confession,
So that the deepest accessible room rewards exploration.

Acceptance Criteria:
- [ ] Existing `wine_note` and `wine_box` enriched; box wired locked=true, key_id=cellar_key, item_found=mothers_confession
- [ ] 2 new Area3Ds: `wine_racks`, `wine_footprints`
- [ ] 2 torches with aggressive flicker
- [ ] Connection to storage_basement (ladder)
- [ ] `test_room_specs.gd` passes for `wine_cellar`

**Ref:** `docs/rooms/wine_cellar/`

---

#### US-1.15: Rebuild attic_stairwell with 2 interactables

As a player,
I want the attic stairwell to be a dread-filled threshold that triggers the Horror phase,
So that entering the attic permanently changes the game atmosphere.

Acceptance Criteria:
- [ ] 2 new Area3Ds: `stairwell_debris`, `stairwell_wall`
- [ ] Connections: upper_hallway (stairs down), attic_storage (door forward)
- [ ] Window moonlight (cold, thin)
- [ ] Entry triggers `entered_attic` and `elizabeth_aware` flags
- [ ] `test_room_specs.gd` passes for `attic_stairs`

**Ref:** `docs/rooms/attic_stairwell/`

---

#### US-1.16: Rebuild attic_storage with 6 interactables — narrative climax

As a player,
I want Elizabeth's prison to contain her portrait, the doll puzzle, her letter, and the hidden door,
So that the truth is revealed through her belongings.

Acceptance Criteria:
- [ ] 6 Area3Ds: `elizabeth_portrait`, `porcelain_doll` (doll type), `elizabeth_letter`, `hidden_door` (locked_door), `attic_window`, `elizabeth_trunk`
- [ ] Doll multi-step logic: first tap = examine, second (after letter) = extract hidden_key + make doll pickable
- [ ] `hidden_door` locked with hidden_key, target=hidden_room
- [ ] Candle near doll flickering, window moonlight
- [ ] Connection to attic_stairs
- [ ] `test_room_specs.gd` passes for `attic_storage`

**Ref:** `docs/rooms/attic_storage/`

---

#### US-1.17: Rebuild hidden_chamber with 5 interactables — endgame room

As a player,
I want the hidden chamber to contain Elizabeth's final words, the ritual circle, and the counter-ritual sequence,
So that I can complete the game with the freedom ending.

Acceptance Criteria:
- [ ] 5 Area3Ds: `elizabeth_final_note`, `chamber_drawings`, `hidden_mirror`, `ritual_circle` (ritual type), `chamber_artifact`
- [ ] `ritual_circle` executes 3-step counter-ritual via interaction_manager
- [ ] 2 candles flickering (darkest room, ambient 0.9)
- [ ] Connection to attic_storage
- [ ] Entry sets `found_hidden_chamber` and `knows_full_truth`
- [ ] `test_room_specs.gd` passes for `hidden_room`

**Ref:** `docs/rooms/hidden_chamber/`

---

#### US-1.18: Rebuild all 5 grounds rooms (garden, chapel, greenhouse, carriage_house, family_crypt)

As a player,
I want the exterior grounds to contain ritual components, puzzle keys, and environmental storytelling,
So that the counter-ritual can be assembled and the grounds feel alive.

Acceptance Criteria:
- [ ] Garden: 4 interactables + 3 connections (front_gate, chapel, greenhouse)
- [ ] Chapel: 5 interactables + `baptismal_font` gives `blessed_water` + 1 connection
- [ ] Greenhouse: 3 interactables + `greenhouse_pot` gives `gate_key` + 1 connection
- [ ] Carriage House: 3 interactables + `carriage_portrait` gives `cellar_key` + 1 connection
- [ ] Family Crypt: 4 interactables + `crypt_flagstone` gives `jewelry_key` + 1 locked connection (gate_key)
- [ ] All rooms have directional/moonlight + appropriate flickering where documented
- [ ] `test_room_specs.gd` passes for all 5 rooms

**Ref:** `docs/rooms/garden/`, `chapel/`, `greenhouse/`, `carriage_house/`, `family_crypt/`

---

### Phase 2: Dialogue + Inventory + Audio Integration

---

#### US-2.1: Create .dialogue files for all 20 rooms with conditional text

As a player,
I want interactable text to change based on what I've discovered,
So that the world responds to my progress through the narrative.

Acceptance Criteria:
- [ ] `dialogue/` directory created with per-floor subdirectories
- [ ] 20 `.dialogue` files written, one per room
- [ ] Every interactable ID from room docs has a matching `~ {id}` title in its .dialogue file
- [ ] Conditional variants using `if GameManager.has_flag()` / `elif` / `else` for 2-3 tiers per interactable
- [ ] `do GameManager.set_flag()` mutations fire flags on read
- [ ] All .dialogue files parse without errors in Godot editor

**Ref:** `docs/addons/dialogue-plan.md`, `docs/rooms/*/dialogue.md` (20 files with complete text)

---

#### US-2.2: Create custom dialogue balloon with Victorian paper aesthetic

As a player,
I want documents and observations to appear on aged paper with serif text,
So that reading feels immersive and period-appropriate.

Acceptance Criteria:
- [ ] Custom balloon scene (`scenes/ui/document_balloon.tscn`) created
- [ ] Background color: PAPER_COLOR (#D1C1A6) with shadow
- [ ] Text color: PAPER_TEXT (#332619) in serif font
- [ ] Title centered, separated by decorative line
- [ ] Text appears with typewriter effect (character by character)
- [ ] Tap anywhere to dismiss
- [ ] Registered as default balloon in Dialogue Manager settings

---

#### US-2.3: Wire interaction_manager.gd to use Dialogue Manager instead of hardcoded strings

As a developer,
I want all document/observation display to flow through Dialogue Manager,
So that conditional text works automatically based on game state.

Acceptance Criteria:
- [ ] `_handle_document()` calls `DialogueManager.show_dialogue_balloon()` with room's .dialogue resource and interactable ID as title
- [ ] Room .dialogue resource loaded on `room_loaded` signal
- [ ] `_show(title, content)` method retained as fallback but Dialogue Manager is primary path
- [ ] All 97 interactables display correct text through Dialogue Manager
- [ ] Conditional variants verified: examine foyer_mirror before and after `elizabeth_aware`

---

#### US-2.4: Integrate gloot inventory system

As a player,
I want a visual inventory showing collected items,
So that I can track what I've found and what I still need.

Acceptance Criteria:
- [ ] `resources/item_prototypes.tres` ProtoTree created with all 10 items (5 keys, binding_book, doll, locket, blessed_water, confession)
- [ ] `Inventory` node added to GameManager autoload
- [ ] `GameManager.has_item()`, `give_item()`, `remove_item()` wrap gloot API
- [ ] Pause menu inventory label replaced with `CtrlInventory` grid display
- [ ] Items persist across room transitions
- [ ] Item acquisition shows "Acquired: {name}" notification

**Ref:** `docs/addons/inventory-plan.md`

---

#### US-2.5: Integrate AdaptiSound layered audio

As a player,
I want room ambience that responds to game phase with tension layers activating after entering the attic,
So that audio escalates the horror progression.

Acceptance Criteria:
- [ ] AdaptiSound configured as autoload (replaces audio_manager.gd)
- [ ] All 36 OGG loops mapped to room IDs
- [ ] Base ambient layer plays per room with crossfade on transition
- [ ] Tension layer activates when `elizabeth_aware` flag is set
- [ ] Reverb audio buses configured per room type (7 presets)
- [ ] Area3D reverb zones added to each room scene
- [ ] Crossfade works correctly when walking between rooms

**Ref:** `docs/addons/audio-plan.md`

---

#### US-2.6: Integrate surface-based footstep sounds

As a player,
I want my footsteps to sound different on marble, wood, stone, metal, and grass,
So that each surface feels distinct and grounded.

Acceptance Criteria:
- [ ] 36 footstep audio files sourced/created (9 surfaces x 4 variations)
- [ ] `MaterialFootstepPlayer3D` added to PlayerController
- [ ] Surface-to-sound mappings configured for all 9 surface types
- [ ] Floor meshes in all 20 room scenes tagged with `footstep_surface` metadata
- [ ] Walking across marble (foyer) sounds distinct from wood (parlor) from stone (basement) from metal (boiler)

**Ref:** `docs/addons/footsteps-plan.md`

---

### Phase 3: State Machine + Camera + Events

---

#### US-3.1: Implement LimboAI hierarchical state machine for game phases

As a developer,
I want a state machine that transitions Exploration → Discovery → Horror → Resolution,
So that the entire game atmosphere responds to narrative progress.

Acceptance Criteria:
- [ ] `scripts/game_state_machine.gd` created extending LimboHSM (< 200 LOC)
- [ ] 4 states: Phase_Exploration, Phase_Discovery, Phase_Horror, Phase_Resolution
- [ ] `GameManager.flag_set` signal dispatches events to HSM
- [ ] `found_first_clue` → Exploration → Discovery transition
- [ ] `entered_attic` → any → Horror transition
- [ ] `knows_full_truth` → Horror → Resolution transition
- [ ] State changes connected to AdaptiSound layer activation
- [ ] State changes connected to lighting parameter adjustments

**Ref:** `docs/addons/state-machine-plan.md`

---

#### US-3.2: Implement Elizabeth presence sub-HSM

As a player,
I want Elizabeth's supernatural presence to escalate from absent to confrontation,
So that the horror builds gradually through observable phenomena.

Acceptance Criteria:
- [ ] Elizabeth sub-HSM nested in Phase_Horror/Phase_Resolution
- [ ] 4 states: Dormant → Watching → Active → Confrontation
- [ ] Watching: mirrors delay slightly, occasional peripheral shadow
- [ ] Active: lights flicker, whispers audible, mirror shows her briefly
- [ ] Confrontation: "You found me" text, direct encounters
- [ ] Transitions driven by flags: `elizabeth_aware`, `entered_attic`, `found_hidden_chamber`

---

#### US-3.3: Integrate Phantom Camera for document inspection

As a player,
I want the camera to smoothly zoom toward paintings and documents when I examine them,
So that reading feels like approaching the object, not opening an overlay.

Acceptance Criteria:
- [ ] PhantomCameraHost added to PlayerController
- [ ] ExplorationCam PhantomCamera3D (priority 10) follows player
- [ ] Inspection PhantomCamera3D nodes placed in 9 key rooms (per phantom-camera-plan.md)
- [ ] Interacting with key objects sets inspection camera priority to 20 → smooth transition
- [ ] Dismissing document resets priority to 0 → camera returns
- [ ] Room reveal cameras for foyer, attic_storage, hidden_chamber

**Ref:** `docs/addons/phantom-camera-plan.md`

---

#### US-3.4: Integrate shaky-camera-3d for horror moments

As a player,
I want subtle camera shake on Elizabeth events and discoveries,
So that horror moments have physical impact.

Acceptance Criteria:
- [ ] ShakyCamera3D integrated with player camera
- [ ] Walking head bob: trauma 0.02, continuous
- [ ] First clue discovery: trauma 0.15, 0.3s
- [ ] Enter attic: trauma 0.1, 2s
- [ ] Mirror Elizabeth event: trauma 0.3, 0.5s
- [ ] Ritual completion: trauma 0.5 → 0.0, 2s
- [ ] NO shake during normal exploration or document reading

**Ref:** `docs/addons/camera-fx-plan.md`

---

#### US-3.5: Implement flashback system

As a player,
I want to see brief visions of past events using horror character models,
So that the story comes alive through visual memory flashes.

Acceptance Criteria:
- [ ] Flashback function: psx_fade dither → spawn horror model → text → despawn → return
- [ ] Parlor flashback: bloodwraith (child-scale, seated) — "She used to sit here"
- [ ] Master bedroom flashback: plague_doctor behind bed — "The occultist promised it would stop"
- [ ] Library flashback: plague_doctor at desk — "The occultist read the words aloud"
- [ ] Foyer flashback: bloodwraith in center — "You see her. Standing. Looking up at the chandelier"
- [ ] Dining room flashback: light surge — "All eight, seated"
- [ ] Family crypt flashback: Lady kneeling — "Victoria came here every night"
- [ ] All flashbacks are one-time events (flag prevents re-trigger)
- [ ] Camera shake accompanies each flashback

**Ref:** `docs/MASTER_SCRIPT.md` (horror character model assignments + per-room flashbacks)

---

#### US-3.6: Implement room entry events and ambient timed events

As a player,
I want rooms to have first-entry observations, ambient sounds, and timed conditional events,
So that each room feels alive and responsive.

Acceptance Criteria:
- [ ] Every room sets `visited_{room_id}` flag on first entry
- [ ] Every room shows room name on entry (via UIOverlay)
- [ ] Front gate: gate creak every 15-30s, wind gust every 20-40s
- [ ] Kitchen: water drip every 8-15s
- [ ] Boiler room: pipe whisper after 30s if `elizabeth_aware`
- [ ] Wine cellar: torch gutter after 60s if `elizabeth_aware`
- [ ] Hallway: child crying near attic door if `elizabeth_aware`
- [ ] Hallway: attic door rattle after 30s if `knows_attic_locked` and no key

**Ref:** `docs/rooms/*/triggers.md` (20 files)

---

### Phase 4: Save System + Quest Tracking + Polish

---

#### US-4.1: Integrate SaveMadeEasy replacing JSON save

As a player,
I want my game to save and load reliably with encryption,
So that progress persists across sessions.

Acceptance Criteria:
- [ ] GameManager.save_game()/load_game() replaced with SaveMadeEasy API
- [ ] Save data includes: current_room, inventory, flags, visited_rooms, interacted_objects, lights_toggled, quest states, HSM state
- [ ] Auto-save triggers on room transitions
- [ ] Manual save available in pause menu
- [ ] Load game restores complete state including player position and room
- [ ] Save file encrypted and device-bound

**Ref:** `docs/addons/save-plan.md`

---

#### US-4.2: Integrate quest-system for puzzle progress tracking

As a player,
I want to see my puzzle progress in the pause menu,
So that I know what I've solved and what remains.

Acceptance Criteria:
- [ ] 6 Quest resources created for each puzzle chain
- [ ] Quests start when player discovers the puzzle (locked door, locked box, etc.)
- [ ] Quests complete when completion flag is set
- [ ] Quest progress visible in pause menu
- [ ] Quest completion triggers "Puzzle Solved" notification

**Ref:** `docs/addons/quest-plan.md`

---

#### US-4.3: Decompose ui_overlay.gd (currently 569 LOC)

As a developer,
I want the UI code split into focused scripts under 200 LOC each,
So that the codebase meets STANDARDS.md.

Acceptance Criteria:
- [ ] `ui_overlay.gd` split into: `ui_landing.gd`, `ui_document.gd`, `ui_pause.gd`, `ui_ending.gd`, `ui_room_name.gd`
- [ ] Each script < 200 LOC
- [ ] All UI functionality preserved
- [ ] Pause menu includes gloot inventory display and quest progress

---

#### US-4.4: PSX dither fade for room transitions

As a player,
I want room transitions to use authentic PSX dither fades instead of linear alpha,
So that transitions match the retro aesthetic.

Acceptance Criteria:
- [ ] `room_manager.gd` fade system uses `psx_fade.gdshader` alpha uniform
- [ ] Tween animates shader `alpha` parameter 0→255→0
- [ ] Door transitions: 0.6s fade
- [ ] Stairs transitions: 0.8s fade
- [ ] Ladder transitions: 1.0s fade
- [ ] Path transitions: 0.5s fade
- [ ] Dither pattern visible during fade (not smooth gradient)

---

### Phase 5: Testing + Visual QA + Android Build

---

#### US-5.1: All rooms pass structural spec test

As a developer,
I want `test_room_specs.gd` to pass with 0 failures,
So that every room has its documented interactables, connections, and lighting.

Acceptance Criteria:
- [ ] `godot --headless --script test/e2e/test_room_specs.gd` exits with code 0
- [ ] All 20 rooms load successfully
- [ ] All ~97 interactables found by ID
- [ ] All ~34 connections found by target
- [ ] All rooms have minimum light count met
- [ ] All rooms with flickering have at least one `metadata/flickering = true` light

---

#### US-5.2: Full click-through walkthrough with screenshot capture

As a developer,
I want `test_room_walkthrough.gd` to visit every room and interact with every object,
So that visual screenshots can be reviewed for quality.

Acceptance Criteria:
- [ ] `godot --headless --script test/e2e/test_room_walkthrough.gd` exits with code 0
- [ ] All 97 interactables found and interacted with (0 MISS)
- [ ] Screenshots saved to `user://screenshots/walkthrough/`
- [ ] Each room has overview + 4 direction shots + per-interactable shots
- [ ] Visual QA review of screenshots confirms no missing geometry, no broken lighting, no floating objects

---

#### US-5.3: All 3 endings completable via E2E test

As a developer,
I want `run_e2e.gd` to complete all 3 endings successfully,
So that the full game flow is verified end-to-end.

Acceptance Criteria:
- [ ] Freedom ending: all 6 ritual components collected → counter-ritual → `freed_elizabeth`
- [ ] Escape ending: `knows_full_truth` + exit to front gate → escape triggered
- [ ] Joined ending: `elizabeth_aware` + !`knows_full_truth` + exit → joined triggered
- [ ] Save/load test: save mid-game, new game, load, verify state restored
- [ ] `godot --headless --script test/e2e/run_e2e.gd` exits with code 0

---

#### US-5.4: Android APK export

As a player,
I want to play Ashworth Manor on an Android device,
So that the game reaches its target platform.

Acceptance Criteria:
- [ ] `export_presets.cfg` configured with Android target
- [ ] ETC2/ASTC texture compression enabled
- [ ] Touch controls working (tap-to-walk, swipe-to-look, tap-to-interact)
- [ ] APK builds without errors
- [ ] APK installs and runs on Android emulator
- [ ] Maestro E2E flows pass on emulator

---

## Implementation Plan

| Phase | Stories | Dependencies | Est. Scope |
|-------|---------|-------------|------------|
| **1: Foundation** | US-1.1 through US-1.18 | None | Shader cleanup, addon install, rebuild all 20 room scenes |
| **2: Dialogue + Inventory + Audio** | US-2.1 through US-2.6 | Phase 1 complete | 20 .dialogue files, inventory integration, audio layers, footsteps |
| **3: State Machine + Camera + Events** | US-3.1 through US-3.6 | Phase 2 complete | HSM, Phantom Camera, flashbacks, room events |
| **4: Save + Quest + Polish** | US-4.1 through US-4.4 | Phase 3 complete | SaveMadeEasy, quest tracking, UI decomposition, PSX transitions |
| **5: Testing + Visual QA + Android** | US-5.1 through US-5.4 | Phase 4 complete | All tests pass, screenshot review, APK export |

---

## Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|------------|
| LimboAI GDExtension incompatible with Godot 4.6.2 | State machine unavailable | Low | Fallback: implement simple HSM in GDScript (< 200 LOC) |
| Phantom Camera conflicts with existing player camera | Camera system broken | Medium | Test in isolation first. Fallback: manual tween camera positions |
| AdaptiSound autoload conflicts with existing audio_manager | Audio broken | Medium | Migrate incrementally: keep audio_manager as wrapper, delegate to AdaptiSound |
| 36 footstep audio files unavailable | No surface sounds | Low | Use asset library search (assets-mcp) or generate with Blender audio tools |
| Room .tscn rebuild breaks existing gameplay | Regression | Medium | Run `run_e2e.gd` after each room rebuild. Git commit per room. |
| ui_overlay.gd decomposition breaks UI | Landing/pause/ending broken | Medium | Decompose one panel at a time, test each |

---

## Success Criteria

1. **Zero test failures:** All 3 test scripts exit code 0
2. **97 interactables functional:** Every documented interactable responds to interaction
3. **3 endings completable:** Full playthrough to each ending verified
4. **Visual quality:** Screenshot review confirms atmosphere matches ART_DIRECTION.md
5. **Audio progression:** Tension layer audibly activates after attic entry
6. **Save/load round-trip:** Save anywhere, load restores exact state
7. **Android playable:** APK runs on emulator with touch controls
