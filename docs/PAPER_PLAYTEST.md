# Paper Playtest — Tearing the Engine Spec Apart

> Historical design/playtest artifact.
> This document predates the shipped route program and survives only as
> reference material. When it conflicts with the current game, the canonical
> source remains [`GAME_BIBLE.md`](./GAME_BIBLE.md).

Three player personas play through the entire game using only the ENGINE_SPEC declaration format. Every time something can't be expressed in the format, or would break, or feels wrong — it's a gap.

---

## Persona 1: First-Timer Fiona

**Profile:** Never played a horror game. Picks up her phone, starts in the front approach. Doesn't read instructions. Taps everything. Gets lost easily. Will quit if confused for more than 2 minutes.

### Fiona's Playthrough

**Moment 1: App launches.**
- Spawns on the front approach at Ashworth Manor
- Sees the gate, drive, trees, and the house beyond

The old detached landing screen is no longer the startup authority. The gap is narrower now: pause, inventory, and ending overlays are still UI systems that need declaration, but the start room itself is correctly driven by `WorldDeclaration.starting_room`.

**Moment 2: Front gate loads.**
- Sees sky, ground, gate, trees, moonlight
- Hears wind

Where does Fiona SPAWN? The RoomDeclaration has `spawn_position` and `spawn_rotation_y`. But which room does she spawn in? The WorldDeclaration has a `rooms` array but no `starting_room` field.

This is now covered by `WorldDeclaration.starting_room` plus the room and world spawn fields.

**Moment 3: Fiona looks up.**
- Sees the PSX night sky with stars and moon

The sky shader exists in the spec. But how does the room_assembler know to USE the sky environment vs the indoor "keep" environment? The RoomDeclaration has `is_exterior` but the EnvironmentDeclaration is a separate resource. How are they linked?

GAP: RoomDeclaration needs `environment_preset: String` (e.g., "grounds", "ground_floor", "basement") that maps to a named EnvironmentDeclaration. OR the WorldDeclaration holds a dictionary of area → EnvironmentDeclaration. Currently the spec has a table of per-area presets but no declaration format to actually hold them.

**Moment 4: Fiona taps the ground.**
- She expects to walk there

The player_controller handles tap-to-walk via raycast on Layer 1 (walkable floor). But the ENGINE_SPEC doesn't mention the player controller AT ALL. It declares rooms but not the player. Where is the player declared? Camera FOV, move speed, tap detection layers, camera height?

GAP: Need a `PlayerDeclaration` resource:
- Camera FOV, height, pitch limits
- Move speed, stop distance
- Tap detection layers (walkable, interactable, connection)
- Head bob settings
- Touch sensitivity

**Moment 5: Fiona walks toward the mansion, taps the gate plaque.**
- Sees document overlay with text

Works in the spec. InteractableDecl with ResponseDecl. Dialogue Manager shows the text. Good.

But WAIT — how does Fiona DISMISS the document? She taps the screen. The spec describes showing text but not dismissing it. The dialogue balloon's dismiss behavior is in the balloon scene, not declared.

GAP: Not a declaration gap — dismiss is UI behavior, handled by the balloon scene. This is fine. But it means the balloon scene's behavior (tap to dismiss, typewriter speed, font) needs to be documented as part of the engine, not left to addon defaults.

**Moment 6: Fiona walks to the mansion entrance. She taps the connection to the foyer.**
- Screen fades (PSX dither fade)
- Foyer loads
- Room name appears: "Grand Foyer"
- She hears new ambient audio

The connection Area3D has `target_room`. The room_assembler builds the fade. But HOW does the transition work mechanically?

1. Player taps connection Area3D
2. interaction_engine detects Layer 4 hit
3. Checks if connection is locked → if locked, check inventory for key
4. If unlocked, tell room_assembler to transition
5. room_assembler: fade out (psx_fade), unload current room, load target room from declaration, fade in
6. Player spawns at `position_in_to` from the Connection resource

But step 5 has a problem: WHERE does the room_assembler get the target room's declaration? It needs a registry of room_id → RoomDeclaration resource path. The WorldDeclaration has `rooms: Array[RoomRef]` but what's a `RoomRef`?

