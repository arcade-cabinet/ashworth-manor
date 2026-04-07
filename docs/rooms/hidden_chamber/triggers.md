# Hidden Chamber — Triggers

### First Entry — Chamber Reveal
```yaml
- set_flag: found_hidden_chamber
- set_flag: visited_hidden_chamber
- show_room_name: "Hidden Chamber"
- show_text: "The house has been hiding this room inside itself for years. It does not feel discovered. It feels admitted."
- play_sfx: "pl_horror_stinger_07_reveal"
- camera_shake: 0.1
- phase pressure: Horror → Resolution threshold
- ambient_change: elizabeth_presence
```

### Elizabeth Mirror Event (on examine hidden_mirror)
```yaml
- show_text via interactable response
- maintain mirror-delay visual effect metadata
- let the reflection itself carry the beat
```

### Counter-Ritual (3 steps at ritual_circle)
See interaction_manager.gd `_handle_ritual()` and puzzles/README.md for full sequence.

Step 3 triggers:
- `freed_elizabeth`
- Light pours from doll
- Drawings fade
- Candles blaze → extinguish
- Silence
- "Thank you."
- 6s delay → Freedom Ending
