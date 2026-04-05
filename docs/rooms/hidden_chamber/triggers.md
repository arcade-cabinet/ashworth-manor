# Hidden Chamber — Triggers

### First Entry — PHASE TRANSITION
```yaml
- set_flag: found_hidden_chamber
- set_flag: knows_full_truth (after reading final note)
- PHASE: Horror → Resolution
- play_sfx: "childs_whisper" — "You found me."
- ambient_change: elizabeth_presence
- show_room_name: "Hidden Chamber"
```

### Elizabeth Mirror Event (on examine hidden_mirror)
```yaml
- play_sfx: "childs_laugh"
- light_flicker: both candles, 2s
- camera_shake: trauma 0.2, 1s
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