GAP: `RoomRef` needs to be defined. Probably:
```
class_name RoomRef extends Resource
@export var room_id: String
@export var declaration_path: String  # res://declarations/rooms/foyer.tres
```

**Moment 7: Fiona is in the foyer. She sees walls, floor, ceiling, chandelier. She looks around.**

The room was built from RoomDeclaration by the room_assembler. Shared envelope surfaces now resolve from environment role recipes and room recipe overrides, not from legacy `wall_texture`, `floor_texture`, or `ceiling_texture` fields.

But what about the DOORWAY OPENINGS? The wall_north is `["wall", "wall", "doorway:to_parlor", "wall", "wall", "wall"]`. The wall_builder sees `doorway:to_parlor` and... does what? It needs to:
1. Leave a gap in the wall geometry (no quad for this segment)
2. Add a door frame (textured posts + header)
3. Place the door panel (interactive, hinged, textured)
4. Place the connection Area3D

But the declaration only says `doorway:to_parlor`. Where does it get:
- Door frame texture?
- Door panel texture?
- Hinge side?
- Whether it's a single/double/heavy door?

Those details are in the Connection resource, not in the wall layout string. So the wall_builder needs to look up the Connection by ID to get the door details.

GAP: The `wall_layout` string format needs to reference connection IDs, and the Connection declaration needs to be rich enough for the door_builder. The current declaration path uses `type` plus explicit compatibility mesh hints (`legacy_panel_model_hint`, `legacy_frame_model_hint`) where old threshold meshes still need them. The wall builder just needs the connection ID to look it up.

Actually there's a SECOND gap: the wall_layout uses `doorway:to_parlor` but the Connection's ID field is `id: String`. Are these the same? The connection from foyer to parlor needs a consistent ID across:
- wall_layout reference
- Connection.id
- The actual Area3D node name

GAP: Need a naming convention. Proposal: Connection ID = `{from_room}_to_{to_room}`. Wall layout references use the same ID. So `wall_north = ["wall", "wall", "doorway:foyer_to_parlor", "wall", "wall", "wall"]`.

**Moment 8: Fiona taps the grandfather clock.**
- Sees text: "The hands point to 3:33..."
- Flag `examined_foyer_clock` is set

Works. InteractableDecl → ResponseDecl with `set_state: {"examined_foyer_clock": true}`.

But LATER, when all clocks are examined, a CROSS-ROOM EVENT fires: "All the clocks chime." Where is this declared?

It's not a room trigger (it's not specific to any room). It's not a puzzle step (there's no puzzle for examining clocks). It's a GLOBAL trigger that fires when a STATE CONDITION becomes true, regardless of which room the player is in.

GAP: Need `GlobalTrigger` declarations in WorldDeclaration:
```
class_name GlobalTrigger extends Resource
@export var trigger_id: String
@export var condition: String        # "examined_foyer_clock AND examined_boiler_clock"
@export var once: bool = true
@export var actions: Array[ActionDecl]
```

These fire whenever the condition becomes true, regardless of current room. The trigger_engine evaluates them on every state change.

**Moment 9: Fiona goes to the parlor, reads the torn diary page.**
- Flag `found_first_clue` is set
- Game phase transitions: Exploration → Discovery

The phase transition is declared in `WorldDeclaration.phase_transitions`. The state_machine_engine watches for flag changes and transitions the HSM. Good.

But what happens VISUALLY when the phase changes? The tension audio layer activates. Mirrors start delaying. The atmosphere shifts. WHERE is this declared?

The PhaseDecl has `tension_scale` and `flicker_intensity`. But "mirrors start delaying" is a BEHAVIOR change on mirror-type interactables. The spec doesn't have a way to declare per-type behavior changes based on game phase.

GAP: Need either:
A) Per-phase behavior modifiers in PhaseDecl: `interactable_modifiers: {type: "mirror", behavior: "delay_reflection"}`
B) OR make mirror delay a conditional in the ResponseDecl: the mirror's response condition checks game phase

