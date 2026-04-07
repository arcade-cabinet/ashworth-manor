# Ashworth Engine Specification

A data-driven game engine for first-person PSX horror exploration games. Inspired by SCUMM (1987), Myst (1993), and godot-procedural3d. One declaration defines everything — rooms, puzzles, items, dialogue, audio, triggers. The engine interprets declarations and generates scenes, tests, and gameplay at runtime.

---

## Design Principles

1. **Declaration is the single source of truth.** Every room, puzzle, item, and connection is declared once in a structured format. Scenes, tests, dialogue, and audio mappings are all derived from declarations.

2. **Myst interaction model.** One tap. The object decides what happens. No verb menus. Player taps an interactable → the interactable's declaration defines the response based on current game state.

3. **SCUMM cause-and-effect.** An action in Room 1 can trigger a consequence in Room 17. The declaration explicitly maps causes to effects across rooms, not just within them.

4. **Rich state, not boolean flags.** State variables hold values (strings, numbers, lists), not just true/false. `pillars = "off,on,off,off,on,on,off,off"` not `pillar_2_on = true, pillar_5_on = true`.

5. **PRNG variation.** Puzzle LOGIC is fixed. Puzzle PLACEMENT is variable. A seed determines which key is in which room. Same graph, different solve path per playthrough.

6. **Rooms are authoring units, compiled worlds are runtime units.** Walls, floors, ceilings, thresholds, props, and atmosphere are generated from declarations, but runtime traversal should happen inside graph-aware compiled worlds rather than hard room-to-room swaps by default.

7. **Scene grammar is explicit.** Every authored room is understood as:
   - the room shell itself
   - always-present static models
   - dynamic/stateful setpieces that may change model, inventory output, or traversal state
   - local self-contained puzzles
   - cross-room diamond weaving that connects A/B/C cause-and-effect chains

8. **Spatial grammar is explicit.** The engine must distinguish exterior grounds, enclosed interiors, glazed rooms, threshold rooms, and service spaces, because shell composition, outlook treatment, and window behavior are different in each case.

9. **Stateful visuals should bias procedural or hybrid.** If a setpiece visibly changes state, the changing part should usually be procedural, shader-driven, or state-swapped inside an authored scene, while static silhouette and ornament can stay model-driven.

10. **The camera must behave like a body.** Entry framing, inspection focus, and pickup beats should bias toward live first-person yaw/pitch/FOV/lean adjustments rather than disembodied cut cameras. Structural awareness matters: walls, columns, door frames, and banisters must not dominate the center view unless that crowding is intentional.

11. **Investigation is locomotion-first.** Suspicious walls, floors, ceilings, and thresholds should be investigable by walking the player into a plausible look posture before resolving whether the surface matters. Puzzle discovery should feel like embodied scrutiny, not menu-driven guessing.

---

## File Structure

```
ashworth/
├── declarations/
│   ├── world.tres          # Top-level: room graph, phases, PRNG config
│   ├── rooms/
│   │   ├── foyer.tres      # Room geometry + interactables + connections + audio + triggers
│   │   ├── parlor.tres
│   │   └── ... (20 rooms)
│   ├── puzzles/
│   │   ├── attic_key.tres  # Puzzle definition: steps, clues, completion, PRNG variation points
│   │   └── ... (6 puzzles)
│   ├── items/
│   │   ├── attic_key.tres  # Item definition: name, category, location, unlock target
│   │   └── ... (11 items)
│   ├── endings/
│   │   ├── freedom.tres
│   │   ├── escape.tres
│   │   └── joined.tres
│   └── state_schema.tres   # All state variables: name, type, initial value, what sets them, what reads them
│
├── engine/
│   ├── room_assembler.gd   # Reads room declaration → generates local room subtree inside a world
│   ├── graph_compiler.gd   # Validates topology, compiled-world coverage, and threshold integrity
│   ├── region_compiler.gd  # Compiles authoring regions into runtime world plans
│   ├── state_machine.gd    # Reads world declaration → manages game phases + Elizabeth
│   ├── interaction_engine.gd  # Reads interactable declarations → dispatches tap responses
│   ├── puzzle_engine.gd    # Reads puzzle declarations → tracks progress, validates chains
│   ├── audio_engine.gd     # Reads room audio config ��� manages layers, SFX, footsteps
│   ├── trigger_engine.gd   # Reads room triggers → runs entry/exit/timed/conditional events
│   ├── test_generator.gd   # Reads declarations → generates test expectations
│   └── prng_engine.gd      # Reads PRNG variation points → shuffles item/clue placements
│
├── builders/
│   ├── wall_builder.gd     # Procedural textured wall shell with inset openings
│   ├── floor_builder.gd    # Procedural textured floor tiling
│   ├── ceiling_builder.gd  # Procedural textured ceiling tiling
│   ├── door_builder.gd     # Procedural door panel + inset trim/frame model
│   ├── window_builder.gd   # Procedural pane/opening + inset trim/frame model
│   ├── stairs_builder.gd   # Procedural stair mass + trim/newel detail
│   ├── trapdoor_builder.gd # Procedural hatch + frame assembly
│   └── ladder_builder.gd   # Procedural climbable / deployable ladder assembly
│
└── assets/
    ├── textures/            # All standalone PNGs (walls, floors, ceilings, doors, windows)
    ├── audio/               # All audio files (loops, tension, SFX, footsteps, music box)
    ├── models/              # GLB models for furniture, props, horror figures
    └── fonts/               # TTF fonts
```

---

## Runtime World Model

The engine now distinguishes between:

- `RoomDeclaration`: local authored space, shell, props, interactables, anchors
- `RegionDecl`: authoring grouping for neighboring rooms
- `compiled_world_id`: the runtime traversal world a region belongs to

Current interim runtime worlds:

- `entrance_path_world`
- `manor_interior_world`
- `rear_grounds_world`
- `service_basement_world`

Target shipped world model:

- `estate_grounds_world`
- `manor_interior_world`
- `service_basement_world`

The shipped goal is that the grounds stop behaving like two disconnected
outside maps and instead become one coherent wraparound estate with staged
front, side, and rear access.

Default transition policy:

- same-world `door`, `gate`, `path` => seamless
- same-world `stairs`, `ladder`, `trapdoor` => embodied
- inter-world traversal => soft transition unless explicitly overridden

