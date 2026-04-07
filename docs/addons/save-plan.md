# Save Plan — SaveMadeEasy

## Source
- Addon: `AdamKormos/SaveMadeEasy`
- Location: `addons/save_system/`

## Purpose

Replace basic JSON save with encrypted, device-bound save system.

## Save Data Structure

```
save_data/
├── current_room: String
├── player_position: Vector3
├── player_rotation_y: float
├── inventory: Array[String] (item IDs from gloot)
├── flags: Dictionary
├── visited_rooms: Array[String]
├── interacted_objects: Array[String]
├── lights_toggled: Dictionary
├── quest_states: Dictionary (from quest-system)
├── hsm_state: String (current game phase from LimboAI)
└── elizabeth_state: String (current Elizabeth presence state)
```

## Auto-Save Triggers

- Room transition (after load completes)
- Item acquired
- Quest completed
- Manual save from pause menu

## Implementation Steps

1. Replace GameManager.save_game()/load_game() with SaveMadeEasy API
2. Serialize all game state including addon states (gloot inventory, quest progress, HSM state)
3. Add auto-save on room transitions
4. Keep manual save in pause menu
5. Test: save in every room, load from every save point, verify all state restores