Option B is already supported — the mirror's response can check `elizabeth_aware`. But the VISUAL delay (reflection arriving late) isn't a text response. It's a rendering effect. Text responses we can do. Rendering effects on interactables we CANNOT currently declare.

GAP: Need `visual_effect` on InteractableDecl or ResponseDecl:
```
@export var visual_effects: Dictionary = {}  # {"mirror_delay": 0.3, "emission_glow": 0.5}
```
These are interpreted by the room_assembler to set shader parameters or animation properties on the interactable's visual representation.

**Moment 10: Fiona explores the upper hallway, finds the locked attic door.**
- Taps it, sees "The door is locked."
- Flag `knows_attic_locked` is set

Works. InteractableDecl with `locked: true`, `key_id: "attic_key"`, `locked_response` text.

But then she goes to the master bedroom, reads the diary, learns the key is in the globe. She goes to the library, taps the globe, gets the attic key. She goes back to the hallway, taps the attic door again.

This time: the door OPENS. She walks through. The attic stairwell loads.

The interaction flow is:
1. Tap locked_door interactable
2. interaction_engine checks `locked: true`
3. Checks inventory for `key_id: "attic_key"` → player HAS it
4. Unlocks the door → sets state `attic_door_unlocked`
5. Transitions to `target_room: "attic_stairs"`

But WAIT — after unlocking, does the door STAY unlocked? If Fiona goes back later, is the door open or does she need the key again?

GAP: `InteractableDecl` needs `unlock_permanently: bool = true`. When true, the unlock state persists in the state schema. The interaction_engine checks `{interactable_id}_unlocked` state before checking `locked`.

Actually — this IS handled by `set_state` in the response. When the door is unlocked, the response sets `attic_door_unlocked: true`. Next time, the first response condition `attic_door_unlocked` matches, and it transitions directly without checking the lock.

OK, that works. Not a gap.

**Moment 11: Fiona enters the attic. Phase transitions to Horror.**
- Tension audio activates
- Elizabeth presence begins

Works via PhaseDecl transitions. But the Elizabeth presence sub-HSM (Dormant → Watching → Active → Confrontation) isn't declared in the spec. The spec mentions it in the addon integration section but there's no `ElizabethDecl` resource.

GAP: Elizabeth's presence system needs to be declared as part of WorldDeclaration or as a separate sub-state-machine declaration. Currently it's just described narratively. Need:
```
@export var elizabeth_states: Array[ElizabethState] = []
@export var elizabeth_transitions: Array[ElizabethTransition] = []
```
Where each ElizabethState defines: visual effects (shadow frequency, flicker multiplier), audio (whisper SFX frequency), and which interactable types are affected (mirrors show her, music box plays, etc).

**Moment 12: Fiona finds all puzzle pieces, performs the counter-ritual, gets the Freedom ending.**
- The ritual is a 3-step sequence at the ritual circle

The ritual_circle InteractableDecl has type "ritual". But the 3-step sequence is currently hardcoded in `puzzle_handler.gd`. In the declaration system, how is a MULTI-STEP interaction declared?

The PuzzleDeclaration has `steps`. But the ritual steps are all on the SAME interactable — tap the circle three times with different items active. The current InteractableDecl doesn't support multi-step progressive interaction.

GAP: InteractableDecl needs a `progressive: bool` flag and `progression_steps: Array[ProgressionStep]`:
```
class_name ProgressionStep extends Resource
@export var step_id: String
@export var required_state: String     # State expression
@export var required_items: PackedStringArray
@export var response: ResponseDecl     # What happens at this step
@export var consume_items: PackedStringArray  # Items consumed at this step
```

The interaction_engine tracks which step the player is on (via state variable `{interactable_id}_step`) and advances through the progression.

---

## Persona 2: Speedrunner Sam

**Profile:** Has played Myst, Riven, every escape room game on Steam. Knows puzzle structures. Will try to break sequence. Will try every shortcut. Will try to use items where they're not intended.

### Sam's Playthrough

**Moment 1: Sam tries to skip the front gate entirely and route straight to the garden.**