Target grounds authoring beats:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`
- `west_side_path`
- `east_side_path`
- `rear_court`
- `garden`
- `greenhouse`
- `carriage_house`
- `pond_edge`
- `woodland_path`
- `chapel`
- `family_crypt`

## Declaration Format

All declarations use Godot Resource files (`.tres`) with custom `Resource` script classes. This means they're editable in the Godot inspector, serializable, and loadable at runtime.

### World Declaration (`world.tres`)

The top-level game definition. Everything the game IS lives here or is referenced from here.

```gdscript
class_name WorldDeclaration
extends Resource

# === Game start ===
@export var starting_room: String = "front_gate"
@export var starting_position: Vector3 = Vector3(0, 0, -8)
@export var starting_rotation_y: float = 180.0

# === Room registry — validated bidirectional connectivity ===
@export var rooms: Array[RoomRef] = []
@export var connections: Array[Connection] = []
@export var secret_passages: Array[SecretPassageDecl] = []
@export var regions: Array[RegionDecl] = []

# === Environments — per-area presets, rooms reference by name ===
@export var area_environments: Dictionary = {}

# === WEAVE SYSTEM — Three-layer narrative threading ===

# Macro threads — 3 emotional perspectives on the same story
@export var macro_threads: Array[MacroThread] = []

# Junctions — where the needle picks A or B (diamonds and swaps)
@export var junctions: Array[JunctionDecl] = []

# PRNG seed — 0 = random each playthrough. Determines macro thread + junction resolution
@export var prng_seed: int = 0

# === Game phases (HSM) ===
@export var phases: Array[PhaseDecl] = []
@export var phase_transitions: Array[PhaseTransition] = []

# === Elizabeth presence sub-HSM ===
@export var elizabeth_states: Array[ElizabethStateDecl] = []
@export var elizabeth_transitions: Array[ElizabethTransition] = []

# === Global triggers — fire on state conditions regardless of current room ===
@export var global_triggers: Array[GlobalTrigger] = []

# === Endings — 3 positive (per macro thread) + 2 negative (shared) ===
@export var endings: Array[EndingDecl] = []

# === Player config ===
@export var player: PlayerDeclaration = null

# === Accessibility ===
@export var accessibility: AccessibilityDecl = null
```

### MacroThread — The emotional perspective

```gdscript
class_name MacroThread
extends Resource

@export var thread_id: String = ""           # "captive", "mourning", "sovereign"
@export var question: String = ""            # "How do I free her?"
@export var elizabeth_nature: String = ""    # "trapped spirit", "grieving soul", "being of power"
@export var house_nature: String = ""        # "cage", "memorial", "instrument"
@export var ending_id: String = ""           # Which positive ending this resolves to

# Key text overrides — these core narrative texts change per macro thread
@export var diary_page_text: String = ""
@export var elizabeth_letter_text: String = ""
@export var elizabeth_final_note_text: String = ""
@export var ritual_sequence_texts: PackedStringArray = []
```

### JunctionDecl — Where the needle passes through

```gdscript
class_name JunctionDecl
extends Resource

@export var junction_id: String = ""
@export var junction_type: String = ""       # "diamond" (cross-room paths) or "swap" (within-room puzzle)
@export var functional_slot: String = ""     # What both variants produce ("attic_access_key")

@export var variant_a: VariantDecl = null
@export var variant_b: VariantDecl = null

# Macro threads suggest which variant maintains emotional coherence
# PRNG can still flip for variety on subsequent playthroughs of same macro thread
@export var macro_preference: Dictionary = {} # {"captive": "A", "mourning": "B", "sovereign": "A"}
```

### VariantDecl — One side of a junction

```gdscript
class_name VariantDecl
extends Resource

@export var room_id: String = ""                         # Room where this variant lives
@export var interactables_active: PackedStringArray = []  # IDs that become interactive
@export var interactables_static: PackedStringArray = []  # IDs that become inert props
@export var puzzle_steps: Array[PuzzleStepDecl] = []     # The puzzle chain
@export var clue_overrides: Dictionary = {}               # {interactable_id: "clue text for this variant"}
```

---

## Scene Grammar

Ashworth Manor room authoring is not just "a list of props and interactables." It uses five layers that need to stay distinct in docs, declarations, and runtime behavior.

### 1. Room Shell

The room itself:

- dimensions
- wall segmentation
- floor / ceiling / wall textures
- threshold surfaces
- entry anchors
- focal anchors
- lighting volume and atmosphere

This is the stable container.

### 2. Static Scene Models

Always-present dressing and architecture:

- table
- chairs
- bookcase
- bed
- fireplace surround
- moulding / trim / newel / banister details

These are declared as `PropDecl` and should be thought of as **scene grammar**, not puzzle state.

### 3. Dynamic / Stateful Setpieces

Objects that can change state, visuals, traversal meaning, or inventory behavior:

- teapot empty vs filled
- lamp lit vs extinguished
- painting closed vs secret passage revealed
- trapdoor sealed vs lowered
- ladder stowed vs unfolded

These are declared as `InteractableDecl`. Their logic may be local, but they are allowed to:

- swap between named visual states
- emit inventory items
- mutate world state
- unlock or reveal thresholds
- become inert dressing on one diamond branch and active on another

### 4. Self-Contained Room Puzzles

A local problem entirely understandable inside one room or one immediate setpiece cluster.

Examples:

- unlock the bookcase to reveal a secret passage
- combine a key and a lock in the same room
- heat, pour, or fill a vessel to change its state

These are usually authored as `PuzzleDeclaration` plus room-local interactables and triggers.

### 5. Diamond Weave Logic

Cross-room cause/effect weaving at different scales:

- **macro**: the emotional thread (`captive`, `mourning`, `sovereign`)
- **meso**: the diamond branch itself, where A/B variants satisfy the same functional slot in different ways
- **micro**: local trigger and state edges inside a room/setpiece

The intended pattern is:

- `A` side in one room creates a usable state or item
- `B` side in another room creates a different but functionally equivalent state or item
- `C` side consumes the functional role and advances the story

So for a tea-service example:

- the table and chairs are static models
- the teapot is a dynamic setpiece
- "filled" vs "empty" is its visual/stateful layer
- pouring into cups is a local micro interaction chain
- using "a vessel with liquid" elsewhere is the meso diamond payoff
- the currently selected macro thread changes emotional interpretation, not the object grammar

This distinction should hold everywhere in the mansion and grounds.

### RoomRef

```gdscript
class_name RoomRef
extends Resource

