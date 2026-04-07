# Dialogue Plan — godot_dialogue_manager

## Source
- Addon: `nathanhoad/godot_dialogue_manager`
- Docs: https://dialogue.nathanhoad.net/
- Location: `addons/dialogue_manager/`

## Purpose

NOT traditional NPC dialogue. Used as a **document/observation content system** for:
- Reading diary entries, letters, notes, books
- Examining paintings, mirrors, clocks, objects
- Conditional observations (text changes based on game state)
- Puzzle hints that cascade based on flags
- Ending text sequences

## Why This Over inkgd

| Feature | dialogue_manager | inkgd |
|---------|-----------------|-------|
| Visual editor | Yes (in Godot) | No (text only) |
| Godot 4 release | Official, stable | Branch only, no release |
| Performance | Native GDScript | ~50x slower than C# ink |
| Conditions | `if/elif/else` on GDScript calls | Ink conditional syntax |
| Mutations | Call any GDScript function | External functions |
| Learning curve | Low (simple syntax) | Medium (Ink language) |

For a game that's mostly document-reading with conditional text (not deep branching conversation trees), dialogue_manager is the better fit.

## File Structure

```
dialogue/
├── ground_floor/
│   ├── foyer.dialogue        # All foyer interactable text
│   ├── parlor.dialogue        # All parlor interactable text
│   ├── dining_room.dialogue
│   └── kitchen.dialogue
├── upper_floor/
│   ├── hallway.dialogue
│   ├── master_bedroom.dialogue
│   ├── library.dialogue
│   └── guest_room.dialogue
├── basement/
│   ├── storage.dialogue
│   └── boiler_room.dialogue
├── deep_basement/
│   └── wine_cellar.dialogue
├── attic/
│   ├── stairwell.dialogue
│   ├── attic_storage.dialogue
│   └── hidden_chamber.dialogue
├── grounds/
│   ├── front_gate.dialogue
│   ├── garden.dialogue
│   ├── chapel.dialogue
│   ├── greenhouse.dialogue
│   ├── carriage_house.dialogue
│   └── family_crypt.dialogue
└── endings/
    ├── freedom.dialogue
    ├── escape.dialogue
    └── joined.dialogue
```

## Dialogue File Format (Example)

```
~ foyer_painting
if GameManager.has_flag("knows_full_truth")
    The patriarch stares down. Now you know what those hollow eyes were hiding. His hand still rests on "Rites of Passage" — the book that taught him to imprison his own daughter.
elif GameManager.has_flag("read_ashworth_diary")
    Lord Ashworth. The man who locked his daughter in the attic. His hollow eyes hold a guilt you now understand.
else
    The patriarch stares down with hollow eyes. His hand rests on a book titled "Rites of Passage."

~ foyer_mirror
if GameManager.has_flag("found_hidden_chamber")
    Your reflection stares back. Behind it, for just a moment — a girl in white. When you blink, she's gone.
elif GameManager.has_flag("elizabeth_aware")
    Your reflection stares back. It moved independently. You're sure of it this time.
else
    Your reflection stares back. For a moment, you could swear it moved independently.

~ foyer_clock
    The hands point to 3:33. The pendulum hangs motionless. No ticking breaks the silence.
do GameManager.set_flag("examined_foyer_clock")
```

## Integration with interaction_manager.gd

**Current flow:**
```
Player taps → Area3D metadata → _handle_document() → _show(title, content)
```

**New flow:**
```
Player taps → Area3D metadata/id → DialogueManager.show_dialogue_balloon(resource, title)
```

**Changes needed:**
1. Replace `_show(title, content)` calls with `DialogueManager.show_dialogue_balloon()`
2. Load `.dialogue` resource per room on room_loaded signal
3. Area3D `metadata/id` maps to dialogue title (e.g., `foyer_painting`)
4. Create custom balloon scene styled as aged paper (matching current PAPER_COLOR)

## Custom Balloon Design

The dialogue balloon replaces our current `PanelContainer` document overlay. Styled to match the Victorian aesthetic:
- Background: PAPER_COLOR `#D1C1A6` with aged texture
- Text: PAPER_TEXT `#332619` in serif font
- Title: Centered, larger, separated by decorative line
- Typewriter effect: Text appears character by character
- Dismiss: Tap anywhere to close (same as current behavior)

## Implementation Steps

1. Create `dialogue/` directory structure
2. Write `.dialogue` file for each room with all interactable text
3. Add conditional variants for each interactable based on game state flags
4. Create custom balloon scene matching Victorian paper aesthetic
5. Update `interaction_manager.gd` to use DialogueManager API
6. Remove hardcoded content strings from Area3D metadata
7. Test: every interactable displays correct text at every game state