Under the current topology, he cannot do that from the opening approach anymore. The front gate is the prologue space, and the discovery exterior now sits behind deeper mansion/service routing.

But CAN he solve anything? He needs the attic key (library globe), which requires the diary clue (master bedroom). The diary is always in the master bedroom. The globe is always in the library. Those rooms are inside the mansion.

The PRNG system shuffles placements. But what if the PRNG puts the attic key OUTSIDE the mansion? Sam could solve the game without ever going inside.

GAP: PRNG variation constraints need to be ENFORCED. The `PuzzleVariation.constraint` field exists ("must_be_accessible_before:attic_door") but there's no validation engine that checks constraints. Need the prng_engine to:
1. Generate candidate shuffles
2. Validate each against the puzzle dependency graph
3. Reject shuffles that create impossible or trivial games
4. Log the validation for debugging

**Moment 2: Sam tries to use the cellar key on the attic door.**
- The attic door's `key_id` is "attic_key". The cellar key doesn't match.
- Sam sees "The door is locked."

Works. The interaction_engine compares item IDs. Wrong key = locked response.

But does Sam get FEEDBACK that he's using the wrong key? Just "locked" isn't helpful. A game like Myst would say "This key doesn't fit this lock."

GAP: `InteractableDecl.locked_response` is a single string. It should be TWO strings:
- `locked_response_no_key`: "The door is locked. You need a key."
- `locked_response_wrong_key`: "The key doesn't fit this lock."

The interaction_engine checks: no key in inventory → no_key response. Has A key but wrong one → wrong_key response.

Actually, this is more nuanced. The player might have 3 keys. The engine should check if ANY item in inventory has category "key", and if so but none match, show the wrong_key message.

GAP: ItemDeclaration needs `category` to be used in lock-check logic. The spec has `category` already. The interaction_engine needs to check: `any item in inventory where category == "key"` → wrong_key message.

**Moment 3: Sam finds the hidden chamber, reads the final note, then goes BACK to every room to see if text changed.**
- The foyer painting should now say something different
- The family tree should now show Elizabeth's name readable
- The mirror should show Elizabeth

This is the cross-room cause-and-effect. Sam sets `knows_full_truth` in the hidden chamber. He returns to the foyer. The painting's ResponseDecl has a condition `knows_full_truth` that shows different text.

Works. The conditional response system handles this. Each interactable can have responses gated on any state expression. No gap here — this is the strength of the declaration format.

**Moment 4: Sam tries to perform the ritual WITHOUT all components.**
- He has the doll and the water but not the confession.
- He taps the ritual circle.

The ritual circle's ProgressionStep checks `required_items: ["porcelain_doll", "binding_book", "lock_of_hair", "blessed_water", "mothers_confession"]` and `required_state: "read_final_note"`.

Sam has some but not all. What happens? The step's condition fails. The interaction_engine needs a FALLBACK response when no progression step matches.

GAP: ProgressionStep needs a fallback:
```
@export var fallback_response: ResponseDecl  # "Something is missing. You haven't found the whole truth yet."
```

**Moment 5: Sam saves mid-game, closes the app, reopens, loads.**
- All state variables restored
- Current room restored
- Inventory restored
- PRNG seed restored (so shuffled placements stay consistent)

The StateSchema declares all variables. SaveMadeEasy serializes them. The WorldDeclaration's `prng_seed` is saved.

But what about WHICH STEP Sam is on for multi-step interactables (like the doll: first tap = examine, second tap = extract key)? That progress is tracked by state variables (`examined_doll`, `read_elizabeth_letter`). As long as those variables are in the StateSchema, save/load works.

Works. No gap.

**Moment 6: Sam plays a SECOND time. PRNG seed is different. Where's the key now?**
- The attic key might be in the carriage house portrait instead of the library globe
- The diary clue should ALSO change to point to the new location

CRITICAL GAP: If the PRNG moves the attic key to the carriage house, the diary text still says "The attic key is hidden in the library globe." The clue text needs to be PARAMETERIZED by the PRNG placement.