@export var room_id: String = ""
@export var declaration_path: String = ""     # res://declarations/rooms/foyer.tres
```

### SecretPassageDecl

Hidden or service-side routing that preserves puzzle order while keeping the estate historically and dramatically coherent.

```gdscript
class_name SecretPassageDecl
extends Resource

@export var passage_id: String = ""
@export var from_room: String = ""
@export var to_room: String = ""

@export var anchor_from: PassageAnchorDecl = null
@export var anchor_to: PassageAnchorDecl = null

@export var discovery_mode: String = "hidden_interactable"
@export var reveal_condition: String = ""
@export var initially_known: bool = false
@export var presentation: PassagePresentationDecl = null

@export var traversal_type: String = "crawl" # crawl, door, panel, stair, ladder, tunnel
@export var functional_role: String = ""     # service_route, family_route, occult_route, escape_route

@export var one_way_until_revealed: bool = false
@export var once_open_always_open: bool = true
@export var locked: bool = false
@export var key_id: String = ""
```

### PassageAnchorDecl

One end of a secret passage in exact room-local 3D space.

```gdscript
class_name PassageAnchorDecl
extends Resource

@export var room_id: String = ""
@export var local_position: Vector3 = Vector3.ZERO
@export var local_rotation_y: float = 0.0
@export var surface_type: String = ""
@export var bounds_size: Vector3 = Vector3(1.0, 2.0, 0.3)
@export var entry_offset: Vector3 = Vector3.ZERO
@export var spawn_position: Vector3 = Vector3.ZERO
@export var spawn_rotation_y: float = 0.0
```

### PassagePresentationDecl

How the player perceives the passage before and after discovery.

```gdscript
class_name PassagePresentationDecl
extends Resource

@export var visible_form: String = ""
@export var model_path: String = ""

@export var closed_text: String = ""
@export var discovered_text: String = ""
@export var opened_text: String = ""

@export var discovery_feedback: PackedStringArray = []
@export var fx_on_reveal: Dictionary = {}

@export var sfx_reveal: String = ""
@export var sfx_open: String = ""
```

### Secret Passage Validation Rules

Secret passages are not generic hidden doors. They must satisfy all of the following:

- both `from_room` and `to_room` must exist in `world.rooms`
- `anchor_from.room_id` must match `from_room`
- `anchor_to.room_id` must match `to_room`
- anchor bounds and spawn positions must be present for both ends
- if `locked == true`, `key_id` must be non-empty
- if `one_way_until_revealed == true`, the runtime must track reveal state explicitly
- secret passages must not bypass required diamond functional slots unless the bypass is itself gated by the same dependency chain

Recommended first use:

- service-side route between the mansion service layer and `carriage_house`

### PlayerDeclaration (GAP #3 fixed)

```gdscript
class_name PlayerDeclaration
extends Resource

@export var camera_fov: float = 70.0
@export var camera_height: float = 1.7
@export var pitch_limit: float = 45.0
@export var move_speed: float = 3.0
@export var stop_distance: float = 0.3
@export var touch_sensitivity: float = 0.003
@export var tap_threshold: float = 15.0      # Pixels — distinguishes tap from drag
@export var tap_time_threshold: float = 0.3  # Seconds
```

### GlobalTrigger (GAP #5 fixed)

Cross-room events that fire when a state condition becomes true, regardless of which room the player is in.

```gdscript
class_name GlobalTrigger
extends Resource

@export var trigger_id: String = ""
@export var condition: String = ""           # State expression — evaluated on EVERY state change
@export var once: bool = true
@export var actions: Array[ActionDecl] = []
```

Example — "all clocks chime":
```
trigger_id: "all_clocks_chime"
condition: "examined_foyer_clock AND examined_boiler_clock"
actions: [{play_sfx: "sfx/horror/horror_stinger_01.ogg"}, {show_text: "All the clocks chime once. 3:33."}]
```

### ElizabethStateDecl (GAP #6 fixed)

```gdscript
class_name ElizabethStateDecl
extends Resource

@export var state_id: String = ""            # "dormant", "watching", "active", "confrontation"
@export var shadow_frequency: float = 0.0    # Periodic screen darken (0 = none)
@export var flicker_multiplier: float = 1.0  # Applied to all flickering lights
@export var whisper_sfx_interval: float = 0.0 # Seconds between whisper SFX (0 = none)
@export var whisper_sfx: String = ""
@export var mirror_delay: float = 0.0        # Seconds of reflection delay on mirror-type interactables
@export var affected_types: PackedStringArray = [] # Which interactable types are affected (mirror, music_box)
```

### ElizabethTransition

```gdscript
class_name ElizabethTransition
extends Resource

@export var from_state: String = ""
@export var to_state: String = ""
@export var trigger_condition: String = ""   # State expression
```

### AccessibilityDecl (GAP #15 fixed)

```gdscript
class_name AccessibilityDecl
extends Resource

@export var base_font_size: int = 16
@export var font_scale: float = 1.0
@export var camera_shake_enabled: bool = true
@export var camera_shake_scale: float = 1.0
@export var subtitle_mode: bool = true       # Show text captions for audio-only narrative events
@export var high_contrast_mode: bool = false
```

### Room Declaration (`rooms/foyer.tres`)

```gdscript
class_name RoomDeclaration
extends Resource

# Identity
@export var room_id: String = ""
@export var room_name: String = ""
@export var floor_name: String = ""          # "ground_floor", "upper_floor", etc

# Environment — references a key in WorldDeclaration.area_environments (GAP #2 fixed)
@export var environment_preset: String = ""  # "grounds", "ground_floor", "upper_floor", "basement", "deep_basement", "attic"

# Geometry
@export var dimensions: Vector3 = Vector3(12, 4.8, 10) # width, height, depth
@export var is_exterior: bool = false

# Textures (256x256 standalone PNGs)
@export var wall_texture: String = "wall0_texture"
@export var floor_texture: String = "floor0_texture"
@export var ceiling_texture: String = "ceiling0_texture"

# Wall layout — per side, what goes in each 2m segment
# Each segment: "wall" | "doorway:{connection_id}" | "window" | "window_boarded" | "window_shuttered"
# Connection ID convention: "{from_room}_to_{to_room}" (GAP #4 fixed)
@export var wall_north: PackedStringArray = []
@export var wall_south: PackedStringArray = []
@export var wall_east: PackedStringArray = []
@export var wall_west: PackedStringArray = []

