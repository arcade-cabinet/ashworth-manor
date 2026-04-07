# Front Gate — Triggers & Events

## Entry Events

### First Entry (New Game)
```yaml
event: front_gate_first_entry
conditions:
  - flag_not_set: visited_front_gate
actions:
  - set_flag: visited_front_gate
  - set_flag: game_started
  - show_room_name: "Ashworth Manor" (not "Front Gate" — the manor IS the name)
```

**Note:** This is the ONLY room where the room name display shows the game title instead of the room name. Sets the tone immediately.

This event now follows the solicitor-letter prologue. `front_gate` is the first embodied threshold, not the first narrative beat.

### First Entry Thread Beat

Before the title/state trigger fires, the room runs one thread-specific opening observation:

| Macro Thread | Opening Beat |
|-------------|--------------|
| `captive` | The gate feels too orderly to be safe, and the drive funnels the player inward without granting ownership of the place. |
| `mourning` | The allée reads as disciplined grief, with the manor waiting like an old family memory left intact too long. |
| `sovereign` | The estate carries itself with the composure of old authority; the player feels received rather than welcomed. |

All three variants trigger a gate creak, and the `captive` / `sovereign` variants add a light camera sway.

### Threshold Acknowledgement
```yaml
event: front_gate_threshold_ack
conditions:
  - flag_set: examined_gate_plaque
  - flag_not_set: front_gate_threshold_acknowledged
actions:
  - set_flag: front_gate_threshold_acknowledged
  - play_sfx: "gate_creak"
  - sign sway / chain creak emphasis
  - subtle camera settle toward the drive
```

This is the player's first commitment to the grounds. It should happen once, immediately after the plaque is read or the estate sign is chosen, without turning the opening into overt supernatural theater.

### Return From Mansion (Ending Checks)
```yaml
event: front_gate_ending_check
conditions:
  - player_coming_from: any interior room
actions:
  - check ending conditions (see connections.md)
```

## Timed Events

### Gate Creak (Ambient)
```yaml
event: gate_creak_ambient
trigger: Every 15-30 seconds (random interval)
conditions:
  - player_in_room: front_gate
actions:
  - play_sfx: "gate_creak" (positional, from gate at Z=-10)
```

### Wind Gust
```yaml
event: wind_gust
trigger: Every 20-40 seconds (random interval)
conditions:
  - player_in_room: front_gate
actions:
  - play_sfx: "wind_gust"
  - brief camera sway (shaky-camera-3d, trauma 0.03, 1.5s)
```

## Conditional Events

### Post-Attic Return
```yaml
event: front_gate_post_attic
conditions:
  - flag_set: elizabeth_aware
  - flag_not_set: front_gate_post_attic_triggered
trigger: Enter front gate from any room
actions:
  - set_flag: front_gate_post_attic_triggered
  - gate_lamp flicker intensifies (energy 2.5 → 4.0 → 2.5 over 3s)
  - play_sfx: "whisper_wind" (mixed into wind ambient)
  - observation: "The gate lamp burns brighter as you approach. As if greeting you. Or warning you."
```

## Flashbacks

### None
Front gate is the player's anchor to the outside world. No flashbacks here — this is the real world. The supernatural belongs inside the house. The gate is where you can still turn back.

The only exception is the **pre-room solicitor letter**, which is not a supernatural flashback. It is the practical document that leads into this threshold.

## Phase-Specific Atmosphere Changes

| Phase | Change |
|-------|--------|
| Exploration | Normal — wind, lamp, quiet, long-distance tension |
| Discovery | Lamp and sign feel more conspicuous, but still grounded |
| Horror | Trees seem closer. Shadows longer. The threshold stops feeling neutral |
| Resolution | Dead calm. No wind. Lamp steady. Eerie stillness |
