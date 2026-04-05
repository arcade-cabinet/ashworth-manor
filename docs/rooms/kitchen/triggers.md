# Kitchen — Triggers & Events

## Entry Events

### First Entry
```yaml
event: kitchen_first_entry
conditions:
  - flag_not_set: visited_kitchen
actions:
  - set_flag: visited_kitchen
  - show_room_name: "Kitchen"
```

## Timed Events

### Dripping Water
```yaml
event: kitchen_drip
trigger: Every 8-15 seconds (random)
conditions:
  - player_in_room: kitchen
actions:
  - play_sfx: "water_drip" (positional, from bucket at (3, 0.2, -3))
```

### Pipe Creak (connects to boiler below)
```yaml
event: kitchen_pipe_creak
trigger: Every 30-60 seconds (random)
conditions:
  - player_in_room: kitchen
actions:
  - play_sfx: "pipe_creak_distant" (positional, from floor/ceiling)
```

## Flashbacks

### None
Like the front gate, the kitchen is grounded in reality. The servants' world is honest — no supernatural overlay. The horror is in the mundane: half-chopped vegetables, a burned pot, a missing knife. Real people abandoned this room in real terror.

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Quiet, cold, dripping water. Utilitarian. |
| Discovery | Pipe sounds more frequent. Faint sound from below (boiler?). |
| Horror | Handprints visible in hearth soot (conditional text). Water in bucket ripples without wind. |
| Resolution | Still. The dripping stops. Even the water is tired. |