# Audio
@export var ambient_loop: String = ""        # Path relative to audio/loops/
@export var tension_loop: String = ""        # Path relative to audio/tension/
@export var reverb_bus: String = "Room"       # Audio bus name
@export var footstep_surface: String = "wood_parquet"

# Spawn (used when entering this room from a connection that doesn't specify position_in_to)
@export var spawn_position: Vector3 = Vector3.ZERO
@export var spawn_rotation_y: float = 0.0

# Interactables — declared inline, not separate files
@export var interactables: Array[InteractableDecl] = []

# Lighting
@export var lights: Array[LightDecl] = []

# Props (non-interactive models)
@export var props: Array[PropDecl] = []

# Triggers
@export var on_entry: Array[TriggerDecl] = []
@export var on_exit: Array[TriggerDecl] = []
@export var ambient_events: Array[AmbientEventDecl] = []
@export var conditional_events: Array[ConditionalEventDecl] = []
@export var flashbacks: Array[FlashbackDecl] = []
```

### Interactable Declaration (inline in Room)

```gdscript
class_name InteractableDecl
extends Resource

@export var id: String = ""
@export var type: String = ""                # painting, note, mirror, clock, switch, box, doll, ritual, observation, photo
@export var position: Vector3 = Vector3.ZERO
@export var wall: String = ""                # "north", "south", "east", "west" — for wall-mounted objects
@export var collision_size: Vector3 = Vector3(1.5, 1.5, 1.5)

# Thread visibility — which macro threads make this interactable active
# Empty = always active (on all threads). "captive" = only on captive thread.
# "captive,mourning" = on both captive and mourning. Sovereign sees it as static.
@export var thread_active: PackedStringArray = []

# Thread-specific response overrides (keyed by macro thread_id)
# When present, REPLACES the default responses array for that thread
@export var thread_responses: Dictionary = {} # {"captive": [ResponseDecl...], "mourning": [...]}

# Visual
@export var model: String = ""               # GLB path for 3D model, empty for text-only
@export var texture: String = ""             # For procedural visual (door/window texture)

# Visual effects — per-phase rendering changes (GAP #13 fixed)
# Interpreted by room_assembler to set shader params or animation properties
@export var visual_effects: Dictionary = {}  # {"mirror_delay": 0.3, "emission_glow": 0.5}

# === Simple interaction: single response set ===
# Ordered by priority (first matching condition wins)
@export var responses: Array[ResponseDecl] = []

# === Progressive interaction: multi-step sequences (GAP #7 fixed) ===
# When true, the interactable advances through steps on each interaction
@export var progressive: bool = false
@export var progression_steps: Array[ProgressionStep] = []
@export var fallback_response: ResponseDecl = null  # Shown when no step's conditions are met (GAP #11 fixed)

# Lock (GAP #10 fixed — split into no-key and wrong-key responses)
@export var locked: bool = false
@export var key_id: String = ""
@export var locked_response_no_key: String = "It's locked. You need a key."
@export var locked_response_wrong_key: String = "This key doesn't fit."

# Item given on interaction
@export var gives_item: String = ""
@export var gives_item_condition: String = ""
@export var also_gives: String = ""

# Switch behavior
@export var controls_light: String = ""

# Connection behavior (for locked_door type)
@export var target_room: String = ""
```

### ProgressionStep (GAP #7 — multi-step interactions)

For interactables that change behavior on each interaction (doll: examine → extract key → pick up, ritual circle: 3-step sequence).

```gdscript
class_name ProgressionStep
extends Resource

@export var step_id: String = ""
@export var required_state: String = ""      # State expression — must be true to reach this step
@export var required_items: PackedStringArray = []
@export var response: ResponseDecl = null    # Text + effects for this step
@export var consume_items: PackedStringArray = [] # Items consumed at this step (e.g., blessed_water)
```

The interaction_engine tracks progression via state variable `{interactable_id}_step` (auto-incremented). Each step's `required_state` is checked IN ADDITION to the step counter.

### Response Declaration (conditional text + effects)

```gdscript
class_name ResponseDecl
extends Resource

# Condition — state expression evaluated at interaction time
# Empty string = default (always matches if no higher-priority response matched)
# Examples: "knows_full_truth", "elizabeth_aware AND entered_attic", "NOT read_diary"
@export var condition: String = ""

# Content — supports PRNG interpolation (GAP #8 fixed)
# Text can contain {prng:variable_name} placeholders resolved at display time
# Example: "The key is hidden in {prng:attic_key_location_hint}."
@export var title: String = ""
@export var text: String = ""

# State mutations — executed when this response is shown
@export var set_state: Dictionary = {}       # {variable_name: value}

# Optional per-response rewards/effects
@export var gives_item: String = ""
@export var gives_item_condition: String = ""
@export var also_gives: String = ""

# SFX
@export var play_sfx: String = ""

# Accessibility: subtitle for audio-only narrative events (GAP #16 fixed)
@export var subtitle_text: String = ""       # Shown if AccessibilityDecl.subtitle_mode is on
```

### State Schema (`state_schema.tres`)

```gdscript
class_name StateSchema
extends Resource

# Every state variable in the game — declared once, validated everywhere
@export var variables: Array[StateVarDecl] = []
```

```gdscript
class_name StateVarDecl
extends Resource

@export var name: String = ""
@export var type: String = "bool"            # bool, int, string, list
@export var initial_value: String = "false"  # Serialized initial value
@export var description: String = ""         # What this variable means
@export var set_by: PackedStringArray = []   # What interactables/triggers SET this
@export var read_by: PackedStringArray = []  # What responses/triggers READ this
@export var prng_eligible: bool = false      # Can PRNG shuffle what sets this?
```

### Puzzle Declaration (`puzzles/attic_key.tres`)

```gdscript
class_name PuzzleDeclaration
extends Resource

@export var puzzle_id: String = ""
@export var name: String = ""
@export var description: String = ""

# Steps — the logical chain. Order matters for display but not for completion
# unless sequential = true
@export var steps: Array[PuzzleStepDecl] = []
@export var sequential: bool = false

# Dependencies — other puzzles that must be complete first
@export var requires_puzzles: PackedStringArray = []

# Completion
@export var completion_state: String = ""    # State expression that means "puzzle solved"
@export var reward_states: Dictionary = {}   # State set on completion
@export var reward_items: PackedStringArray = []

