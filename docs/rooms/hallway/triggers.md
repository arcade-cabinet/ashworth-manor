# Upper Hallway — Triggers & Events

## Entry Events

### First Entry
```yaml
event: hallway_first_entry
conditions:
  - flag_not_set: visited_upper_hallway
actions:
  - set_flag: visited_upper_hallway
  - show_room_name: "Upper Hallway"
  - play_sfx: "floorboard_creak" (positional, from floor)
  - observation: "The hallway stretches into shadow. Doors line both sides. At the far end — a door unlike the others. Heavy. Iron-banded. Locked."
```

## Conditional Events

### Crying Behind Door (Post-Discovery Phase)
```yaml
event: hallway_crying
conditions:
  - flag_set: elizabeth_aware
  - flag_not_set: hallway_crying_triggered
  - player_in_room: upper_hallway
trigger: Player walks within 3m of attic door (Z > 5)
actions:
  - set_flag: hallway_crying_triggered
  - play_sfx: "child_crying_distant" (positional, from attic door at (0,1.5,7.5), muffled)
  - NO text — the sound speaks for itself
  - camera_shake: trauma 0.03, 2s (barely perceptible)
```

### Sconce Flicker Near Attic (Horror Phase)
```yaml
event: hallway_sconce_agitate
conditions:
  - flag_set: entered_attic
  - player_near: attic_door (Z > 4)
actions:
  - hallway_sconce_north energy oscillates: 1.2 → 0.3 → 1.2 over 2s
  - Repeats while player is near
```

### Attic Door Rattle (Pre-Key)
```yaml
event: attic_door_rattle
conditions:
  - flag_set: knows_attic_locked
  - flag_not_set: has_attic_key
  - flag_not_set: attic_door_rattled
  - player_in_room: upper_hallway
trigger: 30 seconds after entry (if conditions met)
actions:
  - set_flag: attic_door_rattled
  - play_sfx: "door_rattle" (positional, from attic door)
  - observation: "The attic door rattled. Not from the wind — from the other side."
```

## Flashbacks

### Post-`knows_full_truth`: The Children Fleeing
```yaml
event: hallway_children_flashback
conditions:
  - flag_set: knows_full_truth
  - flag_not_set: hallway_flashback_triggered
trigger: 15 seconds after entry
actions:
  - set_flag: hallway_flashback_triggered
  - psx_fade: dither to 70% white, 1s
  - play_sfx: "running_footsteps_multiple" (from south end, moving past player to stairs)
  - observation: "Three sets of running footsteps. Small, panicked, barefoot on wood. The children, fleeing in the night. They didn't stop to dress. They didn't stop to look back. They just ran."
  - psx_fade: return, 1s
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Quiet corridor. Creaking underfoot. Doors closed. |
| Discovery | Faint draft from attic door direction. Sconces less steady. |
| Horror | Crying audible near attic door. Sconces flicker near north end. Mask expression changed. |
| Resolution | Dead still. No draft. No sound. The corridor waits. |
