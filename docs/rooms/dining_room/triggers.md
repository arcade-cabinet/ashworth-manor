# Dining Room — Triggers & Events

## Entry Events

### First Entry
```yaml
event: dining_first_entry
conditions:
  - flag_not_set: visited_dining_room
actions:
  - set_flag: visited_dining_room
  - show_room_name: "Dining Room"
```

## Timed Events

### Silverware Clink (Ambient)
```yaml
event: silverware_clink
trigger: Random, every 40-80 seconds
conditions:
  - player_in_room: dining_room
actions:
  - play_sfx: "silverware_clink" (positional, from table center, very quiet)
  # So faint the player isn't sure they heard it. Was that cutlery? Or imagination?
```

## Flashbacks

### Dinner Party Vision (Post-`knows_full_truth`)
```yaml
event: dining_flashback
conditions:
  - flag_set: knows_full_truth
  - flag_not_set: dining_flashback_triggered
  - player_in_room: dining_room
trigger: 15 seconds after entry
actions:
  - set_flag: dining_flashback_triggered
  - psx_fade: dither to 80% white, 1.5s
  - all lights surge to 2x energy for 3s
  - observation: "For a moment, you see them. All eight, seated. Candlelight on silver. Lord Ashworth raising a glass. 'To family.' The guests drink. Lady Ashworth does not. She is watching the doorway."
  - observation: "Then they're gone. The table is empty again. But the wine glass — the one you examined — it's wet."
  - psx_fade: return to normal, 1.5s
  - camera_shake: trauma 0.15, 1s
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Warm chandelier, still table. Museum-like formality. |
| Discovery | Candle flames seem to lean — toward the pushed chair. |
| Horror | Ambient silverware sounds more frequent. Chandelier sways faintly. Shadow of a figure in the chair? |
| Resolution | Dead calm. Candles barely lit. The table is just a table now. The dead are gone. |