# Clues — which interactables hint at this puzzle's solution
@export var clue_chain: Array[ClueDecl] = []

# PRNG variation — what can change per seed
@export var variation_points: Array[PuzzleVariation] = []
```

```gdscript
class_name PuzzleStepDecl
extends Resource

@export var step_id: String = ""
@export var description: String = ""         # Human-readable
@export var action: String = ""              # "interact", "use_item", "examine"
@export var target_interactable: String = "" # Interactable ID
@export var target_room: String = ""         # Room where this step occurs
@export var required_state: String = ""      # State expression
@export var required_items: PackedStringArray = []
@export var result_states: Dictionary = {}   # State set on step completion
@export var result_items: PackedStringArray = [] # Items given
```

```gdscript
class_name PuzzleVariation
extends Resource

# Example: the attic key is normally in the library globe.
# With PRNG, it could be in the carriage house portrait instead.
# The STEP remains "find attic key" but the LOCATION changes.

@export var what_varies: String = ""         # "item_location" | "clue_content" | "code_value"
@export var default_value: String = ""       # Normal placement
@export var alternatives: PackedStringArray = [] # Other valid placements
@export var constraint: String = ""          # "must_be_accessible_before:attic_door"

# PRNG text interpolation (GAP #8 fixed)
# When clue text references this placement via {prng:var_name}, the resolved
# text comes from this dictionary keyed by the selected alternative.
@export var prng_var_name: String = ""       # e.g., "attic_key_location_hint"
@export var text_variants: Dictionary = {}   # {"library_globe": "the library globe", "carriage_portrait": "behind the portrait in the carriage house"}
```

### Item Declaration (`items/attic_key.tres`)

```gdscript
class_name ItemDeclaration
extends Resource

@export var item_id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var category: String = ""            # key, document, artifact, ritual_component
@export var is_ritual_component: bool = false
@export var is_consumable: bool = false

# Functional slot — items sharing a slot are interchangeable for puzzle purposes
# e.g., "attic_access_key" — globe key and gear-puzzle key both fill this slot
@export var functional_slot: String = ""

# Thread visibility — which macro threads this item exists on
@export var thread_active: PackedStringArray = []  # Empty = all threads

# Where it's found (default — junction variants may redirect this)
@export var found_in_room: String = ""
@export var found_at_interactable: String = ""
@export var found_condition: String = ""

# What it unlocks — matches on functional_slot OR specific item_id
@export var unlocks_interactable: String = ""
@export var unlocks_in_room: String = ""
```

### Ending Declaration

```gdscript
class_name EndingDecl
extends Resource

@export var ending_id: String = ""
@export var trigger_condition: String = ""   # State expression
@export var trigger_room: String = ""        # Room where ending triggers (usually front_gate)
@export var text_sequence: PackedStringArray = [] # Lines shown in sequence
@export var timing: Array[float] = []        # Seconds between each line
@export var stinger_sfx: String = ""         # Music stinger path
```

### Light Declaration

```gdscript
class_name LightDecl
extends Resource

@export var id: String = ""
@export var type: String = "omni"            # omni, directional, spot
@export var position: Vector3 = Vector3.ZERO
@export var color: Color = Color(1, 0.9, 0.7)
@export var energy: float = 1.0
@export var range: float = 8.0
@export var shadows: bool = false
@export var flickering: bool = false
@export var flicker_pattern: String = ""     # "candle", "fire", "torch", "gas"
@export var switchable: bool = false
@export var switch_id: String = ""           # Interactable ID that controls this light
```

### Connection (in World)

```gdscript
class_name Connection
extends Resource

@export var id: String = ""                  # Unique connection ID
@export var from_room: String = ""
@export var to_room: String = ""
@export var direction: String = ""           # north/south/east/west/up/down
@export var type: String = "door"            # door, double_door, heavy_door, hidden_door, gate, stairs, trapdoor, ladder, path
@export var position_in_from: Vector3 = Vector3.ZERO  # Where the connection sits in the source room
@export var position_in_to: Vector3 = Vector3.ZERO    # Where player spawns in the target room
@export var spawn_rotation_y: float = 0.0

# Lock
@export var locked: bool = false
@export var key_id: String = ""

# Visual
@export var door_texture: String = ""        # From retro textures pack
@export var frame_texture: String = ""       # Frame material

# Audio
@export var open_sfx: String = ""
@export var close_sfx: String = ""
```

### Trigger Declarations

```gdscript
class_name TriggerDecl
extends Resource

@export var condition: String = ""           # State expression (empty = always)
@export var once: bool = true                # Only fire once? (tracked by trigger ID)
@export var trigger_id: String = ""          # For tracking "already fired"
@export var actions: Array[ActionDecl] = []
```

```gdscript
class_name ActionDecl
extends Resource

# One of these is set — the action type
@export var set_state: Dictionary = {}       # Set state variables
@export var play_sfx: String = ""            # Play sound effect
@export var show_text: String = ""           # Show observation text
@export var show_room_name: String = ""      # Flash room name
@export var camera_shake: float = 0.0        # Shake trauma amount
@export var light_change: Dictionary = {}    # {light_id: {energy: X, duration: Y}}
@export var spawn_model: Dictionary = {}     # {model: path, position: vec3, scale: float, duration: float}
@export var psx_fade: float = 0.0            # Dither fade amount (0-1)

# Accessibility: subtitle for narrative SFX (GAP #16 fixed)
@export var subtitle_text: String = ""       # Shown when subtitle_mode enabled (e.g., "[whisper] ...find me...")
```

---

## Engine Architecture

### Room Assembler (`engine/room_assembler.gd`)

The core. Reads a `RoomDeclaration` and builds a complete `Node3D` scene tree:

```
RoomDeclaration
    ↓ room_assembler.gd
    ↓
Node3D (room root, RoomBase script)
├── Geometry/
│   ├── Floor (floor_builder → tiled QuadMesh + collision)
│   ├── Ceiling (ceiling_builder → tiled QuadMesh)
│   ├── WallNorth (wall_builder → segments with doorway/window openings)
│   ├── WallSouth (wall_builder)
│   ├── WallEast (wall_builder)
│   ���── WallWest (wall_builder)
├── Doors/
│   ├── door_parlor (door_builder → frame + panel + hinge + AnimatableBody3D)
│   └── ...
├── Windows/
│   └── window_south (window_builder → frame + pane)
├── Lighting/
│   ├── Chandelier (OmniLight3D, from LightDecl)
│   └── ...
├── Interactables/
│   ├── foyer_painting (Area3D, from InteractableDecl)
│   └── ...
├── Connections/
│   ├── to_parlor (Area3D, from Connection)
│   └── ...
├── Props/
│   ├── Rug (MeshInstance3D from GLB)
│   └── ...
└── Audio/
    └── ReverbZone (Area3D with reverb bus)
