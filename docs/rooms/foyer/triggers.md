# Grand Foyer — Triggers & Events

## Entry Events

### First Entry
```yaml
event: foyer_first_entry
conditions:
  - flag_not_set: visited_foyer
actions:
  - set_flag: visited_foyer
  - set_flag: foyer_threshold_crossed
  - set_flag: game_started
  - show_room_name: "Grand Foyer" (3s duration)
  - play_ambient: room ambient loop
  - play_sfx: "distant_settling" (positional, from ceiling)
  - light_flicker: foyer_chandelier, energy 4.0→4.8 over 1.4s
  - brief camera sway (shaky-camera-3d, trauma 0.025)
  - observation: "The front door settles somewhere behind you with the soft finality of a verdict. The chandelier brightens overhead. The hall feels less entered than resumed."
```

The room dressing should reinforce that beat:
- the central runner axis pulls the eye toward the staircase and parlor
- paired south-side consoles and lamps keep the entry wall readable without making it safe
- the kitchen and dining exits stay available, but they should not visually compete with the stair/parlor line on first entry

## Conditional Events

### All Clocks Chime
```yaml
event: all_clocks_chime
conditions:
  - flag_set: examined_foyer_clock
  - flag_set: examined_boiler_clock
  # Future: other clock flags from other rooms
  - flag_not_set: all_clocks_chimed
actions:
  - set_flag: all_clocks_chimed
  - play_sfx: "distant_chime" (non-positional, from everywhere)
  - observation: "All the clocks in the house chime once. 3:33. Impossible."
```

### Post-Attic Mirror Event
```yaml
event: foyer_mirror_elizabeth
conditions:
  - flag_set: found_hidden_chamber
  - player_examines: foyer_mirror
  - flag_not_set: foyer_mirror_elizabeth_triggered
actions:
  - set_flag: foyer_mirror_elizabeth_triggered
  - camera_shake: trauma 0.15, duration 0.5s
  - light_flicker: foyer_chandelier, energy 4.0→1.0→4.0, 2s
  - play_sfx: "childs_giggle" (faint, from mirror position)
```

### Chandelier Crystal Tinkle
```yaml
event: chandelier_ambient
trigger: Random, every 30-60 seconds
conditions:
  - player_in_room: foyer
  - light_on: foyer_chandelier
actions:
  - play_sfx: "crystal_tinkle" (positional, from chandelier at (0,4.5,0), very quiet)
```

## Flashbacks

### None in default game state

Childhood-memory flashes belong here eventually, but they should remain quieter and more fragmentary than the Victorian apparitions. The first foyer crossing should not immediately spend that card.

### Post-`knows_full_truth` return:
```yaml
event: foyer_family_flashback
conditions:
  - flag_set: knows_full_truth
  - flag_not_set: foyer_flashback_triggered
  - player_in_room: foyer
trigger: 10 seconds after entry
actions:
  - set_flag: foyer_flashback_triggered
  - psx_fade: dither to 80% white, 1.5s
  - spawn_model: bloodwraith.glb at (0, 0, 0), semi-transparent, child-sized scale
  - observation: "For a moment, you see her. Standing in the center of the foyer. Looking up at the chandelier. She's smiling. She remembers when this was home."
  - despawn_model: bloodwraith.glb, fade 2s
  - psx_fade: return to normal, 1.5s
  - camera_shake: trauma 0.1, 1s
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Normal — warm chandelier, quiet settling sounds |
| Discovery | Sconces flicker more prominently. Occasional creak from above. |
| Horror | Mirror delay visible without examining. Chandelier sways faintly. Cold draft. |
| Resolution | Calm. Chandelier steady. The house feels... tired. Resigned. |
