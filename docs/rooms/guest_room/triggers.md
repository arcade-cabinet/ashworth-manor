# Guest Room — Triggers & Events

## Entry Events

### First Entry
```yaml
event: guest_first_entry
conditions:
  - flag_not_set: visited_guest_room
actions:
  - set_flag: visited_guest_room
  - show_room_name: "Guest Room"
```

## Flashbacks

### Post-`elizabeth_aware`: Helena's Last Night
```yaml
event: guest_flashback
conditions:
  - flag_set: elizabeth_aware
  - flag_not_set: guest_flashback_triggered
trigger: 15 seconds after entry
actions:
  - set_flag: guest_flashback_triggered
  - psx_fade: dither to 60% white, 1s
  - observation: "She sat on the bed, in the dark, listening. The lamp had gone out hours ago. Footsteps in the hallway — but no one came when she called. The door handle turned on its own. Slowly. Then stopped."
  - psx_fade: return, 1s
  - play_sfx: "door_handle_turn_slow" (positional, from door)
```

No visual model spawn — Helena's flashback is audio + text only. More unsettling without a visible figure.

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Quiet, sparse, lonely |
| Discovery | Wind audible. Slight draft from window |
| Horror | Door handle rattles unprompted. Candle nearly goes out |
| Resolution | Still. The door is open now. Helena can leave — but she already left |