```

### Interaction Engine (`engine/interaction_engine.gd`)

Replaces the current `interaction_manager.gd`. When player taps an interactable:

1. Look up the `InteractableDecl` by ID
2. Check if locked → check inventory for key → unlock or show locked_response
3. Iterate `responses` array → evaluate each `condition` against current state
4. First matching condition wins → show its text, execute its `set_state` mutations
5. Give items if applicable
6. Notify puzzle_engine of the interaction

No switch statements. No hardcoded object types. The declaration defines the behavior.

### Puzzle Engine (`engine/puzzle_engine.gd`)

Tracks puzzle progress from declarations:

1. On game start, load all `PuzzleDeclaration` resources
2. Apply PRNG to shuffle variation points
3. On each state change, check if any puzzle step completed
4. On puzzle completion, set reward states and notify UI
5. Validate puzzle dependency graph (no cycles, all prerequisites achievable)

### PRNG Engine (`engine/prng_engine.gd`)

At game start:

1. Generate or use provided seed
2. For each `PuzzleVariation`: select from alternatives
3. Patch the affected room declarations (move items, change clue text)
4. Log the seed + selections for debugging/reproducibility

Example: Attic key normally in library globe. PRNG selects carriage house portrait instead. The puzzle step "find attic key" now points to carriage_house:carriage_portrait. The library globe still exists but gives a different response ("The globe is empty.").

### Test Generator (`engine/test_generator.gd`)

Reads declarations and generates test expectations:

```gdscript
# For each room declaration:
# - Expected interactable IDs
# - Expected connection targets
# - Expected light count and flickering
# - Expected audio loop
# - Expected footstep surface

# For each puzzle declaration:
# - Expected flag chain (simulate all steps, verify completion state)
# - Expected item locations

# For each connection:
# - Bidirectional validation (if A→B exists, B→A must exist)

# For PRNG:
# - Run N seeds, verify all puzzles still solvable per dependency graph
```

---

## State Expression Language

Conditions and triggers use a simple expression language:

```
# Boolean checks
"found_first_clue"                    # Variable is truthy
"NOT knows_full_truth"                # Variable is falsy
"elizabeth_aware AND entered_attic"   # Both truthy
"read_diary OR read_cook_note"        # Either truthy

# Value checks
"discovery_count >= 3"                # Numeric comparison
"current_phase == horror"             # String equality
"pillars == off,on,off,off,on,on,off,off"  # List match

# Item checks
"HAS attic_key"                       # Player has item in inventory
"NOT HAS cellar_key"                  # Player doesn't have item

# Visit checks
"VISITED parlor"                      # Room has been entered
"NOT VISITED attic_storage"           # Room not yet entered
```

Evaluated by a simple parser in `engine/state_machine.gd`. No need for a full scripting language — conditions are declarative, not imperative.

---

## What This Gives Us

### Adding a door
Change the room declaration's `wall_north` from `"wall"` to `"doorway:to_hallway"`. Add a `Connection` in `world.tres`. The room assembler generates the door, the test generator expects it, the interaction engine handles it. Zero script changes.

### Adding an interactable
Add an `InteractableDecl` to the room's `interactables` array with responses. The room assembler places the Area3D, the interaction engine handles taps, the test generator expects it.

### Changing a puzzle
Edit the `PuzzleDeclaration`. Move an item to a different room. Change the clue text. The puzzle engine validates the chain, the PRNG engine knows the new variation space, tests auto-update.

### Changing a wall texture
Change `wall_texture` in the room declaration. The wall builder uses the new texture on next assembly. Every wall segment updates. One change, one place.

### Adding PRNG variation
Add a `PuzzleVariation` to the puzzle declaration listing alternative placements. The PRNG engine handles shuffling. The test generator validates all alternatives are solvable.

---

## Runtime Status

The declaration migration is no longer a future plan. The shipped runtime is declaration-driven:

1. `world.tres` is the canonical world graph
2. rooms are assembled from `RoomDeclaration` data
3. builders generate runtime geometry, connections, lights, props, and interactables
4. declaration-driven interactions, triggers, and conditional events are live
5. legacy `.tscn` room scenes are fallback/reference material, not the source of truth

Ongoing work should assume this architecture is already in force and should remove remaining split-brain references rather than planning another migration.

---

## LOC Considerations

The engine scripts will be larger than 200 LOC each. The `room_assembler.gd` especially. This is acceptable because:

1. **Engine code is infrastructure, not game content.** It's written once and handles ALL rooms. It doesn't change when you add a room or modify a puzzle.
2. **Builder scripts are focused.** `wall_builder.gd` does one thing: generate textured wall segments. It might be 150 LOC. `door_builder.gd` generates doors. Each builder is single-purpose.
3. **Declarations are zero LOC.** Room definitions are data (`.tres` files), not code. Adding 20 rooms adds 20 data files, not 20 scripts.
4. **The interaction engine replaces 3 scripts** (`interaction_manager.gd` + `puzzle_handler.gd` + scattered handlers). Net LOC decreases.

Proposed LOC budget:
- `room_assembler.gd`: 250-300 (core engine, justified)
- Each builder: 100-200
- `interaction_engine.gd`: 150-200
- `puzzle_engine.gd`: 150-200
- `state_machine.gd`: 100-150
- `audio_engine.gd`: 150-200
- `trigger_engine.gd`: 100-150
- `prng_engine.gd`: 80-120
- `test_generator.gd`: 150-200
- Resource classes: 20-50 each (just @export declarations)

Total engine: ~1500-2000 LOC for the runtime that replaces ~3000 LOC of hand-built scripts + eliminates all hand-built .tscn room files.

---

## Environment & Sky Declaration

The WorldDeclaration includes environment settings that control sky, fog, tonemap, and post-processing. These are set globally but can be overridden per-area (e.g., outdoor vs indoor).

### Sky System

Outdoor rooms need a visible sky. Indoor rooms use `Background.KEEP` (no sky rendering — saves performance). The sky uses a custom `shader_type sky` that matches the PSX aesthetic.

```gdscript
class_name SkyDeclaration
extends Resource