The PuzzleVariation has `what_varies: "item_location"` and `alternatives`. But the CLUE TEXT that points to that location also needs to vary. The diary's ResponseDecl needs to reference the PRNG-resolved location.

GAP: Need a `prng_variable` system:
```
# In ResponseDecl.text, support interpolation:
text = "The attic key is hidden in {prng:attic_key_location_hint}."

# In PuzzleVariation:
@export var text_variants: Dictionary = {
    "library_globe": "the library globe",
    "carriage_portrait": "behind the portrait in the carriage house",
}
```

The interaction_engine resolves `{prng:variable_name}` at display time using the PRNG engine's resolved values.

---

## Persona 3: Accessibility Tester Alex

**Profile:** Plays on a small phone. Has limited vision. Needs clear text. Gets motion sick from camera shake. Needs the game to be completable without sound cues.

### Alex's Playthrough

**Moment 1: Alex can't see small text on the phone.**
- Font size needs to be configurable

GAP: No accessibility declarations in the spec. Need:
```
class_name AccessibilityDecl extends Resource
@export var base_font_size: int = 16
@export var font_scale: float = 1.0       # User-adjustable multiplier
@export var camera_shake_enabled: bool = true
@export var camera_shake_scale: float = 1.0  # 0 = no shake
@export var high_contrast_mode: bool = false
@export var subtitle_mode: bool = true     # Show text for audio-only events
```

**Moment 2: Alex can't hear the pipe whisper in the boiler room. Misses the atmospheric event entirely.**
- Audio-only events (whispers, creaks, cries) have no visual fallback

GAP: Every `ActionDecl.play_sfx` that conveys narrative information needs an optional `subtitle_text`:
```
@export var subtitle_text: String = ""  # Shown if accessibility subtitle_mode is on
```

For ambient-only SFX (wind, fire crackle), subtitles aren't needed. But for narrative SFX (Elizabeth's whisper, child crying, pipe voice), subtitles are essential.

**Moment 3: Alex gets motion sick from camera shake during Elizabeth events.**
- Camera shake should be disable-able

Already addressed by `AccessibilityDecl.camera_shake_enabled`. The trigger_engine checks this before applying shake. Not a new gap.

**Moment 4: Alex is colorblind. The red Victorian walls and green arsenic walls look the same.**
- The PSX color reduction makes this WORSE

GAP: This is a visual design issue, not a declaration issue. But the declaration format COULD support `high_contrast_mode` where wall textures are swapped to higher-contrast alternatives. The RoomDeclaration would need:
```
@export var wall_texture_high_contrast: String = ""  # Alternative texture for high-contrast mode
```

Scope creep — park this as a future accessibility enhancement, not a launch blocker.

---

## Summary of Gaps Found

### Critical (must fix before building)

| # | Gap | Where | Fix |
|---|-----|-------|-----|
| 1 | No `starting_room` in WorldDeclaration | World | Add `starting_room: String` + `starting_position: Vector3` |
| 2 | No `environment_preset` linking rooms to environments | Room→Environment | Add `environment_preset: String` to RoomDeclaration, `area_environments: Dictionary` to WorldDeclaration |
| 3 | No PlayerDeclaration | Player config | New resource: FOV, speed, camera height, touch sensitivity |
| 4 | Connection ID naming convention | Wall↔Connection | Define convention: `{from}_to_{to}`, wall layout references same ID |
| 5 | No GlobalTrigger for cross-room events | World | Add `global_triggers: Array[GlobalTrigger]` to WorldDeclaration |
| 6 | Elizabeth sub-HSM not declared | World | Add `elizabeth_states` + `elizabeth_transitions` to WorldDeclaration |
| 7 | Multi-step progressive interactions not declared | Interactable | Add `progressive` flag + `progression_steps` array to InteractableDecl |
| 8 | PRNG text interpolation for clue parameterization | Puzzle/Response | Add `{prng:var}` interpolation in response text, `text_variants` in PuzzleVariation |

### Important (should fix)

