# Library — Triggers & Events

## Entry Events

### First Entry
```yaml
event: library_first_entry
conditions:
  - flag_not_set: visited_library
actions:
  - set_flag: visited_library
  - show_room_name: "Library"
```

## Conditional Events

### Paper Rustling (Ambient)
```yaml
event: library_rustle
trigger: Random, every 20-40 seconds
conditions:
  - player_in_room: library
actions:
  - play_sfx: "paper_rustle" (positional, from bookshelves, very quiet)
```

## Flashbacks

### Post-`has_binding_book`: The Ritual
```yaml
event: library_flashback
conditions:
  - flag_set: has_binding_book
  - flag_not_set: library_flashback_triggered
trigger: 15 seconds after entry
actions:
  - set_flag: library_flashback_triggered
  - psx_fade: dither to 75% white, 1.5s
  - spawn_model: plague_doctor.glb at (0, 0, 0), standing at desk, holding book
  - observation: "The occultist read the words aloud in this room. Lord Ashworth sat where you're standing, listening. 'To trap a spirit, one must first give it form.' The doll was already upstairs. Elizabeth was already screaming."
  - despawn_model: fade 2s
  - psx_fade: return, 1.5s
  - camera_shake: trauma 0.1, 1s
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Quiet. Scholarly. The knowledge here seems benign. |
| Discovery | Paper rustling more frequent. Books seem to shift on shelves. |
| Horror | The binding book GLOWS faintly when player is in the room (emission). Pages rustle aggressively. |
| Resolution | Calm. The book is just a book now. The knowledge is understood. |