@export var enabled: bool = true              # false for indoor rooms
@export var shader_path: String = "res://shaders/psx_sky.gdshader"

# Night sky parameters (uniforms passed to sky shader)
@export var sky_color_top: Color = Color(0.02, 0.02, 0.06)     # Near-black
@export var sky_color_horizon: Color = Color(0.05, 0.04, 0.08)  # Slightly lighter
@export var star_density: float = 0.3         # How many stars (0-1)
@export var star_brightness: float = 0.6      # Star intensity
@export var moon_size: float = 0.02           # Angular size in radians
@export var moon_color: Color = Color(0.7, 0.75, 0.85)
@export var cloud_density: float = 0.4        # Overcast layer (0=clear, 1=solid)
@export var cloud_color: Color = Color(0.08, 0.07, 0.1)
@export var dither_strength: float = 0.3      # PSX Bayer dithering on sky
@export var color_depth: float = 15.0         # PSX color reduction
```

The PSX sky shader (`shaders/psx_sky.gdshader`):
- Procedural stars using hash noise, posterized to PSX color depth
- Moon disc from `LIGHT0_DIRECTION` (DirectionalLight3D)
- Overcast cloud layer using simple noise
- Bayer dithering applied to final color
- Static (no `TIME`) so radiance cubemap renders once — zero per-frame cost
- `AT_CUBEMAP_PASS` renders full sky; background pass reads from RADIANCE

### Environment Declaration

```gdscript
class_name EnvironmentDeclaration
extends Resource

# Background
@export var background_mode: String = "sky"  # "sky", "color", "keep"
@export var background_color: Color = Color(0, 0, 0)  # For "color" mode

# Sky
@export var sky: SkyDeclaration = null

# Fog
@export var fog_enabled: bool = true
@export var fog_density: float = 0.006
@export var fog_color: Color = Color(0.15, 0.12, 0.1)  # Warm dust
@export var volumetric_fog: bool = false      # Performance-heavy, use sparingly

# Tonemap
@export var tonemap_mode: String = "aces"    # "linear", "reinhard", "filmic", "aces"
@export var tonemap_exposure: float = 1.0

# Glow/Bloom
@export var glow_enabled: bool = true
@export var glow_threshold: float = 0.75
@export var glow_intensity: float = 0.2       # Subtle warm glow from light sources

# SSAO
@export var ssao_enabled: bool = true
@export var ssao_radius: float = 1.0
@export var ssao_intensity: float = 0.5

# Ambient light
@export var ambient_source: String = "sky"   # "background", "disabled", "color", "sky"
@export var ambient_color: Color = Color(0.1, 0.08, 0.06)
@export var ambient_energy: float = 0.3

# Vignette (applied by PSX post-process, not Environment)
@export var vignette_color: Color = Color(0.12, 0.1, 0.08)
@export var vignette_weight: float = 0.8
```

### Per-Area Environment Presets

Rather than per-room environments, we define per-AREA presets:

| Area | Background | Sky | Fog | Tonemap | Ambient | Character |
|------|-----------|-----|-----|---------|---------|-----------|
| Grounds (exterior) | sky | PSX night sky with moon + stars | Light fog, cold | ACES, exposure 0.8 | From sky, low energy | Cold moonlit December night |
| Ground Floor | keep | None | Warm dust fog | ACES, exposure 1.0 | Color, warm dim | Faded grandeur |
| Upper Floor | keep | None | Warm dust fog | ACES, exposure 0.9 | Color, dimmer | Private secrets |
| Basement | keep | None | Cold grey fog | ACES, exposure 0.7 | Color, very dim | Industrial menace |
| Deep Basement | keep | None | Dense cold fog | ACES, exposure 0.5 | Disabled | Near darkness |
| Attic | keep | None | Thin dust fog | ACES, exposure 0.6 | Color, cold | Elizabeth's domain |

---

## Addon Integration Map

How each installed addon connects to the declaration system.

### 1. godot-psx (Screen-Space Shaders)

**Not declared per-room.** Applied globally via SubViewportContainer in `main.tscn`.
- `psx_dither.gdshader` → entire game renders through dithering + color depth
- `psx_fade.gdshader` → room transitions (controlled by room_assembler during connection traversal)
- `psx_sky.gdshader` → custom sky shader (NEW, extends the godot-psx aesthetic to sky)

### 2. godot_dialogue_manager

**Declared per-interactable** in `ResponseDecl.text` fields. The interaction_engine:
1. Looks up the interactable's matching response (first condition that matches)
2. Calls `DialogueManager.show_dialogue_balloon(resource, title)` where:
   - `resource` = the `.dialogue` file for the current room (auto-generated from declarations)
   - `title` = the interactable's `id`
3. The `.dialogue` file is GENERATED from the room declaration's interactable responses — NOT hand-written

**Generation rule:** For each InteractableDecl with responses:
```
~ {interactable_id}
if {response[0].condition}
    {response[0].text}
elif {response[1].condition}
    {response[1].text}
else
    {default_response.text}
