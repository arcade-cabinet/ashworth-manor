# Parlor — Triggers & Events

## Entry Events

### First Entry
```yaml
event: parlor_first_entry
conditions:
  - flag_not_set: visited_parlor
actions:
  - set_flag: visited_parlor
  - show_room_name: "Parlor"
  - play_sfx: "fire_crackle_low" (positional, from fireplace)
```

## Critical Event: Phase Transition

### Reading the Diary Page
```yaml
event: read_diary_trigger_discovery
trigger: Player reads parlor_note (sets found_first_clue)
actions:
  - LimboAI HSM dispatches "found_first_clue"
  - Phase transition: Exploration → Discovery
  - AdaptiSound: activate tension audio layer (subtle, building)
  - All mirrors in game now have slight delay
  - Observation: "Someone was locked in the attic. Someone who called out to the children..."
```

This is **the most important trigger in the first half of the game.** Everything changes after this.

## Conditional Events

### Music Box Plays On Its Own
```yaml
event: music_box_auto_play
conditions:
  - flag_set: elizabeth_aware
  - flag_set: reached_attic_storage
  - flag_not_set: music_box_auto_triggered
  - player_in_room: parlor
trigger: 15 seconds after entry (if conditions met)
actions:
  - set_flag: music_box_auto_triggered
  - play_sfx: "music_box_melody" (positional, from music box at (-2, 0.8, -3))
  - light_change: parlor_fireplace energy 1.5 → 0.5 over 3s
  - delay: 5s (melody plays)
  - light_change: parlor_fireplace energy 0.5 → 1.5 over 3s
  - camera_shake: trauma 0.05, 2s (barely perceptible tremor)
```

### Fire Rekindling
```yaml
event: fire_rekindle
conditions:
  - flag_set: elizabeth_aware
  - player_examines: parlor_fireplace
  - flag_not_set: fire_rekindled
actions:
  - set_flag: fire_rekindled
  - light_change: parlor_fireplace energy 1.5 → 3.0, 1s
  - play_sfx: "fire_whoosh" 
  - delay: 3s
  - light_change: parlor_fireplace energy 3.0 → 1.5, 2s
  - No observation text — the fire speaks for itself
```

## Flashbacks

### Post-`elizabeth_aware` re-entry
```yaml
event: parlor_elizabeth_flashback
conditions:
  - flag_set: elizabeth_aware
  - flag_not_set: parlor_flashback_triggered
  - player_in_room: parlor
trigger: 20 seconds after entry
actions:
  - set_flag: parlor_flashback_triggered
  - psx_fade: dither to 70% white, 1s
  - spawn_model: bloodwraith.glb at (0, 0, -1), child-scale, semi-transparent, seated position
  - observation: "She used to sit here. Before they took her upstairs. She would watch the fire and talk to the ballerina in the music box. She was nine years old."
  - despawn_model: fade 2s
  - psx_fade: return to normal, 1s
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Warm, intimate, fire crackling. False comfort. |
| Discovery | Fire seems lower. Shadows deeper in corners. Faint whistling (wind through walls?). |
| Horror | Music box hums faintly even when not examined. Candles gutter. Fireplace embers pulse like heartbeat. |
| Resolution | Fire nearly out. Room feels cold. The green walls are just walls now. The pretense is over. |