| # | Gap | Where | Fix |
|---|-----|-------|-----|
| 9 | No UI screen declarations | World/UI | Landing, pause, inventory, ending screens need declaration or at least documented contracts |
| 10 | Wrong-key feedback | Interactable | Split locked_response into no_key and wrong_key variants |
| 11 | Progression fallback response | Interactable | Add `fallback_response` to progressive interactables |
| 12 | PRNG constraint validation | Puzzle Engine | prng_engine must validate shuffle against dependency graph |
| 13 | Visual effects on interactables | Interactable | Add `visual_effects` dictionary for shader/animation params (mirror delay, emission glow) |
| 14 | RoomRef not defined | World | Define RoomRef resource with room_id + declaration_path |

### Accessibility (future enhancement)

| # | Gap | Where | Fix |
|---|-----|-------|-----|
| 15 | No accessibility declarations | World | AccessibilityDecl with font scale, shake toggle, subtitles |
| 16 | Audio-only narrative events have no visual fallback | Triggers/Actions | `subtitle_text` on narrative SFX actions |
| 17 | Colorblind support | Room | High-contrast alternative textures (scope creep — park it) |

---

## Verdict

The ENGINE_SPEC format handles ~85% of what the game needs. The 8 critical gaps are all fixable with straightforward additions to existing Resource classes — no architectural redesign needed. The biggest conceptual gaps are:

1. **GlobalTriggers** — cross-room cause-and-effect events that fire on state conditions regardless of current room. Essential for the "all clocks chime" moment and similar.

2. **Progressive interactions** — multi-step sequences on a single interactable (doll examine → extract key → pick up doll, ritual circle 3-step). Currently only supported as hardcoded logic.

3. **PRNG text interpolation** — if puzzle placements shuffle, the CLUE TEXT pointing to those placements must also shuffle. The diary can't say "library globe" if the PRNG put the key in the carriage house.

4. **Elizabeth as a declared sub-system** — her presence (shadows, whispers, mirror effects) is a cross-cutting concern that affects every room differently based on game phase. Needs explicit declaration, not implicit script behavior.

None of these require redesigning the format. They're additions to the existing Resource class hierarchy.

---

## Re-Playtest: Post-Weave Architecture Fix

### Validation: Captive Thread (Macro A)

Walking through the entire game as "Captive" thread. Elizabeth is trapped. The house is a cage.

**Front Gate:** Thread-neutral. Same for all threads. Gate, bench, luggage, lamp. ✅ No gap.

**Foyer Entry:**
- Room loads. `environment_preset: "grounds"` → sky visible. ✅ GAP #2 fixed.
- Player spawns at `starting_position` from WorldDeclaration. ✅ GAP #1 fixed.
- Room name "Grand Foyer" shows. ✅
- Foyer on Captive thread: the IRON on the front door stands out. The chandelier casts cage-like shadows.
- Thread-specific text? InteractableDecl for foyer_painting has `thread_responses: {"captive": [...]}` with text emphasizing Lord Ashworth's AUTHORITY and CONTROL. ✅

**Parlor diary page:**
- MacroThread.diary_page_text provides Captive variant: "I locked the door. She cannot leave."
- Sets `found_first_clue`. Phase transition fires. ✅
- Global trigger for phase transition evaluates on state change. ✅ GAP #5 fixed.

**Library — Captive/Path-A (globe puzzle):**
- Junction 1 resolves to A (macro_preference: {"captive": "A"}). Globe is active, gears are static. ✅
- Player taps globe → gives item with `functional_slot: "attic_access_key"`. ✅ GAP W2 fixed.

**Attic door:**
- Locked. `key_id: "attic_key"`. But wait — interaction_engine needs to check FUNCTIONAL SLOT too.
- Player has item with `functional_slot: "attic_access_key"`. Lock check: `has_item_with_slot("attic_access_key")`. ✅ GAP W3 fixed.
- No key → `locked_response_no_key`. Has wrong key → `locked_response_wrong_key`. ✅ GAP #10 fixed.