do {mutations from set_state}
```

Custom balloon scene uses Cinzel (titles) + Cormorant (body) fonts from `assets/fonts/`.

### 3. gloot (Inventory)

**Declared in `ItemDeclaration` resources.** The engine:
1. On startup, reads all `ItemDeclaration` files
2. Creates gloot `ProtoTree` item prototypes from them
3. When either `InteractableDecl` or the chosen `ResponseDecl` grants an item, calls `GameManager.give_item()` which wraps gloot
4. Inventory UI in pause menu reads from gloot `Inventory` node

### 4. AdaptiSound (Layered Audio)

**Declared per-room** in `RoomDeclaration`:
- `ambient_loop` → base layer, always playing
- `tension_loop` → activated when state variable `elizabeth_aware` is true
- `reverb_bus` → which audio bus to route through

**Declared per-area** in `EnvironmentDeclaration`:
- Tension volume scale driven by game phase (from `PhaseDecl`)

**Declared per-event** in `ActionDecl.play_sfx`:
- SFX paths point to organized audio directories
- `sfx/horror/`, `sfx/inventory/`, `sfx/impact/`, `sfx/ambient/`, `sfx/stinger/`, `sfx/music_box/`, `sfx/echoes/`

### 5. godot-material-footsteps

**Declared per-room** in `RoomDeclaration.footstep_surface`:
- Surface type string (marble, wood_parquet, stone, metal_grate, rough_wood, carpet, dirt, grass, gravel)
- The room_assembler tags floor collision with `footstep_surface` metadata
- `MaterialFootstepPlayer3D` on player reads the metadata and plays matching audio from `assets/audio/footsteps/{surface}/`

### 6. phantom-camera

**Declared per-interactable** via `InteractableDecl.type`:
- Interactables with types `painting`, `note`, `photo` that have `wall` set get an inspection PhantomCamera3D placed at the wall position
- The interaction_engine sets inspection camera priority to 20 on interact, 0 on dismiss
- ExplorationCam (priority 10) is always on the player

**Declared per-room** for room reveals:
- Rooms with `on_entry` triggers containing `show_room_name` get a RoomReveal PhantomCamera3D that sweeps on first entry

### 7. shaky-camera-3d

**Declared per-action** in `ActionDecl.camera_shake`:
- Float value = trauma amount (0.0-1.0)
- Applied by trigger_engine when action fires
- Profiles: 0.02 = subtle, 0.1 = discovery, 0.3 = horror moment, 0.5 = ritual

### 8. quest-system

**Declared in `PuzzleDeclaration`:**
- Each puzzle auto-generates a Quest resource
- Quest starts when first step's `required_state` becomes evaluable
- Quest completes when `completion_state` is true
- Quest progress shown in pause menu

### 9. SaveMadeEasy

**Declared in `StateSchema`:**
- All state variables from the schema are serialized on save
- Current room, player position, inventory (via gloot), quest states all saved
- Auto-save on room transitions (triggered by room_assembler connection traversal)
- PRNG seed saved so variation is consistent across save/load

### 10. limboai (HSM)

**Declared in `WorldDeclaration`:**
- `phases` array defines game states
- `phase_transitions` define flag-driven transitions
- The state_machine engine reads these declarations and builds LimboHSM at runtime
- Phase changes drive: AdaptiSound tension volume, room_base flicker intensity, Elizabeth presence

### 11. gdUnit4 (Testing)

**Generated from declarations by test_generator:**
- For each RoomDeclaration: verify interactable IDs exist, connection targets valid, light count, flickering
- For each PuzzleDeclaration: simulate step chain, verify completion state
- For each Connection: verify bidirectional (A→B implies B→A)
- For PRNG: run N seeds, verify all puzzles solvable
- For endings: simulate trigger conditions, verify text sequences

---

## PSX Sky Shader Design

```glsl
shader_type sky;
// PSX-style night sky: posterized stars, dithered moon, overcast clouds
// Static (no TIME) — renders to radiance cubemap ONCE, then cached

uniform vec3 sky_color_top : source_color = vec3(0.02, 0.02, 0.06);
uniform vec3 sky_color_horizon : source_color = vec3(0.05, 0.04, 0.08);
uniform float star_density : hint_range(0.0, 1.0) = 0.3;
uniform float star_brightness : hint_range(0.0, 1.0) = 0.6;
uniform float moon_size : hint_range(0.001, 0.1) = 0.02;
uniform vec3 moon_color : source_color = vec3(0.7, 0.75, 0.85);
uniform float cloud_density : hint_range(0.0, 1.0) = 0.4;
uniform vec3 cloud_color : source_color = vec3(0.08, 0.07, 0.1);
uniform float color_depth : hint_range(2.0, 32.0) = 15.0;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;

// Simple hash for star positions
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 4x4 Bayer dithering
float bayer4(vec2 pos) {
    int x = int(mod(pos.x, 4.0));
    int y = int(mod(pos.y, 4.0));
    int idx = x + y * 4;
    float m[16] = float[16](
        0.0, 8.0, 2.0, 10.0,
        12.0, 4.0, 14.0, 6.0,
        3.0, 11.0, 1.0, 9.0,
        15.0, 7.0, 13.0, 5.0
    );
    return m[idx] / 16.0;
}

void sky() {
    vec3 dir = EYEDIR;

    // Gradient: dark at top, slightly lighter at horizon
    float horizon = smoothstep(-0.1, 0.3, dir.y);
    vec3 sky = mix(sky_color_horizon, sky_color_top, horizon);

    // Stars (only above horizon)
    if (dir.y > 0.0) {
        vec2 star_uv = dir.xz / (dir.y + 0.001) * 50.0;
        float star = hash(floor(star_uv));
        if (star > 1.0 - star_density * 0.05) {
            float twinkle = star_brightness * smoothstep(0.98, 1.0, star);
            sky += vec3(twinkle);
        }
    }

    // Moon disc (from DirectionalLight3D)
    if (LIGHT0_ENABLED) {
        float moon_dist = distance(dir, -LIGHT0_DIRECTION);
        if (moon_dist < moon_size) {
            float moon_edge = smoothstep(moon_size, moon_size * 0.8, moon_dist);
            sky = mix(sky, moon_color * LIGHT0_ENERGY, moon_edge);
        }
    }

    // Overcast cloud layer (simple, no TIME — static)
    if (cloud_density > 0.0 && dir.y > -0.1) {
        vec2 cloud_uv = dir.xz / max(dir.y, 0.01) * 3.0;
        float cloud = hash(floor(cloud_uv * 2.0)) * 0.5 + hash(floor(cloud_uv * 4.0)) * 0.3;
        cloud = smoothstep(1.0 - cloud_density, 1.0, cloud);
        sky = mix(sky, cloud_color, cloud * 0.6);
    }

    // PSX color depth reduction
    sky = floor(sky * color_depth + 0.5) / color_depth;

    // Bayer dithering (use SCREEN_UV to get pixel position)
    float dither = bayer4(SCREEN_UV * vec2(320.0, 240.0)) - 0.5;
    sky += dither_strength * dither / color_depth;
    sky = floor(sky * color_depth + 0.5) / color_depth;

    COLOR = sky;
}
```

This shader:
- Uses NO `TIME` — radiance cubemap renders once and caches
- Gets moon position from `LIGHT0_DIRECTION` (the scene's DirectionalLight3D)
- Applies the SAME Bayer dithering + color depth as `psx_dither.gdshader` — sky matches ground
- Stars are hash-based (deterministic, no animation — PSX games had static star fields)
- Cloud layer is simple hash noise at low frequency — overcast December night feel
- Resolution is implicitly low because the dithering at 320x240 grid posterizes everything
