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
  - play_sfx: "floorboard_creak"
  - show_room_name: "Attic"
  - camera_shake: trauma 0.08, 3s (sustained dread)
  - observation: "A whisper slips down the stairwell after the creak, so close it feels spoken beside your ear. Not words. Recognition."
```

**This is the second most important trigger in the game** (after `found_first_clue`). Everything changes globally:
- Tension audio layer activates in ALL rooms
- Mirrors have slight delay everywhere
- Music box can play on its own
- Elizabeth events become possible
- Horror phase drives AdaptiSound, lighting, atmosphere

### Runtime Note
The current declaration/runtime pass implements the state flip, room-name beat, creak, camera-shake threshold, and the first-entry whisper text beat.