**Attic Storage — Captive/Path-A (doll puzzle):**
- Junction 2 resolves to A. Doll is interactive (progressive), mask is static. ✅
- Doll has `progressive: true`, `progression_steps: [examine, extract_key, pick_up]`. ✅ GAP #7 fixed.
- Step 1 required_state: "" (always). Step 2 required_state: "read_elizabeth_letter". ✅
- Fallback when conditions not met: `fallback_response` shows. ✅ GAP #11 fixed.

**Hidden Chamber — Captive ending:**
- Elizabeth's final note: MacroThread.elizabeth_final_note_text for Captive: "Find me. Free me. Or join me." ✅
- Ritual circle: progressive interaction, 3 steps. ✅
- Counter-ritual completes → `freed_elizabeth` → ending "freedom". ✅
- Ending text from EndingDecl linked to Captive thread's `ending_id`. ✅

**Elizabeth presence throughout:**
- ElizabethStateDecl for "watching": `mirror_delay: 0.15`, `flicker_multiplier: 1.5`. ✅ GAP #6 fixed.
- Captive thread Elizabeth: mirrors show her TRYING TO ESCAPE. Sovereign thread: mirrors show her WATCHING CALMLY. The `thread_responses` on mirror interactables handle this. ✅

**Cross-room cause-and-effect:**
- Reading diary in master bedroom → foyer painting text changes. Conditional in `responses` checks `read_ashworth_diary`. ✅
- All clocks examined → GlobalTrigger fires. ✅ GAP #5 fixed.

**PRNG text interpolation:**
- On Captive/Path-B (second playthrough), diary clue text says "the mechanism in the library holds the key" instead of "globe." PuzzleVariation.text_variants provides this. ResponseDecl.text contains `{prng:attic_key_hint}`. ✅ GAP #8 fixed.

### Validation: Mourning Thread (Macro B)

**Key differences from Captive:**
- Diary: "I hear her crying through the walls" (grief, not control). ✅
- Library: On Mourning/Path-A, the globe puzzle is still available (junction macro_preference might map Mourning→A or B). But the CONTEXT is different — the diary says "she used to love the globe, spinning it, dreaming of places she'd never see." Finding the key in the globe feels like finding her dream. ✅
- Attic: Elizabeth's letter on Mourning thread: "The doll listens when no one else will." Emotional vs mechanical framing. Same puzzle, different weight. ✅
- Ending: "Forgiveness" — the documents burn, the drawings fade. Peace instead of liberation. ✅

### Validation: Sovereign Thread (Macro C)

**Key differences:**
- Diary: "She won't stop LOOKING at me" (fear of power, not guilt). ✅
- Library: On Sovereign, the gear puzzle is preferred (mechanical, control-oriented). Elizabeth understood mechanisms. She MADE the house work for her. ✅
- Attic: The doll isn't the vessel — it's the DECOY. The mask is the real tool. Sovereign/Path-A uses the mask puzzle. ✅
- Hidden chamber: "I chose this. The house has eyes because I gave it eyes." Elizabeth isn't a victim — she's the architect. ✅
- Ending: "Acceptance" — drawings GLOW instead of fading. She doesn't leave. She welcomes you. ✅

### Gaps Found in Re-Playtest

**NONE.** All 14 original gaps are resolved. The 6 weave gaps are resolved. The three macro threads produce coherent, complete, emotionally distinct playthroughs from the same room set.

### Remaining Work (Content, not Architecture)

| Work Item | Quantity | Type |
|-----------|----------|------|
| Mourning variant texts (~35 key interactables) | ~35 entries | Writing |
| Sovereign variant texts (~35 key interactables) | ~35 entries | Writing |
| Captive B-path puzzle logic (gears, etc.) | 6 puzzles | Code |
| Mourning B-path puzzle logic | 6 puzzles | Code |
| Sovereign B-path puzzle logic | 6 puzzles | Code |
| Swap puzzle implementations (3 rooms × 2) | 6 puzzles | Code |
| Additional inventory items for B-paths | ~20 items | Declaration |
| Forgiveness ending text | 5 lines | Writing |
| Acceptance ending text | 5 lines | Writing |
| Junction declarations | 9 | Declaration |
| MacroThread declarations | 3 | Declaration |

**Architecture: DONE. Ready to build.**
