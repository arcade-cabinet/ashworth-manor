# Master Bedroom — Triggers & Events

## Entry Events

### First Entry
```yaml
event: master_first_entry
conditions:
  - flag_not_set: visited_master_bedroom
actions:
  - set_flag: visited_master_bedroom
  - show_room_name: "Master Bedroom"
```

## Conditional Events

### Sobbing From Above (After Attic Discovery)
```yaml
event: bedroom_sobbing
conditions:
  - flag_set: elizabeth_aware
  - flag_not_set: bedroom_sobbing_triggered
  - player_in_room: master_bedroom
trigger: 20 seconds after entry
actions:
  - set_flag: bedroom_sobbing_triggered
  - play_sfx: "child_sobbing_muffled" (positional, from ceiling — attic is directly above)
  - camera_shake: trauma 0.02, 3s
  # No text. The diary already told the player: "I hear her sobbing through the walls."
  # Now the player hears it too.
```

## Flashbacks

### Post-`read_elizabeth_letter`: Lord Ashworth and the Occultist
```yaml
event: bedroom_flashback
conditions:
  - flag_set: read_elizabeth_letter
  - flag_not_set: bedroom_flashback_triggered
trigger: 15 seconds after entry
actions:
  - set_flag: bedroom_flashback_triggered
  - psx_fade: dither to 70% white, 1.5s
  - spawn_model: plague_doctor.glb at (-2, 0, 0), standing behind bed
  - observation: "The occultist promised it would stop. That the binding would make her quiet. Lord Ashworth sat on this bed, head in hands, while a man in a mask performed rituals on his daughter one floor above. It didn't stop. It never stopped."
  - despawn_model: fade 2s
  - psx_fade: return, 1.5s
  - camera_shake: trauma 0.12, 1s
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Quiet, intimate. Just a bedroom. Candles flicker gently. |
| Discovery | Wind seems louder through the window. Occasional settling from above. |
| Horror | Sobbing audible from ceiling. Candles gutter frequently. Mirror delay noticeable. |
| Resolution | Sobbing has stopped. The room feels lighter. Forgiveness pending. |
