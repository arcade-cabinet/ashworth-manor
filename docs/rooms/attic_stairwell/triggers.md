# Attic Stairwell — Triggers

### First Entry — PHASE TRANSITION
```yaml
event: attic_first_entry
conditions:
  - flag_not_set: entered_attic
actions:
  - set_flag: entered_attic
  - set_flag: elizabeth_aware
  - PHASE TRANSITION: Discovery → Horror (or Exploration → Horror if diary skipped)
  - play_sfx: "stairs_creak_long"
  - ambient_change: "whispers_distant"
  - show_room_name: "Attic"
  - camera_shake: trauma 0.08, 3s (sustained dread)
```

**This is the second most important trigger in the game** (after `found_first_clue`). Everything changes globally:
- Tension audio layer activates in ALL rooms
- Mirrors have slight delay everywhere
- Music box can play on its own
- Elizabeth events become possible
- Horror phase drives AdaptiSound, lighting, atmosphere

### Whisper (One-Time)
```yaml
trigger: 5 seconds after entry
- play_sfx: "whisper_find_me" (barely audible, from above)
```
