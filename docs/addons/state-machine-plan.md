# State Machine Plan — LimboAI HSM

## Source
- Addon: `limbonaut/limboai`
- GitHub: https://github.com/limbonaut/limboai
- Install: GDExtension (no custom engine build)
- Requires: Godot 4.6+
- Status: **TO INSTALL**

## Purpose

Hierarchical State Machine (HSM) for managing game-wide state that drives atmosphere, audio, and Elizabeth's presence system. NOT used for AI/NPCs — purely for game phase and event logic.

## State Hierarchy

```
GameHSM (LimboHSM)
│
├── Phase_Exploration (LimboState)
│   │   Entry: Player starts at front gate
│   │   Audio: Base ambient only
│   │   Elizabeth: Absent
│   │
│   ├── Transition → Phase_Discovery
│   │   When: flag "found_first_clue" set (parlor diary page)
│   │
│   └── Transition → Phase_Horror (skip Discovery)
│       When: flag "entered_attic" set
│
├── Phase_Discovery (LimboState)
│   │   Entry: Player found first clue about Elizabeth
│   │   Audio: Base + subtle tension layer
│   │   Elizabeth: Aware (mirrors, music box react)
│   │
│   └── Transition → Phase_Horror
│       When: flag "entered_attic" set
│
├── Phase_Horror (LimboState)
│   │   Entry: Player entered the attic
│   │   Audio: Tension layer prominent, stingers active
│   │   Elizabeth: Active (appears in mirrors, whispers, lights flicker)
│   │
│   └── Transition → Phase_Resolution
│       When: flag "knows_full_truth" set (read final note)
│
└── Phase_Resolution (LimboState)
        Entry: Player knows the full truth
        Audio: Tension + resolution layer (somber, quiet)
        Elizabeth: Waiting (no more scares, she wants to be freed)
        
        ├── Transition → Ending_Freedom
        │   When: flag "freed_elizabeth" set
        │
        ├── Transition → Ending_Escape
        │   When: player exits to front_gate with knows_full_truth but not freed
        │
        └── Transition → Ending_Joined
            When: player exits to front_gate with elizabeth_aware but not knows_full_truth
```

## Elizabeth Presence Sub-HSM

Nested inside the game phase HSM:

```
ElizabethHSM (LimboHSM, nested in Phase_Horror and Phase_Resolution)
│
├── Elizabeth_Dormant
│   No effects. Player hasn't triggered awareness yet.
│   Transition → Elizabeth_Watching: flag "elizabeth_aware"
│
├── Elizabeth_Watching  
│   Mirrors delay slightly. Occasional peripheral shadow.
│   Music box plays in parlor. Paintings feel watched.
│   Transition → Elizabeth_Active: player in attic rooms
│
├── Elizabeth_Active
│   Lights flicker. Whispers audible. Mirror shows her briefly.
│   Transition → Elizabeth_Confrontation: flag "found_hidden_chamber"
│
└── Elizabeth_Confrontation
    Direct encounters. "You found me." text.
    Transition → Elizabeth_Freed: flag "freed_elizabeth"
```

## Integration Points

| System | HSM Drives |
|--------|-----------|
| AdaptiSound | Layer activation (base, tension, stinger volume) based on phase |
| Room lighting | Flicker intensity increases in Horror phase |
| Dialogue Manager | Conditional text branches check phase state |
| Phantom Camera | Elizabeth-related camera events in Horror phase |
| ShakyCamera3D | Shake intensity increases in Horror/Resolution |

## How Flags Map to Transitions

```gdscript
# In game_manager.gd, after set_flag():
func set_flag(flag_name: String) -> void:
    if not flags.get(flag_name, false):
        flags[flag_name] = true
        flag_set.emit(flag_name)
        # Dispatch to HSM
        if _game_hsm:
            _game_hsm.dispatch(flag_name)
```

HSM transitions listen for these flag events:
- `found_first_clue` → Exploration → Discovery
- `entered_attic` → any → Horror
- `elizabeth_aware` → Elizabeth_Dormant → Elizabeth_Watching
- `found_hidden_chamber` → Elizabeth_Active → Elizabeth_Confrontation
- `knows_full_truth` → Horror → Resolution
- `freed_elizabeth` → Resolution → Ending_Freedom

## Implementation Steps

1. Add to `plug.gd`: `plug("limbonaut/limboai")`
2. Run gd-plug install
3. Create `scripts/game_state_machine.gd` extending LimboHSM
4. Define states: Exploration, Discovery, Horror, Resolution
5. Define Elizabeth sub-HSM: Dormant, Watching, Active, Confrontation
6. Connect GameManager.flag_set signal to HSM dispatch
7. Connect HSM state changes to AdaptiSound layer controls
8. Connect HSM state changes to room lighting parameters
9. Test: play through entire game, verify phase transitions at correct moments
